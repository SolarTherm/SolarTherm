within SolarTherm.Models.Storage;

package Thermocline

import SI = Modelica.SIunits;
import CN = Modelica.Constants;
import CV = Modelica.SIunits.Conversions;
import Tables = Modelica.Blocks.Tables;

function Particle_Masses "Input outer diameter, number of filler CVs, density, outputs array of particle CV masses"
  input SI.Length d_p "Outer diameter";
  input Integer N_p "Number of mesh elements";
  input SI.Density rho "Density";
  output SI.Mass m[N_p];
protected
  SI.Length dr "Radius step";
  SI.Length r[N_p] "Midpoint radii";
algorithm
  dr := d_p / (2.0 * N_p);
  for i in 1:N_p loop
    r[i] := (i - 0.5) * dr;
    m[i] := rho * 4.0 * CN.pi * (r[i] ^ 2 * dr + dr ^ 3 / 12.0);
  end for;
end Particle_Masses;

function Relative_Tank_Axes "Input tank height, and number of fluid CVs, output array of non-dimensional z_positions"
  input SI.Length H_tank;
  input Integer N_f;
  output SI.Length ZdH[N_f];
protected
  SI.Length dz "Height step";
algorithm
  dz := H_tank / N_f;
  for i in 1:N_f loop
    ZdH[i] := (i - 0.5) * dz / H_tank;
  end for;
end Relative_Tank_Axes;

function Z_position "Input Tank height and number of fluid CVs, outputs array of z positions"
  input SI.Length H_tank;
  input Integer N_f;
  output SI.Length z_f[N_f];
protected
  SI.Length dz "Height step";
algorithm
  dz := H_tank / N_f;
  for i in 1:N_f loop
    z_f[i] := (i - 0.5) * dz;
  end for;
end Z_position;

function Particle_Radii "Input outer filler particle diameter and number of filler CVs, output array of midpoint radii"
  input SI.Length d_p "Outer diameter";
  input Integer N_p "Number of mesh elements";
  output SI.Length r[N_p] "Midpoint radii";
protected
  SI.Mass m[N_p];
  SI.Length dr "Radius step";
algorithm
  dr := d_p / (2.0 * N_p);
  for i in 1:N_p loop
    r[i] := (i - 0.5) * dr;
  end for;
end Particle_Radii;

end Thermocline;