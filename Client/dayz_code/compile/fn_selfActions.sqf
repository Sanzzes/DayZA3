scriptName "Functions\misc\fn_selfActions.sqf";
/***********************************************************
	ADD ACTIONS FOR SELF
	- Function
	- [] call fnc_usec_selfActions;
************************************************************/
private["_menClose","_hasBandage","_hasEpi","_hasMorphine","_hasBlood","_vehicle","_inVehicle","_color","_part"];

_vehicle = vehicle player;
_inVehicle = (_vehicle != player);
_bag = unitBackpack player;
_classbag = typeOf _bag;
_isWater = 		(surfaceIsWater (position player)) or dayz_isSwimming;
_hasAntiB = 	"ItemAntibiotic" in magazines player;
_hasFuelE = 	"ItemJerrycanEmpty" in magazines player;
//boiled Water
_hasbottleitem = "ItemWaterbottle" in magazines player;
_hasbottleitemE = "ItemWaterbottleUnfilled" in magazines player;
_hasWood = 		"PartWoodPile" in magazines player;
_hasSPack =      "SurvivalPack" in magazines player;
_hastinitem = false;
{
    if (_x in magazines player) then {
        _hastinitem = true;
    };

} forEach boil_tin_cans;

//A3 Med Definitions and other vars by Papzzz and Pwnoz0r

_unit = 			player;
_injured = 			player getVariable ["USEC_injured", false];
_inPain = 			player getVariable ["USEC_inPain", false];
_legsBroke = 		player getVariable ["hit_legs", 0] >= 1;
_armsBroke = 		player getVariable ["hit_hands", 0] >= 1;
_hasBandage = 		"ItemBandage" in magazines player;
_hasMorphine = 		"ItemMorphine" in magazines player;
_hasHeatpack = 		"ItemHeatpack" in magazines player;
_hasPainkillers = 	"ItemPainkiller" in magazines player;
_hasAntibiotic =	"ItemAntibiotic" in magazines player;
_hasClothes1 = 		"Skin_Sniper1_DZ" in magazines player; //Ghillie
_hasClothes2 = 		"Skin_Camo1_DZ" in magazines player; //Camo
_hasClothes3 = 		"Skin_Survivor2_DZ" in magazines player; //Survivor
_hasMRE =		"FoodMRE" in magazines player;
//FOOD
//_hasFood = 			["FoodCanBakedBeans", "FoodCanSardines", "FoodCanFrankBeans", "FoodCanPasta", "FoodSteakCooked"];
//_hasFood2 = 		"FoodCanSardines" in magazines player;
//_hasFood3 = 		"FoodCanFrankBeans" in magazines player;
//_hasFood4 = 		"FoodCanPasta" in magazines player;
//_hasFood5 = 		"FoodSteakCooked" in magazines player;
//DRINK
//_hasDrink =			["ItemSodaCoke", "ItemSodaPepsi", "ItemSodaMdew"];
//_hasDrink2 =		"ItemSodaPepsi" in magazines player;
//_hasDrink3 =		"ItemSodaMdew" in magazines player;
_nearLightG =   nearestObject [player,"Chemlight_green"];
_nearLightB =   nearestObject [player,"Chemlight_blue"];
_nearLightY =   nearestObject [player,"Chemlight_yellow"];
_nearLightR =   nearestObject [player,"Chemlight_red"];
_canPickLightG = false;
_canPickLightY = false;
_canPickLightB = false;
_canPickLightR = false;

if (!isNull _nearLightG) then {
  if (_nearLightG distance player < 1) then {
    _canPickLightG = isNull (_nearLightG getVariable ["owner",objNull]);
  };
};
if (!isNull _nearLightY) then {
  if (_nearLightY distance player < 1) then {
    _canPickLightY = isNull (_nearLightY getVariable ["owner",objNull]);
  };
};
if (!isNull _nearLightB) then {
  if (_nearLightB distance player < 1) then {
    _canPickLightB = isNull (_nearLightB getVariable ["owner",objNull]);
  };
};
if (!isNull _nearLightR) then {
  if (_nearLightR distance player < 1) then {
    _canPickLightR = isNull (_nearLightR getVariable ["owner",objNull]);
  };
};

