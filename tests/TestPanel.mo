model TestPanel
  extends Modelica.Icons.Example;
  import Modelica.Fluid.Types.Dynamics;
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT constrainedby Modelica.Media.Interfaces.PartialMedium;
  
  parameter Integer nodes = 50 "Number of segments";
  parameter Integer n_panels = 2 "Number of panels per flow path";
  parameter Integer n_flow_paths = 8 "Number of parallel flow paths";
  
  parameter Modelica.SIunits.Temperature T_inlet = from_degC(520) "Receiver inlet temperature";
  parameter Modelica.SIunits.Temperature T_outlet = from_degC(740) "Receiver inlet temperature";
  
  parameter Modelica.SIunits.Pressure p_inlet = 1e5 "Receiver inlet pressure";
  parameter Modelica.SIunits.Pressure p_outlet = p_inlet - p_drop "Receiver oulet pressure";
  parameter Modelica.SIunits.PressureDifference p_drop = 0.4e5 "Receiver pressure drop";

  parameter Modelica.Fluid.Types.ModelStructure pipeModelStructure = Modelica.Fluid.Types.ModelStructure.av_vb;
  parameter Dynamics systemMassDynamics = if Medium.singleState then Dynamics.SteadyState else Dynamics.SteadyStateInitial;

  Modelica.Fluid.Sources.Boundary_pT source(
    redeclare package Medium = Medium,
    T = T_inlet,
    nPorts = n_flow_paths,
    p = p_inlet) "Pressure and temperature inlet" annotation (
      Placement(visible = true, transformation(extent = {{-32, -6}, {-20, 6}}, rotation = 0)));

  Modelica.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Medium, 
    T = T_outlet, 
    nPorts = 1, 
    p = p_outlet) "Pressure and temperature outlet" annotation(
    Placement(visible = true, transformation(extent = {{32, -6}, {20, 6}}, rotation = 0)));
  
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel1(n_start = 0, nodes = nodes, n_panels = n_panels)  annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel2( n_panels = panel1.n_panels,n_start = 100, nodes = panel1.nodes) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel3( n_panels = panel1.n_panels,n_start = 200, nodes = panel1.nodes) annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel4( n_panels = panel1.n_panels,n_start = 300, nodes = panel1.nodes) annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel5( n_panels = panel1.n_panels,n_start = 400, nodes = panel1.nodes) annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel6( n_panels = panel1.n_panels,n_start = 500, nodes = panel1.nodes) annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel7( n_panels = panel1.n_panels,n_start = 600, nodes = panel1.nodes) annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.Panel panel8( n_panels = panel1.n_panels,n_start = 700, nodes = panel1.nodes) annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  inner Modelica.Fluid.System system(
    massDynamics=systemMassDynamics, 
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_eps_Re=true) annotation (
      Placement(transformation(extent={{90,-92},{110,-72}})));

equation
  connect(panel1.port_a, source.ports[1]);
  connect(panel2.port_a, source.ports[2]);
  connect(panel3.port_a, source.ports[3]);
  connect(panel4.port_a, source.ports[4]);
  connect(panel5.port_a, source.ports[5]);
  connect(panel6.port_a, source.ports[6]);
  connect(panel7.port_a, source.ports[7]);
  connect(panel8.port_a, source.ports[8]);
  connect(panel1.port_b, sink.ports[1]);
  connect(panel1.port_b, panel2.port_b);
  connect(panel1.port_b, panel3.port_b);
  connect(panel1.port_b, panel4.port_b);
  connect(panel1.port_b, panel5.port_b);
  connect(panel1.port_b, panel6.port_b);
  connect(panel1.port_b, panel7.port_b);
  connect(panel1.port_b, panel8.port_b);
  annotation (
    Documentation(info="<html><p>This example demonstrates two aspects: the treatment of multi-way connections and the usage of an incompressible medium model.</p></html>"),
    experiment(StopTime=200),
    __Dymola_Commands(file="modelica://Modelica/Resources/Scripts/Dymola/Fluid/IncompressibleFluidNetwork/plotResults.mos""plotResults"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,100}})));
end TestPanel;
