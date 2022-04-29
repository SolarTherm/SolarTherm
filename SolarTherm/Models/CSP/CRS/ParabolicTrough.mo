within SolarTherm.Models.CSP.CRS;
model ParabolicTrough
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;
	
	parameter Real lat = 1 "Latitude (+ve North)";

	/*****************General Geometries**************************/
	constant Real pi = Modelica.Constants.pi;
	parameter Integer n_col = 1 "Number of collectors";
	parameter Modelica.SIunits.Length L = 4.06 "length of tubes";
	parameter Modelica.SIunits.Length L_col = 100 "length of the collector";
	parameter Modelica.SIunits.Length A_col = 470.3 "Area of collector";
	parameter Modelica.SIunits.Length A_P =5 "Aperture of the parabola";
	
	/******************** Geometries&Properties of the tube  *******************************/
	parameter Modelica.SIunits.Length Dext_t = 0.07 "External diameter tube" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
	parameter Modelica.SIunits.Length th_t = 0.004 "tube thickness" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
	
	parameter Modelica.SIunits.Area  A_reflector = L*A_P
		"Total areo of the reflector";
	parameter Modelica.SIunits.Length rext_t = Dext_t/2
		" External Radius Glass" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
	parameter Modelica.SIunits.Length rint_t= rext_t-th_t
		"Internal Radius Glass" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
	parameter Modelica.SIunits.Area Am_t = (rext_t^2 - rint_t^2)*pi
		"Area of the metal cross section";
	parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
		"internal diameter of the metal tube";
	parameter Modelica.SIunits.Area A_int_t= L*D_int_t*pi
		"Lateral internal surface of the metal tube";
	parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L
		"Internal volume of the metal tube";
	
	/***************** Optical parameters *****************/
	parameter Real rho_cl = 0.89 "Mirror reflectivity";
	parameter Real Alpha_t=0.97 "Tube Absorptivity";
	parameter Real tau_g=0.91 "Glass transmissivity: from Soponova data sheet";
	
	/******************** Parameters for longitudinal incidence angle modifier  *******************************/
	parameter Real A0 = 4.05;
	parameter Real A1 = 0.247;
	parameter Real A2 = -0.00146;
	parameter Real A3 = 5.65E-6;
	parameter Real A4 = 7.62E-8;
	parameter Real A5 = -1.7;
	parameter Real A6 = 0.0125;
	/******************** HTF parameters ********************/
	parameter Modelica.SIunits.Temperature T_fluid = Modelica.SIunits.Conversions.from_degC(345);

	/******************** Design parameters *************/
	parameter SI.Irradiance dni_des = 950 "DNI at design";
	parameter SI.Velocity Wspd_des = 3 "Wind speed at design";
	parameter SI.Angle dec_des = 0 "Solar declination at design";
	parameter SI.Angle hra_des = 0 "Hour angle at design";
	parameter SI.Angle zen_des = SolarTherm.Models.Sources.SolarFunctions.solarZenith(dec_des,hra_des,lat) "Solar zenith at design";
	parameter SI.Angle inc_des = Modelica.Math.acos(((cos(zen_des))^2 + (cos(dec_des))^2*(sin(hra_des))^2)^0.5);
	parameter Real IAM_des = cos(inc_des);
	parameter Real eta_opt_des = rho_cl*Alpha_t*tau_g*IAM_des;
	parameter SI.Temperature Tamb_des = Modelica.SIunits.Conversions.from_degC(25);
	parameter Real HL_des(final unit="W/m") = A0 + A1*(T_fluid - Tamb_des) + A2*(to_degC(T_fluid))^2 + A3*(to_degC(T_fluid))^3 + A4*dni_des*IAM_des*(to_degC(T_fluid))^2 + Wspd_des^(1/2)*(A5 + A6*(T_fluid - Tamb_des));
	/******************** Variables ********************/
	Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(transformation(origin = {-100,75}, extent={{-10,-10},{10,10}})));
	Modelica.Blocks.Interfaces.RealInput Wspd annotation (Placement(transformation(origin = {-100,-75}, extent={{-10,-10},{10,10}})));

	SolarTherm.Interfaces.Connectors.SolarPort_a solar annotation (Placement(transformation(origin = {0,100}, extent={{-10,-10},{10,10}})));

	SI.Angle dec = solar.dec "Solar declination angle";
	SI.Angle hra = solar.hra "Solar hour angle";
	SI.HeatFlux dni = solar.dni "Direct normal irradiance";
	SI.Angle zen "Solar zenith angle";
	SI.Angle inc "Solar incidence angle";
	Real IAM "Incidence angle modifier";
	Real cosinc = cos(inc) "Cosine of incidence angle";

	SI.HeatFlowRate Qabs;
	SI.HeatFlowRate Qf;
	SI.HeatFlowRate Ql;

	Real HL(unit="W/m", displayUnit="kW/m");
	Real eta_opt;

equation

	zen = SolarTherm.Models.Sources.SolarFunctions.solarZenith(dec,hra,lat);

	inc = Modelica.Math.acos(((cos(zen))^2 + (cos(dec))^2*(sin(hra))^2)^0.5);

	IAM = min(1,(cos(inc) + 0.000884*to_deg(inc) - 0.0000537*(to_deg(inc))^2)/cos(inc))*cos(inc);

	eta_opt = rho_cl*Alpha_t*tau_g*IAM;

	Qabs = dni*n_col*A_col*rho_cl*Alpha_t*tau_g*IAM;

	HL = A0 + A1*(T_fluid - Tamb) + A2*(to_degC(T_fluid))^2 + A3*(to_degC(T_fluid))^3 + A4*dni*IAM*(to_degC(T_fluid))^2 + (max(0,Wspd))^(1/2)*(A5 + A6*(T_fluid - Tamb));
	
	Ql = HL*n_col*L_col;

	Qf = max(0, Qabs - Ql);

//	heat.Q_flow = -Qf;
//	heat.T = T_fluid;

annotation(
    Icon(graphics = {
    Rectangle(origin = {-42, 5}, lineColor = {110, 110, 110}, fillColor = {255, 255, 255}, fillPattern = FillPattern.VerticalCylinder, extent = {{-28, 80}, {28, -80}}), 
    Ellipse(origin = {-42, 89}, rotation = 180, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-28, 16}, {28, -10}}, endAngle = 180), 
    Ellipse(origin = {-42, -75}, lineColor = {110, 110, 110}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-28, 16}, {28, -10}}, endAngle = 360), 
    Rectangle(origin = {-42, 5}, lineColor = {102, 51, 0}, fillColor = {255, 178, 102}, fillPattern = FillPattern.VerticalCylinder, extent = {{-2, 80}, {2, -90}}), 

    Rectangle(origin = {42, 5}, lineColor = {110, 110, 110}, fillColor = {255, 255, 255}, fillPattern = FillPattern.VerticalCylinder, extent = {{-28, 80}, {28, -80}}), 
    Ellipse(origin = {42, 89}, rotation = 180, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-28, 16}, {28, -10}}, endAngle = 180), 
    Ellipse(origin = {42, -75}, lineColor = {110, 110, 110}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-28, 16}, {28, -10}}, endAngle = 360),
    Rectangle(origin = {42, 5}, lineColor = {102, 51, 0}, fillColor = {255, 178, 102}, fillPattern = FillPattern.VerticalCylinder, extent = {{-2, 80}, {2, -90}}), 
    
    Text(origin = {4, -128}, lineColor = {0, 0, 255}, extent = {{-72, 22}, {72, -22}}, textString = "%name")
    }, 
    coordinateSystem(initialScale = 0.1)));
end ParabolicTrough;
