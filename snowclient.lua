-- Подгружаем библиотеку
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Создаем УИ окно
local Window = Library.CreateLib("SnowMurder", "Synapse")

-- Создаем секцию
local Tab = Window:NewTab("Main")

-- Создаем подсекцию
local Section = Tab:NewSection("ESP")

Section:NewToggle("ESP", "ToggleInfo", function(state)
    if state then
        local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwRunService = game:GetService("RunService")

local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwRunService = game:GetService("RunService")

-- Глобальная переменная для включения/выключения скрипта
_G.ESP_Enabled = true

local settings_tbl = {
    ESP_TeamCheck = false,
    Chams = true,
    Chams_White_Color = Color3.fromRGB(255, 255, 255), -- Белый цвет для игроков без оружия
    Chams_Red_Color = Color3.fromRGB(255, 0, 0), -- Красный цвет для игроков с Knife
    Chams_Blue_Color = Color3.fromRGB(0, 0, 255), -- Синий цвет для игроков с Gun
    Chams_Transparency = 0.5 -- Прозрачность (0 = непрозрачно, 1 = полностью прозрачно)
}

-- Функция для уничтожения старой подсветки (Highlight)
function destroy_chams(char)
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Highlight") then
            v:Destroy()
        end
    end
end

-- Функция для проверки, есть ли у игрока предмет "Knife" или "Gun"
function checkWeapon(player)
    local hasKnife = false
    local hasGun = false
    local backpack = player.Backpack:GetChildren()

    -- Проверяем инвентарь
    for _, item in ipairs(backpack) do
        if item.Name == "Knife" then
            hasKnife = true
        elseif item.Name == "Gun" then
            hasGun = true
        end
    end

    -- Проверяем инструмент в руках
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            if tool.Name == "Knife" then
                hasKnife = true
            elseif tool.Name == "Gun" then
                hasGun = true
            end
        end
    end

    return hasKnife, hasGun
end

-- Основной цикл ESP
dwRunService.Heartbeat:Connect(function()
    if _G.ESP_Enabled then
        for _, player in ipairs(dwEntities:GetPlayers()) do
            if player ~= dwLocalPlayer then
                if player.Character and
                   player.Character:FindFirstChild("HumanoidRootPart") and 
                   player.Character:FindFirstChild("Humanoid") and 
                   player.Character:FindFirstChild("Humanoid").Health > 0 then

                    if not settings_tbl.ESP_TeamCheck or player.Team ~= dwLocalPlayer.Team then
                        local char = player.Character
                        local highlightColor = settings_tbl.Chams_White_Color -- По умолчанию белый цвет

                        -- Проверяем наличие Knife и Gun
                        local hasKnife, hasGun = checkWeapon(player)

                        if hasKnife then
                            highlightColor = settings_tbl.Chams_Red_Color
                        elseif hasGun then
                            highlightColor = settings_tbl.Chams_Blue_Color
                        end

                        -- Если включены чамсы (Chams), создаем или обновляем Highlight
                        if settings_tbl.Chams then
                            if not char:FindFirstChild("ChamsHighlight") then
                                local highlight = Instance.new("Highlight", char)
                                highlight.Name = "ChamsHighlight"
                                highlight.FillColor = highlightColor
                                highlight.FillTransparency = settings_tbl.Chams_Transparency
                                highlight.OutlineColor = highlightColor
                                highlight.OutlineTransparency = 0 -- Контур непрозрачный
                            else
                                -- Обновляем существующий Highlight
                                local highlight = char:FindFirstChild("ChamsHighlight")
                                highlight.FillColor = highlightColor
                                highlight.OutlineColor = highlightColor
                            end
                        else
                            destroy_chams(char)
                        end
                    else
                        destroy_chams(player.Character)
                    end
                else
                    destroy_chams(player.Character)
                end
            end
        end
    else
        -- Если скрипт отключен, удаляем все подсветки
        for _, player in ipairs(dwEntities:GetPlayers()) do
            if player ~= dwLocalPlayer and player.Character then
                destroy_chams(player.Character)
            end
        end
    end
end)

    else
-- Скрипт для включения/выключения ESP
_G.ESP_Enabled = not _G.ESP_Enabled

if _G.ESP_Enabled then
    print("ESP включен")
else
    print("ESP выключен")
end

    end
end)


Section:NewToggle("Autofarm", "ToggleInfo", function(state)
    if state then
        local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Настройки
local FlySpeed = 25 -- Скорость полёта

-- Глобальная переменная для управления
_G.FlyEnabled = false

-- Функция для получения всех объектов с именем "Coin_Server"
local function getAllCoins()
    local coins = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
            table.insert(coins, obj)
        end
    end
    return coins
end

-- Основной цикл для полёта
coroutine.wrap(function()
    while true do
        if _G.FlyEnabled then -- Проверяем, включён ли полёт
            local coins = getAllCoins()
            if #coins > 0 then
                for _, coin in ipairs(coins) do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                        local targetPosition = coin.Position
                        local distance = (humanoidRootPart.Position - targetPosition).Magnitude
                        local direction = (targetPosition - humanoidRootPart.Position).Unit

                        -- Движение к монете
                        while distance > 1 do
                            if not _G.FlyEnabled then break end -- Останавливаем, если полёт выключен
                            if not coin.Parent then break end -- Проверяем, существует ли монета
                            humanoidRootPart.CFrame = humanoidRootPart.CFrame + direction * (FlySpeed * RunService.Heartbeat:Wait())
                            distance = (humanoidRootPart.Position - targetPosition).Magnitude
                        end
                    end
                end
            end
        end
        RunService.Heartbeat:Wait() -- Ждём перед следующим обновлением
    end
end)()

-- Скрипт для включения/выключения полёта
_G.FlyEnabled = not _G.FlyEnabled

if _G.FlyEnabled then
    print("Полёт включён")
else
    print("Полёт выключен")
end

    else
        _G.FlyEnabled = not _G.FlyEnabled

if _G.FlyEnabled then
    print("Полёт включён")
else
    print("Полёт выключен")
end

    end
end)
