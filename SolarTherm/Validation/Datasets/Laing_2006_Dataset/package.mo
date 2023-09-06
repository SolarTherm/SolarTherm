within SolarTherm.Validation.Datasets;

package Laing_2006_Dataset "Provides the initial temerature and enthalpy distributions of the validation case used by Niedermeier (2018) based on Pacheco (2002) experimental data"
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  package Fluid = SolarTherm.Materials.Dowtherm_Table;
  package Filler = SolarTherm.Materials.Concrete_Laing_2006_Variation;
  //Niedermeier's Simulation Output
  constant SI.Length zdL_sim_0h[4] = {0.0,0.0435,0.9565,1.0};
  constant SI.Temperature T_K_0h[4] = {398.74,399.15,407.75,408.1595};
  constant SI.Time T_inlet_times[74] = {0.0, 1080.0, 2442.0, 2559.6, 2647.9, 2736.2, 2824.4, 2883.3, 2942.1, 3001.0, 3059.8, 3089.2, 3206.9, 3236.3, 3324.6, 3427.6, 3471.7, 3530.5, 3589.4, 3707.1, 3942.4, 4236.6, 4619.1, 4913.3, 5325.2, 5766.5, 6090.2, 6678.6, 7090.5, 7443.5, 7884.9, 8326.2, 8708.6, 9150.0, 9620.7, 10297.4, 10738.7, 11533.1, 12033.2, 12415.7, 12827.6, 13357.2, 14004.4, 14681.1, 15210.7, 15799.1, 16387.6, 16858.3, 17623.2, 18152.8, 18770.7, 19241.4, 19976.9, 20359.4, 21109.6, 21565.7, 21742.2, 22007.0, 22095.3, 22212.9, 22389.5, 22507.2, 22654.3, 22830.8, 23125.0, 23389.8, 23831.1, 24243.0, 24684.3, 25125.6, 25772.9, 26302.5, 27038.0, 27626.4};
  constant SI.Temperature T_inlet_TK[74] = {298.15, 298.15, 374.85, 379.58, 383.45, 387.97, 392.27, 396.14, 399.36, 402.16, 406.46, 409.68, 415.49, 420.43, 423.88, 429.25, 431.62, 435.49, 438.07, 441.08, 444.52, 446.88, 448.92, 450.74, 453.11, 455.47, 457.19, 459.98, 461.91, 463.84, 465.77, 467.49, 469.21, 470.71, 472.43, 474.57, 476.29, 479.18, 480.79, 482.08, 482.51, 483.58, 484.22, 484.64, 484.74, 484.63, 484.73, 484.84, 484.62, 484.40, 484.18, 483.53, 482.66, 482.01, 479.43, 476.41, 471.46, 461.78, 456.62, 450.39, 443.07, 437.26, 431.89, 425.43, 418.98, 415.32, 411.02, 408.43, 408.64, 409.29, 409.50, 409.71, 410.13, 410.34};
  constant SI.Time T_outlet_times[48] = {2530.2, 2647.9, 2765.6, 2868.6, 2971.5, 3118.6, 3383.4, 3648.2, 4001.3, 4472.0, 5295.8, 5854.8, 6384.4, 7061.1, 7826.0, 8443.9, 9208.8, 10032.6, 10709.3, 11386.0, 11974.4, 12592.2, 13092.4, 13827.9, 14504.6, 15563.8, 16299.3, 17064.2, 18035.1, 18653.0, 19506.2, 20388.8, 21036.1, 21624.5, 21771.6, 21859.9, 22007.0, 22154.1, 22271.8, 22389.5, 22536.6, 22595.4, 22683.7, 22860.2, 23007.3, 23228.0, 23389.8, 23566.3};
  constant SI.Temperature T_outlet_TK[48] = {373.34, 378.07, 384.09, 389.90, 394.85, 400.22, 405.60, 413.33, 417.20, 419.78, 423.43, 426.22, 428.90, 432.02, 435.24, 438.24, 442.32, 445.11, 447.68, 450.69, 453.27, 455.41, 457.13, 459.70, 461.85, 464.42, 465.92, 467.42, 469.34, 470.20, 471.27, 471.91, 470.82, 466.09, 461.57, 456.41, 449.10, 441.78, 434.26, 425.87, 418.55, 414.04, 409.74, 401.56, 394.03, 386.29, 378.33, 373.17};
  constant SI.Time T_Pos1_times[23] = {58.84, 1265.11, 2441.95, 3618.80, 4825.06, 6031.33, 7237.59, 8414.44, 9591.28, 10856.39, 12062.66, 13239.50, 14475.19, 15681.45, 18005.72, 19241.41, 20418.25, 21609.81, 22830.78, 24007.63, 25243.31, 26420.16, 27626.42};
  constant SI.Temperature T_Pos1_TK[23] = {407.77, 407.98, 405.17, 404.09, 415.48, 426.00, 434.81, 442.76, 449.84, 456.29, 461.76, 467.02, 471.09, 474.10, 477.95, 479.01, 479.65, 479.31, 478.55, 478.76, 478.53, 478.31, 477.54};
  constant SI.Time T_Pos4_times[23] = {58.84, 1235.69, 2441.95, 3618.80, 4883.90, 6060.75, 7267.01, 8443.86, 9650.12, 10856.39, 12033.23, 13268.92, 14445.77, 15652.03, 18035.14, 19211.99, 20418.25, 21624.52, 22801.36, 24037.05, 25243.31, 26420.16, 27626.42};
  constant SI.Temperature T_Pos4_TK[23] = {399.17, 398.95, 399.80, 403.23, 408.59, 413.96, 419.33, 424.69, 430.27, 435.43, 440.79, 445.51, 450.45, 454.74, 462.03, 465.03, 467.17, 469.31, 469.74, 469.94, 469.93, 469.27, 469.05};
  constant SI.Time Massflow_times[25] = {0.00, 1265.11, 1794.69, 2177.16, 2618.48, 3618.80, 4854.48, 6031.33, 7237.59, 8473.28, 9620.70, 10856.39, 12062.66, 13268.92, 14475.19, 15652.03, 18005.72, 19241.41, 20403.54, 21536.25, 22830.78, 24007.63, 25243.31, 26420.16, 27626.42};
  
  constant SI.MassFlowRate Massflow_mflow[25] = {0.0000, 0.0000, 0.3177, 0.5756, 0.8249, 1.1343, 1.1339, 1.1421, 1.1417, 1.1241, 1.1237, 1.1147, 1.1229, 1.1053, 1.1049, 1.0959, 1.0951, 1.0775, 1.0814, 0.7670, 0.0010, 0.0092, 0.0088, 0.0000, 0.0000};
  
  function Initial_Temperature_f "Input a height array, obtain a Temperature array"
    input SI.Length[:] z_f;
    output SI.Temperature[size(z_f,1)] T_f;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Length z_data[4] = {0.0,0.0435,0.9565,1.0};
    SI.Temperature T_data[4] = {398.74,399.15,407.75,408.1595};
  algorithm
    for i in 1:N_f loop
        T_f[i] := SolarTherm.Utilities.Interpolation.Interpolate1D(z_data,T_data,z_f[i]);
    end for;
  end Initial_Temperature_f;
  
  function Initial_Enthalpy_f "Input height array, output enthalpy array based on constant SolarSalt properties"
    input SI.Length[:] z_f;
    output SI.SpecificEnthalpy[size(z_f,1)] h_f;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Temperature[N_f] T_f;
    SI.Length z_data[4] = {0.0,0.0435,0.9565,1.0};
    SI.Temperature T_data[4] = {398.74,399.15,407.75,408.1595};
  algorithm
    for i in 1:N_f loop
       T_f[i] := SolarTherm.Utilities.Interpolation.Interpolate1D(z_data,T_data,z_f[i]);
       h_f[i] := Fluid.h_Tf(T_f[i]);
    end for;
  end Initial_Enthalpy_f;
  
  function Initial_Temperature_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
    input SI.Length[:] z_f;
    input Integer N_p;
    output SI.Temperature[size(z_f,1),N_p] T_p;
  protected
    Integer N_f = size(z_f,1);
    Integer j;
    SI.Length z_data[4] = {0.0,0.0435,0.9565,1.0};
    SI.Temperature T_data[4] = {398.74,399.15,407.75,408.1595};
  algorithm
    for i in 1:N_f loop
      for k in 1:N_p loop
          T_p[i,k] := SolarTherm.Utilities.Interpolation.Interpolate1D(z_data,T_data,z_f[i]);
      end for;
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
    SI.Length z_data[4] = {0.0,0.0435,0.9565,1.0};
    SI.Temperature T_data[4] = {398.74,399.15,407.75,408.1595};   
  algorithm
    for i in 1:N_f loop
      for k in 1:N_p loop
        T := SolarTherm.Utilities.Interpolation.Interpolate1D(z_data,T_data,z_f[i]);
        h_p[i,k] := Filler.h_Tf(T,0);
      end for;
    end for;
  end Initial_Enthalpy_p;
  
  function Timeseries_mflow "Input time(s) output mass flow rate (kg/s)"
    input SI.Time t;
    output SI.MassFlowRate m_flow;
  protected
    SI.Time t_data[25] = {0.00, 1265.11, 1794.69, 2177.16, 2618.48, 3618.80, 4854.48, 6031.33, 7237.59, 8473.28, 9620.70, 10856.39, 12062.66, 13268.92, 14475.19, 15652.03, 18005.72, 19241.41, 20403.54, 21536.25, 22830.78, 24007.63, 25243.31, 26420.16, 27626.42};
    SI.MassFlowRate mflow_data[25] = {0.0000, 0.0000, 0.3177, 0.5756, 0.8249, 1.1343, 1.1339, 1.1421, 1.1417, 1.1241, 1.1237, 1.1147, 1.1229, 1.1053, 1.1049, 1.0959, 1.0951, 1.0775, 1.0814, 0.7670, 0.0010, 0.0092, 0.0088, 0.0000, 0.0000};
  algorithm
    m_flow := SolarTherm.Utilities.Interpolation.Interpolate1D(t_data,mflow_data,t);
  end Timeseries_mflow;
  
  function Timeseries_TinletK "Input time(s) output inlet fluid temperature (K)"
    input SI.Time t;
    output SI.MassFlowRate T_inlet;
  protected
    SI.Time t_data[74] = {0.0, 1080.0, 2442.0, 2559.6, 2647.9, 2736.2, 2824.4, 2883.3, 2942.1, 3001.0, 3059.8, 3089.2, 3206.9, 3236.3, 3324.6, 3427.6, 3471.7, 3530.5, 3589.4, 3707.1, 3942.4, 4236.6, 4619.1, 4913.3, 5325.2, 5766.5, 6090.2, 6678.6, 7090.5, 7443.5, 7884.9, 8326.2, 8708.6, 9150.0, 9620.7, 10297.4, 10738.7, 11533.1, 12033.2, 12415.7, 12827.6, 13357.2, 14004.4, 14681.1, 15210.7, 15799.1, 16387.6, 16858.3, 17623.2, 18152.8, 18770.7, 19241.4, 19976.9, 20359.4, 21109.6, 21565.7, 21742.2, 22007.0, 22095.3, 22212.9, 22389.5, 22507.2, 22654.3, 22830.8, 23125.0, 23389.8, 23831.1, 24243.0, 24684.3, 25125.6, 25772.9, 26302.5, 27038.0, 27626.4};
    SI.Temperature T_data[74] = {298.15, 298.15, 374.85, 379.58, 383.45, 387.97, 392.27, 396.14, 399.36, 402.16, 406.46, 409.68, 415.49, 420.43, 423.88, 429.25, 431.62, 435.49, 438.07, 441.08, 444.52, 446.88, 448.92, 450.74, 453.11, 455.47, 457.19, 459.98, 461.91, 463.84, 465.77, 467.49, 469.21, 470.71, 472.43, 474.57, 476.29, 479.18, 480.79, 482.08, 482.51, 483.58, 484.22, 484.64, 484.74, 484.63, 484.73, 484.84, 484.62, 484.40, 484.18, 483.53, 482.66, 482.01, 479.43, 476.41, 471.46, 461.78, 456.62, 450.39, 443.07, 437.26, 431.89, 425.43, 418.98, 415.32, 411.02, 408.43, 408.64, 409.29, 409.50, 409.71, 410.13, 410.34};
  algorithm
    T_inlet := SolarTherm.Utilities.Interpolation.Interpolate1D(t_data,T_data,t);
  end Timeseries_TinletK;
    
end Laing_2006_Dataset;