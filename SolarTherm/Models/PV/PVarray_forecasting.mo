within SolarTherm.Models.PV;

model PVarray_forecasting
  /*
    This model is to foreast the output of the PV array for the next forecast horizon. 
    It accepts the weather file data and self-interpolate the weather data to construct the forecast array
    */
  //************** Importing some stuff
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  //************** Weather file -- overridden by the system level model
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/dagget_ca.motab") "[SYS] Weather file";
  parameter nSI.Time_hour t_zone = -8 "[SYS] Local time zone (UTC=0) TMY2 Dagget 1967 Location ID 23161";
  //************** Design parameters given by the system model
  parameter Integer N_parallel_final = 136;
  parameter Integer N_series = 11;
  parameter Integer n_horizon = 24 "Forecast horizon";
  parameter SI.Power PV_Target = 2e8 "PV array nameplate [W]";
  parameter nSI.Angle_deg azi_s = 180;
  parameter nSI.Angle_deg ele_s = 30;
  parameter nSI.Angle_deg lat = 34.8667;
  parameter nSI.Angle_deg lon = -116.783;
  parameter SI.Angle ele_min = 0.0872665;
  //************* Constants of the PV array
  // Plant location
  parameter Integer year = 1967 "Simulation year";
  parameter Modelica.SIunits.Length H = 100 "Elevation from sea level" annotation(
    Dialog(group = "Location"));
  parameter SI.Angle lat_rad = CV.from_deg(lat);
  parameter SI.Angle d = CN.pi / 180 "Radians to deg conversion factor";
  parameter SI.Angle beta = 30.49 * d;
  // Plant design
  parameter Real Cable_Loss = 0.97 "Cable losses" annotation(
    Dialog(group = "Plant design"));
  parameter Real SM1 = 0.9 "Lower safety margin" annotation(
    Dialog(group = "Plant design"));
  parameter Real SM2 = 0.05 "Upper safety margin" annotation(
    Dialog(group = "Plant design"));
  parameter SI.Power f_soil = 0.95 "External shading and soil factor" annotation(
    Dialog(group = "Plant design"));
  // Inverter parameters -- based on SANDIA
  parameter Real DC_AC_ratio = 1.2 "DC to AC ratio" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Voltage V_Inv_min = 780 "Minimum MPPT DC voltage" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Voltage V_Inv_max = 1000 "Maximum MPPT DC voltage" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Current I_Inv_max = 586.446805 "Maximum DC current" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Temp_C Temp_High = 70 "Maximum operating temperature of inverter" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Temp_C Temp_Low = -10 "Minimum operating temperature of inverter" annotation(
    Dialog(tab = "Inverter"));
  parameter Real Inv_inputs = 1 "Number of MPPT inputs" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Power P_ac_max_inv = 501760 "Maximum AC rated power" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Power P_dc_max_inv = 521938 "Maximum DC rated power" annotation(
    Dialog(tab = "Inverter"));
  parameter SI.Power P_s_inv = 4571.3 "Power consumption during operation" annotation(
    Dialog(tab = "Inverter"));
  parameter Real Ci0 = -3.45e-08 "Sandia Inverter model coefficient";
  parameter Real Ci1 = 2.3e-05 "Sandia Inverter model coefficient";
  parameter Real Ci2 = 0.000675 "Sandia Inverter model coefficient";
  parameter Real Ci3 = 0.000753 "Sandia Inverter model coefficient";
  //****************** Module parameters
  // Module and Array geometry
  parameter SI.Length Wp = 0.979496 "Module width" annotation(
    Dialog(group = "Module geometry and orientation"));
  parameter SI.Length Lp = 1.66514 "Module Length" annotation(
    Dialog(group = "Module geometry and orientation"));
  parameter SI.Length Do = 11.101 "Design interrow spacing" annotation(
    Dialog(group = "Module geometry and orientation"));
  parameter SI.Angle azis = CV.from_deg(azi_s) "Surface azimuth angle" annotation(
    Dialog(group = "Module geometry and orientation"));
  parameter SI.Angle eles = CV.from_deg(ele_s) "Surface elevation angle" annotation(
    Dialog(group = "Module geometry and orientation"));
  // Module parameters
  parameter SI.Power P_module = 400.048 "Nameplate DC capacity of module" annotation(
    Dialog(group = "Plant design"));
  parameter SI.Voltage Voc = 85.3 "Open circuit voltage" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter SI.Current Isc = 5.87 "Short circuit current" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter SI.Current Impref = 5.49 "Reference max power current" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter SI.Voltage Vmpref = 72.9 "Reference max power voltage" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter SI.Current Ixref = 5.8483 "Current at half open-circuit voltage" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter SI.Current Ixxref = 4.1329 "Current at half the sum of Voc and Vmp" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter Real fd = 1 "Fraction of diffuse irradiance used by module" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter Real Ncs = 128 "Number of cells in a module in series" annotation(
    Dialog(tab = "Module", group = "General"));
  parameter Real df = 1 "Diode factor" annotation(
    Dialog(tab = "Module", group = "General"));
  // Solar spectral influence on Isc to air mass variation over the day
  parameter Real a0 = 0.9315 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  parameter Real a1 = 0.0597 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  parameter Real a2 = -0.0107 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  parameter Real a3 = 0.0008 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  parameter Real a4 = -2E-05 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
  // Optical influences on Isc to solar angle-of-incidence
  parameter Real b0 = 1 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  parameter Real b1 = -0.002438 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  parameter Real b2 = 0.0003103 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  parameter Real b3 = -1.246e-05 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  parameter Real b4 = 2.11E-07 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  parameter Real b5 = -1.36e-09 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
  // Irradiance dependent parameters
  parameter Real C0 = 1.0109 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  parameter Real C1 = -0.0109 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  parameter Real C2 = 0.485904 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  parameter Real C3 = -2.188 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  parameter Real C4 = 0.9976 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  parameter Real C5 = 0.0024 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  parameter Real C6 = 1.0785 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  parameter Real C7 = -0.0785 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Irradiance dependent parameters"));
  // Temperature effect parameters
  parameter SI.Velocity a = -3.47 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter Real b = -0.0594 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter SI.Temp_C Ta = 25 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter SI.Temp_C Tcnd = 3 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter Real TCV = 0.0031 "Coefficient for SANDIA performance model" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter Real TCVmp_ref = -0.276 "Voltage temperature coefficient at reference" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter Real Mmp = 0 "Relates TCVmp_ref to effective irradiance" annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter Real TCI = 0.000313 annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter Real TCImp = -0.00031 annotation(
    Dialog(tab = "Module", group = "Temperature effect parameters"));
  parameter SI.Efficiency L_missmatch = 0.02 "Missmatch DC losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  parameter SI.Efficiency L_diode_desc = 0.005 "Diode desconection losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  parameter SI.Efficiency L_dcwiring = 0.02 "DC wiring losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  parameter SI.Efficiency L_track_err = 0 "Tracking error losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  parameter SI.Efficiency L_name_plate = 0 "Nameplate losses" annotation(
    Dialog(tab = "Losses", group = "DC losses"));
  parameter SI.Efficiency L_dc = 1 - (1 - L_missmatch) * (1 - L_diode_desc) * (1 - L_dcwiring) * (1 - L_name_plate);
  parameter SI.Efficiency L_ac_wiring = 0.01 "Wiring AC losses" annotation(
    Dialog(tab = "Losses", group = "AC losses"));
  parameter SI.Efficiency L_ac_transf = 0 "Transformer losses" annotation(
    Dialog(tab = "Losses", group = "AC losses"));
  parameter SI.Efficiency L_ac = 1 - (1 - L_ac_wiring) * (1 - L_ac_transf);
  //*********************** Number of units - N_series and N_parallel are given during the initialisation of the model
  parameter Integer N_inv = integer(PV_Target / P_ac_max_inv) "Number of inverters";
  parameter Integer N_module = integer(DC_AC_ratio * N_inv * P_ac_max_inv / P_module) "Number of modules";
  parameter SI.Voltage Vmin = Vmpref * (1 - TCV * (Temp_High - 25)) * Cable_Loss * SM1;
  parameter SI.Voltage Vmax = Voc * (1 - TCV * (Temp_Low - 25)) * (1 + SM2);
  parameter SI.Current Isc_max = Isc * (1 + TCI * (Temp_High - 25));
  //************** Weather table
  Modelica.Blocks.Types.ExternalCombiTable1D wea_table = Modelica.Blocks.Types.ExternalCombiTable1D(tableName = "data", fileName = wea_file, table = fill(0.0, 0, 2), columns = 1:11, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
  //************** Starting of the forecasting (beginning of the loop)
  Real t0 = 0 "Given by the system level model";
  Real t_forecast[n_horizon];
  //************** Weather variables and solar angles array -- given by the system model
  Real DHI[n_horizon] "Array to store DHI forecast";
  Real albedo[n_horizon] "Array to store albedo forecast";
  SI.Velocity Wspd[n_horizon] "Array to store wind speed forecast";
  SI.Temperature Tdry[n_horizon] "Array to store temperature forecast";
  Real dni[n_horizon] "Array to store DNI forecast";
  SI.Angle delta[n_horizon] "Array to store solar declination angle forecast";
  SI.Angle hra[n_horizon] "Array to store solar hour angle forecast";
  SI.Angle hra_intermediate[n_horizon] "Array to store solar hour angle forecast";
  SI.Angle zen[n_horizon]"Array to store solar zenith angle forecast";
  SI.Angle azi[n_horizon] "Array to store solar azimuth angle forecast";
  SI.Angle ele[n_horizon] "Array to store solar elevation angle forecast";
  
  //************** Calculated solar angles and irradiance variables
  SI.Angle inc[n_horizon] "Solar incidence angle";
  Real AM[n_horizon] "Atmospheric clearness";
  SI.Irradiance Ib_beta[n_horizon];
  SI.Irradiance Id_beta[n_horizon];
  SI.Irradiance Ir_beta[n_horizon];
  //************** Calculated PV module variables
  SI.Voltage Vmp[n_horizon];
  SI.Current Imp[n_horizon];
  SI.Voltage Vx[n_horizon];
  SI.Current Ix[n_horizon];
  SI.Voltage Vxx[n_horizon];
  SI.Current Ixx[n_horizon];
  SI.Voltage Vocf[n_horizon];
  SI.Current Iscf[n_horizon];
  Real X[n_horizon];
  Real F1[n_horizon];
  Real F2[n_horizon];
  SI.Irradiance Gpoa[n_horizon];
  SI.Temp_C Tm[n_horizon];
  SI.Temp_C Tcell[n_horizon];
  Real dTc[n_horizon];
  Real TCVmp[n_horizon];
  SI.Power Pmp[n_horizon];
  SI.Power P_mp_as[n_horizon];
  //************** Plant power and energy
  SI.Power P_dc_inv[n_horizon];
  SI.Power P_ac_inv[n_horizon];
  SI.Power P_rated[n_horizon] "PV rated power";
  //************** Array geometry variables
  SI.Length A[n_horizon];
  SI.Length D[n_horizon];
  SI.Length dx[n_horizon];
  SI.Length h[n_horizon];
  SI.Length m[n_horizon];
  SI.Length p[n_horizon];
  SI.Length z[n_horizon];
  SI.Length s[n_horizon];
  SI.Angle epsilon[n_horizon];
  SI.Angle eta[n_horizon];
  SI.Length x[n_horizon];
  Real Active_fraction[n_horizon];
  Real gmetric[n_horizon];
  //************** Inverted DC to AC conversion variables
  SI.Efficiency eta_inv[n_horizon];
  Real Ai[n_horizon];
  Real Bi[n_horizon];
  Real Ci[n_horizon];
  Real Ge[n_horizon];
  //************** Power array -- output
  Real P_net[n_horizon] "Array to store PV output forecast";
  
equation
  for i in 1:n_horizon loop
//************** ith time in seconds
    if t0 + (i - 1) * 3600 < 3.1536e7 then
      t_forecast[i] = t0 + (i - 1) * 3600;
    else
      t_forecast[i] = t0 + (i - 1) * 3600 - 3.1536e7;
    end if;
    if gmetric[i] > 0.999 then
        azi[i] = CN.pi;
	else
        azi[i] = SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(delta[i], hra[i], lat) + CN.pi;
	end if;
    
//************** Weather variables and solar angles array -- looped over the wea_table
    
    DHI[i] = SolarTherm.Utilities.DHI_horizon(t_forecast[i], wea_table);
    albedo[i] = SolarTherm.Utilities.Albedo_horizon(t_forecast[i], wea_table);
    Wspd[i] = SolarTherm.Utilities.wind_speed_horizon(t_forecast[i], wea_table);
    Tdry[i] = Modelica.SIunits.Conversions.from_degC(
        SolarTherm.Utilities.Tdry_horizon(t_forecast[i], wea_table)
    );
    dni[i] = SolarTherm.Utilities.DNI_horizon(t_forecast[i], wea_table);
    (delta[i], hra_intermediate[i]) = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm(t_forecast[i], lon, lat, t_zone, year);
    if abs(t_forecast[i] - 43200) < 1e-3 then
      hra[i] = 1e-6;
    else
      hra[i] = hra_intermediate[i];
    end if;
    zen[i] = SolarTherm.Models.Sources.SolarFunctions.solarZenith(delta[i], hra[i], lat);
    ele[i] = SolarTherm.Models.Sources.SolarFunctions.elevationAngle(delta[i], hra[i], lat);
    
  
//************** Calculated solar angles and irradiance variables
    inc[i] = acos(min(max(sin(zen[i]) * cos(azis - azi[i]) * sin(eles) + cos(zen[i]) * cos(eles), -1), 1));
    AM[i] = if zen[i] < (-0.5 * CN.pi) or zen[i] > 0.5 * CN.pi then 0 else 1 / (cos(zen[i]) + 0.5057 * (96.08 - zen[i] * 1 / d) ^ (-1.634)) * exp(-0.0001184 * H);
    if inc[i] > 90 * d then
      Ib_beta[i] = 0;
    elseif inc[i] < (-90 * d) then
      Ib_beta[i] = 0;
    else
      Ib_beta[i] = dni[i] * cos(inc[i]);
    end if;
    Id_beta[i] = DHI[i] * (1 + cos(beta)) / 2;
    Ir_beta[i] = albedo[i];
    
    //************** Calculated PV module variables
    Vmp[i] = Vmpref + C2 * Ncs * dTc[i] * log(Ge[i] + 1e-6) + C3 * Ncs * (dTc[i] * log(Ge[i] + 1e-6)) ^ 2 + TCVmp[i] * (Tcell[i] - 25);
    Imp[i] = Impref * (C0 * Ge[i] + C1 * Ge[i] ^ 2) * (1 + TCI * (Tcell[i] - 25));
    Vx[i] = 0.5 * Vocf[i];
    Ix[i] = Ixref * (C4 * X[i] + C5 * X[i] ^ 2) * (1 + TCI * (Tcell[i] - 25));
    Vxx[i] = 0.5 * (Vmp[i] + Vocf[i]);
    Ixx[i] = Ixxref * (C6 * X[i] + C7 * X[i] ^ 2) * (1 + TCImp * (Tcell[i] - 25));
    Vocf[i] = Voc + Ncs * dTc[i] * log(X[i] + 1e-6) + TCV * (Tcell[i] - 25);
    Iscf[i] = Isc * F1[i] * ((Ib_beta[i] * F2[i] + fd * (Id_beta[i] + Ir_beta[i])) / 1000) * (1 + TCI * (Tcell[i] - 25));
    X[i] = max(Gpoa[i] / 1000, 0);
    F1[i] = a0 + a1 * AM[i] + a2 * AM[i] ^ 2 + a3 * AM[i] ^ 3 + a4 * AM[i] ^ 4;
    F2[i] = b0 + b1 * inc[i] + b2 * inc[i] ^ 2 + b3 * inc[i] ^ 3 + b4 * inc[i] ^ 4 + b5 * inc[i] ^ 5;
    Gpoa[i] = Ib_beta[i] + Id_beta[i] + Ir_beta[i];
    Tm[i] = Gpoa[i] * exp(a + b * Wspd[i]) + Tdry[i] - 273.15;
    Tcell[i] = Tm[i] + X[i] * Tcnd;
    dTc[i] = df * CN.k * (Tcell[i] + 273.15) / CN.q;
    TCVmp[i] = TCVmp_ref + Mmp * (1 - Ge[i]);
    Pmp[i] = Vmp[i] * Imp[i];
    if Pmp[i] < 0 or Active_fraction[i] < 0 then
      P_mp_as[i] = 0;
    else
      P_mp_as[i] = Pmp[i] * Active_fraction[i];
    end if;
//************** Plant power and energy
    P_dc_inv[i] = N_parallel_final * N_series * P_mp_as[i] * f_soil * (1 - L_dc);
    P_ac_inv[i] = max(0, (P_ac_max_inv / (Ai[i] - Bi[i]) - Ci[i] * (Ai[i] - Bi[i])) * (P_dc_inv[i] - Bi[i]) + Ci[i] * (P_dc_inv[i] - Bi[i]) ^ 2);
    P_rated[i] = P_module * N_parallel_final * N_series * N_inv;
//************** Array geometry variables
    A[i] = Lp * cos(beta);
    D[i] = if ele[i] < ele_min then 0 else Lp * (sin(beta) / tan(ele[i])) * cos(azi[i]);
    dx[i] = if ele[i] < ele_min then 0 else A[i] + D[i] - Do;
    h[i] = Lp * sin(beta);
    m[i] = if ele[i] < ele_min then 0 else h[i] / tan(ele[i]);
    p[i] = if ele[i] < ele_min then 0 else m[i] * sin(azi[i]);
    z[i] = if ele[i] < ele_min then 0 else h[i] / (sin(ele[i]) + Modelica.Constants.small);
    s[i] = if ele[i] < ele_min then 0 else z[i] * cos(epsilon[i]);
    epsilon[i] = if ele[i] < ele_min then 0 else asin(p[i] / z[i]);
    eta[i] = if ele[i] < ele_min then 0 else asin(h[i] / s[i]);
    x[i] = if ele[i] < ele_min then 0 else dx[i] / (cos(beta) * (1 + tan(beta) / tan(eta[i])));
    Active_fraction[i] = if x[i] < 0 then 1 elseif x[i] > Wp then 0 else (Wp - x[i]) / Wp;
    gmetric[i] = (cos(zen[i]) * sin(lat_rad) - sin(delta[i])) / (sin(zen[i]) * cos(lat_rad));
//************** Inverted DC to AC conversion variables
    eta_inv[i] = if P_dc_inv[i] > 1 then max(0, P_ac_inv[i] / P_dc_inv[i]) else 0;
    Ai[i] = P_dc_max_inv * (1 + Ci1 * (Vmp[i] - V_Inv_max));
    Bi[i] = P_s_inv * (1 + Ci2 * (Vmp[i] - V_Inv_max));
    Ci[i] = Ci0 * (1 + Ci1 * (Vmp[i] - V_Inv_max));
    Ge[i] = max(Iscf[i] / (Isc * (1 + TCI * (Tcell[i] - 25))), 0);
    if P_ac_inv[i] > P_ac_max_inv then
      P_net[i] = P_ac_max_inv * N_inv * (1 - L_ac);
    else
      P_net[i] = P_ac_inv[i] * N_inv * (1 - L_ac);
    end if;
  
  end for;
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end PVarray_forecasting;