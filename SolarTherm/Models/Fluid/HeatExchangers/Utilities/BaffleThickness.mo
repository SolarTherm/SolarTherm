within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function BaffleThickness
  input SI.Length D_s "Shell Diameter";
  input SI.Length l_b "Baffle Spacing";
  output SI.Length t_baffle "Baffle thickness";
  
algorithm
if l_b<=0.61 then
  if D_s<=0.356 then 
    t_baffle:=3.2e-3;
  elseif D_s>0.356 and D_s<=0.711 then
    t_baffle:=4.8e-3;
  elseif D_s>0.711 and D_s<=0.965 then
    t_baffle:=6.4e-3;
  elseif D_s>0.965 and D_s<=1.524 then
    t_baffle:=6.4e-3;
  elseif D_s>1.524 then
    t_baffle:=9.5e-3;
  end if;
elseif l_b>0.61 and l_b<=0.914 then
  if D_s<=0.356 then 
    t_baffle:=4.8e-3;
  elseif D_s>0.356 and D_s<=0.711 then
    t_baffle:=6.4e-3;
  elseif D_s>0.711 and D_s<=0.965 then
    t_baffle:=7.5e-3;
  elseif D_s>0.965 and D_s<=1.524 then
    t_baffle:=9.5e-3;
  elseif D_s>1.524 then
    t_baffle:=12.7e-3;
  end if;
elseif l_b>0.914 and l_b<=1.219 then
  if D_s<=0.356 then 
    t_baffle:=6.4e-3;
  elseif D_s>0.356 and D_s<=0.711 then
    t_baffle:=9.5e-3;
  elseif D_s>0.711 and D_s<=0.965 then
    t_baffle:=9.5e-3;
  elseif D_s>0.965 and D_s<=1.524 then
    t_baffle:=12.7e-3;
  elseif D_s>1.524 then
    t_baffle:=15.9e-3;
  end if;
elseif l_b>1.219 and l_b<=1.524 then
  if D_s<=0.356 then 
    t_baffle:=9.5e-3;
  elseif D_s>0.356 and D_s<=0.711 then
    t_baffle:=9.5e-3;
  elseif D_s>0.711 and D_s<=0.965 then
    t_baffle:=12.7e-3;
  elseif D_s>0.965 and D_s<=1.524 then
    t_baffle:=15.9e-3;
  elseif D_s>1.524 then
    t_baffle:=19.1e-3;
  end if;
elseif l_b>1.524 then
  if D_s<=0.356 then 
    t_baffle:=9.5e-3;
  elseif D_s>0.356 and D_s<=0.711 then
    t_baffle:=12.7e-3;
  elseif D_s>0.711 and D_s<=0.965 then
    t_baffle:=15.9e-3;
  elseif D_s>0.965 and D_s<=1.524 then
    t_baffle:=15.9e-3;
  elseif D_s>1.524 then
    t_baffle:=19.1e-3;
  end if;
end if;

end BaffleThickness;