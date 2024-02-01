within SolarTherm.Media.H2;

package H2_amb_p_table "H2, explicit in h linear interpolation 100-2000 K at intervals of 50K from 100-600 and 100K from 600-2000. Enthalpy is measured relative to 298.15K"
  /* For a new medium, make a copy of this package and remove
    		the "partial" keyword from the package definition above.
    		The statement below extends from PartialMedium and sets some
    		package constants. Provide values for these constants
    		that are appropriate for your medium model. Note that other
    		constants (such as nX, nXi) are automatically defined by
    		definitions given in the base class Interfaces.PartialMedium"
    	*/
  extends Modelica.Media.Interfaces.PartialMedium(ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph, final mediumName = "H2", final substanceNames = {"H2"}, final singleState = false, final reducedX = true, final fixedX = true, Temperature(min = 100.0, max = 2000.0, start = 298.15));
  //import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
  import SolarTherm.Media.H2.H2_amb_p_table_utilities.*;
  // Provide medium constants here
  //constant SpecificHeatCapacity cp_const=123456
  // "Constant specific heat capacity at constant pressure";
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
    		p,T as independent variables.
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
  /*
    	redeclare function extends specificHeatCapacityCv
    		"Return specific heat capacity at constant volume"
    	algorithm
    		cv := 0;
    		annotation (Documentation(info="<html>

    			</html>"));
    	end specificHeatCapacityCv;

    	redeclare function extends isentropicExponent "Return isentropic exponent"
    		extends Modelica.Icons.Function;
    	algorithm
    		gamma := 1;
    		annotation (Documentation(info="<html>

    			</html>"));
    	end isentropicExponent;

    	redeclare function extends isentropicEnthalpy
    		"Return isentropic enthalpy"
    	algorithm
    		h_is := 0; // To be completed
    		annotation (Documentation(info="<html>

    			</html>"));

    	end isentropicEnthalpy;

    	redeclare function extends velocityOfSound "Return velocity of sound"
    		extends Modelica.Icons.Function;
    	algorithm
    		a := 0;
    		annotation (Documentation(info="<html>

    			</html>"));
    	end velocityOfSound;

    	redeclare function extends isobaricExpansionCoefficient
    		"Return overall the isobaric expansion coefficient beta"
    	algorithm
    		beta := beta_T(T_h(state.h));
    			annotation (Documentation(info="<html>

    				</html>"));
    	end isobaricExpansionCoefficient;

    	redeclare function extends isothermalCompressibility
    		"Return overall the isothermal compressibility factor"
    	algorithm
    		kappa := kappa_T(T_h(state.h));
    		annotation (Documentation(info="<html>

    			</html>"));
    	end isothermalCompressibility;


    	function enthalpyOfVaporization
    		"Return vaporization enthalpy of condensing fluid"
    		extends Modelica.Icons.Function;
    		input ThermodynamicState state "Thermodynamic state record";
    		output SpecificEnthalpy r0 "Vaporization enthalpy";
    	algorithm
    		r0 := h_fg_T(T_h(state.h));
    		annotation (Documentation(info="<html>

    			</html>"));
    	end enthalpyOfVaporization;

    	redeclare function extends density_derT_p
    		"Return density derivative w.r.t. temperature at constant pressure"
    	algorithm
    		ddTp := drho_dT_T(T_h(state.h));
    		annotation (Documentation(info="<html>

    			</html>"));
    	end density_derT_p;
    */
  annotation(
    Documentation(info = "<html><head></head><body><p><font face=\"Arial, sans-serif\">Hydrogen gas properties at atmospheric pressure. Specific enthalpy is measured relative to 298.15 K. Data was obtained from Incropera Table A4.</font></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">Restriction</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">The functions provided by this package shall be used inside of the restricted limits according to the referenced literature. </span></p>
<ul>
<li><b><span style=\"font-family: Arial,sans-serif;\">100 K ≤ T ≤ 2000 K</span></b></li>
<li><b><span style=\"font-family: Arial,sans-serif;\">explicit for pressure and specific enthalpy </span></b></li>
</ul>
<p><b><span style=\"font-family: Arial,sans-serif;\">References</span></b> </p>
<p style=\"margin-left: 30px;\">F. P. Incropera and D. P. Dewitt. Fundamentals of Heat and Mass Transfer Second Edition. 1985.</p>
</body></html>"));
end H2_amb_p_table;