test_that("Querying player-level goals added (g+) values works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_player_goals_added() %>% nrow()
    expect_gte(.obj, 0)

    # Unnamed filters ---------------------------------------------------
    expect_error(asa_client$get_player_goals_added("abc", "def", "ghi"))

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_player_goals_added(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(player_id) %>%
        dplyr::pull(player_id)

    .obj <- asa_client$get_player_goals_added(leagues = LEAGUES) %>%
        dplyr::mutate(obj = player_id %in% .exp) %>%
        dplyr::pull(obj) %>%
        mean(na.rm = TRUE)

    expect_equal(.obj, 1)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(player_id) %>%
        dplyr::pull(player_id)

    .obj <- asa_client$get_player_goals_added(leagues = LEAGUES) %>%
        dplyr::mutate(obj = player_id %in% .exp) %>%
        dplyr::pull(obj) %>%
        mean(na.rm = TRUE)

    expect_equal(.obj, 1)

    # Minimum minutes ----------------------------------------------------
    .exp <- 1000
    .obj <- asa_client$get_player_goals_added(minimum_minutes = .exp) %>%
        dplyr::pull(minutes_played) %>%
        min()

    expect_gte(.obj, .exp)

    # Player IDs and names (invalid) -------------------------------------
    expect_error(asa_client$get_player_goals_added(player_ids = "abc", player_names = "abc"))

    # Single ID ----------------------------------------------------------
    IDS <- "vzqo8xZQap"

    .obj <- asa_client$get_player_goals_added(player_ids = IDS) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(player_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple IDs -------------------------------------------------------
    IDS <- c("vzqo8xZQap", "9vQ22BR7QK")

    .obj <- asa_client$get_player_goals_added(player_ids = IDS) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(player_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single player name -------------------------------------------------
    NAMES <- "Dax McCarty"

    .obj <- asa_client$get_player_goals_added(player_names = NAMES) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), player_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple player names ----------------------------------------------
    NAMES <- c("Dax McCarty", "Tiffany McCarty")

    .obj <- asa_client$get_player_goals_added(player_names = NAMES) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), player_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Team IDs and names (invalid) ---------------------------------------
    expect_error(asa_client$get_player_goals_added(team_ids = "abc", team_names = "abc"))

    # Single team ID -----------------------------------------------------
    IDS <- "NWMWlBK5lz"

    .obj <- asa_client$get_player_goals_added(team_ids = IDS) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple team IDs --------------------------------------------------
    IDS <- c("a2lqRX2Mr0", "9Yqdwg85vJ")

    .obj <- asa_client$get_player_goals_added(team_ids = IDS) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single team name ---------------------------------------------------
    NAMES <- "Red Bulls"

    .obj <- asa_client$get_player_goals_added(team_names = NAMES) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple team names ------------------------------------------------
    NAMES <- c("Chicago", "Seattle")

    .obj <- asa_client$get_player_goals_added(team_names = NAMES) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # TODO: Add tests for season_name
    # TODO: Add tests for date range

    # Partial date range (invalid) --------------------------------------
    expect_error(asa_client$get_player_goals_added(start_date = "abc"))

    # Invalid date range ------------------------------------------------
    expect_error(asa_client$get_player_goals_added(start_date = "2021-01-01", end_date = "2020-01-01"))

    # Season and date range (invalid) ------------------------------------
    expect_error(asa_client$get_player_goals_added(season_name = "abc", start_date = "abc"))

    # TODO: Add tests for shot_pattern
    # TODO: Add tests for split_by_teams
    # TODO: Add tests for split_by_seasons
    # TODO: Add tests for split_by_games
    # TODO: Add tests for stage_name

    # Single action type -------------------------------------------------
    .exp <- "Passing"
    .obj <- asa_client$get_player_goals_added(action_type = .exp) %>%
        tidyr::unnest(data) %>%
        dplyr::distinct(action_type) %>%
        dplyr::arrange(action_type) %>%
        dplyr::pull(action_type)

    expect_equal(.obj, .exp)

    # Multiple action types ----------------------------------------------
    .exp <- c("Passing", "Shooting")
    .obj <- asa_client$get_player_goals_added(action_type = .exp) %>%
        tidyr::unnest(data) %>%
        dplyr::distinct(action_type) %>%
        dplyr::arrange(action_type) %>%
        dplyr::pull(action_type)

    expect_equal(.obj, .exp)

    # Single position ----------------------------------------------------
    .exp <- "AM"
    .obj <- asa_client$get_player_goals_added(general_position = .exp) %>%
        dplyr::distinct(general_position) %>%
        dplyr::arrange(general_position) %>%
        dplyr::pull(general_position)

    expect_equal(.obj, .exp)

    # Multiple positions -------------------------------------------------
    .exp <- c("AM", "DM")
    .obj <- asa_client$get_player_goals_added(general_position = .exp) %>%
        dplyr::distinct(general_position) %>%
        dplyr::arrange(general_position) %>%
        dplyr::pull(general_position)

    expect_equal(.obj, .exp)

    # Above replacement --------------------------------------------------
    .exp <- "goals_added_above_replacement"
    .obj <- asa_client$get_player_goals_added(above_replacement = TRUE) %>%
        dplyr::select(dplyr::ends_with("above_replacement")) %>%
        names()

    expect_equal(.obj, .exp)

})

