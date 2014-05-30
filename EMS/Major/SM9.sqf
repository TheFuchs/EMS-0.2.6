//Firebase mission Created by TheSzerdi Edited by Falcyn [QF]

private ["_majortimeout","_cleanmission","_playerPresent","_starttime","_coords","_dummymarker","_base","_wait","_coord1","_coord2","_coord3","_coord4","_coord5","_coord6","_coord7","_coord8","_coord9","_coord10","_coord11","_coord12"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMajor.sqf";
WaitUntil {MissionGo == 1};

_coord1 = [4908.355,11216.505,0];
_coord2 = [6162.9888,11324.005,0];
_coord3 = [7761.3657,11569.265,0];
_coord4 = [8336.6055,10441.17,0];
_coord5 = [7201.0664,10400.667,0];
_coord6 = [6249.1104,9579.043,0];
_coord7 = [4763.3818,9802.2734,0];
_coord8 = [3675.6865,7353.2798,0];
_coord9 = [6815.6362,5599.0854,0];
_coord10 = [7532.0742,8164.3203,0];
_coord11 = [6046.6455,8771.2178,0];
_coord12 = [5266.6836,7273.8135,0];

_coords = [_coord1, _coord2, _coord3, _coord4, _coord5, _coord6, _coord7, _coord8, _coord9, _coord10, _coord11, _coord12] call BIS_fnc_selectRandom;

diag_log "EMS: Major Mission Created (SM9)";

//Mission start
[nil,nil,rTitleText,"A firebase is being constructed! Stop the bandits and secure the construction materials for yourself!", "PLAIN",6] call RE;
[nil,nil,rGlobalRadio,"A firebase is being constructed! Stop the bandits and secure the construction materials for yourself!"] call RE;
[nil,nil,rHINT,"A firebase is being constructed! Stop the bandits and secure the construction materials for yourself!"] call RE;

MissionGoName = "Bandit Firebase";
publicVariable "MissionGoName"; 

Ccoords = _coords;
publicVariable "Ccoords";
[] execVM "debug\addmarkers.sqf";

_base = ["Land_fortified_nest_big","Land_Fort_Watchtower_EP1"] call BIS_fnc_selectRandom;
_baserunover = createVehicle [_base,[(_coords select 0) - 20, (_coords select 1) - 10,-0.2],[], 0, "NONE"];

_crate = createVehicle ["USLaunchersBox",[(_coords select 0) + 2, (_coords select 1),0],[], 0, "NONE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillConstructionMajor.sqf";
_crate setVariable ["permaLoot",true];

_aispawn = [_coords,20,3,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server4.sqf";//AI Guards
sleep 2;
_aispawn = [_coords,40,3,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server4.sqf";//AI Guards
sleep 2;
_aispawn = [_coords,60,4,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server4.sqf";//AI Guards
sleep 2;
_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server4.sqf";//AI Guards

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
	waitUntil{{isPlayer _x && _x distance _crate < 20  } count playableunits > 0}; 

    //Mission completed/timed out
	[nil,nil,rTitleText,"Survivors have secured the construction materials.", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"Survivors have secured the construction materials."] call RE;
	[nil,nil,rHINT,"Survivors have secured the construction materials."] call RE;
} else {
	deleteVehicle _baserunover;
	deleteVehicle _base;
	deleteVehicle _crate;
	[nil,nil,rTitleText,"Bandits left their firebase!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"Bandits left their firebase!"] call RE;
	[nil,nil,rHINT,"Bandits left their firebase!"] call RE;
};

[] execVM "debug\remmarkers.sqf";

MissionGo = 0;
Ccoords = 0;
publicVariable "Ccoords";
MissionGoName = "";
publicVariable "MissionGoName"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
