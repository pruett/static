module Survey.View.Common exposing (..)

import Html exposing (Html, text)
import Html.Attributes as Attrs
import Html.Events exposing (onCheck, onClick, onInput)
import Svg exposing (g, path, rect, svg)
import Svg.Attributes as SvgAttrs


-- Containers


pageContainer : List (Html msg) -> Html msg
pageContainer content =
    Html.div
        [ Attrs.class "u-df u-flexd--c u-ai--c u-jc--c"
        , Attrs.style [ ( "min-height", "100vh" ) ]
        ]
        content


cardContainer : List (Html msg) -> Html msg
cardContainer content =
    let
        utilities : Html.Attribute msg
        utilities =
            Attrs.class
                "u-ma u-tac u-df u-flexd--c u-jc--c u-ai--c"

        cardHeight : Html.Attribute msg
        cardHeight =
            Attrs.style [ ( "max-width", "520px" ), ( "min-width", "400px" ) ]
    in
    Html.div [ utilities, cardHeight ] content


formContainer : List (Html msg) -> Html msg
formContainer content =
    Html.div
        [ Attrs.class "u-mw75p u-m0a u-tal u-pb42"
        , Attrs.style [ ( "max-width", "680px" ) ]
        ]
        content


{-|

    Ensures body elements are aligned vertically and horizontally

-}
elementsContainer : List (Html msg) -> Html msg
elementsContainer content =
    Html.div
        [ Attrs.class "u-df u-flexd--c u-jc--c"
        , Attrs.style [ ( "width", "75%" ) ]
        ]
        content



-- Title / Headers


titleBar : Bool -> msg -> Html msg
titleBar isTraining msg =
    let
        rxCheckStyle : Html.Attribute msg
        rxCheckStyle =
            Attrs.class "u-tac u-m0 u-fs16 u-ffss u-fws u-ttu u-ls2_5 u-ma"

        headerStyle : Html.Attribute msg
        headerStyle =
            Attrs.class "u-df u-ai--c u-jc--fe u-pt24 u-pl42 u-pr42 u-w100p"

        environmentStyle : Html.Attribute msg
        environmentStyle =
            Attrs.classList [ ( "u-color-bg--yellow", isTraining ) ]
    in
    Html.div [ headerStyle, environmentStyle ]
        [ Html.h1 [ rxCheckStyle ] [ text "Prescription Check" ]
        , svg
            [ SvgAttrs.width "15"
            , SvgAttrs.height "12"
            , SvgAttrs.viewBox "0 0 15 12"
            , onClick msg
            ]
            [ g
                [ SvgAttrs.stroke "#47515C"
                , SvgAttrs.fill "none"
                , SvgAttrs.fillRule "evenodd"
                , SvgAttrs.strokeLinecap "square"
                ]
                [ path [ SvgAttrs.d "M13.51-.01L1.49 12.01M13.51 12.01L1.49-.01" ] [] ]
            ]
        ]


headerStyle : Html.Attribute msg
headerStyle =
    Attrs.class "u-fs40 u-fws u-ffs"


subtextStyle : Html.Attribute msg
subtextStyle =
    Attrs.class "u-fs18 u-fwn u-ffss u-color--dark-gray-alt-3 u-mb36"


paragraphStyle : Html.Attribute msg
paragraphStyle =
    Attrs.class "u-fs18 u-fwn u-ffss u-color--dark-gray-alt-3"


title : String -> Html msg
title title =
    Html.h1 [ Attrs.class "u-fs40 u-fws u-ffs" ] [ text title ]


subtext : String -> Html msg
subtext val =
    Html.p [ subtextStyle ] [ text val ]


paragraph : String -> Html msg
paragraph paragraphText =
    Html.p [ subtextStyle ] [ text paragraphText ]


heading : String -> Maybe (List String) -> Html msg
heading titleText subtextValue =
    Html.div []
        [ title titleText
        , Html.div []
            (List.map subtext (Maybe.withDefault [ "" ] subtextValue))
        ]


errorMsg : Maybe String -> Html msg
errorMsg err =
    case err of
        Just msg ->
            Html.div
                [ Attrs.class "u-tac u-ffss u-fs18 u-fws u-p12 u-color-bg--red u-color--white" ]
                [ text msg ]

        Nothing ->
            text ""



-- Buttons


btnStyle : Html.Attribute msg
btnStyle =
    Attrs.class "u-button -button-blue -button-large u-fws u-fs16 u-mb12"


activeButton : String -> Bool -> msg -> Html msg
activeButton btnText disabled msg =
    Html.button
        [ Attrs.disabled disabled
        , onClick msg
        , btnStyle
        ]
        [ text btnText ]


