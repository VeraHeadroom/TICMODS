-- TIC_FastTruck / TIC_FastHummer / TIC_FastHummerMG: DCS's own truck and Humvee models on DCS's own chassis, with
-- stronger acceleration and a higher top speed (stock: M818 20.8 m/s, HMMWV 31.4 m/s, both 2.93 m/s2).
-- TIC_FastHummerMG has DCS's own M2 (GT_t.LN_t.machinegun_12_7_M2) on the roof (8 Nov 2026, the owner: smooth AND
-- firing, so pilots see the ARMA gunner's tracers; the stock armed Humvee was too slow to keep up and went choppy).
-- Laid out as the Humvee Pack mod defines its trucks and its M2 Humvee.
local function vehicle(name, display, chassis, shape, shape_dstr, top, accel, category, attribute, armed)
  GT = {};
  GT_t.ws = 0;
  set_recursive_metatable(GT, GT_t.generic_wheel_vehicle);
  set_recursive_metatable(GT.chassis, GT_t.CH_t[chassis]);
  GT.chassis.max_road_velocity = top;   -- m/s
  GT.chassis.max_acceleration = accel;  -- m/s2: about 2 s to road speed instead of ~6
  GT.chassis.life = 3;

  GT.visual.shape = shape;              -- DCS's own models (Bazar\World\Shapes)
  GT.visual.shape_dstr = shape_dstr;
  GT.swing_on_run = false;

  GT.sensor = {};
  set_recursive_metatable(GT.sensor, GT_t.SN_visual);
  GT.sensor.height = 2.0;

  if armed then
    -- one weapon station: the roof M2, turning all round, as DCS's own armed Humvee
    GT.WS = {};
    GT.WS.maxTargetDetectionRange = 2000;
    local ws = GT_t.inc_ws();
    GT.WS[ws] = {};
    GT.WS[ws].center = "CENTER_TOWER";
    GT.WS[ws].angles = { {math.rad(180), math.rad(-180), math.rad(-10), math.rad(50)} };
    GT.WS[ws].drawArgument1 = 0;
    GT.WS[ws].drawArgument2 = 1;
    GT.WS[ws].omegaY = math.rad(60);
    GT.WS[ws].omegaZ = math.rad(30);
    GT.WS[ws].reference_angle_Y = 0;
    local ln = add_launcher(GT.WS[ws], GT_t.LN_t.machinegun_12_7_M2);
    for i = 1, 5 do
      ln.PL[i].ammo_capacity = 1000;
      ln.PL[i].portionAmmoCapacity = 200;
      ln.PL[i].reload_time = 25;
    end
    ln.BR[1].connector_name = "POINT_GUN";      -- the stock hmmwv_m1043 model's muzzle point
  end

  GT.Name = name;
  GT.DisplayName = _(display);
  GT.DisplayNameShort = _("TIC fast");
  GT.Rate = 1;
  GT.Crew = 1;
  GT.EPLRS = false;
  GT.DetectionRange = 0;
  GT.ThreatRange = 0;
  GT.attribute = armed and {wsType_Ground, wsType_Tank, wsType_Gun, WSTYPE_PLACEHOLDER, attribute}
                      or {wsType_Ground, wsType_Tank, wsType_NoWeapon, WSTYPE_PLACEHOLDER, attribute};
  GT.category = category;
  GT.Countries = {"CJTF Blue", "CJTF Red", "USA", "Russia", "Insurgents"};

  add_surface_unit(GT)
end

vehicle("TIC_FastTruck", "TIC fast truck M818 (stand-in)", "M818", "m-818", "m-818_p_1", 30, 8, "Unarmed", "Trucks")
vehicle("TIC_FastHummer", "TIC fast Humvee (stand-in)", "HMMWV", "hmmwv_m1025", "hmmwv_m1025_p_1", 35, 8, "Unarmed", "Cars")
vehicle("TIC_FastHummerMG", "TIC fast armed Humvee (stand-in)", "HMMWV", "hmmwv_m1043", "hmmwv_m1043_p_1", 35, 8, "Armor", "APC", true)
