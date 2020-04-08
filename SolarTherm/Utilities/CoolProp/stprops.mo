within SolarTherm.Utilities.CoolProp;
function stprops
	input String outprop;
	input String inprop1;
	input Real inval1;
	input String inprop2;
	input Real inval2;
	input String fluid;
	output Real res;
	external res = propsSI(outprop,inprop1,inval1,inprop2,inval2,fluid)
	annotation(Library="dl",
	Include="#include \"st_ext_coolprop_func.c\"",
	IncludeDirectory="modelica://SolarTherm/Utilities/CoolProp");
end stprops;
