within SolarTherm.Media.Sodium.Sodium_utilities;
function cp_T "Specific heat capacity of liquid sodium at constant pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
	
	protected
	Real T_data[33] = {
	371,421,471,521,571,621,671,721,771,821,871,921,971,1021,1071,1121,1171,1221,1271,1321,1371,1421,1471,1521,1571,1621,1671,1721,1771,1821,1871,1921,1971};
    
    Real cp_data[33] = {	1383.19,1363.29,1344.16,1326.32,1310.09,1295.66,1283.15,1272.65,1264.2,1257.86,1253.64,1251.57,1251.67,1253.94,1258.39,1265.04,1273.89,1284.94,1298.2,1313.67,1331.35,1351.24,1373.35,1397.68,1424.23,1452.99,1483.98,1517.19,1552.62,1590.27,1630.14,1672.24,1716.57};
		
    
	
	algorithm
	//Ref. ANL/RE-95/2, pp. 29
	//371K to 2000K liquid on saturation curve
	/*The original equation*/
    cp := 1000 * (1.6582 - 8.4790e-4 * T + 4.4541e-7 * T ^ 2 - 2992.6 * T ^ (-2));
    
    //2nd order polynomial from online
    //cp :=  1.6320503241185443e+003 * T^0-8.1411123568264276e-001 * T^1+  4.3437958184205699e-004 * T^2;
    
    //CombiTable1D
    //cp := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,cp_data,T);
    
    
end cp_T;
