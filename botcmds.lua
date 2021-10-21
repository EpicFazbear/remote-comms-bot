-- The entire of commands that are registered on the Bot. --

return function(ENV)
	setfenv(1, ENV) -- Connects the main environment from botmain.lua into this file.

	return {
		["help"] = function(self, message)
			message:reply("`Prefix = \"".. prefix .."\"`"..
			"\n**ADMINS+ ARE ONLY ALLOWED TO RUN THESE COMMANDS.**"..
			"\n\nThese are all of the admin-only commands.."..
			"\n			`enable` - Enables the chat hook"..
			"\n			`disable` - Disables the chat hook"..
			"\n			`clear` - Clears the communication file"..
			"\n			`setwhitelist` - Toggles on/off whitelist-only mode"..
			"\n			`whitelist <user/userid>` - Whitelists the mentioned user or userid"..
			"\n			`unwhitelist <user/userid>` - Unwhitelists the mentioned user or userid"..
			"\n			`whitelsited` - Displays the usernames of all whitelisted users"..
			"\n			`blacklist <user/userid>` - Blacklists the mentioned user or userid"..
			"\n			`unblacklist <user/userid>` - Unblacklists the mentioned user or userid"..
			"\n			`blacklisted` - Displays the usernames of all blacklisted users"..
			"\n			`setchannel` - Sets the current channel as the communcations channel"..
			"\n			`send <message>` - Debug command that sends your message to the server (Note that this is unfiltered)"..
			"\n\nThese are all of the owner-only commands (The owner of this bot is: `".. getTag(owner) .." - [".. owner .."]`).."..
			"\n			`admin <user/userid>` - Admins the mentioned user or userid"..
			"\n			`unadmin <user/userid>` - Unadmins the mentioned user or userid"..
			"\n			`admins` - Displays the usernames of all current admins"..
			"\n\n```This bot is in active development."..
			"\nFor user/userid commands: You can only run UserIds one at a time, while you could also mention multiple users in one message for all of them to be affected."..
			"\nIf you would like to make a contribution to this bot, feel free to stop by the GitHub repository linked here: https://github.com/EpicFazbear/remote-comms-bot```")
			-- The creator and developer of this bot is Mattsoft#0074
		end;

		["enable"] = function(self, message)
			activated = true
			message:reply("`Successfully enabled the two-way transmission.`")
		end;

		["disable"] = function(self, message)
			activated = false
			message:reply("`Successfully disabled the two-way transmission.`")
		end;

		["send"] = function(self, message) -- Debug Command (No text filter)
			local msgcontent = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			--postAsync(serverUrl, {username = message.member.name, content = msgcontent, level = 4})
			server.Content = {username = message.member.name, content = msgcontent, level = 4, id = randomString(7)}
		end;

		["clear"] = function(self, message)
			activated = false
			--postAsync(serverUrl, {"Hello! Hello! Hello! Hello! How Low?"})
			server.Content = ""
			message:reply("`Successfully cleared the server communication file.`")
		end;

		["setchannel"] = function(self, message)
			local channel = message.channel
			local selected = getWebhook(channel.id)
			if not selected then
				selected = channel:createWebhook(webhookName)
			end
			mainChannel = channel.id
			--postAsync(serverUrl, {username = message.member.name, content = webhookUrl, level = 4, command = "setwebhook"})
			server.Webhook = "https://discordapp.com/api/webhooks/".. selected.id .."/".. selected.token
			message:reply("`Successfully set current channel as communcations channel.`")
		end;

		["setwhitelist"] = function(self, message)
			whitelistOnly = not whitelistOnly
			if whitelistOnly then
				message:reply("`Successfully **enabled** whitelisting restrictions.`")
			else
				message:reply("`Successfully *disabled* whitelisting restrictions.`")
			end
		end;

		["whitelist"] = function(self, message)
			local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			local users = message.mentionedUsers
			local check, returned = checkPermissions(message.author.id, userid, users)
			local send = modifyList(message.author.id, userid, users, whitelisted, true)
			modifyList(message.author.id, userid, users, blacklisted, false)
			if check then
				message:reply("`Successfully whitelisted ".. send ..".`")
			elseif type(returned) == "table" then
				message:reply("`Successfully whitelisted ".. returned[1] ..".`\n`Could not whitelist ".. returned[2] .." because they have the same permission level as you or higher.`")
			else
				message:reply("`Could not whitelist ".. returned .." because they have the same permission level as you or higher.`")
			end
		end;

		["unwhitelist"] = function(self, message)
			local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			local users = message.mentionedUsers
			local check, returned = checkPermissions(message.author.id, userid, users)
			local send = modifyList(message.author.id, userid, users, whitelisted, false)
			if check then
				message:reply("`Successfully unwhitelisted ".. send ..".`")
			elseif type(returned) == "table" then
				message:reply("`Successfully unwhitelisted ".. returned[1] ..".`\n`Could not unwhitelist ".. returned[2] .." because they have the same permission level as you or higher.`")
			else
				message:reply("`Could not unwhitelist ".. returned .." because they have the same permission level as you or higher.`")
			end
		end;

		["blacklist"] = function(self, message)
			local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			local users = message.mentionedUsers
			local check, returned = checkPermissions(message.author.id, userid, users)
			local send = modifyList(message.author.id, userid, users, blacklisted, true)
			modifyList(message.author.id, userid, users, whitelisted, false)
			modifyList(message.author.id, userid, users, admins, false)
			if check then
				message:reply("`Successfully blacklisted ".. send ..".`")
			elseif type(returned) == "table" then
				message:reply("`Successfully blacklisted ".. returned[1] ..".`\n`Could not blacklist ".. returned[2] .." because they have the same permission level as you or higher.`")
			else
				message:reply("`Could not blacklist ".. returned .." because they have the same permission level as you or higher.`")
			end
		end;

		["unblacklist"] = function(self, message)
			local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			local users = message.mentionedUsers
			local check, returned = checkPermissions(message.author.id, userid, users)
			local send = modifyList(message.author.id, userid, users, blacklisted, false)
			if check then
				message:reply("`Successfully unblacklisted ".. send ..".`")
			elseif type(returned) == "table" then
				message:reply("`Successfully unblacklisted ".. returned[1] ..".`\n`Could not unblacklist ".. returned[2] .." because they have the same permission level as you or higher.`")
			else
				message:reply("`Could not unblacklist ".. returned .." because they have the same permission level as you or higher.`")
			end
		end;

		["admin"] = function(self, message)
			if message.author.id == owner then
				local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
				local users = message.mentionedUsers
				local send = modifyList(message.author.id, userid, users, admins, true)
				modifyList(message.author.id, userid, users, blacklisted, false)
				message:reply("`Successfully admined ".. send ..".`")
			end
		end;

		["unadmin"] = function(self, message)
			if message.author.id == owner then
				local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
				local users = message.mentionedUsers
				local send = modifyList(message.author.id, userid, users, admins, false)
				message:reply("`Successfully unadmined ".. send ..".`")
			end
		end;

		["whitelisted"] = function(self, message)
			if #whitelisted ~= 0 then
				local send = returnListString(whitelisted)
				message:reply("```***These are the currently whitelisted users.***\n\n".. send.. "```")
			else
				message:reply("```***There are no currently whitelisted users.***```")
			end
		end;

		["blacklisted"] = function(self, message)
			if #blacklisted ~= 0 then
				local send = returnListString(blacklisted)
				message:reply("```***These are the currently blacklisted users.***\n\n".. send.. "```")
			else
				message:reply("```***There are no currently blacklisted users.***```")
			end
		end;

		["admins"] = function(self, message)
			if message.author.id == owner then
				if #admins ~= 0 then
					local send = returnListString(admins)
					message:reply("```***These are the currently admined users.***\n\n".. send.. "```")
				else
					message:reply("```***There are no currently admined users. (Except the owner)***```")
				end
			end
		end;
	};
end;