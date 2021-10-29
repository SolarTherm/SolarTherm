within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
model Cooler "0D model of a dry-cooler"
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	outer Modelica.Fluid.System system;
	parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 313.15 "Outlet temperature in Kelvin";
	parameter Real deltaT_cooler = 15 "Approach difference of temperature at the outlet";
	parameter Modelica.SIunits.Power P_nom = 10 ^ 6;
	parameter Integer N_cool = 15 "Number of discretization of the cooler";
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	SolarTherm.Types.Conductance UA_dis[N_cool-1] "Conductance of the cooler per sub-HX";
	Modelica.SIunits.HeatFlowRate Q_dis (start=10^7/N_cool)"Heat flow rate dispatched per sub-HX in the cooler";
	Modelica.SIunits.ThermodynamicTemperature[N_cool] T_CO2;
	Modelica.SIunits.HeatFlowRate Q_cooler (start=10^7) "Heat flow rate in the cooler";
	SolarTherm.Types.Conductance UA_cooler "Overall conductance of the cooler";
	SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
	Real[N_cool-1] deltaT_lm "logarithmic temperature difference";
	Real[N_cool] deltaT "difference with the ambiant air at the inlet and outlet";
	Modelica.SIunits.Power P_cooling "Power used by the fans to cool the fluid";
	Real deltaT_ave "average difference of temperature with the ambiant";
	protected
	MedPB.ThermodynamicState[N_cool] state "Thermodynamic State at the i-th position";
	Modelica.SIunits.SpecificEnthalpy[N_cool] h_CO2;
	equation
	for i in 1:N_cool loop
		state[i]=MedPB.setState_pTX(port_a.p,T_CO2[i]);
		h_CO2[i]=state[i].h;
		deltaT[i]=T_CO2[i]-T_amb;
	end for;
	T_CO2[N_cool]=T_amb+deltaT_cooler;
	h_CO2[1]=inStream(port_a.h_outflow);
	for i in 1:(N_cool-1) loop
		Q_dis=port_a.m_flow*(h_CO2[i+1]-h_CO2[i]);
		Q_dis=-UA_dis[i]*deltaT_lm[i];
		deltaT_lm[i] = if deltaT[i+1] * deltaT[i] < 0 then (abs(deltaT[i]) ^ (1 / 3) * sign(deltaT[i]) / 2 + abs(deltaT[i+1]) ^ (1 / 3) * sign(deltaT[i+1]) / 2) ^ 3 else (deltaT[i] - deltaT[i+1]) / (Modelica.Math.log(deltaT[i] / deltaT[i+1]) + 0.0001);
	end for;
	UA_cooler=sum(UA_dis);
	Q_cooler = port_a.m_flow*(h_CO2[N_cool]-h_CO2[1]);
	
	port_a.m_flow + port_b.m_flow = 0;
	port_a.p = port_b.p;
	port_b.h_outflow = h_CO2[N_cool];
	port_a.h_outflow = inStream(port_b.h_outflow);
	ex_d = P_cooling + port_a.m_flow * (MedPB.specificEnthalpy(state[1])- T_amb * MedPB.specificEntropy(state[1])) + port_b.m_flow * (MedPB.specificEnthalpy(state[N_cool]) - T_amb * MedPB.specificEntropy(state[N_cool]));
	P_cooling * deltaT[N_cool] / (-Q_cooler) = 1.49*10^6*(35.7-30)/(136.6*10^6);
	deltaT_ave = (deltaT[1] + deltaT[N_cool]) / 2;
	
	annotation(
		Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-58, 65}, {58, -65}}), Text(origin = {0, -1}, extent = {{-40, -15}, {40, 15}}, textString = "COOLER")}),
	Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-64, 67}, {64, -67}}), Text(origin = {5, 14}, extent = {{-41, -12}, {41, 12}}, textString = "COOLER")}));
	annotation(
		Documentation(info = "<html>
		<p> The overall conductance UA of the cooler is calculated with a logarithmic temperature difference. It is implemented in order to ensure convergence. </p>
		<p>The Cp is varying from 4kJ/kg.K to 1.2 kJ/kg.K in this temperature/pressure range. It is therefore not very accurate but can be used for economical estimations. </p>
		<p> The outlet temperature is fixed by the user. The electrical power necessary for the fans is estimated by	P_elec/(Q_cooler*deltaT_average)=constante, for any sCO2/air HX. P_elec is the power to run the fans, Q_cooler is the energy exchanged with outside and deltaT_average is the average of T_CO2-T_amb, the average is taken between the outlet and the inlet. </p>
		<p> Reference values (but not model) come from: </p> <p>Sienicki, James J., Moisseytsev, Anton, and Lv, Qiuping. Dry Air Cooling and the sCO2 Brayton Cycle. Proceedings of the ASME Turbo Expo 2017: Turbomachinery Technical Conference and Exposition. Volume 9: Oil and Gas Applications; Supercritical CO2 Power Cycles; Wind Energy. Charlotte, North Carolina, USA. June 26–30, 2017. V009T38A015. ASME. https://doi.org/10.1115/GT2017-64042	</p>
			
	
		</html>"));
end Cooler;
