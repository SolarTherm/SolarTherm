within SolarTherm.Models.CSP.CRS.Receivers;
model SodiumReceiver "ReceiverSimple with convective losses"
  extends Interfaces.Models.ReceiverFluid;
//  Medium.BaseProperties medium;

  parameter SI.Length H_rcv=1 "Receiver height" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_rcv=1 "Receiver diameter" annotation(Dialog(group="Technical data"));
  parameter Integer N_pa=1 "Number of panels" annotation(Dialog(group="Technical data"));
  parameter Integer N_fp=1 "Number of flow paths" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_tb=1 "Tube outer diameter" annotation(Dialog(group="Technical data"));
  parameter SI.Thickness t_tb=1 "Tube wall thickness" annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency ab=1 "Coating absortance" annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency em=1 "Coating Emitance" annotation(Dialog(group="Technical data"));

  SI.HeatFlowRate Q_emi;
  SI.HeatFlowRate Q_conv;
  SI.HeatFlowRate Q_ref;
  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  SI.Temperature Tl;
  SI.Temperature T4l;
  SI.CoefficientOfHeatTransfer h_conv;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));

	Modelica.Blocks.Interfaces.RealInput Wspd annotation (Placement(
				transformation(
				extent={{-12,-12},{12,12}},
				rotation=-90,
				origin={-20,84}), iconTransformation(
				extent={{-6,-6},{6,6}},
				rotation=-90,
				origin={-20,78})));

	Modelica.Blocks.Interfaces.BooleanInput on;

	Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature", final unit = "K", displayUnit = "degC", min=0);

	Modelica.Blocks.Interfaces.RealOutput Q_rec_out;

	Medium.ThermodynamicState state_in = Medium.setState_phX(fluid_a.p, inStream(fluid_a.h_outflow));
	Medium.ThermodynamicState state_out = Medium.setState_phX(fluid_b.p, fluid_b.h_outflow);
	SI.Temperature T_in=Medium.temperature(state_in) "Temperature at inlet";
	SI.Temperature T_out=Medium.temperature(state_out) "Temperature at outlet";
	Real y;

	Real eps = Modelica.Constants.small;
	parameter Real[4] CL = {637.103623184,0.060789074969,0.294669725552,-0.266896221475} "Coefs to calculate Tl";
	parameter Real[4] C4L = {669.573988852,0.0551284588504,0.2445016803,-0.237843095521} "Coefs to calculate T4l";
	parameter Real[5] CH = {0.00100914180763,-0.045717460056,0.728433523594,-0.971343416823,9.55891878337} "Coefs to calculate h_conv";

	parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
	SI.MassFlowRate m_flow_tb = fluid_a.m_flow/N_tb_pa/N_fp "Tube mass flow rate";
protected
	parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
	parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
	parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
	parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
equation
	T = T_in;
	
	heat.T=Tamb;
	fluid_a.m_flow + fluid_b.m_flow = 0.0;
	fluid_a.p - fluid_b.p = 0.0;
	fluid_a.h_outflow=inStream(fluid_a.h_outflow);
	
	if on then
		Tl = CL[1] + CL[2]*heat.Q_flow/1e6 + CL[3]*Tamb + CL[4]*Wspd;
		T4l = C4L[1] + C4L[2]*heat.Q_flow/1e6 + C4L[3]*Tamb + C4L[4]*Wspd;
		Q_rec_out = heat.Q_flow + Q_loss;
	else
		Tl = Tamb;
		T4l = Tamb;
		Q_rec_out = heat.Q_flow;
	end if;
	h_conv = CH[5] + CH[4]*Wspd + CH[3]*Wspd^2 + CH[2]*Wspd^3 + CH[1]*Wspd^4;
	Q_ref = (1 - ab)*heat.Q_flow;
	Q_emi = em*sigma*A*(T4l^4 - Tamb^4);
	Q_conv = h_conv*A*(Tl - Tamb);
	Q_loss + Q_emi + Q_conv + Q_ref = 0.0;
	y = 1;

	0 = heat.Q_flow + Q_loss + (fluid_a.m_flow + eps)*(inStream(fluid_a.h_outflow) - fluid_b.h_outflow);
	Q_rcv = (fluid_a.m_flow + eps)*(inStream(fluid_a.h_outflow) - fluid_b.h_outflow);

annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Armando Fontalvo:<br>Released first version. </li>
</ul>
</html>"),
	Icon(graphics = {Text(origin = {0, -140}, lineColor = {0, 0, 255}, extent = {{-120, 20}, {120, -20}}, textString = "%name")}));
end SodiumReceiver;