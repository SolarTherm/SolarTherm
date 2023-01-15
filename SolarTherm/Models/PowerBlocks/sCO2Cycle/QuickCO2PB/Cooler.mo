within SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB;
	model Cooler
		extends SolarTherm.Media.CO2.PropCO2;
		import SI = Modelica.SIunits;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		input Boolean m_sup;
		input SI.ThermodynamicTemperature T_amb "Ambiant temperature in Kelvin";
		parameter SI.ThermodynamicTemperature T_amb_des = 40 + 273.15 "Ambiant temperature in Kelvin at design point";
		parameter SolarTherm.Types.Conductance UA_cooler(fixed = false) "Conductance of the cooler in W/K";
		parameter SI.ThermodynamicTemperature T_low = 55 + 273.15;
		parameter SI.Power P_nom_des = 164000;
		parameter Integer N_cool = 15;
		parameter Real deltaT_design = 15 "Difference between ambient and outlet CO2 temperature";
		MedPB.ThermodynamicState state_a "Thermodynamic State at the entrance";
		MedPB.ThermodynamicState state_b "Thermodynamic State at the outlet";
		Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB, m_flow.start = P_nom_des / 10 ^ 5) annotation(
			Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Real[2] deltaT;
		SI.HeatFlowRate Q_cooler;
		SI.Power P_cooling;
		parameter SolarTherm.Types.Conductance UA_dis[N_cool - 1](each fixed = false) "Conductance of the cooler per sub-HX";
		parameter SI.Power P_cool_des(fixed = false, start = 0.01 * P_nom_des) "power necessary to cool down at design point";
		parameter SI.SpecificEnthalpy h_in_des(fixed = false), h_out_des(fixed = false);
		parameter SI.AbsolutePressure p_in_des(fixed = false);
		parameter SI.AbsolutePressure p_out_des(fixed = false);
		parameter SI.MassFlowRate m_des(fixed = false);
		parameter SI.HeatFlowRate Q_cooler_des(fixed = false, start = 10 ^ 6);
		parameter MedPB.ThermodynamicState[N_cool] state_des(each p.fixed = false, each h.fixed = false) "Thermodynamic State at the i-th position";
		parameter SI.SpecificEnthalpy[N_cool] h_CO2_des(each fixed = false, start = {600000 - i / N_cool * 150000 for i in 1:N_cool});
		//parameter Real[N_cool-1] deltaT_lm_des (each fixed=false)"logarithmic temperature difference";
		parameter Real[N_cool] deltaT_des(each fixed = false, each start = 25) "difference with the ambiant air at the inlet and outlet";
		parameter SI.HeatFlowRate Q_dis_des(fixed = false, start = 10 ^ 5) "Heat flow rate dispatched per sub-HX in the cooler";
		parameter SI.ThermodynamicTemperature[N_cool] T_CO2_des(each fixed = false, each start = 273.15 + 75);
	initial equation
		for i in 1:N_cool loop
			state_des[i] = MedPB.setState_pTX(p_in_des, T_CO2_des[i]);
			h_CO2_des[i] = MedPB.specificEnthalpy(state_des[i]);
			deltaT_des[i] = T_CO2_des[i] - T_amb_des;
		end for;
		T_CO2_des[N_cool] = T_low;
		h_CO2_des[1] = h_in_des;
		h_CO2_des[N_cool] = h_out_des;
		p_out_des = p_in_des;
		for i in 1:N_cool - 1 loop
			Q_dis_des = h_CO2_des[i + 1] - h_CO2_des[i];
			m_des * Q_dis_des = -UA_dis[i] * (deltaT_des[i] + deltaT_des[i + 1]) / 2;
//deltaT_lm_des[i] = if deltaT_des[i+1] * deltaT_des[i] < 0 then (abs(deltaT_des[i]) ^ (1 / 3) * sign(deltaT_des[i]) / 2 + abs(deltaT_des[i+1]) ^ (1 / 3) * sign(deltaT_des[i+1]) / 2) ^ 3 else (deltaT_des[i] - deltaT_des[i+1]) / (Modelica.Math.log(deltaT_des[i] / deltaT_des[i+1]) + 0.0001);
		end for;
		UA_cooler = sum(UA_dis);
		Q_cooler_des = (N_cool - 1) * Q_dis_des * m_des;
//P_cool_des * deltaT_des[N_cool]/(-Q_cooler_des)= 1.49*10^6*(35.7-30)/(136.6*10^6);
		P_cool_des = 0.01 * P_nom_des;
	equation
		deltaT = {MedPB.temperature(state_a) - T_amb, MedPB.temperature(state_b) - T_amb};
		state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
		state_b = MedPB.setState_pTX(port_a.p, max(T_amb + 5, T_low));
		P_cooling = P_cool_des * (deltaT_design / deltaT[2]) ^ (3 / 0.805) * (Q_cooler / Q_cooler_des);
		Q_cooler = port_a.m_flow * (state_b.h - state_a.h);
		port_a.m_flow + port_b.m_flow = 0;
		port_a.p = port_b.p;
		port_b.h_outflow = state_b.h;
		port_a.h_outflow = inStream(port_b.h_outflow);
		annotation(
			Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-58, 65}, {58, -65}}), Text(origin = {0, -1}, extent = {{-40, -15}, {40, 15}}, textString = "COOLER")}),
			Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-64, 67}, {64, -67}}), Text(origin = {5, 14}, extent = {{-41, -12}, {41, 12}}, textString = "COOLER")}),
			Documentation(info = "<html>
			<p>The cooler is thought to be a dry-air cooling device. The outlet temperature of the CO2 is imposed as max(T_low_cycle,T_amb+3). The variation of the ambiant temperature is taken into account in the estimation of the electricity demand for the fans, such as: P_cooling*deltaT/Q_cooler is a constant, deltaT being the average of the temperature of the CO2 and the ambiant, and Q_cooler the energy to withdraw.</p>
			</html>"));
	end Cooler;


