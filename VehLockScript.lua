--[[
    File Name:		VehLockScript.lua
	Programmer:		Mickaël Papineau
	Date:			2021/03/21
	Version:		1.0.0
	Description:
    
    This script is to lock vehicles by using two commands.
]]--

RegisterCommand("lock", function()

    SetVehicleDoorsLockedForAllPlayers(GetLastDrivenVehicle(), true)
    SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), PlayerId(), false)
    notify("~g~Your doors are now locked")

end, false)

RegisterCommand("unlock", function()

    SetVehicleDoorsLockedForAllPlayers(GetLastDrivenVehicle(), false)
    SetVehicleDoorsLockedForPlayer(GetLastDrivenVehicle(), PlayerId(), false)
    notify("~r~Your doors are now unlocked")

end, false)

function notify(msg)

    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)

end