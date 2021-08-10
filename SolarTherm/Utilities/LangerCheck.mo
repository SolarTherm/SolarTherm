within SolarTherm.Utilities;
function LangerCheck
	extends Modelica.Icons.Function;
	input Real azi;
	input Real ele;
	input Real points[:,3];
	input Integer simplices[:,3];
	input Integer ntriangles;
	output Integer triangle[3];
	external "C" langer_check(azi, ele, points, simplices, ntriangles, triangle);
	annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",Include="#include \"st_langer_check.c\"",Library = {"gsl"});
end LangerCheck;