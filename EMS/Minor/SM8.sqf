//Landing party sidemission Created by TheSzerdi Edited by Falcyn [QF]

private ["_minortimeout","_cleanmission","_playerPresent","_starttime","_coord1","_coord2","_coord3","_coords","_wait","_dummymarker"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMinor.sqf";
WaitUntil {MissionGoMinor == 1};

//Mission start
[nil,nil,rTitleText,"A landing party is establishing a beachhead!", "PLAIN",6] call RE;
[nil,nil,rGlobalRadio,"A landing party is establishing a beachhead!"] call RE;
[nil,nil,rHINT,"A landing party is establishing a beachhead!"] call RE;

MissionGoNameMinor = "Landing Party";
publicVariable "MissionGoNameMinor"; 

_coord1 = [[7871.2979,3066.8784,0],[7813.6245,3113.5232,0]];
_coord2 = [[7785.7861,3124.6489,0],[7690.1489,3114.0837,0]];
_coord3 = [[7661.8218,3099.8113,0],[7597.4658,3051.6685,0]];

_coords = [_coord1, _coord2, _coord3] call BIS_fnc_selectRandom;

diag_log "EMS: Minor mission created (SM8)";

MCoords = _coords select 1;
publicVariable "MCoords";
[] execVM "debug\addmarkers75.sqf";

_pbxride = createVehicle ["PBX",_coords select 0,[], 0, "NONE"];
_pbxride setVariable ["Sarge",1,true];
_pbxride setFuel 1;

[_coords select 0,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server6.sqf";//AI Guards
sleep 3;
LandingParty addVehicle _pbxride;
LandingParty move (_coords select 1);
waitUntil{(_pbxride distance (_coords select 1)) < 50}; 
_tent = createVehicle ["TentStorage",_coords select 1,[], 0, "NONE"];
_tent setVariable ["Sarge",1,true];
sleep 1;

_tent addWeaponCargoGlobal   ["ItemCompass", 2];
_tent addWeaponCargoGlobal   ["ItemGPS", 3];
_tent addWeaponCargoGlobal   ["NVGoggles", 1];
_tent addMagazineCargoGlobal ["FoodCanBakedBeans", 4];
_tent addMagazineCargoGlobal ["ItemBandage", 4];
_tent addMagazineCargoGlobal ["ItemMorphine", 4];
_tent addMagazineCargoGlobal ["ItemPainkiller", 4];
_tent addMagazineCargoGlobal ["ItemAntibiotic", 2];
_tent addWeaponCargoGlobal   ["ItemKnife", 2];
_tent addWeaponCargoGlobal   ["ItemToolbox", 2];
_tent addWeaponCargoGlobal   ["ItemMatches", 2];
_tent addMagazineCargoGlobal ["ItemBloodbag", 2];
_tent addMagazineCargoGlobal ["ItemJerryCan", 2];
_tent addMagazineCargoGlobal ["MP5A5", 2];
_tent addMagazineCargoGlobal ["30Rnd_9x19_MP5", 5];
_tent addMagazineCargoGlobal ["glock17_EP1", 2];
_tent addMagazineCargoGlobal ["17Rnd_9x19_glock17", 4];

_minortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_minortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _tent <= 250)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_minortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _tent < 10  } count playableunits > 0};

	//Mission completed/timed out
	[nil,nil,rTitleText,"You've secured the beachhead! Good work.", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"You've secured the beachhead! Good work."] call RE;
	[nil,nil,rHINT,"You've secured the beachhead! Good work."] call RE;
	[_pbxride , typeOf _pbxride] call server_updateObject;
} else {
	deleteVehicle _tent;
	_pbxride setDamage 1.0;
	_pbxride setVariable ["Sarge", nil, true];
	[nil,nil,rTitleText,"The beachhead has been moved by bandits!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The beachhead has been moved by bandits!"] call RE;
	[nil,nil,rHINT,"The beachhead has been moved by bandits!"] call RE;
};

[] execVM "debug\remmarkers75.sqf";

MissionGoMinor = 0;
MCoords = 0;
publicVariable "MCoords";
MissionGoNameMinor = "";
publicVariable "MissionGoNameMinor"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";