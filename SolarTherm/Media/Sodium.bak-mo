within SolarTherm.Media;
package Sodium "Sodium model"
 extends Modelica.Media.Interfaces.PartialMedium(
  final ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
  final mediumName="Sodium",
  final substanceNames={mediumName},
  final singleState=true,
  final reducedX=true,
  final fixedX=true,
  Temperature(
   min=370.9,
   max=1154.7,
   start=700,
   nominal=700));
 //extends Modelica.Media.Interfaces.PartialPureSubstance(
  //final singleState=false, // single state if u and d indepedent of p
                          // single state if u and d indepedent of p
               // redefining all bounds for Temperature (in parent Types package)
              // melting point
               // boiling point for 1 atm

 // Provide medium constants here

 /* The vector substanceNames is mandatory, as the number of
	 * substances is determined based on its size. Here we assume
	 * a single-component medium.
	 * singleState is true if u and d do not depend on pressure, but only
	 * on a thermal variable (temperature or enthalpy). Otherwise, set it
	 * to false.
	 * For a single-substance medium, just set reducedX and fixedX to true, and there's
	 * no need to bother about medium compositions at all. Otherwise, set
	 * final reducedX = true if the medium model has nS-1 independent mass
	 * fraction, or reducedX = false if the medium model has nS independent
	 * mass fractions (nS = number of substances).
	 * If a mixture has a fixed composition set fixedX=true, otherwise false.
	 * The modifiers for reducedX and fixedX should normally be final
	 * since the other equations are based on these values.
	 * 
	 * It is also possible to redeclare the min, max, and start attributes of
	 * Medium types, defined in the base class Interfaces.PartialMedium
	 * (the example of Temperature is shown here). Min and max attributes
	 * should be set in accordance to the limits of validity of the medium
	 * model, while the start attribute should be a reasonable default value
	 * for the initialization of nonlinear solver iterations
	 */

 /* Provide an implementation of model BaseProperties,
	 * that is defined in PartialMedium. Select two independent
	 * variables from p, T, d, u, h. The other independent
	 * variables are the mass fractions "Xi", if there is more
	 * than one substance. Provide 3 equations to obtain the remaining
	 * variables as functions of the independent variables.
	 * It is also necessary to provide two additional equations to set
	 * the gas constant R and the molar mass MM of the medium.
	 * Finally, the thermodynamic state vector, defined in the base class
	 * Interfaces.PartialMedium.BaseProperties, should be set, according to
	 * its definition (see ThermodynamicState below).
	 * The computation of vector X[nX] from Xi[nXi] is already included in
	 * the base class Interfaces.PartialMedium.BaseProperties, so it should not
	 * be repeated here.
	 */

 redeclare record ThermodynamicState
    "A selection of variables that uniquely defines the thermodynamic state"
  extends Modelica.Icons.Record;
  AbsolutePressure p "Absolute pressure of medium";
  Temperature T "Temperature of medium";
 end ThermodynamicState;

 /* Source data is J. Fink and L. Leibowitz (1995). "Thermodynamic and transport
	 * properties of sodium liquid and vapor', technical report ANL/RE-95/2, 
	 * Reactor Engineering Division, Argonne National Laboratories, 
	 * http://www.ne.anl.gov/eda/ANL-RE-95-2.pdf

	 * Enthalpy valid for liquid along saturation curve.  The zero point is
	 * solid state at 298.15K.
	 * 
	 * Using a constant density although there exist equations as function of T.
	 */
 redeclare model extends BaseProperties(final standardOrderComponents=true)
 equation
  // 700K liquid on saturation curve (897 at 500K, 828 at 800K):
  //d = 852;
  // 371K to 2503.7K liquid on saturation curve:
  d = 219 + 275.32*(1 - T/2503.7) + 511.58*sqrt(1 - T/2503.7);
  // 371K to 2000K liquid on saturation curve:
  h = 1000*(-365.77 + 1.6582*T - 4.2395e-4*T^2 + 1.4847e-7*T^3 + 2992.6/T);
  //h = 100*T;
  u = h - p/d;
  MM = 0.02298977;
  R = 8.3144/MM;
  state.p = p;
  state.T = T;
 end BaseProperties;

 /* Provide implementations of the following optional properties.
	 * If not available, delete the corresponding function.
	 * The record "ThermodynamicState" contains the input arguments
	 * of all the function and is defined together with the used
	 * type definitions in PartialMedium. The record most often contains two of the
	 * variables "p, T, d, h" (e.g., medium.T)
	 */

 //redeclare function extends dynamicViscosity "Return dynamic viscosity"
 //algorithm
 //  eta := 10 - state.T*0.3 + state.p*0.2;
 //  annotation (Documentation(info="<html>

 //</html>"));
 //end dynamicViscosity;

 //redeclare function extends thermalConductivity
 //  "Return thermal conductivity"
 //algorithm
 //  lambda := 0;
 //  annotation (Documentation(info="<html>

 //</html>"));
 //end thermalConductivity;

 //redeclare function extends specificEntropy "Return specific entropy"
 //algorithm
 //  s := 0;
 //  annotation (Documentation(info="<html>

 //</html>"));
 //end specificEntropy;

 //redeclare function extends specificHeatCapacityCp
 //  "Return specific heat capacity at constant pressure"
 //algorithm
 //  cp := 0;
 //  annotation (Documentation(info="<html>

 //</html>"));
 //end specificHeatCapacityCp;

 //redeclare function extends specificHeatCapacityCv
 //  "Return specific heat capacity at constant volume"
 //algorithm
 //  cv := 0;
 //  annotation (Documentation(info="<html>

 //</html>"));
 //end specificHeatCapacityCv;

 //redeclare function extends isentropicExponent "Return isentropic exponent"
 //  extends Modelica.Icons.Function;
 //algorithm
 //  gamma := 1;
 //  annotation (Documentation(info="<html>

 //</html>"));
 //end isentropicExponent;

 //redeclare function extends velocityOfSound "Return velocity of sound"
 //  extends Modelica.Icons.Function;
 //algorithm
 //  a := 0;
 //  annotation (Documentation(info="<html>

 //</html>"));
 //end velocityOfSound;
end Sodium;
