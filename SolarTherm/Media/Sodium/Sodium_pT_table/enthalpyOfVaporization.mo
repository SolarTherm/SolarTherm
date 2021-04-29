within SolarTherm.Media.Sodium.Sodium_pT_table;

function enthalpyOfVaporization "Return vaporization enthalpy of condensing fluid"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  output SpecificEnthalpy r0 "Vaporization enthalpy";
algorithm
  r0 := h_fg_T(state.T);
  annotation(
    Documentation(info = "<html>

			</html>"));
end enthalpyOfVaporization;