within SolarTherm.Validation.Models;

model RobertsonStiffEq  
  function polyfit
      //This functions are generated based on data.
      
      input Real y1,y2,y3;
      output Real[3]der_state;
      
      algorithm
      der_state[1] := 0.10045040220547555 -0.14045040220601063*y1 -0.10593265098976143*y2 -0.10045040220549584*y3 + 0.0054824538205883455*(y2*y1) + 2.6978558276269382e-12*(y3*y1) + 10000.005481828559*(y3*y2);
      
      der_state[2] := 0.05313521463241619 -0.013135214624306862*y1 -29999999.97700659*y2 -0.05313521463203297*y3 + 29999999.923868384*(y2*y1) -3.4870592524605115e-11*(y3*y1) + 29989999.923876528*(y3*y2);
      
      der_state[3] := 0.050835662777530405 -0.05083566323213523*y1 + 29999995.88410168*y2 -0.050835662788262154*y3 -29999995.93478567*(y2*y1) + 1.870247318125351e-09*(y3*y1) -29999995.935213607*(y3*y2);
  
  end polyfit;
  
  parameter Real alpha = 0.04;
  parameter Real beta = 1e4;
  parameter Real gamma = 3e7;
  
  Real y1(start = 1);
  Real y2(start = 0);
  Real y3(start = 0);
  
  Real[3] der_state;
  parameter Boolean surr = true;  
algorithm
if surr == true then 
  der_state := polyfit(y1,y2,y3);
else
  der_state := {
          -alpha*y1 + 1e4*y2 * y3, 
          alpha * y1 - beta * y2 * y3 - gamma * y2 ^ 2, 
          gamma * y2 ^ 2
  };
end if;
equation
  der(y1) = der_state[1];
  der(y2) = der_state[2];
  der(y3) = der_state[3];
  //der(y1) = dery1;
  //der(y2) = dery2;
  //der(y3) = dery3;
  annotation(
    experiment(StartTime = 0, StopTime = 88000, Tolerance = 1e-06, Interval = 5));
end RobertsonStiffEq;