# itscalledsoccer (development version)

# itscalledsoccer 0.2.2

### Bug fixes 🐛 

- Resolve issue with nested vectors occasionally being interpreted as lists within data frame columns.


# itscalledsoccer 0.2.1

### Bug fixes 🐛 

- Added more handling to address the CRAN policy: "Packages which use Internet resources should fail gracefully with an informative message if the resource is not available or has changed (and not give a check warning nor error)."


# itscalledsoccer 0.2.0

### What's new ✨

- MLS Next Pro data is now available.


# itscalledsoccer 0.1.0

### Introducing itscalledsoccer ⚽ 🎉 

This is the first release of `itscalledsoccer`, a wrapper around the same API that powers the [American Soccer Analysis app](https://app.americansocceranalysis.com/). It enables R users to programmatically retrieve advanced analytics for their favorite players and teams, with coverage of the following competitions: 

- Major League Soccer
- National Women's Soccer League
- USL Championship
- USL League One
- MLS NEXT Pro
- North American Soccer League (defunct)

We at ASA, have been working on this for the better part of 6 months and are super excited to release it. We hope it makes interacting with our data easier and allows people to build new and informative things.

### What's new ✨

Technically everything in the package is new, but we'll highlight all the functions that are currently available and provide a brief description of what data they return. The package does take a couple seconds to initialize because we do cache some data at the start.

- `get_stadia`: Gets data about stadiums, things like location, name and capacity.
- `get_referees`: Gets data about referees, things like name, birth date and nationality.
- `get_managers`: Gets data about managers, things like name and nationality.
- `get_teams`: Gets data about teams, things like abbreviation and name.
- `get_players`: Gets data about players, things like height, weight and nationality.
- `get_games`: Gets data about games, things like score, attendance and matchday.
- `get_player_xgoals`: Gets a player(s) xGoals for a season or range of dates.
- `get_player_xpass`: Gets a player(s) xPass for a season or range of dates.
- `get_player_goals_added`: Gets a player(s) g+ for a season or range of dates.
- `get_player_salaries`: Gets a player(s) salary for a season or range of dates, only available for MLS.
- `get_goalkeeper_xgoals`: Gets a goalkeepers(s) xGoals for a season or range of dates.
- `get_goalkeeper_goals_added`: Gets a goalkeepers(s) g+ for a season or range of dates.
- `get_team_xgoals`: Gets a team(s) xGoals for a season or range of dates.
- `get_team_xpass`: Gets a team(s) xPass for a season or range of dates.
- `get_team_goals_added`: Gets a team(s) xPass for a season or range of dates.
- `get_team_salaries`: Gets a team(s) salary for a season or range of dates, only available for MLS.
- `get_game_xgoals`: Gets a game(s) xGoals for a season or range of dates.

For more info on xGoals, xPass and g+, check out these articles:

- [xGoals Explanation](https://www.americansocceranalysis.com/explanation?rq=xgoals)
- [An Updated Expected Passing Model](https://www.americansocceranalysis.com/home/2018/4/19/an-updated-expected-passing-model?rq=xpass)
- [What Are Goals Added](https://www.americansocceranalysis.com/what-are-goals-added)

### Bug fixes 🐛 

None, but if you do find a bug while using the package, please submit an [issue](https://github.com/American-Soccer-Analysis/itscalledsoccer/issues).

### Documentation 📚 

We know our documentation is a bit sparse at the moment, but we plan on building it up and adding more examples over time. In the meantime, [the API documentation](https://app.americansocceranalysis.com/api/v1/__docs__/) should be a sufficient stop gap for specific functions.

Happy soccering!
