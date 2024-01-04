SWEP.ModelRightView = nil
SWEP.ModelLeftView = nil

SWEP.ModelRightWorld = nil
SWEP.ModelLeftWorld = nil

function SWEP:NeedsToCreateWorldModels()
    return self.Model != self.WorldModel
end

function SWEP:TryCreateModel()
    if not IsValid(self.ModelRightView) then
        self:CreateCustomModel(false)
    end

    if self:GetAkimbo() and not IsValid(self.ModelLeftView) then
        self:CreateCustomModel(true)
    end

    if self:NeedsToCreateWorldModels() then
        if not IsValid(self.ModelRightWorld) then
            self:CreateCustomModel(false, true)
        end

        if self:GetAkimbo() and not IsValid(self.ModelLeftWorld) then
            self:CreateCustomModel(true, true)
        end
    end
end

function SWEP:CreateCustomModel(left, world)
    world = world or false
    local model = self.Model
    if world then model = self.WorldModel end
    local newmodel = ClientsideModel(model)
    if not IsValid(newmodel) then return end
    newmodel:SetNoDraw(true)
    newmodel:SetBodyGroups(self.Bodygroups)

    if world then
        if left then
            self.ModelLeftWorld = newmodel
        else
            self.ModelRightWorld = newmodel
        end
    else
        if left then
            self.ModelLeftView = newmodel
        else
            self.ModelRightView = newmodel
        end
    end

    table.insert(ACX.CSModelPile, {
        Model = newmodel,
        Weapon = self
    })
end

function SWEP:UpdateModelBodygroups(mdl, left)
    if not IsValid(mdl) then return end

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

    if IsValid(self.ModelLeftWorld) then
        SafeRemoveEntity(self.ModelLeftWorld)
        self.ModelLeftWorld = nil
    end

    if IsValid(self.ModelRightWorld) then
        SafeRemoveEntity(self.ModelRightWorld)
        self.ModelRightWorld = nil
    end
end