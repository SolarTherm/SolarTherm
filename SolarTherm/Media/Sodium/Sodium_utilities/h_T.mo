within SolarTherm.Media.Sodium.Sodium_utilities;
function h_T "Specific enthalpy of liquid sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	
	
	
	protected
	Real T_data[33] = {
	371,421,471,521,571,621,671,721,771,821,871,921,971,1021,1071,1121,1171,1221,1271,1321,1371,1421,1471,1521,1571,1621,1671,1721,1771,1821,1871,1921,1971};

	Real h_data[33] = {	101809.02,170469.62,238151.45,304907.3,370810.49,435946.57,500408.79,564295.41,627708.09,690750.87,753529.45,816150.76,878722.64,941353.62,1004152.76,1067229.53,1130693.72,1194655.37,1259224.72,1324512.21,1390628.39,1457683.91,1525789.54,1595056.12,1665594.54,1737515.78,1810930.83,1885950.74,1962686.6,2041249.5,2121750.59,2204301.03,2289011.99
	};
		
algorithm
	//Ref. ANL/RE-95/2, pp. 4
	// 371K to 2000K liquid on saturation curve:
	/*The original equation*/
    h := 1000 * (-365.77 + 1.6582 * T - 4.2395e-4 * T ^ 2 + 1.4847e-7 * T ^ 3 + 2992.6 / T - 104.90817873321107);
      
    /*The equation below is a simplification from the equation above*/
    //1st order Polynomial from ODS
	//h := 1335.5694333093 * T - 410348.564838737;
	
	//1st order polynomial from online
    //h := -4.0996753621924366e+005 +  1.3351080766858058e+003 * T;
    
    //CombiTable1D
    //h := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,h_data,T);

    
	annotation(derivative=h_T_der);
end h_T;
