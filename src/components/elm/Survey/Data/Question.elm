module Survey.Data.Question exposing (..)

import Array.Hamt as Array exposing (Array)
import Json.Encode as Encode


type alias Question =
    { id : String
    , heading : String
    , subheading : Maybe (List String)
    , variant : Variant
    , rejection : Rejection
    }


type alias ChoiceSettings a =
    { a
        | options : Array String
        , selection : Maybe Int
    }


type alias CheckboxSettings a =
    { a | options : Array ( Bool, String ) }


type alias InputSettings a =
    { a
        | inputType : String
        , value : Maybe String
        , placeholder : String
        , btnDisabled : Bool
    }


type alias CommentSettings a =
    { a
        | comment : Maybe String
        , placeholder : String
    }


type alias RatingSettings =
    { rating : List NumericalRating
    , selection : Maybe Int
    , btnDisabled : Bool
    }


type alias NumericalRating =
    { value : Int
    , selected : Bool
    , caption : Maybe String
    }


type Variant
    = Checkbox (CheckboxSettings {})
    | Choice (ChoiceSettings {})
    | NestedInput (InputSettings { conditionals : ( Int, Int ), additionalQuestions : List Question })
    | NestedCheckbox (CheckboxSettings { conditionals : List ( Int, Question ), activated : List Question })
    | NestedChoice (ChoiceSettings { conditionals : List { index : Int, question : Question } })
    | OptionalComment (CommentSettings { defaultCta : String, activeCta : String })
    | Rating (CommentSettings RatingSettings)
    | RequiredComment (CommentSettings { cta : String, btnDisabled : Bool })


type alias GenericRejection a =
    { a | reason : List String }


type Rejection
    = NoRejection
    | AgeLimitRejection (GenericRejection { range : ( Int, Int ), rejected : Bool })
    | AnswerRejection (GenericRejection { answers : List Int, rejected : Bool })


extractIndexedValue : Int -> Question -> String
extractIndexedValue index question =
    case question.variant of
        Choice { options } ->
            Maybe.withDefault "N/A" <| Array.get index options

        NestedChoice { options } ->
            Maybe.withDefault "N/A" <| Array.get index options

        _ ->
            "N/A"


selectionHasRejection : Int -> List Int -> Bool
selectionHasRejection index answers =
    [ index ]
        |> List.map (\i -> List.member i answers)
        |> List.any (\a -> a == True)


recordResponse : Int -> Question -> Question
recordResponse index question =
    case question.variant of
        Choice settings ->
            { question | variant = Choice { settings | selection = Just index } }

        NestedChoice settings ->
            { question | variant = NestedChoice { settings | selection = Just index } }

        _ ->
            question


determineCheckboxRejection : Array ( Bool, String ) -> List Int -> Bool
determineCheckboxRejection options answers =
    options
        |> Array.toIndexedList
        |> List.filterMap
            (\( index, ( checked, _ ) ) ->
                if checked == True then
                    Just index
                else
                    Nothing
            )
        |> List.map (\index -> List.member index answers)
        |> List.any (\a -> a == True)


updateCheckboxRejections : Array ( Bool, String ) -> Question -> Question
updateCheckboxRejections options question =
    case question.rejection of
        AnswerRejection ({ answers } as rejection) ->
            { question
                | rejection =
                    AnswerRejection
                        { rejection | rejected = determineCheckboxRejection options answers }
            }

        _ ->
            question


updateInputRejections : Maybe String -> Question -> Question
updateInputRejections value question =
    case question.rejection of
        AgeLimitRejection ({ range } as rejection) ->
            if
                value
                    |> Maybe.withDefault "0"
                    |> String.toInt
                    |> Result.withDefault 0
                    |> flip List.member (List.range (Tuple.first range) (Tuple.second range))
            then
                { question | rejection = AgeLimitRejection { rejection | rejected = False } }
            else
                { question | rejection = AgeLimitRejection { rejection | rejected = True } }

        _ ->
            question


getValue : String -> Maybe String
getValue val =
    if String.isEmpty val then
        Nothing
    else
        Just val


handleInputUpdate : String -> Question -> Question
handleInputUpdate value question =
    value
        |> getValue
        |> onInputUpdate question


onInputUpdate : Question -> Maybe String -> Question
onInputUpdate question value =
    case question.variant of
        NestedInput settings ->
            { question
                | variant =
                    NestedInput
                        { settings
                            | value = value
                            , btnDisabled =
                                if value == Nothing then
                                    True
                                else
                                    False
                        }
            }

        Rating settings ->
            { question | variant = Rating { settings | comment = value } }

        OptionalComment settings ->
            { question | variant = OptionalComment { settings | comment = value } }

        RequiredComment settings ->
            { question
                | variant =
                    RequiredComment
                        { settings
                            | comment = value
                            , btnDisabled =
                                if value == Nothing then
                                    True
                                else
                                    False
                        }
            }

        _ ->
            question


updateRatingSelection : Int -> Question -> Question
updateRatingSelection selection question =
    case question.variant of
        Rating ({ rating } as settings) ->
            { question
                | variant =
                    Rating
                        { settings
                            | selection = Just selection
                            , rating = List.map (markRating selection) rating
                            , btnDisabled = False
                        }
            }

        _ ->
            question


getCheckedOptions : Array ( Bool, String ) -> Array ( Bool, String )
getCheckedOptions options =
    let
        isOptionChecked : ( Bool, a ) -> Bool
        isOptionChecked ( checked, _ ) =
            if checked == True then
                True
            else
                False
    in
    options |> Array.filter isOptionChecked


