within SolarTherm.Utilities.ToleranceTest;
function compareReal
	"Compares two Reals, and checks if they are close enough to be considered equal" // Ref: the original function was taken from: .ModelicaCompliance.Util.compareReal
	input Real a;
	input Real b;
	input Real absTol = 1e-10 "Absolute tolerance";
	input Real relTol = 1e-5 "Relative tolerance";
	output Boolean notEqual "true if not equal";
	output Boolean incr "true if the change is incremental";
protected
	Real diff;
algorithm
	diff := abs(b - a);

	if diff < absTol or diff <= (max(abs(b), abs(a)) * relTol) then
		notEqual := false;
	else
		notEqual := true;
	end if;

	if b > a then
		incr := true;
	else
		incr := false;
	end if;
end compareReal;
