--[[
    File Name:		VehLockScript.lua
	Programmer:		Mickaël Papineau
	Date:			2021/03/27
	Version:		1.1.0
	Description:
    
    This script is to lock vehicles by using two commands.
]]--

TriggerEvent( "chat:addSuggestion", "/lock", "Locks the vehicle that you last driven." )
TriggerEvent( "chat:addSuggestion", "/unlock", "Unlocks the vehicle that you locked." )

local OwnVeh
local OwnVehLock = false

RegisterCommand("lock", function()

    if (OwnVehLock == false) then

        SetVehicleDoorsLockedForAllPlayers(GetLastDrivenVehicle(), true)
        SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), PlayerId(), false)
        OwnVeh = GetLastDrivenVehicle()
        OwnVehLock = true
        notify("~g~Your vehicle is now locked")
        
    elseif (OwnVehLock == true) then

        notify("~y~You locked another vehicle, please unlock it before locking this vehicle")

    end

end, false)

RegisterCommand("unlock", function()

    if (OwnVehLock == true) then

        SetVehicleDoorsLockedForAllPlayers(OwnVeh, false)
        SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), PlayerId(), false)
        OwnVehLock = false
        notify("~r~Your vehicle is now unlocked")

    elseif (OwnVehLock == false) then

        notify("~y~You don't have a vehicle that you've locked yet")

    end

end, false)

function notify(msg)

    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)

end