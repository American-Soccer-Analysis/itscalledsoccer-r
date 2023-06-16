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

Any of the `get_*` methods can be used to retrieve the same data made available in the [American Soccer Analysis app](https://app.americansocceranalysis.com/). Partial matches or abbreviations are accepted for any player or team names. For most methods, arguments _must be named_. A few examples are below.

```r
# Get all players named "Dax"
asa_players <- asa_client$get_players(names = "Dax")

# Get season-by-season xG data for all players named "Dax"
asa_xgoals <- asa_client$get_player_xgoals(
    leagues = "mls",
    player_names = "Dax",
    split_by_seasons = TRUE
)

# Get cumulative xPass data for all USL League One teams
asa_xpass <- asa_client$get_team_xpass(
    leagues = "usl1"
)

# Get game-by-game goals added (g+) data for all goalkeepers named "Matt Turner"
asa_goals_added <- asa_client$get_goalkeeper_goals_added(
    leagues = c("mls", "uslc"),
    player_names = "Matt Turner",
    split_by_game = TRUE
)
```
