test_that("Filtering players works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_players() %>% nrow()
    .exp <- asa_client$players %>% nrow()

    expect_equal(.obj, .exp)

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_players(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .obj <- asa_client$get_players(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .obj <- asa_client$get_players(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # IDs and names (invalid) --------------------------------------------
    expect_error(asa_client$get_players(ids = "abc", names = "abc"))

    # Single ID ----------------------------------------------------------
    IDS <- "vzqo8xZQap"

    .obj <- asa_client$get_players(ids = IDS) %>% nrow()
    .exp <- asa_client$players %>% dplyr::filter(player_id %in% IDS) %>% nrow()

    expect_equal(.obj, .exp)

    # Multiple IDs -------------------------------------------------------
    IDS <- c("vzqo8xZQap", "9vQ22BR7QK")

    .obj <- asa_client$get_players(ids = IDS) %>% nrow()
    .exp <- asa_client$players %>% dplyr::filter(player_id %in% IDS) %>% nrow()

    expect_equal(.obj, .exp)

    # Single name --------------------------------------------------------
    NAMES <- "Dax McCarty"

    .obj <- asa_client$get_players(names = NAMES) %>% nrow()
    .exp <- asa_client$players %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), player_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple names -----------------------------------------------------
    NAMES <- c("Dax McCarty", "Tiffany McCarty")

    .obj <- asa_client$get_players(names = NAMES) %>% nrow()
    .exp <- asa_client$players %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), player_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and IDs ----------------------------------------------------
    LEAGUES <- "mls"
    IDS <- c("p6qbedyp50", "9z5kagOjQA")

    .obj <- asa_client$get_players(leagues = LEAGUES, ids = IDS) %>% nrow()
    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      player_id %in% IDS) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and names --------------------------------------------------
    LEAGUES <- "mls"
    NAMES <- "Wright-Phillips"

    .obj <- asa_client$get_players(leagues = LEAGUES, names = NAMES) %>% nrow()
    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      grepl(paste0(NAMES, collapse = "|"), player_name)) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    expect_equal(.obj, .exp)

})

