# GMod Game Mode: Basewars (WIP)

## Description

Basewars is a role-playing mutiplayer game mode for Garry's Mod where players must make a base, gain money, and attack other bases. This game mode is currently a work in progress.

## Installation

To install the Basewars game mode:

1. Download the latest version from the [Releases](https://github.com/lukas-hines/basewars/releases) page.
2. Extract the downloaded ZIP file.
3. Move the `Basewars` folder to your `garrysmod/gamemodes` directory.
4. Download and install [MYSQLOO](https://github.com/FredyH/MySQLOO/).
5. Setup a [mysql](https://www.mysql.com/) server and edit the `gamemode/conf.lua` to the creds of your mysql server.
6. Restart Garry's Mod and select "Basewars" from the game modes menu.
7. Start a game and run the `bw_first_time_setup` in the console.

## About

Players must build a base and gather as much money as posible. Raiding people will reward you and unlock new things to help improve your base!

## Usage

every admin console comand is prefixed with bw_*
```
bw_prep_shutdown : This saves all player data and gets you prepaired for a server shutdown, do to limitations you would have to still manualy shut down the server.
```

## Features and Roadmap

### Current Features

- Economy system.
- Levleing system.
- Persistent data.

### Planned Features

- Shop system.
- Raiding.
- NPCs.
- Cars.
- Custom maps.
- Difrent forms of getting money

## License

This project is licensed under the BSD 3-Clause License.