_getTextZ =     getText (_config >> "displayName");
//End of Code
_hasKnife = 	"ItemKnife" in items player;
_hasToolbox = 	"ItemToolbox" in items player;
_hasTent = 		"ItemTent" in magazines player;
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;

    
_canFill = 		count (nearestObjects [position player, ["Land_pumpa","Land_water_tank"], 4]) > 0;
_isPond = 		false;
_isWell = 		false;
_pondPos = 		[];
_objectsWell = 	[];
_objectsPond = 	[];


if (!_canFill) then {
	_objectsWell = 	nearestObjects [getPosATL player, [], 4];
	{
		//Check for Well
		_isWell = ["_well",str(_x),false] call fnc_inString;
		if (_isWell) then {_canFill = true};
	} forEach _objectsWell;
};

if (!_canFill) then {
	_objectsPond = 		nearestObjects [getPosATL player, [], 50];
	{
		//Check for pond
		_isPond = ["pond",str(_x),false] call fnc_inString;
		if (_isPond) then {
			_pondPos = (_x worldToModel getPosATL player) select 2;
			if (_pondPos < 0) then {
				_canFill = true;
			};
		};
	} forEach _objectsPond;
};

_canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder);

//Off topic functions
/*
	if (player == player) then {
			s_getAlive = player addAction["Force Gear Save", "\z\addons\dayz_code\system\forceGearSave.sqf"];
	};
*/
//End off topic functions

//Start of A3 Scroll functions by Papzzz and Pwnoz0r

