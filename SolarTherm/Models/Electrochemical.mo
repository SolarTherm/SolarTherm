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
    The electrolyser model is based on: https://doi.org/10.1016/j.ijhydene.2019.12.027 . Polarisation curve is extracted, fitted as CombiTable2D where the inputs are: delivered power to the
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
        smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, 
        fileName = fn_curve
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
    
    if W_electrolyser >  0 then
        n_H2 = eta_f * (i * A_electrolyser) / (2 * F) * N_cells;
        n_O2 = 1 / 2 * n_H2;
        n_H2O = n_H2;
        H2_vol = n_H2 * 2.016 / 1000 / 0.09 * 3600;
    else
        n_H2 = 0;
        n_O2 = 0;
        n_H2O = 0;
        H2_vol = 0; 
    end if;
      
    
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
    parameter SI.Power P_electro = 15e3 "Name plate of one unit of electrolyser (after stacking the cells) as per literature";
    parameter SI.Power P_electro_requested = 15e3 "How big is the electrolyser";
    parameter Real N_unit(fixed=false)  "Number of electrolyser unit";
    parameter String fn_curve = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/ElectrolyserCurve/AEL_Polarisation_Curve.motab");
    parameter SI.Pressure p_electrolyser = 7e5 "Operating pressure of in Pa";
    parameter SI.Temperature T_electrolyser = 80 + 273.15 "Operating temperature of in K";
    parameter Real H2_molar_mass = 2e-3 "Molar mass of H2 in kg/mol";
    parameter Real O2_molar_mass = 16e-3 "Molar mass of H2 in kg/mol";
    parameter Real H2O_molar_mass = 18e-3 "Molar mass of H2 in kg/mol";
    parameter Real LHV = 120e6;
    
    //Calculated parameters
    parameter SI.MassFlowRate H2_mdot_design_point(fixed=false) "Given the size of the electricity generator, what would be H2 mdot at design point [kg/s]";
    parameter SI.MassFlowRate O2_mdot_design_point(fixed=false) "Given the size of the electricity generator, what would be O2 mdot at design point [kg/s]";
    parameter Real i_electrolyser_design_point(fixed=false) "Current density of electrolyser at design point [A/cm2]";
    parameter Real eta_farad_design_point(fixed=false) "Faraday eff. at design point [-]";
    parameter Real n_H2_design_point(fixed=false) "Molar flow rate of H2 at design point given the size of the generators (mol/s)";
    
    //Model instantiation
    SolarTherm.Models.Electrochemical.AEL_Electrolyser electrolyser(fn_curve = fn_curve, T_electrolyser = T_electrolyser, p_electrolyser = p_electrolyser);
    
    //Input and output
    Modelica.Blocks.Interfaces.RealInput W_electrolyser_PV annotation(
      Placement(visible = true, transformation(origin = {-116, -19}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-124, -15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      
    Modelica.Blocks.Interfaces.RealInput W_electrolyser_PB annotation(
    Placement(visible = true, transformation(origin = {-116, 31}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, 41}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput H2_mdot_out "Mass flow rate of H2 produced by electrolyser" annotation(
      Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Real H2O_in;
    SI.Mass H2O_mass "Accummulated mass of H2O";
    SI.Power W_electrolyser_final "Final power sent to the electrolyser after dumping (if necessary)";
    SI.Energy E_dumped(start=0) "Accummulated dumped electricity [J]";
    Real N_unit_final "Number of electrolyser unit that is opearting full load";
    parameter Real upstreammultiplier = 1;
    
    //*********** External Combitable 2D
    Modelica.Blocks.Types.ExternalCombiTable2D polarisation_curve =  Modelica.Blocks.Types.ExternalCombiTable2D(
        tableName = "polarisation_curve", 
        fileName = fn_curve, 
        table = fill(0.0, 0, 2), 
        smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative
    ) "2D table for polarisation curve";
    
    SI.Power W_electrolyser;
    SI.Power W_dumped_PV;
    SI.Power W_dumped_PB;
    
    Boolean on_electrolyser;
    parameter Boolean with_storage=false;
    SI.Mass H2_dumped;
    SI.Mass O2_dumped;
    SI.Efficiency eta_AEL;
    
    Modelica.Blocks.Interfaces.RealOutput W_dumped annotation(
      Placement(visible = true, transformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput W_d_PB annotation(
      Placement(visible = true, transformation(origin = {102, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput W_d_PV annotation(
      Placement(visible = true, transformation(origin = {100, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput O2_mdot_out annotation(
      Placement(visible = true, transformation(origin = {106, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.BooleanInput H2_tank_charging annotation(
      Placement(visible = true, transformation(origin = {22, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {22, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  initial equation
    N_unit = ceil(P_electro_requested/P_electro); 
    i_electrolyser_design_point = SolarTherm.Utilities.electrolyser_current_density(
        P_electro, 
        T_electrolyser, 
        polarisation_curve
    );
    
    eta_farad_design_point = (i_electrolyser_design_point / 1e-4) ^ 2 / (electrolyser.f11 + electrolyser.f12 * (T_electrolyser-273.15) + (i_electrolyser_design_point / 1e-4) ^ 2) * (electrolyser.f21 + electrolyser.f22 * (T_electrolyser-273.15)) "Calculating Faraday eff.";
    
    
    n_H2_design_point = eta_farad_design_point * (i_electrolyser_design_point * electrolyser.A_electrolyser) / (2 * Modelica.Constants.F) * electrolyser.N_cells * N_unit;
    
    H2_mdot_design_point = n_H2_design_point * 2e-3;
    O2_mdot_design_point = n_H2_design_point * 0.5 * 16e-3;
  
  equation
    W_electrolyser = W_electrolyser_PB + W_electrolyser_PV;
    
    on_electrolyser = H2_tank_charging;
    
    if on_electrolyser then
    /*If one of the tanks need to be charged then turn on the electrolyser*/
        if W_electrolyser > P_electro_requested then
          /*If power input overshoot, has to be dumped shall it exceeds the nameplate*/
            W_electrolyser_final = P_electro_requested "The final electricity send to the electrolyser == nameplate, rest is dumped";
            W_dumped = W_electrolyser - P_electro_requested "Dumped electricity due to overshoot [W], charge the tank";
            if W_electrolyser_PV < P_electro_requested then
                W_dumped_PV = 0;
                W_dumped_PB = (W_electrolyser_PB - (P_electro_requested - W_electrolyser_PV))/upstreammultiplier;
            else
                W_dumped_PV = W_dumped;
                W_dumped_PB = 0;
            end if;
            
        else
            W_electrolyser_final = W_electrolyser;
            W_dumped = 0 "Dumped electricity due to overshoot [W]";
            W_dumped_PV = 0 "Portion of dumped energy from PV [W]";
            W_dumped_PB = 0 "Portion of dumped power from PB [W]";
        end if;
    else
        /*If all tanks are full, need not to turn on the electrolyser, all the electricity goes to the resistive heater*/
        W_electrolyser_final = 0;
        W_dumped = W_electrolyser_PV "Dumped electricity due to overshoot [W]";
        W_dumped_PV = W_electrolyser_PV "Portion of dumped energy from PV [W]";
        W_dumped_PB = 0 "Portion of dumped power from PB [W]";
    end if;
    
    W_d_PB = W_dumped_PB; 
    W_d_PV = W_dumped_PV;
         
    der(E_dumped) = W_dumped "Integrating W_dumped to get E_dumped";
    
    if W_electrolyser_final > P_electro then
        // AEL Stack is always opearting at full-load at 15 kWe
        electrolyser.W_electrolyser = P_electro;
    else
        // AEL Stack operates at part load
        electrolyser.W_electrolyser = W_electrolyser_final;
    end if;
    
    if on_electrolyser then
        //if W_electrolyser > 10 then
        if W_electrolyser > 1e-3 then
            N_unit_final = W_electrolyser_final/P_electro_requested * N_unit "only several units are operating full load";
            der(H2O_mass) = H2O_in * H2O_molar_mass "Mass of water needed";
            H2O_in = electrolyser.n_H2O * max(1,N_unit_final) "Required hydrogen production in mol/s";
            H2_mdot_out = if H2_tank_charging then electrolyser.n_H2 * max(1,N_unit_final) * H2_molar_mass else 0 "Mass flow rate of H2 production kg/s";
            O2_mdot_out = electrolyser.n_O2 * max(1,N_unit_final) * O2_molar_mass "Mass flow rate of O2 production kg/s"; 
            der(H2_dumped) = if H2_tank_charging then 0 else electrolyser.n_H2 * max(1,N_unit_final) * H2_molar_mass "Dumped H2 ";
            der(O2_dumped) = 0 "Dumped 02 ";
        else
            N_unit_final = 0;
            H2_mdot_out = 0;
            H2O_in = 0;
            der(H2O_mass) = 0;
            O2_mdot_out = 0;
            der(H2_dumped) = 0;
            der(O2_dumped) = 0;
        end if;
    else
        N_unit_final = 0;
        H2_mdot_out = 0;
        H2O_in = 0;
        der(H2O_mass) = 0;
        O2_mdot_out = 0;
        der(H2_dumped) = 0;
        der(O2_dumped) = 0;
    end if;
    eta_AEL = 1;// W_electrolyser_final > 1 then H2_mdot_out * LHV / W_electrolyser_final else 0;
    
  annotation(
      Icon(graphics = {Rectangle(origin = {0, 1}, lineThickness = 3, extent = {{-98, 61}, {98, -61}}), Rectangle(origin = {0, -20}, fillColor = {85, 255, 255}, fillPattern = FillPattern.Vertical, extent = {{-98, 40}, {98, -40}}), Rectangle(origin = {-66, -2}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 42}, {6, -42}}), Rectangle(origin = {-66, -2}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 42}, {6, -42}}), Rectangle(origin = {62, -2}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 42}, {6, -42}}), Text(origin = {-57, -1}, rotation = 270, extent = {{-19, -3}, {23, -15}}, textString = "Anode"), Text(origin = {-57, -1}, rotation = 270, extent = {{-19, -3}, {23, -15}}, textString = "Anode"), Text(origin = {71, -1}, rotation = 270, extent = {{-19, -3}, {23, -15}}, textString = "Cathode"), Line(origin = {-35, 66}, points = {{-31, -26}, {-31, 20}, {31, 20}, {31, 20}}, thickness = 1), Line(origin = {6, 86}, points = {{-10, 4}, {-10, -4}, {-10, -4}}, thickness = 1), Line(origin = {31.12, 63.5}, points = {{-31, 22.5}, {31, 22.5}, {31, -23.5}, {31, -21.5}, {31, -21.5}}, thickness = 1), Line(origin = {0, 85}, points = {{0, 3}, {0, -1}, {0, -1}}, thickness = 1), Line(origin = {9.19, 66}, points = {{-79.1874, -26}, {-79.1874, 26}, {56.8126, 26}, {56.8126, -26}, {56.8126, -26}, {56.8126, -26}}, pattern = LinePattern.Dash, thickness = 1), Polygon(origin = {66, 43}, fillPattern = FillPattern.Solid, points = {{-2, 3}, {0, -3}, {2, 3}, {2, 3}, {-4, 3}, {-2, 3}}), Text(origin = {-78, 52}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {-78, 80}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {-38, 100}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {42, 100}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {74, 80}, extent = {{-6, 8}, {6, -8}}, textString = "e-"), Text(origin = {74, 54}, extent = {{-6, 8}, {6, -8}}, textString = "e-")}, coordinateSystem(initialScale = 0.1)));end Simple_Electrolyser;

  model ElectrolyserCalculator
  
  import SI = Modelica.SIunits;
  import nSI = Modelica.Units.NonSI;
  import CN = Modelica.Constants;
  import CONV = Modelica.SIunits.Conversions;
  import MATH = Modelica.Math;
    
    
  //Some constants
  parameter SI.FaradayConstant F = CN.F "Faraday constant";
  parameter Real R = CN.R "Molar gas constant (J/[mol.K])";
  
  parameter SI.MassFlowRate H2_target = 0.5 * 1e6 * 1e3 / (8760 *3600) "Hydrogen annual target production per second";
  parameter Real H2_mol_target = H2_target * 1000 / 2 / 35;
  parameter SI.Power P_nameplate_AEL = 15e3 "Nameplate per unit of AEL";
  parameter SI.Temperature T_electrolyser = 80 + 273.15;
  
  parameter Integer N_cells = 12 "Number of cells of the electrolyser";
  parameter Real A_electrolyser = 1000 "Total electrode area in cm^2";
  
  parameter String fn_curve = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/ElectrolyserCurve/AEL_Polarisation_Curve.motab");
  parameter Real T_AEL = T_electrolyser - 273.15;
  //CombiTable2D instantiation for reading Polarisation Curve
  Modelica.Blocks.Tables.CombiTable2D p_curve(
      tableOnFile = true, 
      tableName = "polarisation_curve", 
      smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = fn_curve
  );
  
  /*Faraday efficiency*/
  parameter Real f11 = 478645.74 "A^2/m^4";
  parameter Real f12 = -2953.15 "A^2/(m^4.C)";
  parameter Real f21 = 1.03960;
  parameter Real f22 = -0.00104 "C^-1";
  
  
  Real i(fixed=false);
  Real eta_f(fixed=false);
  Real nH2;
  SI.MassFlowRate m_H2;
  Real MW_total;
  
  initial equation
  
  equation
    p_curve.u1 = P_nameplate_AEL;
    p_curve.u2= T_electrolyser;
    i = p_curve.y;
    eta_f = (i / 1e-4) ^ 2 / (f11 + f12 * T_AEL + (i / 1e-4) ^ 2) * (f21 + f22 * T_AEL) "Calculating Faraday eff.";
    nH2 = eta_f * (i * A_electrolyser) / (2 * F) * N_cells * (100e6/P_nameplate_AEL);
    m_H2 = nH2 * 2/1000;
    MW_total = H2_target/m_H2 * P_nameplate_AEL;

  end ElectrolyserCalculator;
 
end Electrochemical;