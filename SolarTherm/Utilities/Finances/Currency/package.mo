within SolarTherm.Utilities.Finances;

package Currency

  final constant Real year_data[19] = {2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024};
  
  final constant Real AUD_to_Euro_data[19] = {0.6069, 0.6200, 0.5860, 0.5790, 0.7159, 0.7696, 0.8362, 0.7602, 0.7108, 0.7088, 0.7039, 0.7133, 0.6647, 0.6505, 0.6045, 0.6351, 0.6600, 0.6144, 0.6101};
  
  final constant Real AUD_to_USD_data[19] = {0.7574, 0.8448, 0.8632, 0.8097, 0.9467, 1.0624, 1.0668, 0.9987, 0.9361, 0.7855, 0.7780, 0.8027, 0.7836, 0.7285, 0.6906, 0.7514, 0.6947, 0.6644, 0.6603};
  
  final constant Real Euro_to_AUD_data[19] = {1.6477, 1.6129, 1.7065, 1.7271, 1.3968, 1.2994, 1.1959, 1.3154, 1.4069, 1.4108, 1.4207, 1.4019, 1.5044, 1.5373, 1.6543, 1.5746, 1.5152, 1.6276, 1.6391};
  
  final constant Real USD_to_AUD_data[19] = {1.3203, 1.1837, 1.1585, 1.2350, 1.0563, 0.9413, 0.9374, 1.0013, 1.0683, 1.2731, 1.2853, 1.2458, 1.2762, 1.3727, 1.4480, 1.3308, 1.4395, 1.5051, 1.5145};
  
  final constant Real Euro_to_USD_data[19] = {1.2480, 1.3626, 1.4730, 1.3984, 1.3224, 1.3805, 1.2758, 1.3137, 1.3170, 1.1082, 1.1053, 1.1253, 1.1789, 1.1199, 1.1424, 1.1831, 1.0526, 1.0814, 1.0823};
  
  final constant Real USD_to_Euro_data[19] = {0.8013, 0.7339, 0.6789, 0.7151, 0.7562, 0.7244, 0.7838, 0.7612, 0.7593, 0.9024, 0.9048, 0.8886, 0.8483, 0.8929, 0.8753, 0.8452, 0.9501, 0.9247, 0.9240};

  function AUD_to_Euro_rate "Conversion rate of AUD to Euros"
    input Real year "Year (Anno Domini)";
    output Real rate;
  algorithm
    rate := Modelica.Math.Vectors.interpolate(year_data,AUD_to_Euro_data,floor(year+0.499));
  end AUD_to_Euro_rate;

  function AUD_to_USD_rate "Conversion rate of AUD to USD"
    input Real year "Year (Anno Domini)";
    output Real rate;
  algorithm
    rate := Modelica.Math.Vectors.interpolate(year_data,AUD_to_USD_data,floor(year+0.499));
  end AUD_to_USD_rate;
  
  function Euro_to_AUD_rate "Conversion rate of Euro to AUD"
    input Real year "Year (Anno Domini)";
    output Real rate;
  algorithm
    rate := Modelica.Math.Vectors.interpolate(year_data,Euro_to_AUD_data,floor(year+0.499));
  end Euro_to_AUD_rate;
  
  function USD_to_AUD_rate "Conversion rate of USD to AUD"
    input Real year "Year (Anno Domini)";
    output Real rate;
  algorithm
    rate := Modelica.Math.Vectors.interpolate(year_data,USD_to_AUD_data,floor(year+0.499));
  end USD_to_AUD_rate;
  
  function Euro_to_USD_rate "Conversion rate of Euro to USD"
    input Real year "Year (Anno Domini)";
    output Real rate;
  algorithm
    rate := Modelica.Math.Vectors.interpolate(year_data,Euro_to_USD_data,floor(year+0.499));
  end Euro_to_USD_rate;
  
  function USD_to_Euro_rate "Conversion rate of USD to Euro"
    input Real year "Year (Anno Domini)";
    output Real rate;
  algorithm
    rate := Modelica.Math.Vectors.interpolate(year_data,USD_to_Euro_data,floor(year+0.499));
  end USD_to_Euro_rate;
  

  annotation(
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Text(origin = {-2, 8}, extent = {{-100, 100}, {100, -100}}, textString = "$")}));
end Currency;