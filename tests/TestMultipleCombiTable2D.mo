model TestMultipleCombiTable2D
	extends Modelica.Icons.Example;

	parameter String textfile = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/lookup.motab");
	parameter Integer N = 100 "Number of tables";
	parameter String tableNames[N] = {"table2D_" + String(i) for i in 1:N};
	
	Modelica.Blocks.Tables.CombiTable2D table[N](
		each fileName = textfile, 
		each tableOnFile = true, 
		tableName = tableNames)  annotation(
			Placement(visible = true, transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	Modelica.Blocks.Sources.RealExpression u1(y = time) annotation(
	Placement(visible = true, transformation(origin = {-88, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression u2(y = time) annotation(
	Placement(visible = true, transformation(origin = {-88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
	for i in 1:N loop
		connect(u1.y, table[i].u1);
		connect(u2.y, table[i].u2);
	end for;
	
annotation(
	uses(Modelica(version = "3.2.3"), SolarTherm(version = "0.2")));
end TestMultipleCombiTable2D;