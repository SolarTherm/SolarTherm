within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL_31p5kWe_574C_290C "SCO2 cycle based on regression of NREL PB, Nitrate Salt HTF"
	extends Cycle(T_in_ref = 574.0 + 273.15);
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;
	parameter SI.Temperature T_amb_ref = 35.0 + 273.15 "Design ambient temperature";
    Real T_ND "Non-dimensional inlet temperature";
    Real T_amb_ND "Non-dimensional ambient temperature";
    //These constants are for eta_Q or k_q
    constant Real a_0 = -6.43901601;
    constant Real a_1 = 2.29091108;
    constant Real a_2 = 9.04913911;
    constant Real a_3 = -5.02206843;
    constant Real a_4 = 1.42792171;
    constant Real a_5 = -0.35782928;
    //These constants are for eta_gross or k_w
    constant Real b_0 = -1.17807223;
    constant Real b_1 = 5.81029393;
    constant Real b_2 = -4.13492394;
    constant Real b_3 = -6.75652612;
    constant Real b_4 = -0.02760564;
    constant Real b_5 = 3.37279872;
    constant Real b_6 = 0.15221531;
    constant Real b_7 = 3.06873908;
    constant Real b_8 = 0.27754429;
    //Regression design values (when all variables are 1)
    parameter Real eta_q_des = 0.94905819 "Design HX efficiency";
    parameter Real eta_w_des = 0.30691911 "Design Cycle efficiency";
    parameter Real eta_gross_des = 0.29128409 "Design gross efficiency, product of eta_q and eta_w";
    
equation
    //Note that k_q and k_w get passed as eta_Q and eta_gross
    T_ND = T_in/T_in_ref;
    T_amb_ND = T_amb/T_amb_ref;

    k_q = a_0 + a_1*(T_ND) + a_2*(T_amb_ND) + a_3*(T_amb_ND^2) + a_4*(load) + a_5*(load^2);
    k_w = b_0 + b_1*(T_amb_ND^2) + b_2*(T_amb_ND^3) + b_3*(load) + b_4*((1.0/load)^2) + b_5*(T_amb_ND*load) + b_6*((T_amb_ND*load)^2) + b_7*(load/T_amb_ND) + b_8*(1.0-(T_amb_ND/T_ND));
end sCO2NREL_31p5kWe_574C_290C;