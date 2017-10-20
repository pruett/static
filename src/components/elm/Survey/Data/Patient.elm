module Survey.Data.Patient exposing (..)

import Json.Encode as Encode


type alias Details =
    { firstName : Maybe String
    , lastName : Maybe String
    , email : Maybe String
    , phone : Maybe String
    , agreeToTerms : Bool
    }


type Input
    = FirstName
    | LastName
    | Email
    | Phone


returnMaybeInput : String -> Maybe String
returnMaybeInput val =
    if String.isEmpty val then
        Nothing
    else
        Just val


updateInput : Input -> String -> Details -> Details
updateInput inputType value details =
    case inputType of
        FirstName ->
            { details | firstName = returnMaybeInput value }

        LastName ->
            { details | lastName = returnMaybeInput value }

        Email ->
            { details | email = returnMaybeInput value }

        Phone ->
            { details | phone = returnMaybeInput value }


updateAgreeToTerms : Bool -> Details -> Details
updateAgreeToTerms checked details =
    { details | agreeToTerms = checked }


points : List String
points =
    [ "Your Prescription Check. Prescription Check is intended only to measure your refractive error and serve as a tool for a licensed eye doctor to determine a prescription for corrective eyewear. It is not a comprehensive eye examination and does not test for any abnormalities, diseases, or risk factors of disease. It is recommended that you receive a full, comprehensive eye examination at intervals recommended by your doctor."
    , "Information we collect. \"Health Information\" is information that relates to your past and present physical health or condition, medications, and ailments. “Personal Information” is information about you, including your first name, last name, and demographic information. As part of your Prescription Check, Warby Parker will collect Personal Information and Health Information that you submit or that is derived as part of the Prescription Check in order to determine your need for, and our ability to issue, a prescription for corrective eyewear."
    , "How we share your information. Warby Parker will share your Health Information and Personal Information with one or more licensed optometrists or ophthalmologists, who will evaluate the results of your Prescription Check. These eye doctors may or may not be Warby Parker employees, but they have an obligation to keep your information confidential. Your eye doctor, solely in his or her medical judgment, will determine whether to issue you a prescription for corrective eyewear or whether to recommend that you receive a comprehensive eye exam."
    , "How we use your information. We may use your Health Information and Personal Information for quality assurance activities, and to provide customer service to you. We may also use your information to respond to your questions, remind you to renew your prescription, or recommend that you receive a comprehensive eye exam. We will not license or sell your information to anyone. Warby Parker will comply with all laws and regulations applicable to the use and disclosure of your Health Information and Personal Information."
    , "Prescriptions. If your eye doctor issues you a prescription for corrective eyewear, Warby Parker will email a copy of your prescription to you at the email address that you have provided. It is your right to use that prescription to purchase eyeglasses from anywhere you’d like!"
    , "Telemedicine. Your Prescription Check is a form of telemedicine, which involves the use of electronic communications by healthcare providers to consult with and provide medical services to patients remotely. We think that telemedicine has the potential to provide a number of benefits, such as more efficient medical evaluation and management. Another potential benefit is improved access to medical care, since telemedicine enables patients to consult healthcare providers (and even obtain expertise of a distant specialist) from their current locations. However, as with any medical services, there are potential risks associated with the use of telemedicine. Delays in evaluation or treatment could occur due to deficiencies or failures of the electronic equipment and, in rare instances, security protocols could fail, causing a breach of privacy of Health Information and Personal Information.  Additionally, limitations in the technology, lack of access to complete medical records, and the nature of telemedicine may restrict a healthcare provider’s ability to diagnose and treat certain conditions."
    ]


terms : List String
terms =
    [ "confirm that you have read, understand, and consent to the Prescription Check services and the terms of this Privacy and Informed Consent Notice"
    , "confirm that all information that you have provided to Warby Parker and the licensed eye doctors is truthful and accurate"
    , "confirm that you are 18 years of age or older"
    , "understand and agree that Warby Parker may send you the results of your Prescription Check at the email address provided to Warby Parker and that Warby Parker may provide a prescription (if any) as an email attachment"
    , "understand that Warby Parker may use your Health Information and Personal Information as described in this Privacy and Informed Consent Notice"
    , "understand the risks and benefits of telemedicine, and that you may expect the anticipated benefits from the use of telemedicine in your care but that no results can be guaranteed"
    ]


info : Details -> Encode.Value
info details =
    let
        { firstName, lastName, email, phone, agreeToTerms } =
            details
    in
        Encode.object
            [ ( "first_name", Encode.string <| Maybe.withDefault "" firstName )
            , ( "last_name", Encode.string <| Maybe.withDefault "" lastName )
            , ( "email", Encode.string <| Maybe.withDefault "" email )
            , ( "phone", Encode.string <| Maybe.withDefault "" phone )
            , ( "agree_to_terms", Encode.bool agreeToTerms )
            , ( "source", Encode.string "kiosk" )
            ]
