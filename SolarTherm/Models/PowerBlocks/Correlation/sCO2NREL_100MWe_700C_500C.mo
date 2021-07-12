within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL_100MWe_700C_500C "SCO2 cycle based on regression of NREL PB, Sodium HTF"
	extends Cycle(T_in_ref = 700.0 + 273.15);
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;
	parameter SI.Temperature T_amb_ref = 35.0 + 273.15 "Design ambient temperature";
    Real T_ND "Non-dimensional inlet temperature";
    Real T_amb_ND "Non-dimensional ambient temperature";
    //These constants are for eta_Q or k_q
    constant Real a_0 = -7.252764;
    constant Real a_1 = 3.652907;
    constant Real a_2 = 7.853152;
    constant Real a_3 = -4.364979;
    constant Real a_4 = 1.433866;
    constant Real a_5 = -0.374598;
    //These constants are for eta_gross or k_w
    constant Real b_0 = 8.102387;
    constant Real b_1 = 5.380067;
    constant Real b_2 = -2.580075;
    constant Real b_3 = -35.960902;
    constant Real b_4 = 40.725961;
    constant Real b_5 = -15.354071;
    constant Real b_6 = 0.307790;
    constant Real b_7 = -0.145251;
    //Regression design values (when all variables are 1)
    parameter Real eta_q_des = 0.947584 "Design HX efficiency";
    parameter Real eta_w_des = 0.475905 "Design Cycle efficiency";
    parameter Real eta_gross_des = 0.450960 "Design gross efficiency, product of eta_q and eta_w";
    
equation
    //Note that k_q and k_w get passed as eta_Q and eta_gross
    T_ND = T_in/T_in_ref;
    T_amb_ND = T_amb/T_amb_ref;

    k_q = a_0 + a_1*(T_ND) + a_2*(T_amb_ND) + a_3*(T_amb_ND^2) + a_4*(load) + a_5*(load^2);
    k_w = b_0 + b_1*(T_ND) + b_2*(T_ND^2) + b_3*(T_amb_ND) + b_4*(T_amb_ND^2) + b_5*(T_amb_ND^3) + b_6*(load) + b_7*(load^2);
end sCO2NREL_100MWe_700C_500C;