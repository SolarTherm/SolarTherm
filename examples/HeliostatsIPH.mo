within examples;

model HeliostatsIPH
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import metadata = SolarTherm.Utilities.Metadata_Optics;
  import SolarTherm.Types.Currency;
  extends Modelica.Icons.Example;
  // Weather and location
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab") "Alice Springs";
  parameter nSI.Angle_deg lat = -23.8 "Latitude (+ve North)";
  parameter nSI.Angle_deg lon = 133.9 "Longitude (+ve East)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  parameter String sunshape = "Buie";
  parameter Real csr = 0.02 "circumsolar ratio";
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter SI.Irradiance dni_des = 1000 "DNI at design point";
  // Heliostat field
  parameter String opt_file(fixed = false);
  parameter String casefolder = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/SolsticeResults");
  parameter SI.HeatFlowRate Q_in_rcv = P_net / 0.9 "Receiver net output at design point";
  parameter String field_type = "polar" "polar or surround";
  parameter SI.Area A_helio = H_helio*W_helio "Reflective area of a heliostat m2";
  parameter Real  r_helio_to_recv= 0.7 "heliostat to receiver size ratio";  
  parameter SI.Length W_helio = H_helio "width of heliostat in m";
  parameter SI.Length H_helio = r_helio_to_recv*H_recv "height of heliostat in m";
  parameter SI.Efficiency rho_helio = 0.9 "reflectivity of heliostat max =1";
  parameter SI.Angle slope_error = 2.0e-3 "slope error of the heliostat in mrad";
  parameter SI.Length R1 = 60 "distance between the first row heliostat and the tower";
  parameter Real fb = 0.75 "factor to grow the field layout";
  parameter Real he_av_design = 1 "Helisotats availability";
  parameter Real n_row_oelt = 5 "number of rows of the look up table (simulated days in a year)";
  parameter Real n_col_oelt = 22 "number of columns of the lookup table (simulated hours per day)";
  parameter Real n_rays = 5e6 "number of rays for the optical simulation";
  parameter Real metadata_list[9] = metadata(opt_file);
  parameter Real n_helios = metadata_list[1] "Number of heliostats";
  parameter SI.Efficiency eta_opt_des =  metadata_list[3] "design point optical efficiency";
  parameter SI.Area A_land = metadata_list[9] "Land area";
  parameter SI.Area A_field = A_helio * n_helios "Reflective area of a heliostat m2";
  parameter Real C_des = eta_opt_des* A_field/A_recv "Concentration ratio at design point";
  // Receiver
  parameter String recv_type = "flat" "other options are : flat, cylinder, stl";
  parameter SI.Power P_net = 20e6 "Receiver net output at design point";
  parameter SI.Temperature T_recv = 900+273.15 "receiver working temperature (K)";
  //parameter SI.Length r_recv = 6.3 "radius of receiver aperture";
  parameter SI.Area A_recv = W_recv*H_recv;
  parameter SI.Length W_recv = H_recv "Receiver width (m)";
  parameter SI.Length H_recv = 5 "Receiver height (m)";
  parameter nSI.Angle_deg tilt_recv = 30 "tilt of receiver in degree relative to tower axis";
  parameter SI.Efficiency ab_recv = 1 "Receiver coating absorptance";
  parameter SI.Efficiency em_recv = 1 "Receiver coating emissivity";
  //parameter SI.RadiantPower R_des(fixed= if fixed_field then true else false) "Input power to receiver at design point";
  parameter SI.Temperature rec_T_amb_des = 25+273.15 "Ambient temperature at design point";
  // Tower
  parameter SI.Length H_tower = 80 "Tower height";
  parameter SI.Length R_tower = 0.01 "Tower diameter";
  // Control
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  
  // Costs
  parameter FI.AreaPrice c_field = 130 "Field cost per design aperture area";
  parameter FI.AreaPrice c_site = 0 "Site improvements cost per area";
  //20
  parameter FI.AreaPrice c_land = 2.5 "Land cost per area";
  parameter FI.Money C_field = c_field * A_field "Field cost";
  parameter FI.Money C_site = c_site * A_field "Site improvements cost";
  parameter FI.Money C_tower = 3e6 * exp(0.0113 * H_tower) "Tower cost";
  parameter FI.Money C_recv = 103e6 * (0.3288 * (P_net / 1e6) ^ 1.304 / 1571) ^ 0.7 "Receiver cost";
  parameter FI.Money C_land = c_land * A_land "Field cost";
  parameter FI.Money C_cap_dir_sub = C_field + C_site + C_tower + C_recv "Direct capital cost subtotal";
  // i.e. purchased equipment costs
  parameter FI.Money C_contingency = 0 * C_cap_dir_sub "Contingency costs";
  parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
  parameter FI.Money C_EPC = 0 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
  // SAM 2018 cost data: 0.13
  parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
  parameter Real pri_om_name(unit = "$/W/year") = 0 "Fixed O&M cost per nameplate per year";
  //SAM 2018 cost data: 66
  parameter Real pri_om_prod(unit = "$/J/year") = 0 "Variable O&M cost per production per year";
  //SAM 2018 cost data: 3.5
  parameter FI.MoneyPerYear C_year = pri_om_name * P_net "Fixed O&M cost per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
  parameter Real r = 0.05 "interest rate";
  parameter Integer life = 20 "life time of the system";
  parameter Real CRF = r * (1 + r) ^ life / ((1 + r) ^ life - 1) "capical recovery factor";
  SI.Energy E_net(start = 0, fixed = true, displayUnit = "MW.h");
  SI.Energy E_inc(start = 0, fixed = true, displayUnit = "MW.h");
  SI.Energy E_sol(start = 0, fixed = true, displayUnit = "MW.h");
  Real DNI_counts(start=0);
  SI.HeatFlowRate DNI_q(start = 0);
  SI.HeatFlowRate DNI_average(start=0);
  
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(origin = {-49, 30}, extent = {{-9, -10}, {9, 10}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-58, 40}, {-38, 60}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{90, 50}, {70, 70}}, rotation = 0)));
  //WindSpeed_input
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-10, 40}, {10, 60}}, rotation = 0)));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSolsticeSimpleControl heliostatsField(lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, wea_file = wea_file, sunshape = sunshape, csr = csr, dni_des=dni_des, he_av = he_av_design, A_h = A_helio, Q_in_rcv = Q_in_rcv, Q_design = P_net, H_rcv = H_recv, W_rcv = W_recv, n_H_rcv = 1, n_W_rcv = 1, tilt_rcv = tilt_recv, W_helio = W_helio, H_helio = H_helio, H_tower = H_tower, R_tower = R_tower, R1 = R1, fb = fb, rho_helio = rho_helio, slope_error = slope_error, n_row_oelt = n_row_oelt, n_col_oelt = n_col_oelt, n_rays = n_rays, field_type = field_type, rcv_type = recv_type, psave = casefolder) annotation(
    Placement(visible = true, transformation(origin = {8, 0}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  // Receiver
  SolarTherm.Models.CSP.CRS.Receivers.ReceiverSimpleBlackbody receiver(em = em_recv, ab = ab_recv, A_recv = A_recv, T_recv = T_recv) annotation(
    Placement(visible = true, transformation(origin = {66, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Variables:
  //SI.Power P_elec "Output power of power block";
  //SI.Energy E_elec(start = 0, fixed = true, displayUnit="MW.h") "Generate electricity";
  //FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
initial algorithm
  opt_file := heliostatsField.optical.tablefile;
equation
  der(E_net) = receiver.Q_rcv_net;
  der(E_inc) = heliostatsField.Q_net;
  der(E_sol) = heliostatsField.Q_solar;
  der(DNI_q) = sun.dni;
  der(DNI_counts) = 1;
  DNI_average = DNI_q/DNI_counts;
  
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-37, 50}, {-30, 50}, {-30, 49.8}, {-10.6, 49.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{32, 12}, {28.36, 12}, {28.36, 37}, {56, 37}}, color = {191, 0, 0}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{69, 60}, {59, 60}, {59, 42}, {66, 42}}, color = {0, 0, 127}));
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{0, 40}, {8, 40}, {8, 24}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {92, -28}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 10, fontName = "CMU Serif"), Text(origin = {76, -28}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 10, fontName = "CMU Serif"), Text(origin = {72, 52}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 10, fontName = "CMU Serif"), Rectangle(origin = {67, -2}, lineColor = {136, 138, 133}, fillColor = {136, 138, 133}, fillPattern = FillPattern.Solid, extent = {{-7, 26}, {7, -26}})}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
  <ul>
  <li> Ye Wang (Apr 2023) :<br>Released first version. </li>
  </ul>

  </html>"));
end HeliostatsIPH;
