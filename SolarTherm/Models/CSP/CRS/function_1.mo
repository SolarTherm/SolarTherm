within SolarTherm.Models.CSP.CRS;

function function_1 "function used in curtain property calculation"
  //input Real eps_s "emissivity of the particle";
  input Real eCta "product eps_s*C[i]*th_c[i]*a";
  output Real result;
algorithm
  result := 1 - 1/(eCta)^2 + (1+eCta)/(eCta)^2 * exp(-eCta);

end function_1;