-- made by kamalsarasq

-- // VARIABLES //
local module = {}

local remote = game.ReplicatedStorage.SendServerMessage :: RemoteEvent
local TextChatService = game:GetService("TextChatService")

-- prefix
local prefix = "[GOD] "

-- // FUNCTION TO LOAD THE STRING //
function module.load(str: string, player: Player)
	local success, errormessage = pcall(function()
		loadstring(str)()
	end)
	
	-- if not success then we return
	if not success then error(errormessage) return end
	
	-- sending message to every player on chat
	remote:FireAllClients(
		prefix .. "God listened to " .. player.DisplayName .. ".",
		TextChatService.TextChannels.RBXSystem
	)
end

return module
