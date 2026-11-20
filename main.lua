-- ==========================================
-- 1. ระบบตรวจสอบคีย์ (ดึงจาก key.txt บน GitHub)
-- ==========================================
local KEY_URL = "https://raw.githubusercontent.com/mkkouh166-cell/DX/main/key.txt"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end

local function getCamera()
	return workspace.CurrentCamera
end

local function getGuiParent()
	local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
	if pg then
		return pg
	end
	local ok, hui = pcall(function()
		return gethui and gethui()
	end)
	if ok and hui then
		return hui
	end
	return game:GetService("CoreGui")
end

local function fetchValidKey()
	local ok, result = pcall(function()
		return game:HttpGet(KEY_URL)
	end)
	if ok and type(result) == "string" then
		return result:gsub("^%s*(.-)%s*$", "%1")
	end
	return nil
end

local function waitForValidKey()
	local validKey = fetchValidKey()
	if not validKey or validKey == "" then
		warn("[DX Key System] โหลดไฟล์ key.txt ไม่สำเร็จ")
		return false
	end

	local verified = false
	local parentGui = getGuiParent()

	pcall(function()
		local oldKeyGui = parentGui:FindFirstChild("DXKeySystemGui")
		if oldKeyGui then
			oldKeyGui:Destroy()
		end
	end)

	local keyGui = Instance.new("ScreenGui")
	keyGui.Name = "DXKeySystemGui"
	keyGui.ResetOnSpawn = false
	pcall(function() keyGui.IgnoreGuiInset = true end)
	pcall(function() keyGui.DisplayOrder = 1000000 end)
	keyGui.Parent = parentGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 270, 0, 145)
	frame.Position = UDim2.new(0.5, -135, 0.5, -72)
	frame.BackgroundColor3 = Color3.fromRGB(12, 26, 48)
	frame.BorderSizePixel = 0
	frame.Parent = keyGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 26)
	title.Position = UDim2.new(0, 10, 0, 8)
	title.BackgroundTransparency = 1
	title.Text = "DX KEY SYSTEM"
	title.TextColor3 = Color3.fromRGB(0, 212, 255)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 13
	title.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -24, 0, 32)
	box.Position = UDim2.new(0, 12, 0, 38)
	box.PlaceholderText = "กรอกคีย์ที่นี่..."
	box.Text = ""
	box.ClearTextOnFocus = false
	box.BackgroundColor3 = Color3.fromRGB(16, 35, 64)
	box.TextColor3 = Color3.fromRGB(238, 248, 255)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 11
	box.Parent = frame

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = box

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -24, 0, 32)
	btn.Position = UDim2.new(0, 12, 0, 76)
	btn.Text = "ยืนยันคีย์"
	btn.BackgroundColor3 = Color3.fromRGB(0, 140, 235)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(1, -24, 0, 20)
	statusLbl.Position = UDim2.new(0, 12, 0, 114)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = ""
	statusLbl.TextColor3 = Color3.fromRGB(255, 85, 95)
	statusLbl.Font = Enum.Font.GothamBold
	statusLbl.TextSize = 10
	statusLbl.Parent = frame

	btn.MouseButton1Click:Connect(function()
		local latestKey = fetchValidKey() or validKey
		local inputKey = box.Text:gsub("^%s*(.-)%s*$", "%1")
		if inputKey ~= "" and inputKey == latestKey then
			verified = true
			keyGui:Destroy()
		else
			statusLbl.Text = "คีย์ไม่ถูกต้อง"
		end
	end)

	while not verified do
		task.wait(0.1)
	end

	return true
end

if not waitForValidKey() then
	return
end

