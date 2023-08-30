within SolarTherm.Validation.Datasets.AlonsoFig8_DataSet;

function Initial_Temperature_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
  input SI.Length[:] z_f;
  input Integer N_p;
  output SI.Temperature[size(z_f,1),N_p] T_p;
protected
  Integer N_f = size(z_f,1);
  Integer j;
  SI.Length[6] z_data = {0.0299,0.1291,0.2293,0.3294,0.43,0.480};

  SI.Temperature[6] T_data = {307.15,319.15,387.15,547.15,874.15,954.15};
algorithm
  for i in 1:N_f loop
    for k in 1:N_p loop
        T_p[i,k] := SolarTherm.Utilities.Interpolation.Interpolate1D(z_data,T_data,z_f[i]);
    end for;
  end for;
end Initial_Temperature_p;