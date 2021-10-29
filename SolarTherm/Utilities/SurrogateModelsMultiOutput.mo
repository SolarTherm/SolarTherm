within SolarTherm.Utilities;

package SurrogateModelsMultiOutput
  class STNeuralNetwork "Session_Props"
    extends ExternalObject;
  
    function constructor
      input String saved_model_dir "Path to pre-trained Neural Network (saved in SavedModel template)";
      output STNeuralNetwork session "Session variable with Graph, Status, SessionOptions, RunOptions objects";
      external "C" session = load_session_multi_output(saved_model_dir) 
                annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"tf.c\"",
                Library = "tensorflow");
    end constructor;
  
    function destructor
     input STNeuralNetwork session;
     external "C" free_surrogate_multi_output(session)
      annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"tf.c\"",
                Library = "tensorflow");
  
    end destructor;
  end STNeuralNetwork;

  function predict
    input STNeuralNetwork session;
    input Real raw_input[:];
    input Integer inputsize;
    input Integer outputsize;
    input Real X_max[:];
    input Real X_min[:];
    input Real Y_max[:];
    input Real Y_min[:];
    input Real timesimul;
    input Integer node;
    output Real out[outputsize];
    external "C" run_surrogate_multi_output(
      session,
      raw_input,
      inputsize,
      outputsize,
      X_max,
      X_min,
      Y_max,
      Y_min,
      timesimul,
      node,
      out
      )
      
    annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
              Include="#include \"tf.c\"",
              Library = "tensorflow");
  end predict;
  
  function predict_single
    input STNeuralNetwork session;
    input Real raw_input[:];
    input Integer inputsize;
    input Integer outIndex;
    input Real X_max[:];
    input Real X_min[:];
    input Real Y_max;
    input Real Y_min;
    output Real out;
    external "C" out =  run_surrogate_single_output(
      session,
      raw_input,
      inputsize,
      outIndex,
      X_max,
      X_min,
      Y_max,
      Y_min
      )
    annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
              Include="#include \"tf.c\"",
              Library = "tensorflow");
  end predict_single;
  
  function predict_wrap
    input STNeuralNetwork session;
    input Real raw_input[:,:];
    input Real X_max[:];
    input Real X_min[:];
    input Real Y_max[:];
    input Real Y_min[:];
    input Integer inputsize;
    input Integer discretisation;
    input Integer outputsize;
    input Real t;
    output Real out[discretisation,outputsize];
    external "C" predict_wrap(
        session,
        raw_input,
        X_max,
        X_min,
        Y_max,
        Y_min,
        inputsize,
        discretisation,
        outputsize,
        t,
        out
      )
    annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
              Include="#include \"tf.c\"",
              Library = "tensorflow");
  end predict_wrap;
 
end SurrogateModelsMultiOutput;