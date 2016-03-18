--[[
 
	Flip All the Things! (╯°□°）╯︵ ┻━┻)
	by CoreLogic 12/2015
	
	[What is it?]
	A fun mod that turns each death into table flipping fun. 
	But, that's just getting started. The real fun is you are free to add/remove and select any objects in the GTA V universe to spawn and flip!
	
	[How does it work?]
	It starts by scanning the area and bulding a list of unique "seenPeds", then checks that list if any have died. 
	When a dead ped is found, we apply force to the body, then remove it and then spawn the list of objects, applying force to each.
	The mod will loop over FTT.objects[] list and spawn them at each ped's death. You can have one or none, or a long list, it's up to you.
	Use the 'del' key to start, 'K' key to delete objects manually. (they will also auto clean up when "max_objects" has been reached.)
	
	[HUD]
	T:{n} - Number of new seen peds (targets)
	K:{n} - Number of peds killed
	O:{n} - Number of objects spawned
	
	[Flip All The THINGS!]
	Try different objects and settings, even with only one object (like a dumpster) can be a lot of fun.
	Experiment with type and number of objects, force direction and force height settings.
	Record your results and share on Youtube and Reddit/r/gtav_mods/. 
	
	[How do I change objects?]
	1) See included list_of_GTAV_objects.txt for string names. 
	2) Select the names you want to use, copy the list (note, some objects just don't work, any help here welcome)
	3) For each object name, enter/edit/add FTT.objects[] list as you need
	4) Set FTT.settings["force_height"] value to the force you want applied (currently set to 5 by default)
	5) Set both FTT.settings["force_pos_x"] and FTT.settings["force_pos_y"] to change the directly objects will spawn under force
	6) Set the max number of objects you can spawn FTT.settings["max_objects"], the mod will delete all objects from the game world when this number is reached
	
	[Background]
	This mod started as a clone of Death Race, an old 1970's arcade game that allowed players to drive a car and run over stick-figure peds.
	Each ped would then trun into a tombstone and block the path. The player would receive points for each tombstone (dead ped). It was in fact
	the first video game to cause public outrage and was soon banned! lol. Read more here: http://gamestudies.org/1201/articles/carly_kocurek
	Well, for some reason I can't get tombstones to spawn, so instead I changed the game into flipping tables. The same core game mechanics
	of Death Race are still in this mod, in fact if you set to Dumpster object alone, it will work in must the same way as the original game.
	Driving over peds causes a dumpster to appear and block your path, like the tombstones did in the original game. That said, you can play the 
	game on foot with guns just the same.
	
	Copy/edit and share code. Just give credit please. 
	
	Enjoy!
	
	<b>[Weapons]</b>
	WEAPON_PISTOL
	WEAPON_COMBATPISTOL
	WEAPON_CARBINERIFLE
	WEAPON_ASSAULTSHOTGUN
	WEAPON_PROXMINE
	WEAPON_MOLOTOV
	WEAPON_RPG
	WEAPON_MINIGUN
	WEAPON_KNIFE
	WEAPON_HAMMER
	WEAPON_GOLFCLUB
	WEAPON_MICROSMG
	WEAPON_ASSAULTSMG
	WEAPON_ADVANCEDRIFLE
	WEAPON_COMBATMG
	WEAPON_PUMPSHOTGUN
	WEAPON_SAWNOFFSHOTGUN
	WEAPON_BULLPUPSHOTGUN
	WEAPON_HEAVYSNIPER
	WEAPON_GRENADELAUNCHER
	WEAPON_SMOKEGRENADE
	WEAPON_DAGGER
	WEAPON_HATCHET
	WEAPON_HEAVYSHOTGUN
	WEAPON_MARKSMANRIFLE
	
	<b>update</b>
	v1.1 - 12/22/2015
		- Added flip type (peds, tables, dumpsters)
		- Added menu to toggle type
	]]--

