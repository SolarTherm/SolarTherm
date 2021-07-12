within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL_100MWe_720C_500C "SCO2 cycle based on regression of NREL PB, Sodium HTF"
	extends Cycle(T_in_ref = 720.0 + 273.15);
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;
	parameter SI.Temperature T_amb_ref = 35.0 + 273.15 "Design ambient temperature";
    Real T_ND "Non-dimensional inlet temperature";
    Real T_amb_ND "Non-dimensional ambient temperature";
    //These constants are for eta_Q or k_q
    constant Real a_0 = -7.063737;
    constant Real a_1 = 3.363395;
    constant Real a_2 = 8.051343;
    constant Real a_3 = 1.454204;
    constant Real a_4 = -4.473867;
    constant Real a_5 = -0.382406;
    //These constants are for eta_gross or k_w
    constant Real b_0 = 8.237821;
    constant Real b_1 = 4.357904;
    constant Real b_2 = -2.074309;
    constant Real b_3 = -34.690258;
    constant Real b_4 = 39.327013;
    constant Real b_5 = -14.842294;
    constant Real b_6 = 0.301619;
    constant Real b_7 = -0.141392;
    //Regression design values (when all variables are 1)
    parameter Real eta_q_des = 0.948933 "Design HX efficiency";
    parameter Real eta_w_des = 0.476106 "Design Cycle efficiency";
    parameter Real eta_gross_des = 0.451793 "Design gross efficiency, product of eta_q and eta_w";
    
equation
    //Note that k_q and k_w get passed as eta_Q and eta_gross
    T_ND = T_in/T_in_ref;
    T_amb_ND = T_amb/T_amb_ref;

    k_q = a_0 + a_1*(T_ND) + a_2*(T_amb_ND) + a_3*(T_amb_ND^2) + a_4*(load) + a_5*(load^2);
    k_w = b_0 + b_1*(T_ND) + b_2*(T_ND^2) + b_3*(T_amb_ND) + b_4*(T_amb_ND^2) + b_5*(T_amb_ND^3) + b_6*(load) + b_7*(load^2);
end sCO2NREL_100MWe_720C_500C;