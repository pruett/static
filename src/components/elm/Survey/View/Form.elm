module Survey.View.Form exposing (..)

import Survey.Update exposing (Msg(..))
import Survey.View.Common as View
import Survey.Data.Patient exposing (..)
import Html exposing (Html, text)
import Html.Attributes as Attrs
import Html.Events exposing (onClick, onCheck, onInput)


view : Details -> Maybe String -> Html Msg
view details err =
    Html.div []
        [ View.formContainer
            [ Html.div []
                [ header
                , inputGroup
                    [ input
                        "text"
                        "First name"
                        details.firstName
                        (InputPatientDetails FirstName)
                    , input
                        "text"
                        "Last name"
                        details.lastName
                        (InputPatientDetails LastName)
                    ]
                , inputGroup
                    [ input
                        "email"
                        "Email"
                        details.email
                        (InputPatientDetails Email)
                    , input
                        "tel"
                        "Phone number"
                        details.phone
                        (InputPatientDetails Phone)
                    ]
                , Html.div [ Attrs.class "u-tac" ]
                    [ agreeToTerms
                        details.agreeToTerms
                        ToggleAgreeToTerms
                    , submit details SubmitPatientForm
                    ]
                , View.errorMsg err
                ]
            ]
        ]


agreeToTerms : Bool -> (Bool -> msg) -> Html msg
agreeToTerms checked msg =
    Html.label [ Attrs.class "u-db u-pr u-mt18 u-mb12" ]
        [ Html.input
            [ Attrs.type_ "checkbox"
            , Attrs.checked checked
            , Attrs.style [ ( "opacity", "0" ) ]
            , Attrs.class "u-pa u-t0 u-l0"
            , onCheck msg
            ]
            []
        , View.checkbox checked
        , text "By clicking “Submit” I agree to the terms and conditions"
        ]


viewPoint : String -> Html msg
viewPoint point =
    Html.li [ Attrs.class "u-mb24" ] [ text point ]


viewTerm : String -> Html msg
viewTerm term =
    Html.li [] [ text term ]


input : String -> String -> Maybe String -> (String -> msg) -> Html msg
input inputType placeholder value msg =
    Html.input
        [ Attrs.type_ inputType
        , Attrs.placeholder placeholder
        , Attrs.value <| Maybe.withDefault "" value
        , Attrs.class "u-reset--button u-p18 u-mt24 u-mb12 u-color-bg--light-gray-alt-2 u-fs16 u-fwn u-color--dark-gray-alt-3 u-bss u-bw1 u-bc--light-gray-alt-1"
        , Attrs.style [ ( "width", "49%" ) ]
        , onInput msg
        ]
        []


inputGroup : List (Html msg) -> Html msg
inputGroup content =
    Html.div
        [ Attrs.class "u-df u-flexd--r u-jc--sb" ]
        content


header : Html msg
header =
    Html.div [ Attrs.class "u-fs16 u-color--dark-gray-alt-3 u-ffss u-fwn" ]
        [ Html.h1 [ Attrs.class "u-tac u-fs40 u-fws u-ffs" ] [ text "Privacy and Informed Consent Notice" ]
        , Html.p [ Attrs.class "u-fsi" ] [ text "JAND, Inc. d/b/a Warby Parker (“Warby Parker”) provides this Privacy and Informed Consent Notice about your online vision test (the “Prescription Check”) and the collection, use, and protection of your personal and health information." ]
        , Html.ol [ Attrs.class "u-p0 u-m0 u-list-inside" ] <|
            List.map viewPoint points
        , Html.p [] [ text "By agreeing to this Privacy and Informed Consent Notice, you" ]
        , Html.ul [] <|
            List.map viewTerm terms
        , Html.hr [] []
        , Html.h2 [ Attrs.class "u-tal u-fs20 u-fws u-ffs" ] [ text "Patient details" ]
        ]


submit : Details -> msg -> Html msg
submit { firstName, lastName, email, phone, agreeToTerms } msg =
    let
        disabled =
            if
                firstName
                    == Nothing
                    || lastName
                    == Nothing
                    || email
                    == Nothing
                    || phone
                    == Nothing
                    || agreeToTerms
                    == False
            then
                True
            else
                False
    in
        Html.button
            [ Attrs.disabled disabled
            , onClick msg
            , View.btnStyle
            ]
            [ text "Submit" ]