-- ==========================================
-- 2. DX Aimbot Menu (Cyber Blue Theme)
-- ==========================================
local ESPColorPresets = {
	{
		key = "Cyan",
		nameTH = "ฟ้าไซเบอร์",
		nameEN = "Cyber Cyan",
		visible = Color3.fromRGB(0, 212, 255),
		hidden = Color3.fromRGB(55, 130, 235)
	},
	{
		key = "Red",
		nameTH = "แดงสด",
		nameEN = "Crimson Red",
		visible = Color3.fromRGB(255, 55, 75),
		hidden = Color3.fromRGB(165, 35, 50)
	},
	{
		key = "Green",
		nameTH = "เขียวสด",
		nameEN = "Neon Green",
		visible = Color3.fromRGB(45, 255, 125),
		hidden = Color3.fromRGB(25, 155, 80)
	},
	{
		key = "Purple",
		nameTH = "ม่วงนีออน",
		nameEN = "Neon Purple",
		visible = Color3.fromRGB(185, 85, 255),
		hidden = Color3.fromRGB(115, 50, 180)
	},
	{
		key = "Orange",
		nameTH = "ส้มทอง",
		nameEN = "Amber Orange",
		visible = Color3.fromRGB(255, 155, 35),
		hidden = Color3.fromRGB(175, 100, 20)
	},
	{
		key = "Pink",
		nameTH = "ชมพูสด",
		nameEN = "Hot Pink",
		visible = Color3.fromRGB(255, 80, 180),
		hidden = Color3.fromRGB(175, 45, 120)
	}
}

local Config = {
	AimbotEnabled = false,
	FOVEnabled = false,
	FOVDisplayMode = "Center", -- "Center" หรือ "Hidden"
	FOVRadius = 170,
	BoxESPEnabled = false,
	TracerEnabled = false,
	NameESPEnabled = false,
	HPBarEnabled = false,
	TracerOrigin = "Bottom", -- "Top", "Center", "Bottom"
	ESPColorIndex = 1,
	SpeedEnabled = false,
	WalkSpeedValue = 16,
	InfiniteJumpEnabled = false,
	InvisibleEnabled = false,
	TeamCheck = true,
	TargetPartPriority = { "Head", "HumanoidRootPart", "UpperTorso", "Torso" },
	AimSmoothness = 0.72,
	Lang = "TH",
	BaseWidth = 340,
	BaseHeight = 290
}

local Theme = {
	BgMain = Color3.fromRGB(8, 16, 30),
	BgTop = Color3.fromRGB(12, 26, 48),
	BgPanel = Color3.fromRGB(11, 22, 40),
	BgRow = Color3.fromRGB(15, 31, 56),
	BgBtnIdle = Color3.fromRGB(16, 35, 64),
	AccentBright = Color3.fromRGB(0, 212, 255),
	AccentMid = Color3.fromRGB(0, 140, 235),
	AccentDeep = Color3.fromRGB(18, 76, 148),
	BorderBlue = Color3.fromRGB(36, 118, 196),
	SwitchOn = Color3.fromRGB(0, 195, 255),
	SwitchOff = Color3.fromRGB(42, 62, 92),
	TextWhite = Color3.fromRGB(238, 248, 255),
	TextMuted = Color3.fromRGB(142, 182, 224)
}

