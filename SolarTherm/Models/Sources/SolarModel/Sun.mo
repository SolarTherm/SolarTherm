within SolarTherm.Models.Sources.SolarModel;
model Sun "Sun model"
  extends Interfaces.Models.Sun;
  parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location and year"));
  parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location and year"));
  parameter nSI.Time_hour t_zone=9.5 "Local time zone (UCT=0)" annotation(Dialog(group="System location and year"));
  parameter Integer year=1996 "Year" annotation(Dialog(group="System location and year"));
  replaceable function solarPosition =
      SolarTherm.Models.Sources.SolarFunctions.DuffieBeckman_Algorithm
      constrainedby SolarTherm.Models.Sources.SolarFunctions.solarPosition "Solar position" annotation (Dialog(group="Solar position",__Dymola_label="Algorithm"),choicesAllMatching=true);
  SI.Angle dec "Solar declination angle";
  SI.Angle hra "Solar hour angle";
  Modelica.Blocks.Interfaces.RealInput dni
    annotation (Placement(transformation(extent={{-126,-22},{-86,18}})));
equation
  (dec,hra) =solarPosition(
    time,
    lon,
    lat,
    t_zone,
    year);

  solar.dec=dec;
  solar.hra=hra;
  solar.dni=dni;
  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    experiment(StopTime=100000, Interval=60),
    __Dymola_experimentSetupOutput);
end Sun;
