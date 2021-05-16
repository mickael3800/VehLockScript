--[[
    File Name:		VehLockScript.lua
	Programmer:		Mickaël Papineau
	Date:			2021/04/29
	Version:		1.4.1
	Description:    This script is to lock vehicles by using two commands.
]]--

--Config variables [Can Be Modified]
local Lockpick = true  --Enable/disable the /lockpick feature.
local Winbreak = true  --Enable/disable the /winbreak feature.

--Variables [Do Not Modify]
local OwnVehID    --The ID of the vehicle that was locked.
local OwnVehLock = false    --If there is a vehicle that is already locked by the player.

TriggerEvent("chat:addSuggestion", "/lock", "Locks the vehicle that you last driven.") --Chat suggestion for the /lock command.
RegisterCommand("lock", function()  --The /lock command function.

    if (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        SetVehicleDoorsLocked(GetLastDrivenVehicle(), 2)    --Locks the vehicle.
        SetVehicleAlarm(GetLastDrivenVehicle(), true)   --Turns on the vehicles alarm.
        OwnVehID = GetLastDrivenVehicle()   --Sets the OwnVehID to the locked vehicle's ID.
        OwnVehLock = true   --Sets the OwnVehLock to true.
        notify("~g~Your vehicle is now locked") --Notifies the player of the commands success status.

    elseif (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        notify("~y~You locked another vehicle, please unlock it before locking this vehicle")   --Notifies the player of the commands failed status.

    end

end, false)

TriggerEvent("chat:addSuggestion", "/unlock", "Unlocks the vehicle that you locked.") --Chat suggestion for the /unlock command.
RegisterCommand("unlock", function()    --The /unlock command function.

    if (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        SetVehicleDoorsLocked(OwnVehID, 1)    --Unlocks the vehicle.
        SetVehicleAlarm(OwnVehID, false)    --Turns off the vehicles alarm.
        OwnVehLock = false  --Sets the OwnVehLock to false.
        notify("~r~Your vehicle is now unlocked")   --Notifies the player of the commands success status.

    elseif (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        notify("~y~You don't have a vehicle that you've locked yet")    --Notifies the player of the commands failed status.

    end

end, false)

if (Lockpick == true) then

    TriggerEvent("chat:addSuggestion", "/lockpick", "Lockpick the vehicle in front of you.") --Chat suggestion for the /lockpick command.
    RegisterCommand("lockpick", function() --The /lockpick command function.

        local distanceToCheck = 1.0 --The distance to check in front of the player for a vehicle.
        local ped = GetPlayerPed(PlayerId())    --Gets the player ped.
        local pos = GetEntityCoords(ped)    --Gets the players coords.
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(ped, 0.0, distanceToCheck, 0.0)
        local vehicle = GetVehicleInDirection(ped, pos, inFrontOfPlayer)

        if (DoesEntityExist(vehicle)) then  --Checks if the vehicle exists.

            if (GetVehicleDoorLockStatus(vehicle) == 2) then    --Checks if the vehicle is locked.

                local almChance = math.random(1, 10)    --Picks a number in between 1 to 10.

                if (almChance == 4) then --10% chance of not set off the alarm.

                    SetVehicleDoorsLocked(vehicle, 1)    --Unlocks the vehicle
                    notify("~g~You successfully lockpicked the vehicle without setting off the alarm.") --Notifies the player of there results of lockpicking.

                elseif (almChance == 8) then    --10% chance of being unsuccessful.

                    StartVehicleAlarm(vehicle)  --Triggers the vehicles alarm.
                    notify("~r~You unsuccessfully lockpicked the vehicle.") --Notifies the player of there results of lockpicking.

                else   --80% chance of set off the alarm.

                    SetVehicleDoorsLocked(vehicle, 1)    --Unlocks the vehicle
                    StartVehicleAlarm(vehicle)  --Triggers the vehicles alarm.
                    notify("~y~You successfully lockpicked the vehicle but you set off the alarm.") --Notifies the player of there results of lockpicking.

                end

            elseif (GetVehicleDoorLockStatus(vehicle) == 1) then    --Checks if the vehicle is unlocked.

                notify("~y~Are you really trying to lockpick an unlocked vehicle.") --Notifies the player that they're lockpicking an unlocked vehicle.

            end

        else

            notify("~y~You must be near a vehicle to lockpick it.") --Notifies the player of that they need to be near a vehicle to lockpick.

        end

    end, false)

else

    TriggerEvent("chat:removeSuggestion", "/lockpick")

end

if (Winbreak == true) then

    TriggerEvent("chat:addSuggestion", "/winbreak", "Break the window of the vehicle in front of you.") --Chat suggestion for the /winbreak command.
    RegisterCommand("winbreak", function()

        local distanceToCheck = 1.0 --The distance to check in front of the player for a vehicle.
        local ped = GetPlayerPed(PlayerId())    --Gets the player ped.
        local pos = GetEntityCoords(ped)    --Gets the players coords.
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(ped, 0.0, distanceToCheck, 0.0)
        local vehicle = GetVehicleInDirection(ped, pos, inFrontOfPlayer)

        if (DoesEntityExist(vehicle)) then  --Checks if the vehicle exists.

            if (GetVehicleDoorLockStatus(vehicle) == 2) then    --Checks if the vehicle is locked.

                SetVehicleDoorsLocked(vehicle, 7)   --Sets the vehicle door lock status so you can break it.
                TaskEnterVehicle(ped, vehicle, 5000, -1, 2.0, 1, 0)  --Makes you enter the vehicle.

            elseif (GetVehicleDoorLockStatus(vehicle) == 1) then    --Checks if the vehicle is unlocked.

                notify("~y~Are you really trying to break the window of an unlocked vehicle.") --Notifies the player that they're trying to break the window of an unlocked vehicle.

            end

        else

            notify("~y~You must be near a vehicle to break its window.") --Notifies the player of that they need to be near a vehicle to lockpick.

        end

    end, false)

else

    TriggerEvent("chat:removeSuggestion", "/winbreak")

end

RegisterCommand("VehLockScriptVer", function()  --The /VehLockScriptVer command function.

    notify("~y~VehLockScript V1.4.1")   --Notifies the player of the script's version.

end, false)

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