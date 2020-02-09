within SolarTherm.Validation.Models.PCM;

function Mass //Generates the initial masses of each mesh element
  input Real M; //Total mass of PCM
  input Real dx[N]; //array of thicknesses
  input Integer N; //number of mesh elements
  output Real m[N]; //array of masses of each element
algorithm
  for i in 1:N loop
    m[i] := M*(dx[i]/sum(dx));
  end for;
end Mass;
