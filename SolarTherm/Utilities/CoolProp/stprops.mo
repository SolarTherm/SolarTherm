within SolarTherm.Utilities.CoolProp;
function stprops
	input String outprop;
	input String inprop1;
	input Real inval1;
	input String inprop2;
	input Real inval2;
	input String fluid;
	output Real res;
	external "C" res = PropsSI(outprop,inprop1,inval1,inprop2,inval2,fluid)
	annotation(Library={"CoolProp"});
end stprops;
