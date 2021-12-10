within SolarTherm.Utilities;

function InterpolateYield
  input Real array[5];
  input Real flux_multiple_off;
  output Real yield;

algorithm
  /*                      Interpolate -- Linear 
               y(X0)    +          dy/dX          *       (X-X0) 
  */
  if flux_multiple_off>=0.7 and flux_multiple_off < 0.8 then
      yield := array[1] + (array[2]-array[1])/0.1 * (flux_multiple_off-0.7);
      
  elseif flux_multiple_off>=0.8 and flux_multiple_off < 0.9 then
      yield := array[2] + (array[3]-array[2])/0.1 * (flux_multiple_off-0.8);
      
  elseif flux_multiple_off>=0.9 and flux_multiple_off < 1.0 then
      yield := array[3] + (array[4]-array[3])/0.1 * (flux_multiple_off-0.9);
      
  elseif flux_multiple_off>=1.0 and flux_multiple_off < 1.1 then
      yield := array[4] + (array[5]-array[4])/0.1 * (flux_multiple_off-1.0);
      
  //elseif flux_multiple_off >= 1.1 then /*Extrapolation*/
  //    yield := (array[5]-array[4])/(0.1) * (flux_multiple_off - 1.0) + array[4];
  //              //dy/dx * X + C
  else
      yield:=0;
  end if;
  

end InterpolateYield;