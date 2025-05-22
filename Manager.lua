-- made by kamalsarasq

-- // VARIABLES //
local modules = {}
local admins = {
	7626737208
}

local isAdminOnline = false

-- // HTTP INFORMATION //

-- APi key
local API_KEY = "api key goes here"
local Url = "https://api.openai.com/v1/chat/completions"

-- model
local Model = "gpt-4o"

-- Body
local Person = {
	["Role"] = "",
	["PlayerMessage"] = ""
}

-- training promt
local TRAINING_PROMT = {"You are an AI running inside a Roblox game. Your responses are being executed directly on the server using loadstring, so you must reply with code only—no extra text, no comments, no explanations. Every message you receive is a player's chat message. Along with the message, their username will also be sent. Your job is to read the player's message and reply with code that changes the game world as they requested. You have full control over the game world. Only valid Lua code should be returned. Never reply with anything other than code. Remember that the code you write will be executed in ServerScriptStorage, Also DO NOT wrap the code in ```lua``` container."}
-- message template
local MESSAGE_TEMPLATE = {"Here’s the player’s message and username: Username: USER_TEMPLATE | Message: MESSAGE_TEMPLATE"}

-- // SERVICES //
local players = game:GetService("Players")

-- requiring modules and storing them in a table
for _, module in pairs(script:GetChildren()) do
	if module:IsA("ModuleScript") then
		modules[module.Name] = require(module) -- requiring them
	end
end

-- // FUNCTION TO MANIPULATE STRING //
local function manipulateString(str: string, pattern: string, replacement: string)
	
	local newString = str -- storing the string which will be replaced by the edited version
	for i, value in pairs(pattern) do
		newString = string.gsub(newString, value, replacement[i]) -- replacing the values
	end
	warn("Client Message" .. newString)
	return newString 	-- returning the new string
end

-- // FUNCTION TO MAKE THE BODY //
local function makeBody(player: Player, PROMT: string)
	-- editing the body
    return {
	    model = Model,
	    messages = {
			{ role = "system", content =  TRAINING_PROMT[1]},
			{ role = "user", content = manipulateString(MESSAGE_TEMPLATE[1], {"USER_TEMPLATE", "MESSAGE_TEMPLATE"}, {player.Name, PROMT}) }
		}
	}
	
end

-- // FUNCTION TO SEND REQUESTS AND RECIEVE REQUESTS //
local function sendRequest(player: Player, message: string)
	-- sending request and getting response
	--[[local response = modules["SEND_HTTP_REQUEST"].sendRequest(player, message)
	return response -- returning it]]
	warn(Url, API_KEY, nil, makeBody(player, message))
	local newRequest = modules["REQUEST"].new(Url, API_KEY, nil, makeBody(player, message))
	local result = newRequest:Request()
	return result
end

-- // FUNCTION TO HANDLE THE VERIFICATION OF THE REQUEST //
local function verifyRequest(message: string)
	-- checking if the message has the keyword "god", or we will just ignore it
	local HAS_KEYWORD_GOD = modules["CHECK_KEYWORDS"].hasGodWord(message, "god")
	if HAS_KEYWORD_GOD then return true end -- returning true if the keyword was found
end

-- // FUNCTION TO HANDLE WHENEVER THEY CHAT //
local function handleChat(player: Player)
	player.Chatted:Connect(function(message)
		
		if not adminOnline then return end 	-- returning if admin is not online
		
		if not verifyRequest(message) then return end -- checking if the word has the keyword "god" in it
		
		-- sending request and getting response from ChatGPT
		local response = sendRequest(player, message)
		if response then
			print(response)
			modules["LOAD_STRING"].load(response, player) -- loading the request, the bot is trained to only reply in code
		end
	end)
end

local function onPlayerAdded(player: Player)
	-- checking if user is admin
	if table.find(admins, player.UserId) then adminOnline = true end
	
	-- connecting to chat
	handleChat(player)
end

-- // CONNECTING TO WHEN A PLAYER JOINS //
players.PlayerAdded:Connect(onPlayerAdded)

-- // CONNECTING TO WHEN A PLAYER LEAVES TO CHECK IF IT WAS ADMIN //
players.PlayerRemoving:Connect(function(player: Player)
	-- checking if the player is admin
	if table.find(admins, player.UserId) then isAdminOnline = false end
end)
