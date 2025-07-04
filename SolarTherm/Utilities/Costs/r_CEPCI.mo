within SolarTherm.Utilities.Costs;

function r_CEPCI
  input Real Year_Numerator "Year Anno Domini";
  input Real Year_Denominator "Year Anno Domini";
  output Real r "CEPCI Composite Index (-)";
protected 
  constant Real Year_data[25] = {2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024};
  constant Real Index_data[25] = {394.1, 394.3, 395.6, 402.0, 444.2, 468.2, 499.6, 525.4, 575.4, 521.9, 550.8, 585.7, 584.6, 567.3, 576.1, 556.8, 541.7, 567.5, 603.1, 607.5, 596.2, 708.8, 816.0, 797.9, 795.1};
algorithm
  r := Modelica.Math.Vectors.interpolate(Year_data,Index_data,Year_Numerator)/Modelica.Math.Vectors.interpolate(Year_data,Index_data,Year_Denominator);
end r_CEPCI;