local template = {}

function template.spawn()

		--#PLAYER VARS
		local playerPed = PLAYER.PLAYER_PED_ID();
		local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, 0.0, 2.0, 2.0);
		
		--#RANDOM PED
		--local clone = PED.CREATE_RANDOM_PED(coords.x, coords.y, coords.z);
				
		-- if our target skin has is not already loaded by the game we will have
		-- to request the game load it before we can use it with our new ped		
		skin_hash = GAMEPLAY.GET_HASH_KEY("u_m_y_zombie_01")
		STREAMING.REQUEST_MODEL(skin_hash)	
		
		--#CREATE PED
		local clone = PED.CREATE_PED(26, GAMEPLAY.GET_HASH_KEY("u_m_y_zombie_01"), coords.x, coords.y, coords.z, 1, false, true)
		
		--#GROUP
		local group = PLAYER.GET_PLAYER_GROUP(PLAYER.PLAYER_ID());
		PED.SET_PED_AS_GROUP_MEMBER(clone, group);
		
		--#AI
		AI.TASK_COMBAT_HATED_TARGETS_AROUND_PED(clone, 5000, 0);
		PED.SET_PED_KEEP_TASK(clone, true);
		
		--#WEAPONS
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(clone, GAMEPLAY.GET_HASH_KEY("weapon_pistol"), 5, true);
		
		--#PROPERTIES
		ENTITY.SET_ENTITY_INVINCIBLE(clone, false);
end


function template.tick()
	--#PLAYER VARS
	local playerPed = PLAYER.PLAYER_PED_ID()
	local player = PLAYER.GET_PLAYER_PED(playerPed)
	local playerExists = ENTITY.DOES_ENTITY_EXIST(playerPed)
	--#VALIDATION
	if(playerExists) then
		--#INPUT EVENT LISTENER
		if(get_key_pressed(90)) then --# z key
			template.spawn()
			print("new template spawn call")
			-- if we don't pause, will run more than once! --
			wait(2000)
		end
	
	end
end

return template
