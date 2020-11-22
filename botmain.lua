local discordia = require("discordia")
local http = require("coro-http")
local json = require("json")
local query = require("querystring")
client = discordia.Client()
activated = true
prefix = process.env.PREFIX
whitelistOnly = (process.env.WHITELIST_ONLY == "false" and false) or true
serverUrl = process.env.SERVER_URL
mainChannel = process.env.MAIN_CHANNEL
admins = json.decode(process.env.ADMINS)
whitelisted = json.decode(process.env.WHITELISTED)
blacklisted = json.decode(process.env.BLACKLISTED)

--[[ Also apply the following to the in-game scripts
	0 - None/Blacklisted
	1 - Regular User
	2 - Whitelisted
	3 - Admin
	4 - Owner

	Todo:
		Add checks for setting permissions so that admins cannot override other admins permissions,
		and the owner cannot delete his own permissions (LAWL).
--]]

local functions = require("./functions.lua")(getfenv(1))
local previous = getfenv(1)
for i,v in pairs(functions) do previous[i] = v end
setfenv(1, previous) -- Loads our functions

client:on("ready", function()
	client:setStatus("invisible") -- Bravo Six, going dark.
	client:setGame("Sending and recieving messages from within ROBLOX!")
	owner = client.owner.id
--	client:getChannel(logsChannel):send("***{!} COMMUNICATIONS BOT HAS BEEN ACTIVATED {!}***")
	print("***COMMUNICATIONS BOT HAS BEEN ACTIVATED***")
end)


client:on("messageCreate", function(message)
	if message.author == client.user or message.author.bot == true or message.author.discriminator == 0000 then return end

	for name, cmd in next, commands do -- Runs through our list of commands and connects them to our messageCreate connection
		if string.match(string.lower(message.content), string.lower(prefix..name)) and (checkList(admins, message.author.id) or message.author.id == owner or name == "help") then
			cmd(name, message)
		return end
	end

	if string.sub(message.content, 1, 1) ~= prefix and activated and message.channel.id == mainChannel and not checkList(blacklisted, message.author.id) then
		if whitelistOnly and not (checkList(admins, message.author.id) or checkList(whitelisted, message.author.id)) then
			return
		end
		local username = message.member.name
		local content = filterAsync(message.content)
		local level = 1
		if checkList(blacklisted, message.author.id) then
			level = 0
		end
		if checkList(whitelisted, message.author.id) then
			level = 2
		end
		if checkList(admins, message.author.id) then
			level = 3
		end
		if message.author.id == owner then
			level = 4
		end
		if string.lower(string.sub(message.content, 1, 3)) == "/e " then
			message:delete()
		end
		postAsync(serverUrl, {username = username, content = content, level = level})
	end
end)

client:run("Bot ".. process.env.BOT_TOKEN)