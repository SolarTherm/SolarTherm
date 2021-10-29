within SolarTherm.Validation.Models;

model TestDynTank
  function predict_states
    input Real hf, hp;
    output Real[2] out;
  algorithm
    out[1] := hf / hp * 120 - 20 + 30;
    out[2] := 120 - 20 + 30;
  end predict_states;

  import SolarTherm.Utilities.SurrogateModelsMultiOutput.*;
  import Modelica.Utilities.Streams.print;
  //********************** Neural network part
  parameter Integer inputdim = 14 "The dimension of input features";
  parameter Integer outputdim = 2 "Output dimension = dhf/dt and dhp/dt";
  //1st let's initialise the tensorflow session
  parameter String saved_model_dir = "/home/philgun/Documents/coolstuff/coolstuff/ML/script/script/simulation_tank/dyn_tank_3";
  STNeuralNetwork session = STNeuralNetwork(saved_model_dir);
  //2nd define the UB LB for the features and labels
  parameter Real[inputdim] X_max = {952981.8471024092,
                                    832393.0024895384,
                                    0.39793005,
                                    0.344722380460892,
                                    0.1,
                                    0.1,
                                    0.26,
                                    1.507964473723101,
                                    298.15,
                                    82.84263333625299,
                                    953001.9375,
                                    952975.5164330958,
                                    832393.0021223963,
                                    832393.0023466942
  };
                                    
  parameter Real[inputdim] X_min = {675967.5438306999,
                                    547461.3390216347,
                                    0.39793005,
                                    0.344722380460892,
                                    0.1,
                                    0.1,
                                    0.26,
                                    1.507964473723101,
                                    298.15,
                                    -82.74532718339721,
                                    676409.0915674302,
                                    675967.5438306999,
                                    0.0,
                                    0.0
  };
  parameter Real[outputdim] der_max = {17940950.490535565, 6.568992652329139};
  parameter Real[outputdim] der_min = {-11215511.201107323, -4.717486815787243};
  parameter Integer Nf = 50;
  Real[Nf, inputdim] X_in;
  Real[Nf, outputdim] out "Matrix to store the NN output";
  Real[Nf] hf;
  Real[Nf] hp;
  parameter String mode = "Wrapper";
initial equation
  for i in 1:Nf loop
    hf[i] = 952981.8471024092;
    hp[i] = 832393.0024895384;
  end for;
algorithm
  for i in 1:Nf loop
    X_in[i, 1] := hf[i];
    X_in[i, 2] := hp[i];
    X_in[i, 3] := 806.0956025;
    X_in[i, 4] := 0.3336662292428947;
    X_in[i, 5] := 0.1;
    X_in[i, 6] := 0.1;
    X_in[i, 7] := 0.26;
    X_in[i, 8] := 1.507964473723101;
    X_in[i, 9] := 298.15;
    X_in[i, 10] := 0.0001;
    X_in[i, 11] := 906454.4077013284;
    X_in[i, 12] := 906445.927282494;
    X_in[i, 13] := 833992.125890419;
    X_in[i, 14] := 833991.5427863223;
  end for;
  if mode == "NN" then
    for i in 1:Nf loop
      out[i, 1:end] := predict(session, X_in[i, 1:inputdim], inputdim, outputdim, X_max, X_min, der_max, der_min, time, 1);
    end for;
  elseif mode == "Wrapper" then
    out := predict_wrap(session, X_in, X_max, X_min, der_max, der_min, inputdim, Nf, outputdim, time);
  else
    for i in 1:Nf loop
      out[i, 1:end] := SolarTherm.Utilities.toy_function(hf[i], hp[i]);
    end for;
  end if;
equation
  for i in 1:Nf loop
    der(hf[i]) = out[i, 1];
    der(hp[i]) = out[i, 2];
  end for;
  annotation(
    experiment(StartTime = 0, StopTime = 60, Tolerance = 0.0001, Interval = 1));
end TestDynTank;