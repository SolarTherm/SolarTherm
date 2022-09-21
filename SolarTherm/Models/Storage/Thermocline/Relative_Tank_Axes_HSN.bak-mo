within SolarTherm.Models.Storage.Thermocline;

function Relative_Tank_Axes_HSN "Input tank height, and number of fluid CVs, output array of non-dimensional z_positions"
  input SI.Length H_tank;
  input Integer N_f;
  output SI.Length ZdH[N_f];
  protected
  SI.Length dz "Height step";
algorithm
  dz := H_tank / (N_f - 1);
  for i in 1:N_f loop
    ZdH[i] := ((i-1) * dz) / H_tank;
  end for;
end Relative_Tank_Axes_HSN;