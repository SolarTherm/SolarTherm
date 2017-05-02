within SolarTherm.Media.Sodium;
package Sodium_pT "Pure molten sodium, explicit in p and T"
  /* For a new medium, make a copy of this package and remove
     the "partial" keyword from the package definition above.
     The statement below extends from PartialMedium and sets some
     package constants. Provide values for these constants
     that are appropriate for your medium model. Note that other
     constants (such as nX, nXi) are automatically defined by
     definitions given in the base class Interfaces.PartialMedium"
  */
  extends Modelica.Media.Interfaces.PartialMedium(
    final mediumName="Sodium",
    final substanceNames={"Na"},
    final singleState=false,
    final reducedX=true,
    final fixedX=true,
    Temperature(
      min=370.9,
      max=1154.7,
      start=700),
    ThermoStates = Choices.IndependentVariables.pT);
  import SolarTherm.Media.Sodium.Sodium_utilities.*;
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
     p,T as independent variables.
  */

  redeclare model extends BaseProperties(final standardOrderComponents=true)
    "Base properties of medium"

  equation
    T = state.T;
    p = state.p;
    d = rho_T(T);
    h = h_T(T);
    u = h - p/d;
    MM = 0.02298977;
    R = 8.3144/MM;
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
  redeclare record extends ThermodynamicState
    "A selection of variables that uniquely defines the thermodynamic state"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature";
    annotation (Documentation(info="<html>

</html>"));
  end ThermodynamicState;

    redeclare function setState_pTX
    "Return thermodynamic state from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
    algorithm
    state := ThermodynamicState(p=p, T=T);
    end setState_pTX;

  redeclare function setState_phX
    "Return thermodynamic state from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p, T=T_h(h));
  end setState_phX;

  redeclare function setState_psX
    "Return thermodynamic state from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    //state := ThermodynamicState(p=p, h=h);
    assert(false,"no inverse funtions");
  end setState_psX;

  redeclare function setState_dTX
    "Return thermodynamic state from d, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Density d "Pressure";
    input Temperature T "Specific entropy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    //state := ThermodynamicState(p=p, h=h);
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
    //h := state.h;
    h := h_T(state.T);
    annotation (Inline=true);
    end specificEnthalpy;

  redeclare function extends density "Return density"
  algorithm
    d := rho_T(state.T);
    annotation (Inline=true);
  end density;

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

  redeclare function extends velocityOfSound "Return velocity of sound"
    extends Modelica.Icons.Function;
  algorithm
    a := vs_T(state.T);
    annotation (Documentation(info="<html>

</html>"));
  end velocityOfSound;

  annotation (Documentation(info="<html>
<p><span style=\"font-family: Arial,sans-serif;\">Calculation of fluid properties for pure molten sodium in the fluid region of 370 to 1154 Kelvin. Sodium is used in solar thermal systems due to its high range of temperature and high thermal conductivity. </span></p>
<p><span style=\"font-family: Arial,sans-serif;\">This package of thermodynamic properties is explicit for pressure and temperature. </span></p>
<p><span style=\"font-family: Arial,sans-serif;\">These correlations have been obtained by integration of (cp dT) to obtain enthalpy, and integration of (cp/T dT) to obtain entropy. Integration constants are added so that h and s evaluate to zero at T = 273.15 K (Pye, 2015). </span></p>
<p><b><span style=\"font-family: Arial,sans-serif;\">Restriction</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">The functions provided by this package shall be used inside of the restricted limits according to the referenced literature. </span></p>
<ul>
<li><b><span style=\"font-family: Arial,sans-serif;\">370 Kelvin &le; T &le; 1154 Kelvin </span></b></li>
<li><b><span style=\"font-family: Arial,sans-serif;\">Explicit for pressure and temperature. </span></b></li>
</ul>
<p><b><span style=\"font-family: Arial,sans-serif;\">References</span></b> </p>
<p style=\"margin-left: 30px;\">Fink, J. & Leibowitz, L. (1995). 'Thermodynamic and transport properties of sodium liquid and vapour', <i>Technical Report ANL/RE-95/2, Reactor Engineering Division, Argonne National Laboratories</i>. Retrieved from http://www.ne.anl.gov/eda/ANL-RE-95-2.pdf</p>
<p style=\"margin-left: 30px;\">Pye, J. (2015). 'Model of liquid sodium properties'. Retreived from http://code.ascend4.org/ascend/trunk/models/johnpye/liquidsodium.a4c</p>
</html>"));
end Sodium_pT;
