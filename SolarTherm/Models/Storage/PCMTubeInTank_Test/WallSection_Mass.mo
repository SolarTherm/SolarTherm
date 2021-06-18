within SolarTherm.Models.Storage.PCMTubeInTank_Test;

function WallSection_Mass
  import CN = Modelica.Constants;
  input SI.Length r_tube_out "Tube outer radius";
  input SI.Length r_tube_in "Tube inner radius";
  input SI.Length L "Length of PCM tank";
  input SI.Density Rho "Density of Wall";
  input Integer N_sec "Number of mesh elements";
  output SI.Mass M_Wall[N_sec] "Volume of wall node";
protected
  SI.Length dL "length step";
  SI.Area A_Wall "cross-section area of wall";
algorithm
  A_Wall := CN.pi * (r_tube_out ^ 2 - r_tube_in ^ 2);
  dL := L / N_sec;
  for i in 1:N_sec loop
    M_Wall[i] := Rho * A_Wall * dL;
  end for;
end WallSection_Mass;