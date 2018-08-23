// onPlayerRespawn.sqf
// Executed locally? when the player respawns

// #define AMF_DEBUG

// Reload saved loadout
player setUnitLoadout (player getVariable ["amf_playerLoadout", []]);

// Zeus shouldn't have to respawn, but if they do we need to re-enable some
// stuff and move them back from the edge of the map.
if (player == zeus_virtual) then {
    [zeus_virtual, true] remoteExec ["hideObjectGlobal", 2];
    [zeus_virtual, false] remoteExec ["enableSimulationGlobal", 2];
    openCuratorInterface;
    private _pos = (getPos zeus_commander) params ["_x", "_y", "_z"];
    curatorCamera setPos [_x, _y, _z + 5];
};

// Restore ACRE2 radio channels
{
    private _id = [_x] call acre_api_fnc_getRadioByType;
    private _channel = player getVariable [format ["%1_channel", _x], 1];

    if (not isNil "_id") then {
        [_id, _channel] call acre_api_fnc_setRadioChannel;
        diag_log text format ["[AMF] Set %1's radio %2 to channel %3", (name player), _id, _channel];
    };
} forEach ["ACRE_PRC343", "ACRE_PRC148"];

["<t color='#ccffffff' shadow = '2' size = '.6'>Restored ACRE radio channels</t>", -1, 0.95, 3.5, 1] spawn BIS_fnc_dynamicText;
