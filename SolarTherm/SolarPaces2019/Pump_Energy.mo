within SolarTherm.SolarPaces2019;

partial model Pump_Energy
  extends Icons.PumpModel;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat_a
    annotation (Placement(transformation(extent={{-110,-12},{-90,8}},  rotation=
           0), iconTransformation(extent={{-110,-12},{-90,8}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat_b
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
              100}})),                  Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Pump_Energy;