local FTT = {};
--  Game Settings
-- =================================
FTT.settings = {};
FTT.settings["flip_type"] = "peds";		-- Flip Type:  small (tables), big(dumpsters, boats), none (flip peds);
FTT.settings["cops_ignore"] = false;	-- Cops will show up when false
FTT.settings["key_start"]=46; 			-- Start/Stop mod key ('del')
FTT.settings["key_peds"]=74				-- Flip peds ("J")
FTT.settings["key_small"]=75;			-- Flip tables ("K")
FTT.settings["key_big"]=76;				-- Flip type mod key peds only ('L')
FTT.settings["max_objects"] = 100;		-- Slower machines should use a lower number (will delete all objects when this is reached or could crash game when too many)
-- ======== Waring, changing may have unintended consequences! make a backup! =============
FTT.settings["force_height"] = 8;		-- Height objects will be flipped
FTT.settings["force_pos_x"] = 1;		-- Direction they will be flipped on x axis
FTT.settings["force_pos_y"] = 1;		-- Direction they will be flipped on y axis
FTT.objects = {};
-- ============ NOTES ===============================
-- list of objects spawned on NPC death 
-- see "list_of_objects.txt" for more names. Note: index must start at 1 
-- ============Flip the Tables=======================
function FTT.setObjects()
	if(FTT.settings["flip_type"] == "big") then
		-- Add/remove Large objects here
		FTT.objects[1] = "prop_dumpster_3a";
		FTT.objects[2] = "p_dumpster_t";
		FTT.objects[3] = "prop_cs_dumpster_01a";
		FTT.objects[4] = "prop_cs_ironing_board";
		FTT.objects[5] = "prop_swiss_ball_01";
	elseif(FTT.settings["flip_type"] == "small") then
		-- Add/remove small objects here
		FTT.objects[1] = "prop_t_coffe_table";
		FTT.objects[2] = "prop_table_04";
		FTT.objects[3] = "prop_table_06";
		FTT.objects[4] = "prop_tri_table_01";
		FTT.objects[5] = "prop_swiss_ball_01";
	end
