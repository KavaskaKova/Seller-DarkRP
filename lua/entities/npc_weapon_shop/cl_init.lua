include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

net.Receive("OpenWeaponShopMenu", function()
    local npc = net.ReadEntity()
    
    --основное окно
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 500)
    frame:SetTitle("Магазин оружия")
    frame:Center()
    frame:MakePopup()

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)

    for k, item in pairs(npc.ShopItems) do
        local panel = scroll:Add("DPanel")
        panel:Dock(TOP)
        panel:SetHeight(80)
        panel:DockMargin(5, 5, 5, 5)

        local icon = vgui.Create("SpawnIcon", panel)
        icon:SetSize(64, 64)
        icon:SetPos(5, 8)
        icon:SetModel(item.model)

        local label = vgui.Create("DLabel", panel)
        label:SetText(item.name .. "\nЦена: " .. item.price .. "$")
        label:SetPos(80, 20)
        label:SetSize(200, 40)
        label:SetDark(true)

        local buyBtn = vgui.Create("DButton", panel)
        buyBtn:SetText("Купить")
        buyBtn:SetSize(80, 30)
        buyBtn:SetPos(300, 25)
        buyBtn.DoClick = function()
            net.Start("BuyShopItem")
            net.WriteEntity(npc)
            net.WriteInt(k, 16)
            net.SendToServer()
        end
    end
end)


-- Код написал Kavaska (Discord: kova.cpp)