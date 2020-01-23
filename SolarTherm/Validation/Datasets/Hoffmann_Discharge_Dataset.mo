within SolarTherm.Validation.Datasets;

package Hoffmann_Discharge_Dataset "Provides the initial temerature and enthalpy distributions of the validation case used by Hoffmann (2016) based on Pacheco (2002) experimental data"
  package Fluid = SolarTherm.Media.Materials.SolarSalt;
  package Filler = SolarTherm.Media.Materials.Quartzite;

  function Initial_Temperature_f "Input a height array, obtain a Temperature array"
    input SI.Length[:] z_f;
    output SI.Temperature[size(z_f,1)] T_f;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          T_f[i] := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          T_f[i] := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
          break;
        elseif z_f[i] > z_data[29] then
          T_f[i] := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Temperature_f;
  
  function Initial_Enthalpy_f "Input height array, output enthalpy array based on constant SolarSalt properties"
    input SI.Length[:] z_f;
    output SI.SpecificEnthalpy[size(z_f,1)] h_f;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Temperature[N_f] T_f;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          T_f[i] := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
          h_f[i] := Fluid.h_Tf(T_f[i]);
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          T_f[i] := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
          h_f[i] := Fluid.h_Tf(T_f[i]);
          break;
        elseif z_f[i] > z_data[30] then
          T_f[i] := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
          h_f[i] := Fluid.h_Tf(T_f[i]);
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Enthalpy_f;
  
  function Initial_Temperature_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
    input SI.Length[:] z_f;
    input Integer N_p;
    output SI.Temperature[size(z_f,1),N_p] T_p;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          for k in 1:N_p loop
            T_p[i,k] := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
          end for;
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          for k in 1:N_p loop
            T_p[i,k] := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
          end for;
          break;
        elseif z_f[i] > z_data[30] then
          for k in 1:N_p loop
            T_p[i,k] := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
          end for;
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Temperature_p;
  
  function Initial_Enthalpy_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
    input SI.Length[:] z_f;
    input Integer N_p;
    output SI.SpecificEnthalpy[size(z_f,1),N_p] h_p;
  protected
    Integer N_f = size(z_f,1);
    Real T;
    Integer j;
    SI.Length[30] z_data = {0.1891408355,0.3175156023,0.523611571,0.6784883493,0.9214895894,0.9944855653,1.1308184228,1.2796377505,1.3741831352,1.4781547515,1.6146354925,1.6704761219,1.8875742635,2.0238327876,2.1600214162,2.2961867952,2.4323436086,2.5684492729,2.7045649712,2.8406870326,2.9767858445,3.1128942008,3.2489864049,3.3850771406,3.5212200042,3.6573467155,3.7934473628,3.9295553521,4.337853256,4.473956473};

    SI.Temperature[30] T_data = {599.3728452046,602.0314729755,606.6689806469,610.5690012467,616.9876757959,619.3934758518,623.5635292821,629.767285693,633.4072611776,639.6695587232,646.4827844816,649.4058315496,659.7033119162,662.5447804914,664.1369827102,665.3136376467,666.3371962159,666.4465507639,666.7352467706,667.1376715073,667.1245489615,667.2820195106,667.150794053,666.9933235039,667.7675537037,668.2530878968,668.2727717155,668.4236809917,668.4105584459,668.4761711747};
  algorithm
    for i in 1:N_f loop
      j := 0;
      while j <= 30 loop
        if z_f[i] < z_data[1] then
          for k in 1:N_p loop
            T := T_data[1]+((z_f[i]-z_data[1])/(z_data[2]-z_data[1]))*(T_data[2]-T_data[1]);
            h_p[i,k] := Filler.h_Tf(T,0);
            
          end for;
          break;
        elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j+1] then
          for k in 1:N_p loop
            T := T_data[j] + (T_data[j+1]-T_data[j])*(z_f[i]-z_data[j])/(z_data[j+1]-z_data[j]);
            h_p[i,k] := Filler.h_Tf(T,0);
          end for;
          break;
        elseif z_f[i] > z_data[30] then
          for k in 1:N_p loop
            T := T_data[29]+((z_f[i]-z_data[29])/(z_data[30]-z_data[29]))*(T_data[30]-T_data[29]);
            h_p[i,k] := Filler.h_Tf(T,0);
          end for;
          break;
        else
          j := j + 1;
        end if;
      end while;
    end for;
  end Initial_Enthalpy_p;
end Hoffmann_Discharge_Dataset;