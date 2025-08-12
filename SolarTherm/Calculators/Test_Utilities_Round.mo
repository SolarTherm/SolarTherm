within SolarTherm.Calculators;

model Test_Utilities_Round "Tests the function SolarTherm.Utilities.Round to see if the correct output is returned"
  Real x(start = -100.0);
  Integer y;
equation
  der(x) = 1.0;
  y = SolarTherm.Utilities.Round(x);
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 200, StartTime = 0, Tolerance = 1.0e-5, Interval = 0.01, maxStepSize = 1, initialStepSize = 1));
end Test_Utilities_Round;