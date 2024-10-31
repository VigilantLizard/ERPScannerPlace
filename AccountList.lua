-- Script by zonkerdoodle (@VigilantLizard).
-- Put this in ReplicatedStorage as a ModuleScript.

-- Uses my GitHub repository to pull the updated list of MFD-confirmed ERP accounts.
local result = game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/VigilantLizard/ERPLists/refs/heads/main/AccountList.bin")
local list = result:split(",\n")
local module = list

return module