local Texts = {
	TH = {
		title = "DX เมนูควบคุม",
		menuBtn = "DX",
		tabAim = "ล็อก",
		tabEsp = "มอง",
		tabMove = "ตัวละคร",
		tabCfg = "ภาษา",
		aimbotSwitch = "โหมด Aimbot",
		fovSwitch = "ใช้งานวง FOV",
		fovModeCenter = "แสดง FOV: กลางจอ",
		fovModeHidden = "แสดง FOV: ร่องหน",
		fovSliderPrefix = "ขนาดวง FOV",
		box = "มองบล็อก",
		tracer = "มองเส้น",
		tracerPosTop = "ข้างบน",
		tracerPosCenter = "ตรงกลาง",
		tracerPosBottom = "ข้างล่าง",
		name = "มองชื่อ",
		hpBar = "แถบเลือด",
		espColorLabel = "สีมอง",
		speedSwitch = "โหมดวิ่งเร็ว",
		speedSliderPrefix = "ความเร็ววิ่ง",
		infJumpSwitch = "กระโดดไม่จำกัด",
		invisSwitch = "ตัวละครล่องหน",
		langHeading = "เลือกภาษา / Select Language",
		langLabel = "ภาษา",
		langTH = "ภาษาไทย",
		langEN = "English"
	},
	EN = {
		title = "DX CONTROL",
		menuBtn = "DX",
		tabAim = "AIM",
		tabEsp = "ESP",
		tabMove = "PLAYER",
		tabCfg = "LANGUAGE",
		aimbotSwitch = "Aimbot Mode",
		fovSwitch = "Enable FOV",
		fovModeCenter = "FOV View: Center",
		fovModeHidden = "FOV View: Hidden",
		fovSliderPrefix = "FOV Size",
		box = "Box ESP",
		tracer = "Tracer",
		tracerPosTop = "Top",
		tracerPosCenter = "Center",
		tracerPosBottom = "Bottom",
		name = "Name ESP",
		hpBar = "HP Bar",
		espColorLabel = "ESP Color",
		speedSwitch = "Speed Mode",
		speedSliderPrefix = "Walk Speed",
		infJumpSwitch = "Infinite Jump",
		invisSwitch = "Invisible Character",
		langHeading = "เลือกภาษา / Select Language",
		langLabel = "Language",
		langTH = "ภาษาไทย",
		langEN = "English"
	}
}

local function tr(key)
	local dict = Texts[Config.Lang] or Texts.TH
	return dict[key] or key
end

local function getCurrentESPColorPreset()
	local preset = ESPColorPresets[Config.ESPColorIndex]
	if not preset then
		Config.ESPColorIndex = 1
		preset = ESPColorPresets[1]
	end
	return preset
end

local function getFOVCenter()
	local cam = getCamera()
	if cam then
		return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
	end
	return Vector2.new(0, 0)
end

local function safeCorner(obj, radiusPx)
	pcall(function()
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, radiusPx)
		c.Parent = obj
	end)
end

local function safeStroke(obj, color, thickness)
	local stroke = nil
	pcall(function()
		stroke = Instance.new("UIStroke")
		stroke.Color = color
		stroke.Thickness = thickness
		stroke.Parent = obj
	end)
	return stroke
end

local targetParent = getGuiParent()

pcall(function()
	local old = targetParent:FindFirstChild("DXTargetMenuGui")
	if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DXTargetMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.IgnoreGuiInset = true end)
pcall(function() ScreenGui.DisplayOrder = 999999 end)
ScreenGui.Parent = targetParent

-- วง FOV บนหน้าจอ
local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "DXFOVCircle"
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, Config.FOVRadius * 2, 0, Config.FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.ZIndex = 2
FOVFrame.Parent = ScreenGui
safeCorner(FOVFrame, 999)
local FOVStroke = safeStroke(FOVFrame, Theme.AccentBright, 1.5)

-- ปุ่มลอยเปิด/ปิดเมนู DX
local OpenToggleBtn = Instance.new("TextButton")
OpenToggleBtn.Name = "DXOpenToggleBtn"
OpenToggleBtn.Size = UDim2.new(0, 72, 0, 32)
OpenToggleBtn.Position = UDim2.new(0, 12, 0.28, 0)
OpenToggleBtn.BackgroundColor3 = Theme.BgTop
OpenToggleBtn.Text = tr("menuBtn")
OpenToggleBtn.TextColor3 = Theme.AccentBright
OpenToggleBtn.Font = Enum.Font.GothamBlack
OpenToggleBtn.TextSize = 14
OpenToggleBtn.Active = true
OpenToggleBtn.Draggable = true
OpenToggleBtn.Visible = true
OpenToggleBtn.ZIndex = 10
OpenToggleBtn.Parent = ScreenGui
safeCorner(OpenToggleBtn, 9)
safeStroke(OpenToggleBtn, Theme.AccentBright, 1.5)

