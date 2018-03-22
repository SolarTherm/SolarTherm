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
	annotation(experiment(StartTime=0.0, StopTime=1.0, Interval=0.1, Tolerance=1e-06));
end TestCommand;
