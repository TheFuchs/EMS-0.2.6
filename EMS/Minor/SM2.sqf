//Medical Outpost by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)

private ["_minortimeout","_cleanmission","_playerPresent","_starttime","_coords","_wait","_MainMarker75"];
[] execVM "\z\addons\dayz_server\Missions\SMGoMinor.sqf";
WaitUntil {MissionGoMinor == 1};

_coords =  [getMarkerPos "center",0,5800,10,0,20,0] call BIS_fnc_findSafePos;

diag_log "EMS: Minor mission created (SM2)";

//Mission start
[nil,nil,rTitleText,"A group of bandits have taken over a Medical Outpost! Check your map for the location!", "PLAIN",10] call RE;
[nil,nil,rGlobalRadio,"A group of bandits have taken over a Medical Outpost! Check your map for the location!"] call RE;
[nil,nil,rHINT,"A group of bandits have taken over a Medical Outpost! Check your map for the location!"] call RE;

MissionGoNameMinor = "Medical Outpost";
publicVariable "MissionGoNameMinor"; 

MCoords = _coords;
publicVariable "MCoords";
[] execVM "debug\addmarkers75.sqf";

_baserunover = createVehicle ["US_WarfareBFieldhHospital_Base_EP1",[(_coords select 0) +2, (_coords select 1)+5,-0.3],[], 0, "CAN_COLLIDE"];
_baserunover1 = createVehicle ["MASH_EP1",[(_coords select 0) - 24, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_baserunover2 = createVehicle ["MASH_EP1",[(_coords select 0) - 17, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_baserunover3 = createVehicle ["MASH_EP1",[(_coords select 0) - 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_baserunover4 = createVehicle ["UAZ_Unarmed_UN_EP1",[(_coords select 0) + 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_baserunover5 = createVehicle ["HMMWV_DZ",[(_coords select 0) + 15, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_baserunover6 = createVehicle ["SUV_TK_EP1",[(_coords select 0) + 25, (_coords select 1) - 15,0],[], 0, "CAN_COLLIDE"];

_baserunover setVariable ["Sarge",1,true];
_baserunover1 setVariable ["Sarge",1,true];
_baserunover2 setVariable ["Sarge",1,true];
_baserunover3 setVariable ["Sarge",1,true];
_baserunover4 setVariable ["Sarge",1,true];
_baserunover5 setVariable ["Sarge",1,true];
_baserunover6 setVariable ["Sarge",1,true];


_crate = createVehicle ["USVehicleBox",[(_coords select 0) - 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxesM.sqf";

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 8, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";


[[(_coords select 0) - 20, (_coords select 1) - 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;
[[(_coords select 0) + 10, (_coords select 1) + 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;
[[(_coords select 0) - 10, (_coords select 1) - 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;
[[(_coords select 0) + 20, (_coords select 1) + 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;

_minortimeout = true;
_cleanmission = false;
_playerPresent = false;

_starttime = floor(time);
while {_minortimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _baserunover <= 250)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= 3600) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_minortimeout = false;};
};

if (_playerPresent) then {
	waitUntil{{isPlayer _x && _x distance _baserunover < 10 } count playableunits > 0}; 

	//Mission completed/timed out
	[nil,nil,rTitleText,"The Medical Outpost is under survivor control!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The Medical Outpost is under survivor control!"] call RE;
	[nil,nil,rHINT,"The Medical Outpost is under survivor control!"] call RE;
	[_baserunover4 , typeOf _baserunover4] call server_updateObject;
	[_baserunover5 , typeOf _baserunover5] call server_updateObject;
	[_baserunover6 , typeOf _baserunover6] call server_updateObject;
} else {
	_baserunover4 setDamage 1.0;
	_baserunover4 setVariable ["Sarge", nil, true];
	_baserunover5 setDamage 1.0;
	_baserunover5 setVariable ["Sarge", nil, true];
	_baserunover6 setDamage 1.0;
	_baserunover6 setVariable ["Sarge", nil, true];
	deleteVehicle _baserunover;
	deleteVehicle _baserunover1;
	deleteVehicle _baserunover2;
	deleteVehicle _baserunover3;
	deleteVehicle _crate;
	deleteVehicle _crate2;
	[nil,nil,rTitleText,"The medical outpost exploded!", "PLAIN",6] call RE;
	[nil,nil,rGlobalRadio,"The medical outpost exploded!"] call RE;
	[nil,nil,rHINT,"The medical outpost exploded!"] call RE;
};

[] execVM "debug\remmarkers75.sqf";

MissionGoMinor = 0;
MCoords = 0;
publicVariable "MCoords";
MissionGoNameMinor = "";
publicVariable "MissionGoNameMinor"; 

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";