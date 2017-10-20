module Survey.Questions
    exposing
        ( additionalComments
        , age
        , experiencing
        , eyeProblems
        , eyeSurgery
        , familyHistory
        , haveGlassesOrContacts
        , lastEyeExam
        , personalHistory
        , rateVision
        , visionHistory
        )

import Array.Hamt as Array exposing (Array)
import Survey.Data.Question exposing (..)


age : Question
age =
    { id = "age"
    , heading = "How old are you?"
    , subheading = Nothing
    , variant =
        NestedInput
            { inputType = "number"
            , value = Nothing
            , placeholder = "In years, please."
            , btnDisabled = True
            , conditionals = ( 41, 50 )
            , additionalQuestions = [ over40Under51WearGlasses, over40Under51Experiencing ]
            }
    , rejection =
        AgeLimitRejection
            { range = ( 18, 50 )
            , reason =
                [ "Unfortunately, you fall outside of the age range that we’re currently covering. The American Academy of Ophthalmology recommends that people who are younger than 18 or older than 50 receive screenings for eye conditions that are not currently assessed by our service."
                , "If you need a new prescription or are experiencing any eye or vision issues, please book an eye exam with your doctor. One of our advisors can help you find a Warby Parker location with eye exams or find another convenient option."
                ]
            , rejected = False
            }
    }


