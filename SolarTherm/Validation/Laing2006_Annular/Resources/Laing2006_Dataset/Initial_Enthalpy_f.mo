within SolarTherm.Validation.Laing2006_Annular.Resources.Laing2006_Dataset;

function Initial_Enthalpy_f "Input height array, output enthalpy array based on constant SolarSalt properties"
  input SI.Length[:] z_f;
  output SI.SpecificEnthalpy[size(z_f, 1)] h_f;
protected
  Integer N_f = size(z_f, 1);
  Integer j;
  SI.Temperature[N_f] T_f;
  SI.Length z_data[4] = {0.0, 0.0435, 0.9565, 1.0};
  SI.Temperature T_data[4] = {398.74, 399.15, 407.75, 408.1595};
algorithm
  for i in 1:N_f loop
    T_f[i] := Modelica.Math.Vectors.interpolate(z_data, T_data, z_f[i]);
    h_f[i] := Fluid.h_Tf(T_f[i]);
  end for;
end Initial_Enthalpy_f;