simpleButton : String -> msg -> Html msg
simpleButton btnText msg =
    Html.button [ btnStyle, onClick msg ] [ text btnText ]


singleOption : Int -> String -> (Int -> msg) -> Html msg
singleOption index option msg =
    Html.li []
        [ Html.button
            [ btnStyle
            , onClick (msg index)
            ]
            [ text option ]
        ]


{-|

    An alternative to a link. No background or border, just text

-}
textButton : String -> msg -> Html msg
textButton btnText msg =
    Html.button
        [ Attrs.class "u-button-reset u-button -button-large u-fws u-fs16"
        , Attrs.style [ ( "color", "#00a2e1" ) ]
        , onClick msg
        ]
        [ text btnText ]



-- Checkbox


checkbox : Bool -> Html msg
checkbox checked =
    Html.span [ Attrs.class "u-fs18 u-fwn u-ffss u-color--dark-gray-alt-3 u-mr12" ]
        [ svg
            [ SvgAttrs.width "20"
            , SvgAttrs.height "20"
            , SvgAttrs.viewBox "0 0 20 20"
            , Attrs.style [ ( "transform", "translateY(3px)" ) ]
            ]
            [ rect
                [ SvgAttrs.x ".5"
                , SvgAttrs.y "181.5"
                , SvgAttrs.width "19"
                , SvgAttrs.height "19"
                , SvgAttrs.rx "1"
                , SvgAttrs.transform "translate(0 -181)"
                , SvgAttrs.stroke <|
                    if checked then
                        "#00A2E1"
                    else
                        "#D2D6D9"
                , SvgAttrs.fill <|
                    if checked then
                        "#00A2E1"
                    else
                        "none"
                , SvgAttrs.fillRule "evenodd"
                ]
                []
            , path
                [ SvgAttrs.d "M1 4.5L4 8l6-7"
                , SvgAttrs.strokeWidth "2"
                , SvgAttrs.stroke <|
                    if checked then
                        "#FFF"
                    else
                        "none"
                , SvgAttrs.fill "none"
                , SvgAttrs.fillRule "evenodd"
                , SvgAttrs.strokeLinecap "round"
                , SvgAttrs.strokeLinejoin "round"
                , SvgAttrs.transform "translate(4.5 6)"
                ]
                []
            ]
        ]


checkboxOption : Int -> ( Bool, String ) -> (Int -> Bool -> msg) -> Html msg
checkboxOption index ( checked, value ) msg =
    Html.li
        [ Attrs.class "u-mb18"
        , Attrs.style
            [ ( "textIndent", "-32px" )
            , ( "paddingLeft", "32px" )
            ]
        ]
        [ Html.label [ Attrs.class "u-pr" ]
            [ Html.input
                [ Attrs.type_ "checkbox"
                , Attrs.id <| "cbox" ++ toString index
                , Attrs.checked checked
                , Attrs.style [ ( "opacity", "0" ) ]
                , Attrs.class "u-pa u-t0 u-l0"
                , onCheck (msg index)
                ]
                []
            , checkbox checked
            , Html.text value
            ]
        ]



-- Inputs / Textareas


inputStyle : Html.Attribute msg
inputStyle =
    Attrs.class "u-w100p u-p18 u-fs11 u-fws u-ffss u-color--dark-gray-alt-3 u-mb12"


simpleInput : String -> Html msg
simpleInput placeholder =
    Html.input
        [ Attrs.type_ "text"
        , inputStyle
        , Attrs.placeholder placeholder
        ]
        []


input : String -> String -> Maybe String -> (String -> msg) -> Html msg
input inputType placeholder value msg =
    Html.input
        [ Attrs.type_ inputType
        , Attrs.placeholder placeholder
        , Attrs.value <| Maybe.withDefault "" value
        , inputStyle
        , onInput msg
        ]
        []


textArea : String -> Maybe String -> (String -> msg) -> Html msg
textArea placeholder comment msg =
    Html.textarea
        [ Attrs.placeholder placeholder
        , Attrs.value <| Maybe.withDefault "" comment
        , Attrs.rows 8
        , Attrs.cols 40
        , Attrs.wrap "hard"
        , Attrs.class "u-p18 u-mt24 u-mb12 u-color-bg--light-gray-alt-2 u-fs16 u-fwn u-color--dark-gray-alt-3 u-bc--light-gray-alt-1"
        , Attrs.style [ ( "resize", "none" ) ]
        , onInput msg
        ]
        []
