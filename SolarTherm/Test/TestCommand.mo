within SolarTherm.Test;
block TestCommand
	function touch
		import Modelica.Utilities.System.command;
		input String str;
		output Integer result;
	algorithm
		//result := 5;
		result := command("touch " + str);
	end touch;

	parameter Integer result(fixed=false);
initial algorithm
	result := touch("TestCommandTouched");
end TestCommand;
