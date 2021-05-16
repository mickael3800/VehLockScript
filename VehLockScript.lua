--[[
    File Name:		VehLockScript.lua
	Programmer:		Mickaël Papineau
	Date:			2021/04/06
	Version:		1.2.0
	Description:    This script is to lock vehicles by using two commands.
]]--

--Config variables [Can Be Modified]
local ALock = true  --When the vehicle is locked, all players are locked out?
local PLock = false --When the vehicle is locked, the player is locked out?

--Variables [Do Not Modify]
local OwnVehID    --The ID of the vehicle that was locked.
local OwnVehLock = false    --If there is a vehicle that is already locked by the player.

TriggerEvent("chat:addSuggestion", "/lock", "Locks the vehicle that you last driven.") --Chat suggestion for the /lock command.
TriggerEvent("chat:addSuggestion", "/unlock", "Unlocks the vehicle that you locked.") --Chat suggestion for the /unlock command.

RegisterCommand("lock", function()  --The /lock command function.

    if (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        for i=1, 999, 1 do  --Loops to lock the vehicle to all players.

            SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), i, ALock)    --Locks the vehicle to the PlayerId of the variable i.

        end

        SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), PlayerId(), PLock)   --Locks the vehicle to the player.
        OwnVehID = GetLastDrivenVehicle()   --Sets the OwnVehID to the locked vehicle's ID.
        OwnVehLock = true   --Sets the OwnVehLock to true.
        notify("~g~Your vehicle is now locked") --Notifies the player of the commands success status.

    elseif (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        notify("~y~You locked another vehicle, please unlock it before locking this vehicle")   --Notifies the player of the commands failed status.

    end

end, false)

RegisterCommand("unlock", function()    --The /unlock command function.

    if (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        for i=1, 999, 1 do  --Loops to unlock the vehicle to all players.

            SetVehicleDoorsLockedForPlayer(OwnVehID, i, false)    --Unlocks the vehicle to the PlayerId of the variable i.

        end

        SetVehicleDoorsLockedForPlayer(OwnVehID, PlayerId(), false)   --Unlocks the vehicle to the player.
        OwnVehLock = false  --Sets the OwnVehLock to false.
        notify("~r~Your vehicle is now unlocked")   --Notifies the player of the commands success status.

    elseif (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        notify("~y~You don't have a vehicle that you've locked yet")    --Notifies the player of the commands failed status.

    end

end, false)

RegisterCommand("VehLockScriptVer", function()  --The /VehLockScriptVer command function.

    notify("~y~VehLockScript V1.2.0")   --Notifies the player of the script's version.

end, false)

function notify(msg)    --The function to notify the player.

    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)

end