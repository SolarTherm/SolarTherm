within SolarTherm.Media.SolidParticles.Fe_utilities;
function cp_T "Specific heat capacity of solid Fe as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
protected
	constant Modelica.SIunits.Temperature T_data[128] = {298.15, 300.00, 310.00, 320.00, 330.00, 340.00, 350.00, 360.00, 370.00, 380.00, 390.00, 400.00, 410.00, 420.00, 430.00, 440.00, 450.00, 460.00, 470.00, 480.00, 490.00, 500.00, 510.00, 520.00, 530.00, 540.00, 550.00, 560.00, 570.00, 580.00, 590.00, 600.00, 610.00, 620.00, 630.00, 640.00, 650.00, 660.00, 670.00, 680.00, 690.00, 700.00, 710.00, 720.00, 730.00, 740.00, 750.00, 760.00, 770.00, 780.00, 790.00, 800.00, 810.00, 820.00, 830.00, 840.00, 850.00, 860.00, 870.00, 880.00, 890.00, 900.00, 910.00, 920.00, 930.00, 940.00, 950.00, 960.00, 970.00, 980.00, 990.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1042.00, 1050.00, 1060.00, 1070.00, 1080.00, 1090.00, 1100.00, 1110.00, 1120.00, 1130.00, 1140.00, 1150.00, 1160.00, 1170.00, 1180.00, 1190.00, 1200.00, 1210.00, 1220.00, 1230.00, 1240.00, 1250.00, 1260.00, 1270.00, 1280.00, 1290.00, 1300.00, 1310.00, 1320.00, 1330.00, 1340.00, 1350.00, 1360.00, 1370.00, 1380.00, 1390.00, 1400.00, 1410.00, 1420.00, 1430.00, 1440.00, 1450.00, 1460.00, 1470.00, 1480.00, 1490.00, 1500.00, 1510.00, 1520.00, 1530.00, 1540.00, 1550.00};
	constant Modelica.SIunits.SpecificHeatCapacity cp_data[128] = {449.41, 450.17, 454.25, 458.32, 462.38, 466.42, 470.46, 474.50, 478.53, 482.56, 486.59, 490.63, 494.67, 498.71, 502.77, 506.83, 510.90, 514.98, 519.08, 523.19, 527.32, 531.46, 535.62, 539.80, 544.00, 548.22, 552.46, 556.73, 561.02, 565.34, 569.68, 574.05, 578.46, 582.89, 587.35, 591.85, 596.38, 600.95, 605.55, 610.18, 614.86, 619.58, 562.93, 532.61, 521.53, 525.27, 539.97, 562.32, 589.47, 619.01, 648.97, 677.74, 704.07, 727.04, 746.02, 760.68, 770.95, 776.99, 779.21, 778.21, 774.81, 770.00, 764.94, 760.96, 759.55, 762.31, 771.01, 787.53, 813.85, 852.09, 904.45, 973.23, 1060.83, 1169.74, 1302.51, 1461.79, 1497.06, 1399.44, 1278.97, 1162.01, 1048.42, 938.09, 830.89, 816.66, 803.63, 791.57, 780.42, 770.14, 760.67, 751.98, 744.02, 736.76, 730.14, 724.15, 718.73, 713.86, 709.51, 705.65, 702.24, 699.26, 696.69, 694.50, 692.67, 691.17, 689.98, 689.09, 688.46, 688.10, 687.97, 688.06, 688.35, 688.83, 689.49, 690.31, 691.28, 692.39, 693.62, 694.96, 696.41, 697.96, 699.58, 701.28, 703.05, 704.88, 706.76, 708.69, 710.66, 712.66};

algorithm
	cp := Utilities.Interpolation.Interpolate1D(T_data,cp_data,T);
end cp_T;