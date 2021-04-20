AddCSLuaFile("client/motd.lua")

	
hook.Add("PlayerInitialSpawn", "InitMOTD", function( ply )
	ply:ConCommand("motd")
end)
	
hook.Add("PlayerSay", "MOTD", function( ply, text )
	if string.lower( text ) == "/motd" then
		ply:ConCommand("motd")
	elseif string.lower( text ) == "!motd" then
		ply:ConCommand("motd")
	end
end)
	
	