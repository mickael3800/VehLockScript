--[[
    File Name:		VehLockScript_function.lua
	Programmer:		Mickaël Papineau
	Date:			2021/06/05
	Version:		1.4.3
	Description:    This script is some functions for the client side script.
]]--

function notify(msg)    --The function to notify the player.

    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)

end

function GetVehicleInDirection(entFrom, coordFrom, coordTo)   --From wk_delveh, Gets a vehicle in a certain direction, Credit to Konijima

	local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    if (IsEntityAVehicle(vehicle)) then

        return vehicle

    end

end

RegisterNetEvent("Notify")
AddEventHandler("Notify", function(num)

    if (num == 1) then

        notify("~y~VehLockScript V1.4.3")

    elseif (num == 11) then

        notify("~g~Your vehicle is now locked")

    elseif (num == 12) then

        notify("~g~You successfully lockpicked the vehicle without setting off the alarm.")

    elseif (num == 21) then

        notify("~y~You locked another vehicle, please unlock it before locking this vehicle")

    elseif (num == 22) then

        notify("~y~You don't have a vehicle that you've locked yet")

    elseif (num == 23) then

        notify("~y~You successfully lockpicked the vehicle but you set off the alarm.")

    elseif (num == 24) then

        notify("~y~Are you really trying to lockpick an unlocked vehicle.")

    elseif (num == 25) then

        notify("~y~You must be near a vehicle to lockpick it.")

    elseif (num == 26) then

        notify("~y~Are you really trying to break the window of an unlocked vehicle.")

    elseif (num == 27) then

        notify("~y~You must be near a vehicle to break its window.")

    elseif (num == 31) then

        notify("~r~Your vehicle is now unlocked")

    elseif (num == 32) then

        notify("~r~You unsuccessfully lockpicked the vehicle.")

    end

end)
