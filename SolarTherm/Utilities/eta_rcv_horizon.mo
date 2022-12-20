within SolarTherm.Utilities;

function eta_rcv_horizon
    import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
    import CN = Modelica.Constants;
    import CV = Modelica.SIunits.Conversions;
    import SI = Modelica.SIunits;
    import nSI = Modelica.SIunits.Conversions.NonSIunits;

    input STNeuralNetwork session "The session of the ANN";
    input Real[:] raw_input;
    input Integer inputsize;
    input Real[:] X_max;
    input Real[:] X_min;
    input Real out_max;
    input Real out_min;
    
    output Real eta "Prediction of the receiver eff";
    


algorithm
    eta := predict(
        session, 
        raw_input, 
        inputsize,
        X_max,
        X_min,
        out_max,
        out_min
    );

end eta_rcv_horizon;