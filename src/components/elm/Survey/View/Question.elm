module Survey.View.Question exposing (question)

import Array.Hamt as Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events exposing (onClick)
import Survey.Data.Question exposing (..)
import Survey.Update exposing (Msg(..))
import Survey.View.Common as Common


choiceQuestion : Question -> Array String -> List (Html Msg)
choiceQuestion { heading, subheading } options =
    [ Common.heading heading subheading
    , Html.ul
        [ Attrs.class "u-list-reset" ]
        (options
            |> Array.toIndexedList
            |> List.map (\( i, val ) -> Common.singleOption i val SelectChoice)
        )
    ]


checkbox : Question -> Array ( Bool, String ) -> List (Html Msg)
checkbox { heading, subheading } options =
    [ Common.heading heading subheading
    , Html.ul [ Attrs.class "u-list-reset u-tal" ]
        (options
            |> Array.toIndexedList
            |> List.map (\( i, val ) -> Common.checkboxOption i val ToggleOption)
        )
    , Html.button
        [ Common.btnStyle
        , Attrs.class "u-mt18"
        , onClick Continue
        ]
        [ Html.text <|
            if anyOptionsChecked options then
                "Continue"
            else
                "None of these"
        ]
    ]


viewRating : NumericalRating -> Html Msg
viewRating { value, selected, caption } =
    Html.li []
        [ Html.button
            [ onClick (SelectRating value)
            , Attrs.class "u-reset--button u-bss u-bw1 u-br1 u-bc--blue u-p6 u-fs16 u-fws"
            , Attrs.style [ ( "height", "50px" ), ( "width", "50px" ) ]
            , Attrs.classList [ ( "u-color-bg--blue u-color--white", selected ) ]
            , Attrs.classList [ ( "u-color--blue", not selected ) ]
            ]
            [ Html.text <| toString value ]
        , Html.span
            [ Attrs.class "u-db u-fs14 u-color--dark-gray-alt-3 u-fwn u-mt12" ]
            [ Html.text <| Maybe.withDefault "" caption ]
        ]


ratingQuestion : Question -> CommentSettings RatingSettings -> List (Html Msg)
ratingQuestion { heading, subheading } { rating, placeholder, comment, btnDisabled } =
    [ Common.heading heading subheading
    , Common.elementsContainer
        [ Html.ul [ Attrs.class "u-list-reset u-df u-jc--sb" ] <|
            List.map viewRating rating
        , Common.textArea placeholder comment InputResponse
        , Common.activeButton "Continue" btnDisabled Continue
        ]
    ]


inputQuestion :
    Question
    -> InputSettings { conditionals : ( Int, Int ), additionalQuestions : List Question }
    -> List (Html Msg)
inputQuestion { heading, subheading } { inputType, placeholder, value, btnDisabled } =
    [ Common.heading heading subheading
    , Common.elementsContainer
        [ Common.input inputType placeholder value InputResponse
        , Common.activeButton "Continue" btnDisabled Continue
        ]
    ]


commentBtnValue : Maybe String -> String -> String -> String
commentBtnValue comment default active =
    case comment of
        Just _ ->
            active

        Nothing ->
            default


commentQuestion : Question -> CommentSettings { defaultCta : String, activeCta : String } -> List (Html Msg)
commentQuestion { heading, subheading } { comment, placeholder, defaultCta, activeCta } =
    [ Common.heading heading subheading
    , Common.elementsContainer
        [ Common.textArea placeholder comment InputResponse
        , Common.activeButton (commentBtnValue comment defaultCta activeCta) False Continue
        ]
    ]


requiredCommentQuestion : Question -> CommentSettings { cta : String, btnDisabled : Bool } -> List (Html Msg)
requiredCommentQuestion { heading, subheading } { comment, placeholder, cta, btnDisabled } =
    [ Common.heading heading subheading
    , Common.elementsContainer
        [ Common.textArea placeholder comment InputResponse
        , Common.activeButton cta btnDisabled Continue
        ]
    ]


question : Question -> List (Html Msg)
question question =
    case question.variant of
        Choice { options } ->
            choiceQuestion question options

        NestedChoice { options } ->
            choiceQuestion question options

        NestedInput settings ->
            inputQuestion question settings

        OptionalComment settings ->
            commentQuestion question settings

        RequiredComment settings ->
            requiredCommentQuestion question settings

        Rating settings ->
            ratingQuestion question settings

        Checkbox { options } ->
            checkbox question options

        NestedCheckbox { options } ->
            checkbox question options
