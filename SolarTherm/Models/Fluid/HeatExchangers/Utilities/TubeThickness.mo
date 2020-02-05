within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function TubeThickness
  input SI.Length d_o "Outer Tube Diameter";
  output SI.Length t_tube "Tube thickness";

algorithm
  //t_tube:=43.91*d_o^3 - 5.18*d_o^2 + 0.2235*d_o - 0.0007558;
  
  
//  if d_o<=15.88e-3 then 
//    t_tube:=520.73594961*d_o^3 - 14.88002976*d_o^2 + 0.16797900262*d_o - 0.0001;
  
  if d_o<=7.9e-3 then 
    t_tube:=0.5e-3;
  elseif d_o>7.9e-3 and d_o<=11.1e-3 then
    t_tube:=0.65e-3;
  elseif d_o>11.1e-3 and d_o<=14.3e-3 then
    t_tube:=0.7e-3;
  elseif d_o>14.3e-3 and d_o<=34.9e-3 then
  
//  elseif d_o>15.88e-3 and d_o<=34.9e-3 then
    t_tube:=0.9e-3;
  elseif d_o>34.9e-3 then
    t_tube:=1.2e-3;
  end if;

end TubeThickness;
