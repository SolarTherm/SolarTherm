within SolarTherm.Models.CSP.CRS.Receivers.Panel;
model PanelSimple
	import SolarTherm.Media;
	import Modelica.Utilities.Streams.*;
	import Modelica.Utilities.Strings.*;
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;	
	import Modelica.Constants.*;
	import Modelica.Math.*;

	replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities; //SolarTherm.Media.Sodium.Sodium_utilities;

	Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MediumpT)
		annotation (Placement(visible = true,transformation(extent = {{-86, -8}, {-66, 12}}, rotation = 0), iconTransformation(extent = {{-86, -12}, {-66, 8}}, rotation = 0)));

	Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MediumpT)
		annotation (Placement(visible = true,transformation(extent = {{64, -8}, {84, 12}}, rotation = 0), iconTransformation(extent = {{66, -12}, {86, 8}}, rotation = 0)));

	replaceable package MediumpT = SolarTherm.Media.MoltenSalt.MoltenSalt_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium in the component"
		annotation (choicesAllMatching = true,Dialog(group="Working fluid"));

	parameter Modelica.SIunits.ThermalConductivity kt = 20 "Tube metal thermal conductivity";
	parameter SI.LinearExpansionCoefficient lambdat = 18.5e-6 "Coefficient of linear thermal expansion receiver tube material";
	parameter SI.Stress E = 165e9 "Young's Modulus receiver tube material";
	parameter SI.Efficiency poisson = 0.3 "Poisson ratio of receiver tube material";
	parameter SI.Radius a = 21e-3 "Inner tube radius";
	parameter SI.Radius b = 22.5e-3 "Outer tube radius";
	parameter SI.Diameter D_tb= 45e-3 "Tube outer diameter";
	parameter SI.Height H_rcv = 10.5 "Receiver height"; //Gemasolar solar power tower https://doi.org/10.1016/j.solener.2015.12.055
	parameter SI.Area A_ele = w_pa*H_rcv/Nel;
	parameter SI.Length w_pa = 1.395 "Panel width"; //Gemasolar solar power tower https://doi.org/10.1016/j.solener.2015.12.055

	//Number of panels
	parameter Integer Npa_fl = 9 "Number of panels per flowpath"; //Gemasolar solar power tower https://doi.org/10.1016/j.solener.2015.12.055
	parameter Integer Nel=25 "Number of vertical elements per tube";
	parameter Real N_tb_pa = 31 "Number of tubes per panel"; //div(w_pa,D_tb)
	parameter SI.DensityOfHeatFlowRate q=850e3 "Incoming solar flux";
	parameter SI.Temperature T_in = from_degC(290) "Inlet fluid temperature";
	parameter SI.Efficiency ab=0.94 "Coating absortance";
	parameter SI.Efficiency em=0.86 "Coating emissivity";
	parameter SI.Temperature Tamb = 298.15 "Ambient temperature";
	parameter SI.CoefficientOfHeatTransfer h_ext = 10 "Coefficient of external heat transfer due to external convection";
	parameter Integer N_start = 0 "Starting position";
	parameter Real factor = 1;
	parameter SI.Thickness e = 0.002e-3 "Pipe internal roughness";
	Real f[Nel*Npa_fl] "Darcy friction factor";
	parameter Real L_e_45 = 16.0 "Equivalent lenght for an 45 degree elbow";
	parameter Real L_e_90 = 30.0 "Equivalent lenght for an 90 degree elbow";
	SI.PressureDifference dP_tube[Nel*Npa_fl] "Pressure drop per tube";
	SI.PressureDifference dP_net "Net pressure drop in the receiver";

	SI.SpecificHeatCapacity Cp[Nel*Npa_fl] "Specific Heat Capacity of fluid flow";
	SI.Density rho[Nel*Npa_fl] "Density of fluid flow";
	SI.ThermalConductivity lambda[Nel*Npa_fl] "Density of fluid flow";
	SI.DynamicViscosity muf[Nel*Npa_fl] "Density of fluid flow";
	SI.Velocity vf[Nel*Npa_fl] "Mean velocity of fluid flow";
	SI.MassFlowRate m_dot;
	SI.SpecificEnthalpy h_in; //= Medium.h_T(T_in);
	SI.Temperature Tf[Nel*Npa_fl](each start = T_in);
	SI.SpecificEnthalpy hf[Nel*Npa_fl](each start = Medium.h_T(T_in));
	SI.HeatFlowRate Q_loss[Nel*Npa_fl];
	SI.HeatFlowRate Q_rcv[Nel*Npa_fl];
	SI.HeatFlowRate Q_htf[Nel*Npa_fl];
	Real Ta[Nel*Npa_fl];
	Real Bi1[Nel*Npa_fl];
	Real Bi2[Nel*Npa_fl];
	Real Re[Nel*Npa_fl];
	Real Pr[Nel*Npa_fl];
	Real Nu[Nel*Npa_fl];
	SI.CoefficientOfHeatTransfer h_int[Nel*Npa_fl];
	SI.CoefficientOfHeatTransfer alpha_ext[Nel*Npa_fl];
	SI.Temperature Ts[Nel*Npa_fl];
	SI.Temperature Ti[Nel*Npa_fl];
	SI.Stress sigma_eq[Nel*Npa_fl];
	SI.ThermalConductivity ktf[Nel*Npa_fl];

	String line;
	String filepath = "/home/arfontalvo/Documents/paper1/uniform.csv";
	String file_flux = Modelica.Utilities.Files.loadResource(filepath);

