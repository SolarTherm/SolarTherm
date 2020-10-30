within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function TubeThickness
  input SI.Length d_o "Outer Tube Diameter";
  output SI.Length t_tube "Tube thickness";

algorithm
  //TEMA Standards average thickness
  //t_tube:=43.91*d_o^3 - 5.18*d_o^2 + 0.2235*d_o - 0.0007558;
  
  //TEMA Standard minimum thickness + NREL info maximum thickness 1.2mm
  if d_o<=7.9e-3 then 
    t_tube:=0.5e-3;
  elseif d_o>7.9e-3 and d_o<=11.1e-3 then
    t_tube:=0.6e-3;
  elseif d_o>11.1e-3 and d_o<=14.3e-3 then
    t_tube:=0.7e-3;
  elseif d_o>14.3e-3 and d_o<=34.9e-3 then
    t_tube:=0.9e-3;
  elseif d_o>34.9e-3 then
    t_tube:=1.2e-3;
  end if;

 //t_tube approximated with function
 //t_tube:= 5.1873151374*d_o^3 - 0.93792823782*d_o^2 + 0.055292752767*d_o + 0.00014137538821;
 
  //t_tube fixed
 //t_tube:=1.2e-3;
 
end TubeThickness;
