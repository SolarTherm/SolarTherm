within SolarTherm.Models.Storage.Thermocline;

model Thermocline_Spheres_Section_LC_Final_NeuralNet
  //Lumped Capacitance
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;
  import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;

  //Initialize Material Packages
  replaceable package Fluid_Package = SolarTherm.Materials.Air_Table;
  replaceable package Filler_Package = SolarTherm.Materials.MgO_Constant;
  replaceable package Tank_Package =  SolarTherm.Materials.SS316L "Tank Package (steel shell)";
  replaceable package Encapsulation_Package = Filler_Package "Encapsulation Package, default is the same as Filler package, effectively no encapsulation";
  
  //********************** Neural network part
  parameter Integer inputdim = 4 "The dimension of input features: mdot, tank level, h_in, T_p_rep";
  parameter Integer outputdim = 1 "The dimension of the output: epsilon (effectiveness of the storage)";
    
  //1st let's initialise the tensorflow session
  parameter String saved_model_dir_charging = "/home/philgun/Documents/coolstuff/coolstuff/ML/script/script/effectiveness_based/mymodel_charging_2";
  parameter String saved_model_dir_discharging = "/home/philgun/Documents/coolstuff/coolstuff/ML/script/script/effectiveness_based/mymodel_discharging_2";
  
  STNeuralNetwork session_charging = STNeuralNetwork(saved_model_dir_charging);
  STNeuralNetwork session_discharging = STNeuralNetwork(saved_model_dir_discharging);

  //2nd define the UB LB for the features and labels
  parameter Real[inputdim] X_max_charging = {
        -809.5724248298088,
        0.9771817551665768,
        953001.9375,
        988.3679347547437
  };
  
  parameter Real[inputdim] X_min_charging = {
        -809.5724248298088,
        0.0,
        953001.9375,
        783.1500000000001
  };
  
  parameter Real y_max_charging = 1.101640432870237;
  parameter Real y_min_charging = 0.32760836294765167;
  
  parameter Real[inputdim] X_max_discharging = {
        485.7434548978853,
        0.975505536483094,
        705957.95,
        988.0159120787135
  };
  
  parameter Real[inputdim] X_min_discharging = {
        485.7434548978853,
        0.06469417654196799,
        705957.95,
        796.7364236416677
  };
  
  parameter Real y_max_discharging = 0.9991376596445076;
  parameter Real y_min_discharging = 0.4445542422709799; 
        
  //Height offset for plotting purposes
  parameter SI.Length z_offset = 0.0 "Amount of height offset if there is a tank below it";
  
  //Tank Design parameters
  parameter SI.Energy E_max = 144e9 "Design storage capacity";
  parameter SI.Energy E_init = 0 "Start energy value in the filler relative to minimum energy which is m_filler * hp(T_min)";
  parameter SI.Energy E_min = 100e9 "minimum energy which is m_filler * hp(T_min)";
  
  parameter Real ar = 2.0 "Tank Aspect ratio H/D";
  parameter Real eta = 0.22 "Porosity";
  parameter Real d_p = 0.015 "Diameter of sphere (particle) (m)";
  parameter Real t_e = d_p/(2.0*N_p) "Thickness of encapsulation, default is such that it is at a value that preserves equidistant radii discretizations (m)";
  parameter Real eff_pump = 1.00 "Pump electricity to work efficiency";
  
  
  //Temperature Bounds
  parameter SI.Temperature T_min = CV.from_degC(520) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(720) "Design hot Temperature of everything in the tank (K)";
  parameter SI.Temperature T_start = T_min "Initial (uniform) temperature of all components (K), defaults to T_min";
  
  //Calculated Tank Design Parameters
  parameter SI.Length H_tank = (4 * E_max / (CN.pi * (1 / ar) ^ 2 * (rho_f_avg * (h_f_max - h_f_min) * eta + rho_p * (h_p_max - h_p_min) * (1.0 - eta)))) ^ (1 / 3);
  parameter SI.Diameter D_tank = H_tank / ar;
  parameter SI.Area A = CN.pi * D_tank * D_tank / 4.0 "Cross sectional area of tank";
  parameter Integer N_f = 100 "Number of finite volume elements in fluid";
  parameter Integer N_p = 1 "Only One Element";
  parameter Real dz = H_tank / N_f "discretisations";
  parameter Real N_spheres_total = (N_f*6*(1-eta)*A*dz/(CN.pi*(d_p^3))) "Total number of spheres in the tank";
  parameter SI.Mass m_filler= rho_p*(1/6)*CN.pi*(d_p^3) * N_spheres_total "total mass of filler";
  
  //Thermal Losses
  parameter SI.Area A_loss_tank = CN.pi*D_tank*D_tank*2.0 + CN.pi*D_tank*H_tank "Heat loss area (m2)";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "Heat loss coeff of surfaces (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_wall = U_loss_tank "Cylinder wall heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_top = U_loss_tank "Top circle heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_bot = U_loss_tank "Bottom circle heat loss coeff (W/m2K)";
    
  //Property bounds
    //Fluid
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min,0) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max,0) "Starting enthalpy of the HTF";
  parameter SI.Density rho_f_min = Fluid_Package.rho_Tf(T_min,0);
  parameter SI.Density rho_f_max = Fluid_Package.rho_Tf(T_max,0);
  parameter SI.Density rho_f_avg = (rho_f_min + rho_f_max) / 2;
    //Filler
  parameter SI.SpecificEnthalpy h_p_max = Filler_Package.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_p_min = Filler_Package.h_Tf(T_min, 0.0);
  parameter SI.Density rho_p_min = Filler_Package.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_p_max = Filler_Package.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_p = min(rho_p_min,rho_p_max) "kg/m3";
  
    //Encapsulation
  parameter SI.SpecificEnthalpy h_e_max = Encapsulation_Package.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_e_min = Encapsulation_Package.h_Tf(T_min, 0.0);
  parameter SI.Density rho_e_min = Encapsulation_Package.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_e_max = Encapsulation_Package.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_e = min(rho_e_min,rho_e_max) "kg/m3";
      
  //Operational Controls
  Integer State(start = 2) "operational state 2=standby, 3=discharge, 1=charge";
  
  //Input to NN
  Real[inputdim] X_raw "Input to NN";

  //Inlet and outlet enthalpies and temperatures of the fluid
  SI.SpecificEnthalpy h_in "Inlet Enthalpy depends on mass flow direction (J/kg) --> determined by the wrapper";
  SI.SpecificEnthalpy h_out "Outlet Enthalpy depends on mass flow direction (J/kg) --> determined by the wrapper";
  SI.Temperature T_in "Inlet Temperature depends on mass flow direction --> calculated";
  SI.Temperature T_out "Outlet Temperature depends on mass flow direction --> calculated";
  
  //Particle temperature and enthalpy
  SI.SpecificEnthalpy h_p_rep "Calculated using energy balance";
  SI.Temperature T_p_rep "Calculated by T_h function";
  Real dummy;
 
  //Mass flow rates and superficial velocity of the fluid
  SI.MassFlowRate m_flow(start=0.0) "kg/s";
  
  //Analytics
  SI.Energy E_stored(start = 0.0) "Make sure the tank starts from T_min for this to be correct";
  Real Level(start = 0.0) "Tank energy charging level (0-1)";
  Real epsilon "Effectiveness of the storage --> calculated by calling ANN";
  SI.HeatFlowRate Q_loss_total "Heat loss from the entire surface area";
  SI.Pressure p_drop_total "Sum of all pressure drops";
  SI.Power W_loss_pump "losses due to pressure drop";
  SI.Temperature T_amb;
  //Real data[4];
  
  Fluid_Package.State fluid "Model which calculates properties at outlet of the section";
  Fluid_Package.State fluid_in "Model which calculates properties at inlet of the section";
  Fluid_Package.State fluid_out "Model which calculates properties at outlet of the section";
  
  //Cost breakdown
  parameter Real C_fluid = min(rho_f_max,rho_f_min)*eta*(CN.pi*D_tank*D_tank*H_tank/4.0)*Fluid_Package.cost;
  parameter Real C_section = C_fluid + C_filler + C_insulation + C_tank + C_encapsulation;
  parameter Real C_insulation = if U_loss_tank > 1e-3 then (16.72/U_loss_tank + 0.04269)*A_loss_tank else 0.0;
  parameter Real C_tank = C_shell(max(rho_f_max,rho_f_min),H_tank,D_tank,Tank_Package.sigma_yield(T_max),Tank_Package.rho_Tf(298.15,0.0),4.0);
  
  parameter Real C_filler = rho_p*(1.0-eta)*(CN.pi*D_tank*D_tank*H_tank/4.0)*Filler_Package.cost;
  parameter Real C_encapsulation = 0.0;
  //Filler Surface Area Correction
  parameter Real f_surface = 1.0 "Don't touch this";
  
  //parameter SI.Mass m_e = rho_e*(1/6)*CN.pi*((d_p^3)-((d_p-2*t_e)^3)) "Masses of encapsulation in one particle";
  //Pressure Drop  
