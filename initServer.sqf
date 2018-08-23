// initServer.sqf
// Executed only on the server when the mission is started

// #define AMF_DEBUG

// Give things a moment to settle
sleep 2;

// Loop to set AI skill levels, designed for Skill 85, Precision 35
[] spawn {
    while {true} do {
        {
            _x setSkill ["aimingAccuracy", 0.01];
            _x setSkill ["aimingShake", 0.01];
            _x setSkill ["aimingSpeed", 0.01];
            _x setSkill ["commanding", 0.5];
            _x setSkill ["courage", 1.0];
            _x setSkill ["general", 0.6];
            _x setSkill ["spotDistance", 0.5];
            _x setSkill ["spotTime", 0.3];
            _x setVariable ["amf_skillSet", true];
            #ifdef AMF_DEBUG
            systemChat format ["[AMF] Set skill for %1", _x];
            #endif
        } forEach (allUnits select {!(_x getVariable ["amf_skillSet", false])});
        uiSleep 10;
    };
};

// Set Zeus parameters for maximum freedom
zeus_module setCuratorWaypointCost 0;
{
    zeus_module setCuratorCoef [_x, 0];
} forEach ["place", "edit", "delete", "destroy", "group", "synchronize"];

// Add mission objects to Zeus
zeus_module addCuratorEditableObjects [allUnits, true];
zeus_module addCuratorEditableObjects [vehicles, true];

// Set up Zeus for ACRE by disabling collision and simulation
zeus_virtual hideObjectGlobal true;
zeus_virtual enableSimulationGlobal false;

// ACRE compatibility. Tie the position of the Zeus virtual entity to the
// camera so that Zeus's voice comes out of the camera.
addMissionEventHandler ["EachFrame", {
    zeus_virtual setPos (getPos curatorCamera);
}];

systemChat "[AMF] (Server) Loaded";
