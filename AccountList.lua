-- Script by zonkerdoodle (@VigilantLizard).
-- Put this in ReplicatedStorage as a ModuleScript.

local result = game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/VigilantLizard/ERPLists/refs/heads/main/AccountList.bin")
local list = result:split(",\n")
local module = list

return module
