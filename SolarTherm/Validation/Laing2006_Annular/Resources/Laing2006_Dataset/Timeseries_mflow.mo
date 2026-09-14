within SolarTherm.Validation.Laing2006_Annular.Resources.Laing2006_Dataset;

function Timeseries_mflow "Input time(s) output mass flow rate (kg/s)"
  input SI.Time t;
  output SI.MassFlowRate m_flow;
protected
  SI.Time t_data[25] = {0.00, 1265.11, 1794.69, 2177.16, 2618.48, 3618.80, 4854.48, 6031.33, 7237.59, 8473.28, 9620.70, 10856.39, 12062.66, 13268.92, 14475.19, 15652.03, 18005.72, 19241.41, 20403.54, 21536.25, 22830.78, 24007.63, 25243.31, 26420.16, 27626.42};
  SI.MassFlowRate mflow_data[25] = {0.0000, 0.0000, 0.3177, 0.5756, 0.8249, 1.1343, 1.1339, 1.1421, 1.1417, 1.1241, 1.1237, 1.1147, 1.1229, 1.1053, 1.1049, 1.0959, 1.0951, 1.0775, 1.0814, 0.7670, 0.0010, 0.0092, 0.0088, 0.0000, 0.0000};
algorithm
  m_flow := Modelica.Math.Vectors.interpolate(t_data, mflow_data, t);
end Timeseries_mflow;