within SolarTherm.Models.Storage.PCMTubeInTank_Test;

function HTFSection_Mass
  import CN = Modelica.Constants;
  input SI.Length r_tube_in "Tube inner radius";
  input SI.Length L "Length of PCM tank";
  input SI.Density Rho "Density of HTF";
  input Integer N_sec "Number of mesh elements";
  output SI.Mass M_HTF[N_sec] "Volume of HTF node";
protected
  SI.Length dL "length step";
  SI.Area A_HTF "cross-section area of wall";
algorithm
  A_HTF := CN.pi * r_tube_in ^ 2;
  dL := L / N_sec;
  for i in 1:N_sec loop
    M_HTF[i] := Rho * A_HTF * dL;
  end for;
end HTFSection_Mass;