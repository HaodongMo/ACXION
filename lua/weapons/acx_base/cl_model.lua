SWEP.ModelRightView = nil
SWEP.ModelLeftView = nil

function SWEP:TryCreateModel()
    if not IsValid(self.ModelRightView) then
        self:CreateCustomModel()
    end

    if self:GetAkimbo() and not IsValid(self.ModelLeftView) then
        self:CreateCustomModel(true)
    end
end

function SWEP:CreateCustomModel(left)
    local newmodel = ClientsideModel(self.Model)
    if not IsValid(newmodel) then return end
    newmodel:SetNoDraw(true)
    newmodel:SetBodyGroups(self.Bodygroups)

    if left then
        self.ModelLeftView = newmodel
    else
        self.ModelRightView = newmodel
    end

    table.insert(ACX.CSModelPile, {
        Model = newmodel,
        Weapon = self
    })
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
            if not isnumber(c) then continue end

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