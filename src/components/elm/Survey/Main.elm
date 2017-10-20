module Survey.Main exposing (main)

import Html
import Survey.Data.Patient as Patient
import Survey.Data.Status as Status
import Survey.Model exposing (Model)
import Survey.Questions exposing (..)
import Survey.Update exposing (Msg, update)
import Survey.View exposing (view)


-- We can pass in "flags" from the outside world, a.k.a., JS to
-- provide values on intialization. Here we are passing in an API
-- endpoint defined in our config file.


type alias Flags =
    { api : String
    , isTraining : Bool
    , patientDetails : Patient.Details
    }


init : Flags -> ( Model, Cmd Msg )
init { api, isTraining, patientDetails } =
    ( Model
        []
        age
        [ haveGlassesOrContacts
        , lastEyeExam
        , rateVision
        , experiencing
        , eyeProblems
        , visionHistory
        , personalHistory
        , familyHistory
        , eyeSurgery
        , additionalComments
        ]
        patientDetails
        Status.Welcome
        api
        isTraining
    , Cmd.none
    )


{-|

    Html.program takes a record with a few fields. By indicating our init,
    view, and update functions, our program is now hooked up into
    a uni-directional data flow, where:

        -> model -> view -> update ->
        |                           |
        <---------------------------

-}
main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
