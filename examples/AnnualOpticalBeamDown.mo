within examples;

model AnnualOpticalBeamDown

  import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELT;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import metadata = SolarTherm.Utilities.Metadata_Optics;

  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/AUS_WA.Newman.Airport.943170_RMY.motab");
  parameter Real metadata_list[10] = metadata(opt_file);
  parameter nSI.Angle_deg lon = 119.8 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.42 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  parameter String opt_file(fixed=false);
  parameter String casefolder = "optic" "dont change this";

  /*
	 Boolean for the cost
  */
  parameter Boolean low_cost = true "If false, HX and reactor cost is multiplied by a factor (roughly 2)"; 
  
  /*
      Reading metadata from $casefolder/OELT_Solstice.motab
          n_helios, A_helio, A_secref, A_cpc, Eff_design, H_rcv, W_rcv, H_tower, Q_in_rcv, A_land
  */
  parameter Real n_h=metadata_list[1] "Number of heliostats";
  parameter SI.Area A_h=metadata_list[2] "Heliostat's area in m2";
  parameter Real A_secref=metadata_list[3] "Secondary reflector area in m2";
  parameter SI.Area A_cpc=metadata_list[4] "CPC area in m2";
  parameter Real eta_field_design=metadata_list[5] "Field eff. at design point";
  parameter SI.HeatFlowRate Q_in_rcv_from_OELT = metadata_list[9] "Incident heat flow rate on the aperture at design point after ray tracing [W]";
  parameter SI.Area A_land = metadata_list[10] "Land area in m2";

  /*System size*/
  parameter SI.HeatFlowRate Q_in_rcv = 50e6 "Incident thermal power to the receiver";
  
  /*Iron sample*/
  parameter String iron_sample = "A_1" "Which iron sample used"; 
  
  /*Heliostat and tower parameters*/
  parameter nSI.Angle_deg cpc_theta_deg=26 "acceptance half angle of the CPC in degree";
  parameter Real cpc_h_ratio=0.6 "ratio of CPC critical height [0,1]";
  parameter nSI.Angle_deg aperture_angle_x=160 "aperture angle of the heliostat field in the xOz plan in degree [0,180] ";
  parameter nSI.Angle_deg aperture_angle_y=160 "aperture angle of the heliostat field in the yOz plan in degree [0,180] ";
  parameter nSI.Angle_deg secref_offset = 0.  "Offset of the mirror central line with regards to the hyperboloid axis of symmetry [-100,100]";
  parameter Real secref_inv_eccen=0.7 "Secondary Reflector (hyperboloid) inverse eccentricity [0,1]";
  parameter SI.Length H_tower=80.64 "Tower height";
  parameter Real fb=0.9618 "factor to grow the field layout";
  parameter nSI.Angle_deg tilt_secref=-5 "tilt angle of the secondary mirror (hyperboloid) central axis along the N-S axis in degree";
  parameter SI.Length W_rcv=8 "Polygon receiver width";
  parameter SI.Length H_rcv= W_rcv "Polygon receiver length. Made square";
  parameter SI.Length R1=15. "distance between the first row heliostat and the tower";
  parameter SI.Length W_helio = 6.1 "width of heliostat in m";
  parameter SI.Length H_helio = 6.1 "height of heliostat in m";
  parameter SI.Angle slope_error_bd = 1.53e-3 "slope error of all reflective surfaces in mrad";
  parameter SI.Efficiency slope_error = 1.53e-3 "slope error of the mirror";
  parameter SI.Efficiency rho_secref = 0.9025 "reflectivity of the secondary reflector (hyperboloid)";
  parameter SI.Efficiency rho_cpc = 0.9025 "reflectivity of the CPC";
  parameter SI.Efficiency rho_helio = 0.9025 "reflectivity of the heliostat";
  parameter Real cpc_nfaces=4 "2D-crossed cpc with n faces";
  parameter String sun_shape = "buie" "Sun shape";
  parameter Real circum_solar_ratio = 0.028 "Circum solar ratio";

  /*Optical parameters*/
  parameter Real n_rays = 5e6 "number of rays for the optical simulation";
  parameter Real n_row_oelt = 5 "number of rows of the look up table (simulated days in a year)";
  parameter Real n_col_oelt = 22 "number of columns of the lookup table (simulated hours per day)";
  parameter SI.Length Z_helio = 0.0 "heliostat center z location in m";
  parameter Real n_H_rcv=40 "rendering of flux map on receiver";
  parameter SI.Length Z_rcv=0 "Polygon receiver z position, 0 is on the ground";
  parameter Integer n_procs = 1 "Number of processor to run solstice";
  
  //Environmental variables to run the interpolation functions
  parameter String ppath_sintering = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Path to the directory where the Python script is hosted";
  parameter String pname_sintering = "run_sintering_thermal_model" "The name of the Python script";
  parameter String pfunc_sintering = "run_interpolate" "Name of the function inside pname.py that will be called";
  parameter String solstice_wd = Modelica.Utilities.Files.loadResource(casefolder) "Folder in which the CSVs storing flux map are located absolute p";
  parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm");
  
  //Parameters to generate the training data
  parameter String thermal_model_name_parameters[:] = {
    "T_sky", "k_s", "alpha", "eps_r", "h_ext", "eps",
    "T_i_s_HX1", "T_o_s_HX1", "T_i_g_HX1", "d_p_HX1", "H_HX1", "W_HX1", "t_wall_HX1",
    "T_i_s_HX2", "T_o_s_HX2", "T_i_g_HX2", "W_HX2", "d_p_HX2"
  };
  
  parameter Real thermal_model_parameters[:] = {
      T_sky -273.15, k_s, alpha, eps_r, h_ext, eps,
      T_i_s_HX1 -273.15, T_o_s_HX1 -273.15, T_i_g_HX1 -273.15, d_p_HX1 * 1000, H_HX1, W_HX1, t_wall_HX1 * 100,
      T_i_s_HX2 - 273.15, T_o_s_HX2 - 273.15, T_i_g_HX2 - 273.15, W_HX2, d_p_HX2 * 1000
  };
  
  //Ambient condition parameters
  parameter SI.Temperature T_sky = 40 + 273.15 "Sky temperature [K]";
  parameter SI.ThermalConductivity k_s = 6.5 "Thermal conductivity [W/(m.K)]";
  parameter Real alpha = 0.95 "Absorptivity [-]";
  parameter Real eps_r = 0.9 "Emmissivity [-]-";
  parameter SI.CoefficientOfHeatTransfer h_ext = 20 "Coefficient of convective heat transfer [W/(m2.K)]";
  parameter Real eps = 0.4 "Void fraction [-]";
  

  //Receiver design point parameters
  parameter SI.Temperature T_i_s_HX1 = 25 +273.15 "Iron ore inlet temperature [K]";
  parameter SI.Temperature T_o_s_HX1 = 1140 + 273.15 "Iron ore outlet temperature [K]";
  parameter SI.Temperature T_i_g_HX1 = 1250 + 273.15 "Air inlet temperature [K]";
  parameter SI.Length d_p_HX1 = 7.5e-3 "Iron ore diameter [m]";
  parameter SI.Length H_HX1 = 0.05 "Thickness of heat exchanger [m]";
  parameter SI.Length W_HX1 = W_rcv "Width of heat exchanger [m] equals to W_rcv. SRC: P45 Meeting 3 Dec 2021";
  parameter SI.Length t_wall_HX1 = 0.01 "Wall thickness of heat exchanger [m]";
  
  parameter SI.Temperature T_i_s_HX2 = 1350 +273.15 "Iron ore inlet temperature [K]";
  parameter SI.Temperature T_o_s_HX2 = 200 + 273.15 "Iron ore outlet temperature [K]";
  parameter SI.Temperature T_i_g_HX2 = 25 + 273.15 "Air inlet temperature [K]";
  parameter SI.Length W_HX2 = W_rcv "Width of heat exchanger [m] equals to W_rcv. SRC: P45 Meeting 3 Dec 2021";
  parameter SI.Length d_p_HX2 = 40e-3 "Iron ore diameter [m]";
    
  //status_run to launch the ASCEND model --> collecting training data
  parameter Integer status_run(fixed=false);
  parameter Real design_point_result[3](each fixed=false);
  
  /*Design point calculation result*/
  parameter Real mdot_ore_design_point(fixed=false);
  parameter SI.Volume A_HX1(fixed=false);
  parameter SI.Volume A_HX2(fixed=false);
  
  /*PHX calculation*/
  parameter SI.Density rho_material_HX = 7850 "Density of carbon steel assumed material for HXs Carbon Steel ASTM A36. Source: https://amesweb.info/Materials/Density_of_Steel.aspx";
  //parameter SI.Mass M_HX = (V_HX1 + V_HX2) * rho_material_HX "Total weight of HXs in kg for CAPEX calculation";
  parameter SI.Area A_HX_total = A_HX1 + A_HX2 "Total area of the HXs"; 

  /*Rector calculation*/
  parameter SI.Area A_reactor = W_rcv * H_rcv "Area of the reactor";

  //Specific cost of components
  parameter Real pri_tower = 725.9 "USD/kWth";
  parameter Real pri_secondary_mirror = 1011.81753912 * Modelica.Math.exp(-0.02349651 * Q_in_rcv_from_OELT/1e6) "USD/m2";
  parameter Real pri_field = 75 "USD/m2";
  parameter Real pri_CPC = 300 "USD/m2";
  parameter Real pri_land = 2.47105163015276 "USD/m2 based on Gen3 Topic 1 Downselect Criteria rev_1 Chapter 3.1.3";
  parameter Real pri_steel = 4 * EU_to_USD "USD/kg of steel. Converted from 4 Euro/kg. ";
  parameter Real pri_HX = 40000 * EU_to_USD "Cost of HX for 6m^2 in euro";
  parameter Real pri_labour = 139000 * AUD_to_USD "Cost of labour per person per year";
     
  //Financial parameters
  parameter Real r_disc = 0.0401 "Based on Gen 3";  
  parameter Integer t_life = 30;
  parameter Integer t_cons = 0;
  parameter Real r_contg = 0.1;
  parameter Real r_cons = 0.06;
  parameter Real CEPCI_2020 = 596.2 "CEPCI 2020 https://www.cheresources.com/invision/topic/29828-i-need-2020-cepci/";
  parameter Real CEPCI_1986 = 318.4 "Reference 2 case in SolarTherm master branch";
  parameter Real CEPCI_2005 = 468.2;
  parameter Real CEPCI_2016 = 541.7;

  //Exchange rate
  parameter Real EU_to_USD = 1.13 "Euro to USD Exchange rate is from google (7 December 2021)";
  parameter Real AUD_to_USD = 0.71 "AUD to USD Exchange rate is from google (7 December 2021)";
  
  //O&M cost
  parameter Real C_year = 0.02 * C_cap;
  parameter Real C_prod = 0.02 * C_cap "Variable O&M";

  //Other constants
  parameter Real bm_factor_HX = 4.00;
  parameter Real bm_factor_sf = 1.00;
    
  //Cost calculation
  parameter Real C_tower = 1.09025e6 * Modelica.Math.exp(0.00879 * H_tower)  * (CEPCI_2020/CEPCI_1986)"Latticework steel trussed tower DELSOL Manual 3. 318.4 is CEPCI 1986 the year DELSOL guideline was published";
  parameter Real C_secondary_mirror =  pri_secondary_mirror * A_secref * (CEPCI_2020/CEPCI_2005); 
  parameter Real C_field = pri_field * n_h * A_h * bm_factor_sf;
  parameter Real C_CPC = (28564 * Q_in_rcv_from_OELT/1e6 + 43581) * EU_to_USD * (CEPCI_2020/CEPCI_2016); 
  parameter Real C_reactor = A_reactor / 6 * pri_HX * bm_factor_HX "Cost of reactor";
  parameter Real C_HX = A_HX_total/6 * pri_HX * bm_factor_HX "Cost of HX";
  parameter Real C_land = pri_land * A_land;
  
  parameter Real C_equipment_no_thermal = C_tower + C_secondary_mirror + C_field + C_CPC "Cost of eq without thermal stuffs";
  parameter Real C_equipment_thermal = if low_cost then (C_reactor + C_HX) else 2.051784 * (C_reactor + C_HX)  "Cost of eq with thermal stuffs. The multiplier (default is 2.05) already considers the contingency, construction cost, site prep etc.";

  parameter Real C_direct_no_thermal = if low_cost then (1 + r_contg) * (C_equipment_no_thermal+C_equipment_thermal) else (1 + r_contg) * C_equipment_no_thermal "Direct cost";
  parameter Real C_indirect_no_thermal = r_cons * C_direct_no_thermal + C_land "Indirect cost";
  
  parameter Real C_cap = if low_cost then C_direct_no_thermal + C_indirect_no_thermal else C_direct_no_thermal + C_indirect_no_thermal + C_equipment_thermal;

  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(
      lon = data.lon,
      lat = data.lat,
      t_zone = data.t_zone,
      year = data.year,
      redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
                                                                                                      Placement(transformation(extent = {{-82, 60}, {-62, 80}})));


  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(
      lon = lon,
      lat = lat,
      t_zone = t_zone,
      year = year,
      file = wea_file) annotation(
                                          Placement(visible = true, transformation(extent = {{-100, -50}, {-70, -22}}, rotation = 0)));

  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(
      y = data.DNI) annotation(
                                  Placement(visible = true, transformation(extent = {{-102, 64}, {-82, 84}}, rotation = 0)));
  
  //Solstice beam-down
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELTBeamdown lookuptable(
      cpc_theta_deg=cpc_theta_deg,
      cpc_h_ratio=cpc_h_ratio,
      aperture_angle_x=aperture_angle_x,
      aperture_angle_y=aperture_angle_y,
      secref_offset=secref_offset,
      secref_inv_eccen=secref_inv_eccen,
      H_tower=H_tower,
      fb=fb,
      tilt_secref=tilt_secref,
      Z_rcv=Z_rcv,
      W_rcv=W_rcv,
      H_rcv=H_rcv,
      n_rays=n_rays,
      n_row_oelt=n_row_oelt,
      n_col_oelt=n_col_oelt,
      Q_in_rcv=Q_in_rcv,
      R1=R1,
      W_helio=W_helio,
      H_helio=H_helio,
      Z_helio=Z_helio,
      slope_error_bd=slope_error_bd,
      rho_secref=rho_secref,
      rho_cpc=rho_cpc,
      rho_helio=rho_helio,
      slope_error=slope_error,
      cpc_nfaces=cpc_nfaces,
      n_H_rcv=n_H_rcv,
      psave=casefolder,
      hra=sun.solar.hra,
      dec=sun.solar.dec,
      lat=lat,
      wea_file = wea_file,
      sun_shape = sun_shape, 
      circum_solar_ratio = circum_solar_ratio,
      n_procs = n_procs
  );
  
  //Variable for optical
  Real opt_eff;
  Real opt_ann_eff "annual optical efficiency";
  
  //Inputs to interpolation
  nSI.Angle_deg declination_inDeg;
  nSI.Angle_deg sun_hour_angle_inDeg;
  Real flux_multiple_off;
  SI.Mass M_ore "mass of ore accummulated thru out the year [kg]";
  
  //Analysis
  SI.Energy E_sun;
  SI.Energy E_rcv;
  SI.HeatFlowRate Q_sun;
  SI.HeatFlowRate Q_rcv;

