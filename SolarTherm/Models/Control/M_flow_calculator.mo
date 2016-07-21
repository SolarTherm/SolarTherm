within SolarTherm.Models.Control;
block M_flow_calculator

  Modelica.Blocks.Interfaces.RealInput Q_solar annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-120,-20},{-80,20}})));
  parameter SI.HeatFlowRate Q_max;
  parameter SI.HeatFlowRate Q_min;
  parameter SI.MassFlowRate m_flow_max;
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));

   parameter SI.MassFlowRate m_flow_min=Q_min*m_flow_max/Q_max;
equation


  m_flow=min(max(Q_solar*m_flow_max/Q_max,m_flow_min),m_flow_max);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end M_flow_calculator;