test_that("Querying goalkeeper-level goals added (g+) values works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_goalkeeper_goals_added() %>% nrow()
    expect_gte(.obj, 0)

    # Unnamed filters ---------------------------------------------------
    expect_error(asa_client$get_goalkeeper_goals_added("abc", "def", "ghi"))

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_goalkeeper_goals_added(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(player_id) %>%
        dplyr::pull(player_id)

    .obj <- asa_client$get_goalkeeper_goals_added(leagues = LEAGUES) %>%
        dplyr::mutate(obj = player_id %in% .exp) %>%
        dplyr::pull(obj) %>%
        mean(na.rm = TRUE)

    expect_equal(.obj, 1)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .exp <- asa_client$players %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(player_id) %>%
        dplyr::pull(player_id)

    .obj <- asa_client$get_goalkeeper_goals_added(leagues = LEAGUES) %>%
        dplyr::mutate(obj = player_id %in% .exp) %>%
        dplyr::pull(obj) %>%
        mean(na.rm = TRUE)

    expect_equal(.obj, 1)

    # Minimum minutes ----------------------------------------------------
    .exp <- 1000
    .obj <- asa_client$get_goalkeeper_goals_added(minimum_minutes = .exp) %>%
        dplyr::pull(minutes_played) %>%
        min()

    expect_gte(.obj, .exp)

    # Player IDs and names (invalid) -------------------------------------
    expect_error(asa_client$get_goalkeeper_goals_added(player_ids = "abc", player_names = "abc"))

    # Single player ID ---------------------------------------------------
    IDS <- "vzqoWbkqap"

    .obj <- asa_client$get_goalkeeper_goals_added(player_ids = IDS) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(player_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple player IDs ------------------------------------------------
    IDS <- c("vzqoWbkqap", "gOMn6OlmMw")

    .obj <- asa_client$get_goalkeeper_goals_added(player_ids = IDS) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(player_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single player name -------------------------------------------------
    NAMES <- "Luis Robles"

    .obj <- asa_client$get_goalkeeper_goals_added(player_names = NAMES) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), player_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple player names ----------------------------------------------
    NAMES <- c("Luis Robles", "Ryan Meara")

    .obj <- asa_client$get_goalkeeper_goals_added(player_names = NAMES) %>%
        dplyr::distinct(player_id) %>%
        nrow()

    .exp <- asa_client$players %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), player_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Team IDs and names (invalid) ---------------------------------------
    expect_error(asa_client$get_goalkeeper_goals_added(team_ids = "abc", team_names = "abc"))

    # Single team ID -----------------------------------------------------
    IDS <- "NWMWlBK5lz"

    .obj <- asa_client$get_goalkeeper_goals_added(team_ids = IDS) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple team IDs --------------------------------------------------
    IDS <- c("a2lqRX2Mr0", "9Yqdwg85vJ")

    .obj <- asa_client$get_goalkeeper_goals_added(team_ids = IDS) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single team name ---------------------------------------------------
    NAMES <- "Red Bulls"

    .obj <- asa_client$get_goalkeeper_goals_added(team_names = NAMES) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple team names ------------------------------------------------
    NAMES <- c("Chicago", "Seattle")

    .obj <- asa_client$get_goalkeeper_goals_added(team_names = NAMES) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # TODO: Add tests for season_name
    # TODO: Add tests for date range

    # Partial date range (invalid) --------------------------------------
    expect_error(asa_client$get_goalkeeper_goals_added(start_date = "abc"))

    # Invalid date range ------------------------------------------------
    expect_error(asa_client$get_goalkeeper_goals_added(start_date = "2021-01-01", end_date = "2020-01-01"))

    # Season and date range (invalid) ------------------------------------
    expect_error(asa_client$get_goalkeeper_goals_added(season_name = "abc", start_date = "abc"))

    # TODO: Add tests for split_by_teams
    # TODO: Add tests for split_by_seasons
    # TODO: Add tests for split_by_games
    # TODO: Add tests for stage_name

    # Single action type -------------------------------------------------
    .exp <- "Shotstopping"
    .obj <- asa_client$get_goalkeeper_goals_added(action_type = .exp) %>%
        tidyr::unnest(data) %>%
        dplyr::distinct(action_type) %>%
        dplyr::arrange(action_type) %>%
        dplyr::pull(action_type)

    expect_equal(.obj, .exp)

    # Multiple action types ----------------------------------------------
    .exp <- c("Shotstopping", "Sweeping")
    .obj <- asa_client$get_goalkeeper_goals_added(action_type = .exp) %>%
        tidyr::unnest(data) %>%
        dplyr::distinct(action_type) %>%
        dplyr::arrange(action_type) %>%
        dplyr::pull(action_type)

    expect_equal(.obj, .exp)

    # Above replacement --------------------------------------------------
    .exp <- "goals_added_above_replacement"
    .obj <- asa_client$get_goalkeeper_goals_added(above_replacement = TRUE) %>%
        dplyr::select(dplyr::ends_with("above_replacement")) %>%
        names()

    expect_equal(.obj, .exp)

})

