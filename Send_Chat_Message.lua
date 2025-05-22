-- // VARIABLES //
local replicatedStorage = game:GetService("ReplicatedStorage")
local event = game.ReplicatedStorage:WaitForChild("SendServerMessage") :: RemoteEvent

-- // FUNCTION TO SEND MESSAGE TO THE PLAYER ON HIS LOCAL CHAT //
local function SendServerMessage(Message: string, TextChannel: TextChannel)
	-- checking if the TextChannel exists, if not then we will ignore this
	if not game:GetService("TextChatService").TextChannels:FindFirstChild(tostring(TextChannel)) then return end
	-- it exists, so we will send the message
	TextChannel:DisplaySystemMessage(Message)
end

-- // CONNECTING THE FUNCTION TO SEND THE MESSAGE //
event.OnClientEvent:Connect(SendServerMessage)
