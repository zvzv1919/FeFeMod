local assets =
{
	Asset( "ANIM", "anim/fefe.zip" ),
	Asset( "ANIM", "anim/ghost_fefe_build.zip" ),
}

local skins =
{
	normal_skin = "fefe",
	ghost_skin = "ghost_fefe_build",
}

return CreatePrefabSkin("fefe_none",
{
	base_prefab = "fefe",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"FEFE", "CHARACTER", "BASE"},
	build_name_override = "fefe",
	rarity = "Character",
})