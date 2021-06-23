within SolarTherm.Utilities.Thermocline;

function Degradation_Width_2 //Requires a T_min and T_max input
  input Real z_data[:];
  input Real T_data[:];
  input Real f_low = 0.05;
  input Real f_high = 0.95;
  input Real T_min;
  input Real T_max;
  output Real L_degrade;
protected
  Integer N = size(z_data, 1);
  //Real T_max = T_data[N];
  //Real T_min = T_data[1];
  Real T_low = T_min + f_low*(T_max - T_min);
  Real T_high = T_min + f_high*(T_max - T_min);
  Real z_low;
  Real z_high;
  Integer i;
algorithm
  if (T_data[N] - T_data[1]) < 1.0 then
    L_degrade := 0.0; //Just assume to be zero because thermocline is invalid
  else
    //Set the worst case scenario first
    z_low := z_data[1];
    z_high := z_data[N];
    //Lower triangle
    if T_data[1] > T_low then //z_low is the first element
      z_low := z_data[1];
    else
      i := 2; //start from element 2
      while i < N-1 loop
        if T_data[i] > T_low then //we know the z_low is between i and i-1
          z_low := z_data[i-1] + (T_low-T_data[i-1])*(z_data[i]-z_data[i-1])/(T_data[i]-T_data[i-1]);
        break;
        else
          i := i + 1;
        end if;
      end while; 
    end if;
    //Upper triangle
    if T_data[N] < T_high then //z_high is the last element
      z_high := z_data[N];
    else
      i := N - 1; //Start from element -2
      while i > 2 loop
        if T_data[i] < T_high then //we know the z_low is between i and i-1
          z_high := z_data[i] + (T_high-T_data[i])*(z_data[i+1]-z_data[i])/(T_data[i+1]-T_data[i]);
          break;
        else
          i := i - 1;
        end if;
      end while;
    end if;
  end if;
  L_degrade := z_high - z_low;
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Degradation_Width_2;