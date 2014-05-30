//Bandit Stash House by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)

private ["_minortimeout","_cleanmission","_playerPresent","_starttime","_coords","_wait","_MainMarker75"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMinor.sqf";
WaitUntil {MissionGoMinor == 1};
publicVariable "MissionGoMinor";

_coords =  [getMarkerPos "center",0,5000,10,0,20,0] call BIS_fnc_findSafePos;

diag_log "EMS: Minor mission created (SM3)";

//Mission start
[nil,nil,rTitleText,"A group of bandits have set up a stash house! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"A group of bandits have set up a stash house! Check your map for the location!"] call RE;
[nil,nil,rHINT,"A group of bandits have set up a stash house! Check your map for the location!"] call RE;

MissionGoNameMinor = "Bandit Stash House";
publicVariable "MissionGoNameMinor"; 

MCoords = _coords;
publicVariable "MCoords";
[] execVM "debug\addmarkers75.sqf";

_baserunover = createVehicle ["Land_HouseV_1I3",[(_coords select 0) +2, (_coords select 1) +5,-0.3],[], 0, "CAN_COLLIDE"];
_baserunover2 = createVehicle ["Land_hut06",[(_coords select 0) - 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_baserunover3 = createVehicle ["Land_hut06",[(_coords select 0) - 7, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

_hummer = createVehicle ["HMMWV_DZ",[(_coords select 0) + 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer2 = createVehicle ["UAZ_Unarmed_UN_EP1",[(_coords select 0) - 25, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer3 = createVehicle ["SUV_TK_EP1",[(_coords select 0) + 25, (_coords select 1) - 15,0],[], 0, "CAN_COLLIDE"];

_baserunover setVariable ["Sarge",1,true];
_baserunover2 setVariable ["Sarge",1,true];
_baserunover3 setVariable ["Sarge",1,true];

_hummer setVariable ["Sarge",1,true];
_hummer2 setVariable ["Sarge",1,true];
_hummer3 setVariable ["Sarge",1,true];

_crate = createVehicle ["USVehicleBox",[(_coords select 0) - 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxes.sqf";

[[(_coords select 0) - 20, (_coords select 1) - 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;
[[(_coords select 0) + 20, (_coords select 1) + 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;

_minortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_minortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _baserunover <= 250)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_minortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _baserunover < 10  } count playableunits > 0}; 

	//Mission completed/timed out
	[nil,nil,rTitleText,"The stash house is under survivor control!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The stash house is under survivor control!"] call RE;
    [nil,nil,rHINT,"The stash house is under survivor control!"] call RE;
	[_hummer , typeOf _hummer] call server_updateObject;
	[_hummer2 , typeOf _hummer2] call server_updateObject;
	[_hummer3 , typeOf _hummer3] call server_updateObject;
} else {
	_hummer setDamage 1.0;
	_hummer setVariable ["Sarge", nil, true];
	_hummer2 setDamage 1.0;
	_hummer2 setVariable ["Sarge", nil, true];
	_hummer3 setDamage 1.0;
	_hummer3 setVariable ["Sarge", nil, true];
	deleteVehicle _baserunover;
	deleteVehicle _baserunover2;
	deleteVehicle _baserunover3;
	deleteVehicle _crate;
	[nil,nil,rTitleText,"The stash house exploded!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The stash house exploded!"] call RE;
	[nil,nil,rHINT,"The stash house exploded!"] call RE;
};

[] execVM "debug\remmarkers75.sqf";

MissionGoMinor = 0;
publicVariable "MissionGoMinor";
MCoords = 0;
publicVariable "MCoords";
MissionGoNameMinor = "";
publicVariable "MissionGoNameMinor"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";