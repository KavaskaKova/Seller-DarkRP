AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/Humans/Group02/male_02.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_IDLE)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:AcceptInput(name, activator, caller)
    if name == "Use" and activator:IsPlayer() then
        net.Start("OpenWeaponShopMenu")
        net.WriteEntity(self)
        net.Send(activator)
    end
end

util.AddNetworkString("OpenWeaponShopMenu")
util.AddNetworkString("BuyShopItem")

net.Receive("BuyShopItem", function(len, ply)
    local ent = net.ReadEntity()
    local itemID = net.ReadInt(16)
    local item = ent.ShopItems[itemID]

    if not item or ply:GetPos():DistToSqr(ent:GetPos()) > 10000 then return end

    --проверка наличия денег в профе DarkRP
    if ply:canAfford(item.price) then
        ply:addMoney(-item.price)
        ply:Give(item.class)
        DarkRP.notify(ply, 0, 4, "Вы купили " .. item.name .. " за " .. DarkRP.formatMoney(item.price))
    else
        DarkRP.notify(ply, 1, 4, "У вас недостаточно денег!")
    end
end)


-- Код написал Kavaska (Discord: kova.cpp)