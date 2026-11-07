-- TIC_FastTruck / TIC_FastHummer / TIC_FastHummerMG: DCS's own truck and Humvee models on DCS's own chassis, with
-- stronger acceleration and a higher top speed (stock: M818 20.8 m/s, HMMWV 31.4 m/s, both 2.93 m/s2). Unarmed.
-- Laid out as the Humvee Pack mod defines its trucks.
local function vehicle(name, display, chassis, shape, shape_dstr, top, accel, category, attribute)
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

  GT.Name = name;
  GT.DisplayName = _(display);
  GT.DisplayNameShort = _("TIC fast");
  GT.Rate = 1;
  GT.Crew = 1;
  GT.EPLRS = false;
  GT.DetectionRange = 0;
  GT.ThreatRange = 0;
  GT.attribute = {wsType_Ground, wsType_Tank, wsType_NoWeapon, WSTYPE_PLACEHOLDER, attribute};
  GT.category = category;
  GT.Countries = {"CJTF Blue", "CJTF Red", "USA", "Russia", "Insurgents"};

  add_surface_unit(GT)
end

vehicle("TIC_FastTruck", "TIC fast truck M818 (stand-in)", "M818", "m-818", "m-818_p_1", 30, 8, "Unarmed", "Trucks")
vehicle("TIC_FastHummer", "TIC fast Humvee (stand-in)", "HMMWV", "hmmwv_m1025", "hmmwv_m1025_p_1", 35, 8, "Unarmed", "Cars")
vehicle("TIC_FastHummerMG", "TIC fast armed Humvee (stand-in)", "HMMWV", "hmmwv_m1043", "hmmwv_m1043_p_1", 35, 8, "Unarmed", "Cars")
