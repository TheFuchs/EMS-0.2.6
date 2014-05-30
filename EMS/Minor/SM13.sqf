//Axe murderer script Created by TheSzerdi Edited by Falcyn [QF]

private ["_minortimeout","_cleanmission","_playerPresent","_starttime","_coords","_wait","_dummymarker","_grouparray","_group"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMinor.sqf";
WaitUntil {MissionGoMinor == 1};

_coords = [getMarkerPos "center",0,6000,2,0,200,0] call BIS_fnc_findSafePos;

diag_log "EMS: Minor Mission Created (SM13)";

//Mission start
[nil,nil,rTitleText,"A psychotic axe murderer has escaped from the hospital!", "PLAIN",6] call RE;
[nil,nil,rGlobalRadio,"A psychotic axe murderer has escaped from the hospital!"] call RE;
[nil,nil,rHINT,"A psychotic axe murderer has escaped from the hospital!"] call RE;

MissionGoNameMinor = "Axe Murderer";
publicVariable "MissionGoNameMinor"; 

MCoords = _coords;
publicVariable "MCoords";
[] execVM "debug\addmarkers75.sqf";

[_coords,80,4,1,2] execVM "\z\addons\dayz_server\Missions\add_unit_server5.sqf";//AI Guards
sleep 1;

_minortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_minortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _coords <= 250)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_minortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{({alive _x} count (units AxeMurderer)) < 1};

	//Mission completed/timed out
	[nil,nil,rTitleText,"Finally! He died! Check the body for medical supplies!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"Finally! He died! Check the body for medical supplies!"] call RE;
	[nil,nil,rHINT,"Finally! He died! Check the body for medical supplies!"] call RE;
} else {
	[nil,nil,rTitleText,"The axe murderer has escaped!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The axe murderer has escaped!"] call RE;
	[nil,nil,rHINT,"The axe murderer has escaped!"] call RE;
};

[] execVM "debug\remmarkers75.sqf";

MissionGoMinor = 0;
MCoords = 0;
publicVariable "MCoords";
MissionGoNameMinor = "";
publicVariable "MissionGoNameMinor"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\Minor\SMfinder.sqf";