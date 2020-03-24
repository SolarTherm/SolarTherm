within SolarTherm.Media.CO2;

package CO2_utilities
  extends Modelica.Icons.UtilitiesPackage;

  function cp_p_h "Specific heat capacity of CO2 as a function of pressure and enthalpy. Performs interpolation with the tableID declared in the Medium declaration."
    extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
    output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
    external"C" cp =  ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p)
        annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end cp_p_h;

  function eta_p_h "Dynamic viscosity of molten salt as a function of temperature"
  extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
  
    external "C" eta = ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end eta_p_h;

  function helmholtz_p_h "Specific Helmholtz energy of CO2"
  extends Modelica.Icons.Function;
  input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.SpecificHelmholtzFreeEnergy helmholtz "Specific Helmholtz energy";
  
    external "C" helmholtz = ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end helmholtz_p_h;

  function h_p_s "Specific enthalpy of CO2 as a function of Specific entropy and pressure"
  import SolarTherm.Media.CO2.CO2_utilities.*;
    extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEntropy s "Specific entropy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
  
    external "C" h = ModelicaStandardTables_CombiTable2D_getValue(tableID, s, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end h_p_s;

  function h_p_T "Specific enthalpy of molten salt as a function of temperature"
  extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.Temperature T "Temperature";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
  
    external "C" h = ModelicaStandardTables_CombiTable2D_getValue(tableID, T, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end h_p_T;

  function lambda_p_h "Thermal conductivity of molten salt as a function of temperature"
  extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";
  
    external "C" lambda = ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end lambda_p_h;


  function rho_p_h "Density of molten salt as a function of temperature"
  extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.Density rho "Density";
  
    external "C" rho = ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end rho_p_h;

  function s_p_h "Specific entropy of molten salt as a function of pressure and enthalpy"
  extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.SpecificEntropy s  "Specific entropy";
  
    external "C" s = ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end s_p_h;

  function T_p_h "Temperature of molten salt as a function of pressure and specific enthalpy"
  extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.Temperature T "Temperature";
  
    external "C" T = ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end T_p_h;

  function u_p_h
  extends Modelica.Icons.Function;
    input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Modelica.Blocks.Types.ExternalCombiTable2D tableID "Table with the values to interpolate";
    output Modelica.SIunits.SpecificEnergy u "Specific energy";
  
  external "C" u = ModelicaStandardTables_CombiTable2D_getValue(tableID, h, p) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  
  end u_p_h;
  
   function T_out_turb
    extends Modelica.Icons.Function;
    input SI.ThermodynamicTemperature T_high;
    input SI.AbsolutePressure p_high;
    input SI.AbsolutePressure p_low;
    input SI.Efficiency eta_turb;
    input Modelica.Blocks.Types.ExternalCombiTable2D tableIDh_p_T;
    input Modelica.Blocks.Types.ExternalCombiTable2D tableIDs_p_h;
    input Modelica.Blocks.Types.ExternalCombiTable2D tableIDT_p_h;
    input Modelica.Blocks.Types.ExternalCombiTable2D tableIDh_p_s;
    output SI.ThermodynamicTemperature T_out;

    SI.SpecificEnthalpy h_in, h_isen;
    SI.SpecificEntropy s_in;
    algorithm 
    h_in := h_p_T(p_high, T_high, tableIDh_p_T);
    
    s_in := s_p_h( p_high, h_in,tableIDs_p_h);

    h_isen:= h_p_s(p_low,s_in,tableIDh_p_s) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
    
    T_out:= T_p_h( p_low, h_in+(h_isen-h_in)*eta_turb, tableIDT_p_h) annotation(
      Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
  end T_out_turb;

function T_p_h_new "Temperature of molten salt as a function of pressure and specific enthalpy"
extends Modelica.Icons.Function;
	input String ppath;
	input String pname;
	input String pfunc;
    input Integer argc;
    input Real var[:];
    output Real T "Temperature";
    external T =CO2PropertiesFunc(ppath, pname, pfunc, argc, var)
	annotation(Library="python2.7",
		IncludeDirectory="modelica://SolarTherm/Resources/Include",
		Include="#include \"RunPyFunc.c\""
		);
  end T_p_h_new;

  function stprops
  extends Modelica.Icons.Function;
  	input String outprop;
  	input String inprop1;
  	input Real inval1;
  	input String inprop2;
  	input Real inval2;
  	input String fluid;
  	output Real res;
  	external res = propsSI(outprop,inprop1,inval1,inprop2,inval2,fluid)
  	annotation(Library="dl",
  	Include="#include \"st_ext_coolprop_func.c\"",
  	IncludeDirectory="modelica://SolarTherm/Resources/CoolProp2Modelica");
  end stprops;
  annotation();
end CO2_utilities;