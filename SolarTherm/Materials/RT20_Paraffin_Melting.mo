within SolarTherm.Materials;
package RT20_Paraffin_Melting
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 353e-3, T_melt = 295.15, cost = 0.049); //DOnt trust these constants
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.Temperature T_melt = 295.15 "Melting point (K)";
  //constant Real cost = 0.049 "USD/kg";

  redeclare model State "A model which calculates state and properties"
  	parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/RT20_Paraffin_Slow.txt");
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
	Tables.CombiTable1Ds Tab (tableOnFile=true, tableName="table_1D_1", columns=2:5, fileName=table_file);
	
  equation
	Tab.u = h;
	T = Tab.y[1];
	f = Tab.y[2];
	rho = Tab.y[3];
	k = Tab.y[4];
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  protected
    Real T_data[32] = {273.15,273.21,280.0121,280.9311816193,281.9727571116,283.0143326039,284.3622538293,285.8327133479,287.1806345733,288.2222100656,289.3863238512,290.3053610503,291.1018599562,292.0208971554,292.6335886214,293.1850109409,293.491356674,293.8589715536,294.2878555799,294.5329321663,294.900547046,295.2681619256,295.3294310722,295.4519693654,295.6357768053,295.7583150985,295.8808533917,296.1871991247,301.15,310,320,330};
    Real h_data[32] = {0.00,111.74,12514.5491,14414.0788677313,16820.1499138694,19416.1739373341,23267.3774384282,28362.586712603,34098.4217142326,39480.4227384888,47123.2366497511,54888.9613110481,63313.9345407143,75772.6151124354,86350.3887518043,97982.2151869273,105561.71143908,115930.909260207,129618.697332278,138274.593789282,152308.766702361,166208.855160854,168272.265934168,171758.46175334,175903.906140882,177863.029005075,179054.890823595,180488.849574002,192556.450486522,214076.207325427,238392.31674792,262708.426170412};
  algorithm
    h := Interpolate1D(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy rho "Density (kg/m3)";
  protected
    Real T_data[32] = {273.15,273.21,280.0121,280.9311816193,281.9727571116,283.0143326039,284.3622538293,285.8327133479,287.1806345733,288.2222100656,289.3863238512,290.3053610503,291.1018599562,292.0208971554,292.6335886214,293.1850109409,293.491356674,293.8589715536,294.2878555799,294.5329321663,294.900547046,295.2681619256,295.3294310722,295.4519693654,295.6357768053,295.7583150985,295.8808533917,296.1871991247,301.15,310,320,330};
    Real rho_data[32] = {880.00,880.00,880.0000,878.5299008847,876.6677753387,874.6586398812,871.6780859886,867.7347613029,863.2956384842,859.1303576576,853.2153706291,847.2052595401,840.6849375818,831.0428169139,822.8563826249,813.8541874543,807.9882037296,799.9631920885,789.3698308166,782.6707909266,771.8093527573,761.0516862902,759.4547550943,756.7566908357,753.5484157077,752.0321958358,751.1097807047,750,750,750,750,750};
  algorithm
    rho := Interpolate1D(T_data,rho_data,T);
  end rho_Tf;
  
end RT20_Paraffin_Melting;
