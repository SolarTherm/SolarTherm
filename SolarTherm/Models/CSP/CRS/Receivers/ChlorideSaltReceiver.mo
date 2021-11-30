within SolarTherm.Models.CSP.CRS.Receivers;
model ChlorideSaltReceiver
	extends Interfaces.Models.ReceiverFluid;
	import Modelica.Math.*;
	import Modelica.Constants.*;

	Medium.BaseProperties medium;

	parameter SI.Length H_tower = 175 "Tower height" annotation(Dialog(group="Technical data"));
	parameter Integer N_pa = 20 "Number of panels" annotation(Dialog(group="Technical data"));
	parameter SI.Diameter D_tb = 25e-3 "Tube outer diameter" annotation(Dialog(group="Technical data"));
	parameter SI.Thickness t_tb = 1 "Tube wall thickness" annotation(Dialog(group="Technical data"));
	parameter SI.RadiantPower R_des = 2.7*111e6/0.51/(1 - 0.208) "Input power to receiver at design point";

	parameter SI.Efficiency ab = 1 "Coating absorptance" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency em = 1 "Coating Emmitance" annotation(Dialog(group="Technical data"));

	parameter SI.Length H_rcv = 2 "Receiver height" annotation(Dialog(group="Technical data"));
	parameter SI.Length D_rcv = 2 "Receiver diameter" annotation(Dialog(group="Technical data")); //TODO Change W_rcv by D_rcv

	parameter Boolean const_alpha = true "If true then constant convective heat transfer coefficient";
	parameter SI.CoefficientOfHeatTransfer alpha = 30 if const_alpha "Convective heat transfer coefficient";

	parameter SI.Length L_const = 0 "Piping length constant" annotation(Dialog(group="Piping"));

	parameter Real F_mult=2.6 "Piping length multiplier " annotation(Dialog(group="Piping"));

	parameter Real C_pip(unit="W/m") = 10200 "Piping loss coeficient" annotation(Dialog(group="Piping"));

	parameter Real C1 = 0.86434;
	parameter Real C2 = -1.756263369;//-2.367e-9;
	parameter Real C3 = 1.561860014;//2.837e-18;
	parameter Real C4 = -0.508970016;//-1.246e-27;
	parameter Real C5 = -0.0003484;
	parameter Real C6 = 0.000236987968;//3.194e-13;
	
	SI.SpecificEnthalpy h_in(start=h_0) "Specific enthalpy at inlet";
	SI.SpecificEnthalpy h_out(start=h_0) "Specific enthalpy at outlet";

	SI.Temperature T_in=Medium.temperature(state_in) "Temperature at inlet";
	SI.Temperature T_out=Medium.temperature(state_out) "Temperature at outlet";

	SI.HeatFlowRate Q_loss "Convective and emmisive losses from the receiver";
	SI.HeatFlowRate Q_rcv "Heat flow captured by HTF after piping losses";
	SI.HeatFlowRate Q_net "Net thermal power to the HTF within the receiver";
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

	Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature", final unit = "K", displayUnit = "degC", min=0) annotation (
		Placement(visible = true, transformation(origin = {31, -23}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {31, -23}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

	SI.Efficiency eta_th "Receiver thermal efficiency (Q_net/Q_abs)";
	SI.Efficiency eta_rec "Receiver efficiency (Q_net/Q_in)";
	SI.Energy E_rec;
	SI.Energy E_pip;
	SI.Energy E_loss;
	
	parameter SI.Thickness e = 0.002e-3 "Pipe internal roughness";
	parameter Real N_p = 2 "Number of flowpath";
	Real Re "Reynolds number";
	Real f "Darcy friction factor";
	SI.Velocity v "Pipe internal velocity";
	SI.PressureDifference dP_tube "Pressure drop per tube";
	SI.PressureDifference dP_net "Net pressure drop in the receiver";
	parameter Real L_e_45 = 16.0 "Equivalent lenght for an 45 degree elbow";
	parameter Real L_e_90 = 30.0 "Equivalent lenght for an 90 degree elbow";
	Real est_load "ratio of design mass flow rate in the receiver";
	parameter SI.MassFlowRate m_flow_rec_des = 2425 "Receiver mass flow rate at design point";
	parameter SI.Efficiency eta_pump = 0.85 "Design point efficiency of the tower/receiver pump";
	SI.Efficiency eta_pump_adj "Adjusted efficiency of the tower/receiver pump";
	Modelica.SIunits.Power W_dot_pump "Pumping loss of the receiver/tower";

	parameter SI.Temperature T_0=from_degC(500) "Start value of temperature";
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
	h_in=inStream(fluid_a.h_outflow);
	fluid_b.h_outflow=max(h_0,h_out);
	fluid_a.h_outflow=0;
	T = T_out;
	v = ((fluid_a.m_flow/N_p)/N_tb_pa)/(medium.d*pi*(D_tb/2-t_tb)^2);
	Re = medium.d*v*(D_tb-2*t_tb)/SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities.eta_T(medium.T);
	f = if on then (-1.8*log10((e/(D_tb - 2*t_tb)/3.7)^1.11 + 6.9/Re))^(-2) else 0;
	dP_tube = 0.5*f*H_rcv/(D_tb - 2*t_tb)*medium.d*v^2 + 2/2*f*L_e_45*medium.d*v^2 + 4/2*f*L_e_90*medium.d*v^2;
	dP_net = dP_tube*N_pa/N_p + (H_tower - H_rcv/2)*medium.d*g_n;
	est_load = max(0.25, fluid_a.m_flow/m_flow_rec_des)*100;
	eta_pump_adj = 1.165437387*eta_pump*(-2.8825e-9*est_load^4 + 6.0231e-7*est_load^3 - 1.3867e-4*est_load^2 + 2.0683e-2*est_load);
	W_dot_pump = dP_net*fluid_a.m_flow/medium.d/eta_pump_adj;

	medium.h=(h_in+h_out)/2;
	heat.T=Tamb;
	fluid_b.m_flow=-fluid_a.m_flow;
	medium.p = fluid_b.p;
	medium.p = fluid_a.p;

	if on then
		Q_pip = L_tot*C_pip;
		Q_loss = heat.Q_flow*(1-eta_rec);
		eta_rec = 1 - (C1 + C2*(heat.Q_flow/R_des) + C3*(heat.Q_flow/R_des)^2 + C4*(heat.Q_flow/R_des)^3 + C5*(Tamb-273.15) + C6*(Tamb-273.15)*(heat.Q_flow/R_des));
		eta_th= Q_net/ab*heat.Q_flow;
	else
		Q_pip = 0;
		Q_loss = 0;
		eta_rec = 0;
		eta_th= 0;
	end if;

	Q_net = ab*heat.Q_flow - Q_loss;
	Q_rcv = Q_net - Q_pip;
	Q_rcv = fluid_a.m_flow*(h_out-h_in);

	der(E_loss) = Q_loss;
	der(E_pip) = Q_pip;
	der(E_rec) = Q_rcv;

	annotation (Documentation(info = "<html>
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
	</html>", revisions = "<html>
	<ul>
		<li><i>Jan 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		Created.</li>
	</ul>
	</html>"),
	Icon(graphics = {Text(origin = {0, -140}, lineColor = {0, 0, 255}, extent = {{-120, 20}, {120, -20}}, textString = "%name")}));

end ChlorideSaltReceiver;
