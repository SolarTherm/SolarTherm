within SolarTherm.Models.Fluid.Sensors;
model Temperature
  extends SolarTherm.Interfaces.Models.Temperature;
  Medium.ThermodynamicState state;

equation
  state= Medium.setState_phX(fluid_a.p,inStream(fluid_a.h_outflow),inStream(fluid_a.Xi_outflow));
  T=Medium.temperature(state);
  connect(fluid_a, fluid_b) annotation (Line(points={{-100,0},{0,0},{0,0},{100,0}},
        color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Temperature;
