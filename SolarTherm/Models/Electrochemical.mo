within SolarTherm.Models;

package Electrochemical
  extends Modelica.Icons.Package;

  model SPE_Electrolyser
    /*The electrolyser model is based on: https://doi.org/10.1016/j.ssi.2004.01.076*/
    import Cons = Modelica.Constants;
    import SI = Modelica.SIunits;
    import Math = Modelica.Math;
    parameter SI.Power P_in = 10 "Input power to the electrolyser [W]";
    parameter Real i_a0_Pt = 1e-12 "Anode exchange current density";
    parameter Real i_c0 = 1e-3 "Cathode exchange current density";
    parameter SI.FaradayConstant F = Cons.F "Faraday constant";
    parameter Real R = Cons.R "Molar gas constant (J/[mol.K])";
    parameter Real alpha_a = 0.5 "Transfer coefficient";
    parameter Real mu_e = 0.5 "Stoichiometric coefficient of electrons in the anode";
    parameter SI.Temperature T = 80 + 273.15 "Electrolyser working temperature in K";
    parameter Real A_electrode = 10 "cm2 from https://doi.org/10.1016/S0378-7753(02)00466-4";
    /*
          SI.Current I "Current that flows through the electrolyser";
          */
    //Voltage calculation
    parameter SI.Current I = 1 "Current flows in electrolyser";
    parameter SI.Length Lb = 178e-6 "Membrane length";
    parameter Real delta_b = 0.14 "Conductivity of membrange [S/m]";
    //Equilibrium voltage
    SI.Voltage V_0 "Nernst potential";
    SI.Pressure p_H2 "Partial pressure of H2";
    SI.Pressure p_O2 "Partial pressure of O2";
    //Production rate
    Real ndot_water "Water needed given current [mol/s]";
    Real ndot_H2 "H2 produced given current [mol/s]";
    Real ndot_O2 "O2 Produced given current [mol/s]";
    //Membrane voltage
    SI.Voltage V_mem "Membrane potential";
    //Interfacial voltage
    SI.Voltage V_int;
    //Anode and cathode voltage
    SI.Voltage eta_anode "Anode potential";
    SI.Voltage eta_cathode "Cathode potential";
  equation
