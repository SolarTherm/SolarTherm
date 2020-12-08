within SolarTherm.Models.CSP.CRS.HeliostatsField;
model HeliostatsFieldSolstice_1stApproach
    extends Interfaces.Models.Heliostats;
    import metadata = SolarTherm.Utilities.Metadata_Optics;
    parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location"));
    parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location"));
    parameter Real n_h=metadata_list[1] "Number of heliostats" annotation(Dialog(group="Technical data"));
    parameter SI.Area A_h=W_helio*H_helio  "Heliostat's Area" annotation(Dialog(group="Technical data"));
    parameter Real he_av=0.99 "Heliostat availability" annotation(Dialog(group="Technical data"));
    parameter Boolean set_swaying_optical_eff = false "if true = optical efficiency will depend on the wind speed (swaying effect)";

    parameter Real method = 1 "method of the system design, 1 is design from the PB, and 2 is design from the field";
    parameter SI.HeatFlowRate Q_in_rcv = 1e6;
    parameter SI.Length H_rcv=10 "Receiver aperture height";
    parameter SI.Length W_rcv=10 "Receiver aperture width";
    parameter nSI.Angle_deg tilt_rcv = 0 "tilt of receiver in degree relative to tower axis";
    parameter SI.Length W_helio = 10 "width of heliostat in m";
    parameter SI.Length H_helio = 10 "height of heliostat in m";
    parameter SI.Length H_tower = 100 "Tower height";
    parameter SI.Length R_tower = 0.01 "Tower diameter";
    parameter SI.Length R1=80 "distance between the first row heliostat and the tower";
    parameter Real fb=0.7 "factor to grow the field layout";
    parameter SI.Efficiency helio_rho = 0.95 "reflectivity of heliostat max =1";
    parameter SI.Efficiency helio_soil = 0.95 "percentage of the heliostat surface that is not soiled";
    parameter SI.Efficiency helio_sf_ratio = 0.97 "percentage of avaiable heliostat reflective surface area ";
    parameter SI.Angle slope_error = 1.53e-3 "slope error of heliostats, in radiance";
    parameter SI.Angle slope_error_windy = 2e-3 "a larger optical error of heliostats under windy conditions, in radiance";
    parameter Real n_row_oelt = 3 "number of rows of the look up table (simulated days in a year)";
    parameter Real n_col_oelt = 3 "number of columns of the lookup table (simulated hours per day)";
    parameter Real n_procs = 0 "number of processors, 0 is using maximum available num cpu, 1 is 1 CPU,i.e run in series mode";
    parameter String psave = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include/SolsticePy/result/demo") "the directory for saving the results";  
    parameter String field_type = "polar" "Other options are : surround";
    parameter String rcv_type = "flat" "other options are : flat, cylindrical, stl";  
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab"); 
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

    parameter SI.Energy E_start=90e3 "Start-up energy of a single heliostat" annotation(Dialog(group="Parasitic loads"));
    parameter SI.Power W_track=0.055e3 "Tracking power for a single heliostat" annotation(Dialog(group="Parasitic loads"));
    parameter String opt_file(fixed=false);
    parameter Real metadata_list[9] = metadata(opt_file);

    SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELT optical(
        hra=solar.hra, 
        dec=solar.dec, 
        lat=lat, 
        method=method, 
        Q_in_rcv=Q_in_rcv, 
        H_rcv=H_rcv, 
        W_rcv=W_rcv, 
        tilt_rcv=tilt_rcv, 
        W_helio=W_helio, 
        H_helio=H_helio, 
        H_tower=H_tower, 
        R_tower=R_tower, 
        R1=R1, 
        fb=fb, 
        helio_rho=helio_rho, 
        helio_soil=helio_soil, 
        helio_sf_ratio=helio_sf_ratio, 
        slope_error=slope_error,
        slope_error_windy=slope_error_windy, 
        n_row_oelt=n_row_oelt, 
        n_col_oelt=n_col_oelt, 
        n_procs=n_procs, 
        field_type=field_type, 
        rcv_type=rcv_type, 
        psave=psave, 
        wea_file=wea_file,
        set_swaying_optical_eff = set_swaying_optical_eff);

  SI.HeatFlowRate Q_raw;
  SI.HeatFlowRate Q_net;
  
  SI.Efficiency nu;
  SI.Efficiency nu_windy;
  SI.Efficiency nu_calm;
  SI.Angle slope_error_runtime;

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

  SI.Power W_loss;
  Real damping;
  Boolean on_hf;
  Modelica.Blocks.Interfaces.BooleanInput on_hopper(start = false) annotation(
    Placement(visible = true, transformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  SI.Power W_loss1;
  SI.Power W_loss2;
  //SI.Time t_start=30*60;
  parameter SI.Time t_start=3600 "Start-up traking delay";
  discrete Modelica.SIunits.Time t_on(start=0, fixed=true) "Sunrise time instant";
  Modelica.Blocks.Interfaces.BooleanInput on_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.BooleanInput defocus_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput Wspd_internal
    "Needed to connect to conditional connector";
  parameter SI.HeatFlowRate Q_start=nu_start*Q_in_rcv "Heliostat field start power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_min=nu_min*Q_in_rcv "Heliostat field turndown power" annotation(min=0,Dialog(group="Operating strategy"));
  parameter SI.HeatFlowRate Q_defocus=Q_design "Heat flow rate limiter at defocus state" annotation(Dialog(group="Operating strategy",enable=use_defocus));
initial equation
   on_internal=Q_raw>Q_start;
   opt_file=optical.tablefile;
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
                     (Wspd_internal<Wspd_max) and (on_hopper==true);
  
  nu_calm = optical.nu;
  nu_windy = optical.nu_windy;
  
  if set_swaying_optical_eff == true then
    //********************* Assuming linear relationship between effective slope error vs. wind speed
    /*From DOE Guildline for G3P3 project--> Slope error 2 mrad in windy condition, and 1.5 mrad in calm condition*/
    slope_error_runtime = slope_error + (2e-3-slope_error)/(Wspd_max) * max(Wspd_internal,0);
    
    if slope_error_runtime < 2e-3 then
        //********************* Assuming linear relationship between effective slope error vs. optical efficiency
        nu = nu_windy + (nu_calm - nu_windy) / (2e-3 - slope_error) * (slope_error_runtime - slope_error);
    else
        nu = nu_windy;
    end if;
    
  else
    slope_error_runtime = -1;
    nu = nu_calm;
  end if;
  
  Q_raw= if on_hf then max(he_av*n_h*A_h*solar.dni*optical.nu,0) else 0;

  when Q_raw>Q_start then
    on_internal=true;
  elsewhen Q_raw<Q_min then
    on_internal=false;
  end when;

  Q_net= if on_internal then (if defocus_internal then min(Q_defocus,Q_raw) else Q_raw) else 0;

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

  damping= if on_internal then Q_net/(Q_raw+1e-3) else 1;
  W_loss1=if ele>1e-2 then n_h*he_av*damping*W_track else 0;
  when ele>1e-2 then
    t_on=time;
  end when;
    Q_incident = Q_net;
  W_loss2= if time<t_on+t_start then n_h*he_av*damping*E_start/t_start else 0;
  W_loss=W_loss1+W_loss2;
  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end HeliostatsFieldSolstice_1stApproach;
