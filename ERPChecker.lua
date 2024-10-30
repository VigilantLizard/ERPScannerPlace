-- Script by zonkerdoodle (@VigilantLizard).
-- Put this in Workspace.

-- Scans around 50% faster when disabled, but doesn't list people who are in known ERP groups.
local scanGroups = true

-- Initialize with accounts that can't be followed by zonkerdoodle.
local list = {
	332864766 -- PawteoDerg
}

-- Initialize with groups that can't be joined by zonkerdoodle.
local groupList = {
	34788732, -- Voreblox
	34282593, -- Foxxos
	34640640, -- Nomblox Revived
	17106942, -- sign revolution
	32317885, -- Derg's Paws
	35063781, -- - Spades
	35054382, -- bleach fan club group
	35008055, -- Temple of the Black Goddess
	34208803 -- It dont fard :(
}

local groupMembers = {}

local nextPageCursor = nil
local nextGroupCursor = nil

-- Zonkerdoodle account, used for indexing ERP groups and accounts.
local targetUserId = 7506583559

-- Replace with the group ID you want to check.
local targetGroupId = 34282593



-----------------------------------------------------------------------
----- TOUCH NOTHING BELOW THIS UNLESS YOU KNOW WHAT YOU'RE DOING. -----
-----------------------------------------------------------------------



local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ERP_LIST = require(ReplicatedStorage.AccountList)

local function getGroupMembers(groupId)
	local url = "https://groups.roproxy.com/v1/groups/" .. tostring(groupId) .. "/users?sortOrder=Asc&limit=100"
	if nextGroupCursor ~= nil then
		url = "https://groups.roproxy.com/v1/groups/" .. tostring(groupId) .. "/users?sortOrder=Asc&limit=100&cursor=" .. nextGroupCursor
	end
	local response = HttpService:RequestAsync({
		Url = url,
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json"  -- When sending JSON, set this!
		}
	})
	local data = HttpService:JSONDecode(response.Body)
	nextGroupCursor = data.nextPageCursor
	print(nextGroupCursor)
	for i, v in data.data do
		table.insert(groupMembers, data.data[i].user.userId)
	end
	--print(groupMembers)
	--print(list)
end

-- Function to fetch a user's followings
local function getFollowing(userId)
	local url = "https://friends.roproxy.com/v1/users/" .. tostring(userId) .. "/followings?limit=50&sortOrder=Asc"
	if nextPageCursor ~= nil then
		print("Going to the next page!")
		url = "https://friends.roproxy.com/v1/users/" .. tostring(userId) .. "/followings?limit=50&sortOrder=Asc&cursor=" .. nextPageCursor
	end
	local response = HttpService:RequestAsync({
		Url = url,
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json"  -- When sending JSON, set this!
		}
	})
	local data = HttpService:JSONDecode(response.Body)
	--print(data)
	nextPageCursor = data.nextPageCursor
	for i, v in data.data do
		table.insert(list, data.data[i].id)
	end
	--print(list)
end

-- Function to check if a user is in a group
local function isUserInGroup(userId, groupId)
	local url = "https://groups.roproxy.com/v1/users/" .. tostring(userId) .. "/groups/roles"
	local response = HttpService:RequestAsync({
		Url = url,
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json"  -- When sending JSON, set this!
		}
	})
	local data = HttpService:JSONDecode(response.Body)
	--print(data)
	local isInGroup = false
	if data.data ~= nil then
		for i, v in data.data do
			if v.group.id == groupId then
				isInGroup = true
				--print("User is in group!")
				break
			end
		end
	end
	--if isInGroup == false then print("User ISN'T in group!") end
	return isInGroup
end

-- Get ERP groups from zonkerdoodle.
local function getGroups(userId)
	local url = "https://groups.roproxy.com/v1/users/" .. tostring(userId) .. "/groups/roles"
	local response = HttpService:RequestAsync({
		Url = url,
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json"  -- When sending JSON, set this!
		}
	})
	local data = HttpService:JSONDecode(response.Body)
	--print(data)
	for i, v in data.data do
		table.insert(groupList, data.data[i].group.id)
	end
	--print(groupList)
end

-- Check if user is in an ERP group.
local function isInERP(userId)
	local url = "https://groups.roproxy.com/v1/users/" .. tostring(userId) .. "/groups/roles"
	local response = HttpService:RequestAsync({
		Url = url,
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json"  -- When sending JSON, set this!
		}
	})
	local data = HttpService:JSONDecode(response.Body)
	--print(data)
	local isERP = false
	if data.data ~= nil then
		for i, v in data.data do
			if table.find(groupList, data.data[i].group.id) then
				isERP = true
				--print("User is in group!")
				break
			end
		end
	end
	if isERP and not table.find(list, userId) then
		table.insert(list, userId)
	end
	--if isInGroup == false then print("User ISN'T in group!") end
	return isERP
end

getGroups(targetUserId)
print(groupList)

getGroupMembers(targetGroupId)
while nextGroupCursor ~= nil do
	getGroupMembers(targetGroupId)
end
print(groupMembers)

getFollowing(targetUserId)
while nextPageCursor ~= nil do
	getFollowing(targetUserId)
end

print("Scanning for unsafe accounts...\n \n~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~\n")

for i, v in groupMembers do
	workspace.SignPart.SurfaceGui.TextLabel.Text = "Scanning Member\n" .. i .. "/" .. #groupMembers
	local isInGroup = isUserInGroup(v, targetGroupId)
	if isInGroup then
		local uncensoredID = tostring(v)
		local censoredID = uncensoredID:sub(1, -2) .. "x"
		--print(censoredID)
		ERP = table.find(ERP_LIST, censoredID)
		local ERPGroup = false
		if scanGroups then
			isInERP(v)
		end
		local url = "https://users.roproxy.com/v1/users/" .. tostring(v)
		local response = HttpService:RequestAsync({
			Url = url,
			Method = "GET",
			Headers = {
				["Content-Type"] = "application/json"  -- When sending JSON, set this!
			}
		})
		local data = HttpService:JSONDecode(response.Body)
		local name = data.name
		if ERP then
			warn(tostring(name) ..
				" (" .. tostring(v) ..
				", member #" .. i
				.. ")")
		elseif table.find(list, v) then
			print(tostring(name) ..
				" (" .. tostring(v) ..
				", member #" .. i
				.. ")")
		end
	end
end

warn("\n \n~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~!~\n")
warn("Finished scan.")
