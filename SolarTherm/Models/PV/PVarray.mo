within SolarTherm.Models.PV;
model PVarray
	// Units and Constants
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;

	// Plant location
	parameter nSI.Angle_deg lat=-30.2756 "Latitude (+ve North)" annotation(Dialog(group = "Location"));
	parameter Integer year=1996 "Simulation year" annotation(Dialog(group = "Location"));
	parameter Modelica.SIunits.Length H = 100 "Elevation from sea level" annotation(Dialog(group = "Location"));
	final parameter SI.Angle lat_rad = CV.from_deg(lat);
	final parameter SI.Angle d = CN.pi / 180 "Radians to deg conversion factor";
	final parameter SI.Angle beta = 30.49 * d;
	
	
	// Plant design
	parameter Real Cable_Loss = 0.97 "Cable losses" annotation(Dialog(group = "Plant design"));
	parameter Real SM1 = 0.9 "Lower safety margin" annotation(Dialog(group = "Plant design"));
	parameter Real SM2 = 0.05 "Upper safety margin" annotation(Dialog(group = "Plant design"));
	parameter Real PV_Target_default_value = 16558080 "Default dummy value";
	
	
	parameter SI.Power PV_Target = 6e6 "Nameplate capacity of plant" annotation(Dialog(group = "Plant design"));
	parameter SI.Power PV_Target_final = if PV_Target > 5e5 then PV_Target else PV_Target_default_value "PV target can be 0. This variable is to handle PV Target = 0";
	parameter SI.Power f_soil = 0.95 "External shading and soil factor" annotation(Dialog(group = "Plant design"));
	parameter SI.Angle ele_min = 0.0872665 "Minimum elevation angle below which the PV will shut down (in radian)";

	// Inverter
	parameter Real DC_AC_ratio = 1.2 "DC to AC ratio" annotation(Dialog(tab = "Inverter"));
	parameter SI.Voltage V_Inv_min = 780 "Minimum MPPT DC voltage" annotation(Dialog(tab = "Inverter"));
	parameter SI.Voltage V_Inv_max = 1000 "Maximum MPPT DC voltage" annotation(Dialog(tab = "Inverter"));
	parameter SI.Current I_Inv_max = 586.446805 "Maximum DC current" annotation(Dialog(tab = "Inverter"));
	parameter SI.Temp_C Temp_High = 70 "Maximum operating temperature of inverter" annotation(Dialog(tab = "Inverter"));
	parameter SI.Temp_C Temp_Low = -10 "Minimum operating temperature of inverter" annotation(Dialog(tab = "Inverter"));
	parameter Real Inv_inputs = 1 "Number of MPPT inputs" annotation(Dialog(tab = "Inverter"));
	parameter SI.Power P_ac_max_inv = 501760 "Maximum AC rated power" annotation(Dialog(tab = "Inverter"));
	parameter SI.Power P_dc_max_inv = 521938 "Maximum DC rated power" annotation(Dialog(tab = "Inverter"));
	parameter SI.Power P_s_inv = 4571.3 "Power consumption during operation" annotation(Dialog(tab = "Inverter"));
	parameter Real Ci0 = -3.45e-08 "Sandia Inverter model coefficient";
	parameter Real Ci1 = 2.3e-05 "Sandia Inverter model coefficient";
	parameter Real Ci2 = 0.000675 "Sandia Inverter model coefficient";
	parameter Real Ci3 = 0.000753 "Sandia Inverter model coefficient";
	
	parameter Boolean sizing_method_1 = true "Sizing number of inverters";
	final parameter Integer N_inv =integer(PV_Target_final/P_ac_max_inv) "Number of inverters";
	final parameter Integer N_module = integer(DC_AC_ratio*N_inv*P_ac_max_inv/P_module) "Number of modules";
	final parameter Real DC_AC_ratio_calc = (N_module*P_module)/(N_inv*P_ac_max_inv) "Calculated DC to AC ratio"; //DC to AC ratio needs to be between 0.8 to 1.25 times inverter rated AC power
	final parameter Integer Nstr_max = integer(floor(I_Inv_max / Isc)) "Maximum number of strings based on I_Inv_max";
	final parameter Integer N_series_min = integer(floor(V_Inv_min / Voc)) "Minimum number of modules in series";
	final parameter Integer N_series_max = integer(floor(V_Inv_max / Voc)) "Maximum number of modules in series";
	final parameter Integer N_parallel_min = integer(N_module / N_series_max) "Minimum number of strings in parallel";
	final parameter Integer N_parallel_max = integer(N_module / N_series_min) "Maximum number of strings in parallel";
	final parameter SI.Voltage Vmin = Vmpref * (1 - TCV * (Temp_High - 25)) * Cable_Loss * SM1;
	final parameter SI.Voltage Vmax = Voc * (1 - TCV * (Temp_Low - 25)) * (1 + SM2);
	final parameter SI.Current Isc_max = Isc * (1 + TCI * (Temp_High - 25));
	final parameter Integer N_parallel_guess = if Nstr_max > N_parallel_max then N_parallel_max elseif Nstr_max > N_parallel_min then N_parallel_min else Nstr_max;
	final parameter Integer N_series = if Nstr_max > N_parallel_max then N_series_min else N_series_max "Number of modules in series";
	final parameter Integer N_parallel_guess_m1 = N_parallel_guess - 1;
	final parameter Integer N_parallel_guess_m2 = N_parallel_guess - 2;
	final parameter Integer N_parallel_final(fixed=false);

	// Module and Array geometry
	parameter SI.Length Wp = 0.979496 "Module width" annotation(Dialog(group = "Module geometry and orientation"));
	parameter SI.Length Lp = 1.66514 "Module Length" annotation(Dialog(group = "Module geometry and orientation"));
	parameter SI.Length Do = 11.101 "Design interrow spacing" annotation(Dialog(group = "Module geometry and orientation"));
	parameter nSI.Angle_deg azi_s = 180 "Surface azimuth angle" annotation(Dialog(group = "Module geometry and orientation"));
	parameter nSI.Angle_deg ele_s = 30 "Surface elevation angle" annotation(Dialog(group = "Module geometry and orientation"));
	final parameter SI.Angle azis = CV.from_deg(azi_s) "Surface azimuth angle" annotation(Dialog(group = "Module geometry and orientation"));
	final parameter SI.Angle eles = CV.from_deg(ele_s) "Surface elevation angle" annotation(Dialog(group = "Module geometry and orientation"));

	// Module parameters
	parameter SI.Power P_module = 400.048 "Nameplate DC capacity of module" annotation(Dialog(group = "Plant design"));
	parameter SI.Voltage Voc = 85.3 "Open circuit voltage" annotation(Dialog(tab = "Module", group="General"));
	parameter SI.Current Isc = 5.87 "Short circuit current" annotation(Dialog(tab = "Module", group="General"));
	parameter SI.Current Impref = 5.49 "Reference max power current" annotation(Dialog(tab = "Module", group="General"));
	parameter SI.Voltage Vmpref = 72.9 "Reference max power voltage" annotation(Dialog(tab = "Module", group="General"));
	parameter SI.Current Ixref = 5.8483 "Current at half open-circuit voltage" annotation(Dialog(tab = "Module", group = "General"));
	parameter SI.Current Ixxref = 4.1329 "Current at half the sum of Voc and Vmp" annotation(Dialog(tab = "Module", group = "General"));
	parameter Real fd = 1 "Fraction of diffuse irradiance used by module" annotation(Dialog(tab = "Module", group="General"));
	parameter Real Ncs = 128 "Number of cells in a module in series" annotation(Dialog(tab = "Module", group="General"));
	parameter Real df = 1 "Diode factor" annotation(Dialog(tab = "Module", group="General"));

	// Solar spectral influence on Isc to air mass variation over the day
	parameter Real a0 = 0.9315 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
	parameter Real a1 = 0.0597 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
	parameter Real a2 = -0.0107 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
	parameter Real a3 = 0.0008 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));
	parameter Real a4 = -2E-05 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Solar spectral influence on Isc to air mass variation over the day"));

	// Optical influences on Isc to solar angle-of-incidence
	parameter Real b0 = 1 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
	parameter Real b1 = -0.002438 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
	parameter Real b2 = 0.0003103 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
	parameter Real b3 = -1.246e-05 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
	parameter Real b4 = 2.11E-07 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));
	parameter Real b5 = -1.36e-09 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Optical influences on Isc to solar angle-of-incidence"));

	// Irradiance dependent parameters
	parameter Real C0 = 1.0109 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));
	parameter Real C1 = -0.0109 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));
	parameter Real C2 = 0.485904 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));
	parameter Real C3 = -2.188 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));
	parameter Real C4 = 0.9976 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));
	parameter Real C5 = 0.0024 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));
	parameter Real C6 = 1.0785 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));
	parameter Real C7 = -0.0785 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Irradiance dependent parameters"));

	// Temperature effect parameters
	parameter SI.Velocity a = -3.47 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter Real b = -0.0594 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter SI.Temp_C Ta = 25 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter SI.Temp_C Tcnd = 3 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter Real TCV = 0.0031 "Coefficient for SANDIA performance model" annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter Real TCVmp_ref = -0.276 "Voltage temperature coefficient at reference" annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter Real Mmp = 0 "Relates TCVmp_ref to effective irradiance" annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter Real TCI = 0.000313 annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));
	parameter Real TCImp = -0.00031 annotation(Dialog(tab = "Module", group = "Temperature effect parameters"));

	parameter SI.Efficiency L_missmatch = 0.02 "Missmatch DC losses" annotation(Dialog(tab = "Losses", group = "DC losses"));
	parameter SI.Efficiency L_diode_desc = 0.005 "Diode desconection losses" annotation(Dialog(tab = "Losses", group = "DC losses"));
	parameter SI.Efficiency L_dcwiring = 0.02 "DC wiring losses" annotation(Dialog(tab = "Losses", group = "DC losses"));
	parameter SI.Efficiency L_track_err = 0 "Tracking error losses" annotation(Dialog(tab = "Losses", group = "DC losses"));
	parameter SI.Efficiency L_name_plate = 0 "Nameplate losses" annotation(Dialog(tab = "Losses", group = "DC losses"));
	final parameter SI.Efficiency L_dc = 1 - (1-L_missmatch)*(1-L_diode_desc)*(1-L_dcwiring)*(1-L_name_plate);

	parameter SI.Efficiency L_ac_wiring = 0.01 "Wiring AC losses" annotation(Dialog(tab = "Losses", group = "AC losses"));
	parameter SI.Efficiency L_ac_transf = 0 "Transformer losses" annotation(Dialog(tab = "Losses", group = "AC losses"));
	final parameter SI.Efficiency L_ac = 1 - (1-L_ac_wiring)*(1-L_ac_transf);

	SolarTherm.Interfaces.Connectors.SolarPort_a sun
	annotation(Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput DHI
	annotation(Placement(visible = true, transformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput albedo
	annotation(Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput Wspd
	annotation(Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput Tdry
	annotation(Placement(visible = true, transformation(origin = {-100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
    Modelica.Blocks.Interfaces.RealOutput W_net
    annotation(Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
	// *********** Angles ***************
	SI.Angle delta = sun.dec "Solar declination angle";
	SI.Angle hra "Solar hour angle";
	SI.Angle zen "Solar zenith angle";
	SI.Angle azi "Solar azimuth angle";
	SI.Angle ele "Solar elevation angle";
	SI.Angle inc "Solar incidence angle";

	// Calculated solar angles and irradiance variables
	Real AM "Air mass";
	SI.Irradiance Ib_beta;
	SI.Irradiance Id_beta;
	SI.Irradiance Ir_beta;

	// Calculated PV module variables
	SI.Voltage Vmp;
	SI.Current Imp;
	SI.Voltage Vx;
	SI.Current Ix;
	SI.Voltage Vxx;
	SI.Current Ixx;
	SI.Voltage Vocf;
	SI.Current Iscf;
	Real X;
	Real F1;
	Real F2;
	SI.Irradiance Gpoa;
	SI.Temp_C Tm;
	SI.Temp_C Tcell;
	Real dTc;
	Real TCVmp;
	SI.Power Pmp;
	SI.Power P_mp_as;

	// Plant power and energy
	SI.Power P_dc_inv;
	SI.Power P_ac_inv;
	SI.Power P_net;
	SI.Power P_rated;
	SI.Energy E_gen;

	//Array geometry variables
	SI.Length A; //Projected length of panel on ground
	SI.Length D;
	SI.Length dx;
	SI.Length h;
	SI.Length m;
	SI.Length p;
	SI.Length z;
	SI.Length s;
	SI.Angle epsilon;
	SI.Angle eta;
	SI.Length x; //Shaded vertical length of a row
	Real Active_fraction;
	Real gmetric;

	// Inverter DC to AC conversion
	SI.Efficiency eta_inv;
	Real Ai;
	Real Bi;
	Real Ci;
	Real Ge;

	initial equation
	if sizing_method_1 then
	N_parallel_final = if N_parallel_guess < N_parallel_min/N_inv then integer(N_parallel_min/N_inv) elseif N_parallel_guess > N_parallel_max/N_inv then integer(N_parallel_max/N_inv) else N_parallel_guess;
	else
	N_parallel_final = if abs(mod(N_parallel_guess, Inv_inputs)) < 1e-3 then N_parallel_guess elseif abs(mod(N_parallel_guess_m1, Inv_inputs)) < 1e-3 then N_parallel_guess_m1 else N_parallel_guess;
	end if;

	equation

	zen =  SolarTherm.Models.Sources.SolarFunctions.solarZenith(delta, hra, lat);
	ele = SolarTherm.Models.Sources.SolarFunctions.elevationAngle(delta, hra, lat);

	// *************** Incidence angle ***************
	inc = acos(min(max(sin(zen) * cos(azis - azi) * sin(eles) + cos(zen) * cos(eles), -1), 1));

	// Basic solar irradiance equations

	if abs(time - 43200) < 1e-3 then
	hra = 1e-6;
	else
	hra = sun.hra; 
	end if;

	//Checkpoint: Hour angle (hra) for AM
	if zen < - 0.5*CN.pi or zen > 0.5*CN.pi then
	 AM = 0;
	else 
	 AM = 1/(cos(zen) +0.5057*(96.08-zen*1/d)^(-1.634))*exp(-0.0001184*H);
	end if;

	gmetric = ((cos(zen)*sin(lat_rad)-sin(delta))/(sin(zen)*cos(lat_rad)));

	//Checkpoint: Gmetric for Solar azimuth (azi)
	if gmetric > 0.999 then
	azi = CN.pi;
	else
	azi = SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(delta, hra, lat) + CN.pi;
	end if;

	//Checkpoint: Incidence Angle (i) for Ib_beta
	if inc > 90*d then
	Ib_beta = 0;
	elseif inc < -90*d then
	Ib_beta = 0;
	else
	Ib_beta = sun.dni*cos(inc); 
	end if;

	Id_beta = DHI * (1 + cos(beta))/2;
	Ir_beta = albedo;
	Gpoa = Ib_beta + Id_beta + Ir_beta;
	X = max(Gpoa / 1000, 0);

	Tm = (Gpoa * exp(a + b * Wspd) + Tdry - 273.15);
	Tcell = ((Tm) + X*(Tcnd));


	F1 = a0 + a1*AM + a2*(AM^2) + a3*(AM^3) + a4*(AM^4);
	F2 = b0 + b1*inc + b2*(inc^2) + b3*(inc^3) + b4*(inc^4) + b5*(inc^5); 

	Vocf = Voc + Ncs*dTc*log(X+1e-6) + TCV*(Tcell - 25);
	Iscf = Isc*F1*((Ib_beta*F2 + fd*(Id_beta + Ir_beta))/1000)*(1 + TCI*(Tcell - 25));  

	dTc = df*CN.k*(Tcell + 273.15)/CN.q;  
	TCVmp = TCVmp_ref + Mmp*(1 - Ge);

	Ge = max(Iscf/(Isc*(1 + TCI*(Tcell - 25))),0);

	Vmp = Vmpref + C2*Ncs*dTc*log(Ge+1e-6) + C3*Ncs*(dTc*log(Ge+1e-6))^2 + TCVmp*(Tcell - 25);
	Imp = Impref*(C0*Ge + C1*Ge^2)*(1 + TCI*(Tcell - 25));
	Pmp = Vmp*Imp;

	Vx = 0.5*Vocf;
	Vxx = 0.5*(Vmp + Vocf);
	Ix = Ixref*(C4*X + C5*(X^2))*(1 + TCI*(Tcell - 25));
	Ixx = Ixxref*(C6*X + C7*(X^2))*(1 + TCImp*(Tcell - 25));

	P_dc_inv = (N_parallel_final)*N_series*P_mp_as*f_soil*(1-L_dc);

	Ai = P_dc_max_inv*(1 + Ci1*(Vmp - V_Inv_max));
	Bi = P_s_inv *(1 + Ci2*(Vmp - V_Inv_max));
	Ci = Ci0 *(1 + Ci1*(Vmp - V_Inv_max));

	P_ac_inv = max(0,((P_ac_max_inv/(Ai - Bi)) - Ci*(Ai - Bi))*(P_dc_inv-Bi) + Ci*(P_dc_inv-Bi)^2);

	eta_inv = if P_dc_inv > 100 then max(0,P_ac_inv/P_dc_inv) else 0;

	if P_ac_inv > P_ac_max_inv then
	P_net = P_ac_max_inv*N_inv*(1-L_ac);
	else 
	P_net = P_ac_inv*N_inv*(1-L_ac);
	end if;

	//Shading
	A = Lp*cos(beta);
	h = Lp*sin(beta);

	if ele < ele_min then
        D = 0;
        dx = 0;
        m = 0;
        z = 0;
        p = 0;
        epsilon = 0;
        s = 0;
        eta = 0;
        x = 0;
    else 
        D = Lp*(sin(beta)/tan(ele))*cos(azi);
        dx = A + D - Do;
        m = h/tan(ele);
        z = h/(sin(ele)+Modelica.Constants.small) "Modelica.Constants.small gives me a significant number to avoid division by zero";
        p = m*sin(azi);
        epsilon = asin(p/z);
        s = z*cos(epsilon);
        eta = asin(h/s);
        x = dx/(cos(beta)*(1 + tan(beta)/tan(eta)));
	end if;

	//Checkpoint: Shadow length on panel (x) for P_actual
	if x < 0 then
	Active_fraction = 1;
	elseif x > Wp then 
	Active_fraction = 0;
	else 
	Active_fraction =(Wp-x)/Wp;
	end if;

	if Pmp < 0 or Active_fraction < 0 then
	P_mp_as = 0; 
	else  
	P_mp_as = Pmp*Active_fraction;
	end if;

	P_rated = P_module*N_parallel_final*N_series*N_inv; // PV rated power
	W_net = if abs(PV_Target_default_value - PV_Target_final) < 1e-2 then 0.0 else P_net "If PV Target value == PV_Target_default_value then the system is simulating PV = 0 W therefore, the output from PV model is always 0";
	der(E_gen) = W_net;

	annotation(
	Icon(graphics = {
	Polygon(
		origin = {38, 10}, 
		lineColor = {181, 181, 181}, 
		fillColor = {0, 0, 127}, 
		fillPattern = FillPattern.Solid, 
		lineThickness = 0.25, 
		points = {{-66, -10}, {-52, 30}, {48, 30}, {36, -10}, {-66, -10}}), 
	Polygon(
		origin = {18, -10}, 
		lineColor = {181, 181, 181}, 
		fillColor = {0, 0, 127}, 
		fillPattern = FillPattern.Solid, 
		lineThickness = 0.25, points = {{-66, -10}, {-52, 30}, {48, 30}, {36, -10}, {-66, -10}}), 
	Polygon(
		origin = {-2, -30}, 
		lineColor = {181, 181, 181}, 
		fillColor = {0, 0, 127}, 
		fillPattern = FillPattern.Solid, 
		lineThickness = 0.25, 
		points = {{-66, -10}, {-52, 30}, {48, 30}, {36, -10}, {-66, -10}}), 
	Line(origin = {-40, -20}, points = {{-7, -20}, {7, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-20, -20}, points = {{-7, -20}, {7, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {0.1293, -20.1293}, points = {{-7, -20}, {7, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {20.1293, -20.1293}, points = {{-7, -20}, {7, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-40, -10}, points = {{83, 0}, {-17, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-43.3212, -19.4026}, points = {{83, 0}, {-17, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-47.37, -30.69}, points = {{84, 0}, {-17, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-4, 0}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {16, 0}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {36, 0}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {56, 0}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-19.5, 12}, points = {{83, 0}, {-17, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-22.5, 2.6}, points = {{83, 0}, {-17.5, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-23.24, -9.4}, points = {{80.5, 0}, {66.5, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-2.39986, 22.9063}, points = {{83, 0}, {-17.5, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {0.60014, 32.3063}, points = {{83, 0}, {-17, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {16.1001, 20.3063}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {36.1001, 20.3063}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {56.1001, 20.3063}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {76.1001, 20.3063}, points = {{-17, 0}, {-10, 20}}, color = {213, 213, 213}, thickness = 0.25), 
	Line(origin = {-3.13986, 10.9063}, points = {{80.5, 0}, {66.5, 0}}, color = {213, 213, 213}, thickness = 0.25), 
	Text(origin = {8, -76}, extent = {{-100, 16}, {100, -16}}, lineColor={0,0,255}, textString = "%name")}, 
	coordinateSystem(initialScale = 0.1)));
end PVarray;
