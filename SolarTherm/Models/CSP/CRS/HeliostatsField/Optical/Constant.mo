within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
model Constant "Constant"
  extends OpticalEfficiency;
  parameter SI.Efficiency k=0.6 "Constant average optical efficiency";
equation
  nu=k;
end Constant;
