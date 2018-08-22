// initPlayerLocal.sqf
// Executed locally when player joins (mission start or JIP)

// Give things a moment to settle
sleep 2;

// Disable rating system so that friendlies can't turn hostile
player addEventHandler ["HandleRating", {0}];

// Add a map marker for the player, helps with MOUT
((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", '
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
'];

// Set medic trait if this player has a medkit in their backpack
if ("Medikit" in (backpackItems player)) then {
    player setUnitTrait ["Medic", true];
};

// Give anyone with the medic trait the correct ST HUD icon
STHud_IsMedic = {
    params ["_unit"];
    private _isatd = _unit getUnitTrait "Medic";
    _isatd;
};

hint "AMF loaded";
