within SolarTherm.Models.CSP.CRS.Receivers;
model ChlorideSaltReceiver
	extends Interfaces.Models.ReceiverFluid;

	parameter SI.Length H_tower = 175 "Tower height" annotation(Dialog(group="Technical data"));
	parameter Integer N_pa = 20 "Number of panels" annotation(Dialog(group="Technical data"));
	parameter SI.Diameter D_tb = 25e-3 "Tube outer diameter" annotation(Dialog(group="Technical data"));
	parameter SI.Thickness t_tb = 1 "Tube wall thickness" annotation(Dialog(group="Technical data"));

	parameter SI.Efficiency ab = 1 "Coating absorptance" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency em = 1 "Coating Emmitance" annotation(Dialog(group="Technical data"));

	parameter SI.Length H_rcv = 2 "Receiver height" annotation(Dialog(group="Technical data"));
	parameter SI.Length D_rcv = 2 "Receiver diameter" annotation(Dialog(group="Technical data")); //TODO Change W_rcv by D_rcv

	parameter Boolean const_alpha = true "If true then constant convective heat transfer coefficient";
	parameter SI.CoefficientOfHeatTransfer alpha = 30 if const_alpha "Convective heat transfer coefficient";
	
	parameter SI.Length L_const = 0 "Piping length constant" annotation(Dialog(group="Piping"));

	parameter Real F_mult=2.6 "Piping length multiplier " annotation(Dialog(group="Piping"));

	parameter Real C_pip(unit="W/m") = 10200 "Piping loss coeficient" annotation(Dialog(group="Piping"));

	Medium.BaseProperties medium;

	SI.SpecificEnthalpy h_in "Specific enthalpy at inlet";
	SI.SpecificEnthalpy h_out(start=h_0) "Specific enthalpy at outlet";

	SI.Temperature T_in=Medium.temperature(state_in) "Temperature at inlet";
	SI.Temperature T_out=Medium.temperature(state_out) "Temperature at outlet";

	SI.HeatFlowRate Q_loss "Total losses";
	SI.HeatFlowRate Q_rad "Radiative losses";
	SI.HeatFlowRate Q_con "Convective losses";
	SI.HeatFlowRate Q_rcv "Heat flow captured by HTF";
	SI.HeatFlowRate Q_pip "Piping losses";

	Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
		transformation(
		extent={{-12,-12},{12,12}},
		rotation=-90,
		origin={0,84}), iconTransformation(
		extent={{-6,-6},{6,6}},
		rotation=-90,
		origin={0,78})));

	Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
		transformation(
		extent={{-38,-94},{2,-54}}),iconTransformation(
		extent={{-24,-98},{-12,-86}})));

	SI.Efficiency eff;
	SI.Energy E_rec;

protected
	parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);

	parameter SI.Length L_tot = H_tower*F_mult + L_const "Total piping length";

	Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,h_in);
	Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_b.p,h_out);
	parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width";
	parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
	parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
	parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
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
	Q_pip = if (fluid_a.m_flow > 0.01) then -L_tot*C_pip else 0;

	if on then
		Q_loss=-Q_rad-Q_con-Q_pip;
	else
		Q_loss = 0;
	end if;

	0=ab*heat.Q_flow + Q_loss + fluid_a.m_flow*(h_in-h_out);
	Q_rcv=fluid_a.m_flow*(h_out-h_in);
	eff=max(Q_rcv, 0)/max(1,heat.Q_flow);

	der(E_rec) = Q_rcv;

	annotation (Documentation(info="<html>
	<p>
	<b>ChlorideSaltReceiver</b> models the heat transfer characteristics of an external tubular receiver with a user-defined geometry by employing simple energy and mass balances, an average temperature 	for receiver external surface, and heat transfer correlations. The receiver <b>ChlorideSaltReceiver</b> model has the following connectors:
	</p>
	<ul>
	<li> A <b>HeatPort</b> interface. According to the Modelica sign convention, a positive heat flow rate Q_flow (in Watts) is considered to flow into the receiver.</li>
	<li> A <b>Real_input</b> for the ambient temperature (in K).</li>
	<li> An inlet <b>FluidPort_a</b> and an outlet <b>FluidPort_b</b>. Each fluid connector has three stream variables (h_outflow, Xi_outflow and C_outflow) associated with the flow variable m_flow. 		These variables represent the specific enthalpy, the mass fractions and the concentrations associated to m_flow <0.</li>
	</ul>
	<p>
	The model requires to define the following parameters:a <b>Medium</b> package from the <b>Media</b> library. The default medium package is the <b>MoltenSalt_ph</b>.
	</p>
	<ul>
	<li> <b>H_rcv</b>: Receiver height, in meters. <b>Default</b>: 1.0 m.</li>
	<li> <b>D_rcv</b>: Receiver diameter, in meters. <b>Default</b>: 1.0 m.</li>
	<li> <b>N_pa</b>: Number of panels of the receiver. <b>Default</b>: 20</li>
	<li> <b>D_tb</b>: Outer diameter of receiver tubes, in meters. <b>Default</b>: 25e-3 m (1 mm).</li>
	<li> <b>t_tb</b>: Wall thickness of receiver tubes, in meters. <b>Default</b>: 1e-3 m (1 mm).</li>
	<li> <b>ab</b>: Coating absorptance of the receiver. <b>Default</b>: 1.0.</li>
	<li> <b>em</b>: Coating emmitance of the receiver. <b>Default</b>: 1.0.</li>
	<li> <b>const_alpha</b>: Boolean, true if external convective heat transfer. <b>Default</b>: true.</li>
	<li> <b>alpha</b>: Heat transfer coefficient due to external convection, in W/(m2.K). <b>Default</b>: 30.0 W/(m2.K).</li>
	</ul>
	</html>", revisions="<html>
	<ul>
		<li><i>Jan 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		Created.</li>
	</ul>
	</html>"));

end ChlorideSaltReceiver;
