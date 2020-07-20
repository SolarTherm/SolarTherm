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
	
	parameter Real c0 = -0.00000000000812828041;
	parameter Real c1 = 0.0000000221705242;
	parameter Real c2 = -0.0000229149451;
	parameter Real c3 = 0.0109275916;
	parameter Real c4 = -1.25070245;

	Medium.BaseProperties medium;

	SI.SpecificEnthalpy h_in "Specific enthalpy at inlet";
	SI.SpecificEnthalpy h_out(start=h_0) "Specific enthalpy at outlet";

	SI.Temperature T_in=Medium.temperature(state_in) "Temperature at inlet";
	SI.Temperature T_out=Medium.temperature(state_out) "Temperature at outlet";

	SI.HeatFlowRate Q_loss "Total losses";
	SI.HeatFlowRate Q_rcv "Heat flow captured by curtain";
	SI.Efficiency eta_rcv;

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

	parameter SI.Temperature T_0=from_degC(550) "Start value of temperature";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy h_0=SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(T_0);

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

	if on then
        eta_rcv = (heat.Q_flow/1e6)^4*c0 + (heat.Q_flow/1e6)^3 *c1 + (heat.Q_flow/1e6)^2 *c2 + (heat.Q_flow/1e6)*c3 + c4;
		Q_loss= (1-eta_rcv) * heat.Q_flow;
	else
        eta_rcv = 0;
		Q_loss=0; // when the receiver is 'off', assume no thermal losses
	end if;

	// energy balance: mdot(h_out - h_in) = Q_abs - Q_loss, with some handling of low flow
	heat.Q_flow = Q_loss + Q_rcv;
	Q_rcv=fluid_a.m_flow*(h_out-h_in);

	annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>A Shirazi:<br>Released first version. </li>
</ul>
</html>"));
end ParticleReceiver;