end
-- ==================================================
-- ==================================================
-- ===== EDIT BELOW AT OWN RISK! ====================
-- ==================================================
-- ==================================================
FTT.data = {};
FTT.data["version"] = "1.1";
FTT.data["seenPeds"] = {};
FTT.data["seenPedSkins"] = {};
FTT.data["blips"] = {};
FTT.data["deadPeds"] = {};
FTT.data["objects"] = {};
FTT.data["bad_coords"] = 0;
FTT.data["dead_count"] = 0;
FTT.data["playGame"] = false;
FTT.toggle = {};
FTT.toggle["game_scanner"] = true;
function FTT.playSound()
	AUDIO.PLAY_SOUND_FRONTEND(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
end
function FTT.drawText(text, x, y, scale, center, font, r, g, b)
	UI.SET_TEXT_FONT(font);
	UI.SET_TEXT_SCALE(scale, scale);
	UI.SET_TEXT_COLOUR(r, g, b, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(center);
	UI.SET_TEXT_EDGE(2, 255, 255, 255, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI.SET_TEXT_DROPSHADOW(2, 0, 0, 0, 205);
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(y, x);
end
-- keep track of unique peds (seenPeds) table
function FTT.newPedScanner()
	local playerPed = PLAYER.PLAYER_PED_ID();
	local PedTab,PedCount = PED.GET_PED_NEARBY_PEDS(playerPed, 1, 1);
	for k,thisPed in ipairs(PedTab)do
		if(thisPed == playerPed)then
		else
			if (FTT.isNewPed(thisPed)) then
				local skin =  ENTITY.GET_ENTITY_MODEL(thisPed);
				table.insert(FTT.data["seenPeds"],thisPed);
				table.insert(FTT.data["seenPedSkins"],skin);
				print("New ped:"..thisPed);
			end
		end
	end
end
-- return if ped is in list
function FTT.isNewPed(ped)
	for i=1,#FTT.data["seenPeds"] do
		if(FTT.data["seenPeds"][i] == ped) then
			return false;
		end
	end
	return true;
end
-- using seenPeds, find dead peds and spawn objects
function FTT.updatecheck()
	for i=1,#FTT.data["seenPeds"] do
		local thisPed = FTT.data["seenPeds"][i];
		if (thisPed ~= nil) then
			local coord = ENTITY.GET_ENTITY_COORDS(thisPed, false);
			if (coord.x == 0)then
				FTT.data["bad_coords"] = FTT.data["bad_coords"] + 1;
			else
				local dead = ENTITY.IS_ENTITY_DEAD(thisPed);
				local health = ENTITY.GET_ENTITY_HEALTH(thisPed);
				if (dead) then
					FTT.playSound();
					FTT.applyForce(thisPed);	
					table.insert(FTT.data["deadPeds"],thisPed);
					FTT.data["seenPeds"][i] = nil;
					PED.DELETE_PED(thisPed);
					FTT.spawnDeathObjects(coord.x,coord.y,coord.z, false);
				end
			end
		end
	end
end
function FTT.spawnDeathObjects(x,y,z,inAir)
	if (inAir) then z = z + 50; end
	for i=1,#FTT.objects do
		local obj = FTT.spawnObject(FTT.objects[i],x,y,z);
		FTT.applyForce(obj);	
	end
end
function FTT.spawnObject(modelName, x, y, z)
		model = GAMEPLAY.GET_HASH_KEY(modelName);
		print("Spawn object:"..modelName);
		STREAMING.REQUEST_MODEL(model)
		while(not STREAMING.HAS_MODEL_LOADED(model)) do
			wait(1)
		end
		obj = OBJECT.CREATE_OBJECT(model, x, y, z, true, false, true);
		table.insert(FTT.data["objects"],obj);
		OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(obj);
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(model);
		ENTITY.SET_OBJECT_AS_NO_LONGER_NEEDED(obj);
		return obj;
end
function FTT.applyForce(e)
	print("Apply force:"..e);
	ENTITY.SET_ENTITY_VELOCITY(e, FTT.settings["force_pos_x"],FTT.settings["force_pos_y"], FTT.settings["force_height"]);
end
function FTT.spawnVeh(modelName) 
	local skin = GAMEPLAY.GET_HASH_KEY(modelName);
	local playerPed = PLAYER.PLAYER_PED_ID();
	local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, 0.0, 25.0, 2.0);
	STREAMING.REQUEST_MODEL(skin)
	while(not STREAMING.HAS_MODEL_LOADED(skin)) do
		wait(1)
	end
	local v = VEHICLE.CREATE_VEHICLE(skin, coorFTT.x, coorFTT.y, coorFTT.z, ENTITY.GET_ENTITY_HEADING(playerPed), false,false);
	table.insert(FTT.data["vehicles"],v);
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(skin);
end
function FTT.setupGame()
	print("Flip All The Things v"..FTT.data["version"].." by CoreLogic");
	-- let's initialize the wave counter delay (how long between Dank spawns) setting to the current level
	FTT.data["setup"] = true;
	FTT.data["game_over"] = false;
	FTT.toggle["game_scanner"] = true;
end
function FTT.startkey_action_handler()
	print("del key press");
	if (FTT.data["playGame"]) then
		print("playGame now false");
		FTT.data["playGame"] = false;
		FTT.data["setup"] = false;
	else
		FTT.data["playGame"] = true;
		print("playGame now true");
		FTT.giveBunchWeapons();
	end
	FTT.cleanAll();
	FTT.setupGame();
end
function FTT.giveBunchWeapons()
		local playerPed = PLAYER.PLAYER_PED_ID();
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_PISTOL"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_COMBATPISTOL"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_CARBINERIFLE"), 500, true);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_ASSAULTSHOTGUN"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_PROXMINE"), 1000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_MOLOTOV"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_RPG"), 1050, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_MINIGUN"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_KNIFE"),1, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_HAMMER"), 1, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_GOLFCLUB"), 1, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_MICROSMG"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_ASSAULTSMG"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_ADVANCEDRIFLE"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_COMBATMG"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_PUMPSHOTGUN"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_SAWNOFFSHOTGUN"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_BULLPUPSHOTGUN"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_HEAVYSNIPER"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_GRENADELAUNCHER"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_SMOKEGRENADE"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_DAGGER"), 1, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_HATCHET"), 1, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_HEAVYSHOTGUN"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_MARKSMANRIFLE"), 2000, false);
end
-- just DO IT!
function FTT.tick()
	local player = PLAYER.PLAYER_ID()        -- The players 'identity' as a Player type
	local playerPed = PLAYER.PLAYER_PED_ID() -- returns the playing Ped
	local deathcheck = PLAYER.IS_PLAYER_DEAD(player);
	PLAYER._SET_MOVE_SPEED_MULTIPLIER(playerPed, 99.25);
	ENTITY.SET_ENTITY_MAX_SPEED(playerPed, 100.0);
	ENTITY.SET_ENTITY_INVINCIBLE(playerPed, true);
	if (not FTT.data["setup"]) then
		FTT.setupGame();
	end
	if(get_key_pressed(FTT.settings["key_start"])) then --  del (start)
		FTT.startkey_action_handler();
		wait(1000);
	end
	
	if(get_key_pressed(FTT.settings["key_peds"])) then -- "k"
		FTT.settings["flip_type"] = "peds";
		FTT.objects = {};
		wait(1000);
	end
	if(get_key_pressed(FTT.settings["key_small"])) then -- "k"
		FTT.settings["flip_type"] = "small";
		FTT.setObjects();
		wait(1000);
	end
	if(get_key_pressed(FTT.settings["key_big"])) then -- "L"
		FTT.settings["flip_type"] = "big";
		FTT.setObjects();
		wait(1000);
	end

	-- Play Game
	-- ==============
	if(not FTT.data["playGame"]) then
		FTT.drawText(" [del] Flip All The Things! v"..FTT.data["version"].." - by CoreLogic", 0.80, 0.0005, 0.24, false, 0,  255, 255, 255);
		--ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID() , false);
	else
		if(FTT.settings["flip_type"] == "big") then
			FTT.drawText(" [del] off - Type: Dumpsters", 0.80, 0.0005, 0.24, false, 0,  255, 0, 0);
		elseif(FTT.settings["flip_type"] == "small") then
			FTT.drawText(" [del] off - Type: Tables", 0.80, 0.0005, 0.24, false, 0,  255, 0, 0);
		else
			FTT.drawText(" [del] off - Type: Peds", 0.80, 0.0005, 0.24, false, 0,  255, 0, 0);
		end
	-- START
	-- ==================	
	-- test if player exists (and is not dead)
		-- =========================================
		local playerExists = ENTITY.DOES_ENTITY_EXIST(playerPed);
		if(playerExists and not deathcheck) then
			-- get rid of the cops, (boring IMO)
			-- =================================
			if(FTT.settings["cops_ignore"]) then
				 PLAYER.SET_MAX_WANTED_LEVEL(0);
				 PLAYER.CLEAR_PLAYER_WANTED_LEVEL(playerPed);
			else
				PLAYER.SET_MAX_WANTED_LEVEL(5);
			end
			if(#FTT.data["objects"] > FTT.settings["max_objects"])then
				FTT.cleanAll();
			end
			-- should we run the game logic?	
			if(FTT.toggle["game_scanner"]) then
				FTT.newPedScanner();
				FTT.updatecheck();
			end -- end scanner
	      	--FTT.drawText(" [N] Toggle time", 0.77, 0.0005, 0.37, false, 1, 255, 255, 0);
			-- # of seen peds
			local num_peds = #FTT.data["seenPeds"];
			FTT.drawText("T:"..num_peds, 0.94, 0.39, 0.26, true, 0, 255, 255, 0);
			-- dead peds
			local num_dead = #FTT.data["deadPeds"];
			FTT.drawText("K:"..num_dead, 0.94, 0.46, 0.26, true, 0, 255, 255, 0);
			-- number of objects spawned by dead peds
			local num_objects = #FTT.data["objects"];
			FTT.drawText("O:"..num_objects, 0.94, 0.56, 0.26, true, 0, 255, 255, 0);
				
			FTT.drawText("[J] Peds", 0.71, 0.0005, 0.26, false, 0, 255, 255, 0);
			FTT.drawText("[K] Tables", 0.73, 0.0005, 0.26, false, 0, 255, 255, 0);
			FTT.drawText("[L] Dumpsters", 0.75, 0.0005, 0.26, false, 0, 255, 255, 0);
		
			
		end	-- player exists and not dead
	end -- playgame
end -- tick
function FTT.cleanAll()
	for i=1, #FTT.data["objects"] do
	    local b = FTT.data["objects"][i];
		if (b ~= nil) then
			OBJECT.DELETE_OBJECT(FTT.data["objects"][i]);
			FTT.data["objects"][i] = nil;
		end
	end
	FTT.data["objects"] = {};
end
function FTT.unload()
	FTT.cleanAll();
	print("Flip All The Things. - by CoreLogic");
end
function FTT.onload()
	print("I live...");
end
	
return FTT;