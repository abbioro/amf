// initPlayerLocal.sqf
// Executed locally when a player joins (mission start or JIP)

// #define AMF_DEBUG

[] execVM "briefing.sqf";

// Give things a moment to settle
sleep 2;

// Zeus settings
if (player == zeus_virtual) then {
    // Add a respawn point for Zeus in case some mod kills them with setDamage
    [zeus_virtual, zeus_module] call BIS_fnc_addRespawnPosition;
    // Make Zeus mostly invulnerable, can still be killed by setDamage
    zeus_virtual allowDamage false;
    // Set up Zeus for ACRE by disabling collision and simulation
    [zeus_virtual, true] remoteExec ["hideObjectGlobal", 2];
    [zeus_virtual, false] remoteExec ["enableSimulationGlobal", 2];
    // ACRE compatibility. Tie the position of the Zeus virtual entity to the
    // camera so that Zeus's voice comes out of the camera.
    addMissionEventHandler ["EachFrame", {
        zeus_virtual setPos (getPos curatorCamera);
    }];
} else {
    // Add this player to curator objects so Zeus can keep track of them
    [zeus_module, [[player]]] remoteExec ["addCuratorEditableObjects", 2];
};

// Add this player to curator objects so Zeus can keep track of them
[zeus_module, [[player]]] remoteExec ["addCuratorEditableObjects", 2];

// Make players invulnerable when downed. Works by removing the HandleDamage
// handler that the Revive system adds and replacing it with one that leaves the
// player unharmed if they are incapacitated. Credit for the code goes to Caddrel.
waitUntil {!isNil {player getVariable "bis_revive_ehHandleDamage"}};
player removeEventHandler["HandleDamage", player getVariable "bis_revive_ehHandleDamage"];
player addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_damage"];

    // != is a little faster than isEqualTo, which matters in a HandleDamage EH
    if (lifeState player != "INCAPACITATED") then {
        _damage = _this call bis_fnc_reviveEhHandleDamage;
    } else {
        _damage = 0;
    };
    _damage
}];

// Save player's loadout so it can be restored on respawn
player setVariable ["amf_playerLoadout", getUnitLoadout player];

// Disable rating system so that friendlies can't turn hostile
player addEventHandler ["HandleRating", {0}];

// Add a map marker for the player, helps with MOUT
((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
    (positionCameraToWorld [0,0,1] vectorDiff positionCameraToWorld [0,0,0]) params ["_lx", "_ly"];
    _vehicle = vehicle player;
    (_this select 0) drawIcon [
        getText (configFile/"CfgVehicles"/typeOf player/"Icon"),
        [0,1,0,1],
        getPosATLVisual(_vehicle),
        1.0/ctrlMapScale (_this select 0),
        1.0/ctrlMapScale (_this select 0),
        _lx atan2 _ly,
        "",
        1
    ];
}];

player addEventHandler ["Killed", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    // Save ACRE2 radio channels
    {
        private _id = [_x] call acre_api_fnc_getRadioByType;
        if (not isNil "_id") then {
            _channel = [_id] call acre_api_fnc_getRadioChannel;
            player setVariable [format ["%1_channel", _x], _channel];
        };
    } forEach ["ACRE_PRC343", "ACRE_PRC148"];
}];

// Set medic trait if this player has a medkit in their backpack
if ("Medikit" in (backpackItems player)) then {
    player setUnitTrait ["medic", true];
};

// Give anyone with the medic trait the correct ST HUD icon
STHud_IsMedic = {
    params ["_unit"];
    _unit getUnitTrait "medic"
};

systemChat "[AMF] Loaded";
