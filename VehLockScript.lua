--[[
    File Name:		VehLockScript.lua
	Programmer:		Mickaël Papineau
	Date:			2021/03/31
	Version:		1.1.1
	Description:    This script is to lock vehicles by using two commands.
]]--

--Config variables [Can Be Modified]
local ALock = true  --When the vehicle is locked, all players are locked out?
local PLock = false --When the vehicle is locked, the player is locked out?

--Variables [Do Not Modify]
local OwnVehID    --The ID of the vehicle that was locked.
local OwnVehLock = false    --If there is a vehicle that is already locked by the player.

TriggerEvent( "chat:addSuggestion", "/lock", "Locks the vehicle that you last driven." ) --Chat suggestion for the /lock command.
TriggerEvent( "chat:addSuggestion", "/unlock", "Unlocks the vehicle that you locked." ) --Chat suggestion for the /unlock command.

RegisterCommand("lock", function()  --The /lock command function.

    if (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        SetVehicleDoorsLockedForAllPlayers(GetLastDrivenVehicle(), ALock)   --Locks/Unlocks the vehicle to all players.
        SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), PlayerId(), PLock)   --Locks/Unlocks the vehicle to the player.
        OwnVehID = GetLastDrivenVehicle()   --Sets the OwnVehID to the locked vehicle's ID.
        OwnVehLock = true   --Sets the OwnVehLock to true.
        notify("~g~Your vehicle is now locked") --Notifies the player of the commands success status.
        
    elseif (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        notify("~y~You locked another vehicle, please unlock it before locking this vehicle")   --Notifies the player of the commands failed status.

    end

end, false)

RegisterCommand("unlock", function()    --The /unlock command function.

    if (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        SetVehicleDoorsLockedForAllPlayers(OwnVehID, false) --Unlocks the vehicle to all players.
        SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), PlayerId(), false)   --Unlocks the vehicle to the player.
        OwnVehLock = false  --Sets the OwnVehLock to false.
        notify("~r~Your vehicle is now unlocked")   --Notifies the player of the commands success status.

    elseif (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        notify("~y~You don't have a vehicle that you've locked yet")    --Notifies the player of the commands failed status.

    end

end, false)

function notify(msg)    --The function to notify the player

    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)

end