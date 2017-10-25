Handlers
========

Map of Handler names to require path. Require path should be relative to
the current directory.

We don't just `require` the handlers here because a Grunt task uses this
file to generate routes and doesn't have access to the entire environment.

    module.exports =

Default
-------

      Default:              'default_handler'

Cart
--------

      Cart:                 'cart/cart_handler'

Checkout
--------

      Checkout:                 'checkout/checkout_handler'
      CheckoutConfirmation:     'checkout/checkout_confirmation_handler'
      CheckoutConnectAccounts:  'checkout/checkout_connect_accounts_handler'
      CheckoutFAQ:              'checkout/checkout_faq_handler'
      CheckoutIndex:            'checkout/checkout_index_handler'
      CheckoutLogin:            'checkout/checkout_login_handler'

Customer Center
---------------

      AccountAddresses:     'account/account_addresses_handler'
      AccountBookmarks:     'account/account_bookmarks_handler'
      AccountDashboard:     'account/account_dashboard_handler'
      AccountFavorites:     'account/account_favorites_handler'
      AccountOrders:        'account/account_orders_handler'
      AccountPrescriptions: 'account/account_dashboard_handler'
      AccountProfile:       'account/account_profile_handler'

Products
--------

      EditionsDetail:       'products/editions/editions_detail_handler'
      EditionsGallery:      'products/editions/editions_gallery_handler'
      FrameDetail:          'products/frames/frame_detail_handler'
      FrameGallery:         'products/frames/frame_gallery_handler'
      GiftCard:             'products/gift_card_handler'

Collections
-----------

      AmandaDeCadenet:      'collections/amanda_de_cadenet_handler'
      Archive:              'collections/archive_handler'
      BirthdayForm:         'collections/birthday_form_handler'
      BirthdayPrizes:       'collections/birthday_prizes_handler'
      Concentric:           'collections/concentric_collection_handler'
      Fall2015:             'collections/fall_2015_handler'
      Fall2016Basso:        'collections/fall_2016/basso_handler'
      Fall2016FallPalette:  'collections/fall_2016/fall_palette_handler'
      Fall2016MixedMedia:   'collections/fall_2016/mixed_media_handler'
      Fall2016Sun:          'collections/fall_2016/sun_handler'
      Fall2016TwoTone:      'collections/fall_2016/two_tone_handler'
      Fall2017:             'collections/fall_2017_handler'
      FlashMirrored:        'collections/flash_mirrored_handler'
      HaskellFlash:         'collections/haskell_flash_handler'
      Killscreen:           'collections/killscreen_handler'
      LeithClark:           'collections/leith_clark_handler'
      Metal:                'collections/metal_handler'
      MixedMaterials:       'collections/mixed_materials_handler'
      OffWhite:             'collections/off_white_handler'
      Rauschenberg:         'collections/rauschenberg_handler'
      Resort:               'collections/resort_handler'
      SculptedSeries:       'collections/sculpted_series_handler'
      Spring2016:           'collections/spring_2016_handler'
      Spring2017:           'collections/spring_2017_handler'
      Summer2016:           'collections/summer_2016_handler'
      Summer2017:           'collections/summer_2017_handler'
      Sunscapades:          'collections/sunscapades_handler'
      TylerOakley:          'collections/tyler_oakley_handler'
      Winter2015:           'collections/winter_2015_handler'
      Winter2016:           'collections/winter_2016_handler'
      Winter2017:           'collections/winter_2017_handler'

Eligibility Survey
-------

      EligibilitySurvey:    'eligibility_survey_handler'

Landing
-------

      AppLanding:           'landing/app_landing_handler'
      ConnectAccounts:      'connect_accounts_handler'
      CostumeCouncil:       'landing/costume_council_handler'
      GiftGuide:            'landing/gift_guide_handler'
      Glossary:             'landing/glossary_handler'
      Holiday:              'landing/holiday_handler'
      Home:                 'home_handler'
      Insurance:            'landing/insurance_handler'
      IntakeForm:           'landing/intake_form_handler'
      LandingPage:          'landing/landing_page_handler'
      LensesLanding:        'landing/lenses_landing_handler'
      Login:                'login_handler'
      LowBridgeFit:         'landing/low_bridge_fit_handler'
      PrescriptionCheck:    'landing/prescription_check_handler'
      PrescriptionServices: 'landing/prescription_services_handler'
      SeeSummerBetter:      'landing/see_summer_better_handler'
      PrescriptionHowTo:    'landing/prescription_how_to_handler'

PD
-------

      Pd:      'pd/pd_handler'

Quiz
----

      Quiz:                 'quiz/quiz_handler'
      QuizResults:          'quiz/quiz_results_handler'

Retail
------

      Appointment:          'appointments/appointment_handler'
      EyeExams:             'appointments/eye_exams_handler'
      Locations:            'locations/locations_handler'

Jobs
------

      Jobs:                 'jobs/jobs_handler'

Static
------

      Accessibility:            'static/accessibility_handler'
      AnnualReport2014:         'static/annual_report_2014_handler'
      Eyeglasses:               'static/eyeglasses_handler'
      GeneralElectric:          'static/general_electric_handler'
      FlexibleSpendingAccounts: 'static/flexible_spending_accounts_handler'
      Help:                     'static/help_handler'
      HomeTryOn:                'static/home_try_on_handler'
      Legacy:                   'static/legacy_handler'
      PrivacyPolicy:            'static/privacy_policy_handler'
      SolarEclipse:             'static/solar_eclipse_handler'
      Sunglasses:               'static/sunglasses_handler'
      TermsOfUse:               'static/terms_of_use_handler'
      YearInReview2014:         'static/year_in_review_2014_handler'
      KillScreenKiosk:          'static/killscreen_kiosk_handler'
      BuyAPairGiveAPair:        'static/buy_a_pair_give_a_pair_handler'
