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
