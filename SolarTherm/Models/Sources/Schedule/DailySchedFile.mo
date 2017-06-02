within SolarTherm.Models.Sources.Schedule;
block DailySchedFile "Loaded from table in file"
	extends DailySched;
	parameter String file "File name";
	parameter String name "Table name";

	Modelica.Blocks.Tables.CombiTable1Ds table(
		verboseRead=false,
		tableOnFile=true,
		fileName=file,
		tableName=name,
		smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments);
		//smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative
equation
	connect(t, table.u);
	connect(table.y[1], v);
end DailySchedFile;
