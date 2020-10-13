within SolarTherm.Models.CSP.CRS.HeliostatsField;
model HeliostatsFieldSolstice_3Apertures_1stApproach
  extends Interfaces.Models.Heliostats;
  import metadata = SolarTherm.Utilities.Metadata_Optics_3Apertures;
  parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location"));
  parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location"));
  parameter SI.Area A_h=W_helio*H_helio  "Heliostat's Area" annotation(Dialog(group="Technical data"));
  parameter Real he_av=0.99 "Heliostat availability" annotation(Dialog(group="Technical data"));
  
  
  parameter Real metadata_list[18] = metadata(opt_file);

  parameter Real method = 1 "method of the system design, 1 is design from the PB, and 2 is design from the field";
  
  /*Parameter for each aperture*/
  parameter SI.HeatFlowRate Q_in_rcv_1 = 1e6;
  parameter SI.Length H_rcv_1=10 "Receiver aperture height";
  parameter SI.Length W_rcv_1=10 "Receiver aperture width";
  parameter Real n_h_1 = metadata_list[10] "Number of heliostats paerture 1" annotation(Dialog(group="Technical data"));
  
  parameter SI.HeatFlowRate Q_in_rcv_2 = 1e6;
  parameter SI.Length H_rcv_2=10 "Receiver aperture height";
  parameter SI.Length W_rcv_2=10 "Receiver aperture width";
  parameter Real n_h_2 = metadata_list[11] "Number of heliostats paerture 1" annotation(Dialog(group="Technical data"));
  
  parameter SI.HeatFlowRate Q_in_rcv_3 = 1e6;
  parameter SI.Length H_rcv_3=10 "Receiver aperture height";
  parameter SI.Length W_rcv_3=10 "Receiver aperture width";
  parameter Real n_h_3 = metadata_list[12] "Number of heliostats paerture 1" annotation(Dialog(group="Technical data"));
  /*end parameter for each aperture*/
  
  /*Solstice simulation parameters*/
  parameter nSI.Angle_deg tilt_rcv = 0 "tilt of receiver in degree relative to tower axis";
  parameter SI.Length W_helio = 10 "width of heliostat in m";
  parameter SI.Length H_helio = 10 "height of heliostat in m";
  parameter SI.Length H_tower = 100 "Tower height";
  parameter SI.Length R_tower = 0.01 "Tower diameter";
  parameter SI.Length R1=80 "distance between the first row heliostat and the tower";
  parameter Real fb=0.7 "factor to grow the field layout";
  parameter SI.Efficiency rho_helio = 0.9 "reflectivity of heliostat max =1";
  parameter SI.Angle slope_error = 2e-3 "slope error of the heliostat in mrad";
  parameter Real n_row_oelt = 3 "number of rows of the look up table (simulated days in a year)";
  parameter Real n_col_oelt = 3 "number of columns of the lookup table (simulated hours per day)";
  parameter String psave = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include/SolsticePy/result/demo") "the directory for saving the results";  
  parameter String field_type = "polar" "Other options are : surround";
  parameter String rcv_type = "flat" "other options are : flat, cylindrical, stl";  
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab"); 
  parameter Boolean use_on = false "= true to display when solar field is connected"
    annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_defocus = false "= true to use defocus strategy"
    annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_wind = false "= true to use Wind-stop strategy"
    annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));
  /*end of Solstice simulation parameters*/

  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELT_3Apertures optical(
      hra=solar.hra, dec=solar.dec, 
      lat=lat, 
      method=method, 
      Q_in_rcv=Q_in_rcv_1, 
      H_rcv=H_rcv_1, 
      W_rcv=W_rcv_1, 
      tilt_rcv=tilt_rcv, 
      W_helio=W_helio, 
      H_helio=H_helio, 
      H_tower=H_tower, 
      R_tower=R_tower, 
      R1=R1, 
      fb=fb, 
      rho_helio=rho_helio,
      slope_error=slope_error, 
      n_row_oelt=n_row_oelt, 
      n_col_oelt=n_col_oelt, 
      field_type=field_type, 
      rcv_type=rcv_type, 
      psave=psave, 
      wea_file=wea_file
      );
  
  /*Variables for each aperture*/
  SI.HeatFlowRate Q_raw_1;
  SI.HeatFlowRate Q_net_1;
  SI.Efficiency nu_1;
  
  SI.HeatFlowRate Q_raw_2;
  SI.HeatFlowRate Q_net_2;
  SI.Efficiency nu_2;
  
  SI.HeatFlowRate Q_raw_3;
  SI.HeatFlowRate Q_net_3;
  SI.Efficiency nu_3;
  /*End of variables for each aperture*/ 

  Modelica.Blocks.Interfaces.BooleanOutput on_1 if use_on annotation (Placement(
        visible = true,transformation(
        origin={2, -100},extent={{-20,-20},{20,20}},
        rotation=-90),                           iconTransformation(
        origin={0,-100},extent={{-12,-12},
            {12,12}},
        rotation=-90)));
  Modelica.Blocks.Interfaces.BooleanOutput on_2 if use_on annotation(
    Placement(visible = true, transformation(origin = {38, -100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {42, -100}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput on_3 if use_on annotation(
    Placement(visible = true, transformation(origin = {-44, -100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-42, -100}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.BooleanInput defocus if use_defocus annotation (Placement(
        transformation(extent={{-126,-88},{-86,-48}}),iconTransformation(extent={{-110,
            -72},{-86,-48}})));
  Modelica.Blocks.Interfaces.RealOutput Q_incident annotation(
    Placement(transformation(extent = {{94, -18}, {130, 18}})));
  Modelica.Blocks.Interfaces.RealInput Wspd if use_wind annotation (Placement(
        transformation(extent={{-126,50},{-86,90}}), iconTransformation(extent={
            {-110,50},{-86,74}})));

  SI.Angle elo;
  SI.Angle ele;
  SI.Angle zen;
  SI.Angle zen2;
  SI.Angle azi;

  Real damping_1;
  Real damping_2;
  Real damping_3;

  Boolean on_hf_1;
  Boolean on_hf_2;
  Boolean on_hf_3;
  
  /*ratio of heat --> for particle receiver*/
  Real ratio_1;
  Real ratio_2;
  Real ratio_3;
  
  Modelica.Blocks.Interfaces.BooleanInput on_hopper(start = false) annotation(
    Placement(visible = true, transformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  SI.Power W_loss;
  SI.Power W_loss1;
  SI.Power W_loss2;

  //SI.Time t_start=30*60;
  
  /*Control system of the model*/
  parameter SI.Angle ele_min=from_deg(8) "Heliostat stow deploy angle" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_design_1=529.412 "Receiver design thermal power (with heat losses)" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_design_2=529.412 "Receiver design thermal power (with heat losses)" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_design_3=529.412 "Receiver design thermal power (with heat losses)" annotation(min=0,Dialog(group="Operating strategy"));
  parameter Real nu_start=0.60 "Receiver energy start-up fraction" annotation(min=0,Dialog(group="Operating strategy"));
  parameter Real nu_min=0.25 "Minimum receiver turndown energy fraction" annotation(min=0,Dialog(group="Operating strategy"));
  parameter Real nu_defocus=1 "Receiver limiter energy fraction at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));
  parameter SI.Velocity Wspd_max=15 "Wind stow speed" annotation(min=0,Dialog(group="Operating strategy",enable=use_wind));
  parameter SI.Energy E_start=90e3 "Start-up energy of a single heliostat" annotation(Dialog(group="Parasitic loads"));
  parameter SI.Power W_track=0.055e3 "Tracking power for a single heliostat" annotation(Dialog(group="Parasitic loads"));
  parameter String opt_file(fixed=false);
  parameter SI.Time t_start=3600 "Start-up traking delay";
  discrete Modelica.SIunits.Time t_on(start=0, fixed=true) "Sunrise time instant";
  
  Modelica.Blocks.Interfaces.BooleanInput on_internal_1
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.BooleanInput on_internal_2
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.BooleanInput on_internal_3
    "Needed to connect to conditional connector";
    
  Modelica.Blocks.Interfaces.BooleanInput defocus_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput Wspd_internal
    "Needed to connect to conditional connector";
    
  /*Control system for each aperture*/
  parameter SI.HeatFlowRate Q_start_1 = nu_start * Q_design_1 "Heliostat field start power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_min_1=nu_min*Q_design_1 "Heliostat field turndown power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_defocus_1=nu_defocus*Q_design_1 "Heat flow rate limiter at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));

  parameter SI.HeatFlowRate Q_start_2 = nu_start * Q_design_2 "Heliostat field start power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_min_2=nu_min*Q_design_2 "Heliostat field turndown power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_defocus_2=nu_defocus*Q_design_2 "Heat flow rate limiter at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));
  
  parameter SI.HeatFlowRate Q_start_3 = nu_start * Q_design_3 "Heliostat field start power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_min_3 = nu_min*Q_design_3 "Heliostat field turndown power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_defocus_3 = nu_defocus*Q_design_3 "Heat flow rate limiter at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));
  
initial equation
   on_internal_1=Q_raw_1>Q_start_1;
   on_internal_2=Q_raw_2>Q_start_2;
   on_internal_3=Q_raw_3>Q_start_3;
   opt_file=optical.tablefile;
equation
  if use_on then
    connect(on_1,on_internal_1);
    connect(on_2,on_internal_2);
    connect(on_3,on_internal_3);
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

  on_hf_1=(ele>ele_min) and
                     (Wspd_internal<Wspd_max) and (on_hopper==true);
  on_hf_2=(ele>ele_min) and
                     (Wspd_internal<Wspd_max) and (on_hopper==true);
  on_hf_3=(ele>ele_min) and
                     (Wspd_internal<Wspd_max) and (on_hopper==true);
  
  nu_1 = optical.nu_1;
  nu_2 = optical.nu_2;
  nu_3 = optical.nu_3;
  
  Q_raw_1= if on_hf_1 then max(he_av*n_h_1*A_h*solar.dni*optical.nu_1,0) else 0;
  Q_raw_2= if on_hf_2 then max(he_av*n_h_2*A_h*solar.dni*optical.nu_2,0) else 0;
  Q_raw_3= if on_hf_3 then max(he_av*n_h_3*A_h*solar.dni*optical.nu_3,0) else 0;

  when Q_raw_1>Q_start_1 then
    on_internal_1=true;
  elsewhen Q_raw_1<Q_min_1 then
    on_internal_1=false;
  end when;
  
  when Q_raw_2>Q_start_2 then
    on_internal_2=true;
  elsewhen Q_raw_2<Q_min_2 then
    on_internal_2=false;
  end when;
  
  when Q_raw_3>Q_start_3 then
    on_internal_3=true;
  elsewhen Q_raw_3<Q_min_3 then
    on_internal_3=false;
  end when;

  Q_net_1= if on_internal_1 then (if defocus_internal then min(Q_defocus_1,Q_raw_1) else Q_raw_1) else 0;
  Q_net_2= if on_internal_2 then (if defocus_internal then min(Q_defocus_2,Q_raw_2) else Q_raw_2) else 0;
  Q_net_3= if on_internal_3 then (if defocus_internal then min(Q_defocus_3,Q_raw_3) else Q_raw_3) else 0;
  
  if Q_incident > 100 then 
    ratio_1 = Q_net_1 / Q_incident;
    ratio_2 = Q_net_2 / Q_incident;
    ratio_3 = Q_net_3 / Q_incident;
  else
    ratio_1 = 0;
    ratio_2 = 0;
    ratio_3 = 0;
  end if;

  heat.Q_flow= -Q_net_1 - Q_net_2 - Q_net_3 ;
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

  damping_1 = if on_internal_1 then Q_net_1/(Q_raw_1+1e-3) else 1;
  damping_2 = if on_internal_2 then Q_net_2/(Q_raw_2+1e-3) else 1;
  damping_3 = if on_internal_3 then Q_net_3/(Q_raw_3+1e-3) else 1;
  
  W_loss1=if ele>1e-2 then (n_h_1*he_av*damping_1*W_track + n_h_2*he_av*damping_2*W_track + n_h_3*he_av*damping_3*W_track) else 0;
  
  when ele>1e-2 then
    t_on=time;
  end when;
  
  Q_incident = Q_net_1 + Q_net_2 + Q_net_3;
  
  W_loss2= if time<t_on+t_start then (n_h_1*he_av*damping_1*E_start/t_start + n_h_2*he_av*damping_2*E_start/t_start + n_h_3*he_av*damping_3*E_start/t_start) else 0;
  
  W_loss=W_loss1+W_loss2;
  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end HeliostatsFieldSolstice_3Apertures_1stApproach;