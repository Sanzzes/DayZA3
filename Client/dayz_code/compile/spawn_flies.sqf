private["_"_body","_id","_position"];
_array = _this select 0;
_body = _array select 0;
_position = getPosATL (_body);
_id = [_position,0.1,1.5] call bis_fnc_flies;