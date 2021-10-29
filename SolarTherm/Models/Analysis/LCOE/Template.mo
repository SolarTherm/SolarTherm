within SolarTherm.Models.Analysis.LCOE;
partial model Template
  input SolarTherm.Types.Money[n] I "Total Investment";
  input SolarTherm.Types.Money M_year "Operations and maintenance expenditures in the year";
  input nSI.Energy_kWh E_year "Electrical energy generated in the year";
  parameter Integer n(min=1);
  output SolarTherm.Types.EnergyPrice_kWh  lcoe
    "Levelized Cost of Energy";
  output SolarTherm.Types.Money IT=sum(I);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Template;
