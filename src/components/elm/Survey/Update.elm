module Survey.Update exposing (Msg(..), update)

import Survey.Model exposing (Model)
import Survey.Helpers as Helpers
import Survey.HttpRequests as HttpRequests
import Survey.Data.Question as Question exposing (Question)
import Survey.Data.Patient as Patient
import Survey.Data.Status as Status
import Http


{-|
    The Msg type represents all of the messages that can be sent within
    our application. We are forced to handle all cases below in the update
    function.
-}
type Msg
    = ClickX
    | ConfirmQuit
    | Continue
    | ContinueTakingSurvey
    | HandleFormSubmission (Result Http.Error ())
    | InputPatientDetails Patient.Input String
    | InputResponse String
    | ReadBadNews
    | ReadGoodNews
    | SelectChoice Int
    | SelectRating Int
    | StartSurvey
    | SubmitPatientForm
    | ToggleAgreeToTerms Bool
    | ToggleOption Int Bool


{-|
    The update function is where we handle all the Msg type constructors
    that we defined above. Here we update the model that represents the
    current state of our application. Additionally, we'll be able to send
    commands (Cmd) to the Elm runtime that can perform side-effects like
    Http requests, modifying localstorage, etc.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitPatientForm ->
            ( model, HttpRequests.createPatientSurvey model HandleFormSubmission )

        HandleFormSubmission (Ok ()) ->
            ( { model | status = Status.Success }, Cmd.none )

        HandleFormSubmission (Err err) ->
            ( { model
                | status = Status.FormSubmission (Just (HttpRequests.submissionError err))
              }
            , Cmd.none
            )

        SelectChoice index ->
            ( { model | current = Question.recordResponse index model.current }
                |> Helpers.handleRejections (Just index)
                |> Helpers.handleNestedQuestions (Just index)
                |> Helpers.next
            , Cmd.none
            )

        InputResponse val ->
            ( { model
                | current =
                    model.current
                        |> Question.handleInputUpdate val
                        |> Question.updateRejections
              }
            , Cmd.none
            )

        Continue ->
            ( model
                |> Helpers.handleRejections Nothing
                |> Helpers.handleNestedQuestions Nothing
                |> Helpers.next
            , Cmd.none
            )

        SelectRating rating ->
            ( { model
                | current =
                    model.current
                        |> Question.updateRatingSelection rating
              }
            , Cmd.none
            )

        ToggleOption index checked ->
            ( { model
                | current =
                    model.current
                        |> Question.updateCheckbox index checked
                        |> Question.updateRejections
                        |> Question.handleNestedCheckbox
              }
            , Cmd.none
            )

        StartSurvey ->
            ( { model | status = Status.InSurvey }, Cmd.none )

        ClickX ->
            ( { model | status = Status.Quit }, Cmd.none )

        ContinueTakingSurvey ->
            ( { model | status = Status.InSurvey }, Cmd.none )

        ConfirmQuit ->
            ( { model | status = Status.ThanksForParticipating }, Cmd.none )

        ReadBadNews ->
            ( { model | status = Status.Disqualified Status.GoodNews }, Cmd.none )

        ReadGoodNews ->
            ( { model | status = Status.ThanksForParticipating }, Cmd.none )

        InputPatientDetails inputType value ->
            ( { model
                | patientDetails = Patient.updateInput inputType value model.patientDetails
              }
            , Cmd.none
            )

        ToggleAgreeToTerms checked ->
            ( { model
                | patientDetails = Patient.updateAgreeToTerms checked model.patientDetails
              }
            , Cmd.none
            )
