within SolarTherm.Models.CSP.CRS.HeliostatsField;
model HeliostatFieldOperation
  extends Interfaces.Models.Heliostats;
  import SolarTherm.Utilities.*;
  import SolarTherm.Models.Sources.SolarFunctions.*;
  import Modelica.SIunits.Conversions.*;
  parameter nSI.Time_hour t_zone=9.5 "Local time zone (UCT=0)";
  parameter Integer year=1996 "Year";
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Daggett_Ca_TMY32.motab");
  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/gen3liq_sodium_dagget.motab");
  parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location"));
  parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location"));
  parameter Integer n_h=1 "Number of heliostats" annotation(Dialog(group="Technical data"));
  parameter SI.Area A_h=4 "Heliostat's Area" annotation(Dialog(group="Technical data"));
  parameter Real he_av=0.99 "Heliostat availability" annotation(Dialog(group="Technical data"));
  replaceable model Optical =
      SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Constant
  constrainedby
    SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.OpticalEfficiency
    "Total optical efficency"
    annotation (Dialog(group="Technical data",__Dymola_label="nu"), choicesAllMatching=true);
  parameter Boolean use_on = false
    "= true to display when solar field is connected"
      annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_defocus = false "= true to use defocus strategy"
      annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_wind = false "= true to use Wind-stop strategy"
      annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter SI.Angle ele_min=from_deg(8) "Heliostat stow deploy angle" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_design=529.412 "Receiver design thermal power (with heat losses)" annotation(min=0,Dialog(group="Operating strategy"));
  parameter Real nu_start=0.60 "Receiver energy start-up fraction" annotation(min=0,Dialog(group="Operating strategy"));
  parameter Real nu_min=0.25 "Minimum receiver turndown energy fraction" annotation(min=0,Dialog(group="Operating strategy"));
  parameter Real nu_defocus=1 "Receiver limiter energy fraction at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));
  parameter SI.Velocity Wspd_max=15 "Wind stow speed" annotation(min=0,Dialog(group="Operating strategy",enable=use_wind));

  parameter SI.Time t_start=3600 "Start-up traking delay";
  parameter SI.Energy E_start=90e3 "Start-up energy of a single heliostat" annotation(Dialog(group="Parasitic loads"));
  parameter SI.Power W_track=0.055e3 "Tracking power for a single heliostat" annotation(Dialog(group="Parasitic loads"));
  parameter SI.HeatFlowRate Q_curtail=1e10 "Fixed heat flow rate for curtailment" annotation(min=0,Dialog(group="Operating strategy"));

  Optical optical(hra=solar.hra, dec=solar.dec, lat=lat);
  SI.HeatFlowRate Q_raw;
  SI.HeatFlowRate Q_net;

  Modelica.Blocks.Interfaces.BooleanOutput on if use_on annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-100}),                           iconTransformation(extent={{-12,-12},
            {12,12}},
        rotation=-90,
        origin={0,-100})));
  Modelica.Blocks.Interfaces.BooleanInput defocus if use_defocus annotation (Placement(
        transformation(extent={{-126,-88},{-86,-48}}),iconTransformation(extent={{-110,
            -72},{-86,-48}})));

  Modelica.Blocks.Interfaces.RealInput Wspd if use_wind annotation (Placement(
        transformation(extent={{-126,50},{-86,90}}), iconTransformation(extent={
            {-110,50},{-86,74}})));

  SI.Angle elo;
  SI.Angle ele;
  SI.Angle zen;
  SI.Angle zen2;
  SI.Angle azi;
  SI.Energy E_dni;
  SI.Energy E_field;

  SI.Power W_loss;
  Real damping;
//protected
  Boolean on_hf;
  Boolean on_hf_forecast;
  
  // Variables and parameters for Operation Heuristics
  parameter Real const_t = -dt;
  parameter Integer horizon = 24 "Forecast horizon of the receiver dispatch algorithm";
  parameter Real dt = 3600 "Forecast time step, in seconds";
  SI.HeatFlux dni_horizon[horizon] "DNI for the next horizon";
  SI.Efficiency eta_op_horizon[horizon] "Optical efficiency for the next horizon";
  SI.Angle dec_horizon[horizon] "Forecast declination angle";
  SI.Angle hra_horizon[horizon] "Forecast hour angle";
  SI.Time time_simul "Current simulation second";
  SI.Time t_forecast "Startup time forecast";
  Real counter(start = const_t);

  // Variables flux interpolation
  Modelica.Blocks.Sources.RealExpression u1(y = Modelica.SIunits.Conversions.to_deg(solar.dec));
  Modelica.Blocks.Sources.RealExpression u2(y = Modelica.SIunits.Conversions.to_deg(solar.hra));
  SI.HeatFlux CG[N];
  parameter Integer N = 450 "Number of tube segments in flowpath";
  parameter String tableNames[N] = {"flux_" + String(i) for i in 1:N};
  parameter String file_dni0 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt_FP1_DNIr3.motab");
  parameter String file_dni1 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt_FP1_DNIr2.motab");
  parameter String file_dni2 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt_FP1_DNIr1.motab");
  parameter String file_dni3 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt_FP1_DNIr0.motab");
  
  Modelica.Blocks.Tables.CombiTable2D flux_dni0[N](
    each fileName = file_dni0, 
    each tableOnFile = true, 
    each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    tableName = tableNames);
  Modelica.Blocks.Tables.CombiTable2D flux_dni1[N](
    each fileName = file_dni1, 
    each tableOnFile = true, 
    each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    tableName = tableNames);
  Modelica.Blocks.Tables.CombiTable2D flux_dni2[N](
    each fileName = file_dni2, 
    each tableOnFile = true, 
    each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    tableName = tableNames);
  Modelica.Blocks.Tables.CombiTable2D flux_dni3[N](
    each fileName = file_dni3, 
    each tableOnFile = true, 
    each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    tableName = tableNames);

  Modelica.Blocks.Types.ExternalCombiTable1D wea_table = Modelica.Blocks.Types.ExternalCombiTable1D(
    tableName = "data",
    fileName = wea_file,
    table = fill(0.0, 0, 2),
    columns = 1:9,
    smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);

  Modelica.Blocks.Types.ExternalCombiTable2D opt_table = Modelica.Blocks.Types.ExternalCombiTable2D(
    tableName = "optics", 
    fileName = opt_file, 
    table = fill(0.0, 0, 2), 
    smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);

