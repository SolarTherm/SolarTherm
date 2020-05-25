within SolarTherm.SolarPaces2019;

model Sodium_NaCl_Zebedee
	extends Interfaces.Models.StorageHeat;

//PCM storage model with one heat input and one heat output. Properties of PCM (NaCl) are obtained via lookup table
	import Tables = Modelica.Blocks.Tables;
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	parameter String table_file "path of the table file";
	parameter String solubility_file "path of the solubility data file";
	parameter String convection_file "path of the convection properties data";

//Start of the function section
//Initializing control volume elements within PCM
  function Thickness
    //Generates the initial thicknesses up uneven mesh elements to determine starting mass of each element
    input Real r;
    //common ratio, growth parameter of the uneven mesh
    input Real L;
    input Integer N;
    output Real dz[N];
  protected
    Integer n;
    Real a;
  algorithm
    n := div(N,2);
    if rem(N,2)==0 then //even number
      a := (L/2)*((1.0-r)/(1.0-r^n));
      for i in 1:N loop
        if i <= n then
          dz[i] := a*(r^i);
        else
          dz[i] := a*(r^(N-i+1));
        end if;
      end for;
    else //odd number
      a := (L/2.0)/(((1.0-r^n)/(1.0-r))+(r^(n+1.0)/2.0));
      for i in 1:N loop
        if i <= n+1 then
          dz[i] := a*(r^i);
        else
          dz[i] := a*(r^(N-i+1));
        end if;
      end for;
    end if;
  end Thickness;

function Mass //Generates the initial masses of each mesh element
    input Real M; //Total mass of PCM
    input Real dz[N]; //array of thicknesses
    input Integer N; //number of mesh elements
    output Real m[N]; //array of masses of each element
algorithm
    for i in 1:N loop
        m[i] := M*(dz[i]/sum(dz));
    end for;
end Mass;

function Location //Generates the initial location of each mesh element
    input Real dz[N]; //Array of thicknesses of PCM with length L
    input Real L; //Starting length of PCM
    input Integer N;
    output Real z[N]; //Array of element centroids
algorithm
    z[1] := 0.5*dz[1]-L;
    for i in 2:N loop
        z[i] := sum(dz[1:i-1])+0.5*dz[i]-L;
    end for;
end Location;


function Q_transferbottom //Heat conducted from the bottom of the tray which has neglidgible resistance
	input Real T_HTF;
    input Real T_PCM;
    input Real A; // Cross Sectional Area
    input Real dz_PCM; //Thickness of bottom PCM element
    input Real k_PCM; //Thermal conductivity pf bottom PCM element
	input Real k_gas;
	input Real C_convection;
	input Real D_tray;
    output Real Q; //RAte of heat transfer (J/s)
protected
    Real R_PCM; //Thermal resistivity componennt of half the PCM element's top node
	Real h_conv;
	Real R_total;
algorithm
    R_PCM := 0.5*dz_PCM/k_PCM;
	if T_HTF - T_PCM > 0.0 then //condensation heat transfer
		h_conv := 0.0;
		R_total := R_PCM;
		Q := A*(T_HTF-T_PCM)/R_total;
	else //convection heat transfer
		h_conv := 2.08*(k_gas/D_tray)*((C_convection*abs(T_PCM-T_HTF)*(D_tray^3.0))^0.2);
		R_total := R_PCM + 1.0/h_conv;
		Q := A*(T_HTF-T_PCM)/R_total;
	end if;
end Q_transferbottom;

function Q_transfertop //Heat conducted from the bottom of the tray which has neglidgible resistance
	input Real T_HTF;
    input Real T_PCM;
    input Real A; // Cross Sectional Area
    input Real dz_PCM; //Thickness of bottom PCM element
    input Real k_PCM; //Thermal conductivity pf bottom PCM element
    output Real Q; //RAte of heat transfer (J/s)
protected
    Real R_PCM; //Thermal resistivity componennt of half the PCM element's top node
algorithm
    R_PCM :=  0.5*dz_PCM/k_PCM;
    Q := A*(T_HTF-T_PCM)/R_PCM;
end Q_transfertop;

//Sodium HTF properties
function Hfg_Na //Enthalpy of vaporization of Sodium
    input Real T_Na;
    output Real h_fg;
