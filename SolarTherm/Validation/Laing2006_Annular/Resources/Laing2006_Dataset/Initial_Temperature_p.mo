within SolarTherm.Validation.Laing2006_Annular.Resources.Laing2006_Dataset;

function Initial_Temperature_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
  input SI.Length[:] z_f;
  input Integer N_p;
  output SI.Temperature[size(z_f, 1), N_p] T_p;
protected
  Integer N_f = size(z_f, 1);
  Integer j;
  SI.Length z_data[4] = {0.0, 0.0435, 0.9565, 1.0};
  SI.Temperature T_data[4] = {398.74, 399.15, 407.75, 408.1595};
algorithm
  for i in 1:N_f loop
    for k in 1:N_p loop
      T_p[i, k] := Modelica.Math.Vectors.interpolate(z_data, T_data, z_f[i]);
    end for;
  end for;
end Initial_Temperature_p;