over40Under51WearGlasses : Question
over40Under51WearGlasses =
    { id = "over40_under_51_wear_glasses"
    , heading = "Do you currently wear reading glasses (readers), progressives, or bifocals?"
    , subheading = Just [ "If you’re not sure, here’s a little guide:", "Readers: Glasses that you only put on for looking at things up close. (They might make your distance vision blurry.)", "Progressives: Glasses with multiple prescriptions in the lens.  (When you look straight ahead you look through the distance portion; when you drop your eyes down to read, you look through the reading portion.)", "Bifocals: These are similar to progressives, except that you can see the line in the lens where the distance prescription meets the reading prescription." ]
    , variant =
        Choice
            { options = Array.fromList [ "Yes", "No" ]
            , selection = Nothing
            }
    , rejection =
        AnswerRejection
            { answers = [ 0 ]
            , reason =
                [ "You indicated that you need near-vision correction and at the moment, Prescription Check only evaluates distance-vision prescriptions."
                , "All is not lost! We are hard at work to accommodate more and more prescriptions."
                , "In the meantime, an advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


over40Under51Experiencing : Question
over40Under51Experiencing =
    { id = "over40_under_51_experiencing"
    , heading = "Are you experiencing any of the following?"
    , subheading = Nothing
    , variant =
        Checkbox
            { options =
                Array.fromList
                    [ ( False, "Difficulty focusing on small letters or numbers up close" )
                    , ( False, "Trouble reading restaurant menus" )
                    , ( False, "Difficulty switching my focus from near to far (or back again)" )
                    , ( False, "Getting headaches after reading (even occasionally)" )
                    , ( False, "Sometimes it’s more comfortable to read small print without my glasses" )
                    , ( False, "Difficulty viewing the computer" )
                    ]
            }
    , rejection = NoRejection
    }


haveGlassesOrContacts : Question
haveGlassesOrContacts =
    { id = "glasses_contacts"
    , heading = "Do you have your glasses or contacts with you today?"
    , subheading = Nothing
    , variant =
        NestedChoice
            { options =
                Array.fromList
                    [ "Yep! My glasses."
                    , "Yep! My contacts."
                    , "I don't have either on me."
                    ]
            , selection = Nothing
            , conditionals =
                [ { index = 1, question = accessToContactLensRx }
                , { index = 2, question = mostRecentGlassesRx }
                ]
            }
    , rejection = NoRejection
    }


accessToContactLensRx : Question
accessToContactLensRx =
    { id = "contacts_rx"
    , heading = "Yay contacts!"
    , subheading = Just [ "Do you have access to your contact lens prescription or contact lens box/blister packs—either now or that you can share with us later?" ]
    , variant =
        NestedChoice
            { options = Array.fromList [ "Yes", "No" ]
            , selection = Nothing
            , conditionals =
                [ { index = 0, question = mostRecentGlassesRx } ]
            }
    , rejection =
        AnswerRejection
            { answers = [ 1 ]
            , reason =
                [ "Since you’re wearing your contact lenses today, our doctor needs to see your current contact lens prescription in addition to your past glasses prescription in order to accurately review your results."
                , "(Just like with a comprehensive exam, the doctor uses information about your past prescriptions to determine a prescription that will be the most comfortable for you.)"
                , "Please come back and visit us if you are able to get ahold of your existing contact lens prescription or contact lens box/blister packs! If it’s easier, you may also come in with your current pair of glasses; in that case, we’re able to read your prescription off the glasses."
                , "If you’d like, an advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


mostRecentGlassesRx : Question
mostRecentGlassesRx =
    { id = "recent_rx"
    , heading = "We'll need your most recent glasses prescription"
    , subheading = Just [ "Do you also have access to your most recent glasses prescription—either now or that you can share with us later?" ]
    , variant =
        Choice
            { options = Array.fromList [ "Yes", "No" ]
            , selection = Nothing
            }
    , rejection =
        AnswerRejection
            { answers = [ 1 ]
            , reason =
                [ "Our doctor needs to see your past prescription in order to accurately review your results."
                , "(Just like with a comprehensive exam, the doctor uses information about your past prescriptions to determine a prescription that will be the most comfortable for you.)"
                , "Please come back and visit us if you are able to get ahold of your existing prescription or current pair of glasses. (We can always read your prescription off of your glasses.)"
                , "If you’d like, an advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


lastEyeExam : Question
lastEyeExam =
    { id = "eye_exam"
    , heading = "When was your most recent comprehensive eye exam?"
    , subheading = Nothing
    , variant =
        Choice
            { options =
                Array.fromList
                    [ "Within 2 years"
                    , "2–5 years ago"
                    , "Over 5 years ago"
                    ]
            , selection = Nothing
            }
    , rejection =
        AnswerRejection
            { answers = [ 2 ]
            , reason =
                [ "We require Prescription Check patients to see an eye doctor in person at least once every 5 years. Even if you aren’t experiencing any vision problems, it’s important to have your eye health checked at intervals recommended by your doctor."
                , "An advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


rateVision : Question
rateVision =
    { id = "satisfaction"
    , heading = "Your current prescription"
    , subheading =
        Just [ "How satisfied are you with the current prescription in your glasses?" ]
    , variant =
        Rating
            { rating =
                [ NumericalRating 1 False (Just "Not satisfied")
                , NumericalRating 2 False Nothing
                , NumericalRating 3 False (Just "So-so")
                , NumericalRating 4 False Nothing
                , NumericalRating 5 False (Just "Very satisfied")
                ]
            , selection = Nothing
            , btnDisabled = True
            , placeholder = "If you’d like to explain, go right ahead (optional). We’ll pass it along to the doctor."
            , comment = Nothing
            }
    , rejection = NoRejection
    }


experiencing : Question
experiencing =
    { id = "experiencing"
    , heading = "Are you experiencing any of the below?"
    , subheading = Nothing
    , variant =
        NestedCheckbox
            { options =
                Array.fromList
                    [ ( False, "Headaches" )
                    , ( False, "Eye pain" )
                    , ( False, "Red or tearing eyes (outside of seasonal or known allergies)" )
                    , ( False, "New floaters" )
                    , ( False, "Seeing flashes of light" )
                    , ( False, "New or unusual light sensitivity" )
                    ]
            , conditionals = [ ( 0, headacheFreeResponse ), ( 2, redEyesFreeResponse ) ]
            , activated = []
            }
    , rejection =
        AnswerRejection
            { answers = [ 1, 3, 4, 5 ]
            , reason =
                [ "Based on your response about your health background, our doctor recommends that you get a comprehensive eye exam to check both your prescription and overall eye health."
                , "An advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


headacheFreeResponse : Question
headacheFreeResponse =
    { id = "headache"
    , heading = "Headaches"
    , subheading =
        Just
            [ "Our doctor needs some more info to determine if this might require treatment or a more in-depth exam. (If so, you will be referred for a comprehensive eye exam.)" ]
    , variant =
        RequiredComment
            { comment = Nothing
            , placeholder = "Please describe your headaches. For example, when did your headaches first start and how often do they occur?"
            , cta = "Submit note to doctor"
            , btnDisabled = True
            }
    , rejection = NoRejection
    }


redEyesFreeResponse : Question
redEyesFreeResponse =
    { id = "red_eyes"
    , heading = "Red or tearing eyes"
    , subheading =
        Just
            [ "Our doctor needs some more info to determine if this might require treatment or a more in-depth exam. (If so, you will be referred for a comprehensive eye exam.)" ]
    , variant =
        RequiredComment
            { comment = Nothing
            , placeholder = "Please describe your red eyes. For example, when did this first start and how often does it occur?"
            , cta = "Submit note to doctor"
            , btnDisabled = True
            }
    , rejection = NoRejection
    }


eyeProblems : Question
eyeProblems =
    { id = "eye_conditions"
    , heading = "Have you ever had any of the below eye conditions?"
    , subheading = Nothing
    , variant =
        Checkbox
            { options =
                Array.fromList
                    [ ( False, "Amblyopia (lazy eye)" )
                    , ( False, "Strabismus (eye turn)" )
                    , ( False, "Eye movement problems (like nystagmus)" )
                    , ( False, "Severe dry eye" )
                    , ( False, "Cornea problems (like keratoconus)" )
                    , ( False, "Glaucoma or high eye pressure" )
                    , ( False, "Macular degeneration" )
                    , ( False, "Optic neuritis" )
                    , ( False, "Cataracts" )
                    ]
            }
    , rejection =
        AnswerRejection
            { answers = [ 0, 1, 2, 3, 4, 5, 6, 7, 8 ]
            , reason =
                [ "Based on your response about your eye health history, our doctor recommends that you get a comprehensive eye exam to check both your prescription and overall eye health."
                , "An advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


visionHistory : Question
visionHistory =
    { id = "injuries_infections"
    , heading = "Injuries or infections"
    , subheading =
        Just [ "Do you have reduced vision in one or both eyes due to an injury or infection?" ]
    , variant =
        Choice
            { options = Array.fromList [ "Yes", "No" ]
            , selection = Nothing
            }
    , rejection =
        AnswerRejection
            { answers = [ 0 ]
            , reason =
                [ "Because you noted that you have reduced vision in one or both of your eyes as a result of an injury or an infection, we recommend that you visit a doctor for a comprehensive eye exam."
                , "An advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


personalHistory : Question
personalHistory =
    { id = "health_history"
    , heading = "Your health history"
    , subheading =
        Just [ "Have you ever had or do you have any disease that may affect eyesight, such as diabetes, uncontrolled high blood pressure, or any neurological conditions?" ]
    , variant =
        Choice
            { options = Array.fromList [ "Yes", "No" ]
            , selection = Nothing
            }
    , rejection =
        AnswerRejection
            { answers = [ 0 ]
            , reason =
                [ "Because you noted that you have a personal history of disease that might affect eyesight, we recommend that you visit a doctor for a comprehensive eye exam."
                , "An advisor can help you book an eye exam with us or find another option that’s convenient."
                ]
            , rejected = False
            }
    }


familyHistory : Question
familyHistory =
    { id = "family_history"
    , heading = "Family history"
    , subheading =
        Just [ "Do you have any parents or siblings with a history of glaucoma or high eye pressure, or hereditary retina problems, like retinitis pigmentosa?" ]
    , variant =
        Choice
            { options = Array.fromList [ "Yes", "No" ]
            , selection = Nothing
            }
    , rejection = NoRejection
    }


eyeSurgery : Question
eyeSurgery =
    { id = "eye_surgery"
    , heading = "Have you had eye surgery, including LASIK, or other refractive procedures?"
    , subheading = Nothing
    , variant =
        Choice
            { options = Array.fromList [ "Yes", "No" ]
            , selection = Nothing
            }
    , rejection =
        AnswerRejection
            { answers = [ 0 ]
            , reason =
                [ "Because you noted you have had eye surgery, we recommend that you visit a doctor for a comprehensive eye exam."
                , "An advisor can help you book an eye exam with us or find another convenient option."
                ]
            , rejected = False
            }
    }


additionalComments : Question
additionalComments =
    { id = "doctor_note"
    , heading = "Anything else you’d like the doctor to know?"
    , subheading = Nothing
    , variant =
        OptionalComment
            { comment = Nothing
            , placeholder = "Leave a note (optional)"
            , defaultCta = "Nope"
            , activeCta = "Continue"
            }
    , rejection = NoRejection
    }
