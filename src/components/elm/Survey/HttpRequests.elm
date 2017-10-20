module Survey.HttpRequests exposing (createPatientSurvey, submissionError)

import Survey.Model exposing (Model)
import Survey.Data.Question as Question
import Survey.Data.Patient as Patient
import Json.Decode as Decode
import Json.Encode as Encode
import Http
import Task exposing (Task, andThen)


{-|
    We are making a number of Http requests in this application. In order to
    achieve this, we are following a similar pattern for each request: we first
    define a Request (http://package.elm-lang.org/packages/elm-lang/http/1.0.0/Http#Request)
    then convert that Request into a Task via the `Http.toTask` function.

    As the docs say:
        > "This is only really useful if you want to chain together a
        bunch of requests (or any other tasks) in a single command."

    Since we are making 4 sequential requests in the current flow, using Tasks
    gives us flexibility and allows us to chain requests together. If any
    of the requests fails, the entire chain fails and we handle the error.
-}
type alias Uid =
    String


type alias Uids =
    { patientUid : Uid
    , surveyUid : Uid
    , rxRequestUid : Uid
    }


uid : Decode.Decoder Uid
uid =
    Decode.field "uid" Decode.string


patientInfo : Model -> Encode.Value
patientInfo model =
    Patient.info model.patientDetails


surveyInfo : Model -> Encode.Value
surveyInfo model =
    List.reverse model.previous
        ++ [ model.current ]
        |> Question.encodeSurvey



-- Task which will POST to /patient and grab the "uid" field from the response


patientTask : Model -> Task Http.Error Uid
patientTask model =
    Http.toTask <|
        Http.post
            (model.api ++ "/patient")
            (Http.jsonBody <| patientInfo model)
            uid



-- Task which will POST to /patient_entry and grab the "uid" field from the response


surveyTask : Model -> Task Http.Error Uid
surveyTask model =
    Http.toTask <|
        Http.post
            (model.api ++ "/patient_entry")
            (Http.jsonBody <| surveyInfo model)
            uid


{-|
    Combines the above two Tasks, executing them sequentially.

    We return an object on success:
    { patientId : Uid, surveyUid : Uid }
-}
patientAndSurveyTask : Model -> Task Http.Error { patientUid : Uid, surveyUid : Uid }
patientAndSurveyTask model =
    Task.map2
        (\puid suid ->
            { patientUid = puid, surveyUid = suid }
        )
        (patientTask model)
        (surveyTask model)


{-|
    Task which will receive the above object upon success

    POST to /patient/<patientUid>/prescription_request
    and grab the "uid" field from the response

    We return a `Uids` type (defined above) on success
-}
rxRequestTask : Model -> { patientUid : Uid, surveyUid : Uid } -> Task Http.Error Uids
rxRequestTask model { patientUid, surveyUid } =
    let
        payload =
            Encode.object
                [ ( "blob"
                  , Encode.object
                        [ ( "source", Encode.string "kiosk" )
                        , ( "patient_entry_uids", Encode.list [ Encode.string surveyUid ] )
                        ]
                  )
                ]
    in
        Http.toTask <|
            Http.post
                (model.api ++ "/patient/" ++ patientUid ++ "/prescription_request")
                (Http.jsonBody <| payload)
                (Decode.map3 Uids
                    (Decode.succeed patientUid)
                    (Decode.succeed surveyUid)
                    uid
                )


{-|
    Task that receives the above object upon success

    PATCH /patient/<patientUid>/patient_entry/<surveyUid>

    We ignore the response from this request as this is the last in our chain,
    which is what the "unit type" or `()` stands for
-}
patchPatientAndSurveyTask : Model -> Uids -> Task Http.Error ()
patchPatientAndSurveyTask model { patientUid, surveyUid, rxRequestUid } =
    let
        payload =
            Encode.object
                [ ( "prescription_request_uid", Encode.string rxRequestUid ) ]
    in
        Http.toTask <|
            Http.request
                { method = "PATCH"
                , headers = []
                , url = model.api ++ "/patient/" ++ patientUid ++ "/patient_entry/" ++ surveyUid
                , body = Http.jsonBody <| payload
                , expect = Http.expectStringResponse (\_ -> Ok ())
                , timeout = Nothing
                , withCredentials = False
                }



-- Chain all the above Tasks together


createPatientSurvey : Model -> (Result Http.Error () -> msg) -> Cmd msg
createPatientSurvey model msg =
    Task.attempt msg
        (patientAndSurveyTask model
            |> andThen (rxRequestTask model)
            |> andThen (patchPatientAndSurveyTask model)
        )


submissionError : Http.Error -> String
submissionError error =
    case error of
        Http.BadUrl str ->
            str ++ " looks like a bad url :("

        Http.Timeout ->
            "Sorry, the request timed out. Please try again."

        Http.NetworkError ->
            "Sorry, there seems to be a network error."

        Http.BadStatus res ->
            res.body

        Http.BadPayload str _ ->
            str
