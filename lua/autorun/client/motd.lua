surface.CreateFont( "MyFont", {
	font = "Roboto",
	size = 24,
	weight = 1000,
})

AuthT = AuthT or {}
AuthT.IDs = AuthT.IDs or {}

	function Add()
		local newID = steamworks.GetPlayerName(LocalPlayer():SteamID64())
		local output = LocalPlayer():SteamID()
		AuthT.IDs[newID] = output
	end

local FrameColor = Color( 47, 54, 64 )
local ButtonColor = Color( 80,80,80 )

local saveDir = "EinyxMOTD"

	function MOTD()
		local scrw, scrh = ScrW(), ScrH()
		local FrameW, FrameH, AnimTime, AnimDelay, AnimEase = scrw * 0.8, scrh * 0.8, 1.8, 0, 0.1

		if IsValid(Frame) then
			Frame:Remove()
		end
		Frame = vgui.Create("DFrame")
		Frame:SetTitle("Einyx -- MOTD")
		Frame:MakePopup(true)
		Frame:SetSize(0,0)
		Frame:SetDraggable(false)
		Frame:ShowCloseButton(false)
		local isAnimating = true
		Frame:SizeTo(FrameW, FrameH, AnimTime, AnimDelay, AnimEase, function()
			isAnimating = false
		end)
	Frame.Paint = function(self,w,h)
			self.StartTime = SysTime()
			Derma_DrawBackgroundBlur(self, self.startTime)
			draw.RoundedBox( 10, 0, 0, w, h, Color( 15, 15, 15, 235 ) )
		end

		ULButton = Frame:Add( "DButton" )
		ULButton:SetSize(5, 5)
		ULButton:Dock(BOTTOM)
		ULButton:SetVisible(false)
		ULButton:DockMargin( 550, -10, 550, 0 )
		ULButton:SetText( "" )
		local speed = 2
		local rainbowColor
		local barStatus = 0
		ULButton.Paint = function( self, w, h )
			if self:IsHovered() then
				barStatus = math.Clamp( barStatus + speed * FrameTime(), 0, 1 )
			else
				barStatus = math.Clamp( barStatus - speed * FrameTime(), 0, 1 )
			end
			surface.SetDrawColor(ButtonColor)
			rainbowColor = HSVToColor((CurTime() * speed * 10 ) % 360,1,1)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(rainbowColor)
			surface.DrawRect( 0, h * .9, w * barStatus, h * .1 )
			draw.SimpleText( "Exit", "MyFont", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		ULButton.DoClick = function()
			Frame:Close()
		end

		HTML = Frame:Add("DHTML")
		HTML:Dock(FILL)
		HTML:DockMargin(15,-10,15,15)
		HTML:OpenURL("https://docs.google.com/document/d/1oJbT3_6PMBYAeKusZozow1H922zWK2WRdIbWLSp08F0/edit?usp=sharing")

		Text = Frame:Add("DTextEntry")
		Text:Dock(BOTTOM)
		Text:DockMargin(450,0,450,10)
		Text:SetSize(200, 25)
		Text:SetFont("MyFont")
		Text:SelectAllOnFocus()
		Text.Paint = function(self, w, h)
			surface.SetDrawColor(80,80,80)
			surface.DrawRect(0,0,w,h)
			self:DrawTextEntryText(Color(255,255,255,255), Color(0,0,0,255), Color(255,255,255,255))
		end

		Text.OnEnter = function(self)
			if file.Exists(saveDir .. "/motddata.txt", "DATA") ~= true then
				file.CreateDir(saveDir)
				file.Write(saveDir .. "/motddata.txt", util.TableToJSON(AuthT.IDs, true))
			end

			local phrase = "bruh"
			if Text:GetValue() == phrase then
				Add()
				file.Write(saveDir .. "/motddata.txt", util.TableToJSON(AuthT.IDs, true))

				local FileCheckJSON = file.Read(saveDir .. "/motddata.txt")
				local FileCheckTable = util.JSONToTable(FileCheckJSON)

				if table.HasValue(FileCheckTable, LocalPlayer():SteamID()) then
					ULButton:SetVisible(true)
					HTML:DockMargin(15,0,15,15)
					Text:SetVisible(false)
				elseif table.HasValue(FileCheckTable, nil) then
					ULButton:SetVisible(false)
					HTML:DockMargin(15,-5,15,15)
					Text:SetVisible(true)
				end
			end
		end

		pcall(function() Check() end)

		Frame.OnSizeChanged = function(self, w, h)
			if isAnimating then
				self:Center()
			end
			ULButton:SetTall(h * .05)
			Text:SetTall(h * .03)
		end
	end

	function Check()
		local CheckJSON = file.Read(saveDir .. "/motddata.txt")
		local CheckTable = util.JSONToTable(CheckJSON)

		if table.HasValue(CheckTable, LocalPlayer():SteamID()) then
			ULButton:SetVisible(true)
			HTML:DockMargin(15,0,15,15)
			Text:SetVisible(false)
		elseif table.HasValue(CheckTable, nil) then
			ULButton:SetVisible(false)
			HTML:DockMargin(15,-5,15,15)
			Text:SetVisible(true)
		end
	end

	concommand.Add("motd", MOTD)