-- หน้าต่างหลัก DX
local MainFrame = Instance.new("Frame")
MainFrame.Name = "DXMainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, Config.BaseWidth, 0, Config.BaseHeight)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Theme.BgMain
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui
safeCorner(MainFrame, 12)
safeStroke(MainFrame, Theme.BorderBlue, 1.5)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Theme.BgTop
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
safeCorner(TopBar, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = tr("title")
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextColor3 = Theme.AccentBright
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 13
TitleLabel.Parent = TopBar

local BodyFrame = Instance.new("Frame")
BodyFrame.Size = UDim2.new(1, 0, 1, -36)
BodyFrame.Position = UDim2.new(0, 0, 0, 36)
BodyFrame.BackgroundTransparency = 1
BodyFrame.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 92, 1, -10)
Sidebar.Position = UDim2.new(0, 6, 0, 5)
Sidebar.BackgroundColor3 = Theme.BgPanel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = BodyFrame
safeCorner(Sidebar, 9)
safeStroke(Sidebar, Color3.fromRGB(24, 72, 128), 1)

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -108, 1, -10)
RightPanel.Position = UDim2.new(0, 102, 0, 5)
RightPanel.BackgroundColor3 = Theme.BgPanel
RightPanel.BorderSizePixel = 0
RightPanel.Parent = BodyFrame
safeCorner(RightPanel, 9)
safeStroke(RightPanel, Color3.fromRGB(24, 72, 128), 1)

OpenToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local Pages = {
	Aim = Instance.new("Frame"),
	Esp = Instance.new("Frame"),
	Move = Instance.new("Frame"),
	Cfg = Instance.new("Frame")
}

local DropdownUpdaters = {}

local function closeAllDropdowns(exceptFn)
	for _, fn in ipairs(DropdownUpdaters) do
		if fn ~= exceptFn then
			fn(false)
		end
	end
end

for _, page in pairs(Pages) do
	page.Size = UDim2.new(1, -10, 1, -10)
	page.Position = UDim2.new(0, 5, 0, 5)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = RightPanel
end
Pages.Aim.Visible = true

local TabButtons = {}

local function selectTab(tabName)
	closeAllDropdowns(nil)
	for name, page in pairs(Pages) do
		page.Visible = (name == tabName)
	end
	for name, btn in pairs(TabButtons) do
		local selected = (name == tabName)
		btn.BackgroundColor3 = selected and Theme.AccentMid or Theme.BgBtnIdle
		btn.TextColor3 = selected and Theme.TextWhite or Theme.TextMuted
	end
end

local function createTabButton(tabName, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 36)
	btn.Position = UDim2.new(0.06, 0, 0, yPos)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.Parent = Sidebar
	safeCorner(btn, 7)

	btn.MouseButton1Click:Connect(function()
		selectTab(tabName)
	end)

	return btn
end

TabButtons.Aim = createTabButton("Aim", 8)
TabButtons.Esp = createTabButton("Esp", 50)
TabButtons.Move = createTabButton("Move", 92)
TabButtons.Cfg = createTabButton("Cfg", 134)

local SwitchUpdaters = {}
local SelectorUpdaters = {}
local SliderUpdaters = {}

local function refreshAllUI()
	TitleLabel.Text = tr("title")
	OpenToggleBtn.Text = tr("menuBtn")
	TabButtons.Aim.Text = tr("tabAim")
	TabButtons.Esp.Text = tr("tabEsp")
	TabButtons.Move.Text = tr("tabMove")
	TabButtons.Cfg.Text = tr("tabCfg")

	for _, fn in ipairs(SwitchUpdaters) do fn() end
	for _, fn in ipairs(SelectorUpdaters) do fn() end
	for _, fn in ipairs(SliderUpdaters) do fn() end
end

