surface.CreateFont( "TextFont", { font = "Roboto", size = 21, weight = 1000, })
surface.CreateFont( "ButtonFont", { font = "Roboto", size = 16, weight = 1000, })

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
	local FrameW, FrameH, AnimTime, AnimDelay, AnimEase = scrw * 0.7, scrh * 0.7, 1.8, 0, 0.1

	if IsValid(Frame) then
		Frame:Remove()
	end
	Frame = vgui.Create("DFrame")
	Frame:SetTitle("")
	Frame:MakePopup(true)
	Frame:SetSize(0,0)
	Frame:ShowCloseButton(false)
	local isAnimating = true
	Frame:SizeTo(FrameW, FrameH, AnimTime, AnimDelay, AnimEase, function()
		isAnimating = false
	end)
	Frame.Paint = function(self,w,h)
		surface.SetDrawColor(25,25,25,255)
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(15,15,15,255)
		surface.DrawRect(0,0,w,h*0.04)
	end

	CButton = vgui.Create("DButton", Frame)
	CButton:SetPos(scrw * 0.675, 0)
	CButton:SetFont("ButtonFont")
	CButton:SetVisible(false)
	CButton:SetText("Close")
	CButton.Paint = function(self, w, h)
		surface.SetDrawColor(15,15,15)
		surface.DrawRect(0,0,w,h)
	end
	CButton.DoClick = function()
		Frame:Close()
	end

	HTML = Frame:Add("DHTML")
	HTML:Dock(FILL)
	HTML:DockMargin(5,5,5,5)   
	HTML:SetScrollbars(false)
	HTML:OpenURL("http://furbloke.com/nn/motd.html")

	Text = Frame:Add("DTextEntry")
	Text:Dock(BOTTOM)
	Text:DockMargin(450,0,450,5)
	Text:SetSize(200, 25)
	Text:SetFont("TextFont")
	Text:SetText("Read the Rules and type the Password you find in here!")
	Text:SelectAllOnFocus()
	Text.Paint = function(self, w, h)
		surface.SetDrawColor(35,35,35)
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

			if table.HasValue(FileCheckTable, LocalPlayer():SteamID()) then --HTML:DockMargin(marginLeft, marginTop, marginRight, marginBottom)
				Text:SetVisible(false)
				CButton:SetVisible(true)
				elseif table.HasValue(FileCheckTable, nil) then  
					Text:SetVisible(true)
					CButton:SetVisible(false)
				end
			end
		end

	pcall(function() Check() end)

	Frame.OnSizeChanged = function(self, w, h)
		if isAnimating then
			self:Center()
		end
		Text:SetTall(h * .03)
		CButton:SetSize(w * .04, h * .04)
	end
end

function Check()
	local CheckJSON = file.Read(saveDir .. "/motddata.txt")
	local CheckTable = util.JSONToTable(CheckJSON)

	if table.HasValue(CheckTable, LocalPlayer():SteamID()) then 
		Text:SetVisible(false)
		CButton:SetVisible(true)
	elseif table.HasValue(CheckTable, nil) then
		Text:SetVisible(true)
		CButton:SetVisible(false)
	end
end

concommand.Add("motd", MOTD)