algorithm
	for i in 1:(Npa_fl*Nel) loop
		line := readLine(file_flux,i+N_start);
		Q_rcv[i] := scanReal(line)*1000000; //Converting to MW/m2 to W/m2
	end for;
equation	

	//Energy balance at ports
	h_in = inStream(fluid_a.h_outflow);
	fluid_b.h_outflow = hf[Nel*Npa_fl];
	fluid_a.h_outflow = 0;
	m_dot = fluid_a.m_flow;

	// Mass balance at ports
	fluid_a.m_flow + fluid_b.m_flow = 0;

	// Pressure at ports
	fluid_b.p = fluid_a.p;
	
	//First element
	h_int[1] = Nu[1]*lambda[1]/(2*a);
	rho[1] = Medium.rho_T(Tf[1]);
	lambda[1] = Medium.lamda_T(Tf[1]);
	muf[1] = Medium.eta_T(Tf[1]);
	vf[1] = m_dot/(N_tb_pa*rho[1]*pi*a^2);
	Cp[1] = Medium.cp_T(Tf[1]);
	Re[1] = max(1,vf[1] * rho[1] * 2*a / muf[1]);
	Pr[1] = max(0,muf[1] * Cp[1] / lambda[1]);
	Nu[1] = 0.023*Re[1]^(0.8)*Pr[1]^(0.4);
	alpha_ext[1] = h_ext + factor*Modelica.Constants.sigma*em*(Ts[1]^2+Tamb^2)*(Ts[1]+Tamb);
	ktf[1] = 0.0163914878*Ts[1] + 6.8703621459;
	Bi1[1] = h_int[1]*a/ktf[1];
	Bi2[1] = alpha_ext[1]*b/ktf[1];
	Ta[1] = (Tamb - Tf[1])*ktf[1]/(ab*Q_rcv[1]*b);
	Q_htf[1] = 2*ab*Q_rcv[1]*b*(1 + pi*Bi2[1]*Ta[1])*Bi1[1]*(H_rcv/Nel)/(Bi1[1] + Bi2[1]*(1 - Bi1[1]*log(a/b)))*N_tb_pa;
	m_dot*hf[1] = m_dot*h_in + Q_htf[1];
	Tf[1] = Medium.T_h(hf[1]);
	Ts[1] = Tsurface(Tf[1],Q_rcv[1],Bi1[1],Bi2[1],ab,a,b,ktf[1],Ta[1]);
	Ti[1] = Tinner(Tf[1],Q_rcv[1],Bi1[1],Bi2[1],ab,a,b,ktf[1],Ta[1]);
	sigma_eq[1] = Stress(Tf[1],Q_rcv[1],Bi1[1],Bi2[1],ab,a,b,ktf[1],lambdat,E,poisson,Q_htf[1]/N_tb_pa,H_rcv/Nel);
	
	f[1] = (-1.8*log10((e/(2*a)/3.7)^1.11 + 6.9/Re[1]))^(-2);
	dP_tube[1] = Npa_fl*0.5*f[1]*(H_rcv/Nel)/(2*a)*rho[1]*vf[1]^2; //+ 2/2*f[1]*L_e_45*rho[1]*vf[1]^2 + 4/2*f[1]*L_e_90*rho[1]*vf[1]^2;

	//Other elements
	for i in 2:(Nel*Npa_fl) loop
		h_int[i] = Nu[i]*lambda[i]/(2*a);
		rho[i] = Medium.rho_T(Tf[i]);
		lambda[i] = Medium.lamda_T(Tf[i]);
		muf[i] = Medium.eta_T(Tf[i]);
		vf[i] = m_dot/(N_tb_pa*rho[i]*pi*a^2);
		Cp[i] = Medium.cp_T(Tf[i]);
		Re[i] = max(1,vf[i] * rho[i] * 2*a / muf[i]);
		Pr[i] = max(0,muf[i] * Cp[i] / lambda[i]);
		Nu[i] = 0.023*Re[i]^(0.8)*Pr[i]^(0.4);
		alpha_ext[i] = h_ext + factor*Modelica.Constants.sigma*em*(Ts[i]^2+Tamb^2)*(Ts[i]+Tamb);
		ktf[i] = 0.0163914878*Ts[i] + 6.8703621459;
		Bi1[i] = h_int[i]*a/ktf[i];
		Bi2[i] = alpha_ext[i]*b/ktf[i];
		Ta[i] = (Tamb - Tf[i])*ktf[i]/(ab*Q_rcv[i]*b);
		Q_htf[i] = 2*ab*Q_rcv[i]*b*(1 + pi*Bi2[i]*Ta[i])*Bi1[i]*(H_rcv/Nel)/(Bi1[i] + Bi2[i]*(1 - Bi1[i]*log(a/b)))*N_tb_pa;
		m_dot*hf[i] = m_dot*hf[i-1] + Q_htf[i];
		Tf[i] = Medium.T_h(hf[i]);
		Ts[i] = Tsurface(Tf[i],Q_rcv[i],Bi1[i],Bi2[i],ab,a,b,ktf[i],Ta[i]);
		Ti[i] = Tinner(Tf[i],Q_rcv[i],Bi1[i],Bi2[i],ab,a,b,ktf[i],Ta[i]);
		sigma_eq[i] = Stress(Tf[i],Q_rcv[i],Bi1[i],Bi2[i],ab,a,b,ktf[i],lambdat,E,poisson,Q_htf[i]/N_tb_pa,H_rcv/Nel);
		f[i] = (-1.8*log10((e/(2*a)/3.7)^1.11 + 6.9/Re[i]))^(-2);
		dP_tube[i] = Npa_fl*0.5*f[i]*(H_rcv/Nel)/(2*a)*rho[i]*vf[i]^2;// + 2/2*f[i]*L_e_45*rho[i]*vf[i]^2 + 4/2*f[i]*L_e_90*rho[i]*vf[i]^2;
	end for;
	Q_loss[1:(Nel*Npa_fl)] = ab*Q_rcv[1:(Nel*Npa_fl)]*A_ele;
	dP_net = sum(dP_tube[:]);
annotation(
    Icon(graphics = {
    Rectangle(origin = {1, 42}, lineColor = {118, 118, 118}, fillColor = {216, 216, 216}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-75, 10}, {75, -10}}), 
    Rectangle(origin = {1, 20}, lineColor = {118, 118, 118}, fillColor = {216, 216, 216}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-75, 10}, {75, -10}}), 
    Rectangle(origin = {1, -24}, lineColor = {118, 118, 118}, fillColor = {216, 216, 216}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-75, 10}, {75, -10}}), 
    Rectangle(origin = {1, -2}, lineColor = {118, 118, 118}, fillColor = {216, 216, 216}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-75, 10}, {75, -10}}), 
    Rectangle(origin = {1, -46}, lineColor = {118, 118, 118}, fillColor = {216, 216, 216}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-75, 10}, {75, -10}})
    })
    );
end PanelSimple;
