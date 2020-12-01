within SolarTherm.Models.Control;
model PBS_Controller
  extends Icons.Control;
  replaceable package HTF = SolarTherm.Media.Sodium.Sodium_pT;
  parameter SI.Temperature T_recv_max = 550.0 + 273.15 "Maximum tolerated receiver input temperature";
  parameter SI.Temperature T_recv_start = 530.0 + 273.15 "Receiver input temperature at which receiver can start";
  parameter SI.Temperature T_PB_min = 680.0 + 273.15 "Minimum tolerated PB input temperature";
  parameter SI.Temperature T_PB_start = 710.0 + 273.15 "PB input temperature at which it can start";
  parameter SI.Temperature T_target = 740.0 + 273.15 "Target receiver outlet temperature";
  
  parameter SI.MassFlowRate m_flow_PB_des = 100.0 "Reference power block mass flow rate";
  parameter SI.HeatFlowRate Q_des_blk = 200e6 "Power block design heat rate";
  parameter SI.SpecificEnthalpy h_target = HTF.specificEnthalpy(HTF.setState_pTX(101323.0, T_target)) "Target specific enthalpy of the receiver outlet";
  Integer Control_State(start=6) "1-6 Determines which pumps are flowing and whether defocus is on";
  Boolean Chg(start=true) "Can the storage be charged?";
  Boolean Disch(start=false) "Can the storage be discharged?";
  //Timer to prevent PB from being turned on too many times
  //parameter SI.Time t_wait=1.0*3600 "Time you have to wait after shutdown before it can be turned on again";
  //SI.Time t_shutdown(start=0) "Time since it last shut down";
  //End timer
  parameter SI.HeatFlowRate Q_rcv_min = 0.10*Q_des_blk "Minimum receiver heat-rate to start mass flow to receiver";
  parameter SI.MassFlowRate m_0 = 1.0e-4 "Minimum mass flow rate through any pipe";
  
  Modelica.Blocks.Interfaces.RealInput T_top_tank "Temperature of the top of HTF in storage"
    annotation (Placement(visible = true, transformation(extent = {{-126, -20}, {-86, 20}}, rotation = 0), iconTransformation(extent = {{-126, -8}, {-86, 32}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput T_bot_tank "Temperature of the bottom of HTF in storage"
    annotation (Placement(visible = true, transformation(extent = {{-126, -60}, {-86, -20}}, rotation = 0), iconTransformation(extent = {{-126, -60}, {-86, -20}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealOutput m_flow_PB(start=0.0) "Power block mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, -12}, {130, 28}}, rotation = 0))) ;
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_recv(start=0.0) "Receiver mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, 38}, {130, 78}}, rotation = 0))) ;
  
  Modelica.Blocks.Interfaces.RealOutput Q_defocus(start=Q_des_blk) "Required defocus heat" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(origin = {-108, -90},extent = {{-20, -20}, {20, 20}}, rotation = 180))) ;
  
  Modelica.Blocks.Interfaces.BooleanOutput defocus(start=false) "defocus receiver?" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, -60}, {130, -20}}, rotation = 0))) ;

  Modelica.Blocks.Interfaces.RealInput Q_rcv_raw "The net receiver heat rate before curtailment"
    annotation (Placement(visible = true, transformation(extent = {{-124, 22}, {-84, 62}}, rotation = 0), iconTransformation(extent = {{-126, 48}, {-86, 88}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput h_PB_outlet "Enthalpy of the HTF coming out of PB"
    annotation (Placement(visible = true, transformation(extent = {{-128, -80}, {-88, -40}}, rotation = 0), iconTransformation(origin = {56, 112},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    
  Modelica.Blocks.Interfaces.RealInput h_tank_outlet "Enthalpy of the HTF coming out of bottom of tank"
    annotation (Placement(visible = true, transformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0), iconTransformation(origin = {-40, 112},extent = {{-20, -20}, {20, 20}}, rotation = -90)));

/*
algorithm
  //Changing storage state
  when T_bot_tank < T_recv_start then
    if Control_State == 3 then
      Control_State := 5;
      //defocus := true;
    end if;
  end when;
  when T_bot_tank > T_recv_max then
    if Control_State == 5 then
      Control_State := 3;
      //defocus := false;
    end if;
  end when;
  when T_top_tank >= T_PB_start then
    if Control_State == 1 then
      Control_State := 4;
      //defocus := false;
    elseif Control_State == 6 then
      Control_State := 2;
      //defocus := false;
    end if;
  end when;
  when T_top_tank < T_PB_min then
    if Control_State == 4 then
      Control_State := 1;
      //defocus := false;
    elseif Control_State == 2 then
      Control_State := 6;
      //defocus := false;
    end if;
  end when;
  //Changing receiver state
  when Q_rcv_raw >= Q_des_blk + 1000 then
    if T_bot_tank < T_recv_max then
      Control_State := 5;
      //defocus := false;
    else
      Control_State := 3;
      //defocus := true;
    end if;
  end when;
  when Q_rcv_raw < Q_des_blk - 10000 then
    if T_top_tank > T_PB_min then
      Control_State := 4;
      //defocus := false;
    else
      Control_State := 1;
      //defocus := false;
    end if;
  end when;
  when Q_rcv_raw <= 5000 then
    if T_top_tank > T_PB_min then
      Control_State := 2;
      //defocus := false;
    else
      Control_State := 6;
      //defocus := false;
    end if;     
  end when;
  when Q_rcv_raw > 10000 then
    if T_top_tank > T_PB_min then
      Control_State := 4;
      //defocus := false;
    else
      Control_State := 1;
      //defocus := false;
    end if;     
  end when;
*/
/*equation
  if Q_rcv_raw >= Q_des_blk then
    if T_bot_tank < T_recv_max then
      Control_State = 5;
      defocus = false;
    else
      Control_State = 3;
      defocus = true;
    end if;
  elseif Q_rcv_raw > 0 and Q_rcv_raw < Q_des_blk then
    if T_top_tank > T_PB_min then
      Control_State = 4;
      defocus = false;
    else
      Control_State = 1;
      defocus = false;
    end if;
  else
    if T_top_tank > T_PB_min then
      Control_State = 2;
      defocus = false;
    else
      Control_State = 6;
      defocus = false;
    end if;
  end if;*/
algorithm
  //Changing Storage State
  when T_top_tank < T_PB_min then //Tank cannot be discharged, Disch -> false
    Disch := false;
    if Q_rcv_raw <= Q_rcv_min then //2 -> 6
      Control_State := 6;
    elseif Q_rcv_raw > Q_rcv_min and Q_rcv_raw < Q_des_blk then
      if Chg then //4 -> either 1 or 6
        Control_State := 1;
      else
        Control_State := 6;
      end if;
    end if;
  //end when;
  elsewhen T_top_tank > T_PB_start then //Can start discharging storage, Disch -> true
    Disch := true;
    if Q_rcv_raw <= Q_rcv_min then //6 -> 2,
        Control_State := 2;
    elseif Q_rcv_raw > Q_rcv_min and Q_rcv_raw < Q_des_blk then //either 1 or 6 -> 4
        Control_State := 4;
    end if;
  end when;
  when T_bot_tank > T_recv_max then //Must stop charging, Chg -> false
    Chg := false;
    if Q_rcv_raw >= Q_des_blk then //5 -> 3, power block remains on
      Control_State := 3;
    elseif Q_rcv_raw > Q_rcv_min and Q_rcv_raw < Q_des_blk then //maybe at state 4 or 1
      if Disch == false then //if 1 then 1 -> 6
        Control_State := 6;
      end if;
    end if;
  elsewhen T_bot_tank < T_recv_start then //Can start charging, Chg -> true
    Chg := true;
    if Q_rcv_raw >= Q_des_blk then //3 -> 5, power block remains on
      Control_State := 5;
    elseif Q_rcv_raw > Q_rcv_min and Q_rcv_raw < Q_des_blk then //4 -> either 1 or 6
      if Disch == false then //its not 4 therefore it is 6, 6 -> 1, PB remains off
        Control_State := 1;
      end if;
    end if;
  end when;
  
  //Change Q_rcv_raw state
  when Q_rcv_raw > Q_rcv_min then //Originally 2 or 6
  //becomes either 1, 4 or 6
      if Disch then //either 2 or 6 -> 4
        if Control_State == 2 then
          Control_State := 4;
        end if;
      else //either 2 or 6 -> either 1 or 6, PB does not turn on
        if Chg then
          Control_State := 1;
        else
          Control_State := 6;
        end if;
      end if;
  //end when;
  elsewhen Q_rcv_raw >= Q_des_blk then // 1 or 4 or 6 -> 3 or 5
    if Control_State == 4 then
      if Chg then
        Control_State := 5;
      else
        Control_State := 3;
      end if;
    end if; //new
  //end when;
  elsewhen Q_rcv_raw < Q_des_blk then // 5 or 3 -> 1 or 2 or 4 or 6
      if Disch then
        Control_State := 4;
      else
        if Chg then
          Control_State := 1;
        else
          Control_State := 6;
        end if;
      end if;
  //end when;
  elsewhen Q_rcv_raw <= Q_rcv_min then //1 or 4 or 6 -> 2 or 6
    if Disch then
      if Control_State == 4 then
        Control_State := 2;
      end if; //new
    else
      Control_State := 6;
    end if;
  end when;
equation
  if Control_State == 1 then
    m_flow_recv = max(m_0,Q_rcv_raw/(h_target-h_tank_outlet));
    m_flow_PB = m_0;
    defocus = false;
    Q_defocus = Q_des_blk; //Not used anyway
    
  elseif Control_State == 2 then
    m_flow_recv = m_0;
    m_flow_PB = m_flow_PB_des;
    defocus = false;
    Q_defocus = Q_des_blk; //Not used anyway

  elseif Control_State == 3 then
    m_flow_recv = m_flow_PB_des;
    m_flow_PB = m_flow_PB_des;
    defocus = true;
    Q_defocus = m_flow_PB_des*(h_target-h_PB_outlet); //Not used anyway

  elseif Control_State == 4 then
    m_flow_recv = max(m_0,Q_rcv_raw/(h_target-h_PB_outlet));
    m_flow_PB = m_flow_PB_des; //whoops I switched these by mistake
    defocus = false;
    Q_defocus = Q_des_blk; //Not used anyway

  elseif Control_State == 5 then
    m_flow_recv = max((Q_rcv_raw + m_flow_PB*(h_PB_outlet-h_tank_outlet))/(h_target-h_tank_outlet),m_0);
    m_flow_PB = m_flow_PB_des;
    defocus = false;
    Q_defocus = Q_des_blk; //Not used anyway

  else
    m_flow_recv = m_0;
    m_flow_PB = m_0;
    defocus = false;
    Q_defocus = Q_des_blk; //Not used anyway

  end if;

end PBS_Controller;