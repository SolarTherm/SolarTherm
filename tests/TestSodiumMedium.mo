block TestSodiumMedium

	import SolarTherm.Media.Sodium.Sodium_utilities.*;
  
	// Experimental data for sodium:
	
	parameter Modelica.SIunits.Temperature T_table[12] = {400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500} "Temperature";
  
    parameter Modelica.Media.Interfaces.Types.AbsolutePressure p_table[12] = {0.000180000000000000, 0.0899000000000000, 5.57000000000000, 105, 941, 5150, 20000, 60200, 150400, 325700, 629800, 1113000} "Pressure";
    
	parameter Modelica.SIunits.SpecificEnthalpy h_table[12] = 1000 * {142.091821266789, 277.091821266789, 409.091821266789, 537.091821266789, 664.091821266789, 790.091821266789, 915.091821266789, 1041.09182126679, 1168.09182126679, 1297.09182126679, 1429.09182126679,	1566.09182126679} "Specific enthalpy";
  
    parameter Modelica.SIunits.SpecificEnthalpy h_fg_table[12] = 1000 * {4510, 4435, 4358, 4279, 4197, 4112, 4025, 3933, 3838, 3738, 3633, 3523} "Specific vapourisation enthalpy";
  
    parameter Modelica.SIunits.Density rho_table[12] = {919, 897, 874, 852, 828, 805, 781, 756, 732, 706, 680, 653} "Liquid density";
    
    parameter Modelica.SIunits.Density rho_v_table[12] = {0.000000001240000, 0.000000503000000, 0.000000263000000, 0.000431000000000, 0.003430000000000, 0.017000000000000, 0.060300000000000, 0.168000000000000, 0.394000000000000, 0.805000000000000, 1.480000000000000, 2.500000000000000} "Vapour denisty";
    
  	parameter Modelica.SIunits.SpecificEntropy s_table[12] = {409.288172114454, 711.191583903677, 951.395928268301, 1150.06752013836, 1319.38932066896, 1467.27631559499, 1599.15808870818, 1718.91979042996, 1829.43669140614, 1932.89604666356, 2031.00026984082, 2125.10030319536} "Specific entropy";
  
	parameter Modelica.SIunits.SpecificHeatCapacity cp_table[12] = {1372, 1334, 1301, 1277, 1260, 1252, 1252, 1261, 1279, 1305, 1340, 1384} "Specific heat at constant pressure";
	
	parameter Modelica.SIunits.SpecificHeatCapacity cv_table[12] = {1241, 1170, 1104, 1045, 994, 951, 914, 885, 862, 844, 830, 819} "Specific heat at constant volume";

	parameter Modelica.SIunits.RatioOfSpecificHeatCapacities gamma_table[12] = cp_table ./ cv_table "Isentropic exponent";
  
	parameter Modelica.SIunits.DynamicViscosity eta_table[12] = {0.000599, 0.000415, 0.000321, 0.000264, 0.000227, 0.000201, 0.000181, 0.000166, 0.000153, 0.000143, 0.000135, 0.000128} "Liquid dynamic viscosity";

	parameter Modelica.SIunits.DynamicViscosity eta_v_table[10] = {1.48000000000000e-05, 1.66000000000000e-05, 1.82700000000000e-05, 2.01000000000000e-05, 2.21100000000000e-05, 2.39800000000000e-05, 2.57700000000000e-05, 2.76300000000000e-05, 2.93800000000000e-05, 3.11700000000000e-05} "Vapour dynamic viscosity";
		
	parameter Modelica.SIunits.ThermalConductivity lambda_table[12] = {87.22, 80.09, 73.7, 68, 62.9, 58.34, 54.24, 50.54, 47.16, 44.03, 41.08, 38.24} "Liquid thermal conductivity";
	
	parameter Modelica.SIunits.ThermalConductivity lambda_v_table[9] = {0.0277000000000000, 0.0343000000000000, 0.0406000000000000, 0.0455000000000000, 0.0492000000000000, 0.0522000000000000, 0.0547000000000000, 0.0570000000000000, 0.0592000000000000} "Vapour thermal conductivity";

	parameter Modelica.SIunits.VelocityOfSound vs_table[12] = {2496, 2450, 2402, 2353, 2302, 2249, 2194, 2137, 2079, 2018, 1956, 1892} "Velocity of sound";
	
  
	// Correlations for the sodium thermo-physical properties:
	
	Modelica.SIunits.SpecificHeatCapacity cp_T_test[12] "Specific heat at constant pressure";
	Real error_cp_T_test[12];
	Real err_avg_cp_T_test;
	
	Modelica.SIunits.SpecificHeatCapacity cv_T_test[12] "Specific heat at constant volume";
	Real error_cv_T_test[12];
	Real err_avg_cv_T_test; 
	
	Modelica.SIunits.RatioOfSpecificHeatCapacities gamma_T_test[12] "Isentropic exponent";
	Real error_gamma_T_test[12];
	Real err_avg_gamma_T_test;

    Modelica.SIunits.DynamicViscosity eta_T_test[12] "Liquid dynamic viscosity";
    Real error_eta_T_test[12];
    Real err_avg_eta_T_test;
    
    Modelica.SIunits.DynamicViscosity eta_v_T_test[10] "Vapour dynamic viscosity";
    Real error_eta_v_T_test[10];
    Real err_avg_eta_v_T_test;
    
    Modelica.SIunits.SpecificEnthalpy h_rho_test[12] "Specific enthapy";
	Real error_h_rho_test[12];
	Real err_avg_h_rho_test;
    
    Modelica.SIunits.SpecificEnthalpy h_fg_T_test[12] "Specific enthapy";
    Real error_h_fg_T_test[12];
    Real err_avg_h_fg_T_test;
    
    Modelica.SIunits.SpecificEnthalpy h_s_test[12] "Specific enthapy";
    Real error_h_s_test[12];
    Real err_avg_h_s_test;
    
    Modelica.SIunits.SpecificEnthalpy h_T_test[12] "Specific enthapy";
    Real error_h_T_test[12];
    Real err_avg_h_T_test;
    
    Modelica.SIunits.ThermalConductivity lamda_T_test[12] "Thermal conductivity";
    Real error_lamda_T_test[12];
    Real err_avg_lamda_T_test;
    
    Modelica.SIunits.ThermalConductivity lamda_v_T_test[9] "Thermal conductivity";
    Real error_lamda_v_T_test[9];
    Real err_avg_lamda_v_T_test;
       
    Modelica.Media.Interfaces.Types.AbsolutePressure p_rho_test[8] "Pressure";
    Real error_p_rho_test[8];
    Real err_avg_p_rho_test;
    
    Modelica.Media.Interfaces.Types.AbsolutePressure p_v_T_test[12] "Pressure";
    Real error_p_v_T_test[12];
    Real err_avg_p_v_T_test;
    
    Modelica.SIunits.Density rho_T_test[12] "Density";
    Real error_rho_T_test[12];
    Real err_avg_rho_T_test;
    
    Modelica.SIunits.Density rho_v_T_test[6] "Density";
    Real error_rho_v_T_test[6];
    Real err_avg_rho_v_T_test;
        
    Modelica.SIunits.SpecificEntropy s_rho_test[12] "Specific entropy";
    Real error_s_rho_test[12];
    Real err_avg_s_rho_test;
    
    Modelica.SIunits.SpecificEntropy s_T_test[12] "Specific entropy";
    Real error_s_T_test[12];
    Real err_avg_s_T_test;
    
    Modelica.SIunits.Temperature T_h_test[12] "Temperature";
    Real error_T_h_test[12];
    Real err_avg_T_h_test;
    
    Modelica.SIunits.Temperature T_p_test[12] "Temperature";
    Real error_T_p_test[12];
    Real err_avg_T_p_test;
    
    Modelica.SIunits.Temperature T_s_test[12] "Temperature";
    Real error_T_s_test[12];
    Real err_avg_T_s_test;
    
    Modelica.SIunits.VelocityOfSound vs_T_test[12] "Velocity of sound";
    Real error_vs_T_test[12];
    Real err_avg_vs_T_test;
       
