within SolarTherm.Utilities;

package Interpolation
  function Interpolate1D "Insert x_data[:], y_data[:],x, obtain a y value as an output based on linear interpolation or extrapolation at the end points"
    input Real x_data[:];
    input Real y_data[:];
    input Real x;
    output Real y;
  protected
    Integer N = size(x_data, 1);
    Integer i = 1;
  algorithm
    while i <= N loop
      if x < x_data[1] then
        y := y_data[1] + (x - x_data[1]) / (x_data[2] - x_data[1]) * (y_data[2] - y_data[1]);
        break;
      elseif x > x_data[N] then
        y := y_data[N - 1] + (x - x_data[N - 1]) / (x_data[N] - x_data[N - 1]) * (y_data[N] - y_data[N - 1]);
        break;
      elseif x >= x_data[i] and x <= x_data[i + 1] then
        y := y_data[i] + (x - x_data[i]) / (x_data[i + 1] - x_data[i]) * (y_data[i + 1] - y_data[i]);
        break;
      else
        i := i + 1;
      end if;
    end while;
//extrapolate
  end Interpolate1D;

  function OpticsTableNames "input the prefix to a optical lookup table, outputs an array of filenames for two optical tables"
    input String prefix;
    input Real f_recv;
    output String[2] file_optics_list;
protected
    Real pct;
    Integer count;
    Integer[13] List = {70,75,80,85,90,95,100,105,110,115,120,125,130};
    Boolean success;
    Real weight;
    String file_opticsA;
    String file_opticsB;
    
  algorithm
    success := false;
    count := 1;
    pct := 100.0 * f_receiver;
    if pct > 130.0 then
      file_opticsA := prefix + "_125%Arecv_optics.motab";
      file_opticsB := file_optics + "_130%Arecv_optics.motab";
      weight := (pct - 125) / (130 - 125);
    elseif pct < 70.0 then
      file_opticsA := file_optics + "_70%Arecv_optics.motab";
      file_opticsB := file_optics + "_75%Arecv_optics.motab";
      weight := (pct -70) / (80 - 70);
    else
      while count < 13 and success == false loop
        if pct >= List[count] and pct <= List[count + 1] then
          file_opticsA := file_optics + "_" + String(List[count]) + "%Arecv_optics.motab";
          file_opticsB := file_optics + "_" + String(List[count + 1]) + "%Arecv_optics.motab";
          weight := (pct - List[count]) / (List[count + 1] - List[count]);
          success := true;
        else
          count := count + 1;
        end if;
      end while;
    end if;
    file_optics_list := {file_opticsA, file_opticsB};
  end OpticsTableNames;
  
  function OpticsTableWeight "input the prefix to a optical lookup table, outputs an array of filenames for two optical tables"
    input String prefix;
    input Real f_recv;
    output Real weight;
  protected
    Real pct;
    Integer count;
    Integer[13] List = {70,75,80,85,90,95,100,105,110,115,120,125,130};
    Boolean success;
    String[2] file_optics_list;
    String file_opticsA;
    String file_opticsB;
    
  algorithm
    success := false;
    count := 1;
    pct := 100.0 * f_receiver;
    if pct > 130.0 then
      file_opticsA := prefix + "_125%Arecv_optics.motab";
      file_opticsB := file_optics + "_130%Arecv_optics.motab";
      weight := (pct - 125) / (130 - 125);
    elseif pct < 70.0 then
      file_opticsA := file_optics + "_70%Arecv_optics.motab";
      file_opticsB := file_optics + "_75%Arecv_optics.motab";
      weight := (pct -70) / (80 - 70);
    else
      while count < 13 and success == false loop
        if pct >= List[count] and pct <= List[count + 1] then
          file_opticsA := file_optics + "_" + String(List[count]) + "%Arecv_optics.motab";
          file_opticsB := file_optics + "_" + String(List[count + 1]) + "%Arecv_optics.motab";
          weight := (pct - List[count]) / (List[count + 1] - List[count]);
          success := true;
        else
          count := count + 1;
        end if;
      end while;
    end if;
    file_optics_list := {file_opticsA, file_opticsB};
  end OpticsTableWeight;
end Interpolation;