algorithm
    h_fg := (393.37*(1.0-(T_Na/2503.7))+4398.6*((1.0-(T_Na/2503.7))^0.29302))*1.0E3;
end Hfg_Na;

function Rho_Nal //Density of liquid sodium
    input Real T;
    output Real rho;
algorithm
    rho := 219 + 275.32*(1-(T/2503.7)) + 511.58*((1-(T/2503.7))^0.5); //kg/m^3
end Rho_Nal;

function H_Na //Returns specific enthalpies (J/kg) for sodium liquid and gas
    input Real T;
    output Real h_liq;
    output Real h_gas;
protected
    Real h_avg; //above 2000K the average specific enthalpy of liq and gas are used. They are calculated based on half vaporization enthalpy above and below the average.
algorithm
    h_avg := (2128.4 + 0.86496*T)*1.0E3;  //(J/kg)
    if T < 2000.0 then //below 2000K
        h_liq := ((-365.77+1.6582*T-(4.2395E-4*(T^2))+(1.4847E-7*(T^3))+(2292.6/T))*1000.0); //review incompressible
        h_gas := h_liq + Hfg_Na(T);
    else //above 2000K use average plus/minus half vaporization enthaply
        h_liq := h_avg - 0.5*Hfg_Na(T);
        h_gas := h_avg + 0.5*Hfg_Na(T);
  end if;
end H_Na;

function VLiq_Na //Returns specific volumes (m3/kg) of sodium liquid and gas
    input Real T;
    output Real v_liq;
protected
    Real v_gas;
    Real gamma;
algorithm
    gamma := 1.0E6*((12633.73/(T^2.0))-(0.4672/T))*exp(11.9463-(12633.73/T)-0.4672*log(T)); //properties of sodium based on temperature
    v_liq := 1.0/(219.0 + 275.32*(1.0-(T/2503.7)) + 511.58*((1.0-(T/2503.7))^0.5));
    v_gas := (Hfg_Na(T)/(T*gamma))+v_liq;
end VLiq_Na;

function VGas_Na //Returns specific volumes (m3/kg) of sodium liquid and gas
    input Real T;
    output Real v_gas;
protected
    Real v_liq;
    Real gamma;
algorithm
    gamma := 1.0E6*((12633.73/(T^2.0))-(0.4672/T))*exp(11.9463-(12633.73/T)-0.4672*log(T)); //properties of sodium based on temperature
    v_liq := 1.0/(219.0 + 275.32*(1.0-(T/2503.7)) + 511.58*((1.0-(T/2503.7))^0.5));
    v_gas := (Hfg_Na(T)/(T*gamma))+v_liq;
end VGas_Na;


//End of the function section
//-----------------------------------------------------------------------
	//Free Parameters and Constants
	//Storage Tank (Cylindrical)
	parameter SI.Volume V_tank "Volume of the vessel, including everything inside, m3"; //Optimise
	parameter SI.HeatCapacity HCap_tank "Total heat capacity of the tank, J/kgK"; 

	//Trays (Cylindrical)
	//Tray material
	parameter SI.Length d_tray = 1.0 "Diameter of the tray base, m"; //also used for Nusselt number correlation
	parameter SI.Length z_tray "Tray wall height, m";
	parameter SI.Volume V_tray "Tray material volume occupied by the walls, m3";
	parameter Integer N_tray "Number of trays in the Tank";
	parameter SI.HeatCapacity HCap_tray "Total heat capacity of the trays, J/kgK";
	parameter SI.Area A_PCM "Total cross sectional area per tray, m2";

	//PCM material
	parameter SI.Density rho_PCM_300 "Density of PCM at 300K";
	parameter SI.Density rho_PCM_start "Density of PCM at starting condition";
	parameter SI.SpecificEnthalpy h_PCM_start "Starting specific enthalpy of PCM";
	parameter SI.Length z_PCM "Vertical height of PCM at 300K, m";

	//PCM discretization
	parameter Integer n = 20 "Number of elements";
	parameter Real growth_ratio = 1.1 "Growth Ratio of PCM elements";

	//HTF material (sodium)
    parameter SI.Mass m_HTF "Mass of sodium in the vessel, kg";
	parameter SI.ThermodynamicTemperature T_start "Starting Temperature of PCM and Na gas K";


	//Insulation
	parameter SI.Area A_loss_tank "Total surface area of the tank used for thermal loss calculation";
	parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.5 "Overall heat transfer coefficient for tank thermal losses based on T_HTF - T_amb, W/m2K";

