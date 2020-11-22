-- Our full list of commands.
return function(ENV)
	setfenv(1, ENV)

	return {
		["help"] = function(self, message)
			message:reply("`Prefix = \"".. prefix .."\"`"..
			"\n**ADMINS+ ARE ONLY ALLOWED TO RUN THESE COMMANDS.**"..
			"\n\nThese are all of the admin-only commands.."..
			"\n			`enable` - Enables the chat hook"..
			"\n			`disable` - Disables the chat hook"..
			"\n			`clear` - Clears the communication file"..
			"\n			`whitelist-only` - Toggles on/off whitelist-only mode"..
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
			"\nThe creator and developer of this bot is Mattsoft シ#6704```")
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
			postAsync(serverUrl, {username = message.member.name, content = msgcontent, level = 4})
		end;

		["clear"] = function(self, message)
			activated = false
			postAsync(serverUrl, {"Hello! Hello! Hello! Hello! How Low?"})
			message:reply("`Successfully cleared the server communication file.`")
		end;

		["setchannel"] = function(self, message)
			local channel = message.channel
			mainChannel = channel.id
			local selected
			for _, webhook in next, channel:getWebhooks():toArray() do
				if webhook.name == "Hello! Hello! Hello! Hello! How Low?" then
					selected = webhook
				end
			end
			if not selected then
				selected = channel:createWebhook("Hello! Hello! Hello! Hello! How Low?")
			end
			postAsync(serverUrl, {username = message.member.name, content = tostring("https://discordapp.com/api/webhooks/".. selected.id .."/".. selected.token), level = 4, command = "setwebhook"})
			message:reply("`Successfully set current channel as communcations channel.`")
		end;

		["whitelist-only"] = function(self, message)
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
			local send = modifyList(userid, users, whitelisted, true)
			message:reply("`Successfully whitelisted ".. send ..".`")
			modifyList(userid, users, blacklisted, false)
		end;

		["unwhitelist"] = function(self, message)
			local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			local users = message.mentionedUsers
			local send = modifyList(userid, users, whitelisted, false)
			message:reply("`Successfully unwhitelisted ".. send ..".`")
		end;

		["blacklist"] = function(self, message)
			local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			local users = message.mentionedUsers
			local send = modifyList(userid, users, blacklisted, true)
			message:reply("`Successfully blacklisted ".. send ..".`")
			modifyList(userid, users, whitelisted, false)
		end;

		["unblacklist"] = function(self, message)
			local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
			local users = message.mentionedUsers
			local send = modifyList(userid, users, blacklisted, false)
			message:reply("`Successfully unblacklisted ".. send ..".`")
		end;

		["admin"] = function(self, message)
			if message.author.id == owner then
				local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
				local users = message.mentionedUsers
				local send = modifyList(userid, users, admins, true)
				message:reply("`Successfully admined ".. send ..".`")
				modifyList(userid, users, blacklisted, false)
			end
		end;

		["unadmin"] = function(self, message)
			if message.author.id == owner then
				local userid = string.sub(message.content, string.len(prefix) + string.len(self) + 2)
				local users = message.mentionedUsers
				local send = modifyList(userid, users, admins, false)
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