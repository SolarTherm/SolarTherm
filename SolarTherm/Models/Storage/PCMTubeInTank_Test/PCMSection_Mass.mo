within SolarTherm.Models.Storage.PCMTubeInTank_Test;

function PCMSection_Mass
  import CN = Modelica.Constants;
  input SI.Length r_tube_out "Tube outer radius";
  input SI.Length r_shell "Shell radius";
  input SI.Length L "Length of PCM tank";
  input SI.Density Rho "Density of PCM";
  input Integer N_sec "Number of mesh elements";
  output SI.Mass M_PCM[N_sec] "Volume of PCM node";
protected
  SI.Length dL "length step";
  SI.Area A_PCM "cross-section area of PCM";
algorithm
  A_PCM := CN.pi * (r_shell ^ 2 - r_tube_out ^ 2);
  dL := L / N_sec;
  for i in 1:N_sec loop
    M_PCM[i] := Rho * A_PCM * dL;
  end for;
end PCMSection_Mass;