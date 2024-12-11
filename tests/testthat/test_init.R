test_that("AmericanSoccerAnalysis class initializes successfully", {

    # API version in base url --------------------------------------------
    base_url_api_version <- gsub("^.*/", "", asa_client$base_url) %>% as.character()
    expect_equal(base_url_api_version, asa_client$API_VERSION)

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # Entity tables exist ------------------------------------------------
    for (type in ENTITY_TYPES) {
        expect_s3_class(asa_client[[type]], "data.frame")
    }

    # Entity tables populated with data from all leagues -----------------
    .exp <- length(asa_client$LEAGUES)

    for (type in ENTITY_TYPES) {
        .obj <- asa_client[[type]] %>%
            tidyr::unnest(competitions) %>%
            dplyr::distinct(competitions) %>%
            nrow()

        expect_equal(.obj, .exp)
    }

})
