within SolarTherm.Models.CSP.CRS.Receivers.Panel;
model Panel
  //  import Modelica.Fluid.Types.Dynamics;
  import Modelica.SIunits.Conversions.*;
  parameter Integer nodes = 50 "Number of segments";
  parameter Integer n_start = 0 "Starting position for flux table reading";
  parameter Integer n_panels = 1 "Number of panels";
  parameter Modelica.SIunits.Temperature T_start = from_degC(500);
  parameter Modelica.SIunits.Pressure p_start = 1e5;
  parameter Modelica.SIunits.SpecificEnthalpy h_start = Medium.specificEnthalpy(Medium.setState_pTX(p_start,T_start));
  parameter Modelica.SIunits.MassFlowRate m_flow_start = 3;
  parameter Modelica.SIunits.Length H_rcv = 24 "Tube lenght within panel";
  parameter Modelica.SIunits.Thickness th_tb = 1.2e-3 "Tube thickness within the panel";
  parameter Modelica.SIunits.Diameter d_ext = 60.3e-3 "Tube outer diameter";
  parameter Modelica.SIunits.Diameter d_int = d_ext - 2 * th_tb "Tube inner diameter";
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT constrainedby Modelica.Media.Interfaces.PartialMedium;
  parameter Modelica.Fluid.Types.ModelStructure pipeModelStructure = Modelica.Fluid.Types.ModelStructure.av_vb;

  // Heat transfer
  replaceable model HeatTransfer_1 = Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.LocalPipeFlowHeatTransfer(alpha0 = 1000) 
    constrainedby Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.PartialFlowHeatTransfer 
    "Heat transfer model" annotation(
     choicesAllMatching,Dialog(tab = "General", group = "Fluid 1", enable = use_HeatTransfer));
  
  Modelica.Fluid.Pipes.DynamicPipe pipe1(
    redeclare package Medium = Medium, 
    redeclare model FlowModel = Modelica.Fluid.Pipes.BaseClasses.FlowModels.TurbulentPipeFlow, 
    redeclare final model HeatTransfer = HeatTransfer_1, 
    T_start = T_start, 
    diameter = d_int, 
    h_start = h_start, 
    length = n_panels*H_rcv, 
    m_flow_start = m_flow_start, 
    modelStructure = pipeModelStructure, 
    nNodes = n_panels*nodes, 
    p_a_start = p_start, 
    p_b_start = p_start,
    use_HeatTransfer = true, 
    use_T_start = true) "Receiver pipe model" annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-24, 24}, {24, -24}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.Panel.PipeWall heat1(
    dxs = pipe1.length / pipe1.nNodes, 
    n = pipe1.nNodes, 
    n_start = n_start) "Concentrated solar heat input" annotation(
    Placement(visible = true, transformation(origin = {0, -24}, extent = {{16, -24}, {-16, 24}}, rotation = -90)));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  heat1.alphas = pipe1.heatTransfer.alphas;
  heat1.Tf = pipe1.flowModel.states.T;
  connect(heat1.heatPorts, pipe1.heatPorts) annotation(
    Line(points = {{0, -19}, {0, -11}}, color = {127, 0, 0}, thickness = 0.5));
  connect(port_a, pipe1.port_a) annotation(
    Line(points = {{-80, 0}, {-24, 0}, {-24, 0}, {-24, 0}}, color = {127, 0, 0}, thickness = 0.5));
  connect(port_b, pipe1.port_b) annotation(
    Line(points = {{80, 0}, {24, 0}, {24, 0}, {24, 0}}, color = {127, 0, 0}, thickness = 0.5));
  annotation(
    Icon(
      graphics = {
        Rectangle(
          origin = {1, 44}, 
          lineColor = {118, 118, 118}, 
          fillColor = {216, 216, 216}, 
          fillPattern = FillPattern.HorizontalCylinder, 
          extent = {{-75, 10}, {75, -10}}), 
        Rectangle(
          origin = {1, 22}, 
          lineColor = {118, 118, 118}, 
          fillColor = {216, 216, 216}, 
          fillPattern = FillPattern.HorizontalCylinder, 
          extent = {{-75, 10}, {75, -10}}), 
        Rectangle(
          origin = {1, -22}, 
          lineColor = {118, 118, 118}, 
          fillColor = {216, 216, 216}, 
          fillPattern = FillPattern.HorizontalCylinder, 
          extent = {{-75, 10}, {75, -10}}), 
        Rectangle(
          origin = {1, 0}, 
          lineColor = {118, 118, 118}, 
          fillColor = {216, 216, 216}, 
          fillPattern = FillPattern.HorizontalCylinder, 
          extent = {{-75, 10}, {75, -10}}), 
        Rectangle(
          origin = {1, -44}, 
          lineColor = {118, 118, 118}, 
          fillColor = {216, 216, 216}, 
          fillPattern = FillPattern.HorizontalCylinder, 
          extent = {{-75, 10}, {75, -10}}), 
        Text(
          origin = {1, -86}, 
          lineColor = {0, 0, 255}, 
          extent = {{-75, 12}, {73, -10}}, 
          textString = "%name")}, 
        coordinateSystem(initialScale = 0.1)));
end Panel;
