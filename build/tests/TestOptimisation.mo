
// Optimise with built in Ipopt connection
// setCommandLineOptions("+g=Optimica")
// optimize(AO, numberOfIntervals=50, stopTime=1)

// For Casadi export to XML
// translateModelXML(AO)
// then call deafaulStart.py (haven't found it yet)

// Optimica
// https://www.modelica.org/events/modelica2008/Proceedings/sessions/session1b3.pdf
// See chapter 6 of openmodelica user guide for references to more papers

model A
	Real x1(start=1, fixed=true, min=0, max=1);
	Real x2(start=0, fixed=true, min=0, max=1);
	input Real u(start=0, nominal=1, min=0, max=5);
	//parameter Real u(start=0, free=true, nominal=1, min=0, max=5);
	// Doesn't appear like the Optimica free attribute is supported
equation
	der(x1) = -(u + u^2/2)*x1;
	der(x2) = u*x1;
end A;

optimization AO(objective=-x2)
	extends A;
	//annotation(experiment(StartTime=0.0, StopTime=1.0, Interval=0.02, Tolerance=1e-06));
end AO;
//model B
//	Real x1(start=1, fixed=true, min=0, max=1);
//	Real x2(start=0, fixed=true, min=0, max=1);
//	input Real u(start=0, nominal=1, min=0, max=5);
//	//parameter Real u(start=0, free=true, nominal=1, min=0, max=5);
//	// Doesn't appear like the Optimica free attribute is supported
//equation
//	der(x1) = -(u + u^2/2)*x1;
//	der(x2) = u*x1;
//end B;
//
//optimization BO(objective=-b.x2)
//	B b(u(free=true));
//end BO;
