module Survey.Model exposing (Model)

import Survey.Data.Patient as Patient
import Survey.Data.Question exposing (Question)
import Survey.Data.Status exposing (Status)


{-|

    Our Model holds the entire state of our app. Anytime we want our UI to
    change, we will update our model. This updated model then gets sent to
    our view where it intelligently updates the DOM.

    Here, we are using a zip list (https://en.wikipedia.org/wiki/Zipper_(data_structure))
    to represent our survey questions. This makes it convenient for traversing
    forwards and backwards by performing simple operations (i.e. append, drop)
    on the appropriate sub-lists. In other words, our entire list of questions
    can be combined into a single list with:

    model.previous ++ [model.current] ++ model.remaining

-}
type alias Model =
    { previous : List Question
    , current : Question
    , remaining : List Question
    , patientDetails : Patient.Details
    , status : Status
    , api : String
    , isTraining : Bool
    }
