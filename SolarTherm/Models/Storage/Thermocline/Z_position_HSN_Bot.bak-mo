within SolarTherm.Models.Storage.Thermocline;

function Z_position_HSN_Bot "Input Tank height and number of fluid CVs, outputs array of z positions"
  input SI.Length H_tank;
  input Integer N_f;
  output SI.Length z_f[N_f];
protected
  SI.Length dz "Height step";
algorithm
  dz := H_tank / (N_f - 1);
  for i in 1:N_f loop
    z_f[i] := (i-1) * dz;
  end for;
end Z_position_HSN_Bot;