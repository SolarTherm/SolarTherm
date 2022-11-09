within SolarTherm.Utilities;

function PVArray_func
  	// Units and Constants
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
    
    input Integer N_parallel_final;
    input Integer N_series;
	input Real DHI;
	input Real albedo;
	input SI.Velocity Wspd;
	input SI.Temperature Tdry;
    input SI.Power PV_Target;
    input nSI.Angle_deg azi_s; 
    input nSI.Angle_deg ele_s;
    input nSI.Angle_deg lat;
    input SI.Angle ele_min;
    input Real dni;
    
    // *********** Angles ***************
	input SI.Angle delta;// = sun.dec "Solar declination angle";
	input SI.Angle hra;// "Solar hour angle";
	input SI.Angle zen;// "Solar zenith angle";
	input SI.Angle ele;// "Solar elevation angle";
	input SI.Angle azi;

    output Real P_net;
     
  protected
  // Plant location
  Integer year = 1996 "Simulation year" annotation(
    Dialog(group = "Location"));
  Modelica.SIunits.Length H = 100 "Elevation from sea level" annotation(
    Dialog(group = "Location"));
  
  SI.Angle azis = CV.from_deg(azi_s) "Surface azimuth angle" annotation(
    Dialog(group = "Module geometry and orientation"));
  SI.Angle eles = CV.from_deg(ele_s) "Surface elevation angle" annotation(
    Dialog(group = "Module geometry and orientation"));
  SI.Angle inc = acos(min(max(sin(zen) * cos(azis - azi) * sin(eles) + cos(zen) * cos(eles), -1), 1));
  SI.Angle lat_rad = CV.from_deg(lat);
  SI.Angle d = CN.pi / 180 "Radians to deg conversion factor";
  SI.Angle beta = 30.49 * d;
  
  Real gmetric = (cos(zen) * sin(lat_rad) - sin(delta)) / (sin(zen) * cos(lat_rad));
  
  //SI.Angle azi = if gmetric > 0.999 then CN.pi else SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(delta, hra, lat) + CN.pi;
  
  // Plant design
  Real Cable_Loss = 0.97 "Cable losses" annotation(
    Dialog(group = "Plant design"));
  Real SM1 = 0.9 "Lower safety margin" annotation(
    Dialog(group = "Plant design"));
  Real SM2 = 0.05 "Upper safety margin" annotation(
    Dialog(group = "Plant design"));
  SI.Power f_soil = 0.95 "External shading and soil factor" annotation(
    Dialog(group = "Plant design"));
  
  // Inverter
  Real DC_AC_ratio = 1.2 "DC to AC ratio" annotation(
    Dialog(tab = "Inverter"));
  SI.Voltage V_Inv_min = 780 "Minimum MPPT DC voltage" annotation(
    Dialog(tab = "Inverter"));
  SI.Voltage V_Inv_max = 1000 "Maximum MPPT DC voltage" annotation(
    Dialog(tab = "Inverter"));
  SI.Current I_Inv_max = 586.446805 "Maximum DC current" annotation(
    Dialog(tab = "Inverter"));
  SI.Temp_C Temp_High = 70 "Maximum operating temperature of inverter" annotation(
    Dialog(tab = "Inverter"));
  SI.Temp_C Temp_Low = -10 "Minimum operating temperature of inverter" annotation(
    Dialog(tab = "Inverter"));
  Real Inv_inputs = 1 "Number of MPPT inputs" annotation(
    Dialog(tab = "Inverter"));
  SI.Power P_ac_max_inv = 501760 "Maximum AC rated power" annotation(
    Dialog(tab = "Inverter"));
  SI.Power P_dc_max_inv = 521938 "Maximum DC rated power" annotation(
    Dialog(tab = "Inverter"));
  SI.Power P_s_inv = 4571.3 "Power consumption during operation" annotation(
    Dialog(tab = "Inverter"));
  Real Ci0 = -3.45e-08 "Sandia Inverter model coefficient";
  Real Ci1 = 2.3e-05 "Sandia Inverter model coefficient";
  Real Ci2 = 0.000675 "Sandia Inverter model coefficient";
  Real Ci3 = 0.000753 "Sandia Inverter model coefficient";
  
  // Module and Array geometry
  SI.Length Wp = 0.979496 "Module width" annotation(
    Dialog(group = "Module geometry and orientation"));
  SI.Length Lp = 1.66514 "Module Length" annotation(
    Dialog(group = "Module geometry and orientation"));
  SI.Length Do = 11.101 "Design interrow spacing" annotation(
    Dialog(group = "Module geometry and orientation"));
  
  // Module parameters
  SI.Power P_module = 400.048 "Nameplate DC capacity of module" annotation(
    Dialog(group = "Plant design"));
  SI.Voltage Voc = 85.3 "Open circuit voltage" annotation(
    Dialog(tab = "Module", group = "General"));
  SI.Current Isc = 5.87 "Short circuit current" annotation(
    Dialog(tab = "Module", group = "General"));
  SI.Current Impref = 5.49 "Reference max power current" annotation(
    Dialog(tab = "Module", group = "General"));
  SI.Voltage Vmpref = 72.9 "Reference max power voltage" annotation(
    Dialog(tab = "Module", group = "General"));
  SI.Current Ixref = 5.8483 "Current at half open-circuit voltage" annotation(
    Dialog(tab = "Module", group = "General"));
  SI.Current Ixxref = 4.1329 "Current at half the sum of Voc and Vmp" annotation(
    Dialog(tab = "Module", group = "General"));
  Real fd = 1 "Fraction of diffuse irradiance used by module" annotation(
    Dialog(tab = "Module", group = "General"));
  Real Ncs = 128 "Number of cells in a module in series" annotation(
    Dialog(tab = "Module", group = "General"));
  Real df = 1 "Diode factor" annotation(
    Dialog(tab = "Module", group = "General"));
  // Solar spectral influence on Isc to air mass variation over the day
  Real a0 = 0.9315 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  Real a1 = 0.0597 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  Real a2 = -0.0107 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  Real a3 = 0.0008 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  Real a4 = -2E-05 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  // Optical influences on Isc to solar angle-of-incidence
  Real b0 = 1 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  Real b1 = -0.002438 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  Real b2 = 0.0003103 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  Real b3 = -1.246e-05 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  Real b4 = 2.11E-07 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  Real b5 = -1.36e-09 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  // Irradiance dependent parameters
  Real C0 = 1.0109 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  Real C1 = -0.0109 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  Real C2 = 0.485904 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  Real C3 = -2.188 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  Real C4 = 0.9976 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  Real C5 = 0.0024 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  Real C6 = 1.0785 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  Real C7 = -0.0785 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  // Temperature effect parameters
  SI.Velocity a = -3.47 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  Real b = -0.0594 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  SI.Temp_C Ta = 25 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  SI.Temp_C Tcnd = 3 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  Real TCV = 0.0031 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  Real TCVmp_ref = -0.276 "Voltage temperature coefficient at reference" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  Real Mmp = 0 "Relates TCVmp_ref to effective irradiance" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  Real TCI = 0.000313 annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  Real TCImp = -0.00031 annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  SI.Efficiency L_missmatch = 0.02 "Missmatch DC losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  SI.Efficiency L_diode_desc = 0.005 "Diode desconection losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  SI.Efficiency L_dcwiring = 0.02 "DC wiring losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  SI.Efficiency L_track_err = 0 "Tracking error losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  SI.Efficiency L_name_plate = 0 "Nameplate losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  SI.Efficiency L_ac_wiring = 0.01 "Wiring AC losses" annotation(
    Dialog(tab = "Losses", group = "AC losses"));
  SI.Efficiency L_ac_transf = 0 "Transformer losses" annotation(
    Dialog(tab = "Losses", group = "AC losses"));
  
  Integer N_inv = integer(PV_Target / P_ac_max_inv) "Number of inverters";
  Integer N_module = integer(DC_AC_ratio * N_inv * P_ac_max_inv / P_module) "Number of modules";
  
  //DC to AC ratio needs to be between 0.8 to 1.25 times inverter rated AC power
  SI.Voltage Vmin = Vmpref * (1 - TCV * (Temp_High - 25)) * Cable_Loss * SM1;
  SI.Voltage Vmax = Voc * (1 - TCV * (Temp_Low - 25)) * (1 + SM2);
  SI.Current Isc_max = Isc * (1 + TCI * (Temp_High - 25));
  
  SI.Efficiency L_dc = 1 - (1 - L_missmatch) * (1 - L_diode_desc) * (1 - L_dcwiring) * (1 - L_name_plate);
  SI.Efficiency L_ac = 1 - (1 - L_ac_wiring) * (1 - L_ac_transf);
  
  Real AM = if zen < (-0.5 * CN.pi) or zen > 0.5 * CN.pi then 0 else 1 / (cos(zen) + 0.5057 * (96.08 - zen * 1 / d) ^ (-1.634)) * exp(-0.0001184 * H);
  SI.Irradiance Ib_beta = if inc > 90 * d then 0 elseif inc < (-90 * d) then 0 else dni * cos(inc);
  SI.Irradiance Id_beta = DHI * (1 + cos(beta)) / 2;
  SI.Irradiance Ir_beta = albedo;
  
  // Calculated PV module variables
  SI.Irradiance Gpoa = Ib_beta + Id_beta + Ir_beta;
  SI.Temp_C Tm = Gpoa * exp(a + b * Wspd) + Tdry - 273.15;
  Real X = max(Gpoa / 1000, 0);
  SI.Temp_C Tcell = Tm + X * Tcnd;
  Real dTc = df * CN.k * (Tcell + 273.15) / CN.q;
  Real F1 = a0 + a1 * AM + a2 * AM ^ 2 + a3 * AM ^ 3 + a4 * AM ^ 4;
  Real F2 = b0 + b1 * inc + b2 * inc ^ 2 + b3 * inc ^ 3 + b4 * inc ^ 4 + b5 * inc ^ 5;
  SI.Current Iscf = Isc * F1 * ((Ib_beta * F2 + fd * (Id_beta + Ir_beta)) / 1000) * (1 + TCI * (Tcell - 25));
  Real Ge = max(Iscf / (Isc * (1 + TCI * (Tcell - 25))), 0);
  Real TCVmp = TCVmp_ref + Mmp * (1 - Ge);
  SI.Voltage Vmp = Vmpref + C2 * Ncs * dTc * log(Ge + 1e-6) + C3 * Ncs * (dTc * log(Ge + 1e-6)) ^ 2 + TCVmp * (Tcell - 25);
  SI.Current Imp = Impref * (C0 * Ge + C1 * Ge ^ 2) * (1 + TCI * (Tcell - 25));
  SI.Voltage Vocf = Voc + Ncs * dTc * log(X + 1e-6) + TCV * (Tcell - 25);
  SI.Voltage Vx = 0.5 * Vocf;
  SI.Voltage Vxx = 0.5 * (Vmp + Vocf);
  
  SI.Current Ix = Ixref * (C4 * X + C5 * X ^ 2) * (1 + TCI * (Tcell - 25));
  SI.Current Ixx = Ixxref * (C6 * X + C7 * X ^ 2) * (1 + TCImp * (Tcell - 25));
  SI.Power Pmp = Vmp * Imp;
  
  SI.Length A = Lp * cos(beta);
  //Projected length of panel on ground
  SI.Length D = if ele < ele_min then 0 else Lp * (sin(beta) / tan(ele)) * cos(azi);
  SI.Length dx = if ele < ele_min then 0 else A + D - Do;
  SI.Length h = Lp * sin(beta);
  SI.Length m = if ele < ele_min then 0 else h / tan(ele);
  SI.Length p = if ele < ele_min then 0 else m * sin(azi);
  SI.Length z = if ele < ele_min then 0 else h / (sin(ele) + Modelica.Constants.small);
  SI.Length s = if ele < ele_min then 0 else z * cos(epsilon);
  SI.Angle epsilon = if ele < ele_min then 0 else asin(p / z);
  SI.Angle eta = if ele < ele_min then 0 else asin(h / s);
  SI.Length x = if ele < ele_min then 0 else dx / (cos(beta) * (1 + tan(beta) / tan(eta)));
  
  Real Active_fraction = if x < 0 then 1 elseif x > Wp then 0 else (Wp - x) / Wp;
  
  SI.Power P_mp_as = if Pmp < 0 or Active_fraction < 0 then 0 else Pmp * Active_fraction;
  
  // Plant power and energy
  Real Ai = P_dc_max_inv * (1 + Ci1 * (Vmp - V_Inv_max));
  Real Bi = P_s_inv * (1 + Ci2 * (Vmp - V_Inv_max));
  Real Ci = Ci0 * (1 + Ci1 * (Vmp - V_Inv_max));
  SI.Power P_dc_inv = N_parallel_final * N_series * P_mp_as * f_soil * (1 - L_dc);
  SI.Power P_ac_inv = max(0, (P_ac_max_inv / (Ai - Bi) - Ci * (Ai - Bi)) * (P_dc_inv - Bi) + Ci * (P_dc_inv - Bi) ^ 2);
  SI.Power P_rated = P_module * N_parallel_final * N_series * N_inv;

  SI.Efficiency eta_inv = if P_dc_inv > 1 then max(0, P_ac_inv / P_dc_inv) else 0;
algorithm
  if P_ac_inv > P_ac_max_inv then
    P_net := P_ac_max_inv * N_inv * (1 - L_ac);
  else
    P_net := P_ac_inv * N_inv * (1 - L_ac);
  end if;

end PVArray_func;