test_that("Querying team-level goals added (g+) values works properly", {

    # TODO: Move all these tests into the API codebase and mock what's below
    skip_on_cran()
    skip_on_ci()

    # No filters ---------------------------------------------------------
    .obj <- asa_client$get_team_goals_added() %>% nrow()
    expect_gte(.obj, 0)

    # Unnamed filters ---------------------------------------------------
    expect_error(asa_client$get_team_goals_added("abc", "def", "ghi"))

    # Invalid league -----------------------------------------------------
    expect_error(asa_client$get_team_goals_added(leagues = "abc"))

    # Single league ------------------------------------------------------
    LEAGUES <- "mls"

    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(team_id) %>%
        dplyr::pull(team_id)

    .obj <- asa_client$get_team_goals_added(leagues = LEAGUES) %>%
        dplyr::mutate(obj = team_id %in% .exp) %>%
        dplyr::pull(obj) %>%
        mean(na.rm = TRUE)

    expect_lte(.obj, 1)

    # Multiple leagues ---------------------------------------------------
    LEAGUES <- c("mls", "uslc")

    .exp <- asa_client$teams %>%
        tidyr::unnest(competitions) %>%
        dplyr::filter(competitions %in% LEAGUES) %>%
        dplyr::distinct(team_id) %>%
        dplyr::pull(team_id)

    .obj <- asa_client$get_team_goals_added(leagues = LEAGUES) %>%
        dplyr::mutate(obj = team_id %in% .exp) %>%
        dplyr::pull(obj) %>%
        mean(na.rm = TRUE)

    expect_lte(.obj, 1)

    # Team IDs and names (invalid) ---------------------------------------
    expect_error(asa_client$get_team_goals_added(team_ids = "abc", team_names = "abc"))

    # Single team ID -----------------------------------------------------
    IDS <- "NWMWlBK5lz"

    .obj <- asa_client$get_team_goals_added(team_ids = IDS) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple team IDs --------------------------------------------------
    IDS <- c("a2lqRX2Mr0", "9Yqdwg85vJ")

    .obj <- asa_client$get_team_goals_added(team_ids = IDS) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(team_id %in% IDS) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Single team name ---------------------------------------------------
    NAMES <- "Red Bulls"

    .obj <- asa_client$get_team_goals_added(team_names = NAMES) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # Multiple team names ------------------------------------------------
    NAMES <- c("Chicago", "Seattle")

    .obj <- asa_client$get_team_goals_added(team_names = NAMES) %>%
        tidyr::unnest(team_id) %>%
        dplyr::distinct(team_id) %>%
        nrow()

    .exp <- asa_client$teams %>%
        dplyr::filter(grepl(paste0(NAMES, collapse = "|"), team_name)) %>%
        nrow()

    expect_equal(.obj, .exp)

    # TODO: Add tests for season_name
    # TODO: Add tests for split_by_seasons
    # TODO: Add tests for stage_name

    # Single action type -------------------------------------------------
    .exp <- "Passing"
    .obj <- asa_client$get_team_goals_added(action_type = .exp) %>%
        tidyr::unnest(data) %>%
        dplyr::distinct(action_type) %>%
        dplyr::arrange(action_type) %>%
        dplyr::pull(action_type)

    expect_equal(.obj, .exp)

    # Multiple action types ----------------------------------------------
    .exp <- c("Passing", "Shooting")
    .obj <- asa_client$get_team_goals_added(action_type = .exp) %>%
        tidyr::unnest(data) %>%
        dplyr::distinct(action_type) %>%
        dplyr::arrange(action_type) %>%
        dplyr::pull(action_type)

    expect_equal(.obj, .exp)

    # TODO: Add tests for zone
    # TODO: Add tests for gamestate_trunc

})
