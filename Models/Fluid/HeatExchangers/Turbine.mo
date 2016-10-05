within SolarTherm.Models.Fluid.HeatExchangers;
model Turbine
  extends SolarTherm.Interfaces.Models.Turbine;

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
  //escribe apartir de aqui
  0=h_in-h_out;
  W_el=fluid_a.m_flow*(h_in-h_out);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Turbine;