//Grab GChem
if (_canPickLightG and !dayz_hasLight) then {
  if (s_player_grabflare < 0) then {
    _text = "Green Chemlight";
    s_player_grabflare = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightG, 1, false, true, "", ""];
    s_player_removeflare = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightG, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare;
  player removeAction s_player_removeflare;
  s_player_grabflare = -1;
  s_player_removeflare = -1;
};
//Grab BChem
if (_canPickLightB and !dayz_hasLight) then {
  if (s_player_grabflare2 < 0) then {
    _text = "Blue Chemlight";
    s_player_grabflare2 = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightB, 1, false, true, "", ""];
    s_player_removeflare2 = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightB, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare2;
  player removeAction s_player_removeflare2;
  s_player_grabflare2 = -1;
  s_player_removeflare2 = -1;
};
//Grab YChem
if (_canPickLightY and !dayz_hasLight) then {
  if (s_player_grabflare3 < 0) then {
    _text = "Yellow Chemlight";
    s_player_grabflare3 = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightY, 1, false, true, "", ""];
    s_player_removeflare3 = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightY, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare3;
  player removeAction s_player_removeflare3;
  s_player_grabflare3 = -1;
  s_player_removeflare3 = -1;
};
//Grab RChem
if (_canPickLightR and !dayz_hasLight) then {
  if (s_player_grabflare4 < 0) then {
    _text = "Red Chemlight";
    s_player_grabflare4 = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLightR, 1, false, true, "", ""];
    s_player_removeflare4 = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLightR, 1, false, true, "", ""];
  };
} else {
  player removeAction s_player_grabflare4;
  player removeAction s_player_removeflare4;
  s_player_grabflare4 = -1;
  s_player_removeflare4 = -1;
};
    //Allow player to use the Survival Pack
    if (_vehicle == player and _hasSPack and ((_legsBroke or _armsBroke) or (r_player_infected) or (_inPain) or (_injured) or (r_player_blood < 12000))) then {
        if (s_player_survivalpackA3 < 0) then {
            s_player_survivalpackA3 = player addAction [format["<t color='#FF0000'>Use Survival Pack%1</t>"], "\z\addons\dayz_code\medical\spack.sqf",[_unit], 1, true, true, "", "'SurvivalPack' in magazines player"];
        };
    } else {
        player removeAction s_player_survivalpackA3;
        s_player_survivalpackA3 = -1;
    };
    //Allow player to use heatpacks
    if (_vehicle == player and (dayz_temperatur < 35.5) and _hasHeatpack) then {
    		if (s_player_heatpackA3 < 0) then {
			s_player_heatpackA3 = player addAction [format["<t color='#FF0000'>Use Heatpack%1</t>"], "\z\addons\dayz_code\medical\heatpack.sqf",[_unit], 1, true, true, "", "'ItemHeatpack' in magazines player"];
		};
    } else {
		player removeAction s_player_heatpackA3;
		s_player_heatpackA3 = -1;
    };
    
	//Allow player to use Morphine
	if (_vehicle == player and (_legsBroke or _armsBroke) and _hasMorphine) then {
		if (s_player_morphineA3 < 0) then {
			s_player_morphineA3 = player addAction [format["<t color='#FF0000'>Use Morphine%1</t>"], "\z\addons\dayz_code\medical\morphine.sqf",[_unit], 1, true, true, "", "'ItemMorphine' in magazines player"];
		};
	} else {
		player removeAction s_player_morphineA3;
		s_player_morphineA3 = -1;
	};
	if (_vehicle == player and _hasAntibiotic and r_player_infected) then {
		if (s_player_antibioticA3 < 0) then {
			s_player_antibioticA3 = player addAction [format["<t color='#FF0000'>Use Antibiotics%1</t>"], "\z\addons\dayz_code\medical\antibiotics.sqf",[_unit], 1, true, true, "", "'ItemAntibiotic' in magazines player"];
		};
	} else {
		player removeAction s_player_antibioticA3;
		s_player_antiboioticA3 = -1;
	};
	//Allow player to use Painkillers
	if (_vehicle == player and _inPain and _hasPainkillers) then {
		if (s_player_painkillerA3 < 0) then {
			s_player_painkillerA3 = player addAction [format["<t color='#FF0000'>Use Painkillers%1</t>"], "\z\addons\dayz_code\medical\painkiller.sqf",[_unit], 1, true, true, "", "'ItemPainkiller' in magazines player"];
		};
	} else {
		player removeAction s_player_painkillerA3;
		s_player_painkillerA3 = -1;
	};

	//Allow player to bandage
	if (_vehicle == player and _injured and _hasBandage) then {
		if (s_player_bandageA3 < 0) then {
			s_player_bandageA3 = player addAction [format["<t color='#FF0000'>Use Bandage%1</t>"], "\z\addons\dayz_code\medical\bandageSelf.sqf",[_unit], 1, true, true, "", "'ItemBandage' in magazines player"];
		};
	} else {
		player removeAction s_player_bandageA3;
		s_player_bandageA3 = -1;
	};

	//Allow player to chop trees
	if (_vehicle == player and (["forest",dayz_surfaceType] call fnc_inString) and _hasHatchet) then {
		if (s_player_chopA3 < 0) then {
			s_player_chopA3 = player addAction [format["<t color='#FF0000'>Chop Wood%1</t>"], "\z\addons\dayz_code\actions\player_chopWood.sqf",[_unit], 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_chopA3;
		s_player_chopA3 = -1;
	};

	//Allow player to setup a camp fire
	if (_vehicle == player and _hasWood) then {
		if (s_player_makefireA3 < 0) then {
			s_player_makefireA3 = player addAction [format["<t color='#FF0000'>Place Campfire%1</t>"], "\z\addons\dayz_code\actions\player_makefire.sqf",[_unit], 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_makefireA3;
		s_player_makefireA3 = -1;
	};

	_foodItems = no_output_food + food_with_output + meatcooked;
	_hasFood = false;
		{
			if (_x in magazines player) then {
				_hasFood = true;
			};
		} forEach _foodItems; 
	
	//Allow player to nom nom
	if(_vehicle == player and _hasFood) then {
		if ((r_player_blood < 10000) and (dayz_hunger3 < 0)) then {
		
		player removeAction dayz_hunger2;
		dayz_hunger2 = -1;
		dayz_hunger3 = player addAction [format["<t color='#FF0000'>Eat%1</t>"], "\z\addons\dayz_code\actions\player_eat.sqf",[_getTextZ], 1, false, true, "", "player == player"];
		
		}; if ((r_player_blood >= 10000) and (dayz_hunger2 < 0)) then {
		player removeAction dayz_hunger3;
		dayz_hunger3 = -1;
		if(dayz_hunger >= 270) then {
			dayz_hunger2 = player addAction [format["<t color='#FF0000'>Eat%1</t>"], "\z\addons\dayz_code\actions\player_eat.sqf",[_getTextZ], 1, false, true, "", "player == player"];
		};
		};
	} else	{
		player removeAction dayz_hunger2;
		dayz_hunger2 = -1;
		player removeAction dayz_hunger3;
		dayz_hunger3 = -1;
	};

	_drinkItems = no_output_drink + drink_with_output;
	_hasDrink = false;
		{
			if (_x in magazines player) then {
				_hasDrink = true;
			};
		} forEach _drinkItems; 

	//Allow player to slurp slurp
	if(_vehicle == player and _hasDrink) then {
    	if((dayz_thirst >= 180) and (dayz_thirst2 < 0)) then {
        	dayz_thirst2 = player addAction [format["<t color='#FF0000'>Drink%1</t>"], "\z\addons\dayz_code\actions\player_drink2.sqf",[_getTextZ], 1, false, true, "", "player == player"];
    	};
	} else {
    	player removeAction dayz_thirst2;
    	dayz_thirst2 = -1;
	};

	//Allow player to fill water bottles
	if(_vehicle == player and _canFill and _hasbottleitemE) then {
    	if((s_player_fillwater2 < 0)) then {
        	s_player_fillwater2 = player addAction [format["<t color='#FF0000'>Fill Bottle%1</t>"], "\z\addons\dayz_code\actions\water_fill.sqf",[_getTextZ], 1, false, true, "", "player == player"];
    	};
	} else {
    	player removeAction s_player_fillwater2;
    	s_player_fillwater2 = -1;
	};

	//Allow consuming of an MRE
	if(_vehicle == player and _hasMRE) then {
		if ((r_player_blood < 10000) and (dayz_mre2 < 0)) then {
		
		player removeAction dayz_mre;
		dayz_mre = -1;
		dayz_mre2 = player addAction [format["<t color='#FF0000'>Use MRE%1</t>"], "\z\addons\dayz_code\actions\player_mre.sqf",[_getTextZ], 1, false, true, "", "player == player"];
		
		}; if ((r_player_blood >= 10000) and (dayz_mre < 0)) then {
		player removeAction dayz_mre2;
		dayz_mre2 = -1;
		if((dayz_hunger >= 270) or (dayz_thirst >= 180)) then {
			dayz_mre2 = player addAction [format["<t color='#FF0000'>Use MRE%1</t>"], "\z\addons\dayz_code\actions\player_mre.sqf",[_getTextZ], 1, false, true, "", "player == player"];
		};
		};
	} else {
    	player removeAction dayz_mre;
    	dayz_mre = -1;
    	player removeAction dayz_mre2;
    	dayz_mre2 = -1;
	};
	
	//Allow placing of tents
	if(_vehicle == player and _hasTent) then {
		if(s_doTent < 0) then {
			s_doTent = player addAction [format["<t color='#FF0000'>Pitch Tent%1</t>"], "z\addons\dayz_code\actions\tent_pitch.sqf"];
		};
	} else	{
		player removeAction s_doTent;
		s_doTent = -1;
	};
		
	//Allow changing of clothes
	if(_vehicle == player and (_hasClothes1 or _hasClothes2 or _hasClothes3)) then {
		if((s_doClothes1 < 0) and (_hasClothes1)) then {
			s_doClothes1 = player addAction [format["<t color='#FF0000'>Wear Ghillie Suit</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Sniper1_DZ"]];
		};
		if((s_doClothes2 < 0) and (_hasClothes2)) then {
			s_doClothes2 = player addAction [format["<t color='#FF0000'>Wear Camo Clothing</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Camo1_DZ"]];
		};
		if((s_doClothes3 < 0) and (_hasClothes3)) then {
			s_doClothes3 = player addAction [format["<t color='#FF0000'>Wear Civilian Clothing</t>"], "z\addons\dayz_code\actions\player_wearClothes.sqf", ["Skin_Survivor2_DZ"]];
		};
	} else	{
		player removeAction s_doClothes1;
		s_doClothes1 = -1;
		player removeAction s_doClothes2;
		s_doClothes2 = -1;
		player removeAction s_doClothes3;
		s_doClothes3 = -1;
	};
//End of A3 Scroll functions

if (!isNull cursorTarget and !_inVehicle and (player distance cursorTarget < 4)) then {	//Has some kind of target
	_isHarvested = cursorTarget getVariable["meatHarvested",false];
	_isVehicle = cursorTarget isKindOf "AllVehicles";
	_isVehicletype = typeOf cursorTarget in ["ATV_US_EP1","ATV_CZ_EP1"];
	_isMan = cursorTarget isKindOf "Man";
	_ownerID = cursorTarget getVariable ["characterID","0"];
	_isAnimal = cursorTarget isKindOf "Animal";
	_isDog =  (cursorTarget isKindOf "DZ_Pastor" || cursorTarget isKindOf "DZ_Fin");
	_isZombie = cursorTarget isKindOf "zZombie_base";
	_isPlayer = typeOf cursorTarget in AllPlayers_A3;
	_isDestructable = cursorTarget isKindOf "BuiltItems";
	_isTent = cursorTarget isKindOf "TentStorage";
	_isFuel = false;
	_isAlive = alive cursorTarget;
	_canmove = canmove cursorTarget;
	_text = getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName");
	
	
	_rawmeat = meatraw;
	_hasRawMeat = false;
		{
			if (_x in magazines player) then {
				_hasRawMeat = true;
			};
		} forEach _rawmeat; 
	
	
	if (_hasFuelE) then {
		_isFuel = (cursorTarget isKindOf "Land_Ind_TankSmall") or (cursorTarget isKindOf "Land_fuel_tank_big") or (cursorTarget isKindOf "Land_fuel_tank_stairs") or (cursorTarget isKindOf "Land_wagon_tanker");
	};
	//diag_log ("OWNERID = " + _ownerID + " CHARID = " + dayz_characterID + " " + str(_ownerID == dayz_characterID));
	
	//Allow player to delete objects
	if(_isDestructable and _hasToolbox and _canDo) then {
		if (s_player_deleteBuild < 0) then {
			s_player_deleteBuild = player addAction [format[localize "str_actions_delete",_text], "\z\addons\dayz_code\actions\remove.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteBuild;
		s_player_deleteBuild = -1;
	};
	
	/*
	//Allow player to force save
	if((_isVehicle or _isTent) and _canDo and !_isMan) then {
		if (s_player_forceSave < 0) then {
			s_player_forceSave = player addAction [format[localize "str_actions_save",_text], "\z\addons\dayz_code\actions\forcesave.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_forceSave;
		s_player_forceSave = -1;
	};
	*/
	//flip vehicle
	if ((_isVehicletype) and !_canmove and _isAlive and (player distance cursorTarget >= 2) and (count (crew cursorTarget))== 0 and ((vectorUp cursorTarget) select 2) < 0.5) then {
		if (s_player_flipveh  < 0) then {
			s_player_flipveh = player addAction [format[localize "str_actions_flipveh",_text], "\z\addons\dayz_code\actions\player_flipvehicle.sqf",cursorTarget, 1, true, true, "", ""];		
		};	
	} else {
		player removeAction s_player_flipveh;
		s_player_flipveh = -1;
	};
	
	//Allow player to fill jerrycan
	if(_hasFuelE and _isFuel and _canDo) then {
		if (s_player_fillfuel < 0) then {
			s_player_fillfuel = player addAction [localize "str_actions_self_10", "\z\addons\dayz_code\actions\jerry_fill.sqf",[], 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_fillfuel;
		s_player_fillfuel = -1;
	};
	
	if (!alive cursorTarget and (_isAnimal or _isZombie or _isPlayer) and _hasKnife and !_isHarvested and _canDo) then {
		if (s_player_butcher < 0) then {
			s_player_butcher = player addAction ["Gut Flesh", "\z\addons\dayz_code\actions\gather_meat.sqf",cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_butcher;
		s_player_butcher = -1;
	};
	
	//Fireplace Actions check
	if (inflamed cursorTarget and _hasRawMeat and _canDo) then {
		if (s_player_cook < 0) then {
			s_player_cook = player addAction [localize "str_actions_self_05", "\z\addons\dayz_code\actions\cook.sqf",cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_cook;
		s_player_cook = -1;
	};
	if (inflamed cursorTarget and (_hasbottleitem and _hastinitem) and _canDo) then {
		if (s_player_boil < 0) then {
			s_player_boil = player addAction [localize "str_actions_boilwater", "\z\addons\dayz_code\actions\boil.sqf",cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_boil;
		s_player_boil = -1;
	};
	
	if(cursorTarget == dayz_hasFire and _canDo) then {
		if ((s_player_fireout < 0) and !(inflamed cursorTarget) and (player distance cursorTarget < 3)) then {
			s_player_fireout = player addAction [localize "str_actions_self_06", "\z\addons\dayz_code\actions\fire_pack.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_fireout;
		s_player_fireout = -1;
	};
	
	//Packing my tent
	if(cursorTarget isKindOf "TentStorage" and _canDo and _ownerID == dayz_characterID) then {
		if ((s_player_packtent < 0) and (player distance cursorTarget < 3)) then {
			s_player_packtent = player addAction [localize "str_actions_self_07", "\z\addons\dayz_code\actions\tent_pack.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_packtent;
		s_player_packtent = -1;
		};
	
	//Sleep
	if(cursorTarget isKindOf "TentStorage" and _canDo and _ownerID == dayz_characterID) then {
		if ((s_player_sleep < 0) and (player distance cursorTarget < 3)) then {
			s_player_sleep = player addAction [localize "str_actions_self_sleep", "\z\addons\dayz_code\actions\player_sleep.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_sleep;
		s_player_sleep = -1;
	};
	
	//Repairing Vehicles
	if ((dayz_myCursorTarget != cursorTarget) and _isVehicle and !_isMan and _hasToolbox and (damage cursorTarget < 1)) then {
		_vehicle = cursorTarget;
		{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
		dayz_myCursorTarget = _vehicle;

		_allFixed = true;
		_hitpoints = _vehicle call vehicle_getHitpoints;
		
		{
			_damage = [_vehicle,_x] call object_getHit;
			_part = "PartGeneric";
			
			//change "HitPart" to " - Part" rather than complicated string replace
			_cmpt = toArray (_x);
			_cmpt set [0,20];
			_cmpt set [1,toArray ("-") select 0];
			_cmpt set [2,20];
			_cmpt = toString _cmpt;
				
			if(["Engine",_x,false] call fnc_inString) then {
				_part = "PartEngine";
			};
					
			if(["HRotor",_x,false] call fnc_inString) then {
				_part = "PartVRotor"; //yes you need PartVRotor to fix HRotor LOL
			};

			if(["Fuel",_x,false] call fnc_inString) then {
				_part = "PartFueltank";
			};
			
			if(["Wheel",_x,false] call fnc_inString) then {
				_part = "PartWheel";

			};
					
			if(["Glass",_x,false] call fnc_inString) then {
				_part = "PartGlass";
			};

			// get every damaged part no matter how tiny damage is!
			if (_damage > 0) then {
				
				_allFixed = false;
				_color = "color='#ffff00'"; //yellow
				if (_damage >= 0.5) then {_color = "color='#ff8800'";}; //orange
				if (_damage >= 0.9) then {_color = "color='#ff0000'";}; //red

				_string = format["<t %2>Repair%1</t>",_cmpt,_color]; //Repair - Part
				_handle = dayz_myCursorTarget addAction [_string, "\z\addons\dayz_code\actions\repair.sqf",[_vehicle,_part,_x], 0, false, true, "",""];
				s_player_repairActions set [count s_player_repairActions,_handle];

			};
					
		} forEach _hitpoints;
		if (_allFixed) then {
			_vehicle setDamage 0;
		};
	};
	if (_isMan and !_isAlive and !_isZombie) then {
		if (s_player_studybody < 0) then {
			s_player_studybody = player addAction [localize "str_action_studybody", "\z\addons\dayz_code\actions\study_body.sqf",cursorTarget, 0, false, true, "",""];
		};	

	} else {
		player removeAction s_player_studybody;
		s_player_studybody = -1;
	};

	//Dog
	if (_isDog and _isAlive and (_hasRawMeat) and _canDo and _ownerID == "0" and player getVariable ["dogID", 0] == 0) then {
		if (s_player_tamedog < 0) then {
			s_player_tamedog = player addAction [localize "str_actions_tamedog", "\z\addons\dayz_code\actions\tame_dog.sqf", cursorTarget, 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_tamedog;
		s_player_tamedog = -1;
	};
	
	if (_isDog and _ownerID == dayz_characterID and _isAlive and _canDo) then {
		_dogHandle = player getVariable ["dogID", 0];
		if (s_player_feeddog < 0 and _hasRawMeat) then {
			s_player_feeddog = player addAction [localize "str_actions_feeddog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,0], 0, false, true,"",""];
		};
		if (s_player_waterdog < 0 and "ItemWaterbottle" in magazines player) then {
			s_player_waterdog = player addAction [localize "str_actions_waterdog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,1], 0, false, true,"",""];
		};
		if (s_player_staydog < 0) then {
			_lieDown = _dogHandle getFSMVariable "_actionLieDown";
			if (_lieDown) then { _text = "str_actions_liedog"; } else { _text = "str_actions_sitdog"; };
			s_player_staydog = player addAction [localize _text,"\z\addons\dayz_code\actions\dog\stay.sqf", _dogHandle, 5, false, true,"",""];
		};
		if (s_player_trackdog < 0) then {
			s_player_trackdog = player addAction [localize "str_actions_trackdog","\z\addons\dayz_code\actions\dog\track.sqf", _dogHandle, 4, false, true,"",""];
		};
		if (s_player_barkdog < 0) then {
			s_player_barkdog = player addAction [localize "str_actions_barkdog","\z\addons\dayz_code\actions\dog\speak.sqf", cursorTarget, 3, false, true,"",""];
		};
		if (s_player_warndog < 0) then {
			_warn = _dogHandle getFSMVariable "_watchDog";
			if (_warn) then { _text = "Quiet"; _warn = false; } else { _text = "Alert"; _warn = true; };
			s_player_warndog = player addAction [format[localize "str_actions_warndog",_text],"\z\addons\dayz_code\actions\dog\warn.sqf",[_dogHandle, _warn], 2, false, true,"",""];		
		};
		if (s_player_followdog < 0) then {
			s_player_followdog = player addAction [localize "str_actions_followdog","\z\addons\dayz_code\actions\dog\follow.sqf",[_dogHandle,true], 6, false, true,"",""];
		};
	} else {
		player removeAction s_player_feeddog;
		s_player_feeddog = -1;
		player removeAction s_player_waterdog;
		s_player_waterdog = -1;
		player removeAction s_player_staydog;
		s_player_staydog = -1;
		player removeAction s_player_trackdog;
		s_player_trackdog = -1;
		player removeAction s_player_barkdog;
		s_player_barkdog = -1;
		player removeAction s_player_warndog;
		s_player_warndog = -1;
		player removeAction s_player_followdog;
		s_player_followdog = -1;
	};
} else {
	//Engineering
	{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
	dayz_myCursorTarget = objNull;
	//Others
	player removeAction s_player_forceSave;
	s_player_forceSave = -1;
	player removeAction s_player_flipveh;
	s_player_flipveh = -1;
	player removeAction s_player_sleep;
	s_player_sleep = -1;
	player removeAction s_player_deleteBuild;
	s_player_deleteBuild = -1;
	player removeAction s_player_butcher;
	s_player_butcher = -1;
	player removeAction s_player_cook;
	s_player_cook = -1;
	player removeAction s_player_boil;
	s_player_boil = -1;
	player removeAction s_player_fireout;
	s_player_fireout = -1;
	player removeAction s_player_packtent;
	s_player_packtent = -1;
	player removeAction s_player_fillfuel;
	s_player_fillfuel = -1;
	player removeAction s_player_studybody;
	s_player_studybody = -1;
	//Dog
	player removeAction s_player_tamedog;
	s_player_tamedog = -1;
	player removeAction s_player_feeddog;
	s_player_feeddog = -1;
	player removeAction s_player_waterdog;
	s_player_waterdog = -1;
	player removeAction s_player_staydog;
	s_player_staydog = -1;
	player removeAction s_player_trackdog;
	s_player_trackdog = -1;
	player removeAction s_player_barkdog;
	s_player_barkdog = -1;
	player removeAction s_player_warndog;
	s_player_warndog = -1;
	player removeAction s_player_followdog;
	s_player_followdog = -1;
};

//Dog actions on player self
_dogHandle = player getVariable ["dogID", 0];
if (_dogHandle > 0) then {
	_dog = _dogHandle getFSMVariable "_dog";
	_ownerID = "0";
	if (!isNull cursorTarget) then { _ownerID = cursorTarget getVariable ["characterID","0"]; };
	if (_canDo and !_inVehicle and alive _dog and _ownerID != dayz_characterID) then {
		if (s_player_movedog < 0) then {
			s_player_movedog = player addAction [localize "str_actions_movedog", "\z\addons\dayz_code\actions\dog\move.sqf", player getVariable ["dogID", 0], 1, false, true, "", ""];
		};
		if (s_player_speeddog < 0) then {
			_text = "Walk";
			_speed = 0;
			if (_dog getVariable ["currentSpeed",1] == 0) then { _speed = 1; _text = "Run"; };
			s_player_speeddog = player addAction [format[localize "str_actions_speeddog", _text], "\z\addons\dayz_code\actions\dog\speed.sqf",[player getVariable ["dogID", 0],_speed], 0, false, true, "", ""];
		};
		if (s_player_calldog < 0) then {
			s_player_calldog = player addAction [localize "str_actions_calldog", "\z\addons\dayz_code\actions\dog\follow.sqf", [player getVariable ["dogID", 0], true], 2, false, true, "", ""];
		};
	};
} else {
	player removeAction s_player_movedog;		
	s_player_movedog =		-1;
	player removeAction s_player_speeddog;
	s_player_speeddog =		-1;
	player removeAction s_player_calldog;
	s_player_calldog = 		-1;
};
