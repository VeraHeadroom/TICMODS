-- TIC_FastSoldier / TIC_FastSoldierAK: DCS's own soldier models on DCS's soldier chassis, top speed 6 m/s (stock: 4).
-- Two looks: M4 (blue side) and AK (red side), armed with DCS's own rifles (carabine_M4, AK74).
local function soldier(name, display, shape, shape_dstr, rifle)
  GT = {};
  GT.animation = {};

  GT_t.ws = 0;
  set_recursive_metatable(GT, GT_t.generic_human);
  set_recursive_metatable(GT.chassis, GT_t.CH_t.HUMAN);
  set_recursive_metatable(GT.animation, GT_t.CH_t.HUMAN_ANIMATION);
  GT.chassis.max_road_velocity = 6;     -- m/s (stock DCS soldiers: 4)
  GT.chassis.max_acceleration = 4;      -- stock 3: gets up to a sprint a little sooner

  GT.visual.shape = shape;              -- DCS's own model (Bazar\World\Shapes)
  GT.visual.shape_dstr = shape_dstr;

  GT.toggle_alarm_state_interval = 1.0;
  GT.mobile = true;

  GT.sensor = {};
  set_recursive_metatable(GT.sensor, GT_t.SN_visual);
  GT.sensor.height = 1.8;

  -- the rifle, laid out as the Currenthill pack arms its M4 soldier (CH_USInfantry_M4), DCS's own launcher
  GT.WS = {};
  GT.WS.maxTargetDetectionRange = 1500;
  GT.WS.fire_on_march = false;
  local ws = GT_t.inc_ws();
  GT.WS[ws] = {};
  -- no .center: DCS's own soldier models have no CENTER_TOWER_01 connector ("invalid connector", 25 Oct); the default works
  GT.WS[ws].drawArgument1 = 0;
  GT.WS[ws].drawArgument2 = 1;
  GT.WS[ws].canSetTacticalDir = true;
  GT.WS[ws].omegaY = math.rad(100);
  GT.WS[ws].omegaZ = math.rad(100);
  GT.WS[ws].angles = { { math.rad(45), math.rad(-45), math.rad(-45), math.rad(45) } };
  local ln = add_launcher(GT.WS[ws], GT_t.LN_t[rifle]);
  ln.distanceMax = 500;
  -- ten magazines, as the Currenthill pack does: with the launcher's one the M4 soldier ran dry after 4 bursts (25 Oct)
  for i = 2, 10 do
    ln.PL[i] = {};
    set_recursive_metatable(ln.PL[i], ln.PL[1]);
  end

  GT.Name = name;
  GT.DisplayName = _(display);
  GT.DisplayNameShort = _("TIC fast");
  GT.Rate = 1;

  GT.EPLRS = false;
  GT.DetectionRange = 0;
  GT.ThreatRange = 500;

  GT.Transportable = { size = 100, valide = true };

  -- Not "New infantry" / "Skeleton_type_A" (the Currenthill pack's tags for its skeleton models): with DCS's own
  -- older soldier models they left him gliding upright, legs still (film take 2, 24 Oct)
  GT.attribute = {wsType_Ground, wsType_Tank, wsType_Gun, WSTYPE_PLACEHOLDER,
                  "Infantry",
                 };
  GT.category = "Infantry";
  GT.Countries = {"CJTF Blue", "CJTF Red", "USA", "Russia", "Insurgents"};

  add_surface_unit(GT)
end

soldier("TIC_FastSoldier", "TIC fast soldier M4 (stand-in)", "soldier_m4", "soldier_ak_d", "carabine_M4")
soldier("TIC_FastSoldierAK", "TIC fast soldier AK (stand-in)", "soldier_ak", "soldier_ak_d", "AK74")
