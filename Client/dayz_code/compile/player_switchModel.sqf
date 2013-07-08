private["_class","_position","_dir","_group","_oldUnit","_newUnit","_currentWpn","_muzzles","_currentAnim","_currentCamera"];
_class 			= _this;

_position 		= getPosATL player;
_dir 			= getDir player;
_curgroup       = (group leader (group (player)));
_currentAnim 	= animationState player;
//_currentCamera	= cameraView;


//Get PlayerID
private ["_playerUID"];
	_playerUID = "";
	if (count playableUnits == 0 and isServer) then {
		//In Single Player
		isSinglePlayer = true;
		player sidechat "Single player Mode detected!";
		//_id = [42,"SinglePlayer"] spawn server_onPlayerConnect;
		_playerUID = "42";
	} else {
		_playerUID = getPlayerUID player;
	};

//BackUp Weapons and Mags
private ["_weapons","_magazines","_primweapon","_secweapon"];
	_weapons 	= weapons player;
	_magazines	= call player_countmagazines; //magazines player;
    
_currentmag = currentMagazine player;
_secmag = (handgunMagazine player) select 0;
_magArray = [];
if (_currentmag != "") then {
_magArray = _magArray + [_currentmag];
};
if (_secmag != "") then {
_magArray = _magArray + [_secmag];
};
if ((_secmag == _currentMag) and (_currentMag != "")) then {
    _magArray = [_currentmag];
};
	_magazines = vestItems player;
    _magazines = _magazines + _magArray;
//	if ( (_playerUID == dayz_playerUID) && (count _magazines == 0) && (count (magazines player) > 0 )) exitWith {cutText ["can't count magazines!", "PLAIN DOWN"]};


//	if ( count _magazines == 0 ) exitWith {cutText ["can't count magazines!", "PLAIN DOWN"]};

	_primweapon	= primaryWeapon player;
	_secweapon	= secondaryWeapon player;

	//Checks
	if(!(_primweapon in _weapons) && _primweapon != "") then {
		_weapons = _weapons + [_primweapon];
	};

	if(!(_secweapon in _weapons) && _secweapon != "") then {
		_weapons = _weapons + [_secweapon];
	};

	
//	if(count _magazines == 0) then {
//		_magazines = magazines player;
//	};

//BackUp Backpack
private ["_newBackpackType","_backpackWpn","_backpackMag","_vest","_vestitems"];
	dayz_myBackpack = unitBackpack player;
	_newBackpackType = (typeOf dayz_myBackpack);
	if(_newBackpackType != "") then {
		_backpackWpn = getWeaponCargo unitBackpack player;
		_backpackMag = getMagazineCargo unitBackpack player;
	};
_vest = vest player;

//Get Muzzle
	_currentWpn = currentWeapon player;
	_muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
	if (count _muzzles > 1) then {
		_currentWpn = currentMuzzle player;
	};

//Debug Message
	diag_log "Attempting to switch model";
	diag_log str(_weapons);
	diag_log str(_magazines);
	diag_log (str(_backpackWpn));
	diag_log (str(_backpackMag));

//Secure Player for Transformation
	player setPosATL dayz_spawnPos;

//BackUp Player Object
	_oldUnit = player;
    
_otheritems = assignedItems player;
	
/***********************************/
//DONT USE player AFTER THIS POINT
/***********************************/

//Create New Character
	//[player] joinSilent grpNull;
	_group 		= createGroup west;
	_newUnit 	= _group createUnit [_class,dayz_spawnPos,[],0,"NONE"];

	_newUnit 	setPosATL _position;
	_newUnit 	setDir _dir;

//Clear New Character
	{_newUnit removeMagazine _x;} forEach  magazines _newUnit;
	removeAllWeapons _newUnit;	

    removeUniform _newUnit;
    removeHeadgear _newUnit;
    removeGoggles _newUnit;
    removeAllAssignedItems _newUnit;

	if(_vest != (vest _newUnit) && _vest != "") then {
		_newUnit addItem _vest;		
		_newUnit assignItem _vest;		
	};

//Equip New Charactar

	{
		_newUnit addWeapon _x;
		//sleep 0.05;
	} forEach _weapons;
    
	{
		if (typeName _x == "ARRAY") then {_newUnit addMagazine [_x select 0,_x select 1] } else { _newUnit addMagazine _x };
		//sleep 0.05;
	} forEach _magazines;
	
    
    

//Check and Compare it
	if(str(_weapons) != str(weapons _newUnit)) then {
		//Get Differecnce
		{
			_weapons = _weapons - [_x];
		} forEach (weapons _newUnit);
	
		//Add the Missing
		{
			_newUnit addWeapon _x;
			//sleep 0.2;
		} forEach _weapons;
	};
	
	if(_primweapon !=  (primaryWeapon _newUnit)) then {
		_newUnit addWeapon _primweapon;		
	};

	if(_secweapon != (secondaryWeapon _newUnit) && _secweapon != "") then {
		_newUnit addWeapon _secweapon;		
	};

//Add and Fill BackPack
	if (!isNil "_newBackpackType") then {
		if (_newBackpackType != "") then {
			_newUnit addBackpack _newBackpackType;
			_oldBackpack = dayz_myBackpack;
			dayz_myBackpack = unitBackpack _newUnit;


			//Fill backpack contents
			//Weapons
			_backpackWpnTypes = [];
			_backpackWpnQtys = [];
			if (count _backpackWpn > 0) then {
				_backpackWpnTypes = _backpackWpn select 0;
				_backpackWpnQtys = 	_backpackWpn select 1;
			};
			_countr = 0;
			{
				dayz_myBackpack addWeaponCargoGlobal [_x,(_backpackWpnQtys select _countr)];
				_countr = _countr + 1;
			} forEach _backpackWpnTypes;
			//magazines
			_backpackmagTypes = [];
			_backpackmagQtys = [];
			if (count _backpackmag > 0) then {
				_backpackmagTypes = _backpackMag select 0;
				_backpackmagQtys = 	_backpackMag select 1;
			};
			_countr = 0;
			{
				dayz_myBackpack addmagazineCargoGlobal [_x,(_backpackmagQtys select _countr)];
				_countr = _countr + 1;
			} forEach _backpackmagTypes;
		};
	};
//Debug Message
	diag_log "Swichtable Unit Created. Equipment:";
	diag_log str(weapons _newUnit);
	diag_log str(magazines _newUnit);
	diag_log str(getWeaponCargo unitBackpack _newUnit);
	diag_log str(getMagazineCargo unitBackpack _newUnit);

//Make New Unit Playable
	addSwitchableUnit _newUnit;
	setPlayable _newUnit;
	selectPlayer _newUnit;

//Clear and delete old Unit
	removeAllWeapons _oldUnit;
	{_oldUnit removeMagazine _x;} forEach  magazines _oldUnit;
		
	deleteVehicle _oldUnit;

//Move player inside

//	player switchCamera = _currentCamera;
	if(_currentWpn != "") then {_newUnit selectWeapon _currentWpn;};
	[[[player, _currentanim], { (_this select 0) switchMove (_this select 1); }], "BIS_fnc_spawn", true, false] call BIS_fnc_MP;
	//dayz_originalPlayer attachTo [_newUnit];
	player disableConversation true;
	
	player setVariable ["bodyName",dayz_playerName,true];

	_playerUID=getPlayerUID player;
	_playerObjName = format["player%1",_playerUID];
	call compile format["%1 = player;",_playerObjName];
	publicVariable _playerObjName;
    {
        _newUnit addItem _x;
        _newUnit assignItem _x;
    } forEach _otheritems;