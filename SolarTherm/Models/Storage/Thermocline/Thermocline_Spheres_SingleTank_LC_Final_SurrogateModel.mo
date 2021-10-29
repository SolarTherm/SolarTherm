within SolarTherm.Models.Storage.Thermocline;

model Thermocline_Spheres_SingleTank_LC_Final_SurrogateModel

  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  parameter Boolean with_neural_network = true;
  import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
  
  //************************ NN parameters
  parameter Integer inputdim = 3;
  //2 nd define the UB LB for the features and labels
  parameter Real[inputdim] X_max_charging = {-100.400222705587,1.10509815816349,986049.881964129};
  parameter Real[inputdim] X_min_charging = {-1999.88567524035,0.061006589478941,924592.381219165};
  parameter Real y_max_charging = 1.00999902894914;
  parameter Real y_min_charging = 0.158532257727923;  
  
  parameter Real[inputdim] X_max_discharging = {1999.25093676076,0.993934860101645,749917.462866583};
  parameter Real[inputdim] X_min_discharging = {100.714662771693,0.006731654239218,695050.244857072};
  parameter Real y_max_discharging = 1.00999250658051;
  parameter Real y_min_discharging = 0.306292811136954;
  
  parameter String saved_model_dir_charging = "/home/philgun/Documents/coolstuff/coolstuff/ML/script/script/effectiveness_based/skopt/tank_bayesian_charging/surrogate_model";  
  parameter String saved_model_dir_discharging = "/home/philgun/Documents/coolstuff/coolstuff/ML/script/script/effectiveness_based/skopt/tank_bayesian_discharging/surrogate_model";  
  
  //*************** Instantiate Neural Network sessions for charging and discharging
  parameter SI.Energy E_min = 19953336104584.156 "[J]";
  parameter SI.Mass  m_filler = 34284082.65392467 "[kg]";
  parameter SI.Length D_tank = 21.7161 "Tank diameter [m]";
  parameter SI.Length H_tank = 43.4323 "Tank height [m]";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "Heat loss coeff of surfaces (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_wall = U_loss_tank "Cylinder wall heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_top = U_loss_tank "Top circle heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_bot = U_loss_tank "Bottom circle heat loss coeff (W/m2K)";
  SI.HeatFlowRate Q_loss_total "Heat losses in the tank [W]";
  SI.Temperature T_p_rep "Average temperature in the tank [K]";
  Real dummy;
  STNeuralNetwork session_charging = STNeuralNetwork(saved_model_dir_charging);
  STNeuralNetwork session_discharging = STNeuralNetwork(saved_model_dir_discharging);
  
  /*
  //Curve-Fit Parameters from ZK analysis - Not used
  parameter Real A = 3.9309;
  parameter Real B = -14.2881;
  parameter Real C = 23.3269;
  parameter Real D = -12.7636;
  parameter Real E = 0.3518;
  parameter Real F = 4.1959;
  parameter Real G = -8.9110;
  parameter Real H = 6.1972;
  */
  //**********************Curve fit from Python SKLEARN
  parameter Real regression_params[15] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
  parameter Real[5] CHG_PARAM = regression_params[1:5] "Curve-fit constants for charging";
  parameter Real CHG_INT = regression_params[6] "Curve-fit intercept for charging";
  parameter Real[5] DIS_PARAM = regression_params[7:11] "Curve-fit constants for discharging";
  parameter Real DIS_INT = regression_params[12] "Curve-fit intercept for discharging";
  parameter Real L_charge_flat = regression_params[13] "Region less than which the charging effectiveness curve is flat";//0.568378;
  parameter Real L_discharge_flat = regression_params[14] "Region bigger than which the discharging effectiveness curve is flat ";//0.638798;
      
  // Storage
  //replaceable package Storage = SolarTherm.Materials.Graphite "the storage medium";
  parameter Modelica.SIunits.Temperature T_min = 500 + 273.15 "start temperature of the storage medium";
  parameter Modelica.SIunits.Temperature T_max = 720 + 273.15 "the maximum temperature of the storage medium";
  parameter Modelica.SIunits.Temperature h_max = Fluid_Package.h_Tf(T_max, 1.0) "the maximum enthalpy of the storage medium";
  parameter Modelica.SIunits.Temperature h_min = Fluid_Package.h_Tf(T_min, 0.0) "the initial enthalpy of the storage medium";
  parameter Modelica.SIunits.Energy E_max;
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation(
    Placement(visible = true, transformation(origin = {48, 8.88178e-16}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {46, 0}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  //Modelica.SIunits.Temperature T_st"tempaerture of the storage medium";
  //Modelica.SIunits.SpecificEnthalpy h_st "enthlpy of the sotrage medium";
  // HTF
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "heat transfer medium";
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium_Table "fluid material package";
  replaceable package Filler_Package =  SolarTherm.Materials.MgO_Constant "fluid material package";
  Modelica.SIunits.Temperature T_in;
  Modelica.SIunits.Temperature T_out;
  Modelica.SIunits.SpecificEnthalpy h_in;
  Modelica.SIunits.SpecificEnthalpy h_out;
  Fluid_Package.State fluid_in "Property calculation of inlet";
  Fluid_Package.State fluid_out "Property calculation of outlet";
  // energy balance
  Modelica.SIunits.MassFlowRate m_flow "mass flow with respect to height direction";
  Modelica.SIunits.Energy E_stored(start = L_start * E_max);
  //Real e_out "outlet effectiveness";
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-35, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Level "Storage Level NonDimensional" annotation(
    Placement(visible = true, transformation(origin = {-41, 49}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-48, 0}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  //Regression Modelica
  parameter Real L_start = 0.01 "Starting storage level";
  Real L(start = L_start) "Tank Level";
  Real epsilon "Nondimensional outlet temperature/effectiveness";
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {48, 36}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {46, 48}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
equation
  //********************** m_flow relative to the direction of the fluid
  m_flow = -1.0*fluid_a.m_flow; 
  
  //********************** Populate inputs
  if m_flow > 0.0 then //****************************** fluid flowing upwards so discharge
      //**************** Predict effectiveness\
      //if with_neural_network == true then
      //    epsilon = min(1.0,predict(session_discharging,X_raw,inputdim,X_max_discharging,X_min_discharging,y_max_discharging,y_min_discharging));    
      //else
      if L < L_discharge_flat then //curve region
        //epsilon = min(1.0, E + F*L + G*(L^2) + H*(L^3));
        epsilon = max(0,min(1.0, DIS_PARAM[1] * L + DIS_PARAM[2] * L^2 + DIS_PARAM[3] * L^3 + DIS_PARAM[4] * L^4 + DIS_PARAM[5] * L^5 + DIS_INT));
      else //flat region
        epsilon = 1.00;
      end if;
      
      /*        
      epsilon = min(1.0, DIS_PARAM[1] * L + DIS_PARAM[2] * L^2 + DIS_PARAM[3] * L^3 + DIS_PARAM[4] * L^4 + DIS_PARAM[5] * L^5 + DIS_PARAM[6] * L^6 + DIS_PARAM[7] * L^7 + DIS_INT);
      */
      //end if;
      
      //********************** Enthalpies
      h_in = inStream(fluid_b.h_outflow);
      fluid_b.h_outflow = h_in;
      fluid_a.h_outflow = h_out;
  
      //T_out = T_min + epsilon*(T_max-T_min); ==> ZK original equation
      h_out = h_in + max(epsilon,0) * (h_max - h_in);
      h_bot_outlet = h_min;
      
      //*********************** Energy balance equation
      der(E_stored) = m_flow*(inStream(fluid_b.h_outflow)-fluid_a.h_outflow)- Q_loss_total;
  else //**************************************** fluid flowing downwards so charging
      //**************** Predict effectiveness
      //if with_neural_network then 
      //    if L < X_min_charging[2] then
      //        epsilon = 1;
      //    else
      //       epsilon = max(0,min(1.0,predict(session_charging,X_raw,inputdim,X_max_charging,X_min_charging,y_max_charging,y_min_charging)));  
      //    end if;
      //else
          
      if L > L_charge_flat then //curve region
        //epsilon = min(1.0, A + B*L + C*(L^2) + D*(L^3));
        epsilon = min(1.0, CHG_PARAM[1] * L + CHG_PARAM[2] * L^2 + CHG_PARAM[3] * L^3 + CHG_PARAM[4] * L^4 + CHG_PARAM[5] * L^5+ CHG_INT);
      else //flat region
        epsilon = 1.00;
      end if;
          
          /*
          if L < 0.2 then 
              epsilon = 1;
          else
              epsilon = min(1.0, CHG_PARAM[1] * L + CHG_PARAM[2] * L^2 + CHG_PARAM[3] * L^3 + CHG_PARAM[4] * L^4 + CHG_PARAM[5] * L^5 + CHG_PARAM[6] * L^6 + CHG_PARAM[7] * L^7 + CHG_INT);
          end if;
          */
          
      //end if;
      //********************** Enthalpies
      h_in = inStream(fluid_a.h_outflow);
      fluid_a.h_outflow = h_in;
      fluid_b.h_outflow = h_out;
      
      
      //T_out = T_max - epsilon*(T_max-T_min); ==> ZK original equation
      h_out = h_in + max(epsilon,0) * (h_min - h_in); 
      h_bot_outlet = Fluid_Package.h_Tf(T_out, 0.0);
      
      //*********************** Energy balance equation
      der(E_stored) = -1.0*m_flow*(inStream(fluid_a.h_outflow)-fluid_b.h_outflow)- Q_loss_total;
  end if;
  
  //********************** Avg temp in the tank
  (T_p_rep, dummy)  = Filler_Package.Tf_h((E_stored + E_min) / m_filler);
  
  //********************** Heat loss calculation
  Q_loss_total = U_top * 0.25 * CN.pi * D_tank^2 * (T_p_rep - T_amb) +  
                    U_bot * 0.25 * CN.pi * D_tank^2 * (T_p_rep - T_amb) + 
                        U_wall * CN.pi * D_tank * H_tank * (T_p_rep-T_amb);
   
  //********************** State of charge
  L = E_stored/E_max;
  Level = L;
  
  //********************** Close the port equations
  fluid_in.h = h_in;
  T_in = fluid_in.T;
  
  fluid_out.T = T_out;
  h_out = fluid_out.h;
  
  //********************** Mass balance equation
  fluid_a.m_flow + fluid_b.m_flow = 0;
  
  //********************** Close the ambient temperature
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;

annotation(
    Icon(graphics = {Text(origin = {7, -16}, extent = {{-49, 42}, {35, -10}}, textString = "TC"), Ellipse(origin = {-36, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, 16}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 16}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 6}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 6}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -4}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -4}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -14}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -14}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Text(origin = {-62, 11}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb"), Text(origin = {62, 12}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {-52, -65}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {48, -63}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {43, 68}, extent = {{-15, 4}, {25, -12}}, textString = "SOC", fontSize = 12), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b"), Text(origin = {50, 35.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_95%"), Text(origin = {50, -26.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_05%")}, coordinateSystem(initialScale = 0.1)), Documentation(revisions ="<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>",info="<html>
		<p>This model contains the fluid_a (top) and fluid_b (bottom) ports, basically a complete CSP component. This model simply connects the Thermocline_Spheres_Section models to the correct ports.</p>
		</html>"),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end Thermocline_Spheres_SingleTank_LC_Final_SurrogateModel;