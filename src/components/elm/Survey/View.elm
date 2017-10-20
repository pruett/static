module Survey.View exposing (view)

import Html exposing (Html)
import Survey.Data.Status as Status
import Survey.Model exposing (Model)
import Survey.Update exposing (Msg(..))
import Survey.View.Common as Common
import Survey.View.Form
import Survey.View.Question
import Survey.View.Status


{-|

    This is our application's main view function. It just takes one argument,
    our model, which represents our application's current state. As we make
    updates to the model, it gets piped back through this view function.

-}
view : Model -> Html Msg
view model =
    case model.status of
        Status.Welcome ->
            Survey.View.Status.welcome model.isTraining

        Status.InSurvey ->
            Common.pageContainer
                [ Common.titleBar model.isTraining ClickX
                , Common.cardContainer <|
                    Survey.View.Question.question model.current
                ]

        Status.FormSubmission error ->
            Survey.View.Form.view model.patientDetails error

        Status.Disqualified step ->
            Survey.View.Status.rejected step

        Status.Quit ->
            Survey.View.Status.quit

        Status.ThanksForParticipating ->
            Survey.View.Status.thanks

        Status.Success ->
            Survey.View.Status.success
