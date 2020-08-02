within SolarTherm.Models.CSP.CRS.Receivers.Panel;
model PipeWall "Prescribed heat flow boundary condition"
  import Modelica.Utilities.Streams.*;
  import Modelica.Utilities.Strings.*;
  import Modelica.Constants.*;
  import SI = Modelica.SIunits;
  parameter SI.LinearExpansionCoefficient lambdat = 18.5e-6 "Coefficient of linear thermal expansion receiver tube material";
  parameter SI.Stress E = 165e9 "Young's Modulus receiver tube material";
  parameter SI.Efficiency poisson = 0.3 "Poisson ratio of receiver tube material";
  parameter SI.Temperature T_ref=293.15 "Reference temperature";
  parameter SI.LinearTemperatureCoefficient alpha=0 "Temperature coefficient of heat flow rate";
  parameter SI.HeatFlowRate Q_constant = 2000;
  parameter Integer n=1 "Number of heat transfer segments" annotation(Dialog(tab="Internal Interface",enable=false), Evaluate=true);
  parameter SI.Area dA = d_o*dxs "Fixed projected area of pipe segment";
  parameter SI.Length dxs = 1 "Fixed longitude of pipe segment";
  parameter Integer n_start = 0 "Starting position";
  parameter SI.ThermalConductivity kt = 20 "Tube metal thermal conductivity";
  parameter SI.Diameter d_i = 57.9e-3 "Inner tube diameter";
  parameter SI.Diameter d_o = 60.3e-3 "Inner tube diameter";
  parameter SI.Temperature Tamb = 298.15 "Ambient temperature";
  parameter SI.Efficiency ab=0.94 "Coating absortance";
  parameter SI.CoefficientOfHeatTransfer h_ext = 10 "Coefficient of external heat transfer due to external convection";
  
  // Heat ports
  Modelica.Fluid.Interfaces.HeatPorts_a[n] heatPorts "Heat port to component boundary" annotation (
    Placement(visible = true,transformation(origin = {20,0},extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {11, 0}, extent = {{-20, -5}, {20, 5}}, rotation = -90)));

  // Variables
  SI.CoefficientOfHeatTransfer alphas[n];
  SI.Temperature Tf[n];
  Real Ta[n];
  SI.Temperature Ts[n];
  SI.HeatFlowRate Q_rcv[n];
  Real Bi_i[n];
  Real Bi_o[n];
  SI.Stress sigma_eq[n];

  // String functions
  String line;
  String filepath = "/home/arfontalvo/Desktop/isp2/Table_1D_d1200/tables/Table_1D_d1200_ele6_azi22.csv";
  String file_flux = Modelica.Utilities.Files.loadResource(filepath);

algorithm
  for i in 1:n loop
    line := readLine(file_flux,i+n_start);
    Q_rcv[i] := 1*scanReal(line)*1000;//*dA;
  end for;
equation
  for i in 1:n loop
    Bi_i[i] = 0.5*alphas[i]*d_i/kt;
    Bi_o[i] = h_ext*0.5*d_o/kt;
	Ta[i] = (Tamb - Tf[i])*kt/(ab*Q_rcv[i]*0.5*d_o);
	heatPorts[i].Q_flow = -2*ab*Q_rcv[i]*0.5*d_o*(1 + pi*Bi_o[i]*Ta[i])*Bi_i[i]*dxs/(Bi_i[i] + Bi_o[i]*(1 - Bi_i[i]*log(d_i/d_o)));
	Ts[i] = Tsurface(Tf[i],Q_rcv[i],Bi_i[i],Bi_o[i],ab,0.5*d_i,0.5*d_o,kt,Ta[i]);
	sigma_eq[i] = Stress(Tf[i],Q_rcv[i],Bi_i[i],Bi_o[i],ab,0.5*d_i,0.5*d_o,kt,lambdat,E,poisson,heatPorts[i].Q_flow,dxs);
  end for

  annotation ();
annotation(
    Icon(
      coordinateSystem(extent = {{-40, -60}, {40, 60}}, initialScale = 0.1), 
        graphics = {
          Rectangle(
            fillColor = {175, 175, 175}, 
            fillPattern = FillPattern.Solid, 
            lineThickness = 0.5, extent = {{-12, 40}, {12, -40}})}),
    Diagram(
      coordinateSystem(extent = {{-40, -60}, {40, 60}})),
    version = "",
    uses);
end PipeWall;
