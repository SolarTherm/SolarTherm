within SolarTherm.Validation.Models.PCM;

function Thickness "Generates the initial thicknesses up uneven mesh elements to determine starting mass of each element"
  input Real r; //common ratio, growth parameter of the uneven mesh
  input Real L;
  input Integer N;
  output Real dx[N];
algorithm
  for i in 1:N loop 
    dx[i] := (L*(1.0-r)*(r^(i-1)))/(1.0-r^N);
  end for;
end Thickness; 