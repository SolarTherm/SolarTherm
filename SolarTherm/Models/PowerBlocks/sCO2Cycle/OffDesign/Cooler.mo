within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model Cooler
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		input Modelica.SIunits.ThermodynamicTemperature T_amb "Ambiant temperature in Kelvin";
		Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		parameter SolarTherm.Types.Conductance UA_cooler "Conductance of the cooler in W/K";
		parameter Modelica.SIunits.ThermodynamicTemperature T_low = 55 + 273.15;
		parameter Modelica.SIunits.Power P_cool_design = 1.49*10^6 "power necessary to cool down at design point";
		parameter Real deltaT_design = 15 "Difference between ambient and outlet CO2 temperature";
		MedPB.ThermodynamicState state_a "Thermodynamic State at the entrance";
		MedPB.ThermodynamicState state_b "Thermodynamic State at the outlet";
		Real[2] deltaT;
		Modelica.SIunits.HeatFlowRate Q_cooler;
		Modelica.SIunits.Power P_cooling;
		Real deltaT_ave "average difference of temperature with the ambiant";
	equation
		deltaT = {MedPB.temperature(state_a) - T_amb, MedPB.temperature(state_b) - T_amb};
		state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
		state_b = MedPB.setState_pTX(port_a.p, max(T_amb+3,T_low));
		P_cooling = P_cool_design * (deltaT_design/deltaT[2])^(3/0.805);
		deltaT_ave = (deltaT[1] + deltaT[2]) / 2;
		Q_cooler = port_a.m_flow * (state_b.h - state_a.h);
		port_a.m_flow + port_b.m_flow = 0;
		port_a.p = port_b.p;
		port_b.h_outflow = state_b.h;
		port_a.h_outflow = inStream(port_b.h_outflow);
		annotation(
			Documentation(info = "<html>
			<p>The cooler is thought to be a dry-air cooling device. The outlet temperature of the CO2 is imposed as max(T_low_cycle,T_amb+3). The variation of the ambiant temperature is taken into account in the estimation of the electricity demand for the fans, such as: P_cooling*deltaT/Q_cooler is a constant, deltaT being the average of the temperature of the CO2 and the ambiant, and Q_cooler the energy to withdraw.</p>
			</html>"));
		annotation(
			Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-58, 65}, {58, -65}}), Text(origin = {0, -1}, extent = {{-40, -15}, {40, 15}}, textString = "COOLER")}),
			Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-64, 67}, {64, -67}}), Text(origin = {5, 14}, extent = {{-41, -12}, {41, 12}}, textString = "COOLER")}));
	end Cooler;