equation
	
	cp_T_test = cp_T(T_table);
	error_cp_T_test = 100 * (abs(cp_T_test .- cp_table) ./ cp_table);
	err_avg_cp_T_test = sum(error_cp_T_test) / size(error_cp_T_test,1);
  
	cv_T_test = cv_T(T_table);
	error_cv_T_test = 100 * (abs(cv_T_test .- cv_table) ./ cv_table);
	err_avg_cv_T_test = sum(error_cv_T_test) / size(error_cv_T_test,1);
	
	gamma_T_test = cp_T(T_table) ./ cv_T(T_table);
	error_gamma_T_test = 100 * (abs(gamma_T_test .- gamma_table) ./ gamma_table);
	err_avg_gamma_T_test = sum(error_gamma_T_test) / size(error_gamma_T_test,1);
	  
    eta_T_test = eta_T(T_table);
    error_eta_T_test = 100 * (abs(eta_T_test .- eta_table) ./ eta_table);
	err_avg_eta_T_test = sum(error_eta_T_test) / size(error_eta_T_test,1);
	
	eta_v_T_test = eta_v_T(T_table[3:12]);
    error_eta_v_T_test = 100 * (abs(eta_v_T_test .- eta_v_table) ./ eta_v_table);
	err_avg_eta_v_T_test = sum(error_eta_v_T_test) / size(error_eta_v_T_test,1);

	h_rho_test = h_rho(rho_table);
	error_h_rho_test = 100 * (abs(h_rho_test .- h_table) ./ h_table);
	err_avg_h_rho_test = sum(error_h_rho_test) / size(error_h_rho_test,1);
  
    h_fg_T_test = h_fg_T(T_table);
    error_h_fg_T_test = 100 * (abs(h_fg_T_test .- h_fg_table) ./ h_fg_table);
    err_avg_h_fg_T_test = sum(error_h_fg_T_test) / size(error_h_fg_T_test,1);
    
    h_s_test = h_s(s_table);
    error_h_s_test = 100 * (abs(h_s_test .- h_table) ./ h_table);
    err_avg_h_s_test = sum(error_h_s_test) / size(error_h_s_test,1);
    
    h_T_test = h_T(T_table);
    error_h_T_test = 100 * (abs(h_T_test .- h_table) ./ h_table);
    err_avg_h_T_test = sum(error_h_T_test) / size(error_h_T_test,1);
    
    lamda_T_test = lamda_T(T_table);
    error_lamda_T_test = 100 * (abs(lamda_T_test .- lambda_table) ./ h_table);
    err_avg_lamda_T_test = sum(error_lamda_T_test) / size(error_lamda_T_test,1);
    
    lamda_v_T_test = lamda_v_T(T_table[4:12]);
    error_lamda_v_T_test = 100 * (abs(lamda_v_T_test .- lambda_v_table) ./ lambda_v_table);
    err_avg_lamda_v_T_test = sum(error_lamda_v_T_test) / size(error_lamda_v_T_test,1);
    
    p_rho_test = p_rho(rho_table[5:12]);
    error_p_rho_test = 100 * (abs(p_rho_test .- p_table[5:12]) ./ p_table[5:12]);
    err_avg_p_rho_test = sum(error_p_rho_test) / size(error_p_rho_test,1);
    
    p_v_T_test = p_v(T_table);
    error_p_v_T_test = 100 * (abs(p_v_T_test .- p_table) ./ p_table);
    err_avg_p_v_T_test = sum(error_p_v_T_test) / size(error_p_v_T_test,1);
    
    rho_T_test = rho_T(T_table);
    error_rho_T_test = 100 * (abs(rho_T_test .- rho_table) ./ rho_table);
    err_avg_rho_T_test = sum(error_rho_T_test) / size(error_rho_T_test,1);
    
    rho_v_T_test = rho_v_T(T_table[5:10]);
    error_rho_v_T_test = 100 * (abs(rho_v_T_test .- rho_v_table[5:10]) ./ rho_v_table[5:10]);
    err_avg_rho_v_T_test = sum(error_rho_v_T_test) / size(error_rho_v_T_test,1);
    
    s_rho_test = s_rho(rho_table);
    error_s_rho_test = 100 * (abs(s_rho_test .- s_table) ./ s_table);
    err_avg_s_rho_test = sum(error_s_rho_test) / size(error_s_rho_test,1);
    
    s_T_test = s_T(T_table);
    error_s_T_test = 100 * (abs(s_T_test .- s_table) ./ s_table);
    err_avg_s_T_test = sum(error_s_T_test) / size(error_s_T_test,1);
    
    T_h_test = T_h(h_table);
    error_T_h_test = 100 * (abs(T_h_test .- T_table) ./ T_table);
    err_avg_T_h_test = sum(error_T_h_test) / size(error_T_h_test,1);
    
    T_p_test = T_p(p_table);
    error_T_p_test = 100 * (abs(T_p_test .- T_table) ./ T_table);
    err_avg_T_p_test = sum(error_T_p_test) / size(error_T_p_test,1);
    
    T_s_test = T_s(s_table);
    error_T_s_test = 100 * (abs(T_s_test .- T_table) ./ T_table);
    err_avg_T_s_test = sum(error_T_s_test) / size(error_T_s_test,1);
    
    vs_T_test = vs_T(T_table);
    error_vs_T_test = 100 * (abs(vs_T_test .- vs_table) ./ vs_table);
    err_avg_vs_T_test = sum(error_vs_T_test) / size(error_vs_T_test,1);
    
    
    annotation (Documentation(info="<html>
    	<p>
    	This script was developed in order to test the accuracy of the correlations used to determine the thermo-physical properties of <b>liquid sodium</b>. The experimental data for liquid sodium have been taken from <u>Ref. ANL/RE-95/2</u>. The Thermo-physical properties of liquid sodium were estimated from some correlations reported in <u>Ref. ANL/RE-95/2</u> as well as some obtained through curve fitting in MATLAB:
        </p>
        </html>", revisions="<html>
        <p> Developed by <b>Ali Shirazi</b> on May 15, 2017</p>
        <p> College of Engineering & Computer Science (CECS)
        <p>The Australian National University(ANU)</p>
   	</html>"), experiment(StartTime=0.0, StopTime=2.0, Interval=0.1, Tolerance=1e-06));

end TestSodiumMedium;