test_that("Filtering teams works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_teams() %>% nrow()
    .exp <- asa_client$teams %>% nrow()

    expect_equal(.obj, .exp)

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_teams(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .obj <- asa_client$get_teams(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .obj <- asa_client$get_teams(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # IDs and names (invalid) --------------------------------------------
    expect_error(asa_client$get_teams(ids = "abc", names = "abc"))

    # Single ID ----------------------------------------------------------
    IDS <- "NWMWlBK5lz"

    .obj <- asa_client$get_teams(ids = IDS) %>% nrow()
    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple IDs -------------------------------------------------------
    IDS <- c("a2lqRX2Mr0", "9Yqdwg85vJ")

    .obj <- asa_client$get_teams(ids = IDS) %>% nrow()
    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single name --------------------------------------------------------
    NAMES <- "Red Bulls"

    .obj <- asa_client$get_teams(names = NAMES) %>% nrow()
    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple names -----------------------------------------------------
    NAMES <- c("Chicago", "Seattle")

    .obj <- asa_client$get_teams(names = NAMES) %>% nrow()
    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and IDs ----------------------------------------------------
    LEAGUES <- "mls"
    IDS <- c("a2lqRX2Mr0", "9Yqdwg85vJ")

    .obj <- asa_client$get_teams(leagues = LEAGUES, ids = IDS) %>% nrow()
    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      team_id %in% IDS) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and names --------------------------------------------------
    LEAGUES <- "mls"
    NAMES <- "Chicago"

    .obj <- asa_client$get_teams(leagues = LEAGUES, names = NAMES) %>% nrow()
    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    expect_equal(.obj, .exp)

})

test_that("Filtering stadia works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_stadia() %>% nrow()
    .exp <- asa_client$stadia %>% nrow()

    expect_equal(.obj, .exp)

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_stadia(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .obj <- asa_client$get_stadia(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$stadia %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .obj <- asa_client$get_stadia(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$stadia %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(stadium_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # IDs and names (invalid) --------------------------------------------
    expect_error(asa_client$get_stadia(ids = "abc", names = "abc"))

    # Single ID ----------------------------------------------------------
    IDS <- "Vj58BPwQ8n"

    .obj <- asa_client$get_stadia(ids = IDS) %>% nrow()
    .exp <- asa_client$stadia %>%
        dplyr::filter(stadium_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple IDs -------------------------------------------------------
    IDS <- c("Vj58BPwQ8n", "4JMALEDQKg")

    .obj <- asa_client$get_stadia(ids = IDS) %>% nrow()
    .exp <- asa_client$stadia %>%
        dplyr::filter(stadium_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single name --------------------------------------------------------
    NAMES <- "Toyota"

    .obj <- asa_client$get_stadia(names = NAMES) %>% nrow()
    .exp <- asa_client$stadia %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), stadium_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple names -----------------------------------------------------
    NAMES <- c("Buck Shaw", "Yankee")

    .obj <- asa_client$get_stadia(names = NAMES) %>% nrow()
    .exp <- asa_client$stadia %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), stadium_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and IDs ----------------------------------------------------
    LEAGUES <- "mls"
    IDS <- c("Vj58BPwQ8n", "4JMALEDQKg")

    .obj <- asa_client$get_stadia(leagues = LEAGUES, ids = IDS) %>% nrow()
    .exp <- asa_client$stadia %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      stadium_id %in% IDS) %>%
        dplyr::distinct(stadium_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and names --------------------------------------------------
    LEAGUES <- "mls"
    NAMES <- "Buck Shaw"

    .obj <- asa_client$get_stadia(leagues = LEAGUES, names = NAMES) %>% nrow()
    .exp <- asa_client$stadia %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      grepl(paste0(NAMES, collapse = "|"), stadium_name)) %>%
        dplyr::distinct(stadium_id) %>%
        nrow()

    expect_equal(.obj, .exp)

})

test_that("Filtering managers works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_managers() %>% nrow()
    .exp <- asa_client$managers %>% nrow()

    expect_equal(.obj, .exp)

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_managers(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .obj <- asa_client$get_managers(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$managers %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .obj <- asa_client$get_managers(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$managers %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(manager_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # IDs and names (invalid) --------------------------------------------
    expect_error(asa_client$get_managers(ids = "abc", names = "abc"))

    # Single ID ----------------------------------------------------------
    IDS <- "LeVq3j5WOJ"

    .obj <- asa_client$get_managers(ids = IDS) %>% nrow()
    .exp <- asa_client$managers %>%
        dplyr::filter(manager_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple IDs -------------------------------------------------------
    IDS <- c("LeVq3j5WOJ", "0Oq6zkzq6D")

    .obj <- asa_client$get_managers(ids = IDS) %>% nrow()
    .exp <- asa_client$managers %>%
        dplyr::filter(manager_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single name --------------------------------------------------------
    NAMES <- "Bruce"

    .obj <- asa_client$get_managers(names = NAMES) %>% nrow()
    .exp <- asa_client$managers %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), manager_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple names -----------------------------------------------------
    NAMES <- c("Bruce", "Bob")

    .obj <- asa_client$get_managers(names = NAMES) %>% nrow()
    .exp <- asa_client$managers %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), manager_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and IDs ----------------------------------------------------
    LEAGUES <- "mls"
    IDS <- c("LeVq3j5WOJ", "0Oq6zkzq6D")

    .obj <- asa_client$get_managers(leagues = LEAGUES, ids = IDS) %>% nrow()
    .exp <- asa_client$managers %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      manager_id %in% IDS) %>%
        dplyr::distinct(manager_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and names --------------------------------------------------
    LEAGUES <- "mls"
    NAMES <- "Bruce"

    .obj <- asa_client$get_managers(leagues = LEAGUES, names = NAMES) %>% nrow()
    .exp <- asa_client$managers %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      grepl(paste0(NAMES, collapse = "|"), manager_name)) %>%
        dplyr::distinct(manager_id) %>%
        nrow()

    expect_equal(.obj, .exp)

})

test_that("Filtering referees works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_referees() %>% nrow()
    .exp <- asa_client$referees %>% nrow()

    expect_equal(.obj, .exp)

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_referees(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .obj <- asa_client$get_referees(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$referees %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .obj <- asa_client$get_referees(leagues = LEAGUES) %>% nrow()
    .exp <- asa_client$referees %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(referee_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # IDs and names (invalid) --------------------------------------------
    expect_error(asa_client$get_referees(ids = "abc", names = "abc"))

    # Single ID ----------------------------------------------------------
    IDS <- "a35r6KG5L6"

    .obj <- asa_client$get_referees(ids = IDS) %>% nrow()
    .exp <- asa_client$referees %>%
        dplyr::filter(referee_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple IDs -------------------------------------------------------
    IDS <- c("a35r6KG5L6", "0Oq6037M6D")

    .obj <- asa_client$get_referees(ids = IDS) %>% nrow()
    .exp <- asa_client$referees %>%
        dplyr::filter(referee_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single name --------------------------------------------------------
    NAMES <- "Geiger"

    .obj <- asa_client$get_referees(names = NAMES) %>% nrow()
    .exp <- asa_client$referees %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), referee_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple names -----------------------------------------------------
    NAMES <- c("Geiger", "Kelly")

    .obj <- asa_client$get_referees(names = NAMES) %>% nrow()
    .exp <- asa_client$referees %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), referee_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and IDs ----------------------------------------------------
    LEAGUES <- "mls"
    IDS <- c("a35r6KG5L6", "0Oq6037M6D")

    .obj <- asa_client$get_referees(leagues = LEAGUES, ids = IDS) %>% nrow()
    .exp <- asa_client$referees %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      referee_id %in% IDS) %>%
        dplyr::distinct(referee_id) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Leagues and names --------------------------------------------------
    LEAGUES <- "mls"
    NAMES <- "Geiger"

    .obj <- asa_client$get_referees(leagues = LEAGUES, names = NAMES) %>% nrow()
    .exp <- asa_client$referees %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES,
                      grepl(paste0(NAMES, collapse = "|"), referee_name)) %>%
        dplyr::distinct(referee_id) %>%
        nrow()

    expect_equal(.obj, .exp)

})

test_that("Querying games works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_games() %>% nrow()
    .exp <- asa_client$get_games(leagues = asa_client$LEAGUES) %>% nrow()

    expect_gt(.obj, 0)
    expect_equal(.obj, .exp)

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_games(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .obj <- asa_client$get_games(leagues = LEAGUES) %>%
        dplyr::select("game_id", "home_team_id", "away_team_id") %>%
        tidyr::pivot_longer(cols = dplyr::ends_with("team_id"), values_to = "team_id") %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    expect_lte(.obj, .exp)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .obj <- asa_client$get_games(leagues = LEAGUES) %>%
        dplyr::select("game_id", "home_team_id", "away_team_id") %>%
        tidyr::pivot_longer(cols = dplyr::ends_with("team_id"), values_to = "team_id") %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    expect_lte(.obj, .exp)

    # Single game ID -----------------------------------------------------
    IDS <- "9z5kdxgKqA"

    .obj <- asa_client$get_games(game_ids = IDS) %>% nrow()
    expect_equal(.obj, 1)

    # Multiple game IDs --------------------------------------------------
    IDS <- c("9z5kdxgKqA", "9z5kAnbPQA")

    .obj <- asa_client$get_games(game_ids = IDS) %>% nrow()
    expect_equal(.obj, 2)

    # Team IDs and names (invalid) ---------------------------------------
    expect_error(asa_client$get_games(team_ids = "abc", team_names = "abc"))

    # Single team ID -----------------------------------------------------
    IDS <- "Vj58weDM8n"

    .obj <- asa_client$get_games(team_ids = IDS) %>% nrow()
    .exp <- asa_client$get_games(team_ids = IDS) %>%
        dplyr::filter(home_team_id %in% IDS | away_team_id %in% IDS) %>%
        nrow()

    expect_gt(.obj, 0)
    expect_equal(.obj, .exp)

    # Multiple team IDs --------------------------------------------------
    IDS <- c("Vj58weDM8n", "9Yqdwg85vJ")

    .obj <- asa_client$get_games(team_ids = IDS) %>% nrow()
    .exp <- asa_client$get_games(team_ids = IDS) %>%
        dplyr::filter(home_team_id %in% IDS | away_team_id %in% IDS) %>%
        nrow()

    expect_gt(.obj, 0)
    expect_equal(.obj, .exp)

    # Single team name ---------------------------------------------------
    NAMES <- "Red Bulls"

    .obj <- asa_client$get_games(team_names = NAMES) %>% nrow()
    .exp <- asa_client$get_games(team_names = NAMES) %>%
        dplyr::filter(home_team_id %in% .convert_names_to_ids(asa_client$teams, NAMES) |
                          away_team_id %in% .convert_names_to_ids(asa_client$teams, NAMES)) %>%
        nrow()

    expect_gt(.obj, 0)
    expect_equal(.obj, .exp)

    # Multiple team names ------------------------------------------------
    NAMES <- c("Chicago", "Seattle")

    .obj <- asa_client$get_games(team_names = NAMES) %>% nrow()
    .exp <- asa_client$get_games(team_names = NAMES) %>%
        dplyr::filter(home_team_id %in% .convert_names_to_ids(asa_client$teams, NAMES) |
                          away_team_id %in% .convert_names_to_ids(asa_client$teams, NAMES)) %>%
        nrow()

    expect_gt(.obj, 0)
    expect_equal(.obj, .exp)

    # Single season ------------------------------------------------------
    SEASONS <- 2020

    .obj <- asa_client$get_games(seasons = SEASONS) %>% nrow()
    .exp <- asa_client$get_games(seasons = SEASONS) %>%
        dplyr::filter(season_name %in% SEASONS) %>%
        nrow()

    expect_gt(.obj, 0)
    expect_equal(.obj, .exp)

    # Multiple seasons ---------------------------------------------------
    SEASONS <- 2020:2021

    .obj <- asa_client$get_games(seasons = SEASONS) %>% nrow()
    .exp <- asa_client$get_games(seasons = SEASONS) %>%
        dplyr::filter(season_name %in% SEASONS) %>%
        nrow()

    expect_gt(.obj, 0)
    expect_equal(.obj, .exp)

    # TODO: Add tests for stages

})
