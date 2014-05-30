//Bandit Supply Heli Crash by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)

private ["_majortimeout","_cleanmission","_playerPresent","_starttime","_coords","_MainMarker","_chopper","_wait"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMajor.sqf";

WaitUntil {MissionGo == 1};

_coords = [getMarkerPos "center",0,2500,30,0,20,0] call BIS_fnc_findSafePos;

//Mission start
[nil,nil,rTitleText,"A bandit supply helicopter has crash landed! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"A bandit supply helicopter has crash landed! Check your map for the location!"] call RE;
[nil,nil,rHINT,"Bandits have set up a medical re-supply camp! Check your map for the location!"] call RE;

MissionGoName = "Bandit Supply Heli Crash";
publicVariable "MissionGoName"; 

Ccoords = _coords;
publicVariable "Ccoords";
[] execVM "debug\addmarkers.sqf";

_chopper = ["UH1H_DZE","Mi17_DZE"] call BIS_fnc_selectRandom;

_hueychop = createVehicle [_chopper,_coords,[], 0, "NONE"];
_hueychop setVariable ["Sarge",1,true];
_hueychop setFuel 0.5;
_hueychop setVehicleAmmo 0.5;

_crate1 = createVehicle ["USLaunchersBox",[(_coords select 0) - 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate1] execVM "\z\addons\dayz_server\EMS\misc\fillBoxesS.sqf";
_crate1 setVariable ["permaLoot",true];

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) + 6, _coords select 1,0],[], 90, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\EMS\misc\fillBoxesS.sqf";
_crate2 setVariable ["permaLoot",true];

_crate3 = createVehicle ["RULaunchersBox",[(_coords select 0) - 14, (_coords select 1) -10,0],[], 0, "CAN_COLLIDE"];
[_crate3] execVM "\z\addons\dayz_server\EMS\misc\fillBoxesH.sqf";
_crate3 setVariable ["permaLoot",true];

_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,80,6,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards

_majortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_majortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _hueychop <= 350)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_majortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _hueychop < 10  } count playableunits > 0}; 

	//Mission completed/timed out
	[nil,nil,rTitleText,"The helicopter has been taken by survivors!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The helicopter has been taken by survivors!"] call RE;
	[nil,nil,rHINT,"The helicopter has been taken by survivors!"] call RE;
	[_hueychop , typeOf _hueychop] call server_updateObject;
} else {
	_hueychop setDamage 1.0;
	_hueychop setVariable ["Sarge", nil, true];
	deleteVehicle _crate2;
	deleteVehicle _crate3;
	deleteVehicle _crate4;
	[nil,nil,rTitleText,"Bandits repaired the chopper nd flied away!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"Bandits repaired the chopper nd flied away!"] call RE;
	[nil,nil,rHINT,"Bandits repaired the chopper nd flied away!"] call RE;
};

[] execVM "debug\remmarkers.sqf";

MissionGo = 0;
Ccoords = 0;
publicVariable "Ccoords";
MissionGoName = "";
publicVariable "MissionGoName"; 


SM1 = 5;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
