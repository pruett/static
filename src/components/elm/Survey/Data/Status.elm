module Survey.Data.Status exposing (..)


type Step
    = BadNews (List String)
    | GoodNews


type Status
    = Disqualified Step
    | FormSubmission (Maybe String)
    | InSurvey
    | Quit
    | Success
    | ThanksForParticipating
    | Welcome