local function addSwitchRow(parent, textKey, yPos, initialState, callback)
	local rowBtn = Instance.new("TextButton")
	rowBtn.Size = UDim2.new(1, 0, 0, 28)
	rowBtn.Position = UDim2.new(0, 0, 0, yPos)
	rowBtn.BackgroundColor3 = Theme.BgRow
	rowBtn.Text = ""
	rowBtn.AutoButtonColor = false
	rowBtn.Parent = parent
	safeCorner(rowBtn, 7)
	local rowStroke = safeStroke(rowBtn, Color3.fromRGB(28, 86, 152), 1)

	local switchTrack = Instance.new("Frame")
	switchTrack.Size = UDim2.new(0, 36, 0, 18)
	switchTrack.Position = UDim2.new(0, 7, 0.5, -9)
	switchTrack.BorderSizePixel = 0
	switchTrack.Parent = rowBtn
	safeCorner(switchTrack, 999)

	local switchKnob = Instance.new("Frame")
	switchKnob.Size = UDim2.new(0, 12, 0, 12)
	switchKnob.BackgroundColor3 = Theme.TextWhite
	switchKnob.BorderSizePixel = 0
	switchKnob.Parent = switchTrack
	safeCorner(switchKnob, 999)

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, -48, 1, 0)
	titleLbl.Position = UDim2.new(0, 44, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.TextXAlignment = Enum.TextXAlignment.Center
	titleLbl.TextColor3 = Theme.TextWhite
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 10
	titleLbl.Parent = rowBtn

	local state = initialState

	local function refreshVisual()
		titleLbl.Text = tr(textKey)
		if state then
			switchTrack.BackgroundColor3 = Theme.SwitchOn
			switchKnob.Position = UDim2.new(1, -15, 0.5, -6)
			if rowStroke then rowStroke.Color = Theme.AccentBright end
		else
			switchTrack.BackgroundColor3 = Theme.SwitchOff
			switchKnob.Position = UDim2.new(0, 3, 0.5, -6)
			if rowStroke then rowStroke.Color = Color3.fromRGB(28, 86, 152) end
		end
	end

	refreshVisual()
	table.insert(SwitchUpdaters, refreshVisual)

	rowBtn.MouseButton1Click:Connect(function()
		state = not state
		refreshVisual()
		callback(state)
	end)
end

local function addDropdownSelectorRow(parent, labelKey, yPos, dropdownYPos, optionsList, getIndexFn, setIndexFn, getOptionTextFn, getSwatchColorFn, zBase)
	local zOrder = zBase or 10
	local isOpen = false

	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 28)
	row.Position = UDim2.new(0, 0, 0, yPos)
	row.BackgroundColor3 = Theme.BgRow
	row.BorderSizePixel = 0
	row.ZIndex = zOrder
	row.Parent = parent
	safeCorner(row, 7)
	safeStroke(row, Color3.fromRGB(28, 86, 152), 1)

	local hasSwatch = type(getSwatchColorFn) == "function"
	local swatch = nil
	if hasSwatch then
		swatch = Instance.new("Frame")
		swatch.Size = UDim2.new(0, 10, 0, 10)
		swatch.Position = UDim2.new(0, 7, 0.5, -5)
		swatch.BorderSizePixel = 0
		swatch.ZIndex = zOrder + 1
		swatch.Parent = row
		safeCorner(swatch, 999)
		safeStroke(swatch, Theme.TextWhite, 1)
	end

	local leftLbl = Instance.new("TextLabel")
	leftLbl.Size = UDim2.new(0, hasSwatch and 58 or 66, 1, 0)
	leftLbl.Position = UDim2.new(0, hasSwatch and 20 or 8, 0, 0)
	leftLbl.BackgroundTransparency = 1
	leftLbl.TextXAlignment = Enum.TextXAlignment.Left
	leftLbl.TextColor3 = Theme.TextWhite
	leftLbl.Font = Enum.Font.GothamBold
	leftLbl.TextSize = 10
	leftLbl.ZIndex = zOrder + 1
	leftLbl.Parent = row

	local triggerBtn = Instance.new("TextButton")
	triggerBtn.Size = UDim2.new(0, 118, 0, 22)
	triggerBtn.Position = UDim2.new(1, -122, 0.5, -11)
	triggerBtn.BackgroundColor3 = Theme.BgBtnIdle
	triggerBtn.Text = ""
	triggerBtn.AutoButtonColor = false
	triggerBtn.ZIndex = zOrder + 1
	triggerBtn.Parent = row
	safeCorner(triggerBtn, 6)
	safeStroke(triggerBtn, Color3.fromRGB(36, 118, 196), 1)

	local valLbl = Instance.new("TextLabel")
	valLbl.Size = UDim2.new(1, -22, 1, 0)
	valLbl.Position = UDim2.new(0, 4, 0, 0)
	valLbl.BackgroundTransparency = 1
	valLbl.TextXAlignment = Enum.TextXAlignment.Left
	valLbl.TextColor3 = Theme.AccentBright
	valLbl.Font = Enum.Font.GothamBold
	valLbl.TextSize = 9
	valLbl.ZIndex = zOrder + 2
	valLbl.Parent = triggerBtn

	local arrowIndicator = Instance.new("TextLabel")
	arrowIndicator.Size = UDim2.new(0, 16, 1, 0)
	arrowIndicator.Position = UDim2.new(1, -17, 0, 0)
	arrowIndicator.BackgroundTransparency = 1
	arrowIndicator.Text = "▼"
	arrowIndicator.TextColor3 = Theme.TextWhite
	arrowIndicator.Font = Enum.Font.GothamBold
	arrowIndicator.TextSize = 9
	arrowIndicator.ZIndex = zOrder + 2
	arrowIndicator.Parent = triggerBtn

	local itemHeight = 18
	local gap = 2
	local menuHeight = 20 + (#optionsList * (itemHeight + gap)) + 4

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Size = UDim2.new(0, 118, 0, menuHeight)
	dropdownFrame.Position = UDim2.new(1, -122, 0, dropdownYPos)
	dropdownFrame.BackgroundColor3 = Theme.BgTop
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.Visible = false
	dropdownFrame.ZIndex = zOrder + 15
	dropdownFrame.Parent = parent
	safeCorner(dropdownFrame, 7)
	safeStroke(dropdownFrame, Theme.AccentBright, 1.2)

	local upCloseBtn = Instance.new("TextButton")
	upCloseBtn.Size = UDim2.new(1, -6, 0, 15)
	upCloseBtn.Position = UDim2.new(0, 3, 0, 3)
	upCloseBtn.BackgroundColor3 = Theme.AccentDeep
	upCloseBtn.Text = "▲"
	upCloseBtn.TextColor3 = Theme.TextWhite
	upCloseBtn.Font = Enum.Font.GothamBold
	upCloseBtn.TextSize = 8
	upCloseBtn.ZIndex = zOrder + 16
	upCloseBtn.Parent = dropdownFrame
	safeCorner(upCloseBtn, 4)

	local optionBtns = {}
	for i, optItem in ipairs(optionsList) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, -6, 0, itemHeight)
		optBtn.Position = UDim2.new(0, 3, 0, 20 + (i - 1) * (itemHeight + gap))
		optBtn.Font = Enum.Font.GothamBold
		optBtn.TextSize = 9
		optBtn.TextColor3 = Theme.TextWhite
		optBtn.ZIndex = zOrder + 16
		optBtn.Parent = dropdownFrame
		safeCorner(optBtn, 4)

		optBtn.MouseButton1Click:Connect(function()
			setIndexFn(i)
			isOpen = false
			dropdownFrame.Visible = false
			arrowIndicator.Text = "▼"
		end)

		table.insert(optionBtns, optBtn)
	end

	local function setOpenState(openVal)
		isOpen = openVal
		dropdownFrame.Visible = isOpen
		arrowIndicator.Text = isOpen and "▲" or "▼"
	end

	local f