//-----------------------------------------------------------------------
	//Derived Parameters

	//PCM material
	parameter SI.Mass m_node[n] = Mass((rho_PCM_300)*A_PCM*z_PCM,Thickness(growth_ratio,z_PCM,n),n) "Mass of Node does not change";

//-----------------------------------------------------------------------
	//Graphing parameters
	parameter SI.SpecificEnthalpy h_PCM_latent; //for graphing

//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
	//Variables
	//Storage Tank and Overall
	SI.Energy E_stored "Total energy stored in the system, J";
    SI.HeatFlowRate Q_flow_chg "Heat rate into storage system, J/s";
    SI.HeatFlowRate Q_flow_dis "Heat rate discharged from storage system, J/s";
	SI.HeatFlowRate Q_loss "Heat lost to surroundings, J/s"; //SolarTherm convention provides heat loss as a negative term

    SI.Energy H_tank "Enthalpy change of the Tank material, J";
    SI.Energy H_tray "Enthalpy change of the Tray material, J";
    SI.Energy H_HTF_tray_tank "Enthalpy change of the HTF, Tray and Tank material, J";
    SI.Energy E_HTF_tray_tank (start = 0) "Total energy stored in the HTF, Tray and Tank, J";

    SI.Energy E_HTF (start=0.0) "Energy stored by the HTF, J";
    SI.Energy E_PCM (start=0.0) "Energy stored by the PCM, J";
    SI.Energy E_sensible "Sensible portion of heat storage by PCM, J";
    SI.Energy E_latent "Latent heat portion of PCM, J";

	//HTF Properties
    SI.Enthalpy H_HTF "Combined enthalpy of both liquid and gas HTF, J";
    SI.SpecificVolume v_HTF "Combined specific volume of both liquid and gas HTF, m3/kg";  //Specific volume of sodium liquid&vapor mixture constrained by the available space and mass
    Real x_HTF "Vapor quality of sodium HTF"; //Optimisation throws out results where x_HTF < 0 (compressed liquid) and x_HTF > 1 (superheated vapor)
    SI.ThermodynamicTemperature T_HTF "Temperature of HTF, K";
    Modelica.Blocks.Interfaces.RealOutput T_storage
    annotation (Placement(visible = true, transformation(origin = {108, 58},extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {108, 58},extent = {{-18, -18}, {18, 18}}, rotation = 0)));
    SI.AbsolutePressure p_HTF "Absolute pressure of HTF, Pa";

    SI.SpecificVolume v_liq "Specific volume of sat. sodium liquid at current temperature, m3/kg";
    SI.SpecificVolume v_gas "Specific volume of sat. sodium gas at current temperature, m3/kg";
    SI.SpecificEnthalpy h_liq "Specific enthalpy of sat. sodium liquid at current temperature, J/kg";
    SI.SpecificEnthalpy h_gas "Specific enthalpy of sat. sodium gas at current temperature, J/kg";

	//HTF-PCM Interface
    SI.HeatFlowRate Q_HTFPCM(start=0.0) "Total heat rate from HTF to the PCM, J/s";
    SI.HeatFlowRate Q_HTFPCM_top(start=0.0) "Heat rate from HTF to PCM from the top surface (condensation/boiling), J/s";
    SI.HeatFlowRate Q_HTFPCM_bot(start=0.0) "Heat rate from HTF to PCM from the bottom surface (natural convection), J/s";
	//Convection
	SI.ThermalConductivity k_gas "Thermal conductivity of saturated sodium vapor";
	Real C_convection "Part of the Rayleigh number calculation";
	SI.CoefficientOfHeatTransfer h_convection "Average coefficient of condensation heat transfer at the bottom of trays";

	//Trapped HTF liquid calculation and PCM level
	SI.Length dz_liq "Maximum possible thickness of liquid HTF layer on top of PCM, m";
    SI.MassDefect m_trap "Maximum Possible Mass of liquid sodium trapped in the containers, kg";
    SI.Mass m_avail "Mass of liquid Na available for heat transfer at the receiver and power block in worst case scenario, kg";

	//PCM Discretization
	SI.ThermodynamicTemperature T[n] "Temperature array within PCM, K";
	SI.SpecificEnthalpy h[n] (start = fill(h_PCM_start,n)) "Specific energy array within PCM, J/kg";
	SI.Length dz[n] "Thickness array of PCM elements, m";
	Real f[n] "Liquid fraction array of PCM elements";
	SI.Length z[n] (start = Location(Thickness(growth_ratio,z_PCM,n),z_PCM,n)) "Location of node centes of PCM elements, m";
    SI.Length L_total "Total variable length, m";
    SI.Length L_combined "Total length of Sodium layer and salt, m";

    //Efficiency Calculations
	SI.Heat E_in (start = 0) "Total heat energy entering the System, J";
	SI.Heat E_out (start = 0) "Total heat energy leaving the System, J";
    SI.Heat X_in (start = 0) "Total exergy entering the system, J";
    SI.Heat X_out (start = 0) "Total exergy leaving the system, J";
    Real energy_efficiency;
    Real exergy_efficiency;

	//Tables
    Tables.CombiTable1Ds Tab[n] (each tableOnFile=true, each tableName="table_1D_1",each columns=2:5, each fileName=table_file);
    //Tables.CombiTable1Ds SoluTab (tableOnFile=true, tableName="table_1D_1", fileName=solubility_file);
    Tables.CombiTable1Ds ConvTab (tableOnFile=true, tableName="table_1D_1",columns=2:3, fileName=convection_file);


