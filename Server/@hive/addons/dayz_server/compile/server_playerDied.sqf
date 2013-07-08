private["_characterID","_minutes","_newObject","_playerID","_key","_playerName","_playerID","_myGroup","_group","_victim", "_killer", "_weapon", "_message", "_distance","_loc_message","_victimName","_killerName","_killerPlayerID"];
//[unit, weapon, muzzle, mode, ammo, magazine, projectile]
_characterID = 	_this select 0;
_minutes =		_this select 1;
_newObject = 	_this select 2;
_playerID = 	_this select 3;
_playerName = 	name _newObject;

_victim removeAllEventHandlers "MPHit";

_victim = _this select 2;
_victimName = _victim getVariable["bodyName", "nil"];
_killer = _victim getVariable["AttackedBy", "nil"];
_killerName = _victim getVariable["AttackedByName", "nil"];

// when a zombie kills a player _killer, _killerName and _weapon will be "nil"
// we can use this to determine a zombie kill and send a customized message for that. right now no killmsg means it was a zombie.
if (_killerName != "nil") then
{
	_weapon = _victim getVariable["AttackedByWeapon", "nil"];
	_distance = _victim getVariable["AttackedFromDistance", "nil"];
	_displayname = getText (configFile >> 'CfgWeapons' >> _weapon >> 'displayName');
	if (_victimName == _killerName) then 
	{
		_message = format["%1 killed himself",_victimName];
		_loc_message = format["PKILL: %1 killed himself", _victimName];
	}
	else 
	{
		_killerPlayerID = getPlayerUID _killer;
		_message = format["%1 was killed by %2 ( %3 | %4m )",_victimName, _killerName, _displayname, _distance];
		_loc_message = format["PKILL: %1 (%5) was killed by %2 (%6) with weapon %3 from %4m", _victimName, _killerName, _weapon, _distance, _playerID, _killerPlayerID];
	};

	diag_log _loc_message;
	//[nil, nil, rTITLETEXT, _message, "PLAIN DOWN", 0] call RE;
    [[[_message], { cutText [format['%1',(_this select 0)],'PLAIN DOWN']; }], "BIS_fnc_spawn", true, false] call BIS_fnc_MP;
    
	// Cleanup
	_victim setVariable["AttackedBy", "nil", true];
	_victim setVariable["AttackedByName", "nil", true];
	_victim setVariable["AttackedByWeapon", "nil", true];
	_victim setVariable["AttackedFromDistance", "nil", true];
};

dayz_disco = dayz_disco - [_playerID];

_newObject setVariable["processedDeath",time];
_newObject setVariable ["bodyName", _playerName, true];


if (typeName _minutes == "STRING") then 
{
	_minutes = parseNumber _minutes;
};

if (_characterID != "0") then 
{
	_key = format["CHILD:202:%1:%2:",_characterID,_minutes];
	//diag_log ("HIVE: WRITE: "+ str(_key));
	_key call server_hiveWrite;
} 
else 
{
	deleteVehicle _newObject;
};

diag_log ("PDEATH: Player Died " + _playerID);