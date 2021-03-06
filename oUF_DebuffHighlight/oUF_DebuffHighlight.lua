local _, ns = ...
local oUF = Tukui.oUF or oUF
assert(oUF, 'oUF DebuffHighlight: unable to locate oUF')
 
local playerClass = select(2,UnitClass("player"))
local CanDispel = {
	PRIEST = { Magic = true, Disease = true },
	SHAMAN = { Magic = false, Curse = true },
	PALADIN = { Magic = false, Poison = true, Disease = true },
	DRUID = { Magic = false, Curse = true, Poison = true },
	MONK = { Magic = false, Poison = true, Disease = true }
}

local dispellist = CanDispel[playerClass] or {}
local origColors = {}
local origBorderColors = {}
local origPostUpdateAura = {}

local blackList = {}

local function GetDebuffType(unit, filter)
	if not unit or not UnitCanAssist("player", unit) then return nil end
	local i = 1
	while true do
		local name, _, texture, _, debufftype = UnitAura(unit, i, "HARMFUL")
		if not texture then break end
		if debufftype and (not filter or (filter and dispellist[debufftype])) and not blackList[name] then
			return debufftype, texture
		end
		i = i + 1
	end
end

local function CheckSpec(self, event, levels)
	-- Not interested in gained points from leveling
	if event == "CHARACTER_POINTS_CHANGED" and levels > 0 then return end

	--Check for certain talents to see if we can dispel magic or not
	local id, spec = GetSpecializationInfo(GetSpecialization())
	if playerClass == "PALADIN" and spec == "Holy" then
		dispellist.Magic = true
	elseif playerClass == "SHAMAN" and spec == "Restoration" then
		dispellist.Magic = true
	elseif playerClass == "DRUID" and spec == "Restoration" then
		dispellist.Magic = true
	elseif playerClass == "MONK" and spec == "Mistwalker" then
		dispellist.Magic = true
	end
end

local function Update(object, event, unit)
	if unit ~= object.unit then return; end

	local debuffType, texture  = GetDebuffType(unit, object.DebuffHighlightFilter)
	if debuffType then
		local color = DebuffTypeColor[debuffType]
		if object.DebuffHighlightBackdrop then
			object:SetBackdropColor(color.r, color.g, color.b, object.DebuffHighlightAlpha or 1)
		elseif object.DebuffHighlightUseTexture then
			object.DebuffHighlight:SetTexture(texture)
		else
			object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, object.DebuffHighlightAlpha or .5)
		end
	else
		if object.DebuffHighlightBackdrop then
 			local color = origColors[object]
 			object:SetBackdropColor(color.r, color.g, color.b, color.a)
 			color = origBorderColors[object]
 			object:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
 		elseif object.DebuffHighlightUseTexture then
			object.DebuffHighlight:SetTexture(nil)
		else
			local color = origColors[object]
			object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	end
end
 
local function Enable(object)
	-- if we're not highlighting this unit return
	if not object.DebuffHighlightBackdrop and not object.DebuffHighlight then
		return
	end

	-- if we're filtering highlights and we're not of the dispelling type, return
	if object.DebuffHighlightFilter and not CanDispel[playerClass] then
		return
	end

	-- make sure aura scanning is active for this object
	object:RegisterEvent("UNIT_AURA", Update)
	object:RegisterUnitEvent("UNIT_AURA", object.unit)

	object:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	object:RegisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec)
	CheckSpec(object)

	if object.DebuffHighlightBackdrop then
		local r, g, b, a = object:GetBackdropColor()
		origColors[object] = { r = r, g = g, b = b, a = a}
		r, g, b, a = object:GetBackdropBorderColor()
		origBorderColors[object] = { r = r, g = g, b = b, a = a}
	elseif not object.DebuffHighlightUseTexture then
		local r, g, b, a = object.DebuffHighlight:GetVertexColor()
		origColors[object] = { r = r, g = g, b = b, a = a}
	end
 
	return true
end
 
local function Disable(object)
	object:UnregisterEvent("UNIT_AURA", Update)
	object:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	object:UnregisterEvent("CHARACTER_POINTS_CHANGED", CheckSpec)

	if object.DebuffHighlightBackdrop then
		local color = origColors[object]
		if color then
			object:SetBackdropColor(color.r, color.g, color.b, color.a)
			color = origBorderColors[object]
			object:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
		end
	elseif not object.DebuffHighlightUseTexture then -- color debuffs
		local color = origColors[object]
		if color then
			object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	end	
end
 
oUF:AddElement('DebuffHighlight', Update, Enable, Disable)