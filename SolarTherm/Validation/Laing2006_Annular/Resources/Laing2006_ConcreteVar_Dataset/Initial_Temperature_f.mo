within SolarTherm.Validation.Laing2006_Annular.Resources.Laing2006_ConcreteVar_Dataset;

function Initial_Temperature_f "Input a height array, obtain a Temperature array"
  input SI.Length[:] z_f;
  output SI.Temperature[size(z_f,1)] T_f;
protected
  Integer N_f = size(z_f,1);
  Integer j;
  SI.Length z_data[2] = {0.0043,0.957};
  SI.Temperature T_data[2] = {399.57,404.73};
algorithm
  for i in 1:N_f loop
      T_f[i] := Modelica.Math.Vectors.interpolate(z_data,T_data,z_f[i]);
  end for;
end Initial_Temperature_f;