//Sniper team script Created by TheSzerdi Edited by Falcyn [QF]

private ["_minortimeout","_cleanmission","_playerPresent","_starttime","_coords","_wait","_dummymarker"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMinor.sqf";
WaitUntil {MissionGoMinor == 1};

_coords = [getMarkerPos "center",0,7000,2,0,2000,0] call BIS_fnc_findSafePos;

diag_log "EMS: Minor mission created (SM7)";

//Mission start
[nil,nil,rTitleText,"A sniper team has been spotted!", "PLAIN",6] call RE;
[nil,nil,rGlobalRadio,"A sniper team has been spotted!"] call RE;
[nil,nil,rHINT,"A sniper team has been spotted!"] call RE;

MissionGoNameMinor = "Sniper Team";
publicVariable "MissionGoNameMinor"; 

MCoords = _coords;
publicVariable "MCoords";
[] execVM "debug\addmarkers75.sqf";

[_coords,80,4,2,1] execVM "\z\addons\dayz_server\missions\add_unit_server5.sqf";//AI Guards
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
	waitUntil{({alive _x} count (units SniperTeam)) < 1};

	//Mission completed/timed out
	[nil,nil,rTitleText,"You've killed the snipers! Now loot the corpses!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"You've killed the snipers! Now loot the corpses!"] call RE;
	[nil,nil,rHINT,"You've killed the snipers! Now loot the corpses!"] call RE;
} else {
	[nil,nil,rTitleText,"The snipers moved over!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The snipers moved over!"] call RE;
	[nil,nil,rHINT,"The snipers moved over!"] call RE;
};

[] execVM "debug\remmarkers75.sqf";

MissionGoMinor = 0;
MCoords = 0;
publicVariable "MCoords";
MissionGoNameMinor = "";
publicVariable "MissionGoNameMinor"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";
