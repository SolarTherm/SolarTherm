model TestStorageENTU
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  extends Modelica.Icons.Example;
  // Input Parameters
  // *********************
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "Medium props for sodium";
  //replaceable package Medium = Media.MoltenSalt.MoltenSalt_ph "Medium props for molten salt";  
  //Start value of level in %
  Modelica.Fluid.Sources.Boundary_pT Recv(redeclare package Medium = Medium, T = 740 + 273.15, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-86, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink fluidSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {72, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pump_recv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_recv_var(y = m_recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-50, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real m_recv_signal "Signal value";
  parameter Real t_storage(unit = "h") = 8.0 "Hours of storage";
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
  parameter SI.Power P_gross_des = 100e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk_des = 0.51 "Power block efficiency at design point";
  SolarTherm.Models.Storage.eNTU eNTU(E_max = Q_flow_ref_blk * t_storage * 3600) annotation(
    Placement(visible = true, transformation(origin = {1, -13}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
initial equation

equation
  m_recv_signal = 200;
 // pump_recv.fluid_b.p = 101325;
//pump_recv.fluid_a.p = pump_recv.fluid_b.p;
//pump_PB.fluid_a.p = pump_PB.fluid_b.p;
//m_recv_signal = 10.0 * sin(time * 2.0 * CN.pi * (1.0 / (3600.0 * 24)));
  connect(Recv.ports[1], pump_recv.fluid_a) annotation(
    Line(points = {{-76, 8}, {-64, 8}, {-64, 0}, {-54, 0}}, color = {0, 127, 255}));
  connect(m_flow_recv_var.y, pump_recv.m_flow) annotation(
    Line(points = {{-39, 32}, {-44, 32}, {-44, 9}}, color = {0, 0, 127}));
  connect(pump_recv.fluid_b, eNTU.fluid_a) annotation(
    Line(points = {{-34, 0}, {1, 0}, {1, -5}}, color = {0, 127, 255}));
  connect(eNTU.fluid_b, fluidSink.port_a) annotation(
    Line(points = {{1, -20}, {31.5, -20}, {31.5, -22}, {62, -22}}, color = {0, 127, 255}));
  annotation(
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
end TestStorageENTU;