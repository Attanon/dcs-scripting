local base  	= _G

-- Don't double load the lua
if base.dcsbot ~= nil then
	return
end

-- load the configuration
local JSON = loadfile(lfs.currentdir() .. "Scripts\\JSON.lua")()

dcsbot = base.dcsbot or {}
if dcsbot.UDPSendSocket == nil then
	package.path  = package.path..";.\\LuaSocket\\?.lua;"
	package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"
	local socket = require("socket")
	dcsbot.UDPSendSocket = socket.udp()
end

dcsbot.sendBotMessage = dcsbot.sendBotMessage or function (msg, channel)
	local messageTable = {}
	messageTable.command = 'sendMessage'
	messageTable.message = msg
	dcsbot.sendBotTable(messageTable, channel)
end

dcsbot.sendBotTable = dcsbot.sendBotTable or function (tbl, channel)
	tbl.server_name = "test-server"
	tbl.channel = channel or "-1"
	local tbl_json_txt = JSON:encode(tbl)
	socket.try(dcsbot.UDPSendSocket:sendto(tbl_json_txt, "ip", 51001))
end

dcsbot.sendBotMessage("test msg")