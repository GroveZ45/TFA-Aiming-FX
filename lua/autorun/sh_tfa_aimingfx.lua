if CLIENT then
	local tfa_aimingfx_enabled = CreateClientConVar("cl_tfa_aimingfx_enabled", 1)
	local tfa_aimingfx_vignette_enabled = CreateClientConVar("cl_tfa_aimingfx_vignette_enabled", 1)
	local tfa_aimingfx_vignette_intensity_initially_multiplier = CreateClientConVar("cl_tfa_aimingfx_vignette_intensity_initially_multiplier", 0.75)
	local tfa_aimingfx_vignette_intensity_sighted_multiplier = CreateClientConVar("cl_tfa_aimingfx_vignette_intensity_sighted_multiplier", 0.6)
	local tfa_aimingfx_ca_enabled = CreateClientConVar("cl_tfa_aimingfx_ca_enabled", 1)
	local tfa_aimingfx_ca_intensity_initially_multiplier = CreateClientConVar("cl_tfa_aimingfx_ca_intensity_initially_multiplier", 0)
	local tfa_aimingfx_ca_intensity_sighted_multiplier = CreateClientConVar("cl_tfa_aimingfx_ca_intensity_sighted_multiplier", 5)

	--Some convars may sounds weird due to my horrible language barrier but I don't give a single fuck about that, It works at least

	local addmat_r = Material("aimingfx/ca/add_r")
	local addmat_g = Material("aimingfx/ca/add_g")
	local addmat_b = Material("aimingfx/ca/add_b")
	local vgbm = Material("vgui/black")

	local function TFA_AimingFX_DrawChroma(rx, gx, bx, ry, gy, by)
		render.UpdateScreenEffectTexture()

		addmat_r:SetTexture("$basetexture", render.GetScreenEffectTexture())
		addmat_g:SetTexture("$basetexture", render.GetScreenEffectTexture())
		addmat_b:SetTexture("$basetexture", render.GetScreenEffectTexture())

		render.SetMaterial(vgbm)
		render.DrawScreenQuad()

		render.SetMaterial(addmat_r)
		render.DrawScreenQuadEx(-rx / 2, -ry / 2, ScrW() + rx, ScrH() + ry)

		render.SetMaterial(addmat_g)
		render.DrawScreenQuadEx(-gx / 2, -gy / 2, ScrW() + gx, ScrH() + gy)

		render.SetMaterial(addmat_b)
		render.DrawScreenQuadEx(-bx / 2, -by / 2, ScrW() + bx, ScrH() + by)
	end

	--https://sun9-87.userapi.com/impg/eCD-9b7mayfh2MTgPQae32CPIwETyRscE0bpug/WISKuiyr1lM.jpg?size=604x601&quality=96&sign=317145f427668884d7f728a4ba59c70d&type=album

	hook.Add("RenderScreenspaceEffects", "TFA_AimingFX", function()
		local ply = LocalPlayer()
		local wep = ply:GetActiveWeapon()

		if not tfa_aimingfx_enabled:GetBool() then return end
		if ply:IsNPC() then return end

		local ADSProgress = wep.IronSightsProgress or 0
		local VignetteTexture = surface.GetTextureID("aimingfx/vignette/vignette")

		local AimingFXVignetteMultiplier = tfa_aimingfx_vignette_intensity_initially_multiplier:GetFloat() + (ADSProgress * (-tfa_aimingfx_vignette_intensity_sighted_multiplier:GetFloat() * tfa_aimingfx_vignette_intensity_initially_multiplier:GetFloat())) -- tfa_aimingfx_vignette_intensity_initially_multiplier:GetFloat() + (ADSProgress * -tfa_aimingfx_vignette_intensity_sighted_multiplier:GetFloat())
		local AimingFXCAMultiplier = tfa_aimingfx_ca_intensity_initially_multiplier:GetFloat() + (ADSProgress * tfa_aimingfx_ca_intensity_sighted_multiplier:GetFloat())

		surface.SetTexture(VignetteTexture)
		surface.SetDrawColor(255, 255, 255, 255)

		if tfa_aimingfx_vignette_enabled:GetBool() then
			surface.DrawTexturedRect(0 - (ScrW() * AimingFXVignetteMultiplier), 0 - (ScrH() * AimingFXVignetteMultiplier), ScrW() * (1 + 2 * AimingFXVignetteMultiplier), ScrH() * (1 + 2 * AimingFXVignetteMultiplier))
		end

		if tfa_aimingfx_ca_enabled:GetBool() then
			TFA_AimingFX_DrawChroma(8 * AimingFXCAMultiplier, 4 * AimingFXCAMultiplier, 0 * AimingFXCAMultiplier, 4 * AimingFXCAMultiplier, 2 * AimingFXCAMultiplier, 0 * AimingFXCAMultiplier)
		end
	end)
end