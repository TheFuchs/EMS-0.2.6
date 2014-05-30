//Weapon Truck Crash by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)

private ["_minortimeout","_cleanmission","_playerPresent","_starttime","_coords","_wait","_MainMarker75"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMinor.sqf";
WaitUntil {MissionGoMinor == 1};

_coords = [getMarkerPos "center",0,5800,10,0,200,0] call BIS_fnc_findSafePos;

diag_log "EMS: Minor mission created (SM6)";

//Mission start
[nil,nil,rTitleText,"A bandit weapons truck has crashed! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"A bandit weapons truck has crashed! Check your map for the location!"] call RE;
[nil,nil,rHINT,"A bandit weapons truck has crashed! Check your map for the location!"] call RE;

MissionGoNameMinor = "Weapon Truck Crash";
publicVariable "MissionGoNameMinor"; 

MCoords = _coords;
publicVariable "MCoords";
[] execVM "debug\addmarkers75.sqf";

_uralcrash = createVehicle ["UralWreck",_coords,[], 0, "CAN_COLLIDE"];
_uralcrash setVariable ["Sarge",1,true];

_crate = createVehicle ["USLaunchersBox",[(_coords select 0) + 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxes.sqf";

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";

_crate3 = createVehicle ["RULaunchersBox",[(_coords select 0) - 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate3] execVM "\z\addons\dayz_server\missions\misc\fillBoxesH.sqf";

[_coords,40,4,3,0] execVM "\z\addons\dayz_server\Missions\add_unit_server.sqf";//AI Guards
sleep 1;
[_coords,40,4,3,0] execVM "\z\addons\dayz_server\Missions\add_unit_server.sqf";//AI Guards
sleep 1;
[_coords,40,4,3,0] execVM "\z\addons\dayz_server\Missions\add_unit_server.sqf";//AI Guards
sleep 1;
[_coords,40,4,3,0] execVM "\z\addons\dayz_server\Missions\add_unit_server.sqf";//AI Guards
sleep 1;

_minortimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);
while {_minortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _uralcrash <= 250)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_minortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _uralcrash < 10  } count playableunits > 0}; 

	//Mission completed/timed out
	[nil,nil,rTitleText,"The crash site has been secured by survivors!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The crash site has been secured by survivors!"] call RE;
	[nil,nil,rHINT,"The crash site has been secured by survivors!"] call RE;
} else {
	deleteVehicle _uralcrash;
	deleteVehicle _crate;
	deleteVehicle _crate2;
	deleteVehicle _crate3;
	[nil,nil,rTitleText,"The crash site has been secured by bandits!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The crash site has been secured by bandits!"] call RE;
	[nil,nil,rHINT,"The crash site has been secured by bandits!"] call RE;
};

[] execVM "debug\remmarkers75.sqf";

MissionGoMinor = 0;
MCoords = 0;
publicVariable "MCoords";
MissionGoNameMinor = "";
publicVariable "MissionGoNameMinor"; 

SM1 = 5;
[0] execVM "\z\addons\dayz_server\missions\Minor\SMfinder.sqf";