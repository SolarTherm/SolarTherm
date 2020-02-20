within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function ShellDiameter
  input SI.Length d_o "Outer Tube Diameter";
  input Integer N_t;
  input Integer layout;
  input Integer N_p;
  output SI.Length L_bb;
  output SI.Length D_b;
  output SI.Length D_s;
  output SI.Length D_s_out;
  
  protected
  Real KK1;
  Real nn1;
  SI.Length t_shell;

algorithm
  //Shell Diameter
  if layout==1 then
    if N_p==1 then
      KK1:=0.215;
      nn1:=2.207;
    elseif N_p==2 then
      KK1:=0.156;
      nn1:=2.291;
    elseif N_p==4 then
      KK1:=0.158;
      nn1:=2.263;
    elseif N_p==6 then
      KK1:=0.0402;
      nn1:=2.617;
    elseif N_p==8 then
      KK1:=0.0331;
      nn1:=2.643;
    end if;
  else
    if N_p==1 then
      KK1:=0.319;
      nn1:=2.142;
    elseif N_p==2 then
      KK1:=0.249;
      nn1:=2.207;
    elseif N_p==4 then
      KK1:=0.175;
      nn1:=2.285;
    elseif N_p==6 then
      KK1:=0.0743;
      nn1:=2.499;
    elseif N_p==8 then
      KK1:=0.0365;
      nn1:=2.675;
    end if;
  end if;
  D_b:=(N_t/KK1)^(1/nn1)*d_o;
  L_bb:=(12+5*(D_b+d_o))/995;
  D_s:=L_bb+D_b+d_o;
  t_shell:=ShellThickness(D_s);
  D_s_out:=D_s+2*t_shell;
 
end ShellDiameter;