algorithm

equation  
  if State == 1 then
      //Charging (Mass flows top to bottom)
      epsilon = predict(session_charging,X_raw,inputdim,X_max_charging,X_min_charging,y_max_charging,y_min_charging, State);
      h_out = h_in + min(epsilon,1) * (h_f_min - h_in);    
  elseif State == 2 then
      epsilon = 0;
      h_out = h_in;
  else
      //Discharging (Mass flows bottom to top)
      epsilon = predict(session_discharging,X_raw,inputdim,X_max_discharging,X_min_discharging,y_max_discharging,y_min_discharging, State);
      h_out = h_in + min(epsilon,1) * (h_f_max - h_in);
  end if;
  //Determine which operational state: In this version, standby and discharge are lumped.
  if m_flow < 0.0 then //mass is flowing downwards so charging
      State = 1;
  elseif abs(m_flow) < 1e-3 then
      State = 2;
  else //mass is flowing upwards so discharging
      State = 3;
  end if;
  
  
  X_raw = {m_flow, Level, h_in,  T_p_rep};
  
  fluid_in.h = h_in;
  fluid_out.h = h_out;
  
  T_in = fluid_in.T;
  T_out = fluid_out.T;
    
  //Analytics
  der(E_stored) = abs(m_flow) * (h_in - h_out) - Q_loss_total;
  Level = E_stored / E_max;
  
  //Calculate fluid properties using representative temperature of the tank
  h_p_rep = (E_stored + E_min) / m_filler;
  (T_p_rep,dummy) = Filler_Package.Tf_h(h_p_rep) "Assign temperature of the filler to the T_p_rep";
  
  fluid.T = T_p_rep;
    
  //Heat loss calculations
  Q_loss_total = U_top * 0.25 * CN.pi * D_tank^2 * (T_p_rep - T_amb) +  U_bot * 0.25 * CN.pi * D_tank^2 * (T_p_rep - T_amb) + U_wall * CN.pi * D_tank * H_tank * (T_p_rep-T_amb);
  
  //Calculated Pumping losses
  p_drop_total = dz*(((600*((1-eta)^2)*fluid.mu*abs(m_flow))/((eta^3)*(d_p^2)*rho_f_avg*CN.pi*(D_tank^2)))+((28*(1-eta)*(m_flow^2))/((eta^3)*d_p*rho_f_avg*CN.pi*CN.pi*(D_tank^4))));
  W_loss_pump = (abs(m_flow)/rho_f_avg)*p_drop_total/eff_pump;
  
  annotation (Documentation(revisions = "<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>", info = "<html>
		<p>This model contains the heat-transfer calculations of a thermocline packed bed storage tank with spherical filler geometry. This model does not contain any fluid connectors, for the CSP component with connectors, see Thermocline_Spheres_SingleTank. Variables fluid_top and fluid_bot provides the enthalpy-temperature relationship of the fluid material. Depending on whether m_flow is positive (discharging, fluid flowing upwards) or negative (charging, fluid flowing downwards), the charging/discharging equations are applied. In this iteration of the model, discharging and standby are lumped into one state.</p>
		</html>"),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end Thermocline_Spheres_Section_LC_Final_NeuralNet;