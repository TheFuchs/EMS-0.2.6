//Medical Crate by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)

private ["_majortimeout","_cleanmission","_playerPresent","_starttime","_coords","_MainMarker","_wait"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMajor.sqf";

WaitUntil {MissionGo == 1};

_coords = [getMarkerPos "center",0,4800,30,0,2000,0] call BIS_fnc_findSafePos;

diag_log "EMS: Major Mission Created (SM6)";

//Mission start
[nil,nil,rTitleText,"A medical supply crate has been secured by bandits! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"A medical supply crate has been secured by bandits! Check your map for the location!"] call RE;
[nil,nil,rHINT,"A medical supply crate has been secured by bandits! Check your map for the location!"] call RE;

MissionGoName = "Medical Crate";
publicVariable "MissionGoName"; 

Ccoords = _coords;
publicVariable "Ccoords";
[] execVM "debug\addmarkers.sqf";

_hummer = createVehicle ["HMMWV_DZE",[(_coords select 0) + 10, (_coords select 1) - 10,0],[], 0, "CAN_COLLIDE"];
_hummer1 = createVehicle ["UAZ_Unarmed_DZE",[(_coords select 0) + 20, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

_hummer setVariable ["Sarge",1,true];
_hummer1 setVariable ["Sarge",1,true];

_crate = createVehicle ["USVehicleBox",[(_coords select 0) - 1, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxesM.sqf";
_crate setVariable ["permaLoot",true];

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";
_crate2 setVariable ["permaLoot",true];

_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards

_majortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_majortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _crate <= 350)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_majortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _crate < 15  } count playableunits > 0}; 

	//Mission completed/timed out
	[nil,nil,rTitleText,"The medical crate is under survivor control!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The medical crate is under survivor control!"] call RE;
	[nil,nil,rHINT,"The medical crate is under survivor control!"] call RE;
	[_hummer , typeOf _hummer] call server_updateObject;
	[_hummer1 , typeOf _hummer1] call server_updateObject;
} else {
	_hummer setDamage 1.0;
	_hummer setVariable ["Sarge", nil, true];
	_hummer1 setDamage 1.0;
	_hummer1 setVariable ["Sarge", nil, true];
	deleteVehicle _crate;
	deleteVehicle _crate2;
	[nil,nil,rTitleText,"Bandits have moved the medical crate!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"Bandits have moved the medical crate!"] call RE;
	[nil,nil,rHINT,"Bandits have moved the medical crate!"] call RE;
};

[] execVM "debug\remmarkers.sqf";

MissionGo = 0;
Ccoords = 0;
publicVariable "Ccoords";
MissionGoName = "";
publicVariable "MissionGoName"; 

SM1 = 5;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
