within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function BaffleThickness
  input SI.Length D_s "Shell Diameter";
  input SI.Length l_b "Baffle Spacing";
  output SI.Length t_baffle "Baffle thickness";
  
algorithm
//TEMA Standards - Minimum Baffle Thickness
if noEvent(l_b<=0.61) then
  if noEvent(D_s<=0.356) then 
    t_baffle:=3.2e-3;
  elseif noEvent(D_s>0.356 and D_s<=0.711) then
    t_baffle:=4.8e-3;
  elseif noEvent(D_s>0.711 and D_s<=0.965) then
    t_baffle:=6.4e-3;
  elseif noEvent(D_s>0.965 and D_s<=1.524) then
    t_baffle:=6.4e-3;
  elseif noEvent(D_s>1.524) then
    t_baffle:=9.5e-3;
  end if;
elseif noEvent(l_b>0.61 and l_b<=0.914) then
  if noEvent(D_s<=0.356) then 
    t_baffle:=4.8e-3;
  elseif noEvent(D_s>0.356 and D_s<=0.711) then
    t_baffle:=6.4e-3;
  elseif noEvent(D_s>0.711 and D_s<=0.965) then
    t_baffle:=7.5e-3;
  elseif noEvent(D_s>0.965 and D_s<=1.524) then
    t_baffle:=9.5e-3;
  elseif noEvent(D_s>1.524) then
    t_baffle:=12.7e-3;
  end if;
elseif noEvent(l_b>0.914 and l_b<=1.219) then
  if noEvent(D_s<=0.356) then 
    t_baffle:=6.4e-3;
  elseif noEvent(D_s>0.356 and D_s<=0.711) then
    t_baffle:=9.5e-3;
  elseif noEvent(D_s>0.711 and D_s<=0.965) then
    t_baffle:=9.5e-3;
  elseif noEvent(D_s>0.965 and D_s<=1.524) then
    t_baffle:=12.7e-3;
  elseif noEvent(D_s>1.524) then
    t_baffle:=15.9e-3;
  end if;
elseif noEvent(l_b>1.219 and l_b<=1.524) then
  if noEvent(D_s<=0.356) then 
    t_baffle:=9.5e-3;
  elseif noEvent(D_s>0.356 and D_s<=0.711) then
    t_baffle:=9.5e-3;
  elseif noEvent(D_s>0.711 and D_s<=0.965) then
    t_baffle:=12.7e-3;
  elseif noEvent(D_s>0.965 and D_s<=1.524) then
    t_baffle:=15.9e-3;
  elseif noEvent(D_s>1.524) then
    t_baffle:=19.1e-3;
  end if;
elseif noEvent(l_b>1.524) then
  if noEvent(D_s<=0.356) then 
    t_baffle:=9.5e-3;
  elseif noEvent(D_s>0.356 and D_s<=0.711) then
    t_baffle:=12.7e-3;
  elseif noEvent(D_s>0.711 and D_s<=0.965) then
    t_baffle:=15.9e-3;
  elseif noEvent(D_s>0.965 and D_s<=1.524) then
    t_baffle:=15.9e-3;
  elseif noEvent(D_s>1.524) then
    t_baffle:=19.1e-3;
  end if;
end if;

//Fixed Baffle Thickness
//t_baffle:=19.1e-3;

//TEMA Standards - Minimum Baffle Thickness - Approximated Function
//if l_b<=0.61 then
//  if D_s<=0.356 then 
//    t_baffle:=3.2e-3;
//  elseif D_s>0.356 and D_s<=1.254 then
//    t_baffle:=0.004332389*log(D_s) + 0.007674598;
//  else
//    t_baffle:=9.5e-3;
//  end if;
//elseif l_b>0.61 and l_b<=0.914 then
//  if D_s<=0.356 then 
//    t_baffle:=0.0048;
//  elseif D_s>0.356 and D_s<=1.254 then
//    t_baffle:=0.005432678*log(D_s) + 0.010411;
//  else
//    t_baffle:=0.0127;
//  end if;
//elseif l_b>0.914 and l_b<=1.219 then
//  if D_s<=0.356 then 
//    t_baffle:=0.0066;
//  elseif D_s>0.356 and D_s<=1.254 then
//    t_baffle:=0.0064457*log(D_s) + 0.01326375;
//  else
//    t_baffle:=0.0160;
//  end if;
//elseif l_b>1.219 and l_b<=1.524 then
//  if D_s<=0.356 then 
//    t_baffle:=0.0095;
//  elseif D_s>0.356 and D_s<=1.254 then
//    t_baffle:=0.006601736*log(D_s) + 0.01631843;
//  else
//    t_baffle:=0.0191;
//  end if;
//elseif l_b>1.524 then
//  if D_s<=0.356 then 
//    t_baffle:=0.0098;
//  elseif D_s>0.356 and D_s<=1.254 then
//    t_baffle:=0.006591127*log(D_s) + 0.01663412;
//  else
//    t_baffle:=0.0194;
//  end if;
//end if;		


end BaffleThickness;