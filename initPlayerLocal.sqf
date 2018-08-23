// initPlayerLocal.sqf
// Executed locally when player joins (mission start or JIP)

// Give things a moment to settle
sleep 2;

// Zeus settings
if (player == zeus_virtual) then {
    // Add a respawn point for Zeus in case some mod kills them with setDamage
    [zeus_virtual, zeus_module] call BIS_fnc_addRespawnPosition;
    // Make Zeus mostly invulnerable, can still be killed by setDamage
    zeus_virtual allowDamage false;
};
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

// Set medic trait if this player has a medkit in their backpack
if ("Medikit" in (backpackItems player)) then {
    player setUnitTrait ["medic", true];
};

// Give anyone with the medic trait the correct ST HUD icon
STHud_IsMedic = {
    params ["_unit"];
    _unit getUnitTrait "medic"
};

hint "AMF loaded";
