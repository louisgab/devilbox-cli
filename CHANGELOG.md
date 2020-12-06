# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.1] - 2020-12-06
### Fixed
    - add missing help an documentation for new commands

## [0.4.0] - 2020-12-06
### Added
    - "check" command that shortcuts to check-config.sh devilbox file
    - "exec" command that enables command execution without entering the container
    - "mysql" command that opens the mysql cli, and possibility to exec query directly
    
## [0.3.2] - 2020-05-23
### Changed
    - default command shows version and help (@llaville)

## [0.3.1] - 2020-05-23
### Fixed
    - help command documentation, thanks to @llaville
    - build process, thanks to @llaville

## [0.3.0] - 2020-01-17
### Added
    - Restart command, thanks to @thomasplevy
### Changed
    - Possibility to add services to docker-compose, thanks to @thomasplevy

## [0.2.3] - 2019-04-01
### Fixed
    - Failed build, clean it up

## [0.2.2] - 2019-04-01
### Fixed
    - Bin path in package.json

## [0.2.1] - 2019-04-01
### Changed
    - Updated README.md

## [0.2.0] - 2019-03-08
### Added
    - Published as npm package for easier install/update
### Removed
    - Database path from devilbox versions prior to 1.0.0

## [0.1.0] - 2019-03-08
### Added
    - Build script that concatenates all source files in one dist file
    - New commands: enter, config, open, run, stop, update
    - Possibility to change default devilbox path with DEVILBOX_PATH in profile source
### Changed
    - Restructure the whole project with separate files for clarity
    - Lot of good practices
    - Fancy messages output
    - Readme adapted to new usage

## [0.0.3] - 2019-03-08
### Changed
    - Sed regex compatibility with characters

## [0.0.2] - 2019-03-08
### Changed
    - Use short function declarations
    - Format helpers with colors

## [0.0.1] - 2019-03-08
### Added
    - First version: commands for php/mysql/apache and docroot/projects/databases paths.