protected
	//PCM properties
	SI.Density rho[n];//(start = fill(Rho_NaCl(T_start,0.0),n)) "Node Density";
	SI.ThermalConductivity k[n];//(start = fill(K_NaCl(T_start,0.0),n)) "Node thermal Conductivity";
	SI.SpecificEnthalpy h_HTF;
	SI.Density d_HTF;

	//Heat lost to surroundings
  Modelica.Blocks.Interfaces.RealInput T_amb annotation (Placement(
        visible = true,transformation(
        
        origin={0, 124},extent={{-16,-16},{16,16}},
        rotation=-90), iconTransformation(
        
        origin={-41,97},extent={{-11,-11},{11,11}},
        rotation=-90)));
	//SI.ThermodynamicTemperature T_amb;

	//For pump calculations
	SI.SpecificEnthalpy h_fg;

initial equation
	for i in 1:n loop
		h[i] = h_PCM_start; //set all nodes to a constant starting specific enthalpy
	end for;
	T_HTF = T_start;
equation
    T_storage = T_HTF;
	//Heat Transfered to the Tank and energy tracking
    H_tank = HCap_tank*(T_HTF-T_start);
    H_tray = HCap_tray*(T_HTF-T_start);
    H_HTF_tray_tank = H_HTF + H_tank + H_tray;
	Q_loss = -1.0*U_loss_tank*A_loss_tank*(T_HTF-T_amb);
    der(H_HTF_tray_tank) = Q_flow_chg - Q_flow_dis - Q_HTFPCM + Q_loss;
    der(E_stored) = Q_flow_chg - Q_flow_dis + Q_loss; //Rate of change of energy in the storage vessel
    der(E_HTF_tray_tank) = Q_flow_chg - Q_flow_dis - Q_HTFPCM + Q_loss;
	E_HTF = E_HTF_tray_tank - H_tank - H_tray;

	//HTF Properties
    V_tank - sum(dz)*A_PCM = v_HTF*m_HTF + V_tray;
