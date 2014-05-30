//Medical C-130 Crash by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)

private ["_majortimeout","_cleanmission","_playerPresent","_starttime","_coords","_MainMarker","_wait"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMajor.sqf";
WaitUntil {MissionGo == 1};

_coords = [getMarkerPos "center",0,6000,100,0,200,0] call BIS_fnc_findSafePos;

diag_log "EMS: Major mission created (SM2)";

//Mission start
[nil,nil,rTitleText,"A C-130 carrying medical supplies has crashed and bandits are securing the site! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"A C-130 carrying medical supplies has crashed and bandits are securing the site! Check your map for the location!"] call RE;
[nil,nil,rHINT,"A C-130 carrying medical supplies has crashed and bandits are securing the site! Check your map for the location!"] call RE;

MissionGoName = "Medical C-130 Crash";
publicVariable "MissionGoName"; 

Ccoords = _coords;
publicVariable "Ccoords";
[] execVM "debug\addmarkers.sqf";

_c130wreck = createVehicle ["C130J_wreck_EP1",[(_coords select 0) + 30, (_coords select 1) - 5,0],[], 0, "NONE"];
_hummer = createVehicle ["HMMWV_DZE",[(_coords select 0) - 20, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer1 = createVehicle ["UAZ_Unarmed_DZE",[(_coords select 0) - 30, (_coords select 1) - 10,0],[], 0, "CAN_COLLIDE"];
_hummer2 = createVehicle ["SUV_Camo_DZE",[(_coords select 0) + 10, (_coords select 1) + 5,0],[], 0, "CAN_COLLIDE"];

_c130wreck setVariable ["Sarge",1,true];
_hummer setVariable ["Sarge",1,true];
_hummer1 setVariable ["Sarge",1,true];
_hummer2 setVariable ["Sarge",1,true];

_crate = createVehicle ["USVehicleBox",[(_coords select 0) - 10, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxesM.sqf";
_crate setVariable ["permaLoot",true];

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";
_crate2 setVariable ["permaLoot",true];

_aispawn = [[(_coords select 0) + 20, _coords select 1,0],80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [[(_coords select 0) + 30, _coords select 1,0],80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [[(_coords select 0) + 20, _coords select 1,0],40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [[(_coords select 0) + 30, _coords select 1,0],40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards

_majortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_majortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _c130wreck <= 350)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_majortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _c130wreck < 20 } count playableunits > 0}; 

	//Mission completed/timed out
	[nil,nil,rTitleText,"The crash site has been secured by survivors!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The crash site has been secured by survivors!"] call RE;
	[nil,nil,rHINT,"The crash site has been secured by survivors!"] call RE;
	[_hummer , typeOf _hummer] call server_updateObject;
	[_hummer1 , typeOf _hummer2] call server_updateObject;
	[_hummer2 , typeOf _hummer3] call server_updateObject;
} else {
	_hummer setDamage 1.0;
	_hummer setVariable ["Sarge", nil, true];
	_hummer2 setDamage 1.0;
	_hummer2 setVariable ["Sarge", nil, true];
	_hummer1 setDamage 1.0;
	_hummer1 setVariable ["Sarge", nil, true];
	deleteVehicle _c130wreck;
	deleteVehicle _crate;
	deleteVehicle _crate2;
	[nil,nil,rTitleText,"Bandits moved over with all the loot!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"Bandits moved over with all the loot!"] call RE;
	[nil,nil,rHINT,"Bandits moved over with all the loot!"] call RE;
};

[] execVM "debug\remmarkers.sqf";

MissionGo = 0;
Ccoords = 0;
publicVariable "Ccoords";
MissionGoName = "";
publicVariable "MissionGoName"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";