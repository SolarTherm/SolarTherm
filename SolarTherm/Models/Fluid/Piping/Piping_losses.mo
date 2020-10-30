within SolarTherm.Models.Fluid.Piping;
model Piping_losses
  extends SolarTherm.Interfaces.Models.Pipe;
  parameter SI.Length H_tower=10 "Tower height"
                                               annotation(Dialog(group="Technical data"));
  parameter SI.Length L_const=0 "Piping length constant" annotation(Dialog(group="Piping"));
  parameter Real F_mult=1 "Piping length multiplier "
                                                     annotation(Dialog(group="Piping"));
  parameter Real C_pip(unit="W/m")=1000 "Piping loss coeficient" annotation(Dialog(group="Piping"));
  parameter SI.Length L_tot=H_tower*F_mult+L_const "Total piping length";

  SI.HeatFlowRate Q_pip;
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
equation
  fluid_a.m_flow+fluid_b.m_flow=0;
  fluid_a.h_outflow=h_out;
  fluid_b.h_outflow=h_out;
  fluid_a.Xi_outflow=fluid_b.Xi_outflow;
  fluid_b.Xi_outflow=inStream(fluid_a.Xi_outflow);
  fluid_a.p=fluid_b.p;

  h_in=inStream(fluid_a.h_outflow);
  Q_pip=-L_tot*C_pip;
  0=Q_pip+fluid_a.m_flow*(h_in-h_out);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Piping_losses;
