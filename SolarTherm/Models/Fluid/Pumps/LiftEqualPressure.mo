within SolarTherm.Models.Fluid.Pumps;

model LiftEqualPressure
  extends SolarTherm.Interfaces.Models.Lift;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  parameter SI.Height dh = 0 "Vertical displacement";
  parameter Real CF = 0.5 "Counterweight factor ";
  parameter SI.Efficiency eff = 0.85 "Elevator total efficiency";
  Modelica.Blocks.Interfaces.RealInput m_flow  annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {17, 73}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));
  SI.Power W_loss "Power required to lift particles";
equation
  fluid_a.m_flow = fluid_b.m_flow;
  fluid_b.h_outflow = inStream(fluid_a.h_outflow);
  fluid_a.h_outflow = 0;
  fluid_b.Xi_outflow = inStream(fluid_a.Xi_outflow);
  fluid_a.Xi_outflow = inStream(fluid_b.Xi_outflow);
  W_loss = fluid_a.m_flow * CN.g_n * dh * (1 - CF) / eff;
  fluid_a.p = fluid_b.p;
//fluid_a.h_outflow=fluid_b.h_outflow;
//fluid_a.Xi_outflow=fluid_b.Xi_outflow;
//fluid_a.p=fluid_b.p;
  annotation(
    Documentation(revisions = "<html>
	<ul>
	<li>A Shirazi:<br>Released first version. </li>
	</ul>
	</html>"));
end LiftEqualPressure;