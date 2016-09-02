within SolarTherm.Models.CSP.CRS.HeliostatsField;
model HeliostatsField
  extends Interfaces.Models.Heliostats;
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
  parameter SI.Angle ele_min=from_deg(8) "Heliostat stow deploy angle" annotation(Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_min=529.412e6*0.25 "Heliostat field turndown power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_defocus=6.39804e8
    "Heat flow rate limiter at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));
  parameter SI.Velocity Wspd_max=15 "Wind stow speed" annotation(min=0,Dialog(group="Operating strategy",enable=use_wind));

  parameter SI.Energy E_start=90e3 "Start-up energy of a single heliostat" annotation(Dialog(group="Parasitic loads"));
  parameter SI.Power W_track=0.055e3 "Tracking power for a single heliostat" annotation(Dialog(group="Parasitic loads"));

  Optical optical;
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
        transformation(extent={{-120,50},{-80,90}}), iconTransformation(extent={
            {-110,50},{-86,74}})));

  SI.Angle elo;
  SI.Angle ele;
  SI.Angle zen;
  SI.Angle zen2;
  SI.Angle azi;

  SI.Power W_loss;
  Real damping;
//protected
  Boolean on_hf;
protected
  SI.Power W_loss1;
  SI.Power W_loss2;
  SI.Time t_start=30*60;
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";
  Modelica.Blocks.Interfaces.BooleanInput on_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.BooleanInput defocus_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput Wspd_internal
    "Needed to connect to conditional connector";
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

  on_hf=(ele>ele_min) and
                     (Wspd_internal<Wspd_max);
  Q_raw= if on_hf then max(he_av*n_h*A_h*solar.dni*optical.nu,0) else 0;

  on_internal=Q_raw>Q_min;
  Q_net= if on_internal then (if defocus_internal then min(Q_defocus,Q_raw) else Q_raw) else 0;

  heat.Q_flow= -Q_net;
  elo=SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(solar.dec);
  optical.hra=solar.hra;
  optical.dec=solar.dec;

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

  damping= Q_net/(Q_raw+1e-3);
  W_loss1=if on_internal then n_h*he_av*damping*W_track else 0;
  when on_internal then
    entryTime=time;
  end when;
  W_loss2= if time<entryTime+t_start then n_h*he_av*damping*E_start/t_start else 0;
  W_loss=W_loss1+W_loss2;
  annotation (Documentation(info="<html>
</html>"));
end HeliostatsField;
