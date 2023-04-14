within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL_200kWe_574C_290C "SCO2 cycle based on regression of NREL PB, Nitrate Salt HTF"
	extends Cycle(T_in_ref = 574.0 + 273.15);
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;
	parameter SI.Temperature T_amb_ref = 35.0 + 273.15 "Design ambient temperature";
    Real t_in "Non-dimensional inlet temperature, called theta_in";
    Real t_amb "Non-dimensional ambient temperature, called theta_amb";
    parameter Real[12] a_array = {a_0,a_1,a_2,a_3,a_4,a_5,a_6,a_7,a_8,a_9,a_10,a_11} "Array of a";
    parameter Real[12] b_array = {b_0,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_10,b_11} "Array of b";
    Real[12] w_array = {1.0,t_amb,load,(t_amb)^2,(t_amb)^3,(load)^2,(t_in*t_amb)^3,(t_amb*load),(t_amb*load)^3,(t_in*load)^2,load/t_in,load/t_amb} "Array of w variables";
    Real[12] x_array = {1.0,t_amb,(t_in)^2,(t_amb)^3,(load)^2,(t_in*t_amb)^3,(t_amb*load),(t_amb*load)^2,(t_in*load),(t_in*load)^3,t_in/t_amb,load/t_amb} "Array of x variables";
    
    //Constants of a refer to regression constants of k_q
    constant Real a_0 = 55.5385;
    constant Real a_1 = -169.991;
    constant Real a_2 = 30.362;
    constant Real a_3 = 173.437;
    constant Real a_4 = -58.2379;
    constant Real a_5 = 3.05958;
    constant Real a_6 = -0.714121;
    constant Real a_7 = -10.6607;
    constant Real a_8 = -0.562018;
    constant Real a_9 = -2.24582;
    constant Real a_10 = -8.22426;
    constant Real a_11 = -10.7995;

    //Obtained by Zeb using StatGraphics Software
    //Adjusted R2 = 99.0185%
    //Standard Error = 0.0214622
    //Mean Absolute Error = 0.0168135
    
    //Constants of b refer to regression constants of k_w
    constant Real b_0 = -12.7118;
    constant Real b_1 = 14.5255;
    constant Real b_2 = -2.68897;
    constant Real b_3 = -4.39287;
    constant Real b_4 = -1.2235;
    constant Real b_5 = 0.845379;
    constant Real b_6 = 1.28025;
    constant Real b_7 = 0.377222;
    constant Real b_8 = -2.39567;
    constant Real b_9 = 0.323985;
    constant Real b_10 = 4.4821;
    constant Real b_11 = 1.88419;
    //Obtained by Zeb using StatGraphics Software
    //Adjusted R2 = 97.2072%
    //Standard Error = 0.00464156
    //Mean Absolute Error = 0.00349272
    parameter Real eta_q_des = sum(a_array) "Design HX efficiency";
    parameter Real eta_w_des = sum(b_array) "Design Cycle efficiency";
    parameter Real eta_gross_des = eta_q_des*eta_w_des "Design gross efficiency, product of eta_q and eta_w";
equation
    //Note that k_q and k_w get passed as eta_Q and eta_gross
    t_in = T_in/T_in_ref;
    t_amb = T_amb/T_amb_ref;
    k_q = sum(a_array.*w_array);
    k_w = sum(b_array.*x_array);
end sCO2NREL_200kWe_574C_290C;