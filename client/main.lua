--[[
    File Name:		main.lua
	Programmer:		Mickaël Papineau
	Date:			2021/06/05
	Version:		1.4.3
	Description:    This script is the main client side script.
]]--

--Variables [Do Not Modify]
local OwnVehID    --The ID of the vehicle that was locked.
local OwnVehLock = false    --If there is a vehicle that is already locked by the player.

TriggerEvent("chat:addSuggestion", "/lock", "Locks the vehicle that you last driven.") --Chat suggestion for the /lock command.
RegisterCommand("lock", function()  --The /lock command function.

    if (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        SetVehicleDoorsLocked(GetLastDrivenVehicle(), 2)    --Locks the vehicle.
        SetVehicleAlarm(GetLastDrivenVehicle(), true)   --Turns on the vehicles alarm.
        OwnVehID = NetworkGetNetworkIdFromEntity(GetLastDrivenVehicle())   --Sets the OwnVehID to the locked vehicle's ID.
        OwnVehLock = true   --Sets the OwnVehLock to true.
        TriggerEvent("Notify", 11)  --Notifies the player of the commands success status.

    elseif (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        TriggerEvent("Notify", 21)  --Notifies the player of the commands failed status.

    end

end, false)

TriggerEvent("chat:addSuggestion", "/unlock", "Unlocks the vehicle that you locked.") --Chat suggestion for the /unlock command.
RegisterCommand("unlock", function()    --The /unlock command function.

    if (OwnVehLock == true) then    --If there's a locked vehicle by the player.

        SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(OwnVehID), 1)    --Unlocks the vehicle.
        SetVehicleAlarm(NetworkGetEntityFromNetworkId(OwnVehID), false)    --Turns off the vehicles alarm.
        OwnVehLock = false  --Sets the OwnVehLock to false.
        TriggerEvent("Notify", 31)  --Notifies the player of the commands success status.

    elseif (OwnVehLock == false) then   --If there's no locked vehicle by the player.

        TriggerEvent("Notify", 22)  --Notifies the player of the commands failed status.

    end

end, false)

if (Config.Lockpick == true) then

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
                    TriggerEvent("Notify", 12)  --Notifies the player of there results of lockpicking.

                elseif (almChance == 8) then    --10% chance of being unsuccessful.

                    StartVehicleAlarm(vehicle)  --Triggers the vehicles alarm.
                    TriggerEvent("Notify", 32)  --Notifies the player of there results of lockpicking.

                else   --80% chance of set off the alarm.

                    SetVehicleDoorsLocked(vehicle, 1)    --Unlocks the vehicle
                    StartVehicleAlarm(vehicle)  --Triggers the vehicles alarm.
                    TriggerEvent("Notify", 23)  --Notifies the player of there results of lockpicking.

                end

            elseif (GetVehicleDoorLockStatus(vehicle) == 1) then    --Checks if the vehicle is unlocked.

                TriggerEvent("Notify", 24)  --Notifies the player that they're lockpicking an unlocked vehicle.

            end

        else

            TriggerEvent("Notify", 25)  --Notifies the player of that they need to be near a vehicle to lockpick.

        end

    end, false)

else

    TriggerEvent("chat:removeSuggestion", "/lockpick")

end

if (Config.Winbreak == true) then

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

                TriggerEvent("Notify", 26)  --Notifies the player that they're trying to break the window of an unlocked vehicle.

            end

        else

            TriggerEvent("Notify", 27)  --Notifies the player of that they need to be near a vehicle to lockpick.

        end

    end, false)

else

    TriggerEvent("chat:removeSuggestion", "/winbreak")

end

RegisterCommand("VehLockScriptVer", function()  --The /VehLockScriptVer command function.

    TriggerEvent("Notify", 1)   --Notifies the player of the script's version.

end, false)