initial equation
  /*Call Solstice to generate OELT*/
  opt_file = lookuptable.tablefile;
  
  /*Call mdot ore design point*/
  design_point_result = SolarTherm.Utilities.RunSinteringThermalModelDesignPoint(
      SolarTherm_path, 
      solstice_wd, 
      thermal_model_parameters,
      iron_sample, 
      opt_file
  );
  
  mdot_ore_design_point = design_point_result[1]; 
  A_HX1 = design_point_result[2]; 
  A_HX2 = design_point_result[3];
  
  /*Initialisation of the model*/
  if Q_in_rcv_from_OELT > Q_in_rcv then
      Modelica.Utilities.Streams.print("Heat duty delivered by heliostat field is enough\n\n");
      status_run = SolarTherm.Utilities.RunSinteringThermalModel(SolarTherm_path, solstice_wd, thermal_model_parameters, opt_file, iron_sample);
  else
      Modelica.Utilities.Streams.print("Heat duty delivered by heliostat field is NOT enough\n\n");
      status_run = -1000;
  end if;

equation
  declination_inDeg = Modelica.SIunits.Conversions.to_deg(sun.dec);
  sun_hour_angle_inDeg = Modelica.SIunits.Conversions.to_deg(sun.hra);
  flux_multiple_off = data.DNI/1000;
  
  if status_run > -500 then
	  /*If heliostat field gives the adeuqate amount of heat at design point then the system is eligible to run*/
	  if flux_multiple_off < 0.7 then
		  der(M_ore) = 0;
	  else
		  der(M_ore) = SolarTherm.Utilities.InterpolateSinteringThermalModel(
		        ppath_sintering, pname_sintering, 
		        pfunc_sintering, 
		        solstice_wd, declination_inDeg, 
		        sun_hour_angle_inDeg, flux_multiple_off, time
		  );
	  end if;
  
  else
	  /*If heliostat field could not provide the requested heat, then the yield is forced to be zero to cut computational time*/
	  der(M_ore) = 0;
  end if;
  
  opt_eff=lookuptable.nu;
  Q_sun=sun.dni*n_h*A_h;
  der(E_sun)=Q_sun;

  Q_rcv=sun.dni*n_h*A_h*opt_eff;
  der(E_rcv)=Q_rcv;
  
  if time > 3.1535e7 then
      opt_ann_eff=E_rcv/E_sun;
  else
      opt_ann_eff = 0;
  end if;

  connect(DNI_input.y, sun.dni) annotation(
												Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

  annotation(
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 3600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> Y. Wang (23 Jun 2021) :<br>Released first version. </li>
	</ul>

	</html>"),
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)));
end AnnualOpticalBeamDown;
