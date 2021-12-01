within SolarTherm.Models.Fluid.HeatExchangers;
model SimpleHeatExchanger "A simple counterflow heat exchanger model based on LMTD method"
	import SI = Modelica.SIunits;
	import CV = Modelica.SIunits.Conversions;
	import Modelica.Math.*;
	import Modelica.Constants.pi;

	final parameter Real eps = Modelica.Constants.small;

	replaceable package Medium_h = SolarTherm.Media.Sodium.Sodium_pT;
	replaceable package Medium_c = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;

	Modelica.Fluid.Interfaces.FluidPort_a port_c_in(redeclare package Medium = Medium_h)
		annotation (Placement(visible = true,transformation(origin = {-26, 35}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {-26, 35}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_c_out(redeclare package Medium = Medium_h)
		annotation (Placement(visible = true,transformation(origin = {-26, -35}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {-26, -35}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));

	Modelica.Fluid.Interfaces.FluidPort_a port_h_in(redeclare package Medium = Medium_h)
		annotation (Placement(visible = true,transformation(origin = {44, -21}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {44, -21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_h_out(redeclare package Medium = Medium_h)
		annotation (Placement(visible = true,transformation(origin = {44, 21}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {44, 21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));

	parameter SI.HeatFlowRate Q_flow_des = 50e6;
	parameter SI.Temperature T_h_in_des = CV.from_degC(594);
	parameter SI.Temperature T_h_out_des = CV.from_degC(310);
	parameter SI.Temperature T_c_in_des = CV.from_degC(290);
	parameter SI.Temperature T_c_out_des = CV.from_degC(574);
	final parameter Medium_h.ThermodynamicState state_h_in_des = Medium_h.setState_pTX(Medium_h.p_default, T_h_in_des);
	final parameter Medium_h.ThermodynamicState state_h_out_des = Medium_h.setState_pTX(Medium_h.p_default, T_h_out_des);
	final parameter SI.CoefficientOfHeatTransfer U = Q_flow_des/A/(T_h_in_des - T_c_out_des);
	SI.TemperatureDifference LMTD;
	SI.Temperature T_h_in = Medium_h.temperature(state_h_in);
	SI.Temperature T_h_out = Medium_h.temperature(state_h_out);
	SI.Temperature T_c_in = Medium_c.temperature(state_c_in);
	SI.Temperature T_c_out = Medium_c.temperature(state_c_out);

	// Variables
	SI.HeatFlowRate Q_flow;
	Medium_h.ThermodynamicState state_h_in = Medium_h.setState_phX(port_h_in.p, inStream(port_h_in.h_outflow));
	Medium_h.ThermodynamicState state_h_out = Medium_h.setState_phX(port_h_out.p, port_h_out.h_outflow);
	Medium_c.ThermodynamicState state_c_in = Medium_c.setState_phX(port_c_in.p, inStream(port_c_in.h_outflow));
	Medium_c.ThermodynamicState state_c_out = Medium_c.setState_phX(port_c_out.p, port_c_out.h_outflow);
	SI.TemperatureDifference dT1 = T_h_in - T_c_out;
	SI.TemperatureDifference dT2 = T_h_out - T_c_in;

	parameter SI.Length L = 19.9665 "Length of the heat exchanger";
	parameter SI.Diameter Ds = 1.91969 "Shell ID";
	parameter SI.Diameter dot = 19.05/1000 "Tube OD";
	parameter SI.Thickness tt = 1.2/1000 "Tube thickness";
	final parameter SI.Length dit = dot - 2*tt "Tube ID";
	parameter Integer Nt = 5957 "Number of tubes";
	final parameter SI.Area A = pi*dot*L*Nt "Heat exchange area";
	final parameter SI.Volume V_h = 0.25*pi*dit^2*L*Nt "Volume of hot fluid inside tubes";
	final parameter SI.Volume V_c = 0.2*pi*Ds^2*L - V_h "Volume of cold fluid inside shell";
//initial equation
//	if noEvent(port_h_in.m_flow > 0.0) then
//		0 = port_c_in.m_flow*(inStream(port_c_in.h_outflow) - medium_c.h);
//	else
//		0 = inStream(port_c_in.h_outflow) - medium_c.h;
//	end if;

//	medium_h.T = T_h_out_des;

equation
	// Pressure drop
	port_h_in.p = port_h_out.p;
	port_c_in.p = port_c_out.p;
	// Mass balance in hot and cold streams
	port_h_in.m_flow + port_h_out.m_flow = 0;
	port_c_in.m_flow + port_c_out.m_flow = 0;
	// Energy balance
	0.0 = port_h_in.m_flow*(inStream(port_h_in.h_outflow) - port_h_out.h_outflow) - Q_flow;
	0.0 = port_c_in.m_flow*(inStream(port_c_in.h_outflow) - port_c_out.h_outflow) + Q_flow;
	Q_flow = U*A*LMTD;
	if noEvent(port_h_in.m_flow > 0.0) then
		LMTD = if noEvent(dT1*dT2 < eps) then 0 else max(eps,(dT1 - dT2)/log(max(dT1/dT2, eps)));
	else
		LMTD = 0;
	end if;
	//Shouldn't have reverse flows
	port_c_in.h_outflow = inStream(port_c_in.h_outflow);
	port_h_in.h_outflow = inStream(port_h_in.h_outflow);
	
	annotation (
	Icon(coordinateSystem(extent = {{-40, -40}, {40, 40}},preserveAspectRatio=true), 
	graphics = {Rectangle(origin = {10, 10}, lineColor = {46, 52, 54}, fillColor = {211, 215, 207}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 20}, {20, -40}}), 
	Ellipse(origin = {-30, 0}, lineColor = {46, 52, 54}, fillColor = {211, 215, 207}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, extent = {{-22, 30}, {22, -30}}), 
	Rectangle(origin = {-26, 33}, lineColor = {46, 52, 54}, fillColor = {211, 215, 207}, fillPattern = FillPattern.VerticalCylinder, extent = {{-2, 3}, {2, -3}}), 
	Rectangle(origin = {-26, -33}, lineColor = {46, 52, 54}, fillColor = {211, 215, 207}, fillPattern = FillPattern.VerticalCylinder, extent = {{-2, 3}, {2, -3}}), 
	Ellipse(origin = {28, 0}, lineColor = {46, 52, 54}, fillColor = {211, 215, 207}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, extent = {{-22, 30}, {22, -30}}), 
	Line(origin = {18.16, 3.16}, points = {{24.8675, -24.1325}, {-57.1325, -24.1325}, {-57.1325, -10.1325}, {20.8675, -10.1325}, {20.8675, 3.86754}, {-57.1325, 3.86754}, {-57.1325, 17.8675}, {24.8675, 17.8675}}, thickness = 0.5), 
	Text(
		origin = {10, 50}, 
		lineColor = {0, 0, 255}, 
		extent = {{-30, 1}, {30, -9}}, 
		textString = "%name")}),
	Diagram(
	coordinateSystem(extent = {{-40, -40}, {40, 40}})
	)
	);
end SimpleHeatExchanger;
