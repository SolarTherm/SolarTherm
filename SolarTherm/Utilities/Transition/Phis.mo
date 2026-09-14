within SolarTherm.Utilities.Transition;

function Phis
  input Real x;
  output Real y;
protected
  Real x1;
algorithm
  x1 := max(1.0e-3, x);
  y := exp(-1.0/x1)/(exp(-1.0/x1) + exp(-1.0/(1.0-x1)));
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info="<html><img width=\"500\" src=\"modelica://SolarTherm/Resources/Utilities/Transitions_Phis.png\"></html>"));
end Phis;