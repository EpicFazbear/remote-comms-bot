local http = require("http")
local PRC = process.env

return function(ENV)
	setfenv(1, ENV) -- Connects the main environment from botmain.lua into this file.
	local http_table = {}

	function http_table:Init()
		self.Content = "Hello world\n"
		self.Server = http.createServer(function (req, res)
			local body = self.Content
			res:setHeader("Content-Type", "text/plain")
			res:setHeader("Content-Length", #body)
			res:finish(body)
		end)
		self.Server:listen(PRC.PORT)
	end

	return http_table
end;