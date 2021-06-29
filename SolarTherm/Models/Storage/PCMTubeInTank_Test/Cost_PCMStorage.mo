within SolarTherm.Models.Storage.PCMTubeInTank_Test;

model Cost_PCMStorage
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;
  
  replaceable package Fluid = SolarTherm.Media.Materials.Sodium "Fluid Package";
  replaceable package Storage = SolarTherm.Media.Materials.PCM710_UniSA "PCM Package";
  replaceable package Tank = SolarTherm.Media.Materials.SS316L "Tank package, steel tank";
  replaceable package Tube = SolarTherm.Media.Materials.SS316L "Tube package, steel tube";  

//Design parameter
  parameter SI.Length L = 210 "Length of Storage tank, m";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius, m";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius, m";
  parameter SI.Length r_shell = 0.03 "Shell radius, m";
  parameter Integer N_tube = 8040 "Number of tubes";

  parameter SI.Temperature T_min = CV.from_degC(540) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(750) "Design hot Temperature of everything in the tank (K)";

  //Property bounds
  //Fluid
  parameter SI.Density rho_f_min = Fluid.rho_Tf(T_min,0.0);
  parameter SI.Density rho_f_max = Fluid.rho_Tf(T_max,1.0);
  parameter SI.Density rho_f_avg = (rho_f_min + rho_f_max) / 2.0;
  //Tank
  parameter SI.Density rho_ta_min = Tank.rho_Tf(T_min,0.0);
  parameter SI.Density rho_ta_max = Tank.rho_Tf(T_max,0.0);
  parameter SI.Density rho_ta_avg = (rho_ta_min + rho_ta_max) / 2.0;
  //Tube
  parameter SI.Density rho_tu_min = Tube.rho_Tf(T_min,0.0);
  parameter SI.Density rho_tu_max = Tube.rho_Tf(T_max,0.0);
  parameter SI.Density rho_tu_avg = (rho_tu_min + rho_tu_max) / 2.0;
  //Storage material
  parameter SI.Density rho_p_min = Storage.rho_Tf(T_min,0.0);
  parameter SI.Density rho_p_max = Storage.rho_Tf(T_max,0.0);
  parameter SI.Density rho_p_avg = (rho_p_min + rho_p_max) / 2.0;
//Material cost
  parameter Real C_storage = Storage.cost "Cost of storage material, $/kg";
  parameter Real C_fluid = Fluid.cost "Cost of fluid material, $/kg";
  parameter Real C_tank = Tank.cost "Cost of tank material, $/kg";
  parameter Real C_tube = Tube.cost "Cost of tube material, $/kg";
  //parameter Real C_storage = 0.51 "Cost of storage material, $/kg";
  //parameter Real C_fluid = 2 "Cost of fluid material, $/kg";
  //parameter Real C_tank = 3.5 "Cost of tank material, $/kg";
  //parameter Real C_tube = 3.5 "Cost of tube material, $/kg";
  parameter Real C_insulation = 256 "Cost of external insulation material, $/m2";
  parameter Real C_foundation = 1320 "Cost of foundation and footing material, $/m2";
  //Storage vessel size estimation
  parameter Integer N_tank = integer (L/15.0) "Number of storage tanks";
  parameter SI.Length L_tank = L / N_tank "Length of one storage tank, m"; 
  parameter SI.Length S_tube = 2 * r_shell "Spacing between tubes, m"; 
  parameter Real pfactor = 0.9 "Packing factor of the tubes";
  parameter SI.Length R_tank = (N_tube * S_tube ^ 2) ^ 0.5 / 2 / pfactor "Radius of storage tank, m"; 
  parameter SI.Length H_header = R_tank / 3 "Height of tank header"; 
//Storage vessel material requirement
  parameter SI.Length W_tank = 0.012 "Thickness of tank wall, m"; 
  parameter SI.Length W_tubesheet = 0.012 "Thickness of tubesheet, m";
  parameter SI.Mass M_tank = CN.pi * L_tank * ((R_tank + W_tank)^2 - R_tank^2) * N_tank * rho_ta_avg "Mass of steel required for the shell of each storage tank, kg"; 
  parameter SI.Mass M_header = CN.pi * (4/3) * ((R_tank+W_tank)^2*(H_header+W_tank) -R_tank^2*H_header) * 1.05 * N_tank * rho_ta_avg "Mass of steel required for the header of the storage tank, assuming elliptical headers, kg"; 
  parameter SI.Mass M_tubesheet = CN.pi * (((R_tank + W_tank)^2 * W_tubesheet) - (r_tube_out^2 / 2 * W_tubesheet * N_tube)) * N_tank * rho_tu_avg "Mass of steel required for the tubesheet, kg";
  parameter SI.Mass M_tube = CN.pi * (r_tube_out^2 - r_tube_in^2 ) * N_tube * L_tank * N_tank * rho_tu_avg "Mass of steel required for tubes, kg";
  parameter SI.Mass M_fluid = (CN.pi * r_tube_in ^2 * L_tank * N_tube + CN.pi * (4/3) * R_tank^2*H_header) * N_tank * rho_f_avg "Mass of HTF in the header and tubes which is in addition to the HTF in the system, kg";
  parameter SI.Mass M_PCM = CN.pi * (R_tank^2 - N_tube * r_tube_out^2) * L_tank * N_tank * rho_p_avg "Mass of PCM, kg"; 
  parameter SI.Area A_found = (2 * R_tank + 2 * W_tank) * N_tank * L_tank "Foundation area. The foundation area of the storage vessels was assumed to be a rectangular block with the dimensions of the width of the vessel and length, m2"; 
  parameter SI.Area A_tank = (2 * CN.pi * (R_tank + W_tank) * (L_tank + R_tank + 2 * W_tank) + 2 * CN.pi * (R_tank + W_tank)^2) * N_tank "Surface area of storage tank, m2"; 

//Cost estimation 
//The purchased cost of each system was estimated as being the sum of the material requirements while the direct cost includes the cost of installation (30 % of purchased cost)

  parameter Real Cost_storage = M_PCM * C_storage / 1.0e6 "Total cost of PCM, $M";
  parameter Real Cost_fluid = M_fluid * C_fluid / 1.0e6 "Total cost of additional HTF in the header and tubes, $M";
  parameter Real Cost_vessel = (M_tank + M_header + M_tubesheet ) * C_tank / 1.0e6 "Total cost of steel for the tank vessel, $M";
  parameter Real Cost_tube = M_tube * C_tube / 1.0e6 "Total cost of steel for the tube. $M";
  parameter Real Cost_insulation = A_tank * C_insulation / 1.0e6 "Total cost of foundation, $M";
  parameter Real Cost_foundation = A_found * C_foundation / 1.0e6 "Total cost of foundation, $M";
  parameter Real TotalCost = 1.3 * (Cost_storage + Cost_fluid + Cost_vessel + Cost_tube + Cost_insulation + Cost_foundation) "Total cost of the storage system, including 30% of material cost as the installation cost, $M";
  annotation(
    Documentation(info = "<html><head></head><body><p> The cost of the storage system is determined by estimating the material requirements for
each design to meet the stated energy storage power and capacity. The details are explained in the publication (<a href=\"https://doi.org/10.1016/j.renene.2021.06.069\">https://doi.org/10.1016/j.renene.2021.06.069</a>). </p>

    <p>By Ming Liu on 25/06/2021</p>

  </body></html>"));   
  
end Cost_PCMStorage;
