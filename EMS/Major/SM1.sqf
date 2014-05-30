//Bandit Hunting Party by lazyink (Full credit to TheSzerdi & TAW_Tonic for the code)
//Re-Edited for EMS by Firefly,Fuchs,williamjbrown

private ["_minortimeout","_cleanmission","_playerPresent","_starttime","_coords","_wait","_MainMarker75"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMinor.sqf";
WaitUntil {MissionGoMinor == 1};

_coords = [getMarkerPos "center",0,5500,2,0,2000,0] call BIS_fnc_findSafePos;

diag_log "EMS: Minor mission created (SM1)";

//Mission start
[nil,nil,rTitleText,"A bandit hunting party has been spotted! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"A bandit hunting party has been spotted! Check your map for the location!"] call RE;
[nil,nil,rHINT,"A bandit hunting party has been spotted! Check your map for the location!"] call RE;

MissionGoNameMinor = "Bandit Hunting Party";
publicVariable "MissionGoNameMinor"; 

MCoords = _coords;
publicVariable "MCoords";
[] execVM "debug\addmarkers75.sqf";

_hummer = createVehicle ["HMMWV_DES_EP1_DZE",[(_coords select 0) + 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer setVariable ["Sarge",1,true];

[_coords,80,4,2,1] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 5;
[_coords,80,4,2,1] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 5;
[_coords,80,4,2,1] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 1;

_minortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_minortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _hummer <= 250)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_minortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{({alive _x} count (units SniperTeam)) < 1};

	//Mission completed
	[nil,nil,rTitleText,"The hunting party has been wiped out!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The hunting party has been wiped out!"] call RE;
	[nil,nil,rHINT,"The hunting party has been wiped out!"] call RE;
	[_hummer , typeOf _hummer] call server_updateObject;
} else {
	_hummer setDamage 1.0;
	_hummer setVariable ["Sarge", nil, true];
	[nil,nil,rTitleText,"The party is over!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The party is over!"] call RE;
	[nil,nil,rHINT,"The party has is over!"] call RE;
};

[] execVM "debug\remmarkers75.sqf";

MissionGoMinor = 0;
MCoords = 0;
publicVariable "MCoords";
MissionGoNameMinor = "";
publicVariable "MissionGoNameMinor"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";