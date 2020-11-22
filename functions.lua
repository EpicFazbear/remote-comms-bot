local http = require("coro-http")
local json = require("json")
local query = require("querystring")


-- Functions used by the other .lua files
return function(ENV)
	setfenv(1, ENV)
	return {
		commands = require("./commands.lua")(ENV); -- Loads in the commands into the table so that it can get loaded into the main environment later.

		postAsync = function(url, data)
			local res, body = http.request("POST", url,
				{{"Content-Type", "application/json"}},
				json.encode(data)
			)
			--print("Sent JSON: ".. json.encode(data))
			return body
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

		checkList = function(list, value)
			for int, element in next, list do
				if element == value then
					return true, int
				end
			end
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

		returnListString = function(tableName)
			local fullstring = ""
			for _, item in next, tableName do
				fullstring = fullstring .. getTag(item) .." - [".. item .."]\n"
			end
			return fullstring
		end;

		modifyList = function(single, mult, tableName, adding)
			if tonumber(single) then
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

			mult = mult:toArray()
			if #mult ~= 0 then
				local fullstring = ""
				for _, item in next, mult do
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
				return string.sub(fullstring, 1, #fullstring - 2)
			end
		end;
	};
end;