handleNestedCheckbox : Question -> Question
handleNestedCheckbox question =
    case question.variant of
        NestedCheckbox ({ options, conditionals } as settings) ->
            let
                checkedIndices =
                    options
                        |> Array.toIndexedList
                        |> List.filterMap
                            (\( index, ( checked, _ ) ) ->
                                if checked == True then
                                    Just index
                                else
                                    Nothing
                            )

                adjusted =
                    conditionals
                        |> List.filterMap
                            (\( index, q ) ->
                                if List.member index checkedIndices then
                                    Just q
                                else
                                    Nothing
                            )
            in
            { question
                | variant =
                    NestedCheckbox { settings | activated = adjusted }
            }

        _ ->
            question


anyOptionsChecked : Array ( Bool, String ) -> Bool
anyOptionsChecked options =
    getCheckedOptions options
        |> Array.length
        |> (\num -> num > 0)


markRating : Int -> NumericalRating -> NumericalRating
markRating selection rating =
    if rating.value == selection then
        { rating | selected = True }
    else
        { rating | selected = False }


updateRejections : Question -> Question
updateRejections question =
    case question.variant of
        Checkbox { options } ->
            updateCheckboxRejections options question

        NestedCheckbox { options } ->
            updateCheckboxRejections options question

        NestedInput { value } ->
            updateInputRejections value question

        _ ->
            question


updateCheckboxOptions : Int -> Array ( Bool, String ) -> Bool -> Array ( Bool, String )
updateCheckboxOptions index options checked =
    case Array.get index options of
        Just ( _, text ) ->
            Array.set index ( checked, text ) options

        Nothing ->
            options


updateCheckbox : Int -> Bool -> Question -> Question
updateCheckbox index checked question =
    case question.variant of
        Checkbox ({ options } as settings) ->
            { question | variant = Checkbox { settings | options = updateCheckboxOptions index options checked } }

        NestedCheckbox ({ options } as settings) ->
            { question | variant = NestedCheckbox { settings | options = updateCheckboxOptions index options checked } }

        _ ->
            question


encodedChoice : Maybe Int -> Question -> Maybe ( String, Encode.Value )
encodedChoice selection question =
    case selection of
        Just index ->
            Just
                ( question.id
                , Encode.object
                    [ ( "response"
                      , Encode.string <| extractIndexedValue index question
                      )
                    , ( "heading", Encode.string question.heading )
                    ]
                )

        Nothing ->
            Nothing


encodedValue : Maybe String -> Question -> Maybe ( String, Encode.Value )
encodedValue value question =
    case value of
        Just val ->
            Just
                ( question.id
                , Encode.object
                    [ ( "response", Encode.string val )
                    , ( "heading", Encode.string question.heading )
                    ]
                )

        Nothing ->
            Nothing


encodedCheckbox : Array ( Bool, String ) -> Question -> Maybe ( String, Encode.Value )
encodedCheckbox options question =
    let
        nullResponse : String
        nullResponse =
            "None of the above"

        response : List String
        response =
            getCheckedOptions options
                |> Array.toList
                |> List.map (\( _, val ) -> val)
    in
    case List.length response of
        0 ->
            Just
                ( question.id
                , Encode.object
                    [ ( "response", Encode.string nullResponse )
                    , ( "heading", Encode.string question.heading )
                    ]
                )

        1 ->
            Just
                ( question.id
                , Encode.object
                    [ ( "response", Encode.string <| Maybe.withDefault nullResponse (List.head response) )
                    , ( "heading", Encode.string question.heading )
                    ]
                )

        _ ->
            Just
                ( question.id
                , Encode.object
                    [ ( "response", Encode.list <| List.map Encode.string response )
                    , ( "heading", Encode.string question.heading )
                    ]
                )


encodedRating : Maybe Int -> Maybe String -> Question -> Maybe ( String, Encode.Value )
encodedRating selection comment question =
    case comment of
        Just val ->
            Just
                ( question.id
                , Encode.object
                    [ ( "response", Encode.int <| Maybe.withDefault 0 selection )
                    , ( "note", Encode.string val )
                    , ( "heading", Encode.string question.heading )
                    ]
                )

        Nothing ->
            Just
                ( question.id
                , Encode.object
                    [ ( "response", Encode.int <| Maybe.withDefault 0 selection )
                    , ( "heading", Encode.string question.heading )
                    ]
                )


encodeQuestionResponse : Question -> Maybe ( String, Encode.Value )
encodeQuestionResponse question =
    case question.variant of
        Choice { selection } ->
            encodedChoice selection question

        NestedChoice { selection } ->
            encodedChoice selection question

        NestedInput { value } ->
            encodedValue value question

        OptionalComment { comment } ->
            encodedValue comment question

        RequiredComment { comment } ->
            encodedValue comment question

        Checkbox { options } ->
            encodedCheckbox options question

        NestedCheckbox { options } ->
            encodedCheckbox options question

        Rating { selection, comment } ->
            encodedRating selection comment question


surveyAttributes : List Question -> Encode.Value
surveyAttributes questions =
    Encode.object
        [ ( "order"
          , Encode.list <| List.map (\q -> Encode.string q.id) questions
          )
        ]


encodeSurvey : List Question -> Encode.Value
encodeSurvey questions =
    Encode.object
        [ ( "kiosk_survey"
          , Encode.object
                (( "attributes", surveyAttributes questions )
                    :: List.filterMap encodeQuestionResponse questions
                )
          )
        , ( "type", Encode.string "kiosk_survey" )
        ]
