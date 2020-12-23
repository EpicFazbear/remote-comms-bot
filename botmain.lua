local discordia = require("discordia")
local http = require("coro-http")
local json = require("json")
local query = require("querystring")
local ENV = process.env

client = discordia.Client()
activated = true
prefix = ENV.PREFIX
whitelistOnly = ENV.WHITELIST_ONLY == "true"
serverUrl = ENV.SERVER_URL
mainChannel = ENV.MAIN_CHANNEL
ownerOverride = ENV.OWNER_OVERRIDE
if ownerOverride == "" then ownerOverride = nil end
admins = json.decode(ENV.ADMINS)
whitelisted = json.decode(ENV.WHITELISTED)
blacklisted = json.decode(ENV.BLACKLISTED)

--[[ -- TODO: Add auth token for sending to and recieving from server
	0 - None/Blacklisted
	1 - Regular User
	2 - Whitelisted
	3 - Admin
	4 - Owner
--]]

local functions = require("./functions.lua")(getfenv(1))
local previous = getfenv(1)
for i,v in pairs(functions) do previous[i] = v end
setfenv(1, previous) -- Loads our functions

client:on("ready", function()
	if ENV.INVISIBLE == "true" then
		client:setStatus("invisible") -- Bravo Six, going dark.
	end
	if string.lower(ENV.STATUS) ~= "none" then
		client:setGame(ENV.STATUS) -- "Sending and recieving messages from within ROBLOX!"
	end
	owner = ownerOverride or client.owner.id
	client:getChannel(mainChannel):send("***{!} Communications bot has been activated {!}***")
	print("\n***{!} Communications bot has been activated {!}***")
end)


client:on("messageCreate", function(message)
	if message.author == client.user or message.author.bot == true or message.author.discriminator == 0000 then return end

	for name, cmdFunction in next, commands do -- Runs through our list of commands and connects them to our messageCreate connection
		if string.match(string.lower(message.content), string.lower(prefix..name)) and (checkList(admins, message.author.id) or message.author.id == owner or name == "help") then
			local ran, error = pcall(function()
				cmdFunction(name, message)
			end)
			if not ran then
				message:reply("```~~ AN INTERNAL ERROR HAS OCCURRED ~~\n".. tostring(error) .."```")
			end
		return end
	end

	if string.sub(message.content, 1, 1) ~= prefix and activated and message.channel.id == mainChannel and not checkList(blacklisted, message.author.id) then
		if whitelistOnly and not (checkList(admins, message.author.id) or checkList(whitelisted, message.author.id)) then
			return
		end
		local username = message.member.name
		local content = filterAsync(message.content)
		local level = getLevel(message.author.id)
		if string.lower(string.sub(message.content, 1, 3)) == "/e " then
			message:delete()
		end
		postAsync(serverUrl, {username = username, content = content, level = level})
	end
end)

client:run("Bot ".. ENV.BOT_TOKEN)