within SolarTherm.Validation.Models.PCM;

function Location //Generates the initial location of each mesh element
  input Real dx[N]; //Array of thicknesses of PCM with length L
  input Real L; //Starting length of PCM
  input Integer N;
  output Real x[N]; //Array of element centroids
algorithm
  x[1] := 0.5*dx[1];
  for i in 2:N loop
    x[i] := sum(dx[1:i-1])+0.5*dx[i];
  end for;
end Location;