module Survey.Helpers exposing (handleNestedQuestions, handleRejections, next)

import Survey.Data.Question as Question exposing (Question)
import Survey.Data.Status as Status exposing (Status)
import Survey.Model exposing (Model)


next : Model -> Model
next model =
    case model.remaining of
        [] ->
            { model | status = Status.FormSubmission Nothing }

        head :: tail ->
            { model
                | previous = model.current :: model.previous
                , current = head
                , remaining = tail
            }


handleNestedQuestions : Maybe Int -> Model -> Model
handleNestedQuestions index model =
    case model.current.variant of
        Question.NestedInput { conditionals, value, additionalQuestions } ->
            let
                ( first, second ) =
                    conditionals
            in
            case Maybe.map String.toInt value of
                Just (Ok res) ->
                    if List.member res <| List.range first second then
                        { model | remaining = List.append additionalQuestions model.remaining }
                    else
                        model

                _ ->
                    model

        Question.NestedChoice { conditionals } ->
            let
                addStackedQuestion : { index : Int, question : Question } -> Model -> Model
                addStackedQuestion conditional acc =
                    if conditional.index == Maybe.withDefault 0 index then
                        { acc | remaining = conditional.question :: model.remaining }
                    else
                        acc
            in
            List.foldl addStackedQuestion model conditionals

        Question.NestedCheckbox { activated } ->
            if List.isEmpty activated then
                model
            else
                { model
                    | remaining =
                        List.append activated model.remaining
                }

        _ ->
            model


answerRejectionStatus : Maybe Int -> Question.GenericRejection { answers : List Int, rejected : Bool } -> Model -> Model
answerRejectionStatus index { answers, reason, rejected } model =
    let
        status : Status
        status =
            if Question.selectionHasRejection (Maybe.withDefault 0 index) answers == True then
                Status.Disqualified (Status.BadNews reason)
            else
                model.status
    in
    case model.current.variant of
        Question.NestedChoice _ ->
            { model | status = status }

        Question.Choice _ ->
            { model | status = status }

        _ ->
            if rejected == True then
                { model | status = Status.Disqualified (Status.BadNews reason) }
            else
                model


handleRejections : Maybe Int -> Model -> Model
handleRejections index model =
    case model.current.rejection of
        Question.AgeLimitRejection { reason, rejected } ->
            if rejected == True then
                { model | status = Status.Disqualified (Status.BadNews reason) }
            else
                model

        Question.AnswerRejection settings ->
            answerRejectionStatus index settings model

        Question.NoRejection ->
            model
