module Survey.View.Status exposing (..)

import Html exposing (Html)
import Survey.Data.Status exposing (..)
import Survey.Update exposing (Msg(..))
import Survey.View.Common as View


welcome : Bool -> Html Msg
welcome isTraining =
    View.pageContainer
        [ View.titleBar isTraining ClickX
        , View.cardContainer
            [ View.heading "Now, for a few questions..." Nothing
            , View.simpleButton "Get started" StartSurvey
            ]
        ]


quit : Html Msg
quit =
    View.pageContainer
        [ View.cardContainer
            [ View.heading
                "Do you really want to quit?"
                (Just
                    [ "If you quit, your in-progress data will be lost. (Poof! Gone with the wind! Etc!)"
                    ]
                )
            , View.simpleButton "Keep taking the survey" ContinueTakingSurvey
            , View.textButton "I'm sure" ConfirmQuit
            ]
        ]


thanks : Html Msg
thanks =
    View.pageContainer
        [ View.cardContainer
            [ View.heading
                "Thanks for taking part in Prescription Check!"
                Nothing
            , View.paragraph "While you’re here, feel free to keep browsing. (FYI: You can always order without a prescription and add an updated one to your account later. And of course, ask an advisor if you’d like help getting a prescription.)"
            , View.paragraph "Hope to see you again soon!"
            ]
        ]


success : Html Msg
success =
    View.pageContainer
        [ View.cardContainer
            [ View.heading
                "Wahoo!"
                Nothing
            , View.paragraph "You are eligible to participate in our Prescription Check service."
            , View.paragraph "Any of our in-store advisors can help you continue the process of getting an updated prescription. Go get started!"
            ]
        ]


rejected : Step -> Html Msg
rejected step =
    case step of
        BadNews reason ->
            View.pageContainer
                [ View.cardContainer
                    [ View.title "We're sorry"
                    , Html.div [] (List.map View.paragraph reason)
                    , View.simpleButton "Continue" ReadBadNews
                    ]
                ]

        GoodNews ->
            View.pageContainer
                [ View.cardContainer
                    [ View.title "There is some good news!"
                    , View.paragraph "We’re constantly improving our technology. Sign up to learn when our test could be ready for you."
                    , View.elementsContainer
                        [ View.simpleInput "Email (optional)"
                        , View.simpleButton "Continue" ReadGoodNews
                        ]
                    ]
                ]
