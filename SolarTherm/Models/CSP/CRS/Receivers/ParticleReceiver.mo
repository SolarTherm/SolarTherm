within SolarTherm.Models.CSP.CRS.Receivers;
model ParticleReceiver
	extends Interfaces.Models.ReceiverFluid;

	parameter SI.Length H_rcv = 2 "Receiver drop height" annotation(Dialog(group="Technical data"));
	parameter SI.Length W_rcv = 2 "Receiver width" annotation(Dialog(group="Technical data"));
	parameter SI.Length L_rcv = 1 "Receiver length(depth)" annotation(Dialog(group="Technical data"));

	parameter SI.Area A = H_rcv * W_rcv "Receiver aperture area" annotation(Dialog(group="Technical data"));

	parameter SI.Length th_c_in = 1 "Curtain thicknesss at the inlet" annotation(Dialog(group="Technical data"));

	parameter SI.Efficiency em "Emissivity" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency ab "Absorptivity" annotation(Dialog(group="Technical data"));

	parameter Boolean const_alpha = true "If true then constant convective heat transfer coefficient";
	parameter SI.CoefficientOfHeatTransfer alpha=1 if const_alpha "Convective heat transfer coefficient";

	// this object represents the state of the particles in the curtain:
	Medium.BaseProperties medium;

	// from ReceiverFluid and Receiver, we inherit
	//   * fluid_a, fluid_b (inlet and outlet ports)
	//   * heat (heat port, supply of heat to the receiver)

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
	parameter SI.Temperature T_0=from_degC(580.3) "Start value of temperature";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy  h_0=SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(T_0);

	Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,h_in);
	Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_b.p,h_out);

equation
	medium.h=(h_in+h_out)/2; // temperature for thermal losses = average of inlet and outlet pcl temperatures
	h_in=inStream(fluid_a.h_outflow);
	fluid_b.h_outflow=max(h_0,h_out);
	fluid_a.h_outflow=0;

	heat.T=medium.T;
	fluid_b.m_flow=-fluid_a.m_flow; // mass conservation
	fluid_a.p=medium.p; // no pressure drops (it should all be ambient pressure)
	fluid_b.p=medium.p;

	Q_rad=A*sigma*em*(medium.T^4-Tamb^4); // radiative losses
	Q_con=A*alpha*(medium.T-Tamb); // convective losses

	if on then
		Q_loss=-Q_rad-Q_con;
	else
		Q_loss=0; // when the receiver is 'off', assume no thermal losses
	end if;

	// energy balance: mdot(h_out - h_in) = Q_abs - Q_loss, with some handling of low flow
	0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
	Q_rcv=fluid_a.m_flow*(h_out-h_in);
	eff=max(Q_rcv, 0)/max(1,heat.Q_flow);

	annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>A Shirazi:<br>Released first version. </li>
</ul>
</html>"));
end ParticleReceiver;
