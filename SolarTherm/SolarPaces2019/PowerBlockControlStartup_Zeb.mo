within SolarTherm.SolarPaces2019;

model PowerBlockControlStartup_Zeb
  extends SolarTherm.Icons.Control;
  parameter Real T_on=1048 "Temp of start discharge"; //90
  parameter Real T_off=1023 "Temp of stop discharge"; //10
  parameter Real t_startup=20.0*60.0 "Startup duration in seconds where power block consumes heat at a fraction of design but has no electrical gross output";
  //parameter SI.Time period = 1.0*3600.0;
  Modelica.Blocks.Interfaces.RealInput T_HTF annotation (Placement(visible = true, transformation(extent = {{-128, -70}, {-88, -30}}, rotation = 0), iconTransformation(extent = {{-128, -78}, {-88, -38}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput load(start=0.0) "Is the power block on?" annotation (Placement(visible = true, transformation(extent = {{92, -20}, {132, 20}}, rotation = 0), iconTransformation(extent = {{92, 40}, {132, 80}}, rotation = 0))) ;
  Modelica.Blocks.Interfaces.BooleanOutput startup(start=false) "Is the power block starting up?" annotation (Placement(visible = true, transformation(extent = {{92, -40}, {132, 0}}, rotation = 0), iconTransformation(extent = {{92, -80}, {132, -40}}, rotation = 0)));
  //SI.Time next_startup(start=0.0);
protected
  Real beginning(start=-1) "beginning time of startup";
  Real ending(start=-1) "ending time of startup";

algorithm
  when T_HTF > T_on then
	//if time > next_startup then
    	load := 1.0;
		startup := true;
		beginning := time;
		ending := beginning + t_startup;
		//next_startup := time + period;
	//end if;
  end when;
  when time > ending then
		startup := false;
  end when;
  //when time > next_startup then
	//if T_HTF > T_on then
    	//load := 1.0;
		//next_startup := time + period;
	//end if;
  //end when;

  when T_HTF < T_off then
    load := 0.0;
	startup := false;
  end when;
end PowerBlockControlStartup_Zeb;