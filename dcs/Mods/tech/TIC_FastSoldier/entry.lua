-- TIC_FastSoldier: DCS soldier and vehicle types that run faster than DCS's own (soldiers 6 m/s; stock 4).
-- DCS's own models on DCS's own chassis; nothing runs unless a mission places them.
-- Every DCS soldier is GT_t.generic_human on the GT_t.CH_t.HUMAN chassis with GT_t.CH_t.HUMAN_ANIMATION, whose walk
-- and run cycles are set by distance (run: 2.3 m a cycle), so a faster soldier strides faster rather than sliding.
-- Laid out as the Currenthill infantry pack does it (CH_USInfantry_M4). A mod's entry.lua has no pcall, error or log.
-- Install: Saved Games\DCS\Mods\tech\TIC_FastSoldier (remove: delete that folder).
declare_plugin("TIC Fast Soldier", {
  installed = true,
  dirName = current_mod_path,
  version = "1.0",
  state = "installed",
  info = _("Troops in Contact: soldiers and vehicles faster than DCS's own"),
})

dofile(current_mod_path .. "/Database/TIC_FastSoldier.lua")
dofile(current_mod_path .. "/Database/TIC_FastVehicles.lua")   -- the fast vehicles

plugin_done()
