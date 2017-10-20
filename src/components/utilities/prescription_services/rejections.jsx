const React = require("react/addons");

const REJECTIONS = {
  AGE: (
    <span>
      <p>
        Unfortunately, you fall outside of the age range that we’re currently covering. The American
        Academy of Ophthalmology recommends that people who are younger than 18 or older than 50
        receive screenings for eye conditions that are not currently assessed by our service.
      </p>
      <p>
        The good news is, plenty of our stores offer eye exams. Book an appointment at a Warby
        Parker location that's convenient for you{" "}
        <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>. (If that doesn’t
        work, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.)
      </p>
    </span>
  ),

  PROGRESSIVES: (
    <span>
      <p>
        You indicated that you need near-vision correction and at the moment, our In-store
        Prescription Check service only evaluates distance-vision prescriptions.
      </p>
      <p>
        We are hard at work to accommodate more and more prescriptions. In the meantime, plenty of
        our stores offer eye exams. Book an appointment at a Warby Parker location that's convenient
        for you <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>.
      </p>
      <p>
        (If that’s not ideal, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.)
      </p>
    </span>
  ),

  EYEGLASSES: (
    <span>
      <p>
        We require eligible In-store Prescription Check users to have their past prescription
        information—whether the actual glasses or a doctor-issued prescription—on hand in order for
        our doctor to accurately review your results.
      </p>
      <p>
        Just like with a comprehensive exam, the doctor uses information about your past
        prescriptions to help determine a prescription that will be the most comfortable for you.
      </p>
      <p>
        Please come back and answer these questions again if you are able to get ahold of your
        latest prescription or current pair of glasses.
      </p>
      <p>
        In the meantime, book an eye exam at a Warby Parker location near you{" "}
        <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>. If that’s not
        convenient, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  ),

  LAST_EYE_EXAM: (
    <span>
      <p>
        We require In-store Prescription Check patients to have seen an eye doctor in person at
        least once in the past 5 years. Even if you aren’t experiencing any vision problems, it’s
        important to have your eye health checked at intervals recommended by your doctor.
      </p>
      <p>
        The good news is, you can always book an eye exam at a Warby Parker location near you{" "}
        <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>. If that’s not
        convenient, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  ),

  HEALTH: (
    <span>
      <p>
        Based on your response about your eye health history, we recommend that you visit a doctor for a comprehensive eye exam to check both your prescription and overall eye health.
      </p>
      <p>
        The good news is, plenty of our stores offer eye exams. Book an eye exam at a Warby Parker
        location near you <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>. If
        that’s not convenient, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  ),

  REDUCED_VISION: (
    <span>
      <p>
        Based on your response about your eye health history, we recommend that you visit a doctor
        for a comprehensive eye exam to check both your prescription and overall eye health.
      </p>
      <p>
        We might be able to help you out with that :) Book an eye exam at a Warby Parker location
        near you <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>. If that’s
        not convenient, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  ),

  HEALTH_HISTORY: (
    <span>
      <p>
        Because you noted that you have a history of disease that might affect eyesight, we
        recommend that you visit a doctor for a comprehensive eye exam.
      </p>
      <p>
        We might be able to help you out with that :) Book an eye exam at a Warby Parker location
        near you <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>. If that’s
        not convenient, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  ),

  SURGERY: (
    <span>
      <p>
        Because you noted that you’ve had eye surgery, we recommend that you visit a doctor for a
        comprehensive eye exam.
      </p>
      <p>
        We might be able to help you out with that :) Book an eye exam at a Warby Parker location
        near you <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>. If that’s
        not convenient, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  ),

  NO_STORES: (
    <span>
      <p>
        Unfortunately, your location isn't within our current geographic coverage (at the moment,
        In-store Prescription Check is only available in select locations due to state laws and
        regulations) and it doesn’t look like we have any stores offering eye exams near you.
      </p>
      <p>
        The good news is, we are growing and we are hard at work on reaching more states. Until
        then, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  ),

  DOWNLOAD_APP: (
    <span>
      <p>
        Unfortunately, there aren’t any Warby Parker locations offering In-store Prescription Check
        near you.
      </p>
      <p>
        However, our Prescription Check app might be *just* the solution for you. It’s our mobile
        refraction service that, if you are eligible, allows an eye doctor to assess your vision and
        provide an updated glasses prescription.
      </p>
      <p>
        Download it <a href="https://www.warbyparker.com/prescription-check-app">here</a> to see if
        you’re eligible.
      </p>
    </span>
  ),

  GET_EYE_EXAM: (
    <span>
      <p>
        Unfortunately, your location isn't within our current geographic coverage—at the moment,
        In-store Prescription Check is only available in select locations due to state laws and
        regulations—but we are hard at work on reaching more states.
      </p>
      <p>
        The good news is, a Warby Parker store near you offers eye exams (more info{" "}
        <a href="https://www.warbyparker.com/appointments/eye-exams">here</a>). If that’s not
        convenient, our friends at{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        can help you out.{" "}
        <a href="https://www.zocdoc.com/" target="_blank">
          Zocdoc
        </a>{" "}
        is a super easy way to find a doctor and book appointments online.
      </p>
    </span>
  )
};

module.exports = REJECTIONS;