protected
  SI.Power W_loss1;
  SI.Power W_loss2;
  discrete Modelica.SIunits.Time t_on(start=0, fixed=true) "Sunrise time instant";
  Modelica.Blocks.Interfaces.BooleanInput on_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.BooleanInput defocus_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput Wspd_internal
    "Needed to connect to conditional connector";
  parameter SI.HeatFlowRate Q_start=nu_start*Q_design "Heliostat field start power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_min=nu_min*Q_design "Heliostat field turndown power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_defocus=nu_defocus*Q_design "Heat flow rate limiter at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));

initial equation
  on_internal=Q_raw>Q_start;
  on_hf_forecast = ele>ele_min;
equation
  if use_on then
    connect(on,on_internal);
  end if;
  if use_defocus then
    connect(defocus,defocus_internal);
  else
    defocus_internal = false;
  end if;
  if use_wind then
    connect(Wspd,Wspd_internal);
  else
    Wspd_internal = -1;
  end if;

  on_hf=(ele>ele_min) and (Wspd_internal<Wspd_max);
  Q_raw= if on_hf_forecast then max(he_av*n_h*A_h*solar.dni*optical.nu,0) else 0;

  // Operation heuristics
  der(counter) = 1;
  when counter > 0 then
    time_simul = floor(time);
    for i in 1:horizon loop
      (dec_horizon[i], hra_horizon[i]) = PSA_Algorithm(if time_simul + i * dt < 31536000 then time_simul + i * dt else time_simul + i * dt - 31536000, lon, lat, t_zone, year);
      dni_horizon[i] = horizon_function(if time_simul + i * dt < 31536000 then time_simul + i * dt else time_simul + i * dt - 31536000, 3, wea_table);
      eta_op_horizon[i] = opt_eff_horizon(to_deg(dec_horizon[i]), to_deg(hra_horizon[i]), opt_table);
    end for;
    reinit(counter,const_t);
  end when;
  t_forecast = if on_hf then ReceiverStartupTime(horizon, dni_horizon, eta_op_horizon, n_h*A_h, dt, Q_start) else 0;
  when t_forecast>t_start and on_hf then
    on_hf_forecast = true;
  elsewhen not on_hf then
    on_hf_forecast = false;
  end when;
  // End Operation heuristics

  // Flux interpolation
  for i in 1:N loop
    connect(u1.y, flux_dni0[i].u1);
    connect(u2.y, flux_dni0[i].u2);
    connect(u1.y, flux_dni1[i].u1);
    connect(u2.y, flux_dni1[i].u2);
    connect(u1.y, flux_dni2[i].u1);
    connect(u2.y, flux_dni2[i].u2);
    connect(u1.y, flux_dni3[i].u1);
    connect(u2.y, flux_dni3[i].u2);
    // FluxInterpolation(nu_52, nu_76, nu_100, nu_124, ele, sun.dni, ele_min)
    CG[i] = max(0, FluxInterpolation(flux_dni0[i].y*1e3, flux_dni1[i].y*1e3, flux_dni2[i].y*1e3, flux_dni3[i].y*1e3, ele, solar.dni, ele_min));
  end for;
  // End Flux interpolation 
  when Q_raw>Q_start then
    on_internal=true;
  elsewhen Q_raw<Q_min then
    on_internal=false;
  end when;

  Q_net= if on_internal then (if defocus_internal then min(Q_defocus,Q_raw) else min(Q_curtail,Q_raw)) else 0;
  heat.Q_flow= -Q_net;
  elo=SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(solar.dec);
//   optical.hra=solar.hra;
//   optical.dec=solar.dec;

  ele=SolarTherm.Models.Sources.SolarFunctions.elevationAngle(
    solar.dec,
    solar.hra,
    lat);
  zen=pi/2-ele;
  zen2=SolarTherm.Models.Sources.SolarFunctions.aparentSolarZenith(
    solar.dec,
    solar.hra,
    lat);
  azi=SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(
    solar.dec,
    solar.hra,
    lat);

  der(E_field) = Q_net;
  der(E_dni) = he_av*n_h*A_h*solar.dni;
  damping= if on_internal then Q_net/(Q_raw+1e-3) else 1;
  W_loss1=if ele>1e-2 then n_h*he_av*damping*W_track else 0;
  when ele>1e-2 then
    t_on=time;
  end when;
  W_loss2= if time<t_on+t_start then n_h*he_av*damping*E_start/t_start else 0;
  W_loss=W_loss1+W_loss2;
  annotation (Documentation(info = "<html>
</html>", revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    Icon(graphics = {Text(origin = {0, -140}, lineColor = {0, 0, 255}, extent = {{-140, 20}, {140, -20}}, textString = "%name")}));
end HeliostatFieldOperation;
