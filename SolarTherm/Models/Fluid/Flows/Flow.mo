within SolarTherm.Models.Fluid.Flows;
partial model Flow "A flow model representing the mass flow rate, density and pressure change within a control volume"
 import SI = Modelica.SIunits;
 SI.MassFlowRate m_flow;
 SI.Density d_avg "Average density";
 SI.Pressure dp "Pressure change";
end Flow;
