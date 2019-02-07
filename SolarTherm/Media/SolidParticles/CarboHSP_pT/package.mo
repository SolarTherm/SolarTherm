within SolarTherm.Media.SolidParticles;
package CarboHSP_pT "Solid CarboHSP particle model, explicit in p and T"

	/* The statement below extends from PartialMedium and sets some
		package constants. Provide values for these constants
		that are appropriate for your medium model. Note that other
		constants (such as nX, nXi) are automatically defined by
		definitions given in the base class Interfaces.PartialMedium"
	*/

	extends Modelica.Media.Interfaces.PartialMedium(
		ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pT,
		final mediumName="CARBO HSP 20/40",
		final substanceNames={"Al2O3", "SiO2", "Fe2O3", "TiO2", "other"}, // Molar fractions: 83%, 5%, 7%, 3.5% and 1.5%
		final singleState=false,
		final reducedX=true,
		final fixedX=true,
		Temperature(
			min=300,
			max=1373.15,
			start=900));

	import SolarTherm.Media.SolidParticles.CarboHSP_utilities.*;

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
	MM = 0.10313381;
	R = 8.3144 / MM;

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

	redeclare function setState_psX
		"Return thermodynamic state as function of p, s and composition X or Xi"
		extends Modelica.Icons.Function;
		input AbsolutePressure p "Pressure";
		input SpecificEntropy s "Specific entropy";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p, T=T_s(s));
	end setState_psX;

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

	redeclare function extends specificGibbsEnergy "Return specific Gibbs energy"
	algorithm
		g := 0; //TODO: to be implemented.
		annotation (Documentation(info="<html>

			</html>"));	
	end specificGibbsEnergy;

	redeclare function extends specificHelmholtzEnergy "Return specific Helmholtz energy"
	algorithm
		f := 0; //TODO: to be implemented.
		annotation (Documentation(info="<html>

			</html>"));	
	end specificHelmholtzEnergy;

	redeclare function extends specificHeatCapacityCp
		"Return specific heat capacity at constant pressure"
	algorithm
		cp := cp_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end specificHeatCapacityCp;

	redeclare function extends specificHeatCapacityCv
		"Return specific heat capacity at constant volume"
	algorithm
		cv := cp_T(state.T); // for a solid substance: cp is almost equal to cv
		annotation (Documentation(info="<html>

			</html>"));
	end specificHeatCapacityCv;

	redeclare function extends isentropicEnthalpy
		"Return isentropic enthalpy"
	algorithm
		h_is := 0;//TODO: to be implemented.
		annotation (Documentation(info="<html>

			</html>"));
	end isentropicEnthalpy;

	redeclare function extends density_derT_p
		"Return density derivative w.r.t. temperature at constant pressure"
	algorithm
		ddTp := drho_dT_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end density_derT_p;

	annotation (Documentation(info="<html>
		<p><span style=\"font-family: Arial,sans-serif;\">Calculation of thermo-physical properties for pure solid CarboHSP particle in the temperature region of 50 to 1100 degC. CarboHSP can used in falling particle CSP central receiver systems as heat transfer carrier and storage medium. </span></p>
		<p><span style=\"font-family: Arial,sans-serif;\">This package of thermodynamic properties is explicit for pressure and temperature. </span></p>
		<p><span style=\"font-family: Arial,sans-serif;\">These correlations have been obtained by integration of (cp dT) to obtain enthalpy, and integration of (cp/T dT) to obtain entropy. Integration constants are added so that h and s evaluate to zero at T = 298.15 K (i.e. 25 degC). </span></p>
		<p><b><span style=\"font-family: Arial,sans-serif;\">Restriction</span></b></p>
		<p><span style=\"font-family: Arial,sans-serif;\">The functions provided by this package shall be used inside of the restricted limits according to the referenced literature. </span></p>
<ul>
		<li><b><span style=\"font-family: Arial,sans-serif;\">50 degC &le; T &le; 1100 degC </span></b></li>
		<li><b><span style=\"font-family: Arial,sans-serif;\">Explicit for pressure and temperature. </span></b></li>
</ul>
		<p><b><span style=\"font-family: Arial,sans-serif;\">References</span></b> </p>
		<p style=\"margin-left: 30px;\">Siegel, N.P. et al., 'Development and Evaluation of a Prototype Solid Particle Receiver: On-Sun Testing and Model Validation', <i>Journal of Solar Energy Engineering </i> 132 (2010) 021008. Retrieved from https://bit.ly/2RFgEUz</p>
		<p style=\"margin-left: 30px;\">Siegel, N.P. et al., 'The Development of Direct Absorption and Storage Media for Falling Particle Solar Central Receivers', <i>Journal of Solar Energy Engineering </i> 137 (2015) 041003. Retrieved from https://bit.ly/2UMc3lx</p>
		<p style=\"margin-left: 30px;\">CARBO Company's website. Retreived from https://bit.ly/2GbWHTM</p>
		</html>"));
end CarboHSP_pT;