//Figure out the volume avaibale for the sodium mixture based on vessel volume and
  p_HTF = 1.0E6 * exp(11.9463 - 12633.73 / T_HTF) / T_HTF ^ 0.4672; //Saturation pressure curve
    (h_liq,h_gas) = H_Na(T_HTF); //Specific enthlapies of components
    v_liq = VLiq_Na(T_HTF); //Specific volume of liquid
    v_gas = VGas_Na(T_HTF); //Specific volume of gas
    x_HTF*v_gas + (1.0-x_HTF)*v_liq = v_HTF; //Figure out the quality of the mixture from both volume and enthalpy
    H_HTF = m_HTF*(x_HTF*h_gas + (1.0-x_HTF)*h_liq); //Enthalpy constraint
	h_HTF = H_HTF/m_HTF;
	d_HTF = 1.0/v_HTF;
	h_fg = Hfg_Na(T_HTF);

	//PCM Section
    //Calculate properties of the NaCl
    for i in 1:n loop
    	Tab[i].u = h[i];
    	Tab[i].y[1] = T[i];
    	Tab[i].y[2] = f[i];
    	Tab[i].y[3] = rho[i];
    	Tab[i].y[4] = k[i];
    	dz[i]*rho[i]*A_PCM = m_node[i];
	end for;
	z[1] = 0.5*dz[1];
	for i in 2:n loop
    	z[i] = sum(dz[1:i-1])+0.5*dz[i];
    end for;
	//Heat transfer equations within the PCM
    //Mid-node Equation
	for i in 2:n-1 loop
		m_node[i]*der(h[i])=A_PCM*((2.0*((k[i+1]*k[i])/(dz[i]*k[i+1]+dz[i+1]*k[i]))*(T[i+1]-T[i])) - (2.0*((k[i]*k[i-1])/(dz[i]*k[i-1]+dz[i-1]*k[i]))*(T[i]-T[i-1])));
	end for;
    //Boundary Condition Equations
	m_node[n]*der(h[n])= Q_HTFPCM_top - A_PCM*(2.0*((k[n]*k[n-1])/(dz[n-1]*k[n]+dz[n]*k[n-1]))*(T[n]-T[n-1])); //if this slice is hotter than bottom, heat flows out
	m_node[1]*der(h[1])= Q_HTFPCM_bot + 2.0*A_PCM*((k[2]*k[1])/(dz[1]*k[2]+dz[2]*k[1]))*(T[2]-T[1]);
//Interface Equations
  Q_HTFPCM_bot = Q_transferbottom(T_HTF, T[1], A_PCM, dz[1], k[1], k_gas, C_convection, d_tray);
	Q_HTFPCM_top = Q_transfertop(T_HTF,T[n],A_PCM,dz[n],k[n]);
	Q_HTFPCM = Q_HTFPCM_bot + Q_HTFPCM_top;
    der(E_PCM) = Q_HTFPCM;

	//Convection Heat Transfer Equation
	ConvTab.u = T_HTF;
	ConvTab.y[1] = k_gas;
	ConvTab.y[2] = C_convection;
	h_convection = 2.08*(k_gas/d_tray)*((C_convection*abs(T[1]-T_HTF)*(d_tray^3.0))^0.2);

	//Tracking energy
    E_latent = sum(f .* m_node)*h_PCM_latent; //latent heat of fusion is 482390.5 J/kg
    E_sensible = E_PCM - E_latent;

	//Mass of liquid sodium trapped
	L_total = sum(dz);
	dz_liq = z_tray-L_total; //Empty Length available above the PCM surface
	m_trap = dz_liq*A_PCM/v_liq; //Worst case mass of sodium liquid in trays
	m_avail = m_HTF*(1.0-x_HTF) - m_trap;
    L_combined = sum(dz) + dz_liq;

	der(E_in) = Q_flow_chg;
	der(E_out) = Q_flow_dis;

	der(X_in) = Q_flow_chg*(1.0-(300.0/T_HTF));
	der(X_out) = Q_flow_dis*(1.0-(300.0/T_HTF));


	//Analytical variables


    if time >= 10*3600*24 then //start calculating efficiencies after day 10
		energy_efficiency = E_out/E_in;
		exergy_efficiency = X_out/X_in;
    else
		energy_efficiency = 0.0;
		exergy_efficiency = 0.0;
    end if;



	heat_a.Q_flow = Q_flow_chg;
	heat_b.Q_flow = -1.0*Q_flow_dis;
	heat_b.T=T_HTF;
	heat_a.T=T_HTF;
//assert(m_trap >= 1.0e-12, "Invalid Mass", level = AssertionLevel.error);
end Sodium_NaCl_Zebedee;