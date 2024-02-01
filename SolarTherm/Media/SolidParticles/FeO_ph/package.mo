within SolarTherm.Media.SolidParticles;

package FeO_ph
  /* The statement below extends from PartialMedium and sets some
    		package constants. Provide values for these constants
    		that are appropriate for your medium model. Note that other
    		constants (such as nX, nXi) are automatically defined by
    		definitions given in the base class Interfaces.PartialMedium"
    	*/
  extends Modelica.Media.Interfaces.PartialMedium(ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph, final mediumName = "FeO", final substanceNames = {"FeO"}, final singleState = false, final reducedX = true, final fixedX = true, Temperature(min = 298.15, max = 1812.0, start = 900 + 273.15));
  import SolarTherm.Media.SolidParticles.FeO_utilities.*;
  // Provide medium constants here
  //constant SpecificHeatCapacity cp_const=123456
  //"Constant specific heat capacity at constant pressure";
  /* The vector substanceNames is mandatory, as the number of
    		substances is determined based on its size. Here we assume
    		a single-component medium.
    		singleState is true if u and d do not depend on pressure, but only
    		on a thermal variable (temperature or enthalpy). Otherwise, set it
    		to false.
    		For a single-substance medium, just set reducedX and fixedX to true, and there's
    		no need to bother about medium compositions at all. Otherwise, set
    		final reducedX = true if the medium model has nS-1 independent mass
    		fraction, or reducedX = false if the medium model has nS independent
    		mass fractions (nS = number of substances).
    		If a mixture has a fixed composition set fixedX=true, otherwise false.
    		The modifiers for reducedX and fixedX should normally be final
    		since the other equations are based on these values.

    		It is also possible to redeclare the min, max, and start attributes of
    		Medium types, defined in the base class Interfaces.PartialMedium
    		(the example of Temperature is shown here). Min and max attributes
    		should be set in accordance to the limits of validity of the medium
    		model, while the start attribute should be a reasonable default value
    		for the initialization of nonlinear solver iterations */
  /* Provide an implementation of model BaseProperties,
    		that is defined in PartialMedium. Select two independent
    		variables from p, T, d, u, h. The other independent
    		variables are the mass fractions "Xi", if there is more
    		than one substance. Provide 3 equations to obtain the remaining
    		variables as functions of the independent variables.
    		It is also necessary to provide two additional equations to set
    		the gas constant R and the molar mass MM of the medium.
    		Finally, the thermodynamic state vector, defined in the base class
    		Interfaces.PartialMedium.BaseProperties, should be set, according to
    		its definition (see ThermodynamicState below).
    		The computation of vector X[nX] from Xi[nXi] is already included in
    		the base class Interfaces.PartialMedium.BaseProperties, so it should not
    		be repeated here.
    		The code fragment below is for a single-substance medium with
    		p and h as independent variables.
    	*/
  /* Provide implementations of the following optional properties.
    		If not available, delete the corresponding function.
    		The record "ThermodynamicState" contains the input arguments
    		of all the function and is defined together with the used
    		type definitions in PartialMedium. The record most often contains two of the
    	variables "p, T, d, h" (e.g., medium.T)
    	*/
  /* Provide implementations of the following optional properties.
  		If not available, delete the corresponding function.
  		The record "ThermodynamicState" contains the input arguments
  		of all the function and is defined together with the used
  		type definitions in PartialMedium. The record most often contains two of the
  	variables "p, T, d, h" (e.g., medium.T)
  	*/
  annotation(
    Documentation(info = "<html><head></head><body><p><span style=\"font-family: Arial,sans-serif;\">Calculation of thermo-physical properties for pure solid Fe3O4 in the temperature region of 298.15 K to 1570 K. Thermodynamic properties are explicit in terms of enthalpy and pressure. Properties are calculated via linear interpolation of data-tables with 10 K temperature intervals.
		</span></p><b><span style=\"font-family: Arial, sans-serif;\">Restrictions</span></b><div><span style=\"font-family: Arial, sans-serif;\"><br></span></div><div><span style=\"font-family: Arial, sans-serif;\">The functions provided by this package shall be used inside of the restricted limits according to the referenced literature.</span>
<ul>
		<li><b><span style=\"font-family: Arial,sans-serif;\">298.15 K ≤ T ≤ 1570 K </span></b></li>
		<li><b><span style=\"font-family: Arial,sans-serif;\">Explicit for pressure and enthalpy. </span></b></li>
</ul>
		<p><b><span style=\"font-family: Arial,sans-serif;\">References</span></b> </p>
		<p style=\"margin-left: 30px;\">Chase M. W. NIST-JANAF themochemical tables, 1998. URL https://webbook.nist.gov/cgi/
cbook.cgi?ID=C1317608&amp;Mask=2#Thermo-Condensed. Fourth Edition, Monograph 9</p>
		<p style=\"margin-left: 30px;\">Emmanuil Beygelzimer and Yan Beygelzimer. Heat Capacity of oxide scale in the range from 0
C to 1300 C: Generalized estimates with account for movability of phase transitions, October
2021.</p>
		<p style=\"margin-left: 30px;\">Emmanuil Beygelzimer and Yan Beygelzimer. Thermal conductivity of oxide scale and its com-
ponents in the range from 0 C to 1300 C: Generalized estimates with account for movability of
phase transitions, October 2021.</p>
		<p style=\"margin-left: 30px;\">Emmanuil Beygelzimer and Yan Beygelzimer. Generalized estimates for the density of oxide
scale in the range from 0 C to 1300 C, October 2021.</p>
		</div></body></html>"));
end FeO_ph;