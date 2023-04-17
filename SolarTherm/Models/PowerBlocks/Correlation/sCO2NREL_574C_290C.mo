within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL_574C_290C "SCO2 cycle based on regression of NREL PB, Nitrate Salt HTF"
	extends Cycle(T_in_ref = 574.0 + 273.15);
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;
	parameter SI.Temperature T_amb_ref = 35.0 + 273.15 "Design ambient temperature";
    parameter SI.Power P_name = 31.5e3 "Nameplate rating of power block";
    Real t_in "Non-dimensional inlet temperature, called theta_in";
    Real t_amb "Non-dimensional ambient temperature, called theta_amb";
    parameter Real[12] a_array = {a_0,a_1,a_2,a_3,a_4,a_5,a_6,a_7,a_8,a_9,a_10,a_11} "Array of a";
    parameter Real[12] b_array = {b_0,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_10,b_11} "Array of b";
    Real[12] w_array = {1.0,t_amb,load,(t_amb)^2,(t_amb)^3,(load)^2,(t_in*t_amb)^3,(t_amb*load),(t_amb*load)^3,(t_in*load)^2,load/t_in,load/t_amb} "Array of w variables";
    Real[12] x_array = {1.0,t_amb,(t_in)^2,(t_amb)^3,(load)^2,(t_in*t_amb)^3,(t_amb*load),(t_amb*load)^2,(t_in*load),(t_in*load)^3,t_in/t_amb,load/t_amb} "Array of x variables";
    
    //Constants of a refer to regression constants of k_q
    parameter Real a_0 =
            if P_name==31.5e3 then 55.5445
            else if P_name==100e3 then 55.5337
            else if P_name==200e3 then  55.5385
            else if P_name==300e3 then 55.5454
            else 55.533 ;
    parameter Real a_1 = 
            if P_name==31.5e3 then -170.01
            else if P_name==100e3 then -169.975
            else if P_name==200e3 then -169.991
            else if P_name==300e3 then  -170.014
            else  -169.969 ;
    parameter Real a_2 =
            if P_name==31.5e3 then  30.3634
            else if P_name==100e3 then 30.3615
            else if P_name==200e3 then 30.362
            else if P_name==300e3 then 30.3631
            else 30.3695 ;
    parameter Real a_3 = 
            if P_name==31.5e3 then 173.457
            else if P_name==100e3 then 173.419
            else if P_name==200e3 then 173.437
            else if P_name==300e3 then 173.461
            else  173.409;
    parameter Real a_4 = 
            if P_name==31.5e3 then -58.2448
            else if P_name==100e3 then  -58.2319
            else if P_name==200e3 then -58.2379
            else if P_name==300e3 then -58.2463
            else  -58.2263;
    parameter Real a_5 = 
            if P_name==31.5e3 then 3.05989
            else if P_name==100e3 then 3.05979
            else if P_name==200e3 then 3.05958
            else if P_name==300e3 then 3.05986
            else  3.0596;
    parameter Real a_6 = 
            if P_name==31.5e3 then -0.714165
            else if P_name==100e3 then -0.713936
            else if P_name==200e3 then -0.714121
            else if P_name==300e3 then -0.714164
            else  -0.71439 ;
    parameter Real a_7 = 
            if P_name==31.5e3 then -10.6609
            else if P_name==100e3 then  -10.6604
            else if P_name==200e3 then -10.6607
            else if P_name==300e3 then  -10.6608
            else  -10.6645;
    parameter Real a_8 = 
            if P_name==31.5e3 then -0.561919
            else if P_name==100e3 then -0.562047
            else if P_name==200e3 then -0.562018
            else if P_name==300e3 then -0.561911
            else  -0.562029;
    parameter Real a_9 = 
            if P_name==31.5e3 then -2.24643
            else if P_name==100e3 then -2.24597
            else if P_name==200e3 then -2.24582
            else if P_name==300e3 then -2.24641
            else -2.24583 ;
    parameter Real a_10 = 
            if P_name==31.5e3 then -8.22561
            else if P_name==100e3 then -8.22417
            else if P_name==200e3 then -8.22426
            else if P_name==300e3 then -8.22558
            else -8.22486 ;
    parameter Real a_11 = 
            if P_name==31.5e3 then -10.7992
            else if P_name==100e3 then -10.7995
            else if P_name==200e3 then -10.7995
            else if P_name==300e3 then -10.799
            else -10.8026 ;
    
    //parameters of b refer to regression parameters of k_w
    parameter Real b_0 = 
            if P_name==31.5e3 then -12.7053
            else if P_name==100e3 then -12.7118
            else if P_name==200e3 then -12.7118
            else if P_name==300e3 then -12.708
            else  -12.7033;
    parameter Real b_1 = 
            if P_name==31.5e3 then 14.5183
            else if P_name==100e3 then 14.5255
            else if P_name==200e3 then 14.5255
            else if P_name==300e3 then 14.5213
            else 14.5159 ;
    parameter Real b_2 =
            if P_name==31.5e3 then  -2.68666
            else if P_name==100e3 then -2.689
            else if P_name==200e3 then -2.68897
            else if P_name==300e3 then -2.68765
            else  -2.68593;
    parameter Real b_3 = 
            if P_name==31.5e3 then -4.39112
            else if P_name==100e3 then -4.39282
            else if P_name==200e3 then -4.39287
            else if P_name==300e3 then -4.3918
            else -4.39013 ;
    parameter Real b_4 = 
            if P_name==31.5e3 then -1.2235
            else if P_name==100e3 then -1.22351
            else if P_name==200e3 then  -1.2235
            else if P_name==300e3 then -1.22348
            else  -1.22356;
    parameter Real b_5 = 
            if P_name==31.5e3 then 0.844929
            else if P_name==100e3 then 0.845351
            else if P_name==200e3 then 0.845379
            else if P_name==300e3 then 0.845088
            else 0.844519 ;
    parameter Real b_6 = 
            if P_name==31.5e3 then 1.28102
            else if P_name==100e3 then 1.28021
            else if P_name==200e3 then 1.28025
            else if P_name==300e3 then 1.28068
            else  1.28063;
    parameter Real b_7 = 
            if P_name==31.5e3 then 0.376981
            else if P_name==100e3 then 0.377219
            else if P_name==200e3 then 0.377222
            else if P_name==300e3 then 0.377051
            else  0.377021;
    parameter Real b_8 =
            if P_name==31.5e3 then  -2.39619
            else if P_name==100e3 then -2.3956
            else if P_name==200e3 then -2.39567
            else if P_name==300e3 then -2.39586
            else  -2.39568;
    parameter Real b_9 = 
            if P_name==31.5e3 then 0.324071
            else if P_name==100e3 then 0.323989
            else if P_name==200e3 then 0.323985
            else if P_name==300e3 then 0.32404
            else  0.324078 ;
    parameter Real b_10 =
            if P_name==31.5e3 then  4.47912
            else if P_name==100e3 then 4.48212
            else if P_name==200e3 then 4.4821
            else if P_name==300e3 then 4.48036
            else 4.47821 ;
    parameter Real b_11 = 
            if P_name==31.5e3 then 1.88415
            else if P_name==100e3 then 1.88416
            else if P_name==200e3 then 1.88419
            else if P_name==300e3 then 1.88408
            else 1.88405 ;

    parameter Real eta_q_des = sum(a_array) "Design HX efficiency";
    parameter Real eta_w_des = sum(b_array) "Design Cycle efficiency";
    parameter Real eta_gross_des = eta_q_des*eta_w_des "Design gross efficiency, product of eta_q and eta_w";
equation
    //Note that k_q and k_w get passed as eta_Q and eta_gross
    t_in = T_in/T_in_ref;
    t_amb = T_amb/T_amb_ref;
    k_q = sum(a_array.*w_array);
    k_w = sum(b_array.*x_array);
    
end sCO2NREL_574C_290C;
