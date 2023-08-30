within SolarTherm.Validation.Datasets.AlonsoFig8_DataSet;

function Initial_Temperature_f "Input a height array, obtain a Temperature array"
  input SI.Length[:] z_f;
  output SI.Temperature[size(z_f,1)] T_f;
protected
  Integer N_f = size(z_f,1);
  Integer j;
  SI.Length[6] z_data = {0.0299,0.1291,0.2293,0.3294,0.43,0.480};

  SI.Temperature[6] T_data = {307.15,319.15,387.15,547.15,874.15,954.15};
algorithm
  for i in 1:N_f loop
      T_f[i] := SolarTherm.Utilities.Interpolation.Interpolate1D(z_data,T_data,z_f[i]);
  end for;
end Initial_Temperature_f;