SWEP.ModelRightView = nil
SWEP.ModelLeftView = nil

function SWEP:TryCreateModel()
    if self.ModelRightView then return end
    if self.ModelLeftView then return end

    self:CreateCustomModel()
end

function SWEP:CreateCustomModel()
    local newmodel_left = ClientsideModel(self.Model)
    local newmodel_right = ClientsideModel(self.Model)

    if not IsValid(newmodel_left) or not IsValid(newmodel_right) then
        return
    end

    newmodel_left:SetNoDraw(true)
    newmodel_right:SetNoDraw(true)

    newmodel_left:SetBodyGroups(self.Bodygroups)
    newmodel_right:SetBodyGroups(self.Bodygroups)

    self.ModelLeftView = newmodel_left
    self.ModelRightView = newmodel_right

    table.insert(ACX.CSModelPile, {Model = newmodel_left, Weapon = self})
    table.insert(ACX.CSModelPile, {Model = newmodel_right, Weapon = self})
end

function SWEP:UpdateModelBodygroups(mdl, left)
    mdl:SetBodyGroups(self.Bodygroups)

    local bbg = self.BulletBodygroups

    if bbg then
        local amt = self:Clip1()
        if left then
            amt = self:Clip2()
        end

        for c, bgs in pairs(bbg) do
            if amt < c then
                mdl:SetBodygroup(bgs[1], bgs[2])
                break
            end
        end
    end
end

function SWEP:KillCustomModels()
    if IsValid(self.ModelLeftView) then
        SafeRemoveEntity(self.ModelLeftView)
        self.ModelLeftView = nil
    end

    if IsValid(self.ModelRightView) then
        SafeRemoveEntity(self.ModelRightView)
        self.ModelRightView = nil
    end
end