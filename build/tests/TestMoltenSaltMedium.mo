model TestMoltenSaltMedium

	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;

	// Experimental data for molten salt:

	parameter Modelica.SIunits.Temperature T_table[13] = {533.15, 560.927777777778, 588.705555555556, 616.483333333333, 644.261111111111, 672.038888888889, 699.816666666667, 727.594444444445, 755.372222222222, 783.15, 810.927777777778, 838.705555555556, 866.483333333333} "Temperature";

	parameter Modelica.Media.Interfaces.Types.AbsolutePressure p_table[13] = {1526.7033808805, 2550.26786424896, 4058.71520155749, 6194.48949257368, 9115.67665869631, 12992.7811887082, 18005.1524430582, 24337.2984452776, 32175.2843744551, 41703.3664726353, 53100.9663770837, 66540.0499805841, 82182.9407952451} "Pressure";

	parameter Modelica.SIunits.SpecificEnthalpy h_table[13] = {768732.510665, 810124.424245247, 851649.053874877, 893306.399553889, 935096.461282284, 977019.239060062, 1019074.73288722, 1061262.94276377, 1103583.86868969, 1146037.510665, 1188623.86868969, 1231342.94276377, 1274194.73288722} "Specific enthalpy";

	parameter Modelica.SIunits.SpecificEnthalpy h_fg_table[13] = {506922.596138589, 506870.701419283, 506794.223139281, 506685.939382727, 506537.835193404, 506341.265993733, 506087.138771137, 505766.098968825, 505368.713082215, 504885.639319837, 504307.781004682, 503626.419465984, 502833.324901681} "Specific vapourisation enthalpy";

	parameter Modelica.SIunits.Density rho_table[13] = {1923.8174063, 1905.87672774, 1888.09623381, 1870.31573988, 1852.53524595, 1834.75475202, 1816.97425809, 1799.19376416, 1781.41327023, 1763.6327763, 1745.85228237, 1728.07178844, 1710.29129451} "Liquid density";

	parameter Modelica.SIunits.SpecificEntropy s_table[13] = {8857.0248, 8932.7054, 9004.9583, 9074.0997, 9140.4039, 9204.1106, 9265.4302, 9324.5485, 9381.6307, 9436.8237, 9490.2594, 9542.0560, 9592.3205} "Specific entropy";

	parameter Modelica.SIunits.SpecificHeatCapacity cp_table[13] = {1489.504, 1497.872, 1502.056, 1506.24, 1510.424, 1514.608, 1518.792, 1522.976, 1531.344, 1535.528, 1539.712, 1543.896, 1548.08} "Specific heat at constant pressure";

	parameter Modelica.SIunits.DynamicViscosity eta_table[13] = {0.004342875766209, 0.003558075975413, 0.002928913330381, 0.002436455078722, 0.002061644454379, 0.001785631380734, 0.001589441767507, 0.001454060186529, 0.001360553885408, 0.001289990111751, 0.001223436113163, 0.001141876461478, 0.00102641974219} "Liquid dynamic viscosity";

	parameter Modelica.SIunits.ThermalConductivity lambda_table[13] = {0.492163300893919, 0.497585525433475, 0.503007749973031, 0.508429974512587, 0.513852199052143, 0.519274423591699, 0.524696648131255, 0.530118872670811, 0.535541097210367, 0.540961592172718, 0.546383816712274, 0.55180604125183, 0.557228265791385} "Liquid thermal conductivity";

	// Correlations for the molten salt thermo-physical properties:

	Modelica.SIunits.SpecificHeatCapacity cp_T_test[13] "Specific heat at constant pressure";
	Real error_cp_T_test[13];
	Real err_avg_cp_T_test;

	Modelica.SIunits.DynamicViscosity eta_T_test[13] "Liquid dynamic viscosity";
	Real error_eta_T_test[13];
	Real err_avg_eta_T_test;

	Modelica.SIunits.SpecificEnthalpy h_rho_test[13] "Specific enthapy";
	Real error_h_rho_test[13];
	Real err_avg_h_rho_test;

	Modelica.SIunits.SpecificEnthalpy h_fg_p_test[13] "Specific enthapy";
	Real error_h_fg_p_test[13];
	Real err_avg_h_fg_p_test;

	Modelica.SIunits.SpecificEnthalpy h_s_test[13] "Specific enthapy";
	Real error_h_s_test[13];
	Real err_avg_h_s_test;

	Modelica.SIunits.SpecificEnthalpy h_T_test[13] "Specific enthapy";
	Real error_h_T_test[13];
	Real err_avg_h_T_test;

	Modelica.SIunits.ThermalConductivity lamda_T_test[13] "Thermal conductivity";
	Real error_lamda_T_test[13];
	Real err_avg_lamda_T_test;

	Modelica.Media.Interfaces.Types.AbsolutePressure p_rho_test[13] "Pressure";
	Real error_p_rho_test[13];
	Real err_avg_p_rho_test;

	Modelica.Media.Interfaces.Types.AbsolutePressure p_sat_T_test[13];
	Real error_p_sat_T_test[13];
	Real err_avg_p_sat_T_test;

	Modelica.SIunits.Density rho_T_test[13] "Density";
	Real error_rho_T_test[13];
	Real err_avg_rho_T_test;

	Modelica.SIunits.SpecificEntropy s_rho_test[13] "Specific entropy";
	Real error_s_rho_test[13];
	Real err_avg_s_rho_test;

	Modelica.SIunits.SpecificEntropy s_T_test[13] "Specific entropy";
	Real error_s_T_test[13];
	Real err_avg_s_T_test;

	Modelica.SIunits.Temperature T_h_test[13] "Temperature";
	Real error_T_h_test[13];
	Real err_avg_T_h_test;

	Modelica.SIunits.Temperature T_sat_p_test[13] "Temperature";
	Real error_T_sat_p_test[13];
	Real err_avg_T_sat_p_test;

	Modelica.SIunits.Temperature T_s_test[13] "Temperature";
	Real error_T_s_test[13];
	Real err_avg_T_s_test;

