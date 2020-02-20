within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function ShellThickness
  input SI.Length D_s "Shell Diameter";
  output SI.Length t_shell "Shell thickness";
  
algorithm

//TEMA Standards - Minimum Shell Thickness
  if noEvent(D_s<=0.15) then 
    t_shell:=3.2e-3;
  elseif noEvent(D_s>0.15 and D_s<=0.3) then
    t_shell:=3.2e-3;
  elseif noEvent(D_s>0.3 and D_s<=0.58) then
    t_shell:=3.2e-3;
  elseif noEvent(D_s>0.58 and D_s<=0.74) then
    t_shell:=4.8e-3;
  elseif noEvent(D_s>0.74 and D_s<=0.99) then
    t_shell:=6.4e-3;
  elseif noEvent(D_s>0.99 and D_s<=1.52) then
    t_shell:=6.4e-3;
  elseif noEvent(D_s>1.52 and D_s<=2.03) then
    t_shell:=7.9e-3;
  elseif noEvent(D_s>2.03) then
    t_shell:=9.5e-3;
  end if;

//TEMA Standards - Minimum Shell Thickness - Approximated Function
//  if D_s<=0.15 then 
//    t_shell:=3.2e-3;
//  elseif D_s>0.15 and D_s<=2.03 then
//    t_shell:=0.006560749*D_s^0.3821246;
//  else
//    t_shell:=9.5e-3;
//  end if;

end ShellThickness;