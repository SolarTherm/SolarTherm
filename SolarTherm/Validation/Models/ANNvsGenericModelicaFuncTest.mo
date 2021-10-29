within SolarTherm.Validation.Models;

model ANNvsGenericModelicaFuncTest
  function func1
    input Real t;
    output Real y;
    
    algorithm
    y:=3 * t ^ 2 + 2 * t + 3;
  end func1;
  import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
  parameter Integer Nf = 100;
  
  Real[Nf] y(start = fill(10,Nf));
  
  parameter String mode = "ANN2";
  STNeuralNetwork session = STNeuralNetwork("/home/philgun/Documents/coolstuff/coolstuff/ML/script/script/simulation_tank/toymodel");
  parameter Real[1] X_max = {10.0}; 
  parameter Real y_max = 323.0; 
  parameter Real[1] X_min = {0.0}; 
  parameter Real y_min = 3.0; 
  
  Real[Nf] dery;

algorithm
  if mode == "ANN2" then
      for i in 1:Nf loop
        dery[i] := predict(session,{time},1,X_max,X_min,y_max,y_min);
      end for;
  else
      for i in 1:Nf loop
        dery[i] := 0;
      end for;
  end if;
equation
  if mode == "PolynomialC" then
    for i in 1:Nf loop
      der(y[i]) = toy(time);
    end for;
  elseif mode == "ANN" then
    for i in 1:Nf loop
      der(y[i]) = predict(session,{time},1,X_max,X_min,y_max,y_min);
    end for;
  elseif mode == "ANN2" then
    for i in 1:Nf loop
      der(y[i]) = dery[i];
    end for;
  else
    for i in 1:Nf loop
      der(y[i]) = func1(time);
    end for;
  end if;
  annotation(
    experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-06, Interval = 0.05));
end ANNvsGenericModelicaFuncTest;