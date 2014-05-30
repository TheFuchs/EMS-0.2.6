//Medical Ural Attack by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)

private ["_majortimeout","_cleanmission","_playerPresent","_starttime","_coords","_MainMarker","_chopper","_wait"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMajor.sqf";

WaitUntil {MissionGo == 1};

_coords = [getMarkerPos "center",0,3800,30,0,200,0] call BIS_fnc_findSafePos;

diag_log "EMS: Major Mission Created (SM5)";

//Mission start
[nil,nil,rTitleText,"Bandits have destroyed a Ural carrying medical supplies and are securing the cargo! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"Bandits have destroyed a Ural carrying medical supplies and are securing the cargo! Check your map for the location!"] call RE;
[nil,nil,rHINT,"Bandits have destroyed a Ural carrying medical supplies and are securing the cargo! Check your map for the location!"] call RE;

MissionGoName = "Medical Ural Attack";
publicVariable "MissionGoName"; 

Ccoords = _coords;
publicVariable "Ccoords";
[] execVM "debug\addmarkers.sqf";

_uralcrash = createVehicle ["UralWreck",_coords,[], 0, "CAN_COLLIDE"];
_uralcrash setVariable ["Sarge",1,true];

_hummer = createVehicle ["UAZ_Unarmed_DZE",[(_coords select 0) + 20, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer1 = createVehicle ["HMMWV_DZE",[(_coords select 0) + 30, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

_hummer setVariable ["Sarge",1,true];
_hummer1 setVariable ["Sarge",1,true];

_crate = createVehicle ["USVehicleBox",[(_coords select 0) - 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxesM.sqf";
_crate setVariable ["permaLoot",true];

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 10, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";
_crate2 setVariable ["permaLoot",true];

_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;

_majortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_majortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _uralcrash <= 350)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_majortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _uralcrash < 10  } count playableunits > 0}; 

	//Mission completed/timed out
	[nil,nil,rTitleText,"The medical supplies have been secured by survivors!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The medical supplies have been secured by survivors!"] call RE;
	[nil,nil,rHINT,"The medical supplies have been secured by survivors!"] call RE;
	[_hummer , typeOf _hummer] call server_updateObject;
	[_hummer1 , typeOf _hummer1] call server_updateObject;
} else {
	_hummer setDamage 1.0;
	_hummer setVariable ["Sarge", nil, true];
	_hummer1 setDamage 1.0;
	_hummer1 setVariable ["Sarge", nil, true];
	deleteVehicle _crate;
	deleteVehicle _crate2;
	[nil,nil,rTitleText,"Bandits flew with the cargo!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"Bandits flew with the cargo!"] call RE;
	[nil,nil,rHINT,"Bandits flew with the cargo!"] call RE;
};

[] execVM "debug\remmarkers.sqf";

MissionGo = 0;
Ccoords = 0;
publicVariable "Ccoords";
MissionGoName = "";
publicVariable "MissionGoName"; 


SM1 = 5;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
