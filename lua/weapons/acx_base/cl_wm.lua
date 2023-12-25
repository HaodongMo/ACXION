function SWEP:DrawWorldModel()
    self:TryCreateModel()

    local model_right = self.ModelRightView

    model_right:SetupBones()

    self:UpdateModelBodygroups(model_right)

    local bone_name_right = "ValveBiped.Bip01_R_Hand"
    local boneid = self:GetOwner():LookupBone(bone_name_right)
    local pos, ang = self:GetOwner():GetBonePosition(boneid)

    local wpos, wang = self:GetCustomWorldPos(pos, ang)

    model_right:SetRenderOrigin(wpos)
    model_right:SetRenderAngles(wang)
    model_right:SetPos(wpos)
    model_right:SetAngles(wang)

    model_right:DrawModel()

    local model_left = self.ModelLeftView

    self:UpdateModelBodygroups(model_left, true)

    model_left:SetupBones()

    local bone_name_left = "ValveBiped.Bip01_L_Hand"

    boneid = self:GetOwner():LookupBone(bone_name_left)
    pos, ang = self:GetOwner():GetBonePosition(boneid)

    local lwpos, lwang = self:GetCustomWorldPos(pos, ang, true)

    model_left:SetRenderOrigin(lwpos)
    model_left:SetRenderAngles(lwang)
    model_left:SetPos(lwpos)
    model_left:SetAngles(lwang)

    if self:GetAkimbo() then
        model_left:DrawModel()
    end
end

function SWEP:GetCustomWorldPos(pos, ang, left)
    left = left or false

    local up, right, forward = ang:Up(), ang:Right(), ang:Forward()
    // if left then right = right * -1 end

    if left then
        pos = pos + right * self.ModelOffsetWorld.x
        pos = pos + forward * self.ModelOffsetWorld.y
        pos = pos - up * self.ModelOffsetWorld.z

        ang:RotateAroundAxis(up, self.ModelAngleWorld.x)
        ang:RotateAroundAxis(right, self.ModelAngleWorld.y)
        ang:RotateAroundAxis(forward, self.ModelAngleWorld.z + 180)
    else
        pos = pos + right * self.ModelOffsetWorld.x
        pos = pos + forward * self.ModelOffsetWorld.y
        pos = pos + up * self.ModelOffsetWorld.z
        
        ang:RotateAroundAxis(up, self.ModelAngleWorld.x)
        ang:RotateAroundAxis(right, self.ModelAngleWorld.y)
        ang:RotateAroundAxis(forward, self.ModelAngleWorld.z)
    end

    return pos, ang
end