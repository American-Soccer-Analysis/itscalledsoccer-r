# itscalledsoccer <img src="man/figures/logo.png" align="right" height="175" style="height: 175px;"/>

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/itscalledsoccer)](https://CRAN.R-project.org/package=itscalledsoccer)
[![R-CMD-check](https://github.com/American-Soccer-Analysis/itscalledsoccer-r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/American-Soccer-Analysis/itscalledsoccer-r/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/American-Soccer-Analysis/itscalledsoccer-r/branch/main/graph/badge.svg?token=TNXUHQDSC9)](https://app.codecov.io/gh/American-Soccer-Analysis/itscalledsoccer-r?branch=main)
<!-- badges: end -->

## Overview

`itscalledsoccer` is a wrapper around the same API that powers the [American Soccer Analysis app](https://app.americansocceranalysis.com/). It enables R users to programmatically retrieve advanced analytics for their favorite players and teams, with coverage of the following competitions: 

- Major League Soccer
- National Women's Soccer League
- USL Championship
- USL League One
- USL Super League
- MLS NEXT Pro
- North American Soccer League (defunct)

## Installation

```r
# Install release version from CRAN
install.packages("itscalledsoccer")

# Install development version from GitHub
devtools::install_github("American-Soccer-Analysis/itscalledsoccer-r")
```

## Getting Started

Initialize the main class with the `new` method.

```r
asa_client <- AmericanSoccerAnalysis$new()
```

If you're in an environment where a proxy server is required, or if you need to need to alter any other `CURL` options, you can pass any number of [`httr` configs](https://www.rdocumentation.org/packages/httr/versions/1.4.2/topics/config) when initializing the class. Use these at your own discretion.

```r
asa_client <- AmericanSoccerAnalysis$new(
    httr::config(ssl_verifypeer = 0L),
    httr::use_proxy("64.251.21.73", 8080)
)
```

## Usage

Any of the `get_*` methods can be used to retrieve the same data made available in the [American Soccer Analysis app](https://app.americansocceranalysis.com/). Partial matches or abbreviations are accepted for any player or team names. For most methods, arguments _must be named_. Additionally, dataframes of complete players, teams, games, and more are also available for joining additional information. A variety of examples are below, and full documentation can be found via the CRAN documentation, linked above and [here](https://cran.r-project.org/web/packages/itscalledsoccer/itscalledsoccer.pdf).

```r
# Initialize the main class
asa_client <- AmericanSoccerAnalysis$new()
```

```r
# Access dataframes of games, players, teams, and more from the ASA client object created above
all_games <- asa_client$games
all_teams <- asa_client$teams
all_players <- asa_client$players

# see league options
asa_client$LEAGUES
```

```r
# Get all players named "Dax"
dax_players <- asa_client$get_players(names = "Dax")
```

```r
# Get cumulative player shot information (i.e., xgoals) from the NWSL over three seasons
# see other parameters in package documentation
asa_xgoals <- asa_client$get_player_xgoals(
    leagues = "nwsl", 
    season_name = c(2021:2023), 
    split_by_seasons = FALSE)
head(shots_df)
```

```r
# Get season-by-season shot information (i.e., xgoals) for all players named "Dax" in MLS
asa_xgoals <- asa_client$get_player_xgoals(
    leagues = "mls",
    player_names = "Dax",
    split_by_seasons = TRUE
)

# Join player names
library(dplyr)
asa_xgoals <- asa_xgoals %>%
    left_join(all_players,
              by = "player_id")
```

```r
# Get player passing information (i.e., xpass) from MLS in 2023
asa_xpass <- asa_client$get_player_xpass(
    leagues = "mls", 
    season_name = 2023)

# Get cumulative/career xPass data for all USL League One teams
asa_xpass <- asa_client$get_team_xpass(
    leagues = "usl1"
)
```

```r
# Get team g+ information (i.e., goals added) from MLS
library(tidyr)

# tall version
asa_goals_added <- asa_client$get_team_goals_added(
    leagues = "mls", 
    season_name = 2023) %>%
    tidyr::unnest(data)

# wide version
asa_goals_added <- asa_client$get_team_goals_added(
    leagues = "mls", 
    season_name = 2023) %>%
    tidyr::unnest(data) %>%
    tidyr::pivot_wider( id_cols = team_id, 
                        names_from = action_type, 
                        values_from = c(num_actions_for:goals_added_against))

# Get game-by-game goals added (g+) data for all goalkeepers named "Matt Turner"
asa_goals_added <- asa_client$get_goalkeeper_goals_added(
    leagues = c("mls", "uslc"),
    player_names = "Matt Turner",
    split_by_game = TRUE
)
```