/*
  I = i_a0_Pt * (
    Math.exp((alpha_a * mu_e - F * eta_anode)/ (R*T)) - Math.exp(-((1 - alpha_a)*mu_e - F * eta_anode)/(R*T))
  );
  */
    ndot_water = I * A_electrode / (2 * F);
    ndot_H2 = I * A_electrode / (2 * F);
    ndot_O2 = I * A_electrode / (4 * F);
    p_H2 = ndot_H2 / (ndot_H2 + ndot_O2 + ndot_water) * 1;
    p_O2 = ndot_O2 / (ndot_H2 + ndot_O2 + ndot_water) * 1;
    V_0 = 1.23 - 0.9e-3 * (T - 298) + 2.3 * (0.082057366080960 * T / (4 * F)) * Modelica.Math.log(p_H2 ^ 2 * p_O2) "atm";
    eta_anode = R * T / F * Math.asinh(I / i_a0_Pt * 0.5);
    eta_cathode = R * T / F * Math.asinh(I / i_c0 * 0.5);
    V_mem = Lb / delta_b * I;
    V_int = 1;
  end SPE_Electrolyser;

  model AEL_Electrolyser
  /*
    The electrolyser model is based on: http://dx.doi.org/10.1016/j.energy.2017.07.053 . Polarisation curve is extracted, fitted as CombiTable2D where the inputs are: delivered power to the
    electrolyser (W) and working temperature of the electrolyser (K). Model limitation:
    
    1. The polarisation curve is based on curve-fit experimental data of 15kW AEL electrolyser testbed unit 
    2. Model is only valid for working pressure 7bar with temperature between 323.15 - 353.15 K
    
    If the requested size of the AEL unit is > 15kW, then multiplier M has to be added:
        M = int(W_elec_requested / 15kWe)
        
     and the output then is multiplied by M
    
  */
    import SI = Modelica.SIunits;
    import nSI = Modelica.Units.NonSI;
    import CN = Modelica.Constants;
    import CONV = Modelica.SIunits.Conversions;
    import MATH = Modelica.Math;
    
    
    //Some constants
    parameter SI.FaradayConstant F = CN.F "Faraday constant";
    parameter Real R = CN.R "Molar gas constant (J/[mol.K])";
    parameter String fn_curve = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/ElectrolyserCurve/AEL_Polarisation_Curve.motab");
    
    
    //Electrolyser configuration parameters
    parameter Integer N_cells = 12 "Number of cells of the electrolyser";
    parameter Real A_electrolyser = 1000 "Total electrode area in cm^2";
    parameter SI.Voltage V_0 = 1.229 "Standard voltage of the redox cycle";
    
    
    //Working condition of the electrolyser
    parameter SI.Pressure p_electrolyser = 7e5 "Operating pressure of AEL in Pa";
    parameter SI.Temperature T_electrolyser = 80 + 273.15 "Operating temperature of AEL in K";
    
    
    //Intermediate parameter
    parameter Real p_AEL = CONV.to_bar(p_electrolyser);
    parameter Real T_AEL = CONV.to_degC(T_electrolyser);
    
    
    //Coefficients of the electrolyser
    /*Polarisation curve*/
    parameter Real r1 = 4.45153e-5 "ohm.m^2";
    parameter Real r2 = 6.88874e-9 "ohm.m^2/C";
    parameter Real d1 = -3.12996e-6 "ohm.m^2";
    parameter Real d2 = 4.47137e-7 "ohm.m^2/bar";
    parameter SI.Voltage s = 0.33824 "V";
    parameter Real t1 = -0.01539 "m^2/A";
    parameter Real t2 = 2.00181 "m^2.C/A";
    parameter Real t3 = 15.24178 "m^2.C^2/A";
    
    
    /*Faraday efficiency*/
    parameter Real f11 = 478645.74 "A^2/m^4";
    parameter Real f12 = -2953.15 "A^2/(m^4.C)";
    parameter Real f21 = 1.03960;
    parameter Real f22 = -0.00104 "C^-1";
    
    
    /*Gas purity (hydrogen in oxygen)*/
    parameter Real C1 = 0.09901;
    parameter Real C2 = -0.00207 "C^-1";
    parameter Real C3 = 1.31064e-5 "C^-2";
    parameter Real C4 = -0.08483;
    parameter Real C5 = 0.00179 "C^-1";
    parameter Real C6 = -1.13390e-5 "C^-2";
    parameter Real C7 = 1481.45 "A/m^2";
    parameter Real C8 = -23.60345 "A/(m^2.C)";
    parameter Real C9 = -0.25774 "A/(m^2.C^2)";
    parameter Real E1 = 3.71417;
    parameter Real E2 = -0.93063 "bar^-1";
    parameter Real E3 = 0.05817 "bar^-2";
    parameter Real E4 = -3.72068;
    parameter Real E5 = 0.93219 "bar^-1";
    parameter Real E6 = -0.05826 "bar^-2";
    parameter Real E7 = -18.38215 "A/m^2";
    parameter Real E8 = 5.87316 "A/(m^2.bar)";
    parameter Real E9 = -0.46425 "A/(m^2.bar^2)";
    
    
    //CombiTable2D instantiation for reading Polarisation Curve
    Modelica.Blocks.Tables.CombiTable2D p_curve(
        tableOnFile = true, 
        tableName = "polarisation_curve", 
        smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = fn_curve
    );
    
    
    //Runtime variables
    SI.Power W_electrolyser "Power given by the plant";
    SI.MolarFlowRate n_H2 "Molar flow rate of H2 mol/s";
    SI.MolarFlowRate n_O2 "Molar flow rate of O2 mol/s";
    SI.MolarFlowRate n_H2O "Molar flow rate of H2O mol/s";
    SI.Efficiency eta_f "Faraday efficiency";
    Real i(min = 0) "Current density in A/m^2";
    Real H2_vol;
     
    
  equation
    //der(W_electrolyser) = 1;
    p_curve.u1 = W_electrolyser;
    p_curve.u2 = T_electrolyser;
    i = p_curve.y;
    
    
    eta_f = (i / 1e-4) ^ 2 / (f11 + f12 * T_AEL + (i / 1e-4) ^ 2) * (f21 + f22 * T_AEL) "Calculating Faraday eff.";
    
    
    n_H2 = eta_f * (i * A_electrolyser) / (2 * F) * N_cells;
    n_O2 = 1 / 2 * n_H2;
    n_H2O = n_H2;
    H2_vol = n_H2 * 2.016 / 1000 / 0.09 * 3600;
    
    
  //Calculate reversible voltage using Nernst equation
  //V_rev = V_0 + (T_electrolyser - 298.15) * (-0.9e-3) + (R * T_electrolyser) / (2 * F) * MATH.log(
  //        (n_H2/(n_H2 + n_O2) * p_electrolyser) * (n_O2/(n_H2 + n_O2) * p_electrolyser)^0.5
  //);
  //Calculate the cell voltage
  //V_cell = V_rev +
  //         ((r1 + d1) + r2 * T_AEL + d2 * p_AEL) * i +
  //                  s * MATH.log((t1 + t2 / T_AEL + t3 / T_AEL^2) * i + 1);
  //Calculate the current flow
  //i = W_electrolyser / (V_cell * N_cells * A_electrolyser) "A/cm2";
  //Calculate the stack voltage
  //V_stack = V_cell * N_cells;
  end AEL_Electrolyser;

  model Simple_Electrolyser
  /*
    Simple electrolyser model
  */
    import SI = Modelica.SIunits;
    import nSI = Modelica.Units.NonSI;
    import CN = Modelica.Constants;
    import CONV = Modelica.SIunits.Conversions;
    import MATH = Modelica.Math;
    
    //Parameters
    parameter SI.Power P_electro = 15e3 "Name plate of one unit of electrolyser (after stacking the cells)";
    parameter SI.Power P_electro_requested = 15e3 "How big is the electrolyser";
    parameter Real N_unit = ceil(P_electro_requested/P_electro) "Number of electrolyser unit";  
    parameter String fn_curve = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/ElectrolyserCurve/AEL_Polarisation_Curve.motab");
    parameter SI.Pressure p_electrolyser = 7e5 "Operating pressure of in Pa";
    parameter SI.Temperature T_electrolyser = 80 + 273.15 "Operating temperature of in K";
    
    //Model instantiation
    SolarTherm.Models.Electrochemical.AEL_Electrolyser electrolyser(fn_curve = fn_curve, T_electrolyser = T_electrolyser, p_electrolyser = p_electrolyser);
    
    //Input and output
    Modelica.Blocks.Interfaces.RealInput W_electrolyser annotation(
      Placement(visible = true, transformation(origin = {-116, 1}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-118, 1}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput H2_out annotation(
      Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Real H2O_in;
  equation
    electrolyser.W_electrolyser = W_electrolyser/N_unit;
    H2_out = electrolyser.n_H2 * N_unit "Mol flux of H2 production mol/s";
    H2O_in = electrolyser.n_H2O * N_unit "Required hydrogen production in mol/s";
  
  annotation(
      Icon(graphics = {Rectangle(origin = {0, 1}, lineThickness = 3, extent = {{-98, 61}, {98, -61}}), Rectangle(origin = {0, -20}, fillColor = {85, 255, 255}, fillPattern = FillPattern.Vertical, extent = {{-98, 40}, {98, -40}}), Rectangle(origin = {-66, -2}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 42}, {6, -42}}), Rectangle(origin = {-66, -2}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 42}, {6, -42}}), Rectangle(origin = {62, -2}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 42}, {6, -42}}), Text(origin = {-57, -1}, rotation = 270, extent = {{-19, -3}, {23, -15}}, textString = "Anode"), Text(origin = {-57, -1}, rotation = 270, extent = {{-19, -3}, {23, -15}}, textString = "Anode"), Text(origin = {71, -1}, rotation = 270, extent = {{-19, -3}, {23, -15}}, textString = "Cathode"), Line(origin = {-35, 66}, points = {{-31, -26}, {-31, 20}, {31, 20}, {31, 20}}, thickness = 1), Line(origin = {6, 86}, points = {{-10, 4}, {-10, -4}, {-10, -4}}, thickness = 1), Line(origin = {31.12, 63.5}, points = {{-31, 22.5}, {31, 22.5}, {31, -23.5}, {31, -21.5}, {31, -21.5}}, thickness = 1), Line(origin = {0, 85}, points = {{0, 3}, {0, -1}, {0, -1}}, thickness = 1), Line(origin = {9.19, 66}, points = {{-79.1874, -26}, {-79.1874, 26}, {56.8126, 26}, {56.8126, -26}, {56.8126, -26}, {56.8126, -26}}, pattern = LinePattern.Dash, thickness = 1), Polygon(origin = {66, 43}, fillPattern = FillPattern.Solid, points = {{-2, 3}, {0, -3}, {2, 3}, {2, 3}, {-4, 3}, {-2, 3}}), Text(origin = {-78, 52}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {-78, 80}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {-38, 100}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {42, 100}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {74, 80}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {74, 54}, extent = {{-6, 8}, {6, -8}}, textString = "e-")}, coordinateSystem(initialScale = 0.1)));end Simple_Electrolyser;
end Electrochemical;