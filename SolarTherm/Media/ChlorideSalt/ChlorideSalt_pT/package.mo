within SolarTherm.Media.ChlorideSalt;
package ChlorideSalt_pT "Chloride Salt model, explicit in p and T"
	/* The statement below extends from PartialMedium and sets some
		package constants. Provide values for these constants
		that are appropriate for your medium model. Note that other
		constants (such as nX, nXi) are automatically defined by
		definitions given in the base class Interfaces.PartialMedium"
	*/
	extends Modelica.Media.Interfaces.PartialMedium(
		ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pT,
		final mediumName="Chloride Salt",
		final substanceNames={"MgCl2","KCl","NaCl"},
		final singleState=false,
		final reducedX=true,
		final fixedX=true,
		Temperature(
			min=430+273.15, //Solidification Temperature equal to 426°C
			max=780+273.15,
			start=800));
	import SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities.*;
	// Provide medium constants here

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
		p and T as independent variables.
	*/

	redeclare record extends ThermodynamicState
		"A selection of variables that uniquely defines the thermodynamic state"
		AbsolutePressure p "Absolute pressure of medium";
		Temperature T "Temperature of medium";
		annotation (Documentation(info="<html>
			
			</html>"));
	end ThermodynamicState;

	redeclare model extends BaseProperties(final standardOrderComponents=true)
		"Base properties of medium"

 equation
	T = state.T;
	p = state.p;
	d = rho_T(T);
	h = h_T(T);
	u = h - p / d;
	MM = 0.07862523372; //Composition: NaCl–KCl–MgCl2 24.5–20.5–55 (% in weight)
	R = 8.3144 / MM;
	//T = T_h(h);
	//h = state.h;

	end BaseProperties;

	/* Provide implementations of the following optional properties.
		If not available, delete the corresponding function.
		The record "ThermodynamicState" contains the input arguments
		of all the function and is defined together with the used
		type definitions in PartialMedium. The record most often contains two of the
		variables "p, T, d, h" (e.g., medium.T)
	*/


	redeclare function setState_pTX
		"Return thermodynamic state as function of p, T and composition X or Xi"
		extends Modelica.Icons.Function;
		input AbsolutePressure p "Pressure";
		input Temperature T "Temperature";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p, T=T);
	end setState_pTX;

	redeclare function setState_phX
		"Return thermodynamic state as function of p, h and composition X or Xi"
		extends Modelica.Icons.Function;
		input AbsolutePressure p "Pressure";
		input SpecificEnthalpy h "Specific enthalpy";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p, T=T_h(h));
	end setState_phX;

	redeclare function setState_dTX
		"Return thermodynamic state as function of d, T and composition X or Xi"
		extends Modelica.Icons.Function;
		input Density d "Density";
		input Temperature T "Temperature";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p_rho(d), T=T);
		assert(false,"no inverse functions");
	end setState_dTX;

	redeclare function extends pressure "Return pressure"
	algorithm
		p := state.p;
		annotation (Inline=true);
	end pressure;
	
	redeclare function extends temperature "Return temperature"
	algorithm
		//T := T_h(state.h);
		T := state.T;
		annotation (Inline=true);
	end temperature;

	redeclare function extends specificEnthalpy "Return specific enthalpy"
	algorithm
		h := h_T(state.T);
		annotation (Inline=true);
	end specificEnthalpy;

	redeclare function extends density "Return density"
	algorithm
		d := rho_T(state.T);
		annotation (Inline=true);
	end density;

	redeclare function extends specificInternalEnergy "Return specific internal energy"
	algorithm
		u := h_T(state.T) - state.p / rho_T(state.T);
		annotation (Inline=true);
	end specificInternalEnergy;

	redeclare function extends dynamicViscosity "Return dynamic viscosity"
	algorithm
		eta := eta_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end dynamicViscosity;

	redeclare function extends thermalConductivity "Return thermal conductivity"
	algorithm
		lambda := lamda_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end thermalConductivity;

	redeclare function extends specificEntropy "Return specific entropy"
	algorithm
		s := s_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end specificEntropy;

	redeclare function extends specificHeatCapacityCp
		"Return specific heat capacity at constant pressure"
	algorithm
		cp := cp_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end specificHeatCapacityCp;

	redeclare function extends density_derT_p
		"Return density derivative w.r.t. temperature at constant pressure"
	algorithm
		ddTp := drho_dT_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end density_derT_p;

end ChlorideSalt_pT;