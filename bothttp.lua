-- Initialization of the HTTP webserver used by ROBLOX to retrieve data from Discord. --

local http = require("http")
local json = require("json")
local PRC = process.env

return function(ENV)
	setfenv(1, ENV); -- Connects the main environment from botmain.lua into this file.
	local http_table = {};

	function http_table:Init()
		self.Content = ""
		self.Webhook = ""
		self.Server = http.createServer(function(req, res, idk) -- req.url
			local function getHeader(name)
				name = string.lower(name)
				for _, data in pairs(req.headers) do
					if string.lower(data[1]) == name then
						return tostring(data[2])
					end
				end
			end
			local body = ""
			local passed = getHeader("password") == tostring(PRC.PASSWORD)

			local path = req.url
			res:setHeader("Content-Type", "text/plain")
			if path == "/" or path == "/messages" then
				if passed == true then
					res:setHeader("Content-Type", "text/plain")
					res:setHeader("Webhook-URL", tostring(self.Webhook))
					body = json.encode(self.Content)
				else
					if path == "/" then
						body = "Welcome! This webserver is functioning properly."
					else
						body = "Bad password"
					end
				end
			else
				body = "Invalid request"
			end
			res:setHeader("Content-Length", #body)
			res:finish(body)
		end)

		self.Server:listen(PRC.PORT)
		print("Webserver is now running!")
	end;

	return http_table;
end;