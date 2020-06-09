within SolarTherm.Systems;

model OpticsFileReader
  import SolarTherm.Types.Solar_angles;
  parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/surround/100MWe/3774c%/706K/";
  parameter Integer dSM = 18;
  parameter Integer T_recv_avg = 706;
  parameter Integer eta_blk_cpct = 3774;
  parameter Integer phi_pct = 100;
  parameter Integer HT_pct = 100;
  parameter Integer A_recv_pct = 100;
  
  parameter String opt_file = Modelica.Utilities.Files.loadResource(opt_file_prefix + String(dSM) + "dSM/isp_designpt/" + String(phi_pct) + "%phi_" + String(HT_pct) + "%HT_" + String(A_recv_pct) + "%Arecv_optics.motab");
  
  
  //Metadata from the optical lookup table file(s)
  parameter Real[8] Meta = SolarTherm.Utilities.Metadata_Optics(opt_file);
  //List of metadata values for field A
  parameter Integer n_heliostat = SolarTherm.Utilities.Round(Meta[1]) "Number of heliostats";
  parameter SI.Area A_heliostat = Meta[2] "Area of one heliostat";
  parameter Real eff_opt_des = Meta[3] "Design optical efficiency";
  parameter SI.Length H_recv = Meta[4] "Height of the receiver";
  parameter SI.Length D_recv = Meta[5] "Diameter/Width of the receiver";
  parameter SI.Length H_tower = Meta[6] "Height of the tower";
  
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table_Full OpticsModel(angles=Solar_angles.dec_hra,file=opt_file);
  Real A_recv(start=Modelica.Constants.pi*H_recv*D_recv);
equation
  der(A_recv)=0.0;
  OpticsModel.dec = 0.0;
  OpticsModel.hra = 0.0;
end OpticsFileReader;