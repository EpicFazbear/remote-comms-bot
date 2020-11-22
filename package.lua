return {
  name = "discord-bot-hosting",
  version = "1.2.0",
  description = "Hosting discord bot on Heroku (Remote Communications)",
  main = "botmain.lua",
  scripts = {
    start = "botmain.lua"
  },
  dependencies = {
    "SinisterRectus/discordia"
  },
}