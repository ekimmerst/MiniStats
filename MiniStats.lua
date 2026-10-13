local ADDON_NAME = ...
local bar, cells
local initialized = false
local freeSlots, totalSlots = 0, 0
local function RestorePosition()
    bar:ClearAllPoints()
    local p = MiniStatsDB.position
    if type(p) == "table" and type(p.x) == "number" and type(p.y) == "number" then
        bar:SetPoint("CENTER", UIParent, "BOTTOMLEFT", p.x, p.y)
    elseif MiniExpBarFrame and MiniExpBarFrame:IsShown() then
        bar:SetPoint("TOP", MiniExpBarFrame, "BOTTOM", 0, -3)
    else
        bar:SetPoint("TOP", Minimap or UIParent, "BOTTOM", 0, -31)
    end
end
local function SavePosition()
    local x, y = bar:GetCenter()
    if not x or not y then return end
    local scale = bar:GetEffectiveScale() / UIParent:GetEffectiveScale()
    MiniStatsDB.position = { x = x * scale, y = y * scale }
    RestorePosition()
end
local function Layout()
    local source = MiniExpBarFrame or Minimap
    if not source then return end
    local width = source:GetWidth() * source:GetEffectiveScale() / bar:GetEffectiveScale()
    if width <= 0 then return end
    bar:SetWidth(width)
    -- Keep both groups at the outer edges; shrink text only if space runs out.
    local textWidths, totalTextWidth = {}, 0
    for i, cell in ipairs(cells) do
        cell.text:SetScale(1)
        textWidths[i] = math.max(1, cell.text:GetStringWidth())
        totalTextWidth = totalTextWidth + textWidths[i]
    end
    local available = math.max(2, width - 18 * #cells - 8)
    local textScale = math.min(1, available / totalTextWidth)
    for i, cell in ipairs(cells) do
        cell:SetWidth(18 + textWidths[i] * textScale)
        cell:ClearAllPoints()
        if i == 1 then
            cell:SetPoint("LEFT", bar, "LEFT", 0, 0)
        else
            cell:SetPoint("RIGHT", bar, "RIGHT", 0, 0)
        end
        cell.text:SetScale(textScale)
    end
end
local function UpdateStats()
    if not initialized then return end
    local money = GetMoney() or 0
    cells[1].text:SetText(string.format("|cffffd700%dg|r |cffc7c7cf%ds|r |cffeda55f%dc|r",
        math.floor(money / 10000), math.floor(money / 100) % 100, money % 100))
    freeSlots, totalSlots = 0, 0
    local getSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
    local getFree = C_Container and C_Container.GetContainerNumFreeSlots or GetContainerNumFreeSlots
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        totalSlots = totalSlots + (getSlots(bag) or 0)
        freeSlots = freeSlots + (getFree(bag) or 0)
    end
    cells[2].text:SetText(string.format("%d (%d)", freeSlots, totalSlots))
    cells[2].text:SetTextColor(1, freeSlots == 0 and 0.25 or 1, freeSlots == 0 and 0.2 or 1)
    Layout()
end
local function ShowTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
    if self.index == 1 then
        GameTooltip:AddLine("Geld", 1, 0.82, 0)
        local money = GetMoney() or 0
        GameTooltip:AddLine(string.format("%d Gold, %d Silber, %d Kupfer", math.floor(money / 10000), math.floor(money / 100) % 100, money % 100), 1, 1, 1)
    else
        GameTooltip:AddLine("Taschenplätze", 1, 0.82, 0)
        GameTooltip:AddLine(string.format("%d frei / %d insgesamt · %d belegt", freeSlots, totalSlots, totalSlots - freeSlots), 1, 1, 1)
        GameTooltip:AddLine("Rucksack und angelegte Taschen (inkl. Spezialtaschen)", 0.7, 0.7, 0.7)
    end
    GameTooltip:AddLine("Linke Maustaste halten und ziehen zum Verschieben", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end
local function CreateBar()
    MiniStatsDB = type(MiniStatsDB) == "table" and MiniStatsDB or {}
    bar = CreateFrame("Frame", "MiniStatsFrame", UIParent)
    bar:SetSize(140, 20)
    bar:SetFrameStrata("MEDIUM")
    bar:SetMovable(true)
    bar:SetClampedToScreen(true)
    bar:EnableMouse(true)
    bar:RegisterForDrag("LeftButton")
    local function startDrag() GameTooltip:Hide(); bar:StartMoving() end
    local function stopDrag() bar:StopMovingOrSizing(); SavePosition() end
    bar:SetScript("OnDragStart", startDrag)
    bar:SetScript("OnDragStop", stopDrag)
    cells = {}
    local icons = { "Interface\\MoneyFrame\\UI-GoldIcon", "Interface\\Icons\\INV_Misc_Bag_08" }
    for i = 1, 2 do
        local cell = CreateFrame("Frame", nil, bar)
        cell.index = i
        cell:SetHeight(20)
        cell:EnableMouse(true)
        cell:RegisterForDrag("LeftButton")
        cell:SetScript("OnDragStart", startDrag)
        cell:SetScript("OnDragStop", stopDrag)
        cell:SetScript("OnEnter", ShowTooltip)
        cell:SetScript("OnLeave", function() GameTooltip:Hide() end)
        local icon = cell:CreateTexture(nil, "ARTWORK")
        icon:SetSize(14, 14)
        icon:SetPoint("LEFT", 1, 0)
        icon:SetTexture(icons[i])
        if i > 1 then icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
        cell.text = cell:CreateFontString(nil, "OVERLAY")
        cell.text:SetPoint("LEFT", icon, "RIGHT", 3, 0)
        cell.text:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        cell.text:SetShadowColor(0, 0, 0, 1)
        cell.text:SetShadowOffset(1, -1)
        cells[i] = cell
    end
    cells[1].text:SetTextColor(1, 0.82, 0)
    initialized = true
    RestorePosition()
    UpdateStats()
end
local events = CreateFrame("Frame")
for _, event in ipairs({ "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_MONEY", "BAG_UPDATE", "UI_SCALE_CHANGED", "DISPLAY_SIZE_CHANGED" }) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" then
        if name == ADDON_NAME and not initialized then CreateBar() end
        return
    end
    if not initialized then return end
    UpdateStats()
    if event == "PLAYER_ENTERING_WORLD" and not MiniStatsDB.position then RestorePosition() end
end)
local elapsedSinceCheck = 0
events:SetScript("OnUpdate", function(_, elapsed)
    elapsedSinceCheck = elapsedSinceCheck + elapsed
    if elapsedSinceCheck >= 0.5 then
        elapsedSinceCheck = 0
        if initialized then Layout() end
    end
end)
SLASH_MINISTATS1 = "/ministats"
SlashCmdList.MINISTATS = function(message)
    if not initialized then return end
    if (message or ""):lower():match("^%s*reset%s*$") then
        MiniStatsDB.position = nil
        RestorePosition()
        UpdateStats()
    else
        print("MiniStats: /ministats reset - Position zurücksetzen. Mit gedrückter linker Maustaste verschieben.")
    end
end
