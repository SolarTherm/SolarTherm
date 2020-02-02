within SolarTherm.Models.Fluid.Pumps;
model LiftSimple "A simple particle lift model"
	extends SolarTherm.Interfaces.Models.Lift;

	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter Boolean cont_m_flow = true "Control m_flow else control dp";
	parameter Boolean use_input = true "Use input else parameter";

	parameter SI.MassFlowRate m_flow_fixed = 0 "Fixed m_flow when no input";
	parameter SI.Pressure dp_fixed = 0 "Fixed dp when no input";

	parameter SI.Height dh = 0 "Vertical displacement";
	parameter Real CF = 0.5 "Counterweight factor ";
	parameter SI.Efficiency eff = 0.85 "Elevator total efficiency";

	Modelica.Blocks.Interfaces.RealInput m_flow if cont_m_flow and use_input annotation(
		Placement(
			visible = true,transformation(
			origin={-30, 60},extent={{-20,-20},{20,20}},
			rotation=-90), iconTransformation(
			origin={17, 73},extent={{-9, -9}, {9, 9}},
			rotation=-90)));

	Modelica.Blocks.Interfaces.RealInput dp if (not cont_m_flow) and use_input annotation(
		Placement(
			visible = true,transformation(
			origin={30, 60},extent={{-22, -22}, {22, 22}},
			rotation=-90), iconTransformation(
			origin={-23, 73},extent={{-9, -9}, {9, 9}},
			rotation=-90)));

	SI.Power W_loss "Power required to lift particles";

equation
	fluid_a.m_flow + fluid_b.m_flow = 0;

	fluid_b.h_outflow = inStream(fluid_a.h_outflow);
	fluid_a.h_outflow = 0;//inStream(fluid_b.h_outflow);

	fluid_b.Xi_outflow = inStream(fluid_a.Xi_outflow);
	fluid_a.Xi_outflow = inStream(fluid_b.Xi_outflow);

	W_loss = fluid_a.m_flow * CN.g_n * dh * (1 - CF) / eff;

	if cont_m_flow then
		fluid_a.m_flow = if use_input then m_flow else m_flow_fixed;
	else
		fluid_a.p - fluid_b.p = if use_input then dp else dp_fixed;
	end if;

	annotation (Documentation(revisions="<html>
	<ul>
	<li>A Shirazi:<br>Released first version. </li>
	</ul>
	</html>"));

	//fluid_a.h_outflow=fluid_b.h_outflow;
	//fluid_a.Xi_outflow=fluid_b.Xi_outflow;
	//fluid_a.p=fluid_b.p;

end LiftSimple;
