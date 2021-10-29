within SolarTherm.Utilities;

package SurrogateModelsSingleOutput
  class STNeuralNetwork "Session_Props"
    extends ExternalObject;
  
    function constructor
      input String saved_model_dir "Path to pre-trained Neural Network (saved in SavedModel template)";
      output STNeuralNetwork session "Session variable with Graph, Status, SessionOptions, RunOptions objects";
      external "C" session = load_session_static_ANN(saved_model_dir) 
                annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"st_surrogate.c\"",
                Library = "tensorflow");
    end constructor;
  
    function destructor
     input STNeuralNetwork session;
     external "C" free_surrogate(session)
      annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"st_surrogate.c\"",
                Library = "tensorflow");
  
    end destructor;
  end STNeuralNetwork;

  function predict
    input STNeuralNetwork session;
    input Real raw_input[:];
    input Integer inputsize;
    input Real X_max[:];
    input Real X_min[:];
    input Real Y_max;
    input Real Y_min;
    output Real out;
    external "C" out = run_surrogate(session,raw_input,inputsize,X_max,X_min,Y_max,Y_min)
    annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
              Include="#include \"st_surrogate.c\"",
              Library = "tensorflow");
  end predict;
  
  function toy
    input Real t;
    output Real out;
    external "C" out = toyfunc(t)
    annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
              Include="#include \"st_surrogate.c\""
              );
  end toy;
  
end SurrogateModelsSingleOutput;