equation
	cp_T_test = cp_T(T_table);
	error_cp_T_test = 100 * (abs(cp_T_test .- cp_table) ./ cp_table);
	err_avg_cp_T_test = sum(error_cp_T_test) / size(error_cp_T_test,1);

	eta_T_test = eta_T(T_table);
	error_eta_T_test = 100 * (abs(eta_T_test .- eta_table) ./ eta_table);
	err_avg_eta_T_test = sum(error_eta_T_test) / size(error_eta_T_test,1);

	h_rho_test = h_rho(rho_table);
	error_h_rho_test = 100 * (abs(h_rho_test .- h_table) ./ h_table);
	err_avg_h_rho_test = sum(error_h_rho_test) / size(error_h_rho_test,1);

	h_fg_p_test = h_fg_p(T_table);
	error_h_fg_p_test = 100 * (abs(h_fg_p_test .- h_fg_table) ./ h_fg_table);
	err_avg_h_fg_p_test = sum(error_h_fg_p_test) / size(error_h_fg_p_test,1);

	h_s_test = h_s(s_table);
	error_h_s_test = 100 * (abs(h_s_test .- h_table) ./ h_table);
	err_avg_h_s_test = sum(error_h_s_test) / size(error_h_s_test,1);

	h_T_test = h_T(T_table);
	error_h_T_test = 100 * (abs(h_T_test .- h_table) ./ h_table);
	err_avg_h_T_test = sum(error_h_T_test) / size(error_h_T_test,1);

	lamda_T_test = lamda_T(T_table);
	error_lamda_T_test = 100 * (abs(lamda_T_test .- lambda_table) ./ h_table);
	err_avg_lamda_T_test = sum(error_lamda_T_test) / size(error_lamda_T_test,1);

	p_rho_test = p_rho(rho_table);
	error_p_rho_test = 100 * (abs(p_rho_test .- p_table) ./ p_table);
	err_avg_p_rho_test = sum(error_p_rho_test) / size(error_p_rho_test,1);

	p_sat_T_test = p_sat_T(T_table);
	error_p_sat_T_test = 100 * (abs(p_sat_T_test .- p_table) ./ p_table);
	err_avg_p_sat_T_test = sum(error_p_sat_T_test) / size(error_p_sat_T_test,1);

	rho_T_test = rho_T(T_table);
	error_rho_T_test = 100 * (abs(rho_T_test .- rho_table) ./ rho_table);
	err_avg_rho_T_test = sum(error_rho_T_test) / size(error_rho_T_test,1);

	s_rho_test = s_rho(rho_table);
	error_s_rho_test = 100 * (abs(s_rho_test .- s_table) ./ s_table);
	err_avg_s_rho_test = sum(error_s_rho_test) / size(error_s_rho_test,1);

	s_T_test = s_T(T_table);
	error_s_T_test = 100 * (abs(s_T_test .- s_table) ./ s_table);
	err_avg_s_T_test = sum(error_s_T_test) / size(error_s_T_test,1);

	T_h_test = T_h(h_table);
	error_T_h_test = 100 * (abs(T_h_test .- T_table) ./ T_table);
	err_avg_T_h_test = sum(error_T_h_test) / size(error_T_h_test,1);

	T_sat_p_test = T_sat_p(p_table);
	error_T_sat_p_test = 100 * (abs(T_sat_p_test .- T_table) ./ T_table);
	err_avg_T_sat_p_test = sum(error_T_sat_p_test) / size(error_T_sat_p_test,1);

	T_s_test = T_s(s_table);
	error_T_s_test = 100 * (abs(T_s_test .- T_table) ./ T_table);
	err_avg_T_s_test = sum(error_T_s_test) / size(error_T_s_test,1);

    annotation (Documentation(info="<html>
    	<p>
    	This script was developed in order to test the accuracy of the correlations used to determine the thermo-physical properties of <b>molten salt (60% NaNO3 and 40% KNO3 by weight)</b>. The experimental data for molten salt have been taken from <u>R. Ferri et al.  International Journal of Thermal Sciences 47 (2008) 1676-1687</u>. The Thermo-physical properties of molten salt were estimated from some correlations reported in <u>R. Ferri et al.  International Journal of Thermal Sciences 47 (2008) 1676-1687</u> as well as some obtained through curve fitting in MATLAB:
        </p>
        </html>", revisions="<html>
        <p> Developed by <b>Ali Shirazi</b> on May 15, 2017</p>
        <p> College of Engineering & Computer Science (CECS)
        <p>The Australian National University(ANU)</p>
   	</html>"), experiment(StartTime=0.0, StopTime=2.0, Interval=0.1, Tolerance=1e-06));

end TestMoltenSaltMedium;
