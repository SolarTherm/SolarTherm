within SolarTherm.Media.SolidParticles.Fe3O4_utilities;
function T_h "Temperature of Fe3O4 as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy (J/kg)";
	output Modelica.SIunits.Temperature T "Temperature (K)";
protected
	constant Modelica.SIunits.Temperature T_data[129] = {298.15, 300.00, 310.00, 320.00, 330.00, 340.00, 350.00, 360.00, 370.00, 380.00, 390.00, 400.00, 410.00, 420.00, 430.00, 440.00, 450.00, 460.00, 470.00, 480.00, 490.00, 500.00, 510.00, 520.00, 530.00, 540.00, 550.00, 560.00, 570.00, 580.00, 590.00, 600.00, 610.00, 620.00, 630.00, 640.00, 650.00, 660.00, 670.00, 680.00, 690.00, 700.00, 710.00, 720.00, 730.00, 740.00, 750.00, 760.00, 770.00, 780.00, 790.00, 800.00, 810.00, 820.00, 830.00, 840.00, 850.00, 860.00, 870.00, 880.00, 890.00, 900.00, 910.00, 920.00, 930.00, 940.00, 950.00, 960.00, 970.00, 980.00, 990.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1050.00, 1060.00, 1070.00, 1080.00, 1090.00, 1100.00, 1110.00, 1120.00, 1130.00, 1140.00, 1150.00, 1160.00, 1170.00, 1180.00, 1190.00, 1200.00, 1210.00, 1220.00, 1230.00, 1240.00, 1250.00, 1260.00, 1270.00, 1280.00, 1290.00, 1300.00, 1310.00, 1320.00, 1330.00, 1340.00, 1350.00, 1360.00, 1370.00, 1380.00, 1390.00, 1400.00, 1410.00, 1420.00, 1430.00, 1440.00, 1450.00, 1460.00, 1470.00, 1480.00, 1490.00, 1500.00, 1510.00, 1520.00, 1530.00, 1540.00, 1550.00, 1560.00, 1570.00};
	constant Modelica.SIunits.SpecificEnthalpy h_data[129] = {0.00, 1219.97, 7872.35, 14621.15, 21464.57, 28400.90, 35428.52, 42545.88, 49751.51, 57044.00, 64422.03, 71884.31, 79429.65, 87056.90, 94764.95, 102552.79, 110419.42, 118363.94, 126385.47, 134483.23, 142656.46, 150904.50, 159226.75, 167622.68, 176091.85, 184633.92, 193248.63, 201935.85, 210695.58, 219527.97, 228433.34, 237412.18, 246465.25, 255593.52, 264798.29, 274081.19, 283444.28, 292890.06, 302421.60, 312042.62, 321757.57, 331571.79, 341491.67, 351524.77, 361680.09, 371968.26, 382401.89, 392995.83, 403767.61, 414737.88, 425930.99, 437375.56, 449105.27, 461159.73, 473585.51, 486437.31, 499720.43, 511834.26, 522686.27, 532833.84, 542583.39, 552103.47, 561486.92, 570785.06, 580026.37, 589226.80, 598395.40, 607537.43, 616656.06, 625753.28, 634830.46, 643888.57, 652928.41, 661950.62, 670955.78, 679944.43, 688917.04, 697874.10, 706816.02, 715743.25, 724656.19, 733555.23, 742440.74, 751313.08, 760172.62, 769019.67, 777854.58, 786677.65, 795489.19, 804289.49, 813078.83, 821857.49, 830625.73, 839383.81, 848131.98, 856870.47, 865599.52, 874319.35, 883030.19, 891732.24, 900425.70, 909110.78, 917787.67, 926456.54, 935117.60, 943770.99, 952416.91, 961055.51, 969686.96, 978311.40, 986929.00, 995539.89, 1004144.22, 1012742.13, 1021333.76, 1029919.23, 1038498.66, 1047072.20, 1055639.95, 1064202.03, 1072758.56, 1081309.65, 1089855.41, 1098395.94, 1106931.34, 1115461.71, 1123987.16, 1132507.77, 1141023.64};

algorithm
	T := Utilities.Interpolation.Interpolate1D(h_data,T_data,h);
end T_h;