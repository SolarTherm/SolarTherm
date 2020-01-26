within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function TubeThickness
  input SI.Length d_o "Outer Tube Diameter";
  output SI.Length t_tube "Tube thickness";
algorithm
  t_tube:=43.91*d_o^3 - 5.18*d_o^2 + 0.2235*d_o - 0.0007558;

end TubeThickness;
