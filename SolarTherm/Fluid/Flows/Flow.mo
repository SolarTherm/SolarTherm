within SolarTherm.Fluid.Flows;
partial model Flow
 import SI = Modelica.SIunits;
 SI.MassFlowRate m_flow;
 SI.Density d_avg "Average density";
 SI.Pressure dp "Pressure change";
end Flow;
