-- Initialization of the HTTP webserver used by ROBLOX to retrieve data from Discord. --

local http = require("http")
local json = require("json")
local PRC = process.env

return function(ENV)
	setfenv(1, ENV) -- Connects the main environment from botmain.lua into this file.
	local http_table = {}

	function http_table:Init()
		self.Content = "Hello! Hello! Hello! Hello! How Low?"
		self.Webhook = ""
		self.Server = http.createServer(function(req, res) -- req.url
			local body
			local passed = false
			for _, data in pairs(req.headers) do
				if data[1]:lower() == "password" then
					if tostring(data[2]) == tostring(PRC.PASSWORD) then
						passed = true
					end
				end
			end

			local path = req.url
			if path == "/messages" then
				if passed == true then
					res:setHeader("Content-Type", "text/plain")
					--res:setHeader("Webhook-URL", tostring(self.Webhook))
					body = json.encode(self.Content)
				else
					body = "Bad password"
				end
			elseif path == "/" then
				res:setHeader("Content-Type", "text/plain")
				body = "Welcome! This webserver is functioning properly."
			else
				res:setHeader("Content-Type", "text/plain")
				body = "Invalid request"
			end
			res:setHeader("Content-Length", #body)
			res:finish(body)
		end)
		self.Server:listen(PRC.PORT)
		print("Webserver is now running!")
	end

	return http_table
end;