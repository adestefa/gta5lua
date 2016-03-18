local again = {}
function again.tick()
    -- end key 35--
	if(get_key_pressed(35)) then
		loadAddIns()
		print("AddIns ReLoaded")
		wait(4999);	
	end
end
return again