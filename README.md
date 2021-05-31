# Remote Communications Bot

A heavily modified version of my original Discord Lua bot.
This bot's main purpose is communicating to the remote admin server for sending messages/commands to linked Roblox games (Using a certain plugin that reads messages from the webserver).

I may or may not release the Roblox scripts I made to make a full connection between Roblox and Discord. (They're not that hard to replicate anyways) As of now (when this repository becomes public), the code for this bot and for the remote server (now integrated into the bot) are available for use.

- Requires [Luvit](https://luvit.io/) and [Discordia](https://github.com/SinisterRectus/Discordia) in order to run.
- Configurable in the .env file
- Recommended to use [Heroku](https://www.heroku.com/) to host externally 24/7. There's some additional steps you'll need to do in order to set it up, however.

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/EpicFazbear/remote-comms-bot)