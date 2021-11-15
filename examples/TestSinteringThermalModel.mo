within examples;

model TestSinteringThermalModel
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/AUS_WA_Leinster_Airport_954480_TMY.motab");
  parameter nSI.Angle_deg lon = 120.70 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -27.85 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  
  parameter String ppath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Path to the directory where the Python script is hosted";
  parameter String pname = "run_sintering_thermal_model" "The name of the Python script";
  parameter String pfunc = "run_thermalSinteringModel" "Name of the function inside pname.py that will be called";
  
  parameter String varnames[:] = {
    "T_sky", "k_s", "alpha", "eps_r", "h_ext", "eps",
    "T_i_s_HX1", "T_o_s_HX1", "T_i_g_HX1", "d_p_HX1", "H_HX1", "W_HX1", "t_wall_HX1",
    "T_i_s_HX2", "T_o_s_HX2", "T_i_g_HX2", "W_HX2", "d_p_HX2",
    "flux_multiple_off"
  };
  parameter String solstice_wd = ".";
  parameter String modelica_wd = Modelica.Utilities.Files.fullPathName(solstice_wd) "Folder in which the CSVs storing flux map are located absolute p";
  parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm");
    
  parameter SI.Temperature T_sky = 40 + 273.15 "Sky temperature [K]";
  parameter SI.ThermalConductivity k_s = 6.5 "Thermal conductivity [W/(m.K)]";
  parameter Real alpha = 0.95 "Absorptivity [-]";
  parameter Real eps_r = 0.9 "Emmissivity [-]-";
  parameter SI.CoefficientOfHeatTransfer h_ext = 20 "Coefficient of convective heat transfer [W/(m2.K)]";
  parameter Real eps = 0.4 "Void fraction [-]";
  
  parameter SI.Temperature T_i_s_HX1 = 25 +273.15 "Iron ore inlet temperature [K]";
  parameter SI.Temperature T_o_s_HX1 = 1140 + 273.15 "Iron ore outlet temperature [K]";
  parameter SI.Temperature T_i_g_HX1 = 1250 + 273.15 "Air inlet temperature [K]";
  parameter SI.Length d_p_HX1 = 7.5e-3 "Iron ore diameter [m]";
  parameter SI.Length H_HX1 = 0.05 "Thickness of heat exchanger [m]";
  parameter SI.Length W_HX1 = 8.0 "Width of heat exchanger [m]";
  parameter SI.Length t_wall_HX1 = 0.01 "Wall thickness of heat exchanger [m]";
  
  parameter SI.Temperature T_i_s_HX2 = 1350 +273.15 "Iron ore inlet temperature [K]";
  parameter SI.Temperature T_o_s_HX2 = 200 + 273.15 "Iron ore outlet temperature [K]";
  parameter SI.Temperature T_i_g_HX2 = 25 + 273.15 "Air inlet temperature [K]";
  parameter SI.Length W_HX2 = 8.0 "Width of heat exchanger [m]";
  parameter SI.Length d_p_HX2 = 40e-3 "Iron ore diameter [m]";
  
  parameter Integer status_run(fixed=false);
  
    
  SolarTherm.Models.Sources.DataTable.DataTable data(
		lon = lon,
		lat = lat,
		t_zone = t_zone,
		year = year,
		file = wea_file
  );
  
  
  Real flux_multiple_off "Multiplier of the flux based on DNI at time t over 1000 W/m2";
  Real DNI;
  Real vars[19] "Array to store variables";
 
initial equation
  status_run = SolarTherm.Utilities.RunSinteringThermalModel(ppath, pname, pfunc, SolarTherm_path, modelica_wd, varnames, vars);

equation
  DNI = data.DNI;
  flux_multiple_off = DNI/1000;
 
  vars = {
      T_sky -273.15, k_s, alpha, eps_r, h_ext, eps,
      T_i_s_HX1 -273.15, T_o_s_HX1 -273.15, T_i_g_HX1 -273.15, d_p_HX1 * 1000, H_HX1, W_HX1, t_wall_HX1 * 100,
      T_i_s_HX2 - 273.15, T_o_s_HX2 - 273.15, T_i_g_HX2 - 273.15, W_HX2, d_p_HX2 * 1000,
      flux_multiple_off
  };
  

end TestSinteringThermalModel;