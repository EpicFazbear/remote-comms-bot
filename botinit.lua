-- Initialization of functions and variables used by the other .lua files. --

local http = require("coro-http")
local query = require("querystring")
--local json = require("json")

local charset = {} -- [0-9a-zA-Z]
for c = 48, 57  do table.insert(charset, string.char(c)) end
for c = 65, 90  do table.insert(charset, string.char(c)) end
for c = 97, 122 do table.insert(charset, string.char(c)) end


return function(ENV)
	setfenv(1, ENV) -- Connects the main environment from botmain.lua into this file.
	return {
		commands = require("./botcmds.lua")(ENV); -- Loads in the commands into the table so that it can get loaded into the main environment later.
		server = require("./bothttp.lua")(ENV);

		postAsync = function(url, data)
			--[[
				local res, body = http.request("POST", url,
					{{"Content-Type", "application/json"}},
					json.encode(data)
				)
				--print("Sent JSON: ".. json.encode(data))
				return body
			--]]
			server.Content = data
		end;

		filterAsync = function(string)
			local baseurl = "https://www.purgomalum.com/service/plain?text="
			local filtered
			local ran, body = pcall(function()
				local res, body = http.request("GET", baseurl .. query.urlencode(string))
				return body
			end)
			return ran and body or "[Content Deleted]"
		end;

		randomString = function(length)
			if not length or length <= 0 then length = 5 end
			math.randomseed(os.clock()^5)
			local stringz = ""
			for i = 1, length do
				stringz = stringz .. charset[math.random(1, #charset)]
			end
			return stringz
		end;

		getWebhook = function(channel)
			for _, webhook in next, client:getChannel(channel):getWebhooks():toArray() do
				if webhook.name == webhookName then
					return webhook
				end
			end
			return nil
		end;

		getTag = function(id)
			local ran, returned = pcall(function()
				return client:getUser(id).tag
			end)
			if ran then
				return returned
			else
				return "Invalid user"
			end
		end;

		getLevel = function(userid)
			local level = 1
			if checkList(blacklisted, userid) then
				level = 0
			end
			if checkList(whitelisted, userid) then
				level = 2
			end
			if checkList(admins, userid) then
				level = 3
			end
			if owner == userid then
				level = 4
			end
			return level
		end;

		checkPermissions = function(self, single, multiple)
			if tonumber(single) then
				return getLevel(self) > getLevel(single), getTag(single)
			end

			if multiple then
				multiple = multiple:toArray()
				if #multiple ~= 0 then
					local successful = true
					local list1 = ""
					local list2 = ""
					for int, item in next, multiple do
						if getLevel(self) <= getLevel(item.id) then
							successful = false
							list2 = list2 .. getTag(item.id) ..", "
						else
							list1 = list1 .. getTag(item.id) ..", "
						end
					end
					if list1 == "" then
						list1 = "No one.."
					end
					return successful, {string.sub(list1, 1, #list1 - 2), string.sub(list2, 1, #list2 - 2)}
				end
			end
			return false, "Invalid user"
		end;

		checkList = function(list, value)
			for int, element in next, list do
				if element == value then
					return true, int
				end
			end
		end;

		returnListString = function(tableName)
			local fullstring = ""
			for _, item in next, tableName do
				fullstring = fullstring .. getTag(item) .." - [".. item .."]\n"
			end
			return fullstring
		end;

		modifyList = function(self, single, multiple, tableName, adding)
			if tonumber(single) then
				if checkPermissions(self, single) then
					if adding then
						table.insert(tableName, single)
						return getTag(single)
					else
						local found, int = checkList(tableName, single)
						if found then
							table.remove(tableName, int)
							return getTag(single)
						end
					end
				end
				return false
			end

			if multiple then
				multiple = multiple:toArray()
				if #multiple ~= 0 then
					local fullstring = ""
					for _, item in next, multiple do
						if checkPermissions(self, item.id) then
							if adding then
								table.insert(tableName, item.id)
								fullstring = fullstring .. getTag(item.id) ..", "
							else
								local found, int = checkList(tableName, item.id)
								if found then
									table.remove(tableName, int)
									fullstring = fullstring .. getTag(item.id) ..", "
								end
							end
						end
					end
					return string.sub(fullstring, 1, #fullstring - 2)
				end
			end
		end;
	};
end;