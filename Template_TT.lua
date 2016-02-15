--[[ 
======================================= 
    <TT> v 0.1  1:43 AM 7/21/2015
======================================= 
  	This code is free to use and share, but please give credit and use in good will. (CoreLogic http://www.developer-me.com/forums/member.php?action=profile&uid=29)
  
	Github: https://github.com/adestefa/<TT>.git	
  
	Installation:
	 1. Install Script Hook https://www.gta5-mods.com/tools/script-hook-v 
	 2. Install the LUA script plugin for Scripthook https://www.gta5-mods.com/tools/lua-plugin-for-script-hook-v 
	 3. Download the <TT> file
	 4. Put the <b><TT>.lua</b> file in your <install dir>\Grand Theft Auto V\scripts\addins folder. 
	 5. Text will appear above the mini-map when installed correctly
 
 -------------------------------
 version 0.9 7/17/2015
  - base version  
]]--
local <TT> = {};
-- ======================================= 
--  Main configuration settings
-- ======================================= 
<TT>.settings = {};
<TT>.settings["key_wait_time"] = 310;       -- key press delay before event firing again
<TT>.settings["dialog_cooldown"] = 1050;    -- time to show dialog msg on screen
-- ======================================= 
--     Run-time Global members
-- ======================================= 
<TT>.data = {};
<TT>.data["seenPeds"] = {};                  -- all peds seen and lifted by <TT>
<TT>.data["setup"] = false;				     -- did we set up the player yet?
-- =======================================  
--  Each element in this table is
--  a switch that when on will be shown
--  as msg on screen when set true
--  and not shown when false.
-- =======================================  
<TT>.toggle = {};
<TT>.toggle["dialog"] = true;                 -- dialog message
<TT>.toggle["action1"] = false;               -- action handler (test kill peds) 'T' key
-- ======================================= 
--  Each element in this table is a timer
--   which often is associated with a 
--   'toggle' element. 
-- ======================================= 
<TT>.timer = {};
<TT>.timer["dialog"] = 0;                     -- timer to track dialog msg time onscreen
-- =======================================  
--     draw text to screen
-- ======================================= 
<TT>.locations = {};
<TT>.locations["bridge1"] = {x=575.097, y=-2047.383, z=29.462 };
-- =======================================  
--     draw text to screen
-- ======================================= 
function <TT>.draw_text(text, x, y, scale)
	UI.SET_TEXT_FONT(0);
	UI.SET_TEXT_SCALE(scale, scale);
	UI.SET_TEXT_COLOUR(255, 255, 255, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(false);
	UI.SET_TEXT_DROPSHADOW(2, 2, 0, 0, 0);
	UI.SET_TEXT_EDGE(1, 0, 0, 0, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(y, x);
end
-- ======================================= 
-- extra message display area
-- ======================================= 
function <TT>.displayHitText(txt)
	<TT>.draw_text(txt, 0.5, 0.0005, 0.3);
end
-- ======================================= 
-- play a sound 
-- (where do we find a 
--    list of game sound hashes??)
-- ======================================= 
function <TT>.playSound()
	AUDIO.PLAY_SOUND_FRONTEND(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
end
-- ======================================= 
--  Dynamically Toggle UI msg stage
-- ======================================= 
function <TT>.switch(toggle)
 	if <TT>.toggle[toggle] then
		<TT>.toggle[toggle] = false;
	else
		<TT>.toggle[toggle] = true;
	end
end
-- =======================================
-- return distance to player in free space
-- =======================================
function <TT>.findDistance(entity)
	local player = PLAYER.PLAYER_PED_ID() 
	local playerCoord = ENTITY.GET_ENTITY_COORDS(player,true);
	local coord = ENTITY.GET_ENTITY_COORDS(entity,true);
	local xDis = playerCoord.x - coord.x --PED
	local yDis = playerCoord.y - coord.y	--PED
	local zDis = playerCoord.z - coord.z	--PED
	local distance = math.sqrt(xDis*xDis+yDis*yDis+zDis*zDis);
	return distance

end
-- =======================================
-- return distance to player in 2D space
-- =======================================
function <TT>.findDistanceXY(entity)
	local player = PLAYER.PLAYER_PED_ID(); 
	local playerCoord = ENTITY.GET_ENTITY_COORDS(player,true);
	local coord = ENTITY.GET_ENTITY_COORDS(entity,true);
	local xDis = playerCoord.x - coord.x;
	local yDis = playerCoord.y - coord.y;
	local distance = math.sqrt(xDis*xDis+yDis*yDis);
	return distance
end
-- ======================================= 
--  		Initialize
-- ======================================= 
function <TT>.setup()
	local player = PLAYER.PLAYER_PED_ID(); 
	local skin_hash = GAMEPLAY.GET_HASH_KEY("a_f_y_hipster_02");
	STREAMING.REQUEST_MODEL(skin_hash);
	PLAYER.SET_PLAYER_MODEL(player, GAMEPLAY.GET_HASH_KEY("a_f_y_hipster_02"));
	ENTITY.SET_ENTITY_COORDS(player, 1204.983, -2541.552, 37.900, true, true, true, true);
	ENTITY.SET_ENTITY_MAX_SPEED(player, 500);
	ENTITY.SET_ENTITY_INVINCIBLE(player, true);
	ENTITY.SET_ENTITY_HEALTH(player, 200);
	PLAYER.CLEAR_PLAYER_WANTED_LEVEL(player);
	ENTITY.SET_ENTITY_INVINCIBLE(player, false);
	PED.SET_PED_ARMOUR(player, 100);
	<TT>.data["setup"] = true; -- remember if we set the player up
end
-- ======================================= 
--   Returns if we have seen this ped
-- ======================================= 
function <TT>.isNewPed(ped) 
	for i=1,#<TT>.data["seenPeds"] do
	local dead = PED._IS_PED_DEAD(<TT>.data["seenPeds"][i], true);
		--if(thisPedHealth > 0) then
		if(not dead) then
			if(<TT>.data["seenPeds"][i] == ped) then
			return false;
			end  
		end
	end
	return true;
end
-- ======================================= 
--     Find a new target
-- ======================================= 
function <TT>.newTarget(ped)
	if (<TT>.isNewPed(ped)) then
		table.insert(<TT>.data["seenPeds"],ped);
		return false;
	else
		return true;
	end   
end
-- ======================================= 
--      print Ped data to console
-- ======================================= 
function <TT>.printPedData()
	for i=1,#<TT>.data["seenPeds"] do
		local dead = PED._IS_PED_DEAD(<TT>.data["seenPeds"][i], true);
		print(i,<TT>.data["seenPeds"][i],"Dead:"..dead);
	end
	<TT>.displayHitText("Ped data printed to console");
end
-- ======================================= 
--   doSomethingPeds
-- ======================================= 
function <TT>.doSomethingPeds()
	local playerPed = PLAYER.PLAYER_PED_ID();
	local PedTab,PedCount = PED.GET_PED_NEARBY_PEDS(playerPed, 1, -1);
	thisPedCount = PedCount;
	for k,p in ipairs(PedTab)do 
		if(p == playerPed)then
		else
			-- target this ped (if not already dead)
			if (<TT>.newTarget(p)) then
				<TT>.playSound();
				local coord=ENTITY.GET_ENTITY_COORDS(p,true)
			else
				-- do nothing /not targeting
			end
		end		
	end
end
-- ======================================= 
--   doSomethingVehs
-- ======================================= 
function <TT>.doSomethingVehs()
	local playerPed = PLAYER.PLAYER_PED_ID();
	local VehTab,VehCount = PED.GET_PED_NEARBY_VEHICLES(playerPed, 1)
	thisVehCount = VehCount;
	for k,v in ipairs(VehTab)do
		local PlayerVeh = PED.IS_PED_IN_VEHICLE(playerPed, v, false)
		if(v == PlayerVeh)then
		else
			if (<TT>.newTarget(v)) then
				
				<TT>.playSound();
				speed = ENTITY.GET_ENTITY_SPEED(v)
				
			--	for i = 1,60 do
			--		VEHICLE.SET_VEHICLE_FORWARD_SPEED(v, speed)
			--		if(speed < 1)then
			--		else
			--			speed = speed - 1
			--		end
			--		ENTITY.SET_ENTITY_VELOCITY(v, 0, 0, 0);
			--	end
				
				for window = 0, 8 do
					VEHICLE.SMASH_VEHICLE_WINDOW(v, window)
				end
				for flat = 0, 8 do
					VEHICLE.SET_VEHICLE_TYRE_BURST(v, flat, true, 1000.0);
				end
				--VEHICLE.SET_VEHICLE_ALARM(v, true);
				--VEHICLE.START_VEHICLE_ALARM(v);
				VEHICLE.SET_VEHICLE_INTERIORLIGHT(v, true);
				VEHICLE.SET_VEHICLE_DAMAGE(v, 0.5, 0.5, 0.5, 1000.0, 1000, true);
			else
				-- do nothing /not targeting
			end
		end		
	end
end
-- ======================================= 
--    Spawn Specific Ped
-- ======================================= 
function <TT>.spawnPed()
	local playerPed = PLAYER.PLAYER_PED_ID();
	local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, 0.0, 2.0, 2.0);
	skin_hash = GAMEPLAY.GET_HASH_KEY("u_m_y_zombie_01")
	STREAMING.REQUEST_MODEL(skin_hash)	
	local clone = PED.CREATE_PED(26, GAMEPLAY.GET_HASH_KEY("u_m_y_zombie_01"), coords.x, coords.y, coords.z, 1, false, true)
	local group = PLAYER.GET_PLAYER_GROUP(PLAYER.PLAYER_ID());
	PED.SET_PED_AS_GROUP_MEMBER(clone, group);
	AI.TASK_COMBAT_HATED_TARGETS_AROUND_PED(clone, 5000, 0);
	PED.SET_PED_KEEP_TASK(clone, true);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(clone, GAMEPLAY.GET_HASH_KEY("weapon_pistol"), 5, true);
	ENTITY.SET_ENTITY_INVINCIBLE(clone, false);
end
-- ======================================= 
--    Spawn Random Ped
-- ======================================= 
function <TT>.spawnRandomPed()
	local playerPed = PLAYER.PLAYER_PED_ID();
	local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, 0.0, 2.0, 2.0);
	local group = PLAYER.GET_PLAYER_GROUP(PLAYER.PLAYER_ID());
	local clone = PED.CREATE_RANDOM_PED(coords.x, coords.y, coords.z);
	PED.SET_PED_RELATIONSHIP_GROUP_HASH(clone, GAMEPLAY.GET_HASH_KEY("army"))
	--PED.SET_PED_AS_GROUP_MEMBER(clone, group);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(clone, GAMEPLAY.GET_HASH_KEY("weapon_pistol"), 5, true);
	ENTITY.SET_ENTITY_INVINCIBLE(clone, false);
	AI.TASK_COMBAT_PED(clone, PLAYER.PLAYER_PED_ID(),1 ,1)
	PED.SET_PED_KEEP_TASK(clone, true);
	PED.SET_PED_MONEY(clone, 500);
	PED.SET_ENABLE_HANDCUFFS(clone, true);
	table.insert(<TT>.data["clones"], clone);
	return clone;
end
-- ======================================= 
--    Spawn chicken
-- ======================================= 
function <TT>.spawnChicken()
	if (<TT>.data["chicken"] == 0) then
		local skin_hash = GAMEPLAY.GET_HASH_KEY("a_c_hen");
		STREAMING.REQUEST_MODEL(skin_hash);
		local clone = PED.CREATE_PED(26, GAMEPLAY.GET_HASH_KEY("a_c_hen"), 1210.261, -2523.061, 39.46, 1, false, true)
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(clone, GAMEPLAY.GET_HASH_KEY("army"));
		ENTITY.SET_ENTITY_INVINCIBLE(clone, false);
		PED.SET_PED_MONEY(clone, 1000);
		ENTITY.FREEZE_ENTITY_POSITION(clone, true);
		<TT>.data["chicken"] = clone;
		--STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(skin_hash);
		<TT>.data["chicken_in_play"] = true;
	else
		print("Chicken already in play");
	end
end
-- ======================================= 
--    Kill Peds
-- ======================================= 
function <TT>.killPeds() 
	local playerPed = PLAYER.PLAYER_PED_ID()
	local PedTab,PedCount = PED.GET_PED_NEARBY_PEDS(playerPed, 30, 30)
	local VehTab,VehCount = PED.GET_PED_NEARBY_VEHICLES(playerPed, 1)
	for k,p in ipairs(PedTab)do 
		if(p == playerPed)then
		else
			ENTITY.SET_ENTITY_HEALTH(p, 0);
			PED.EXPLODE_PED_HEAD(p, GAMEPLAY.GET_HASH_KEY("WEAPON_NIGHTSTICK"));
			PED.SET_PED_TO_RAGDOLL(p, 6, 20, 20, TRUE, TRUE, TRUE);
		end
	end
	
end
-- ======================================= 
--   checkCars()
-- ======================================= 
function <TT>.checkCars()
	local playerPed = PLAYER.PLAYER_PED_ID()
	local PedTab,PedCount = PED.GET_PED_NEARBY_PEDS(playerPed, 30, 30)
	local totalFlatsThisCheck = 0
	for k,p in ipairs(PedTab)do 
		v = PED.GET_VEHICLE_PED_IS_USING(p)
			local count = 0;
			if VEHICLE.IS_VEHICLE_TYRE_BURST(vehicle, 1, true) then
				count = count + 1;
				tmod.displayHitText("Hit tire 1 $100!");
				print("Hit tire 1"..v);
			end
			if VEHICLE.IS_VEHICLE_TYRE_BURST(vehicle, 2, true) then
				count = count + 1;
				tmod.displayHitText("Hit tire 2 $100!");
				print("Hit tire 2"..v);
			end
			if VEHICLE.IS_VEHICLE_TYRE_BURST(vehicle, 3, true) then
				count = count + 1;
				tmod.displayHitText("Hit tire 3 $100!");
				print("Hit tire 3"..v);
			end
			if VEHICLE.IS_VEHICLE_TYRE_BURST(vehicle, 4, true) then
				count = count + 1;
				tmod.displayHitText("Hit tire 4  $100!");	
				print("Hit tire 4"..v);
			end
		totalFlatsThisCheck = totalFlatsThisCheck + count;
	end
	return totalFlatsThisCheck;
end
-- ======================================= 
--   Show toggle msgs to screen
-- ======================================= 
function <TT>.showDisplayStack()
	-- ============= --
	--  Info dialog
	-- ============= --
	if (<TT>.toggle["dialog"]) then
		if (<TT>.timer["dialog"] < <TT>.settings["dialog_cooldown"]) then
			<TT>.draw_text(" <TT>", 0.45, 0.00005, 0.4);
			<TT>.draw_text(" TEXT", 0.5, 0.00005, 0.3);
			<TT>.draw_text(" TEXT", 0.63, 0.00005, 0.3);	
			<TT>.draw_text("  by CoreLogic 2015", 0.7, 0.000005, 0.24);			
			<TT>.timer["dialog"] = <TT>.timer["dialog"] + 1;
		else
			<TT>.toggle["dialog"] = false;
			<TT>.timer["dialog"] = 0;
		end
	end
	-- ===================== --
	--   Drop attack toggle
	-- ===================== --
	if(<TT>.toggle['action1']) then
		--<TT>.force();
		<TT>.draw_text(" - attacking... -", 0.97, 0.7, 0.3);
		<TT>.toggle["action1"] = false;
	end
end
-- ======================================= 
--          Capture key up event
-- ======================================= 
function <TT>.keyPressOnce()
	local key2 = 67;
	if CONTROLS.IS_CONTROL_JUST_RELEASED(pad, key) then
		--Jack()
	elseif get_key_pressed(key2) then
		while get_key_pressed(key2) do
			wait(0)
		end
		--Jack()
	end
end
-- ======================================= 
--          Do the work!
-- ======================================= 
function <TT>.tick()
	local playerPed = PLAYER.PLAYER_PED_ID();
	-- ===========================
	--  Draw mgs/run config
	-- ===========================
	<TT>.showDisplayStack();
	-- ===========================
	--  Initialize player
	-- ===========================
	if (not <TT>.data["setup"]) then
		<TT>.setup();
	end	
	-- ===========================
	--  BTN: Test 'T' - Debugging
	-- ===========================
	if(get_key_pressed(84)) then 	
		<TT>.switch("action1");
		wait(<TT>.settings["key_wait_time"]);
	end	
	-- ===========================
	--  BTN: Info about mod 'I'
	-- ===========================
	if(get_key_pressed(73)) then 	
		<TT>.switch("dialog");
		wait(<TT>.settings["key_wait_time"]);
	end	
	-- =============================
	--  BTN: Main action 'K'
	-- =============================
	if(get_key_pressed(75)) then
		<TT>.killPeds();
		wait(<TT>.settings["key_wait_time"]);
	else -- not lifting
	-- =============================
	--  simple display UI
	-- =============================
		--<TT>.draw_text(" [K] <TT> (v0.0)", 0.97, 0.7, 0.3);
	end		
end
function <TT>.unload()
end
return <TT>;
