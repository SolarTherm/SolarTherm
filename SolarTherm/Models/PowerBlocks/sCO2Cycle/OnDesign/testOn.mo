within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
model testOn
	extends SolarTherm.Media.CO2.PropCO2;
	
	parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
	parameter Real m_des=100;
	SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow srcTLMDt (p_out=250*10^5,T_out=600,m_flow=m_des) annotation(
		Placement(visible = true, transformation(origin = {46, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
	SourceFlow srcTLMDc (p_out=80*10^5,T_out=100,m_flow=0.7*m_des) annotation(
		Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkTLMDt annotation(
		Placement(visible = true, transformation(origin = {-44, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkTLMDc annotation(
		Placement(visible = true, transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
	SourceFlow srcDTAvec (p_out=85*10^5,T_out=100,m_flow=0.7*m_des) annotation(
		Placement(visible = true, transformation(origin = {-42, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow srcDTAvet (p_out=250*10^5,T_out=600,m_flow=m_des) annotation(
		Placement(visible = true, transformation(origin = {46, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
	SinkFlow sinkDTAvet annotation(
		Placement(visible = true, transformation(origin = {-42, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkDTAvec annotation(
		Placement(visible = true, transformation(origin = {46, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
	SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperatorDTAve TLMD (N_q=60) annotation(
		Placement(visible = true, transformation(origin = {0, -16}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
	OnDesign.HeatRecuperatorDTAve DTAve (N_q=15) annotation(
		Placement(visible = true, transformation(origin = {-4, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
	equation
	connect(DTAve.from_comp_port_b, sinkDTAvec.port_a) annotation(
		Line(points = {{6, 56}, {6, 56}, {6, 66}, {38, 66}, {38, 66}}, color = {0, 127, 255}));
	connect(srcDTAvec.port_b, DTAve.from_comp_port_a) annotation(
		Line(points = {{-34, 64}, {-16, 64}, {-16, 54}, {-16, 54}}, color = {0, 127, 255}));
	connect(DTAve.from_turb_port_b, sinkDTAvet.port_a) annotation(
		Line(points = {{-16, 38}, {-14, 38}, {-14, 30}, {-34, 30}, {-34, 30}}, color = {0, 127, 255}));
	connect(DTAve.from_turb_port_a, srcDTAvet.port_b) annotation(
		Line(points = {{6, 38}, {6, 38}, {6, 30}, {38, 30}, {38, 30}}, color = {0, 127, 255}));
	connect(TLMD.from_comp_port_a, srcTLMDc.port_b) annotation(
		Line(points = {{-14, -8}, {-16, -8}, {-16, 0}, {-36, 0}, {-36, 0}}, color = {0, 127, 255}));
	connect(TLMD.from_turb_port_b, sinkTLMDt.port_a) annotation(
		Line(points = {{-12, -26}, {-14, -26}, {-14, -30}, {-36, -30}, {-36, -30}}, color = {0, 127, 255}));
	connect(TLMD.from_turb_port_a, srcTLMDt.port_b) annotation(
		Line(points = {{12, -26}, {38, -26}, {38, -30}, {38, -30}}, color = {0, 127, 255}));
	connect(TLMD.from_comp_port_b, sinkTLMDc.port_a) annotation(
		Line(points = {{12, -8}, {12, -8}, {12, 0}, {34, 0}, {34, 0}}, color = {0, 127, 255}));
end testOn;
