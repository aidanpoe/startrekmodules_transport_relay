---------------------------------------
---------------------------------------
--        made for Star Trek Module  --
-- Addon Created by HouseofPoe.co.uk --
--        API Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2025 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
-- Star Trek Transport Relay | Loader--
---------------------------------------

if not istable(TOOL) then Star_Trek:LoadAllModules() return end

TOOL.Category = "ST:RP"
TOOL.Name = "Transport Relay Tool"
TOOL.ConfigName = ""

local textEntry

if (CLIENT) then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" }
	}

	language.Add("tool.transport_relay.name", "Transport Relay Tool")
	language.Add("tool.transport_relay.desc", "Mark entities, props, NPCs, ragdolls, or players as transport relay destinations. They will appear in the transporter system until transported.")
	language.Add("tool.transport_relay.left", "Mark Entity as Transport Relay")
	language.Add("tool.transport_relay.right", "Remove Transport Relay from Entity")

	local relays = {}
	
	net.Receive("Star_Trek.TransportRelay.Sync", function()
		relays = net.ReadTable()
	end)

	net.Receive("Star_Trek.TransportRelay.Create", function()
		local ent = net.ReadEntity()

		net.Start("Star_Trek.TransportRelay.Create")
			net.WriteEntity(ent)
			net.WriteString(textEntry:GetText())
		net.SendToServer()
	end)

	-- Oh look, here is some feedback for the relay thingy
	local function renderRelayMarker(ent, name)
		if not IsValid(ent) then return end
		
		local pos = ent:GetPos()
		local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
		local size = (maxs - mins):Length()
		local height = math.max(size, 30)
		
		-- them lines you see going up? yeah its them lad
		render.DrawLine(pos, pos + Vector(0, 0, height), Color(100, 200, 255))
		render.DrawLine(pos + Vector(5, 0, 0), pos + Vector(5, 0, height), Color(100, 200, 255))
		render.DrawLine(pos + Vector(-5, 0, 0), pos + Vector(-5, 0, height), Color(100, 200, 255))
		render.DrawLine(pos + Vector(0, 5, 0), pos + Vector(0, 5, height), Color(100, 200, 255))
		render.DrawLine(pos + Vector(0, -5, 0), pos + Vector(0, -5, height), Color(100, 200, 255))
		
		-- Circle the top of the thing lad
		local ringPos = pos + Vector(0, 0, height)
		for i = 0, 12 do
			local a1 = math.rad((i / 12) * 360)
			local a2 = math.rad(((i + 1) / 12) * 360)
			local p1 = ringPos + 15 * Vector(math.sin(a1), math.cos(a1), 0)
			local p2 = ringPos + 15 * Vector(math.sin(a2), math.cos(a2), 0)
			render.DrawLine(p1, p2, Color(100, 200, 255))
		end

		-- puts a name on the top, if its called "derek" then your item will be marked "derek" I knew a derek once, was a bit of a prick
		if isstring(name) and name ~= "" then
			local dy = EyeAngles():Up()
			local dx = -EyeAngles():Right()
			local ang = dx:AngleEx(dx:Cross(-dy))
			ang:RotateAroundAxis(EyeAngles():Forward(), 180)

			cam.Start3D2D(ringPos + Vector(0, 0, 10), ang, 0.1)
				draw.SimpleText(name, "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end

	-- am not gonna tell you what this is for mwahahaha
	hook.Add("PostDrawTranslucentRenderables", "TransportRelay.Render", function()
		local toolSwep = LocalPlayer():GetActiveWeapon()
		if not IsValid(toolSwep) or toolSwep:GetClass() ~= "gmod_tool" then
			return
		end

		local toolTable = LocalPlayer():GetTool()
		if not istable(toolTable) or toolTable.Mode ~= "transport_relay" then
			return
		end

		for entIndex, relayData in pairs(relays or {}) do
			local ent = Entity(entIndex)
			if IsValid(ent) then
				renderRelayMarker(ent, relayData.Name)
			end
		end
	end)
end

if SERVER then
	util.AddNetworkString("Star_Trek.TransportRelay.Sync")
	util.AddNetworkString("Star_Trek.TransportRelay.Create")

	function TOOL:Sync()
		net.Start("Star_Trek.TransportRelay.Sync")
			net.WriteTable(Star_Trek.Transporter.Relays)
		net.Send(self:GetOwner())
	end

	net.Receive("Star_Trek.TransportRelay.Create", function(len, ply)
		local ent = net.ReadEntity()
		local name = net.ReadString()

		if not IsValid(ent) then return end

		local tool = ply:GetTool()
		if tool.Mode ~= "transport_relay" then return end

		-- not named the baby? well lets give it a number
		if name == "" then
			Star_Trek.Transporter.RelayCounter = Star_Trek.Transporter.RelayCounter + 1
			name = tostring(Star_Trek.Transporter.RelayCounter) .. " (Relay)"
		else
			name = name .. " (Relay)"
		end

		-- stores the data somewhere? like is it ram? a floppy disk? inside the warp core? who knows
		local entIndex = ent:EntIndex()
		Star_Trek.Transporter.Relays[entIndex] = {
			Entity = ent,
			Name = name,
			Pos = ent:GetPos()
		}

		-- another secrect cos funny
		ent.IsTransportRelay = true
		ent.TransportRelayName = name

		hook.Run("Star_Trek.Transporter.ExternalsChanged")
	end)

	function TOOL:Deploy()
		self:Sync()
	end
end

-- Sync relays when they change
hook.Add("Star_Trek.Transporter.ExternalsChanged", "Star_Trek.TransportRelay.ExternalsChanged", function()
	for _, ply in ipairs(player.GetAll()) do
		local tool = ply:GetTool()
		if tool == nil then continue end
		if tool.Mode == "transport_relay" then
			tool:Sync()
		end
	end
end)

--  adds derek to the list 
hook.Add("Star_Trek.Transporter.AddExternalMarkers", "Star_Trek.TransportRelay.AddExternalMarkers", function(interface, externalMarkers, skipNetworked)
	for entIndex, relayData in pairs(Star_Trek.Transporter.Relays) do
		local ent = relayData.Entity
		
		-- Check if entity still exists
		if not IsValid(ent) then
			-- Clean up invalid entries
			Star_Trek.Transporter.Relays[entIndex] = nil
			continue
		end

		-- Update position in case entity moved, thats a bloody good feature, thanks AI!
		relayData.Pos = ent:GetPos()

		-- Add to external markers with a unique ID
		-- Use a very large number to avoid conflicts with normal external markers
		local relayId = 1000000 + entIndex
		externalMarkers[relayId] = {
			Name = relayData.Name,
			Pos = relayData.Pos
		}
	end
end)

-- Remove relay when entity is transported, cos you don't want the relay to stay, where does it go? I eat it, I eat the relay
hook.Add("Star_Trek.Transporter.EndTransporterCycle", "Star_Trek.TransportRelay.RemoveOnTransport", function(transporterCycle)
	if not istable(transporterCycle) then return end
	
	local ent = transporterCycle.Entity
	if not IsValid(ent) then return end
	if not ent.IsTransportRelay then return end

	-- Only remove relay when entity is successfully rematerialized (not in buffer)
	-- State 4 means completed rematerialization
	if transporterCycle.State >= 4 then
		-- Remove from relay list
		local entIndex = ent:EntIndex()
		if Star_Trek.Transporter.Relays[entIndex] then
			Star_Trek.Transporter.Relays[entIndex] = nil
			ent.IsTransportRelay = nil
			ent.TransportRelayName = nil
			
			hook.Run("Star_Trek.Transporter.ExternalsChanged")
		end
	end
end)

-- Left click: Mark entity as relay
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	-- Check if entity can be marked as relay
	-- Allow props, NPCs, ragdolls, and players
	local class = ent:GetClass()
	local isValid = ent:IsPlayer() or 
	                ent:IsNPC() or 
	                class == "prop_physics" or 
	                class == "prop_ragdoll" or
	                class:find("npc_") or
	                ent:GetPhysicsObject():IsValid()

	if not isValid then
		if IsValid(self:GetOwner()) then
			self:GetOwner():ChatPrint("This entity cannot be marked as a transport relay.")
		end
		return false
	end

	-- Check if already marked (so you dont have to manually do it)
	if ent.IsTransportRelay then
		if IsValid(self:GetOwner()) then
			self:GetOwner():ChatPrint("This entity is already marked as a transport relay.")
		end
		return false
	end

	local owner = self:GetOwner()
	if not IsValid(owner) then return true end

	net.Start("Star_Trek.TransportRelay.Create")
		net.WriteEntity(ent)
	net.Send(owner)

	return true
end

-- Right click: Remove relay from entity
function TOOL:RightClick(tr)
	if (CLIENT) then return true end

	local ent = tr.Entity
	if not IsValid(ent) then return false end

	if not ent.IsTransportRelay then
		if IsValid(self:GetOwner()) then
			self:GetOwner():ChatPrint("This entity is not marked as a transport relay.")
		end
		return false
	end

	-- Remove relay
	local entIndex = ent:EntIndex()
	if Star_Trek.Transporter.Relays[entIndex] then
		Star_Trek.Transporter.Relays[entIndex] = nil
		ent.IsTransportRelay = nil
		ent.TransportRelayName = nil

		if IsValid(self:GetOwner()) then
			self:GetOwner():ChatPrint("Transport relay removed.")
		end

		hook.Run("Star_Trek.Transporter.ExternalsChanged")
	end

	return true
end

function TOOL:BuildCPanel()
	if SERVER then return end

	self:AddControl("Header", {
		Text = "#tool.transport_relay.name",
		Description = "Name your relay (leave empty for auto-numbering):"
	})

	textEntry = vgui.Create("DTextEntry")
	textEntry:SetPlaceholderText("Enter relay name...")

	self:AddItem(textEntry)

	self:AddControl("Label", {
		Text = "Left Click: Mark entity as relay"
	})

	self:AddControl("Label", {
		Text = "Right Click: Remove relay"
	})

	self:AddControl("Label", {
		Text = "Relays will disappear from the transporter list once transported."
	})
end
-- imagine if i coded all of this, Id be on so much smack right now