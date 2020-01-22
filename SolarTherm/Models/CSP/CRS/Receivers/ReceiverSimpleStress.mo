within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverSimpleStress
	extends Interfaces.Models.ReceiverFluid;
	Medium.BaseProperties medium;
	SI.SpecificEnthalpy h_in;
	SI.SpecificEnthalpy h_out( start=h_0);
	//SI.MassFlowRate m_flow;
	parameter SI.Length H_rcv=1 "Receiver height" annotation(Dialog(group="Technical data"));
	parameter SI.Diameter D_rcv=1 "Receiver diameter" annotation(Dialog(group="Technical data"));
	parameter Integer N_pa = 1 "Number of panels" annotation(Dialog(group="Technical data"));
	parameter SI.Diameter D_tb=1 "Tube outer diameter" annotation(Dialog(group="Technical data"));
	parameter SI.Thickness t_tb=1 "Tube wall thickness" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency ab=1 "Coating absortance" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency em=1 "Coating Emitance" annotation(Dialog(group="Technical data"));

	//Begin new parameters
	parameter SI.ThermalConductivity k=20 "Tube thermal conductivity" annotation(Dialog(group="Technical data"));
	parameter SI.Stress E = 165e9 "Young's Modulus receiver tube material";
	parameter SI.LinearExpansionCoefficient lambda = 18.5e-6 "Coefficient of linear thermal expansion receiver tube material";
	parameter Real poisson = 0.3 "Poisson ratio of receiver tube material";
	parameter SI.CoefficientOfHeatTransfer alpha=30 "Convective heat transfer coefficient (Logie et al. 2015, Temperature and heat flux distributions in Sodium Receiver Tubes)";
	parameter Integer N_fl = 2 "Number of parallel flow-paths" annotation(Dialog(group="Technical data"));	
	parameter SI.Radius a = D_tb/2 - t_tb;
	parameter SI.Radius b = D_tb/2;
	//End new variables

	SI.HeatFlowRate Q_loss;
	SI.HeatFlowRate Q_rcv;

	//Begin new variables
	SI.CoefficientOfHeatTransfer alpha_ext "Overall heat transfer coefficient (Eq. 1.9 Incropera, Fundamentals of Heat and Mass Transfer, 6th ed)";
	SI.Efficiency Bi1;
	SI.Efficiency Bi2;
	SI.Efficiency gp1;
	SI.Efficiency gg1;
	SI.Efficiency gp2;
	SI.Efficiency gg2;
	SI.Stress sigma_theta;
	SI.Stress sigma_z;
	SI.Stress sigma_eq;
	Real sigma_eq_MPa;
	SI.TemperatureDifference B1(final start=0);
	SI.TemperatureDifference A1(final start=0);
	SI.TemperatureDifference B2(final start=0);
	SI.TemperatureDifference A2(final start=0);
	SI.TemperatureDifference DT(final start=0);
	Real K2(unit = "K/m");
	Real K1(unit = "K/m");
	replaceable model Nusselt = 
		SolarTherm.Models.CSP.CRS.Receivers.HeatTransfer.DittusBoelter constrainedby 
		SolarTherm.Models.CSP.CRS.Receivers.HeatTransfer.PartialHeatTransfer "Heat Transfer Correlation"	
		annotation (Dialog(group="Technical data",__Dymola_label="Nu"), choicesAllMatching=true);
	Nusselt nusselts(redeclare package Medium = Medium, state=states, v=vs, D=D_tb-2*t_tb, L=H_rcv);
	SI.Velocity vs "Mean velocity of fluid flow";
	SI.CoefficientOfHeatTransfer alphas "CoefficientOfHeatTransfer";
	Medium.ThermodynamicState states=Medium.setState_pTX(medium.p,medium.T);
	Medium.Density rhos=Medium.density(states) "Density";
	Medium.ThermalConductivity lambdas= Medium.thermalConductivity(states) "Thermal conductivity";
	SI.Temperature T_theta;
	//End new variables

	Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
				transformation(
				extent={{-12,-12},{12,12}},
				rotation=-90,
				origin={0,84}), iconTransformation(
				extent={{-6,-6},{6,6}},
				rotation=-90,
				origin={0,78})));

protected
	parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
	parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
	parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
	parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
	parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
equation
	
	medium.h=(h_in+h_out)/2;
	h_in=inStream(fluid_a.h_outflow);
	fluid_b.h_outflow=max(h_0,h_out);
	fluid_a.h_outflow=0;

	heat.T=medium.T;
	fluid_b.m_flow=-fluid_a.m_flow;
	fluid_a.p=medium.p;
	fluid_b.p=medium.p;

	//Begin thermal stress
	vs = fluid_a.m_flow/(N_fl*N_tb_pa*rhos*pi*a^2);
	alphas = nusselts.Nu*lambdas/(2*a);
	alpha_ext = alpha + sigma*em*(medium.T^2+Tamb^2)*(medium.T+Tamb);
	Bi1 = alphas*a/k;
	Bi2 = alpha_ext*b/k;
	gp1 = 1 - (a/b)^2*(1 - Bi1)/(1 + Bi1);
	gg1 = 1 + (a/b)^2*(1 - Bi1)/(1 + Bi1);
	gp2 = 2*(1 - (a/b)^4*(2 - Bi1)/(2 + Bi1));
	gg2 = 1 + (a/b)^4*(2 - Bi1)/(2 + Bi1);	
	A1 = 1/(2*(gp1 + Bi2*gg1));	
	A2 = -2/(-3*pi*(gp2 + Bi2*gg2));
	B1 = A1*(a/b)^2*(1 - Bi1)/(1 + Bi1);
	B2 = A2*(a/b)^4*(2 - Bi1)/(2 + Bi1);
	DT = (Q_rcv/div(D_rcv*pi,D_tb))*log(b/a)/(pi*k*H_rcv);
	K1 = DT/log(b/a);
	K2 = (B1*ab*(heat.Q_flow/A)*b^2/k)*b/(a^2 + b^2);	
	T_theta = A1 + B1 + A2 + B2;	
	sigma_theta = lambda*E/(2*(1-poisson))*(K1*(1 - 2*a^2/(b^2 - a^2)*log(b/a)) + K2*(2 - 2*a^2/b^2));
	sigma_z = poisson*(sigma_theta) + lambda*E*T_theta*ab*(heat.Q_flow/A)*b/k;
	sigma_eq = (((sigma_theta - sigma_z)^2 + (sigma_theta)^2 + (sigma_z)^2)/2)^0.5;
	sigma_eq_MPa = sigma_eq*1e-6;
	//End thermal stress

	Q_loss=-A*sigma*em*(medium.T^4-Tamb^4);
	0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
	Q_rcv=fluid_a.m_flow*(h_out-h_in);

	annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
<li>Armando Fontalvo:<br>Introduce thermo-elastic aproximation. </li>
</ul>
</html>"));
end ReceiverSimpleStress;
