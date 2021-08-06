within SolarTherm.Models.Storage.Tank;
model Reservoir_FixedMass
  extends Interfaces.Models.StorageFluid;
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium_Table;
  parameter SI.Mass m = 10.0 "Mass of HTF";
  //Medium.BaseProperties medium;
  parameter SI.Temperature T_start=from_degC(500) "Start value of temperature (K)";
  Modelica.Blocks.Interfaces.RealOutput h_fluid = fluid_state.h "Enthalpy of fluid" annotation (Placement(visible = true, transformation(origin = {107, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {102, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0))) ;
  
  Fluid_Package.State fluid_state;
 
  
initial equation
  fluid_state.h=Fluid_Package.h_Tf(T_start,0.0);
equation
  fluid_a.m_flow + fluid_b.m_flow = 0.0;
  fluid_a.p = fluid_b.p;
  fluid_a.h_outflow = inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=fluid_state.h;
  der(fluid_state.h) = (fluid_a.m_flow*inStream(fluid_a.h_outflow)+fluid_b.m_flow*fluid_state.h)/m;
  
  annotation (Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(origin = {2, -4}, lineColor = {255, 255, 255}, extent = {{-64, 56}, {64, -56}}, textString = "RS")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Reservoir_FixedMass;