-- This is our main environment for the Discord Bot. --

local discordia = require("discordia")
local json = require("json")
local ENV = process.env

if ENV.PREFIX == nil then
	print("Please start your bot using `heroku local` (Search up how to set up the Heroku CLI if you don't know how to do this).")
end

client = discordia.Client()
activated = true
prefix = ENV.PREFIX
whitelistOnly = ENV.WHITELIST_ONLY == "true"
webhookName = ENV.WEBHOOK_NAME
serverUrl = ENV.SERVER_URL
mainChannel = ENV.MAIN_CHANNEL
ownerOverride = ENV.OWNER_OVERRIDE
if ownerOverride == "" then ownerOverride = nil end
admins = json.decode(ENV.ADMINS)
whitelisted = json.decode(ENV.WHITELISTED)
blacklisted = json.decode(ENV.BLACKLISTED)
table.insert(admins, owner)


-- Injects our external variables and functions into the main environment.
local functions = require("./botinit.lua")(getfenv(1))
local previous = getfenv(1)
for i,v in pairs(functions) do previous[i] = v end
setfenv(1, previous)


client:on("ready", function()
	print("***Starting bot..***")
	owner = ownerOverride or client.owner.id
	local message
	if ENV.INVISIBLE ~= "true" then
		message = client:getChannel(mainChannel):send("***Starting bot..***")
		client:setStatus("idle")
		client:setGame("Initializing..")
	else
		client:setStatus("invisible") -- Bravo Six, going dark.
	end

	local webhook = getWebhook(mainChannel)
	if webhook == nil then
		webhook = client:getChannel(mainChannel):createWebhook(webhookName)
	end
	server.Webhook = "https://discordapp.com/api/webhooks/".. webhook.id .."/".. webhook.token
	server:Init()

	if ENV.INVISIBLE ~= "true" then
		client:setStatus("online")
		if string.lower(ENV.STATUS) ~= "none" then
			client:setGame(ENV.STATUS)
		end
		message:setContent(message.content .. "\n***{!} Communications bot has been activated {!}***")
	end
	print("***{!} Communications bot has been activated {!}***")
end)


client:on("messageCreate", function(message)
	if message.author == client.user or message.author.bot == true or message.author.discriminator == 0000 then return end

	if string.sub(string.lower(message.content), 1, 1) == prefix then
		for name, cmdFunction in next, commands do -- Runs through our list of commands and connects them to our messageCreate connection
			if string.sub(string.lower(message.content), 1, string.len(prefix) + string.len(name)) == string.lower(prefix .. name) and (checkList(admins, message.author.id) or name == "help") then
				local ran, error = pcall(function()
					cmdFunction(name, message)
				end)
				if not ran then
					message:reply("```~~ AN INTERNAL ERROR HAS OCCURRED ~~\n".. tostring(error) .."```")
				end
			return end
		end
	return end

	if activated and message.channel.id == mainChannel then
		if whitelistOnly and not (checkList(admins, message.author.id) or checkList(whitelisted, message.author.id)) then
			return
		elseif checkList(blacklisted, message.author.id) then
			return
		end
		local username = message.member.name
		local content = filterAsync(message.content)
		local level = getLevel(message.author.id)
		if string.lower(string.sub(message.content, 1, 3)) == "/e " then
			message:delete()
		end
		postAsync(serverUrl, {username = username, content = content, level = level, id = randomString(7)})
	end
end)


client:run("Bot ".. ENV.BOT_TOKEN);