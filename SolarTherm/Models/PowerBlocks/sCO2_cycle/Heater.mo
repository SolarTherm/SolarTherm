within SolarTherm.Models.PowerBlocks.sCO2_cycle;
model Heater "A simple counterflow heat exchanger model based on LMTD method"
	import Modelica.SIunits.Conversions.*;
	import CN = Modelica.Constants;
	import SI = Modelica.SIunits;
	import Modelica.Math;

	replaceable package Medium_A = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph "Hot stream medium";
	replaceable package Medium_B = SolarTherm.Media.CarbonDioxide "Cold stream medium";

	parameter String fluid = "R744";
	parameter SI.Area A = 1000 "Heat transfer surface area";
	parameter SI.CoefficientOfHeatTransfer U = 1000 "Heat tranfer coefficient";
	parameter SI.TemperatureDifference dT_approach = 15 "Minimum temperature difference between streams";
	parameter SI.TemperatureDifference LMTD_des = 40.36 "Logarithmic mean temperature difference at design";
	parameter SI.MassFlowRate m_flow_a_des = 1000 "Hot stream mass flow rate at design";
	parameter SI.Pressure p_a_des = 1e5 "Hot stream pressure";
	parameter SI.Pressure p_b_des = 24e5 "Cold stream pressure";
	parameter SI.Temperature T_a_in_des = from_degC(715) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_a_out_des = from_degC(500) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_b_in_des = from_degC(113) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_b_out_des = from_degC(715) "Cold stream outlet temperature at design";
	parameter SI.SpecificEnthalpy h_a_in_des = Medium_A.specificEnthalpy(Medium_A.setState_pTX(p_a_des,T_a_in_des)) "Hot stream inlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_a_out_des = Medium_A.specificEnthalpy(Medium_A.setState_pTX(p_a_des,T_a_out_des)) "Hot stream outlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_b_in_des = Medium_B.specificEnthalpy(Medium_B.setState_pTX(p_b_des,T_b_in_des)) "Cold stream inlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_b_out_des = Medium_B.specificEnthalpy(Medium_B.setState_pTX(p_b_des,T_b_out_des)) "Cold stream outlet enthalpy at design";
	parameter SI.MassFlowRate m_flow_b_des = Q_flow_des/(h_b_out_des - h_b_in_des) "Cold side mass flow rate";
	parameter SI.HeatFlowRate Q_flow_des = m_flow_a_des*(h_a_in_des - h_a_out_des) "Heat flow from hot to cold streams at design";

	Medium_A.ThermodynamicState state_a_in = Medium_A.setState_phX(port_a_in.p,inStream(port_a_in.h_outflow)) "Hot stream inlet thermodynamic state";
	Medium_A.ThermodynamicState state_a_out = Medium_A.setState_pTX(port_a_in.p,T_a_out) "Hot stream outlet thermodynamic state";
	Medium_B.ThermodynamicState state_b_in = Medium_B.setState_phX(port_b_in.p,inStream(port_b_in.h_outflow)) "Cold stream inlet thermodynamic state";
	Medium_B.ThermodynamicState state_b_out = Medium_B.setState_pTX(port_b_in.p,T_b_out) "Cold stream outlet thermodynamic state";

	SI.Temperature T_a_in(start = T_a_in_des) "Hot stream inlet temperature";
	SI.Temperature T_a_out(start = T_a_out_des) "Hot stream outlet temperature";
	SI.Temperature T_b_in(start = T_b_in_des) "Cold stream inlet temperature";
	SI.Temperature T_b_out(start = T_b_out_des) "Cold stream outlet temperature";

	SI.HeatFlowRate Q_flow(start = Q_flow_des) "Heat flow from hot to cold side";
	SI.TemperatureDifference LMTD(start = LMTD_des) "Logarithmic mean temperature difference";

	Modelica.Fluid.Interfaces.FluidPort_a port_a_in(redeclare package Medium = Medium_A)
		annotation (Placement(visible = true,transformation(origin = {40, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
		iconTransformation(origin = {40, 21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_a_out(redeclare package Medium = Medium_A)
		annotation (Placement(visible = true,transformation(origin = {-40, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
		iconTransformation(origin = {-40, 21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_a port_b_in(redeclare package Medium = Medium_B)
		annotation (Placement(visible = true,transformation(origin = {-40, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
		iconTransformation(origin = {-40, -21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_b_out(redeclare package Medium = Medium_B)
		annotation (Placement(visible = true,transformation(origin = {40, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
		iconTransformation(origin = {40, -21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
equation
	//Mass balance
	port_a_in.m_flow - port_a_out.m_flow = 0;
	port_b_out.m_flow - port_b_in.m_flow = 0;
	
	//Inlet and outlet pressure
	port_a_out.h_outflow = Medium_A.specificEnthalpy(state_a_out);

	T_a_in = Medium_A.temperature(state_a_in);
	T_b_in = Medium_B.temperature(state_b_in);
	
	dT_approach = T_a_out - T_b_in;
	Q_flow = port_a_in.m_flow*(inStream(port_a_in.h_outflow) - port_a_out.h_outflow);
	Q_flow = U*A*LMTD;
	LMTD = ((T_a_in-T_b_out)-dT_approach)/(Math.log((T_a_in-T_b_out)/dT_approach));
	Q_flow = port_b_in.m_flow*(port_b_out.h_outflow - inStream(port_b_in.h_outflow));

	port_a_out.p = port_a_in.p;
	port_b_out.p = p_b_des;

	// Shouldn't have reverse flows
	port_a_in.h_outflow = h_a_in_des;
	port_b_in.h_outflow = h_b_in_des;
	
	annotation (Documentation(info = "<html>
	<p>
		<b>Heater</b> heat exchanger model.
	</p>
	</html>", revisions = "<html>
	<ul>		
		<li><i>Mar 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		First release.</li>
	</ul>
	</html>"),
	Icon(graphics = {
	
	Rectangle(
	fillColor = {255, 255, 255}, 
	fillPattern = FillPattern.Solid, 
	extent = {{-40,-40}, {40, 40}}),  
	
	Line(
	origin = {17.0281, 33.0904},
	points = {{-56.9596, -11.3792}, 
	{-34.9596, -11.3792}, 
	{-32.9596, -5.37918}, 
	{-28.9596, -17.3792}, 
	{-24.9596, -5.37918}, 
	{-20.9596, -17.3792}, 
	{-16.9596, -5.37918}, 
	{-12.9596, -17.3792}, 
	{-8.95957, -5.37918}, 
	{-4.95957, -17.3792}, 
	{-0.9596, -5.37918}, 
	{1.0404, -11.3792}, 
	{23.0404, -11.3792}}, 
	color = {206, 0, 0}), 
	
	Line(
	origin = {17.0281, -9.2511}, 
	points = {{-56.9596, -11.3792}, 
	{-34.9596, -11.3792}, 
	{-32.9596, -5.37918}, 
	{-28.9596, -17.3792}, 
	{-24.9596, -5.37918}, 
	{-20.9596, -17.3792}, 
	{-16.9596, -5.37918}, 
	{-12.9596, -17.3792}, 
	{-8.95957, -5.37918}, 
	{-4.95957, -17.3792}, 
	{-0.9596, -5.37918}, 
	{1.0404, -11.3792}, 
	{23.0404, -11.3792}}, 
	color = {0, 127, 255})}, 
	
	coordinateSystem(
		preserveAspectRatio=true,
		extent={{-40,-40},{40,40}})));
end Heater;
