within SolarTherm.Models.Sources.DataTable;
model ForecastTable
	extends Icons.Data;

	parameter String file "File containing the reactor forcast data";
	parameter Real startTime = 0;
	output SI.Energy E_fcst "daily energy output of the reactor";

protected
	Modelica.Blocks.Sources.CombiTimeTable table(
		tableOnFile=true,
		tableName="data",
		fileName=file,
		columns={2},
		smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		startTime=startTime);

equation
	E_fcst=table.y[1];

end ForecastTable;
