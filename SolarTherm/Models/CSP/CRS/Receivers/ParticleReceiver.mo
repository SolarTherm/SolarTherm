within SolarTherm.Models.CSP.CRS.Receivers;

model ParticleReceiver
	extends Interfaces.Models.ReceiverFluid;

	parameter SI.Length H_rcv = 2 "Receiver drop height" annotation(Dialog(group="Technical data"));
	parameter SI.Length W_rcv = 2 "Receiver width" annotation(Dialog(group="Technical data"));
	parameter SI.Length L_rcv = 1 "Receiver length(depth)" annotation(Dialog(group="Technical data"));

	parameter SI.Area A = H_rcv * W_rcv "Receiver aperture area" annotation(Dialog(group="Technical data"));

	parameter SI.Length th_c_in = 1 "Curtain thickness at the inlet" annotation(Dialog(group="Technical data"));

	parameter SI.Efficiency em "Emissivity" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency ab "Absorptivity" annotation(Dialog(group="Technical data"));

	parameter Boolean const_alpha = true "If true then constant convective heat transfer coefficient";
	parameter SI.CoefficientOfHeatTransfer alpha=1 if const_alpha "Convective heat transfer coefficient";

	Medium.BaseProperties medium;

	SI.SpecificEnthalpy h_in "Specific enthalpy at inlet";
	SI.SpecificEnthalpy h_out(start=h_0) "Specific enthalpy at outlet";

	SI.Temperature T_in=Medium.temperature(state_in) "Temperature at inlet";
	SI.Temperature T_out=Medium.temperature(state_out) "Temperature at outlet";

	SI.HeatFlowRate Q_loss "Total losses";
	SI.HeatFlowRate Q_rad "Radiative losses";
	SI.HeatFlowRate Q_con "Convective losses";
	SI.HeatFlowRate Q_rcv "Heat flow captured by curtain";

	Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
		transformation(
		extent={{-12,-12},{12,12}},
		rotation=-90,
		origin={0,84}), iconTransformation(
		extent={{-6,-6},{6,6}},
		rotation=-90,
		origin={0,78})));

	Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
		transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
		-24,-98},{-12,-86}})));

	Real eff;

protected
	parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);

	Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,h_in);
	Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_b.p,h_out);

equation
	medium.h=(h_in+h_out)/2;
	h_in=inStream(fluid_a.h_outflow);
	fluid_b.h_outflow=max(h_0,h_out);
	fluid_a.h_outflow=0;

	heat.T=medium.T;
	fluid_b.m_flow=-fluid_a.m_flow;
	fluid_a.p=medium.p;
	fluid_b.p=medium.p;

	Q_rad=A*sigma*em*(medium.T^4-Tamb^4);
	Q_con=A*alpha*(medium.T-Tamb);

	if on then
		Q_loss=-Q_rad-Q_con;
	else
		Q_loss=0;
	end if;

	0=ab*heat.Q_flow+Q_loss+max(1e-3,fluid_a.m_flow)*(h_in-h_out);
	Q_rcv=fluid_a.m_flow*(h_out-h_in);
	eff=max(Q_rcv, 0)/max(1,heat.Q_flow);


	annotation (Documentation(info="<html>
	<p>
	<b>ParticleReceiver</b> models the heat transfer characteristics of an external tubular receiver with a user-defined geometry by employing simple energy and mass balances, an average temperature 	for receiver external surface, and heat transfer correlations. The receiver <b>ParticleReceiver</b> model has the following connectors:
	</p>
	<ul>
	<li> A <b>HeatPort</b> interface. According to the Modelica sign convention, a positive heat flow rate Q_flow (in Watts) is considered to flow into the receiver.</li>
	<li> A <b>Real_input</b> for the ambient temperature (in K).</li>
	<li> A <b>BooleanInput </b> for the operation of the field.</li>
	<li> An inlet <b>FluidPort_a</b> and an outlet <b>FluidPort_b</b>. Each fluid connector has three stream variables (h_outflow, Xi_outflow and C_outflow) associated with the flow variable m_flow. 		These variables represent the specific enthalpy, the mass fractions and the concentrations associated to m_flow <0.</li>
	</ul>
	<p>
	The model requires to define the following parameters:a <b>Medium</b> package from the <b>Media</b> library.
	</p>
	<ul>
	<li> <b>H_rcv</b>: Receiver height, in meters. <b>Default</b>: 1.0 m.</li>
	<li> <b>W_rcv</b>: Receiver width, in meters. <b>Default</b>: 1.0 m.</li>
	<li> <b>L_rcv</b>: Receiver length(depth), in meters. <b>Default</b>: 1.0 m.</li>
	<li> <b>th_c_in</b>: Curtain thickness at the receiver inlet. <b>Default</b>: 1.0 m.</li>
	<li> <b>ab</b>: Absorptance of the curtain.</li>
	<li> <b>em</b>: Emmitance of the curtain.</li>
	<li> <b>const_alpha</b>: Boolean, true if external convective heat transfer. <b>Default</b>: true.</li>
	<li> <b>alpha</b>: Heat transfer coefficient due to external convection, in W/(m2.K). <b>Default</b>: 1.0 W/(m2.K).</li>
	</ul>
</html>", revisions="<html>
		<ul>
		<li><i>Jun 2019</i> by Ali Shirazi and <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		Created.</li>
		<li><i>Jan 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		Information modified.</li>
	</ul>
</html>"));

end ParticleReceiver;
