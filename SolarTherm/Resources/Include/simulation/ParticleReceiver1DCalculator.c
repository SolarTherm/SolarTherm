/* Main Simulation File */

#if defined(__cplusplus)
extern "C" {
#endif

#include "ParticleReceiver1DCalculator_model.h"
#include "simulation/solver/events.h"

#define prefixedName_performSimulation ParticleReceiver1DCalculator_performSimulation
#define prefixedName_updateContinuousSystem ParticleReceiver1DCalculator_updateContinuousSystem
#include <simulation/solver/perform_simulation.c.inc>

#define prefixedName_performQSSSimulation ParticleReceiver1DCalculator_performQSSSimulation
#include <simulation/solver/perform_qss_simulation.c.inc>

/* dummy VARINFO and FILEINFO */
const FILE_INFO dummyFILE_INFO = omc_dummyFileInfo;
const VAR_INFO dummyVAR_INFO = omc_dummyVarInfo;

int ParticleReceiver1DCalculator_input_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int ParticleReceiver1DCalculator_input_function_init(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int ParticleReceiver1DCalculator_input_function_updateStartValues(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int ParticleReceiver1DCalculator_inputNames(DATA *data, char ** names){
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int ParticleReceiver1DCalculator_data_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  TRACE_POP
  return 0;
}

int ParticleReceiver1DCalculator_output_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int ParticleReceiver1DCalculator_setc_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


/*
equation index: 769
type: SIMPLE_ASSIGN
particleReceiver1D._Re = 4.428690551393267 * sqrt(particleReceiver1D.H_drop_design) * particleReceiver1D.rho_air * particleReceiver1D.H_drop_design / particleReceiver1D.miu
*/
void ParticleReceiver1DCalculator_eqFunction_769(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,769};
  modelica_real tmp0;
  tmp0 = data->simulationInfo->realParameter[48] /* particleReceiver1D.H_drop_design PARAM */;
  if(!(tmp0 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.H_drop_design) was %g should be >= 0", tmp0);
  }
  data->localData[0]->realVars[166] /* particleReceiver1D.Re variable */ = (4.428690551393267) * ((sqrt(tmp0)) * ((data->localData[0]->realVars[539] /* particleReceiver1D.rho_air variable */) * (DIVISION_SIM(data->simulationInfo->realParameter[48] /* particleReceiver1D.H_drop_design PARAM */,data->localData[0]->realVars[418] /* particleReceiver1D.miu variable */,"particleReceiver1D.miu",equationIndexes))));
  TRACE_POP
}
/*
equation index: 770
type: SIMPLE_ASSIGN
particleReceiver1D._Nu = -758.9 + 0.05737 * particleReceiver1D.Re ^ 0.8571
*/
void ParticleReceiver1DCalculator_eqFunction_770(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,770};
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_real tmp5;
  modelica_real tmp6;
  modelica_real tmp7;
  tmp1 = data->localData[0]->realVars[166] /* particleReceiver1D.Re variable */;
  tmp2 = 0.8571;
  if(tmp1 < 0.0 && tmp2 != 0.0)
  {
    tmp4 = modf(tmp2, &tmp5);
    
    if(tmp4 > 0.5)
    {
      tmp4 -= 1.0;
      tmp5 += 1.0;
    }
    else if(tmp4 < -0.5)
    {
      tmp4 += 1.0;
      tmp5 -= 1.0;
    }
    
    if(fabs(tmp4) < 1e-10)
      tmp3 = pow(tmp1, tmp5);
    else
    {
      tmp7 = modf(1.0/tmp2, &tmp6);
      if(tmp7 > 0.5)
      {
        tmp7 -= 1.0;
        tmp6 += 1.0;
      }
      else if(tmp7 < -0.5)
      {
        tmp7 += 1.0;
        tmp6 -= 1.0;
      }
      if(fabs(tmp7) < 1e-10 && ((unsigned long)tmp6 & 1))
      {
        tmp3 = -pow(-tmp1, tmp4)*pow(tmp1, tmp5);
      }
      else
      {
        throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp1, tmp2);
      }
    }
  }
  else
  {
    tmp3 = pow(tmp1, tmp2);
  }
  if(isnan(tmp3) || isinf(tmp3))
  {
    throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp1, tmp2);
  }
  data->localData[0]->realVars[7] /* particleReceiver1D.Nu variable */ = -758.9 + (0.05737) * (tmp3);
  TRACE_POP
}
/*
equation index: 771
type: SIMPLE_ASSIGN
particleReceiver1D._h_ambient = particleReceiver1D.Nu * particleReceiver1D.k_air / particleReceiver1D.H_drop_design
*/
void ParticleReceiver1DCalculator_eqFunction_771(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,771};
  data->localData[0]->realVars[355] /* particleReceiver1D.h_ambient variable */ = (data->localData[0]->realVars[7] /* particleReceiver1D.Nu variable */) * (DIVISION_SIM(data->localData[0]->realVars[417] /* particleReceiver1D.k_air variable */,data->simulationInfo->realParameter[48] /* particleReceiver1D.H_drop_design PARAM */,"particleReceiver1D.H_drop_design",equationIndexes));
  TRACE_POP
}
/*
equation index: 772
type: SIMPLE_ASSIGN
particleReceiver1D._q_conv_curtain[30] = particleReceiver1D.F_wind * particleReceiver1D.h_ambient * (T_out_design - T_amb_design)
*/
void ParticleReceiver1DCalculator_eqFunction_772(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,772};
  data->localData[0]->realVars[478] /* particleReceiver1D.q_conv_curtain[30] variable */ = (data->localData[0]->realVars[6] /* particleReceiver1D.F_wind variable */) * ((data->localData[0]->realVars[355] /* particleReceiver1D.h_ambient variable */) * (data->simulationInfo->realParameter[13] /* T_out_design PARAM */ - data->simulationInfo->realParameter[11] /* T_amb_design PARAM */));
  TRACE_POP
}
/*
equation index: 773
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[30] = particleReceiver1D.q_conv_curtain[30] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_773(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,773};
  data->localData[0]->realVars[72] /* particleReceiver1D.Qloss_conv_curtain_discrete[30] variable */ = (data->localData[0]->realVars[478] /* particleReceiver1D.q_conv_curtain[30] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 774
type: SIMPLE_ASSIGN
particleReceiver1D._phi[2] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[2] * particleReceiver1D.vp[2] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_774(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,774};
  modelica_boolean tmp8;
  tmp8 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[419] /* particleReceiver1D.phi[2] variable */ = (tmp8?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[542] /* particleReceiver1D.t_c[2] variable */)) * (data->localData[0]->realVars[604] /* particleReceiver1D.vp[2] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[2] * particleReceiver1D.vp[2] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 775
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[1] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[2] * particleReceiver1D.t_c[2] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_775(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,775};
  modelica_boolean tmp9;
  tmp9 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[574] /* particleReceiver1D.tau_c[1] variable */ = (tmp9?0.0:exp((-1.5) * ((data->localData[0]->realVars[419] /* particleReceiver1D.phi[2] variable */) * (DIVISION_SIM(data->localData[0]->realVars[542] /* particleReceiver1D.t_c[2] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 776
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[1] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[2] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[2] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[1])
*/
void ParticleReceiver1DCalculator_eqFunction_776(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,776};
  modelica_boolean tmp10;
  modelica_real tmp11;
  modelica_boolean tmp12;
  modelica_real tmp13;
  tmp10 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp12 = (modelica_boolean)tmp10;
  if(tmp12)
  {
    tmp13 = 0.0;
  }
  else
  {
    tmp11 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp13 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[419] /* particleReceiver1D.phi[2] variable */)),(3.141592653589793) * ((tmp11 * tmp11 * tmp11)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[542] /* particleReceiver1D.t_c[2] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[574] /* particleReceiver1D.tau_c[1] variable */,"1.0 - particleReceiver1D.tau_c[1]",equationIndexes);
  }
  data->localData[0]->realVars[231] /* particleReceiver1D.abs_c[1] variable */ = tmp13;
  TRACE_POP
}
/*
equation index: 777
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[1] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[2] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[2] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[1])
*/
void ParticleReceiver1DCalculator_eqFunction_777(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,777};
  modelica_boolean tmp14;
  modelica_real tmp15;
  modelica_boolean tmp16;
  modelica_real tmp17;
  tmp14 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp16 = (modelica_boolean)tmp14;
  if(tmp16)
  {
    tmp17 = 0.0;
  }
  else
  {
    tmp15 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp17 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[419] /* particleReceiver1D.phi[2] variable */)),(3.141592653589793) * ((tmp15 * tmp15 * tmp15)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[542] /* particleReceiver1D.t_c[2] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[574] /* particleReceiver1D.tau_c[1] variable */,"1.0 - particleReceiver1D.tau_c[1]",equationIndexes);
  }
  data->localData[0]->realVars[262] /* particleReceiver1D.eps_c[1] variable */ = tmp17;
  TRACE_POP
}
/*
equation index: 778
type: SIMPLE_ASSIGN
particleReceiver1D._vp[3] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[2] ^ 2.0 + 19.6133 * (particleReceiver1D.x[3] - particleReceiver1D.x[2])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_778(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,778};
  modelica_boolean tmp18;
  modelica_real tmp19;
  modelica_real tmp20;
  modelica_boolean tmp21;
  modelica_real tmp22;
  tmp18 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp21 = (modelica_boolean)tmp18;
  if(tmp21)
  {
    tmp19 = data->localData[0]->realVars[604] /* particleReceiver1D.vp[2] variable */;
    tmp20 = (tmp19 * tmp19) + (19.6133) * (data->localData[0]->realVars[636] /* particleReceiver1D.x[3] variable */ - data->localData[0]->realVars[635] /* particleReceiver1D.x[2] variable */);
    if(!(tmp20 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[2] ^ 2.0 + 19.6133 * (particleReceiver1D.x[3] - particleReceiver1D.x[2])) was %g should be >= 0", tmp20);
    }
    tmp22 = sqrt(tmp20);
  }
  else
  {
    tmp22 = 0.0;
  }
  data->localData[0]->realVars[605] /* particleReceiver1D.vp[3] variable */ = tmp22;
  TRACE_POP
}
/*
equation index: 779
type: SIMPLE_ASSIGN
particleReceiver1D._phi[3] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[3] * particleReceiver1D.vp[3] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_779(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,779};
  modelica_boolean tmp23;
  tmp23 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[420] /* particleReceiver1D.phi[3] variable */ = (tmp23?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[543] /* particleReceiver1D.t_c[3] variable */)) * (data->localData[0]->realVars[605] /* particleReceiver1D.vp[3] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[3] * particleReceiver1D.vp[3] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 780
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[2] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[3] * particleReceiver1D.t_c[3] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_780(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,780};
  modelica_boolean tmp24;
  tmp24 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[575] /* particleReceiver1D.tau_c[2] variable */ = (tmp24?0.0:exp((-1.5) * ((data->localData[0]->realVars[420] /* particleReceiver1D.phi[3] variable */) * (DIVISION_SIM(data->localData[0]->realVars[543] /* particleReceiver1D.t_c[3] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 781
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[2] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[3] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[3] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[2])
*/
void ParticleReceiver1DCalculator_eqFunction_781(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,781};
  modelica_boolean tmp25;
  modelica_real tmp26;
  modelica_boolean tmp27;
  modelica_real tmp28;
  tmp25 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp27 = (modelica_boolean)tmp25;
  if(tmp27)
  {
    tmp28 = 0.0;
  }
  else
  {
    tmp26 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp28 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[420] /* particleReceiver1D.phi[3] variable */)),(3.141592653589793) * ((tmp26 * tmp26 * tmp26)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[543] /* particleReceiver1D.t_c[3] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[575] /* particleReceiver1D.tau_c[2] variable */,"1.0 - particleReceiver1D.tau_c[2]",equationIndexes);
  }
  data->localData[0]->realVars[232] /* particleReceiver1D.abs_c[2] variable */ = tmp28;
  TRACE_POP
}
/*
equation index: 782
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[2] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[3] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[3] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[2])
*/
void ParticleReceiver1DCalculator_eqFunction_782(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,782};
  modelica_boolean tmp29;
  modelica_real tmp30;
  modelica_boolean tmp31;
  modelica_real tmp32;
  tmp29 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp31 = (modelica_boolean)tmp29;
  if(tmp31)
  {
    tmp32 = 0.0;
  }
  else
  {
    tmp30 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp32 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[420] /* particleReceiver1D.phi[3] variable */)),(3.141592653589793) * ((tmp30 * tmp30 * tmp30)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[543] /* particleReceiver1D.t_c[3] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[575] /* particleReceiver1D.tau_c[2] variable */,"1.0 - particleReceiver1D.tau_c[2]",equationIndexes);
  }
  data->localData[0]->realVars[263] /* particleReceiver1D.eps_c[2] variable */ = tmp32;
  TRACE_POP
}
/*
equation index: 783
type: SIMPLE_ASSIGN
particleReceiver1D._vp[4] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[3] ^ 2.0 + 19.6133 * (particleReceiver1D.x[4] - particleReceiver1D.x[3])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_783(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,783};
  modelica_boolean tmp33;
  modelica_real tmp34;
  modelica_real tmp35;
  modelica_boolean tmp36;
  modelica_real tmp37;
  tmp33 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp36 = (modelica_boolean)tmp33;
  if(tmp36)
  {
    tmp34 = data->localData[0]->realVars[605] /* particleReceiver1D.vp[3] variable */;
    tmp35 = (tmp34 * tmp34) + (19.6133) * (data->localData[0]->realVars[637] /* particleReceiver1D.x[4] variable */ - data->localData[0]->realVars[636] /* particleReceiver1D.x[3] variable */);
    if(!(tmp35 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[3] ^ 2.0 + 19.6133 * (particleReceiver1D.x[4] - particleReceiver1D.x[3])) was %g should be >= 0", tmp35);
    }
    tmp37 = sqrt(tmp35);
  }
  else
  {
    tmp37 = 0.0;
  }
  data->localData[0]->realVars[606] /* particleReceiver1D.vp[4] variable */ = tmp37;
  TRACE_POP
}
/*
equation index: 784
type: SIMPLE_ASSIGN
particleReceiver1D._phi[4] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[4] * particleReceiver1D.vp[4] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_784(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,784};
  modelica_boolean tmp38;
  tmp38 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[421] /* particleReceiver1D.phi[4] variable */ = (tmp38?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[544] /* particleReceiver1D.t_c[4] variable */)) * (data->localData[0]->realVars[606] /* particleReceiver1D.vp[4] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[4] * particleReceiver1D.vp[4] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 785
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[3] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[4] * particleReceiver1D.t_c[4] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_785(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,785};
  modelica_boolean tmp39;
  tmp39 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[576] /* particleReceiver1D.tau_c[3] variable */ = (tmp39?0.0:exp((-1.5) * ((data->localData[0]->realVars[421] /* particleReceiver1D.phi[4] variable */) * (DIVISION_SIM(data->localData[0]->realVars[544] /* particleReceiver1D.t_c[4] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 786
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[3] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[4] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[4] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[3])
*/
void ParticleReceiver1DCalculator_eqFunction_786(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,786};
  modelica_boolean tmp40;
  modelica_real tmp41;
  modelica_boolean tmp42;
  modelica_real tmp43;
  tmp40 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp42 = (modelica_boolean)tmp40;
  if(tmp42)
  {
    tmp43 = 0.0;
  }
  else
  {
    tmp41 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp43 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[421] /* particleReceiver1D.phi[4] variable */)),(3.141592653589793) * ((tmp41 * tmp41 * tmp41)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[544] /* particleReceiver1D.t_c[4] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[576] /* particleReceiver1D.tau_c[3] variable */,"1.0 - particleReceiver1D.tau_c[3]",equationIndexes);
  }
  data->localData[0]->realVars[233] /* particleReceiver1D.abs_c[3] variable */ = tmp43;
  TRACE_POP
}
/*
equation index: 787
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[3] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[4] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[4] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[3])
*/
void ParticleReceiver1DCalculator_eqFunction_787(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,787};
  modelica_boolean tmp44;
  modelica_real tmp45;
  modelica_boolean tmp46;
  modelica_real tmp47;
  tmp44 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp46 = (modelica_boolean)tmp44;
  if(tmp46)
  {
    tmp47 = 0.0;
  }
  else
  {
    tmp45 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp47 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[421] /* particleReceiver1D.phi[4] variable */)),(3.141592653589793) * ((tmp45 * tmp45 * tmp45)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[544] /* particleReceiver1D.t_c[4] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[576] /* particleReceiver1D.tau_c[3] variable */,"1.0 - particleReceiver1D.tau_c[3]",equationIndexes);
  }
  data->localData[0]->realVars[264] /* particleReceiver1D.eps_c[3] variable */ = tmp47;
  TRACE_POP
}
/*
equation index: 788
type: SIMPLE_ASSIGN
particleReceiver1D._vp[5] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[4] ^ 2.0 + 19.6133 * (particleReceiver1D.x[5] - particleReceiver1D.x[4])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_788(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,788};
  modelica_boolean tmp48;
  modelica_real tmp49;
  modelica_real tmp50;
  modelica_boolean tmp51;
  modelica_real tmp52;
  tmp48 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp51 = (modelica_boolean)tmp48;
  if(tmp51)
  {
    tmp49 = data->localData[0]->realVars[606] /* particleReceiver1D.vp[4] variable */;
    tmp50 = (tmp49 * tmp49) + (19.6133) * (data->localData[0]->realVars[638] /* particleReceiver1D.x[5] variable */ - data->localData[0]->realVars[637] /* particleReceiver1D.x[4] variable */);
    if(!(tmp50 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[4] ^ 2.0 + 19.6133 * (particleReceiver1D.x[5] - particleReceiver1D.x[4])) was %g should be >= 0", tmp50);
    }
    tmp52 = sqrt(tmp50);
  }
  else
  {
    tmp52 = 0.0;
  }
  data->localData[0]->realVars[607] /* particleReceiver1D.vp[5] variable */ = tmp52;
  TRACE_POP
}
/*
equation index: 789
type: SIMPLE_ASSIGN
particleReceiver1D._phi[5] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[5] * particleReceiver1D.vp[5] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_789(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,789};
  modelica_boolean tmp53;
  tmp53 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[422] /* particleReceiver1D.phi[5] variable */ = (tmp53?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[545] /* particleReceiver1D.t_c[5] variable */)) * (data->localData[0]->realVars[607] /* particleReceiver1D.vp[5] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[5] * particleReceiver1D.vp[5] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 790
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[4] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[5] * particleReceiver1D.t_c[5] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_790(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,790};
  modelica_boolean tmp54;
  tmp54 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[577] /* particleReceiver1D.tau_c[4] variable */ = (tmp54?0.0:exp((-1.5) * ((data->localData[0]->realVars[422] /* particleReceiver1D.phi[5] variable */) * (DIVISION_SIM(data->localData[0]->realVars[545] /* particleReceiver1D.t_c[5] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 791
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[4] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[5] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[5] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[4])
*/
void ParticleReceiver1DCalculator_eqFunction_791(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,791};
  modelica_boolean tmp55;
  modelica_real tmp56;
  modelica_boolean tmp57;
  modelica_real tmp58;
  tmp55 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp57 = (modelica_boolean)tmp55;
  if(tmp57)
  {
    tmp58 = 0.0;
  }
  else
  {
    tmp56 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp58 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[422] /* particleReceiver1D.phi[5] variable */)),(3.141592653589793) * ((tmp56 * tmp56 * tmp56)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[545] /* particleReceiver1D.t_c[5] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[577] /* particleReceiver1D.tau_c[4] variable */,"1.0 - particleReceiver1D.tau_c[4]",equationIndexes);
  }
  data->localData[0]->realVars[234] /* particleReceiver1D.abs_c[4] variable */ = tmp58;
  TRACE_POP
}
/*
equation index: 792
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[4] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[5] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[5] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[4])
*/
void ParticleReceiver1DCalculator_eqFunction_792(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,792};
  modelica_boolean tmp59;
  modelica_real tmp60;
  modelica_boolean tmp61;
  modelica_real tmp62;
  tmp59 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp61 = (modelica_boolean)tmp59;
  if(tmp61)
  {
    tmp62 = 0.0;
  }
  else
  {
    tmp60 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp62 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[422] /* particleReceiver1D.phi[5] variable */)),(3.141592653589793) * ((tmp60 * tmp60 * tmp60)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[545] /* particleReceiver1D.t_c[5] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[577] /* particleReceiver1D.tau_c[4] variable */,"1.0 - particleReceiver1D.tau_c[4]",equationIndexes);
  }
  data->localData[0]->realVars[265] /* particleReceiver1D.eps_c[4] variable */ = tmp62;
  TRACE_POP
}
/*
equation index: 793
type: SIMPLE_ASSIGN
particleReceiver1D._vp[6] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[5] ^ 2.0 + 19.6133 * (particleReceiver1D.x[6] - particleReceiver1D.x[5])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_793(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,793};
  modelica_boolean tmp63;
  modelica_real tmp64;
  modelica_real tmp65;
  modelica_boolean tmp66;
  modelica_real tmp67;
  tmp63 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp66 = (modelica_boolean)tmp63;
  if(tmp66)
  {
    tmp64 = data->localData[0]->realVars[607] /* particleReceiver1D.vp[5] variable */;
    tmp65 = (tmp64 * tmp64) + (19.6133) * (data->localData[0]->realVars[639] /* particleReceiver1D.x[6] variable */ - data->localData[0]->realVars[638] /* particleReceiver1D.x[5] variable */);
    if(!(tmp65 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[5] ^ 2.0 + 19.6133 * (particleReceiver1D.x[6] - particleReceiver1D.x[5])) was %g should be >= 0", tmp65);
    }
    tmp67 = sqrt(tmp65);
  }
  else
  {
    tmp67 = 0.0;
  }
  data->localData[0]->realVars[608] /* particleReceiver1D.vp[6] variable */ = tmp67;
  TRACE_POP
}
/*
equation index: 794
type: SIMPLE_ASSIGN
particleReceiver1D._phi[6] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[6] * particleReceiver1D.vp[6] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_794(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,794};
  modelica_boolean tmp68;
  tmp68 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[423] /* particleReceiver1D.phi[6] variable */ = (tmp68?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[546] /* particleReceiver1D.t_c[6] variable */)) * (data->localData[0]->realVars[608] /* particleReceiver1D.vp[6] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[6] * particleReceiver1D.vp[6] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 795
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[5] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[6] * particleReceiver1D.t_c[6] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_795(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,795};
  modelica_boolean tmp69;
  tmp69 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[578] /* particleReceiver1D.tau_c[5] variable */ = (tmp69?0.0:exp((-1.5) * ((data->localData[0]->realVars[423] /* particleReceiver1D.phi[6] variable */) * (DIVISION_SIM(data->localData[0]->realVars[546] /* particleReceiver1D.t_c[6] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 796
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[5] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[6] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[6] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[5])
*/
void ParticleReceiver1DCalculator_eqFunction_796(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,796};
  modelica_boolean tmp70;
  modelica_real tmp71;
  modelica_boolean tmp72;
  modelica_real tmp73;
  tmp70 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp72 = (modelica_boolean)tmp70;
  if(tmp72)
  {
    tmp73 = 0.0;
  }
  else
  {
    tmp71 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp73 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[423] /* particleReceiver1D.phi[6] variable */)),(3.141592653589793) * ((tmp71 * tmp71 * tmp71)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[546] /* particleReceiver1D.t_c[6] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[578] /* particleReceiver1D.tau_c[5] variable */,"1.0 - particleReceiver1D.tau_c[5]",equationIndexes);
  }
  data->localData[0]->realVars[235] /* particleReceiver1D.abs_c[5] variable */ = tmp73;
  TRACE_POP
}
/*
equation index: 797
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[5] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[6] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[6] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[5])
*/
void ParticleReceiver1DCalculator_eqFunction_797(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,797};
  modelica_boolean tmp74;
  modelica_real tmp75;
  modelica_boolean tmp76;
  modelica_real tmp77;
  tmp74 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp76 = (modelica_boolean)tmp74;
  if(tmp76)
  {
    tmp77 = 0.0;
  }
  else
  {
    tmp75 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp77 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[423] /* particleReceiver1D.phi[6] variable */)),(3.141592653589793) * ((tmp75 * tmp75 * tmp75)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[546] /* particleReceiver1D.t_c[6] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[578] /* particleReceiver1D.tau_c[5] variable */,"1.0 - particleReceiver1D.tau_c[5]",equationIndexes);
  }
  data->localData[0]->realVars[266] /* particleReceiver1D.eps_c[5] variable */ = tmp77;
  TRACE_POP
}
/*
equation index: 798
type: SIMPLE_ASSIGN
particleReceiver1D._vp[7] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[6] ^ 2.0 + 19.6133 * (particleReceiver1D.x[7] - particleReceiver1D.x[6])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_798(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,798};
  modelica_boolean tmp78;
  modelica_real tmp79;
  modelica_real tmp80;
  modelica_boolean tmp81;
  modelica_real tmp82;
  tmp78 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp81 = (modelica_boolean)tmp78;
  if(tmp81)
  {
    tmp79 = data->localData[0]->realVars[608] /* particleReceiver1D.vp[6] variable */;
    tmp80 = (tmp79 * tmp79) + (19.6133) * (data->localData[0]->realVars[640] /* particleReceiver1D.x[7] variable */ - data->localData[0]->realVars[639] /* particleReceiver1D.x[6] variable */);
    if(!(tmp80 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[6] ^ 2.0 + 19.6133 * (particleReceiver1D.x[7] - particleReceiver1D.x[6])) was %g should be >= 0", tmp80);
    }
    tmp82 = sqrt(tmp80);
  }
  else
  {
    tmp82 = 0.0;
  }
  data->localData[0]->realVars[609] /* particleReceiver1D.vp[7] variable */ = tmp82;
  TRACE_POP
}
/*
equation index: 799
type: SIMPLE_ASSIGN
particleReceiver1D._phi[7] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[7] * particleReceiver1D.vp[7] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_799(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,799};
  modelica_boolean tmp83;
  tmp83 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[424] /* particleReceiver1D.phi[7] variable */ = (tmp83?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[547] /* particleReceiver1D.t_c[7] variable */)) * (data->localData[0]->realVars[609] /* particleReceiver1D.vp[7] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[7] * particleReceiver1D.vp[7] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 800
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[6] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[7] * particleReceiver1D.t_c[7] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_800(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,800};
  modelica_boolean tmp84;
  tmp84 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[579] /* particleReceiver1D.tau_c[6] variable */ = (tmp84?0.0:exp((-1.5) * ((data->localData[0]->realVars[424] /* particleReceiver1D.phi[7] variable */) * (DIVISION_SIM(data->localData[0]->realVars[547] /* particleReceiver1D.t_c[7] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 801
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[6] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[7] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[7] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[6])
*/
void ParticleReceiver1DCalculator_eqFunction_801(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,801};
  modelica_boolean tmp85;
  modelica_real tmp86;
  modelica_boolean tmp87;
  modelica_real tmp88;
  tmp85 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp87 = (modelica_boolean)tmp85;
  if(tmp87)
  {
    tmp88 = 0.0;
  }
  else
  {
    tmp86 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp88 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[424] /* particleReceiver1D.phi[7] variable */)),(3.141592653589793) * ((tmp86 * tmp86 * tmp86)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[547] /* particleReceiver1D.t_c[7] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[579] /* particleReceiver1D.tau_c[6] variable */,"1.0 - particleReceiver1D.tau_c[6]",equationIndexes);
  }
  data->localData[0]->realVars[236] /* particleReceiver1D.abs_c[6] variable */ = tmp88;
  TRACE_POP
}
/*
equation index: 802
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[6] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[7] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[7] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[6])
*/
void ParticleReceiver1DCalculator_eqFunction_802(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,802};
  modelica_boolean tmp89;
  modelica_real tmp90;
  modelica_boolean tmp91;
  modelica_real tmp92;
  tmp89 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp91 = (modelica_boolean)tmp89;
  if(tmp91)
  {
    tmp92 = 0.0;
  }
  else
  {
    tmp90 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp92 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[424] /* particleReceiver1D.phi[7] variable */)),(3.141592653589793) * ((tmp90 * tmp90 * tmp90)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[547] /* particleReceiver1D.t_c[7] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[579] /* particleReceiver1D.tau_c[6] variable */,"1.0 - particleReceiver1D.tau_c[6]",equationIndexes);
  }
  data->localData[0]->realVars[267] /* particleReceiver1D.eps_c[6] variable */ = tmp92;
  TRACE_POP
}
/*
equation index: 803
type: SIMPLE_ASSIGN
particleReceiver1D._vp[8] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[7] ^ 2.0 + 19.6133 * (particleReceiver1D.x[8] - particleReceiver1D.x[7])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_803(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,803};
  modelica_boolean tmp93;
  modelica_real tmp94;
  modelica_real tmp95;
  modelica_boolean tmp96;
  modelica_real tmp97;
  tmp93 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp96 = (modelica_boolean)tmp93;
  if(tmp96)
  {
    tmp94 = data->localData[0]->realVars[609] /* particleReceiver1D.vp[7] variable */;
    tmp95 = (tmp94 * tmp94) + (19.6133) * (data->localData[0]->realVars[641] /* particleReceiver1D.x[8] variable */ - data->localData[0]->realVars[640] /* particleReceiver1D.x[7] variable */);
    if(!(tmp95 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[7] ^ 2.0 + 19.6133 * (particleReceiver1D.x[8] - particleReceiver1D.x[7])) was %g should be >= 0", tmp95);
    }
    tmp97 = sqrt(tmp95);
  }
  else
  {
    tmp97 = 0.0;
  }
  data->localData[0]->realVars[610] /* particleReceiver1D.vp[8] variable */ = tmp97;
  TRACE_POP
}
/*
equation index: 804
type: SIMPLE_ASSIGN
particleReceiver1D._phi[8] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[8] * particleReceiver1D.vp[8] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_804(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,804};
  modelica_boolean tmp98;
  tmp98 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[425] /* particleReceiver1D.phi[8] variable */ = (tmp98?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[548] /* particleReceiver1D.t_c[8] variable */)) * (data->localData[0]->realVars[610] /* particleReceiver1D.vp[8] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[8] * particleReceiver1D.vp[8] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 805
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[7] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[8] * particleReceiver1D.t_c[8] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_805(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,805};
  modelica_boolean tmp99;
  tmp99 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[580] /* particleReceiver1D.tau_c[7] variable */ = (tmp99?0.0:exp((-1.5) * ((data->localData[0]->realVars[425] /* particleReceiver1D.phi[8] variable */) * (DIVISION_SIM(data->localData[0]->realVars[548] /* particleReceiver1D.t_c[8] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 806
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[7] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[8] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[8] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[7])
*/
void ParticleReceiver1DCalculator_eqFunction_806(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,806};
  modelica_boolean tmp100;
  modelica_real tmp101;
  modelica_boolean tmp102;
  modelica_real tmp103;
  tmp100 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp102 = (modelica_boolean)tmp100;
  if(tmp102)
  {
    tmp103 = 0.0;
  }
  else
  {
    tmp101 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp103 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[425] /* particleReceiver1D.phi[8] variable */)),(3.141592653589793) * ((tmp101 * tmp101 * tmp101)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[548] /* particleReceiver1D.t_c[8] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[580] /* particleReceiver1D.tau_c[7] variable */,"1.0 - particleReceiver1D.tau_c[7]",equationIndexes);
  }
  data->localData[0]->realVars[237] /* particleReceiver1D.abs_c[7] variable */ = tmp103;
  TRACE_POP
}
/*
equation index: 807
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[7] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[8] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[8] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[7])
*/
void ParticleReceiver1DCalculator_eqFunction_807(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,807};
  modelica_boolean tmp104;
  modelica_real tmp105;
  modelica_boolean tmp106;
  modelica_real tmp107;
  tmp104 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp106 = (modelica_boolean)tmp104;
  if(tmp106)
  {
    tmp107 = 0.0;
  }
  else
  {
    tmp105 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp107 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[425] /* particleReceiver1D.phi[8] variable */)),(3.141592653589793) * ((tmp105 * tmp105 * tmp105)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[548] /* particleReceiver1D.t_c[8] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[580] /* particleReceiver1D.tau_c[7] variable */,"1.0 - particleReceiver1D.tau_c[7]",equationIndexes);
  }
  data->localData[0]->realVars[268] /* particleReceiver1D.eps_c[7] variable */ = tmp107;
  TRACE_POP
}
/*
equation index: 808
type: SIMPLE_ASSIGN
particleReceiver1D._vp[9] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[8] ^ 2.0 + 19.6133 * (particleReceiver1D.x[9] - particleReceiver1D.x[8])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_808(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,808};
  modelica_boolean tmp108;
  modelica_real tmp109;
  modelica_real tmp110;
  modelica_boolean tmp111;
  modelica_real tmp112;
  tmp108 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp111 = (modelica_boolean)tmp108;
  if(tmp111)
  {
    tmp109 = data->localData[0]->realVars[610] /* particleReceiver1D.vp[8] variable */;
    tmp110 = (tmp109 * tmp109) + (19.6133) * (data->localData[0]->realVars[642] /* particleReceiver1D.x[9] variable */ - data->localData[0]->realVars[641] /* particleReceiver1D.x[8] variable */);
    if(!(tmp110 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[8] ^ 2.0 + 19.6133 * (particleReceiver1D.x[9] - particleReceiver1D.x[8])) was %g should be >= 0", tmp110);
    }
    tmp112 = sqrt(tmp110);
  }
  else
  {
    tmp112 = 0.0;
  }
  data->localData[0]->realVars[611] /* particleReceiver1D.vp[9] variable */ = tmp112;
  TRACE_POP
}
/*
equation index: 809
type: SIMPLE_ASSIGN
particleReceiver1D._phi[9] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[9] * particleReceiver1D.vp[9] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_809(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,809};
  modelica_boolean tmp113;
  tmp113 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[426] /* particleReceiver1D.phi[9] variable */ = (tmp113?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[549] /* particleReceiver1D.t_c[9] variable */)) * (data->localData[0]->realVars[611] /* particleReceiver1D.vp[9] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[9] * particleReceiver1D.vp[9] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 810
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[8] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[9] * particleReceiver1D.t_c[9] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_810(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,810};
  modelica_boolean tmp114;
  tmp114 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[581] /* particleReceiver1D.tau_c[8] variable */ = (tmp114?0.0:exp((-1.5) * ((data->localData[0]->realVars[426] /* particleReceiver1D.phi[9] variable */) * (DIVISION_SIM(data->localData[0]->realVars[549] /* particleReceiver1D.t_c[9] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 811
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[8] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[9] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[9] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[8])
*/
void ParticleReceiver1DCalculator_eqFunction_811(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,811};
  modelica_boolean tmp115;
  modelica_real tmp116;
  modelica_boolean tmp117;
  modelica_real tmp118;
  tmp115 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp117 = (modelica_boolean)tmp115;
  if(tmp117)
  {
    tmp118 = 0.0;
  }
  else
  {
    tmp116 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp118 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[426] /* particleReceiver1D.phi[9] variable */)),(3.141592653589793) * ((tmp116 * tmp116 * tmp116)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[549] /* particleReceiver1D.t_c[9] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[581] /* particleReceiver1D.tau_c[8] variable */,"1.0 - particleReceiver1D.tau_c[8]",equationIndexes);
  }
  data->localData[0]->realVars[238] /* particleReceiver1D.abs_c[8] variable */ = tmp118;
  TRACE_POP
}
/*
equation index: 812
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[8] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[9] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[9] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[8])
*/
void ParticleReceiver1DCalculator_eqFunction_812(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,812};
  modelica_boolean tmp119;
  modelica_real tmp120;
  modelica_boolean tmp121;
  modelica_real tmp122;
  tmp119 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp121 = (modelica_boolean)tmp119;
  if(tmp121)
  {
    tmp122 = 0.0;
  }
  else
  {
    tmp120 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp122 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[426] /* particleReceiver1D.phi[9] variable */)),(3.141592653589793) * ((tmp120 * tmp120 * tmp120)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[549] /* particleReceiver1D.t_c[9] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[581] /* particleReceiver1D.tau_c[8] variable */,"1.0 - particleReceiver1D.tau_c[8]",equationIndexes);
  }
  data->localData[0]->realVars[269] /* particleReceiver1D.eps_c[8] variable */ = tmp122;
  TRACE_POP
}
/*
equation index: 813
type: SIMPLE_ASSIGN
particleReceiver1D._vp[10] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[9] ^ 2.0 + 19.6133 * (particleReceiver1D.x[10] - particleReceiver1D.x[9])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_813(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,813};
  modelica_boolean tmp123;
  modelica_real tmp124;
  modelica_real tmp125;
  modelica_boolean tmp126;
  modelica_real tmp127;
  tmp123 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp126 = (modelica_boolean)tmp123;
  if(tmp126)
  {
    tmp124 = data->localData[0]->realVars[611] /* particleReceiver1D.vp[9] variable */;
    tmp125 = (tmp124 * tmp124) + (19.6133) * (data->localData[0]->realVars[643] /* particleReceiver1D.x[10] variable */ - data->localData[0]->realVars[642] /* particleReceiver1D.x[9] variable */);
    if(!(tmp125 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[9] ^ 2.0 + 19.6133 * (particleReceiver1D.x[10] - particleReceiver1D.x[9])) was %g should be >= 0", tmp125);
    }
    tmp127 = sqrt(tmp125);
  }
  else
  {
    tmp127 = 0.0;
  }
  data->localData[0]->realVars[612] /* particleReceiver1D.vp[10] variable */ = tmp127;
  TRACE_POP
}
/*
equation index: 814
type: SIMPLE_ASSIGN
particleReceiver1D._phi[10] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[10] * particleReceiver1D.vp[10] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_814(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,814};
  modelica_boolean tmp128;
  tmp128 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[427] /* particleReceiver1D.phi[10] variable */ = (tmp128?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[550] /* particleReceiver1D.t_c[10] variable */)) * (data->localData[0]->realVars[612] /* particleReceiver1D.vp[10] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[10] * particleReceiver1D.vp[10] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 815
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[9] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[10] * particleReceiver1D.t_c[10] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_815(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,815};
  modelica_boolean tmp129;
  tmp129 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[582] /* particleReceiver1D.tau_c[9] variable */ = (tmp129?0.0:exp((-1.5) * ((data->localData[0]->realVars[427] /* particleReceiver1D.phi[10] variable */) * (DIVISION_SIM(data->localData[0]->realVars[550] /* particleReceiver1D.t_c[10] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 816
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[9] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[10] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[10] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[9])
*/
void ParticleReceiver1DCalculator_eqFunction_816(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,816};
  modelica_boolean tmp130;
  modelica_real tmp131;
  modelica_boolean tmp132;
  modelica_real tmp133;
  tmp130 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp132 = (modelica_boolean)tmp130;
  if(tmp132)
  {
    tmp133 = 0.0;
  }
  else
  {
    tmp131 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp133 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[427] /* particleReceiver1D.phi[10] variable */)),(3.141592653589793) * ((tmp131 * tmp131 * tmp131)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[550] /* particleReceiver1D.t_c[10] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[582] /* particleReceiver1D.tau_c[9] variable */,"1.0 - particleReceiver1D.tau_c[9]",equationIndexes);
  }
  data->localData[0]->realVars[239] /* particleReceiver1D.abs_c[9] variable */ = tmp133;
  TRACE_POP
}
/*
equation index: 817
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[9] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[10] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[10] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[9])
*/
void ParticleReceiver1DCalculator_eqFunction_817(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,817};
  modelica_boolean tmp134;
  modelica_real tmp135;
  modelica_boolean tmp136;
  modelica_real tmp137;
  tmp134 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp136 = (modelica_boolean)tmp134;
  if(tmp136)
  {
    tmp137 = 0.0;
  }
  else
  {
    tmp135 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp137 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[427] /* particleReceiver1D.phi[10] variable */)),(3.141592653589793) * ((tmp135 * tmp135 * tmp135)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[550] /* particleReceiver1D.t_c[10] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[582] /* particleReceiver1D.tau_c[9] variable */,"1.0 - particleReceiver1D.tau_c[9]",equationIndexes);
  }
  data->localData[0]->realVars[270] /* particleReceiver1D.eps_c[9] variable */ = tmp137;
  TRACE_POP
}
/*
equation index: 818
type: SIMPLE_ASSIGN
particleReceiver1D._vp[11] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[10] ^ 2.0 + 19.6133 * (particleReceiver1D.x[11] - particleReceiver1D.x[10])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_818(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,818};
  modelica_boolean tmp138;
  modelica_real tmp139;
  modelica_real tmp140;
  modelica_boolean tmp141;
  modelica_real tmp142;
  tmp138 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp141 = (modelica_boolean)tmp138;
  if(tmp141)
  {
    tmp139 = data->localData[0]->realVars[612] /* particleReceiver1D.vp[10] variable */;
    tmp140 = (tmp139 * tmp139) + (19.6133) * (data->localData[0]->realVars[644] /* particleReceiver1D.x[11] variable */ - data->localData[0]->realVars[643] /* particleReceiver1D.x[10] variable */);
    if(!(tmp140 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[10] ^ 2.0 + 19.6133 * (particleReceiver1D.x[11] - particleReceiver1D.x[10])) was %g should be >= 0", tmp140);
    }
    tmp142 = sqrt(tmp140);
  }
  else
  {
    tmp142 = 0.0;
  }
  data->localData[0]->realVars[613] /* particleReceiver1D.vp[11] variable */ = tmp142;
  TRACE_POP
}
/*
equation index: 819
type: SIMPLE_ASSIGN
particleReceiver1D._phi[11] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[11] * particleReceiver1D.vp[11] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_819(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,819};
  modelica_boolean tmp143;
  tmp143 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[428] /* particleReceiver1D.phi[11] variable */ = (tmp143?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[551] /* particleReceiver1D.t_c[11] variable */)) * (data->localData[0]->realVars[613] /* particleReceiver1D.vp[11] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[11] * particleReceiver1D.vp[11] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 820
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[10] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[11] * particleReceiver1D.t_c[11] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_820(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,820};
  modelica_boolean tmp144;
  tmp144 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[583] /* particleReceiver1D.tau_c[10] variable */ = (tmp144?0.0:exp((-1.5) * ((data->localData[0]->realVars[428] /* particleReceiver1D.phi[11] variable */) * (DIVISION_SIM(data->localData[0]->realVars[551] /* particleReceiver1D.t_c[11] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 821
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[10] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[11] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[11] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[10])
*/
void ParticleReceiver1DCalculator_eqFunction_821(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,821};
  modelica_boolean tmp145;
  modelica_real tmp146;
  modelica_boolean tmp147;
  modelica_real tmp148;
  tmp145 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp147 = (modelica_boolean)tmp145;
  if(tmp147)
  {
    tmp148 = 0.0;
  }
  else
  {
    tmp146 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp148 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[428] /* particleReceiver1D.phi[11] variable */)),(3.141592653589793) * ((tmp146 * tmp146 * tmp146)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[551] /* particleReceiver1D.t_c[11] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[583] /* particleReceiver1D.tau_c[10] variable */,"1.0 - particleReceiver1D.tau_c[10]",equationIndexes);
  }
  data->localData[0]->realVars[240] /* particleReceiver1D.abs_c[10] variable */ = tmp148;
  TRACE_POP
}
/*
equation index: 822
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[10] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[11] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[11] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[10])
*/
void ParticleReceiver1DCalculator_eqFunction_822(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,822};
  modelica_boolean tmp149;
  modelica_real tmp150;
  modelica_boolean tmp151;
  modelica_real tmp152;
  tmp149 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp151 = (modelica_boolean)tmp149;
  if(tmp151)
  {
    tmp152 = 0.0;
  }
  else
  {
    tmp150 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp152 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[428] /* particleReceiver1D.phi[11] variable */)),(3.141592653589793) * ((tmp150 * tmp150 * tmp150)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[551] /* particleReceiver1D.t_c[11] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[583] /* particleReceiver1D.tau_c[10] variable */,"1.0 - particleReceiver1D.tau_c[10]",equationIndexes);
  }
  data->localData[0]->realVars[271] /* particleReceiver1D.eps_c[10] variable */ = tmp152;
  TRACE_POP
}
/*
equation index: 823
type: SIMPLE_ASSIGN
particleReceiver1D._vp[12] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[11] ^ 2.0 + 19.6133 * (particleReceiver1D.x[12] - particleReceiver1D.x[11])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_823(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,823};
  modelica_boolean tmp153;
  modelica_real tmp154;
  modelica_real tmp155;
  modelica_boolean tmp156;
  modelica_real tmp157;
  tmp153 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp156 = (modelica_boolean)tmp153;
  if(tmp156)
  {
    tmp154 = data->localData[0]->realVars[613] /* particleReceiver1D.vp[11] variable */;
    tmp155 = (tmp154 * tmp154) + (19.6133) * (data->localData[0]->realVars[645] /* particleReceiver1D.x[12] variable */ - data->localData[0]->realVars[644] /* particleReceiver1D.x[11] variable */);
    if(!(tmp155 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[11] ^ 2.0 + 19.6133 * (particleReceiver1D.x[12] - particleReceiver1D.x[11])) was %g should be >= 0", tmp155);
    }
    tmp157 = sqrt(tmp155);
  }
  else
  {
    tmp157 = 0.0;
  }
  data->localData[0]->realVars[614] /* particleReceiver1D.vp[12] variable */ = tmp157;
  TRACE_POP
}
/*
equation index: 824
type: SIMPLE_ASSIGN
particleReceiver1D._phi[12] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[12] * particleReceiver1D.vp[12] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_824(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,824};
  modelica_boolean tmp158;
  tmp158 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[429] /* particleReceiver1D.phi[12] variable */ = (tmp158?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[552] /* particleReceiver1D.t_c[12] variable */)) * (data->localData[0]->realVars[614] /* particleReceiver1D.vp[12] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[12] * particleReceiver1D.vp[12] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 825
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[11] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[12] * particleReceiver1D.t_c[12] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_825(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,825};
  modelica_boolean tmp159;
  tmp159 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[584] /* particleReceiver1D.tau_c[11] variable */ = (tmp159?0.0:exp((-1.5) * ((data->localData[0]->realVars[429] /* particleReceiver1D.phi[12] variable */) * (DIVISION_SIM(data->localData[0]->realVars[552] /* particleReceiver1D.t_c[12] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 826
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[11] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[12] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[12] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[11])
*/
void ParticleReceiver1DCalculator_eqFunction_826(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,826};
  modelica_boolean tmp160;
  modelica_real tmp161;
  modelica_boolean tmp162;
  modelica_real tmp163;
  tmp160 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp162 = (modelica_boolean)tmp160;
  if(tmp162)
  {
    tmp163 = 0.0;
  }
  else
  {
    tmp161 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp163 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[429] /* particleReceiver1D.phi[12] variable */)),(3.141592653589793) * ((tmp161 * tmp161 * tmp161)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[552] /* particleReceiver1D.t_c[12] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[584] /* particleReceiver1D.tau_c[11] variable */,"1.0 - particleReceiver1D.tau_c[11]",equationIndexes);
  }
  data->localData[0]->realVars[241] /* particleReceiver1D.abs_c[11] variable */ = tmp163;
  TRACE_POP
}
/*
equation index: 827
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[11] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[12] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[12] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[11])
*/
void ParticleReceiver1DCalculator_eqFunction_827(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,827};
  modelica_boolean tmp164;
  modelica_real tmp165;
  modelica_boolean tmp166;
  modelica_real tmp167;
  tmp164 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp166 = (modelica_boolean)tmp164;
  if(tmp166)
  {
    tmp167 = 0.0;
  }
  else
  {
    tmp165 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp167 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[429] /* particleReceiver1D.phi[12] variable */)),(3.141592653589793) * ((tmp165 * tmp165 * tmp165)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[552] /* particleReceiver1D.t_c[12] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[584] /* particleReceiver1D.tau_c[11] variable */,"1.0 - particleReceiver1D.tau_c[11]",equationIndexes);
  }
  data->localData[0]->realVars[272] /* particleReceiver1D.eps_c[11] variable */ = tmp167;
  TRACE_POP
}
/*
equation index: 828
type: SIMPLE_ASSIGN
particleReceiver1D._vp[13] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[12] ^ 2.0 + 19.6133 * (particleReceiver1D.x[13] - particleReceiver1D.x[12])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_828(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,828};
  modelica_boolean tmp168;
  modelica_real tmp169;
  modelica_real tmp170;
  modelica_boolean tmp171;
  modelica_real tmp172;
  tmp168 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp171 = (modelica_boolean)tmp168;
  if(tmp171)
  {
    tmp169 = data->localData[0]->realVars[614] /* particleReceiver1D.vp[12] variable */;
    tmp170 = (tmp169 * tmp169) + (19.6133) * (data->localData[0]->realVars[646] /* particleReceiver1D.x[13] variable */ - data->localData[0]->realVars[645] /* particleReceiver1D.x[12] variable */);
    if(!(tmp170 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[12] ^ 2.0 + 19.6133 * (particleReceiver1D.x[13] - particleReceiver1D.x[12])) was %g should be >= 0", tmp170);
    }
    tmp172 = sqrt(tmp170);
  }
  else
  {
    tmp172 = 0.0;
  }
  data->localData[0]->realVars[615] /* particleReceiver1D.vp[13] variable */ = tmp172;
  TRACE_POP
}
/*
equation index: 829
type: SIMPLE_ASSIGN
particleReceiver1D._phi[13] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[13] * particleReceiver1D.vp[13] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_829(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,829};
  modelica_boolean tmp173;
  tmp173 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[430] /* particleReceiver1D.phi[13] variable */ = (tmp173?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[553] /* particleReceiver1D.t_c[13] variable */)) * (data->localData[0]->realVars[615] /* particleReceiver1D.vp[13] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[13] * particleReceiver1D.vp[13] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 830
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[12] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[13] * particleReceiver1D.t_c[13] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_830(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,830};
  modelica_boolean tmp174;
  tmp174 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[585] /* particleReceiver1D.tau_c[12] variable */ = (tmp174?0.0:exp((-1.5) * ((data->localData[0]->realVars[430] /* particleReceiver1D.phi[13] variable */) * (DIVISION_SIM(data->localData[0]->realVars[553] /* particleReceiver1D.t_c[13] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 831
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[12] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[13] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[13] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[12])
*/
void ParticleReceiver1DCalculator_eqFunction_831(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,831};
  modelica_boolean tmp175;
  modelica_real tmp176;
  modelica_boolean tmp177;
  modelica_real tmp178;
  tmp175 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp177 = (modelica_boolean)tmp175;
  if(tmp177)
  {
    tmp178 = 0.0;
  }
  else
  {
    tmp176 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp178 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[430] /* particleReceiver1D.phi[13] variable */)),(3.141592653589793) * ((tmp176 * tmp176 * tmp176)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[553] /* particleReceiver1D.t_c[13] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[585] /* particleReceiver1D.tau_c[12] variable */,"1.0 - particleReceiver1D.tau_c[12]",equationIndexes);
  }
  data->localData[0]->realVars[242] /* particleReceiver1D.abs_c[12] variable */ = tmp178;
  TRACE_POP
}
/*
equation index: 832
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[12] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[13] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[13] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[12])
*/
void ParticleReceiver1DCalculator_eqFunction_832(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,832};
  modelica_boolean tmp179;
  modelica_real tmp180;
  modelica_boolean tmp181;
  modelica_real tmp182;
  tmp179 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp181 = (modelica_boolean)tmp179;
  if(tmp181)
  {
    tmp182 = 0.0;
  }
  else
  {
    tmp180 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp182 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[430] /* particleReceiver1D.phi[13] variable */)),(3.141592653589793) * ((tmp180 * tmp180 * tmp180)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[553] /* particleReceiver1D.t_c[13] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[585] /* particleReceiver1D.tau_c[12] variable */,"1.0 - particleReceiver1D.tau_c[12]",equationIndexes);
  }
  data->localData[0]->realVars[273] /* particleReceiver1D.eps_c[12] variable */ = tmp182;
  TRACE_POP
}
/*
equation index: 833
type: SIMPLE_ASSIGN
particleReceiver1D._vp[14] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[13] ^ 2.0 + 19.6133 * (particleReceiver1D.x[14] - particleReceiver1D.x[13])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_833(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,833};
  modelica_boolean tmp183;
  modelica_real tmp184;
  modelica_real tmp185;
  modelica_boolean tmp186;
  modelica_real tmp187;
  tmp183 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp186 = (modelica_boolean)tmp183;
  if(tmp186)
  {
    tmp184 = data->localData[0]->realVars[615] /* particleReceiver1D.vp[13] variable */;
    tmp185 = (tmp184 * tmp184) + (19.6133) * (data->localData[0]->realVars[647] /* particleReceiver1D.x[14] variable */ - data->localData[0]->realVars[646] /* particleReceiver1D.x[13] variable */);
    if(!(tmp185 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[13] ^ 2.0 + 19.6133 * (particleReceiver1D.x[14] - particleReceiver1D.x[13])) was %g should be >= 0", tmp185);
    }
    tmp187 = sqrt(tmp185);
  }
  else
  {
    tmp187 = 0.0;
  }
  data->localData[0]->realVars[616] /* particleReceiver1D.vp[14] variable */ = tmp187;
  TRACE_POP
}
/*
equation index: 834
type: SIMPLE_ASSIGN
particleReceiver1D._phi[14] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[14] * particleReceiver1D.vp[14] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_834(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,834};
  modelica_boolean tmp188;
  tmp188 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[431] /* particleReceiver1D.phi[14] variable */ = (tmp188?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[554] /* particleReceiver1D.t_c[14] variable */)) * (data->localData[0]->realVars[616] /* particleReceiver1D.vp[14] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[14] * particleReceiver1D.vp[14] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 835
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[13] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[14] * particleReceiver1D.t_c[14] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_835(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,835};
  modelica_boolean tmp189;
  tmp189 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[586] /* particleReceiver1D.tau_c[13] variable */ = (tmp189?0.0:exp((-1.5) * ((data->localData[0]->realVars[431] /* particleReceiver1D.phi[14] variable */) * (DIVISION_SIM(data->localData[0]->realVars[554] /* particleReceiver1D.t_c[14] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 836
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[13] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[14] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[14] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[13])
*/
void ParticleReceiver1DCalculator_eqFunction_836(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,836};
  modelica_boolean tmp190;
  modelica_real tmp191;
  modelica_boolean tmp192;
  modelica_real tmp193;
  tmp190 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp192 = (modelica_boolean)tmp190;
  if(tmp192)
  {
    tmp193 = 0.0;
  }
  else
  {
    tmp191 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp193 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[431] /* particleReceiver1D.phi[14] variable */)),(3.141592653589793) * ((tmp191 * tmp191 * tmp191)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[554] /* particleReceiver1D.t_c[14] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[586] /* particleReceiver1D.tau_c[13] variable */,"1.0 - particleReceiver1D.tau_c[13]",equationIndexes);
  }
  data->localData[0]->realVars[243] /* particleReceiver1D.abs_c[13] variable */ = tmp193;
  TRACE_POP
}
/*
equation index: 837
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[13] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[14] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[14] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[13])
*/
void ParticleReceiver1DCalculator_eqFunction_837(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,837};
  modelica_boolean tmp194;
  modelica_real tmp195;
  modelica_boolean tmp196;
  modelica_real tmp197;
  tmp194 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp196 = (modelica_boolean)tmp194;
  if(tmp196)
  {
    tmp197 = 0.0;
  }
  else
  {
    tmp195 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp197 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[431] /* particleReceiver1D.phi[14] variable */)),(3.141592653589793) * ((tmp195 * tmp195 * tmp195)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[554] /* particleReceiver1D.t_c[14] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[586] /* particleReceiver1D.tau_c[13] variable */,"1.0 - particleReceiver1D.tau_c[13]",equationIndexes);
  }
  data->localData[0]->realVars[274] /* particleReceiver1D.eps_c[13] variable */ = tmp197;
  TRACE_POP
}
/*
equation index: 838
type: SIMPLE_ASSIGN
particleReceiver1D._vp[15] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[14] ^ 2.0 + 19.6133 * (particleReceiver1D.x[15] - particleReceiver1D.x[14])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_838(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,838};
  modelica_boolean tmp198;
  modelica_real tmp199;
  modelica_real tmp200;
  modelica_boolean tmp201;
  modelica_real tmp202;
  tmp198 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp201 = (modelica_boolean)tmp198;
  if(tmp201)
  {
    tmp199 = data->localData[0]->realVars[616] /* particleReceiver1D.vp[14] variable */;
    tmp200 = (tmp199 * tmp199) + (19.6133) * (data->localData[0]->realVars[648] /* particleReceiver1D.x[15] variable */ - data->localData[0]->realVars[647] /* particleReceiver1D.x[14] variable */);
    if(!(tmp200 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[14] ^ 2.0 + 19.6133 * (particleReceiver1D.x[15] - particleReceiver1D.x[14])) was %g should be >= 0", tmp200);
    }
    tmp202 = sqrt(tmp200);
  }
  else
  {
    tmp202 = 0.0;
  }
  data->localData[0]->realVars[617] /* particleReceiver1D.vp[15] variable */ = tmp202;
  TRACE_POP
}
/*
equation index: 839
type: SIMPLE_ASSIGN
particleReceiver1D._phi[15] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[15] * particleReceiver1D.vp[15] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_839(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,839};
  modelica_boolean tmp203;
  tmp203 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[432] /* particleReceiver1D.phi[15] variable */ = (tmp203?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[555] /* particleReceiver1D.t_c[15] variable */)) * (data->localData[0]->realVars[617] /* particleReceiver1D.vp[15] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[15] * particleReceiver1D.vp[15] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 840
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[14] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[15] * particleReceiver1D.t_c[15] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_840(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,840};
  modelica_boolean tmp204;
  tmp204 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[587] /* particleReceiver1D.tau_c[14] variable */ = (tmp204?0.0:exp((-1.5) * ((data->localData[0]->realVars[432] /* particleReceiver1D.phi[15] variable */) * (DIVISION_SIM(data->localData[0]->realVars[555] /* particleReceiver1D.t_c[15] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 841
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[14] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[15] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[15] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[14])
*/
void ParticleReceiver1DCalculator_eqFunction_841(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,841};
  modelica_boolean tmp205;
  modelica_real tmp206;
  modelica_boolean tmp207;
  modelica_real tmp208;
  tmp205 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp207 = (modelica_boolean)tmp205;
  if(tmp207)
  {
    tmp208 = 0.0;
  }
  else
  {
    tmp206 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp208 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[432] /* particleReceiver1D.phi[15] variable */)),(3.141592653589793) * ((tmp206 * tmp206 * tmp206)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[555] /* particleReceiver1D.t_c[15] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[587] /* particleReceiver1D.tau_c[14] variable */,"1.0 - particleReceiver1D.tau_c[14]",equationIndexes);
  }
  data->localData[0]->realVars[244] /* particleReceiver1D.abs_c[14] variable */ = tmp208;
  TRACE_POP
}
/*
equation index: 842
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[14] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[15] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[15] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[14])
*/
void ParticleReceiver1DCalculator_eqFunction_842(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,842};
  modelica_boolean tmp209;
  modelica_real tmp210;
  modelica_boolean tmp211;
  modelica_real tmp212;
  tmp209 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp211 = (modelica_boolean)tmp209;
  if(tmp211)
  {
    tmp212 = 0.0;
  }
  else
  {
    tmp210 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp212 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[432] /* particleReceiver1D.phi[15] variable */)),(3.141592653589793) * ((tmp210 * tmp210 * tmp210)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[555] /* particleReceiver1D.t_c[15] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[587] /* particleReceiver1D.tau_c[14] variable */,"1.0 - particleReceiver1D.tau_c[14]",equationIndexes);
  }
  data->localData[0]->realVars[275] /* particleReceiver1D.eps_c[14] variable */ = tmp212;
  TRACE_POP
}
/*
equation index: 843
type: SIMPLE_ASSIGN
particleReceiver1D._vp[16] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[15] ^ 2.0 + 19.6133 * (particleReceiver1D.x[16] - particleReceiver1D.x[15])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_843(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,843};
  modelica_boolean tmp213;
  modelica_real tmp214;
  modelica_real tmp215;
  modelica_boolean tmp216;
  modelica_real tmp217;
  tmp213 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp216 = (modelica_boolean)tmp213;
  if(tmp216)
  {
    tmp214 = data->localData[0]->realVars[617] /* particleReceiver1D.vp[15] variable */;
    tmp215 = (tmp214 * tmp214) + (19.6133) * (data->localData[0]->realVars[649] /* particleReceiver1D.x[16] variable */ - data->localData[0]->realVars[648] /* particleReceiver1D.x[15] variable */);
    if(!(tmp215 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[15] ^ 2.0 + 19.6133 * (particleReceiver1D.x[16] - particleReceiver1D.x[15])) was %g should be >= 0", tmp215);
    }
    tmp217 = sqrt(tmp215);
  }
  else
  {
    tmp217 = 0.0;
  }
  data->localData[0]->realVars[618] /* particleReceiver1D.vp[16] variable */ = tmp217;
  TRACE_POP
}
/*
equation index: 844
type: SIMPLE_ASSIGN
particleReceiver1D._phi[16] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[16] * particleReceiver1D.vp[16] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_844(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,844};
  modelica_boolean tmp218;
  tmp218 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[433] /* particleReceiver1D.phi[16] variable */ = (tmp218?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[556] /* particleReceiver1D.t_c[16] variable */)) * (data->localData[0]->realVars[618] /* particleReceiver1D.vp[16] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[16] * particleReceiver1D.vp[16] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 845
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[15] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[16] * particleReceiver1D.t_c[16] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_845(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,845};
  modelica_boolean tmp219;
  tmp219 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[588] /* particleReceiver1D.tau_c[15] variable */ = (tmp219?0.0:exp((-1.5) * ((data->localData[0]->realVars[433] /* particleReceiver1D.phi[16] variable */) * (DIVISION_SIM(data->localData[0]->realVars[556] /* particleReceiver1D.t_c[16] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 846
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[15] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[16] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[16] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[15])
*/
void ParticleReceiver1DCalculator_eqFunction_846(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,846};
  modelica_boolean tmp220;
  modelica_real tmp221;
  modelica_boolean tmp222;
  modelica_real tmp223;
  tmp220 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp222 = (modelica_boolean)tmp220;
  if(tmp222)
  {
    tmp223 = 0.0;
  }
  else
  {
    tmp221 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp223 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[433] /* particleReceiver1D.phi[16] variable */)),(3.141592653589793) * ((tmp221 * tmp221 * tmp221)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[556] /* particleReceiver1D.t_c[16] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[588] /* particleReceiver1D.tau_c[15] variable */,"1.0 - particleReceiver1D.tau_c[15]",equationIndexes);
  }
  data->localData[0]->realVars[245] /* particleReceiver1D.abs_c[15] variable */ = tmp223;
  TRACE_POP
}
/*
equation index: 847
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[15] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[16] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[16] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[15])
*/
void ParticleReceiver1DCalculator_eqFunction_847(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,847};
  modelica_boolean tmp224;
  modelica_real tmp225;
  modelica_boolean tmp226;
  modelica_real tmp227;
  tmp224 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp226 = (modelica_boolean)tmp224;
  if(tmp226)
  {
    tmp227 = 0.0;
  }
  else
  {
    tmp225 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp227 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[433] /* particleReceiver1D.phi[16] variable */)),(3.141592653589793) * ((tmp225 * tmp225 * tmp225)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[556] /* particleReceiver1D.t_c[16] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[588] /* particleReceiver1D.tau_c[15] variable */,"1.0 - particleReceiver1D.tau_c[15]",equationIndexes);
  }
  data->localData[0]->realVars[276] /* particleReceiver1D.eps_c[15] variable */ = tmp227;
  TRACE_POP
}
/*
equation index: 848
type: SIMPLE_ASSIGN
particleReceiver1D._vp[17] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[16] ^ 2.0 + 19.6133 * (particleReceiver1D.x[17] - particleReceiver1D.x[16])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_848(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,848};
  modelica_boolean tmp228;
  modelica_real tmp229;
  modelica_real tmp230;
  modelica_boolean tmp231;
  modelica_real tmp232;
  tmp228 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp231 = (modelica_boolean)tmp228;
  if(tmp231)
  {
    tmp229 = data->localData[0]->realVars[618] /* particleReceiver1D.vp[16] variable */;
    tmp230 = (tmp229 * tmp229) + (19.6133) * (data->localData[0]->realVars[650] /* particleReceiver1D.x[17] variable */ - data->localData[0]->realVars[649] /* particleReceiver1D.x[16] variable */);
    if(!(tmp230 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[16] ^ 2.0 + 19.6133 * (particleReceiver1D.x[17] - particleReceiver1D.x[16])) was %g should be >= 0", tmp230);
    }
    tmp232 = sqrt(tmp230);
  }
  else
  {
    tmp232 = 0.0;
  }
  data->localData[0]->realVars[619] /* particleReceiver1D.vp[17] variable */ = tmp232;
  TRACE_POP
}
/*
equation index: 849
type: SIMPLE_ASSIGN
particleReceiver1D._phi[17] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[17] * particleReceiver1D.vp[17] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_849(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,849};
  modelica_boolean tmp233;
  tmp233 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[434] /* particleReceiver1D.phi[17] variable */ = (tmp233?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[557] /* particleReceiver1D.t_c[17] variable */)) * (data->localData[0]->realVars[619] /* particleReceiver1D.vp[17] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[17] * particleReceiver1D.vp[17] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 850
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[16] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[17] * particleReceiver1D.t_c[17] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_850(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,850};
  modelica_boolean tmp234;
  tmp234 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[589] /* particleReceiver1D.tau_c[16] variable */ = (tmp234?0.0:exp((-1.5) * ((data->localData[0]->realVars[434] /* particleReceiver1D.phi[17] variable */) * (DIVISION_SIM(data->localData[0]->realVars[557] /* particleReceiver1D.t_c[17] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 851
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[16] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[17] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[17] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[16])
*/
void ParticleReceiver1DCalculator_eqFunction_851(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,851};
  modelica_boolean tmp235;
  modelica_real tmp236;
  modelica_boolean tmp237;
  modelica_real tmp238;
  tmp235 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp237 = (modelica_boolean)tmp235;
  if(tmp237)
  {
    tmp238 = 0.0;
  }
  else
  {
    tmp236 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp238 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[434] /* particleReceiver1D.phi[17] variable */)),(3.141592653589793) * ((tmp236 * tmp236 * tmp236)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[557] /* particleReceiver1D.t_c[17] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[589] /* particleReceiver1D.tau_c[16] variable */,"1.0 - particleReceiver1D.tau_c[16]",equationIndexes);
  }
  data->localData[0]->realVars[246] /* particleReceiver1D.abs_c[16] variable */ = tmp238;
  TRACE_POP
}
/*
equation index: 852
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[16] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[17] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[17] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[16])
*/
void ParticleReceiver1DCalculator_eqFunction_852(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,852};
  modelica_boolean tmp239;
  modelica_real tmp240;
  modelica_boolean tmp241;
  modelica_real tmp242;
  tmp239 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp241 = (modelica_boolean)tmp239;
  if(tmp241)
  {
    tmp242 = 0.0;
  }
  else
  {
    tmp240 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp242 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[434] /* particleReceiver1D.phi[17] variable */)),(3.141592653589793) * ((tmp240 * tmp240 * tmp240)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[557] /* particleReceiver1D.t_c[17] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[589] /* particleReceiver1D.tau_c[16] variable */,"1.0 - particleReceiver1D.tau_c[16]",equationIndexes);
  }
  data->localData[0]->realVars[277] /* particleReceiver1D.eps_c[16] variable */ = tmp242;
  TRACE_POP
}
/*
equation index: 853
type: SIMPLE_ASSIGN
particleReceiver1D._vp[18] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[17] ^ 2.0 + 19.6133 * (particleReceiver1D.x[18] - particleReceiver1D.x[17])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_853(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,853};
  modelica_boolean tmp243;
  modelica_real tmp244;
  modelica_real tmp245;
  modelica_boolean tmp246;
  modelica_real tmp247;
  tmp243 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp246 = (modelica_boolean)tmp243;
  if(tmp246)
  {
    tmp244 = data->localData[0]->realVars[619] /* particleReceiver1D.vp[17] variable */;
    tmp245 = (tmp244 * tmp244) + (19.6133) * (data->localData[0]->realVars[651] /* particleReceiver1D.x[18] variable */ - data->localData[0]->realVars[650] /* particleReceiver1D.x[17] variable */);
    if(!(tmp245 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[17] ^ 2.0 + 19.6133 * (particleReceiver1D.x[18] - particleReceiver1D.x[17])) was %g should be >= 0", tmp245);
    }
    tmp247 = sqrt(tmp245);
  }
  else
  {
    tmp247 = 0.0;
  }
  data->localData[0]->realVars[620] /* particleReceiver1D.vp[18] variable */ = tmp247;
  TRACE_POP
}
/*
equation index: 854
type: SIMPLE_ASSIGN
particleReceiver1D._phi[18] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[18] * particleReceiver1D.vp[18] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_854(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,854};
  modelica_boolean tmp248;
  tmp248 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[435] /* particleReceiver1D.phi[18] variable */ = (tmp248?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[558] /* particleReceiver1D.t_c[18] variable */)) * (data->localData[0]->realVars[620] /* particleReceiver1D.vp[18] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[18] * particleReceiver1D.vp[18] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 855
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[17] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[18] * particleReceiver1D.t_c[18] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_855(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,855};
  modelica_boolean tmp249;
  tmp249 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[590] /* particleReceiver1D.tau_c[17] variable */ = (tmp249?0.0:exp((-1.5) * ((data->localData[0]->realVars[435] /* particleReceiver1D.phi[18] variable */) * (DIVISION_SIM(data->localData[0]->realVars[558] /* particleReceiver1D.t_c[18] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 856
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[17] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[18] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[18] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[17])
*/
void ParticleReceiver1DCalculator_eqFunction_856(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,856};
  modelica_boolean tmp250;
  modelica_real tmp251;
  modelica_boolean tmp252;
  modelica_real tmp253;
  tmp250 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp252 = (modelica_boolean)tmp250;
  if(tmp252)
  {
    tmp253 = 0.0;
  }
  else
  {
    tmp251 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp253 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[435] /* particleReceiver1D.phi[18] variable */)),(3.141592653589793) * ((tmp251 * tmp251 * tmp251)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[558] /* particleReceiver1D.t_c[18] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[590] /* particleReceiver1D.tau_c[17] variable */,"1.0 - particleReceiver1D.tau_c[17]",equationIndexes);
  }
  data->localData[0]->realVars[247] /* particleReceiver1D.abs_c[17] variable */ = tmp253;
  TRACE_POP
}
/*
equation index: 857
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[17] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[18] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[18] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[17])
*/
void ParticleReceiver1DCalculator_eqFunction_857(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,857};
  modelica_boolean tmp254;
  modelica_real tmp255;
  modelica_boolean tmp256;
  modelica_real tmp257;
  tmp254 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp256 = (modelica_boolean)tmp254;
  if(tmp256)
  {
    tmp257 = 0.0;
  }
  else
  {
    tmp255 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp257 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[435] /* particleReceiver1D.phi[18] variable */)),(3.141592653589793) * ((tmp255 * tmp255 * tmp255)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[558] /* particleReceiver1D.t_c[18] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[590] /* particleReceiver1D.tau_c[17] variable */,"1.0 - particleReceiver1D.tau_c[17]",equationIndexes);
  }
  data->localData[0]->realVars[278] /* particleReceiver1D.eps_c[17] variable */ = tmp257;
  TRACE_POP
}
/*
equation index: 858
type: SIMPLE_ASSIGN
particleReceiver1D._vp[19] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[18] ^ 2.0 + 19.6133 * (particleReceiver1D.x[19] - particleReceiver1D.x[18])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_858(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,858};
  modelica_boolean tmp258;
  modelica_real tmp259;
  modelica_real tmp260;
  modelica_boolean tmp261;
  modelica_real tmp262;
  tmp258 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp261 = (modelica_boolean)tmp258;
  if(tmp261)
  {
    tmp259 = data->localData[0]->realVars[620] /* particleReceiver1D.vp[18] variable */;
    tmp260 = (tmp259 * tmp259) + (19.6133) * (data->localData[0]->realVars[652] /* particleReceiver1D.x[19] variable */ - data->localData[0]->realVars[651] /* particleReceiver1D.x[18] variable */);
    if(!(tmp260 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[18] ^ 2.0 + 19.6133 * (particleReceiver1D.x[19] - particleReceiver1D.x[18])) was %g should be >= 0", tmp260);
    }
    tmp262 = sqrt(tmp260);
  }
  else
  {
    tmp262 = 0.0;
  }
  data->localData[0]->realVars[621] /* particleReceiver1D.vp[19] variable */ = tmp262;
  TRACE_POP
}
/*
equation index: 859
type: SIMPLE_ASSIGN
particleReceiver1D._phi[19] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[19] * particleReceiver1D.vp[19] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_859(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,859};
  modelica_boolean tmp263;
  tmp263 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[436] /* particleReceiver1D.phi[19] variable */ = (tmp263?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[559] /* particleReceiver1D.t_c[19] variable */)) * (data->localData[0]->realVars[621] /* particleReceiver1D.vp[19] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[19] * particleReceiver1D.vp[19] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 860
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[18] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[19] * particleReceiver1D.t_c[19] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_860(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,860};
  modelica_boolean tmp264;
  tmp264 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[591] /* particleReceiver1D.tau_c[18] variable */ = (tmp264?0.0:exp((-1.5) * ((data->localData[0]->realVars[436] /* particleReceiver1D.phi[19] variable */) * (DIVISION_SIM(data->localData[0]->realVars[559] /* particleReceiver1D.t_c[19] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 861
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[18] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[19] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[19] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[18])
*/
void ParticleReceiver1DCalculator_eqFunction_861(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,861};
  modelica_boolean tmp265;
  modelica_real tmp266;
  modelica_boolean tmp267;
  modelica_real tmp268;
  tmp265 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp267 = (modelica_boolean)tmp265;
  if(tmp267)
  {
    tmp268 = 0.0;
  }
  else
  {
    tmp266 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp268 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[436] /* particleReceiver1D.phi[19] variable */)),(3.141592653589793) * ((tmp266 * tmp266 * tmp266)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[559] /* particleReceiver1D.t_c[19] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[591] /* particleReceiver1D.tau_c[18] variable */,"1.0 - particleReceiver1D.tau_c[18]",equationIndexes);
  }
  data->localData[0]->realVars[248] /* particleReceiver1D.abs_c[18] variable */ = tmp268;
  TRACE_POP
}
/*
equation index: 862
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[18] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[19] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[19] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[18])
*/
void ParticleReceiver1DCalculator_eqFunction_862(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,862};
  modelica_boolean tmp269;
  modelica_real tmp270;
  modelica_boolean tmp271;
  modelica_real tmp272;
  tmp269 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp271 = (modelica_boolean)tmp269;
  if(tmp271)
  {
    tmp272 = 0.0;
  }
  else
  {
    tmp270 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp272 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[436] /* particleReceiver1D.phi[19] variable */)),(3.141592653589793) * ((tmp270 * tmp270 * tmp270)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[559] /* particleReceiver1D.t_c[19] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[591] /* particleReceiver1D.tau_c[18] variable */,"1.0 - particleReceiver1D.tau_c[18]",equationIndexes);
  }
  data->localData[0]->realVars[279] /* particleReceiver1D.eps_c[18] variable */ = tmp272;
  TRACE_POP
}
/*
equation index: 863
type: SIMPLE_ASSIGN
particleReceiver1D._vp[20] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[19] ^ 2.0 + 19.6133 * (particleReceiver1D.x[20] - particleReceiver1D.x[19])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_863(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,863};
  modelica_boolean tmp273;
  modelica_real tmp274;
  modelica_real tmp275;
  modelica_boolean tmp276;
  modelica_real tmp277;
  tmp273 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp276 = (modelica_boolean)tmp273;
  if(tmp276)
  {
    tmp274 = data->localData[0]->realVars[621] /* particleReceiver1D.vp[19] variable */;
    tmp275 = (tmp274 * tmp274) + (19.6133) * (data->localData[0]->realVars[653] /* particleReceiver1D.x[20] variable */ - data->localData[0]->realVars[652] /* particleReceiver1D.x[19] variable */);
    if(!(tmp275 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[19] ^ 2.0 + 19.6133 * (particleReceiver1D.x[20] - particleReceiver1D.x[19])) was %g should be >= 0", tmp275);
    }
    tmp277 = sqrt(tmp275);
  }
  else
  {
    tmp277 = 0.0;
  }
  data->localData[0]->realVars[622] /* particleReceiver1D.vp[20] variable */ = tmp277;
  TRACE_POP
}
/*
equation index: 864
type: SIMPLE_ASSIGN
particleReceiver1D._phi[20] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[20] * particleReceiver1D.vp[20] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_864(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,864};
  modelica_boolean tmp278;
  tmp278 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[437] /* particleReceiver1D.phi[20] variable */ = (tmp278?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[560] /* particleReceiver1D.t_c[20] variable */)) * (data->localData[0]->realVars[622] /* particleReceiver1D.vp[20] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[20] * particleReceiver1D.vp[20] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 865
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[19] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[20] * particleReceiver1D.t_c[20] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_865(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,865};
  modelica_boolean tmp279;
  tmp279 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[592] /* particleReceiver1D.tau_c[19] variable */ = (tmp279?0.0:exp((-1.5) * ((data->localData[0]->realVars[437] /* particleReceiver1D.phi[20] variable */) * (DIVISION_SIM(data->localData[0]->realVars[560] /* particleReceiver1D.t_c[20] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 866
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[19] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[20] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[20] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[19])
*/
void ParticleReceiver1DCalculator_eqFunction_866(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,866};
  modelica_boolean tmp280;
  modelica_real tmp281;
  modelica_boolean tmp282;
  modelica_real tmp283;
  tmp280 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp282 = (modelica_boolean)tmp280;
  if(tmp282)
  {
    tmp283 = 0.0;
  }
  else
  {
    tmp281 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp283 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[437] /* particleReceiver1D.phi[20] variable */)),(3.141592653589793) * ((tmp281 * tmp281 * tmp281)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[560] /* particleReceiver1D.t_c[20] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[592] /* particleReceiver1D.tau_c[19] variable */,"1.0 - particleReceiver1D.tau_c[19]",equationIndexes);
  }
  data->localData[0]->realVars[249] /* particleReceiver1D.abs_c[19] variable */ = tmp283;
  TRACE_POP
}
/*
equation index: 867
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[19] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[20] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[20] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[19])
*/
void ParticleReceiver1DCalculator_eqFunction_867(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,867};
  modelica_boolean tmp284;
  modelica_real tmp285;
  modelica_boolean tmp286;
  modelica_real tmp287;
  tmp284 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp286 = (modelica_boolean)tmp284;
  if(tmp286)
  {
    tmp287 = 0.0;
  }
  else
  {
    tmp285 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp287 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[437] /* particleReceiver1D.phi[20] variable */)),(3.141592653589793) * ((tmp285 * tmp285 * tmp285)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[560] /* particleReceiver1D.t_c[20] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[592] /* particleReceiver1D.tau_c[19] variable */,"1.0 - particleReceiver1D.tau_c[19]",equationIndexes);
  }
  data->localData[0]->realVars[280] /* particleReceiver1D.eps_c[19] variable */ = tmp287;
  TRACE_POP
}
/*
equation index: 868
type: SIMPLE_ASSIGN
particleReceiver1D._vp[21] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1D.x[21] - particleReceiver1D.x[20])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_868(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,868};
  modelica_boolean tmp288;
  modelica_real tmp289;
  modelica_real tmp290;
  modelica_boolean tmp291;
  modelica_real tmp292;
  tmp288 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp291 = (modelica_boolean)tmp288;
  if(tmp291)
  {
    tmp289 = data->localData[0]->realVars[622] /* particleReceiver1D.vp[20] variable */;
    tmp290 = (tmp289 * tmp289) + (19.6133) * (data->localData[0]->realVars[654] /* particleReceiver1D.x[21] variable */ - data->localData[0]->realVars[653] /* particleReceiver1D.x[20] variable */);
    if(!(tmp290 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1D.x[21] - particleReceiver1D.x[20])) was %g should be >= 0", tmp290);
    }
    tmp292 = sqrt(tmp290);
  }
  else
  {
    tmp292 = 0.0;
  }
  data->localData[0]->realVars[623] /* particleReceiver1D.vp[21] variable */ = tmp292;
  TRACE_POP
}
/*
equation index: 869
type: SIMPLE_ASSIGN
particleReceiver1D._phi[21] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[21] * particleReceiver1D.vp[21] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_869(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,869};
  modelica_boolean tmp293;
  tmp293 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[438] /* particleReceiver1D.phi[21] variable */ = (tmp293?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[561] /* particleReceiver1D.t_c[21] variable */)) * (data->localData[0]->realVars[623] /* particleReceiver1D.vp[21] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[21] * particleReceiver1D.vp[21] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 870
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[20] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[21] * particleReceiver1D.t_c[21] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_870(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,870};
  modelica_boolean tmp294;
  tmp294 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[593] /* particleReceiver1D.tau_c[20] variable */ = (tmp294?0.0:exp((-1.5) * ((data->localData[0]->realVars[438] /* particleReceiver1D.phi[21] variable */) * (DIVISION_SIM(data->localData[0]->realVars[561] /* particleReceiver1D.t_c[21] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 871
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[20] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[21] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[21] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[20])
*/
void ParticleReceiver1DCalculator_eqFunction_871(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,871};
  modelica_boolean tmp295;
  modelica_real tmp296;
  modelica_boolean tmp297;
  modelica_real tmp298;
  tmp295 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp297 = (modelica_boolean)tmp295;
  if(tmp297)
  {
    tmp298 = 0.0;
  }
  else
  {
    tmp296 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp298 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[438] /* particleReceiver1D.phi[21] variable */)),(3.141592653589793) * ((tmp296 * tmp296 * tmp296)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[561] /* particleReceiver1D.t_c[21] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[593] /* particleReceiver1D.tau_c[20] variable */,"1.0 - particleReceiver1D.tau_c[20]",equationIndexes);
  }
  data->localData[0]->realVars[250] /* particleReceiver1D.abs_c[20] variable */ = tmp298;
  TRACE_POP
}
/*
equation index: 872
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[20] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[21] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[21] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[20])
*/
void ParticleReceiver1DCalculator_eqFunction_872(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,872};
  modelica_boolean tmp299;
  modelica_real tmp300;
  modelica_boolean tmp301;
  modelica_real tmp302;
  tmp299 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp301 = (modelica_boolean)tmp299;
  if(tmp301)
  {
    tmp302 = 0.0;
  }
  else
  {
    tmp300 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp302 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[438] /* particleReceiver1D.phi[21] variable */)),(3.141592653589793) * ((tmp300 * tmp300 * tmp300)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[561] /* particleReceiver1D.t_c[21] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[593] /* particleReceiver1D.tau_c[20] variable */,"1.0 - particleReceiver1D.tau_c[20]",equationIndexes);
  }
  data->localData[0]->realVars[281] /* particleReceiver1D.eps_c[20] variable */ = tmp302;
  TRACE_POP
}
/*
equation index: 873
type: SIMPLE_ASSIGN
particleReceiver1D._vp[22] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[21] ^ 2.0 + 19.6133 * (particleReceiver1D.x[22] - particleReceiver1D.x[21])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_873(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,873};
  modelica_boolean tmp303;
  modelica_real tmp304;
  modelica_real tmp305;
  modelica_boolean tmp306;
  modelica_real tmp307;
  tmp303 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp306 = (modelica_boolean)tmp303;
  if(tmp306)
  {
    tmp304 = data->localData[0]->realVars[623] /* particleReceiver1D.vp[21] variable */;
    tmp305 = (tmp304 * tmp304) + (19.6133) * (data->localData[0]->realVars[655] /* particleReceiver1D.x[22] variable */ - data->localData[0]->realVars[654] /* particleReceiver1D.x[21] variable */);
    if(!(tmp305 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[21] ^ 2.0 + 19.6133 * (particleReceiver1D.x[22] - particleReceiver1D.x[21])) was %g should be >= 0", tmp305);
    }
    tmp307 = sqrt(tmp305);
  }
  else
  {
    tmp307 = 0.0;
  }
  data->localData[0]->realVars[624] /* particleReceiver1D.vp[22] variable */ = tmp307;
  TRACE_POP
}
/*
equation index: 874
type: SIMPLE_ASSIGN
particleReceiver1D._phi[22] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[22] * particleReceiver1D.vp[22] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_874(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,874};
  modelica_boolean tmp308;
  tmp308 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[439] /* particleReceiver1D.phi[22] variable */ = (tmp308?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[562] /* particleReceiver1D.t_c[22] variable */)) * (data->localData[0]->realVars[624] /* particleReceiver1D.vp[22] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[22] * particleReceiver1D.vp[22] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 875
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[21] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[22] * particleReceiver1D.t_c[22] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_875(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,875};
  modelica_boolean tmp309;
  tmp309 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[594] /* particleReceiver1D.tau_c[21] variable */ = (tmp309?0.0:exp((-1.5) * ((data->localData[0]->realVars[439] /* particleReceiver1D.phi[22] variable */) * (DIVISION_SIM(data->localData[0]->realVars[562] /* particleReceiver1D.t_c[22] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 876
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[21] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[22] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[22] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[21])
*/
void ParticleReceiver1DCalculator_eqFunction_876(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,876};
  modelica_boolean tmp310;
  modelica_real tmp311;
  modelica_boolean tmp312;
  modelica_real tmp313;
  tmp310 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp312 = (modelica_boolean)tmp310;
  if(tmp312)
  {
    tmp313 = 0.0;
  }
  else
  {
    tmp311 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp313 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[439] /* particleReceiver1D.phi[22] variable */)),(3.141592653589793) * ((tmp311 * tmp311 * tmp311)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[562] /* particleReceiver1D.t_c[22] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[594] /* particleReceiver1D.tau_c[21] variable */,"1.0 - particleReceiver1D.tau_c[21]",equationIndexes);
  }
  data->localData[0]->realVars[251] /* particleReceiver1D.abs_c[21] variable */ = tmp313;
  TRACE_POP
}
/*
equation index: 877
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[21] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[22] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[22] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[21])
*/
void ParticleReceiver1DCalculator_eqFunction_877(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,877};
  modelica_boolean tmp314;
  modelica_real tmp315;
  modelica_boolean tmp316;
  modelica_real tmp317;
  tmp314 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp316 = (modelica_boolean)tmp314;
  if(tmp316)
  {
    tmp317 = 0.0;
  }
  else
  {
    tmp315 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp317 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[439] /* particleReceiver1D.phi[22] variable */)),(3.141592653589793) * ((tmp315 * tmp315 * tmp315)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[562] /* particleReceiver1D.t_c[22] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[594] /* particleReceiver1D.tau_c[21] variable */,"1.0 - particleReceiver1D.tau_c[21]",equationIndexes);
  }
  data->localData[0]->realVars[282] /* particleReceiver1D.eps_c[21] variable */ = tmp317;
  TRACE_POP
}
/*
equation index: 878
type: SIMPLE_ASSIGN
particleReceiver1D._vp[23] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[22] ^ 2.0 + 19.6133 * (particleReceiver1D.x[23] - particleReceiver1D.x[22])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_878(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,878};
  modelica_boolean tmp318;
  modelica_real tmp319;
  modelica_real tmp320;
  modelica_boolean tmp321;
  modelica_real tmp322;
  tmp318 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp321 = (modelica_boolean)tmp318;
  if(tmp321)
  {
    tmp319 = data->localData[0]->realVars[624] /* particleReceiver1D.vp[22] variable */;
    tmp320 = (tmp319 * tmp319) + (19.6133) * (data->localData[0]->realVars[656] /* particleReceiver1D.x[23] variable */ - data->localData[0]->realVars[655] /* particleReceiver1D.x[22] variable */);
    if(!(tmp320 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[22] ^ 2.0 + 19.6133 * (particleReceiver1D.x[23] - particleReceiver1D.x[22])) was %g should be >= 0", tmp320);
    }
    tmp322 = sqrt(tmp320);
  }
  else
  {
    tmp322 = 0.0;
  }
  data->localData[0]->realVars[625] /* particleReceiver1D.vp[23] variable */ = tmp322;
  TRACE_POP
}
/*
equation index: 879
type: SIMPLE_ASSIGN
particleReceiver1D._phi[23] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[23] * particleReceiver1D.vp[23] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_879(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,879};
  modelica_boolean tmp323;
  tmp323 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[440] /* particleReceiver1D.phi[23] variable */ = (tmp323?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[563] /* particleReceiver1D.t_c[23] variable */)) * (data->localData[0]->realVars[625] /* particleReceiver1D.vp[23] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[23] * particleReceiver1D.vp[23] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 880
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[22] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[23] * particleReceiver1D.t_c[23] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_880(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,880};
  modelica_boolean tmp324;
  tmp324 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[595] /* particleReceiver1D.tau_c[22] variable */ = (tmp324?0.0:exp((-1.5) * ((data->localData[0]->realVars[440] /* particleReceiver1D.phi[23] variable */) * (DIVISION_SIM(data->localData[0]->realVars[563] /* particleReceiver1D.t_c[23] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 881
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[22] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[23] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[23] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[22])
*/
void ParticleReceiver1DCalculator_eqFunction_881(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,881};
  modelica_boolean tmp325;
  modelica_real tmp326;
  modelica_boolean tmp327;
  modelica_real tmp328;
  tmp325 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp327 = (modelica_boolean)tmp325;
  if(tmp327)
  {
    tmp328 = 0.0;
  }
  else
  {
    tmp326 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp328 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[440] /* particleReceiver1D.phi[23] variable */)),(3.141592653589793) * ((tmp326 * tmp326 * tmp326)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[563] /* particleReceiver1D.t_c[23] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[595] /* particleReceiver1D.tau_c[22] variable */,"1.0 - particleReceiver1D.tau_c[22]",equationIndexes);
  }
  data->localData[0]->realVars[252] /* particleReceiver1D.abs_c[22] variable */ = tmp328;
  TRACE_POP
}
/*
equation index: 882
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[22] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[23] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[23] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[22])
*/
void ParticleReceiver1DCalculator_eqFunction_882(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,882};
  modelica_boolean tmp329;
  modelica_real tmp330;
  modelica_boolean tmp331;
  modelica_real tmp332;
  tmp329 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp331 = (modelica_boolean)tmp329;
  if(tmp331)
  {
    tmp332 = 0.0;
  }
  else
  {
    tmp330 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp332 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[440] /* particleReceiver1D.phi[23] variable */)),(3.141592653589793) * ((tmp330 * tmp330 * tmp330)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[563] /* particleReceiver1D.t_c[23] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[595] /* particleReceiver1D.tau_c[22] variable */,"1.0 - particleReceiver1D.tau_c[22]",equationIndexes);
  }
  data->localData[0]->realVars[283] /* particleReceiver1D.eps_c[22] variable */ = tmp332;
  TRACE_POP
}
/*
equation index: 883
type: SIMPLE_ASSIGN
particleReceiver1D._vp[24] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[23] ^ 2.0 + 19.6133 * (particleReceiver1D.x[24] - particleReceiver1D.x[23])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_883(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,883};
  modelica_boolean tmp333;
  modelica_real tmp334;
  modelica_real tmp335;
  modelica_boolean tmp336;
  modelica_real tmp337;
  tmp333 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp336 = (modelica_boolean)tmp333;
  if(tmp336)
  {
    tmp334 = data->localData[0]->realVars[625] /* particleReceiver1D.vp[23] variable */;
    tmp335 = (tmp334 * tmp334) + (19.6133) * (data->localData[0]->realVars[657] /* particleReceiver1D.x[24] variable */ - data->localData[0]->realVars[656] /* particleReceiver1D.x[23] variable */);
    if(!(tmp335 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[23] ^ 2.0 + 19.6133 * (particleReceiver1D.x[24] - particleReceiver1D.x[23])) was %g should be >= 0", tmp335);
    }
    tmp337 = sqrt(tmp335);
  }
  else
  {
    tmp337 = 0.0;
  }
  data->localData[0]->realVars[626] /* particleReceiver1D.vp[24] variable */ = tmp337;
  TRACE_POP
}
/*
equation index: 884
type: SIMPLE_ASSIGN
particleReceiver1D._phi[24] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[24] * particleReceiver1D.vp[24] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_884(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,884};
  modelica_boolean tmp338;
  tmp338 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[441] /* particleReceiver1D.phi[24] variable */ = (tmp338?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[564] /* particleReceiver1D.t_c[24] variable */)) * (data->localData[0]->realVars[626] /* particleReceiver1D.vp[24] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[24] * particleReceiver1D.vp[24] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 885
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[23] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[24] * particleReceiver1D.t_c[24] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_885(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,885};
  modelica_boolean tmp339;
  tmp339 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[596] /* particleReceiver1D.tau_c[23] variable */ = (tmp339?0.0:exp((-1.5) * ((data->localData[0]->realVars[441] /* particleReceiver1D.phi[24] variable */) * (DIVISION_SIM(data->localData[0]->realVars[564] /* particleReceiver1D.t_c[24] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 886
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[23] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[24] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[24] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[23])
*/
void ParticleReceiver1DCalculator_eqFunction_886(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,886};
  modelica_boolean tmp340;
  modelica_real tmp341;
  modelica_boolean tmp342;
  modelica_real tmp343;
  tmp340 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp342 = (modelica_boolean)tmp340;
  if(tmp342)
  {
    tmp343 = 0.0;
  }
  else
  {
    tmp341 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp343 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[441] /* particleReceiver1D.phi[24] variable */)),(3.141592653589793) * ((tmp341 * tmp341 * tmp341)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[564] /* particleReceiver1D.t_c[24] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[596] /* particleReceiver1D.tau_c[23] variable */,"1.0 - particleReceiver1D.tau_c[23]",equationIndexes);
  }
  data->localData[0]->realVars[253] /* particleReceiver1D.abs_c[23] variable */ = tmp343;
  TRACE_POP
}
/*
equation index: 887
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[23] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[24] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[24] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[23])
*/
void ParticleReceiver1DCalculator_eqFunction_887(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,887};
  modelica_boolean tmp344;
  modelica_real tmp345;
  modelica_boolean tmp346;
  modelica_real tmp347;
  tmp344 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp346 = (modelica_boolean)tmp344;
  if(tmp346)
  {
    tmp347 = 0.0;
  }
  else
  {
    tmp345 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp347 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[441] /* particleReceiver1D.phi[24] variable */)),(3.141592653589793) * ((tmp345 * tmp345 * tmp345)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[564] /* particleReceiver1D.t_c[24] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[596] /* particleReceiver1D.tau_c[23] variable */,"1.0 - particleReceiver1D.tau_c[23]",equationIndexes);
  }
  data->localData[0]->realVars[284] /* particleReceiver1D.eps_c[23] variable */ = tmp347;
  TRACE_POP
}
/*
equation index: 888
type: SIMPLE_ASSIGN
particleReceiver1D._vp[25] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[24] ^ 2.0 + 19.6133 * (particleReceiver1D.x[25] - particleReceiver1D.x[24])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_888(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,888};
  modelica_boolean tmp348;
  modelica_real tmp349;
  modelica_real tmp350;
  modelica_boolean tmp351;
  modelica_real tmp352;
  tmp348 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp351 = (modelica_boolean)tmp348;
  if(tmp351)
  {
    tmp349 = data->localData[0]->realVars[626] /* particleReceiver1D.vp[24] variable */;
    tmp350 = (tmp349 * tmp349) + (19.6133) * (data->localData[0]->realVars[658] /* particleReceiver1D.x[25] variable */ - data->localData[0]->realVars[657] /* particleReceiver1D.x[24] variable */);
    if(!(tmp350 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[24] ^ 2.0 + 19.6133 * (particleReceiver1D.x[25] - particleReceiver1D.x[24])) was %g should be >= 0", tmp350);
    }
    tmp352 = sqrt(tmp350);
  }
  else
  {
    tmp352 = 0.0;
  }
  data->localData[0]->realVars[627] /* particleReceiver1D.vp[25] variable */ = tmp352;
  TRACE_POP
}
/*
equation index: 889
type: SIMPLE_ASSIGN
particleReceiver1D._phi[25] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[25] * particleReceiver1D.vp[25] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_889(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,889};
  modelica_boolean tmp353;
  tmp353 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[442] /* particleReceiver1D.phi[25] variable */ = (tmp353?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[565] /* particleReceiver1D.t_c[25] variable */)) * (data->localData[0]->realVars[627] /* particleReceiver1D.vp[25] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[25] * particleReceiver1D.vp[25] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 890
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[24] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[25] * particleReceiver1D.t_c[25] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_890(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,890};
  modelica_boolean tmp354;
  tmp354 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[597] /* particleReceiver1D.tau_c[24] variable */ = (tmp354?0.0:exp((-1.5) * ((data->localData[0]->realVars[442] /* particleReceiver1D.phi[25] variable */) * (DIVISION_SIM(data->localData[0]->realVars[565] /* particleReceiver1D.t_c[25] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 891
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[24] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[25] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[25] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[24])
*/
void ParticleReceiver1DCalculator_eqFunction_891(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,891};
  modelica_boolean tmp355;
  modelica_real tmp356;
  modelica_boolean tmp357;
  modelica_real tmp358;
  tmp355 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp357 = (modelica_boolean)tmp355;
  if(tmp357)
  {
    tmp358 = 0.0;
  }
  else
  {
    tmp356 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp358 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[442] /* particleReceiver1D.phi[25] variable */)),(3.141592653589793) * ((tmp356 * tmp356 * tmp356)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[565] /* particleReceiver1D.t_c[25] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[597] /* particleReceiver1D.tau_c[24] variable */,"1.0 - particleReceiver1D.tau_c[24]",equationIndexes);
  }
  data->localData[0]->realVars[254] /* particleReceiver1D.abs_c[24] variable */ = tmp358;
  TRACE_POP
}
/*
equation index: 892
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[24] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[25] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[25] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[24])
*/
void ParticleReceiver1DCalculator_eqFunction_892(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,892};
  modelica_boolean tmp359;
  modelica_real tmp360;
  modelica_boolean tmp361;
  modelica_real tmp362;
  tmp359 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp361 = (modelica_boolean)tmp359;
  if(tmp361)
  {
    tmp362 = 0.0;
  }
  else
  {
    tmp360 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp362 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[442] /* particleReceiver1D.phi[25] variable */)),(3.141592653589793) * ((tmp360 * tmp360 * tmp360)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[565] /* particleReceiver1D.t_c[25] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[597] /* particleReceiver1D.tau_c[24] variable */,"1.0 - particleReceiver1D.tau_c[24]",equationIndexes);
  }
  data->localData[0]->realVars[285] /* particleReceiver1D.eps_c[24] variable */ = tmp362;
  TRACE_POP
}
/*
equation index: 893
type: SIMPLE_ASSIGN
particleReceiver1D._vp[26] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[25] ^ 2.0 + 19.6133 * (particleReceiver1D.x[26] - particleReceiver1D.x[25])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_893(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,893};
  modelica_boolean tmp363;
  modelica_real tmp364;
  modelica_real tmp365;
  modelica_boolean tmp366;
  modelica_real tmp367;
  tmp363 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp366 = (modelica_boolean)tmp363;
  if(tmp366)
  {
    tmp364 = data->localData[0]->realVars[627] /* particleReceiver1D.vp[25] variable */;
    tmp365 = (tmp364 * tmp364) + (19.6133) * (data->localData[0]->realVars[659] /* particleReceiver1D.x[26] variable */ - data->localData[0]->realVars[658] /* particleReceiver1D.x[25] variable */);
    if(!(tmp365 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[25] ^ 2.0 + 19.6133 * (particleReceiver1D.x[26] - particleReceiver1D.x[25])) was %g should be >= 0", tmp365);
    }
    tmp367 = sqrt(tmp365);
  }
  else
  {
    tmp367 = 0.0;
  }
  data->localData[0]->realVars[628] /* particleReceiver1D.vp[26] variable */ = tmp367;
  TRACE_POP
}
/*
equation index: 894
type: SIMPLE_ASSIGN
particleReceiver1D._phi[26] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[26] * particleReceiver1D.vp[26] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_894(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,894};
  modelica_boolean tmp368;
  tmp368 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[443] /* particleReceiver1D.phi[26] variable */ = (tmp368?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[566] /* particleReceiver1D.t_c[26] variable */)) * (data->localData[0]->realVars[628] /* particleReceiver1D.vp[26] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[26] * particleReceiver1D.vp[26] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 895
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[25] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[26] * particleReceiver1D.t_c[26] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_895(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,895};
  modelica_boolean tmp369;
  tmp369 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[598] /* particleReceiver1D.tau_c[25] variable */ = (tmp369?0.0:exp((-1.5) * ((data->localData[0]->realVars[443] /* particleReceiver1D.phi[26] variable */) * (DIVISION_SIM(data->localData[0]->realVars[566] /* particleReceiver1D.t_c[26] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 896
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[25] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[26] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[26] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[25])
*/
void ParticleReceiver1DCalculator_eqFunction_896(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,896};
  modelica_boolean tmp370;
  modelica_real tmp371;
  modelica_boolean tmp372;
  modelica_real tmp373;
  tmp370 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp372 = (modelica_boolean)tmp370;
  if(tmp372)
  {
    tmp373 = 0.0;
  }
  else
  {
    tmp371 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp373 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[443] /* particleReceiver1D.phi[26] variable */)),(3.141592653589793) * ((tmp371 * tmp371 * tmp371)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[566] /* particleReceiver1D.t_c[26] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[598] /* particleReceiver1D.tau_c[25] variable */,"1.0 - particleReceiver1D.tau_c[25]",equationIndexes);
  }
  data->localData[0]->realVars[255] /* particleReceiver1D.abs_c[25] variable */ = tmp373;
  TRACE_POP
}
/*
equation index: 897
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[25] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[26] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[26] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[25])
*/
void ParticleReceiver1DCalculator_eqFunction_897(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,897};
  modelica_boolean tmp374;
  modelica_real tmp375;
  modelica_boolean tmp376;
  modelica_real tmp377;
  tmp374 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp376 = (modelica_boolean)tmp374;
  if(tmp376)
  {
    tmp377 = 0.0;
  }
  else
  {
    tmp375 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp377 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[443] /* particleReceiver1D.phi[26] variable */)),(3.141592653589793) * ((tmp375 * tmp375 * tmp375)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[566] /* particleReceiver1D.t_c[26] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[598] /* particleReceiver1D.tau_c[25] variable */,"1.0 - particleReceiver1D.tau_c[25]",equationIndexes);
  }
  data->localData[0]->realVars[286] /* particleReceiver1D.eps_c[25] variable */ = tmp377;
  TRACE_POP
}
/*
equation index: 898
type: SIMPLE_ASSIGN
particleReceiver1D._vp[27] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[26] ^ 2.0 + 19.6133 * (particleReceiver1D.x[27] - particleReceiver1D.x[26])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_898(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,898};
  modelica_boolean tmp378;
  modelica_real tmp379;
  modelica_real tmp380;
  modelica_boolean tmp381;
  modelica_real tmp382;
  tmp378 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp381 = (modelica_boolean)tmp378;
  if(tmp381)
  {
    tmp379 = data->localData[0]->realVars[628] /* particleReceiver1D.vp[26] variable */;
    tmp380 = (tmp379 * tmp379) + (19.6133) * (data->localData[0]->realVars[660] /* particleReceiver1D.x[27] variable */ - data->localData[0]->realVars[659] /* particleReceiver1D.x[26] variable */);
    if(!(tmp380 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[26] ^ 2.0 + 19.6133 * (particleReceiver1D.x[27] - particleReceiver1D.x[26])) was %g should be >= 0", tmp380);
    }
    tmp382 = sqrt(tmp380);
  }
  else
  {
    tmp382 = 0.0;
  }
  data->localData[0]->realVars[629] /* particleReceiver1D.vp[27] variable */ = tmp382;
  TRACE_POP
}
/*
equation index: 899
type: SIMPLE_ASSIGN
particleReceiver1D._phi[27] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[27] * particleReceiver1D.vp[27] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_899(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,899};
  modelica_boolean tmp383;
  tmp383 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[444] /* particleReceiver1D.phi[27] variable */ = (tmp383?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[567] /* particleReceiver1D.t_c[27] variable */)) * (data->localData[0]->realVars[629] /* particleReceiver1D.vp[27] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[27] * particleReceiver1D.vp[27] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 900
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[26] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[27] * particleReceiver1D.t_c[27] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_900(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,900};
  modelica_boolean tmp384;
  tmp384 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[599] /* particleReceiver1D.tau_c[26] variable */ = (tmp384?0.0:exp((-1.5) * ((data->localData[0]->realVars[444] /* particleReceiver1D.phi[27] variable */) * (DIVISION_SIM(data->localData[0]->realVars[567] /* particleReceiver1D.t_c[27] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 901
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[26] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[27] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[27] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[26])
*/
void ParticleReceiver1DCalculator_eqFunction_901(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,901};
  modelica_boolean tmp385;
  modelica_real tmp386;
  modelica_boolean tmp387;
  modelica_real tmp388;
  tmp385 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp387 = (modelica_boolean)tmp385;
  if(tmp387)
  {
    tmp388 = 0.0;
  }
  else
  {
    tmp386 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp388 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[444] /* particleReceiver1D.phi[27] variable */)),(3.141592653589793) * ((tmp386 * tmp386 * tmp386)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[567] /* particleReceiver1D.t_c[27] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[599] /* particleReceiver1D.tau_c[26] variable */,"1.0 - particleReceiver1D.tau_c[26]",equationIndexes);
  }
  data->localData[0]->realVars[256] /* particleReceiver1D.abs_c[26] variable */ = tmp388;
  TRACE_POP
}
/*
equation index: 902
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[26] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[27] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[27] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[26])
*/
void ParticleReceiver1DCalculator_eqFunction_902(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,902};
  modelica_boolean tmp389;
  modelica_real tmp390;
  modelica_boolean tmp391;
  modelica_real tmp392;
  tmp389 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp391 = (modelica_boolean)tmp389;
  if(tmp391)
  {
    tmp392 = 0.0;
  }
  else
  {
    tmp390 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp392 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[444] /* particleReceiver1D.phi[27] variable */)),(3.141592653589793) * ((tmp390 * tmp390 * tmp390)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[567] /* particleReceiver1D.t_c[27] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[599] /* particleReceiver1D.tau_c[26] variable */,"1.0 - particleReceiver1D.tau_c[26]",equationIndexes);
  }
  data->localData[0]->realVars[287] /* particleReceiver1D.eps_c[26] variable */ = tmp392;
  TRACE_POP
}
/*
equation index: 903
type: SIMPLE_ASSIGN
particleReceiver1D._vp[28] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[27] ^ 2.0 + 19.6133 * (particleReceiver1D.x[28] - particleReceiver1D.x[27])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_903(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,903};
  modelica_boolean tmp393;
  modelica_real tmp394;
  modelica_real tmp395;
  modelica_boolean tmp396;
  modelica_real tmp397;
  tmp393 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp396 = (modelica_boolean)tmp393;
  if(tmp396)
  {
    tmp394 = data->localData[0]->realVars[629] /* particleReceiver1D.vp[27] variable */;
    tmp395 = (tmp394 * tmp394) + (19.6133) * (data->localData[0]->realVars[661] /* particleReceiver1D.x[28] variable */ - data->localData[0]->realVars[660] /* particleReceiver1D.x[27] variable */);
    if(!(tmp395 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[27] ^ 2.0 + 19.6133 * (particleReceiver1D.x[28] - particleReceiver1D.x[27])) was %g should be >= 0", tmp395);
    }
    tmp397 = sqrt(tmp395);
  }
  else
  {
    tmp397 = 0.0;
  }
  data->localData[0]->realVars[630] /* particleReceiver1D.vp[28] variable */ = tmp397;
  TRACE_POP
}
/*
equation index: 904
type: SIMPLE_ASSIGN
particleReceiver1D._phi[28] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[28] * particleReceiver1D.vp[28] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_904(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,904};
  modelica_boolean tmp398;
  tmp398 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[445] /* particleReceiver1D.phi[28] variable */ = (tmp398?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[568] /* particleReceiver1D.t_c[28] variable */)) * (data->localData[0]->realVars[630] /* particleReceiver1D.vp[28] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[28] * particleReceiver1D.vp[28] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 905
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[27] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[28] * particleReceiver1D.t_c[28] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_905(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,905};
  modelica_boolean tmp399;
  tmp399 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[600] /* particleReceiver1D.tau_c[27] variable */ = (tmp399?0.0:exp((-1.5) * ((data->localData[0]->realVars[445] /* particleReceiver1D.phi[28] variable */) * (DIVISION_SIM(data->localData[0]->realVars[568] /* particleReceiver1D.t_c[28] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 906
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[27] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[28] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[28] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[27])
*/
void ParticleReceiver1DCalculator_eqFunction_906(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,906};
  modelica_boolean tmp400;
  modelica_real tmp401;
  modelica_boolean tmp402;
  modelica_real tmp403;
  tmp400 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp402 = (modelica_boolean)tmp400;
  if(tmp402)
  {
    tmp403 = 0.0;
  }
  else
  {
    tmp401 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp403 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[445] /* particleReceiver1D.phi[28] variable */)),(3.141592653589793) * ((tmp401 * tmp401 * tmp401)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[568] /* particleReceiver1D.t_c[28] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[600] /* particleReceiver1D.tau_c[27] variable */,"1.0 - particleReceiver1D.tau_c[27]",equationIndexes);
  }
  data->localData[0]->realVars[257] /* particleReceiver1D.abs_c[27] variable */ = tmp403;
  TRACE_POP
}
/*
equation index: 907
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[27] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[28] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[28] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[27])
*/
void ParticleReceiver1DCalculator_eqFunction_907(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,907};
  modelica_boolean tmp404;
  modelica_real tmp405;
  modelica_boolean tmp406;
  modelica_real tmp407;
  tmp404 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp406 = (modelica_boolean)tmp404;
  if(tmp406)
  {
    tmp407 = 0.0;
  }
  else
  {
    tmp405 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp407 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[445] /* particleReceiver1D.phi[28] variable */)),(3.141592653589793) * ((tmp405 * tmp405 * tmp405)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[568] /* particleReceiver1D.t_c[28] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[600] /* particleReceiver1D.tau_c[27] variable */,"1.0 - particleReceiver1D.tau_c[27]",equationIndexes);
  }
  data->localData[0]->realVars[288] /* particleReceiver1D.eps_c[27] variable */ = tmp407;
  TRACE_POP
}
/*
equation index: 908
type: SIMPLE_ASSIGN
particleReceiver1D._vp[29] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[28] ^ 2.0 + 19.6133 * (particleReceiver1D.x[29] - particleReceiver1D.x[28])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_908(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,908};
  modelica_boolean tmp408;
  modelica_real tmp409;
  modelica_real tmp410;
  modelica_boolean tmp411;
  modelica_real tmp412;
  tmp408 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp411 = (modelica_boolean)tmp408;
  if(tmp411)
  {
    tmp409 = data->localData[0]->realVars[630] /* particleReceiver1D.vp[28] variable */;
    tmp410 = (tmp409 * tmp409) + (19.6133) * (data->localData[0]->realVars[662] /* particleReceiver1D.x[29] variable */ - data->localData[0]->realVars[661] /* particleReceiver1D.x[28] variable */);
    if(!(tmp410 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[28] ^ 2.0 + 19.6133 * (particleReceiver1D.x[29] - particleReceiver1D.x[28])) was %g should be >= 0", tmp410);
    }
    tmp412 = sqrt(tmp410);
  }
  else
  {
    tmp412 = 0.0;
  }
  data->localData[0]->realVars[631] /* particleReceiver1D.vp[29] variable */ = tmp412;
  TRACE_POP
}
/*
equation index: 909
type: SIMPLE_ASSIGN
particleReceiver1D._phi[29] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[29] * particleReceiver1D.vp[29] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_909(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,909};
  modelica_boolean tmp413;
  tmp413 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[446] /* particleReceiver1D.phi[29] variable */ = (tmp413?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[569] /* particleReceiver1D.t_c[29] variable */)) * (data->localData[0]->realVars[631] /* particleReceiver1D.vp[29] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[29] * particleReceiver1D.vp[29] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 910
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[28] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[29] * particleReceiver1D.t_c[29] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_910(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,910};
  modelica_boolean tmp414;
  tmp414 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[601] /* particleReceiver1D.tau_c[28] variable */ = (tmp414?0.0:exp((-1.5) * ((data->localData[0]->realVars[446] /* particleReceiver1D.phi[29] variable */) * (DIVISION_SIM(data->localData[0]->realVars[569] /* particleReceiver1D.t_c[29] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 911
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[28] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[29] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[29] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[28])
*/
void ParticleReceiver1DCalculator_eqFunction_911(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,911};
  modelica_boolean tmp415;
  modelica_real tmp416;
  modelica_boolean tmp417;
  modelica_real tmp418;
  tmp415 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp417 = (modelica_boolean)tmp415;
  if(tmp417)
  {
    tmp418 = 0.0;
  }
  else
  {
    tmp416 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp418 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[446] /* particleReceiver1D.phi[29] variable */)),(3.141592653589793) * ((tmp416 * tmp416 * tmp416)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[569] /* particleReceiver1D.t_c[29] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[601] /* particleReceiver1D.tau_c[28] variable */,"1.0 - particleReceiver1D.tau_c[28]",equationIndexes);
  }
  data->localData[0]->realVars[258] /* particleReceiver1D.abs_c[28] variable */ = tmp418;
  TRACE_POP
}
/*
equation index: 912
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[28] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[29] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[29] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[28])
*/
void ParticleReceiver1DCalculator_eqFunction_912(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,912};
  modelica_boolean tmp419;
  modelica_real tmp420;
  modelica_boolean tmp421;
  modelica_real tmp422;
  tmp419 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp421 = (modelica_boolean)tmp419;
  if(tmp421)
  {
    tmp422 = 0.0;
  }
  else
  {
    tmp420 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp422 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[446] /* particleReceiver1D.phi[29] variable */)),(3.141592653589793) * ((tmp420 * tmp420 * tmp420)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[569] /* particleReceiver1D.t_c[29] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[601] /* particleReceiver1D.tau_c[28] variable */,"1.0 - particleReceiver1D.tau_c[28]",equationIndexes);
  }
  data->localData[0]->realVars[289] /* particleReceiver1D.eps_c[28] variable */ = tmp422;
  TRACE_POP
}
/*
equation index: 913
type: SIMPLE_ASSIGN
particleReceiver1D._vp[30] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[29] ^ 2.0 + 19.6133 * (particleReceiver1D.x[30] - particleReceiver1D.x[29])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_913(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,913};
  modelica_boolean tmp423;
  modelica_real tmp424;
  modelica_real tmp425;
  modelica_boolean tmp426;
  modelica_real tmp427;
  tmp423 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp426 = (modelica_boolean)tmp423;
  if(tmp426)
  {
    tmp424 = data->localData[0]->realVars[631] /* particleReceiver1D.vp[29] variable */;
    tmp425 = (tmp424 * tmp424) + (19.6133) * (data->localData[0]->realVars[663] /* particleReceiver1D.x[30] variable */ - data->localData[0]->realVars[662] /* particleReceiver1D.x[29] variable */);
    if(!(tmp425 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[29] ^ 2.0 + 19.6133 * (particleReceiver1D.x[30] - particleReceiver1D.x[29])) was %g should be >= 0", tmp425);
    }
    tmp427 = sqrt(tmp425);
  }
  else
  {
    tmp427 = 0.0;
  }
  data->localData[0]->realVars[632] /* particleReceiver1D.vp[30] variable */ = tmp427;
  TRACE_POP
}
/*
equation index: 914
type: SIMPLE_ASSIGN
particleReceiver1D._phi[30] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[30] * particleReceiver1D.vp[30] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_914(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,914};
  modelica_boolean tmp428;
  tmp428 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[447] /* particleReceiver1D.phi[30] variable */ = (tmp428?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[570] /* particleReceiver1D.t_c[30] variable */)) * (data->localData[0]->realVars[632] /* particleReceiver1D.vp[30] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[30] * particleReceiver1D.vp[30] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 915
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[29] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[30] * particleReceiver1D.t_c[30] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_915(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,915};
  modelica_boolean tmp429;
  tmp429 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[602] /* particleReceiver1D.tau_c[29] variable */ = (tmp429?0.0:exp((-1.5) * ((data->localData[0]->realVars[447] /* particleReceiver1D.phi[30] variable */) * (DIVISION_SIM(data->localData[0]->realVars[570] /* particleReceiver1D.t_c[30] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 916
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[29] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[30] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[30] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[29])
*/
void ParticleReceiver1DCalculator_eqFunction_916(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,916};
  modelica_boolean tmp430;
  modelica_real tmp431;
  modelica_boolean tmp432;
  modelica_real tmp433;
  tmp430 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp432 = (modelica_boolean)tmp430;
  if(tmp432)
  {
    tmp433 = 0.0;
  }
  else
  {
    tmp431 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp433 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[447] /* particleReceiver1D.phi[30] variable */)),(3.141592653589793) * ((tmp431 * tmp431 * tmp431)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[570] /* particleReceiver1D.t_c[30] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[602] /* particleReceiver1D.tau_c[29] variable */,"1.0 - particleReceiver1D.tau_c[29]",equationIndexes);
  }
  data->localData[0]->realVars[259] /* particleReceiver1D.abs_c[29] variable */ = tmp433;
  TRACE_POP
}
/*
equation index: 917
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[29] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[30] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[30] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[29])
*/
void ParticleReceiver1DCalculator_eqFunction_917(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,917};
  modelica_boolean tmp434;
  modelica_real tmp435;
  modelica_boolean tmp436;
  modelica_real tmp437;
  tmp434 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp436 = (modelica_boolean)tmp434;
  if(tmp436)
  {
    tmp437 = 0.0;
  }
  else
  {
    tmp435 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp437 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[447] /* particleReceiver1D.phi[30] variable */)),(3.141592653589793) * ((tmp435 * tmp435 * tmp435)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[570] /* particleReceiver1D.t_c[30] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[602] /* particleReceiver1D.tau_c[29] variable */,"1.0 - particleReceiver1D.tau_c[29]",equationIndexes);
  }
  data->localData[0]->realVars[290] /* particleReceiver1D.eps_c[29] variable */ = tmp437;
  TRACE_POP
}
/*
equation index: 918
type: SIMPLE_ASSIGN
particleReceiver1D._vp[31] = if liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1D.vp[30] ^ 2.0 + 19.6133 * (particleReceiver1D.x[31] - particleReceiver1D.x[30])) ^ 0.5 else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_918(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,918};
  modelica_boolean tmp438;
  modelica_real tmp439;
  modelica_real tmp440;
  modelica_boolean tmp441;
  modelica_real tmp442;
  tmp438 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp441 = (modelica_boolean)tmp438;
  if(tmp441)
  {
    tmp439 = data->localData[0]->realVars[632] /* particleReceiver1D.vp[30] variable */;
    tmp440 = (tmp439 * tmp439) + (19.6133) * (data->localData[0]->realVars[664] /* particleReceiver1D.x[31] variable */ - data->localData[0]->realVars[663] /* particleReceiver1D.x[30] variable */);
    if(!(tmp440 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[30] ^ 2.0 + 19.6133 * (particleReceiver1D.x[31] - particleReceiver1D.x[30])) was %g should be >= 0", tmp440);
    }
    tmp442 = sqrt(tmp440);
  }
  else
  {
    tmp442 = 0.0;
  }
  data->localData[0]->realVars[633] /* particleReceiver1D.vp[31] variable */ = tmp442;
  TRACE_POP
}
/*
equation index: 919
type: SIMPLE_ASSIGN
particleReceiver1D._phi[31] = if liftSimple.m_flow_fixed > 1e-06 then liftSimple.m_flow_fixed / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[31] * particleReceiver1D.vp[31] * particleReceiver1D.rho_s) else 0.0
*/
void ParticleReceiver1DCalculator_eqFunction_919(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,919};
  modelica_boolean tmp443;
  tmp443 = Greater(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[448] /* particleReceiver1D.phi[31] variable */ = (tmp443?DIVISION_SIM(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[571] /* particleReceiver1D.t_c[31] variable */)) * (data->localData[0]->realVars[633] /* particleReceiver1D.vp[31] variable */)) * (data->simulationInfo->realParameter[110] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[31] * particleReceiver1D.vp[31] * particleReceiver1D.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 920
type: SIMPLE_ASSIGN
particleReceiver1D._tau_c[30] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else exp((-1.5) * particleReceiver1D.phi[31] * particleReceiver1D.t_c[31] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void ParticleReceiver1DCalculator_eqFunction_920(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,920};
  modelica_boolean tmp444;
  tmp444 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[603] /* particleReceiver1D.tau_c[30] variable */ = (tmp444?0.0:exp((-1.5) * ((data->localData[0]->realVars[448] /* particleReceiver1D.phi[31] variable */) * (DIVISION_SIM(data->localData[0]->realVars[571] /* particleReceiver1D.t_c[31] variable */,(cos(data->simulationInfo->realParameter[113] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 921
type: SIMPLE_ASSIGN
particleReceiver1D._abs_c[30] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[31] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[31] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[30])
*/
void ParticleReceiver1DCalculator_eqFunction_921(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,921};
  modelica_boolean tmp445;
  modelica_real tmp446;
  modelica_boolean tmp447;
  modelica_real tmp448;
  tmp445 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp447 = (modelica_boolean)tmp445;
  if(tmp447)
  {
    tmp448 = 0.0;
  }
  else
  {
    tmp446 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp448 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[91] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[448] /* particleReceiver1D.phi[31] variable */)),(3.141592653589793) * ((tmp446 * tmp446 * tmp446)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[571] /* particleReceiver1D.t_c[31] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[603] /* particleReceiver1D.tau_c[30] variable */,"1.0 - particleReceiver1D.tau_c[30]",equationIndexes);
  }
  data->localData[0]->realVars[260] /* particleReceiver1D.abs_c[30] variable */ = tmp448;
  TRACE_POP
}
/*
equation index: 922
type: SIMPLE_ASSIGN
particleReceiver1D._eps_c[30] = if liftSimple.m_flow_fixed < 1e-06 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[31] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[31] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[30])
*/
void ParticleReceiver1DCalculator_eqFunction_922(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,922};
  modelica_boolean tmp449;
  modelica_real tmp450;
  modelica_boolean tmp451;
  modelica_real tmp452;
  tmp449 = Less(data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp451 = (modelica_boolean)tmp449;
  if(tmp451)
  {
    tmp452 = 0.0;
  }
  else
  {
    tmp450 = data->simulationInfo->realParameter[93] /* particleReceiver1D.d_p PARAM */;
    tmp452 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[95] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[448] /* particleReceiver1D.phi[31] variable */)),(3.141592653589793) * ((tmp450 * tmp450 * tmp450)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[571] /* particleReceiver1D.t_c[31] variable */)) * (data->simulationInfo->realParameter[90] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[603] /* particleReceiver1D.tau_c[30] variable */,"1.0 - particleReceiver1D.tau_c[30]",equationIndexes);
  }
  data->localData[0]->realVars[291] /* particleReceiver1D.eps_c[30] variable */ = tmp452;
  TRACE_POP
}
/*
equation index: 923
type: SIMPLE_ASSIGN
particleReceiver1D._h_s[31] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1D$Tab.getTableValue(particleReceiver1D.Tab[31].tableID, 1, T_out_design, particleReceiver1D.Tab[31].tableOnFileRead)
*/
void ParticleReceiver1DCalculator_eqFunction_923(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,923};
  data->localData[0]->realVars[386] /* particleReceiver1D.h_s[31] variable */ = omc_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_getTableValue(threadData, data->simulationInfo->extObjs[30], ((modelica_integer) 1), data->simulationInfo->realParameter[13] /* T_out_design PARAM */, data->simulationInfo->realParameter[85] /* particleReceiver1D.Tab[31].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 924
type: SIMPLE_ASSIGN
particleReceiver1D._h_s[1] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1D$Tab.getTableValue(particleReceiver1D.Tab[1].tableID, 1, particleReceiver1D.T_s[1], particleReceiver1D.Tab[1].tableOnFileRead)
*/
void ParticleReceiver1DCalculator_eqFunction_924(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,924};
  data->localData[0]->realVars[356] /* particleReceiver1D.h_s[1] variable */ = omc_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 1), data->localData[0]->realVars[169] /* particleReceiver1D.T_s[1] variable */, data->simulationInfo->realParameter[55] /* particleReceiver1D.Tab[1].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 925
type: SIMPLE_ASSIGN
particleReceiver1D._Qdot_rec = max(liftSimple.m_flow_fixed * (particleReceiver1D.h_s[31] - particleReceiver1D.h_s[1]), 0.0)
*/
void ParticleReceiver1DCalculator_eqFunction_925(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,925};
  data->localData[0]->realVars[10] /* particleReceiver1D.Qdot_rec variable */ = fmax((data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */) * (data->localData[0]->realVars[386] /* particleReceiver1D.h_s[31] variable */ - data->localData[0]->realVars[356] /* particleReceiver1D.h_s[1] variable */),0.0);
  TRACE_POP
}
/*
equation index: 926
type: SIMPLE_ASSIGN
particleReceiver1D._Qabsorbed = abs(liftSimple.m_flow_fixed * (particleReceiver1D.h_s[1] - particleReceiver1D.h_s[31]))
*/
void ParticleReceiver1DCalculator_eqFunction_926(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,926};
  data->localData[0]->realVars[9] /* particleReceiver1D.Qabsorbed variable */ = fabs((data->simulationInfo->realParameter[36] /* liftSimple.m_flow_fixed PARAM */) * (data->localData[0]->realVars[356] /* particleReceiver1D.h_s[1] variable */ - data->localData[0]->realVars[386] /* particleReceiver1D.h_s[31] variable */));
  TRACE_POP
}
void ParticleReceiver1DCalculator_eqFunction_927(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_928(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_929(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_930(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_931(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_932(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_933(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_934(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_935(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_936(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_937(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_938(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_939(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_940(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_941(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_942(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_943(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_944(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_945(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_946(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_947(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_948(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_949(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_950(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_951(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_952(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_953(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_954(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_955(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_956(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_957(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_958(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_959(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_960(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_961(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_962(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_963(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_964(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_965(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_966(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_967(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_968(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_969(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_970(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_971(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_972(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_973(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_974(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_975(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_976(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_977(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_978(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_979(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_980(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_981(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_982(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_983(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_984(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_985(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_986(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_987(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_988(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_989(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_990(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_991(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_992(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_993(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_994(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_995(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_996(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_997(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_998(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_999(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1000(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1001(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1002(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1003(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1004(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1005(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1006(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1007(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1008(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1009(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1010(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1011(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1012(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1013(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1014(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1015(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1016(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1017(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1018(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1019(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1020(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1021(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1022(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1023(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1024(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1025(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1026(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1027(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1028(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1029(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1030(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1031(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1032(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1033(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1034(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1035(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1036(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1037(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1038(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1039(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1040(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1041(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1042(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1043(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1044(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1045(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1046(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1047(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1048(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1049(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1050(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1051(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1052(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1053(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1054(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1055(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1056(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1057(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1058(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1059(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1060(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1061(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1062(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1063(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1064(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1065(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1066(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1067(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1068(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1069(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1070(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1071(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1072(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1073(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1074(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1075(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1076(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1077(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1078(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1079(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1080(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1081(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1082(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1083(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1084(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1085(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1086(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1087(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1088(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1089(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1090(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1091(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1092(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1093(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1094(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1095(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1096(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1097(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1098(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1099(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1100(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1101(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1102(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1103(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1104(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1105(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1106(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1107(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1108(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1109(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1110(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1111(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1112(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1113(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1114(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1115(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1116(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1117(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1118(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1119(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1120(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1121(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1122(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1123(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1124(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1125(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1126(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1127(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1128(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1129(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1130(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1131(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1132(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1133(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1194(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1193(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1192(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1191(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1190(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1189(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1188(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1187(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1186(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1185(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1184(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1183(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1182(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1181(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1180(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1179(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1178(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1177(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1176(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1175(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1174(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1173(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1172(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1171(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1170(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1169(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1168(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1167(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1166(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1165(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1164(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1163(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1162(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1161(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1160(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1159(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1158(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1157(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1156(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1155(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1154(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1153(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1152(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1151(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1150(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1149(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1148(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1147(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1146(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1145(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1144(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1143(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1142(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1141(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1140(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1139(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1138(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1137(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1136(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1135(DATA*, threadData_t*);
void ParticleReceiver1DCalculator_eqFunction_1134(DATA*, threadData_t*);
/*
equation index: 1195
indexNonlinear: 1
type: NONLINEAR

vars: {particleReceiver1D._T_w[32], particleReceiver1D._gc_b[29], particleReceiver1D._T_w[1], particleReceiver1D._T_w[30], particleReceiver1D._T_w[29], particleReceiver1D._T_w[28], particleReceiver1D._T_w[27], particleReceiver1D._T_w[26], particleReceiver1D._T_w[25], particleReceiver1D._T_w[24], particleReceiver1D._T_w[23], particleReceiver1D._T_w[22], particleReceiver1D._T_w[21], particleReceiver1D._T_w[20], particleReceiver1D._T_w[19], particleReceiver1D._T_w[18], particleReceiver1D._T_w[17], particleReceiver1D._T_w[16], particleReceiver1D._T_w[15], particleReceiver1D._T_w[14], particleReceiver1D._T_w[13], particleReceiver1D._T_w[12], particleReceiver1D._T_w[11], particleReceiver1D._T_w[10], particleReceiver1D._T_w[9], particleReceiver1D._T_w[8], particleReceiver1D._T_w[7], particleReceiver1D._T_w[6], particleReceiver1D._gc_f[30], particleReceiver1D._T_w[5], particleReceiver1D._T_w[4], particleReceiver1D._T_w[3], particleReceiver1D._T_s[2], particleReceiver1D._T_s[3], particleReceiver1D._T_s[4], particleReceiver1D._T_s[5], particleReceiver1D._T_s[6], particleReceiver1D._T_s[7], particleReceiver1D._T_s[8], particleReceiver1D._T_s[9], particleReceiver1D._T_s[10], particleReceiver1D._T_s[11], particleReceiver1D._T_s[12], particleReceiver1D._T_s[14], particleReceiver1D._T_s[15], particleReceiver1D._T_s[16], particleReceiver1D._T_s[17], particleReceiver1D._T_s[18], particleReceiver1D._T_s[19], particleReceiver1D._T_s[20], particleReceiver1D._T_s[21], particleReceiver1D._T_s[22], particleReceiver1D._T_s[23], particleReceiver1D._T_s[25], particleReceiver1D._T_s[27], particleReceiver1D._T_s[28], particleReceiver1D._T_s[30], particleReceiver1D._T_s[13], particleReceiver1D._T_s[24], particleReceiver1D._T_s[29], particleReceiver1D._T_s[26]}
eqns: {927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 986, 987, 988, 989, 990, 991, 992, 993, 994, 995, 996, 997, 998, 999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133, 1194, 1193, 1192, 1191, 1190, 1189, 1188, 1187, 1186, 1185, 1184, 1183, 1182, 1181, 1180, 1179, 1178, 1177, 1176, 1175, 1174, 1173, 1172, 1171, 1170, 1169, 1168, 1167, 1166, 1165, 1164, 1163, 1162, 1161, 1160, 1159, 1158, 1157, 1156, 1155, 1154, 1153, 1152, 1151, 1150, 1149, 1148, 1147, 1146, 1145, 1144, 1143, 1142, 1141, 1140, 1139, 1138, 1137, 1136, 1135, 1134}
*/
void ParticleReceiver1DCalculator_eqFunction_1195(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1195};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 1195 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[0] = data->localData[0]->realVars[228] /* particleReceiver1D.T_w[32] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[1] = data->localData[0]->realVars[352] /* particleReceiver1D.gc_b[29] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[2] = data->localData[0]->realVars[199] /* particleReceiver1D.T_w[1] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[3] = data->localData[0]->realVars[227] /* particleReceiver1D.T_w[30] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[4] = data->localData[0]->realVars[226] /* particleReceiver1D.T_w[29] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[5] = data->localData[0]->realVars[225] /* particleReceiver1D.T_w[28] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[6] = data->localData[0]->realVars[224] /* particleReceiver1D.T_w[27] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[7] = data->localData[0]->realVars[223] /* particleReceiver1D.T_w[26] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[8] = data->localData[0]->realVars[222] /* particleReceiver1D.T_w[25] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[9] = data->localData[0]->realVars[221] /* particleReceiver1D.T_w[24] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[10] = data->localData[0]->realVars[220] /* particleReceiver1D.T_w[23] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[11] = data->localData[0]->realVars[219] /* particleReceiver1D.T_w[22] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[12] = data->localData[0]->realVars[218] /* particleReceiver1D.T_w[21] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[13] = data->localData[0]->realVars[217] /* particleReceiver1D.T_w[20] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[14] = data->localData[0]->realVars[216] /* particleReceiver1D.T_w[19] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[15] = data->localData[0]->realVars[215] /* particleReceiver1D.T_w[18] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[16] = data->localData[0]->realVars[214] /* particleReceiver1D.T_w[17] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[17] = data->localData[0]->realVars[213] /* particleReceiver1D.T_w[16] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[18] = data->localData[0]->realVars[212] /* particleReceiver1D.T_w[15] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[19] = data->localData[0]->realVars[211] /* particleReceiver1D.T_w[14] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[20] = data->localData[0]->realVars[210] /* particleReceiver1D.T_w[13] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[21] = data->localData[0]->realVars[209] /* particleReceiver1D.T_w[12] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[22] = data->localData[0]->realVars[208] /* particleReceiver1D.T_w[11] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[23] = data->localData[0]->realVars[207] /* particleReceiver1D.T_w[10] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[24] = data->localData[0]->realVars[206] /* particleReceiver1D.T_w[9] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[25] = data->localData[0]->realVars[205] /* particleReceiver1D.T_w[8] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[26] = data->localData[0]->realVars[204] /* particleReceiver1D.T_w[7] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[27] = data->localData[0]->realVars[203] /* particleReceiver1D.T_w[6] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[28] = data->localData[0]->realVars[354] /* particleReceiver1D.gc_f[30] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[29] = data->localData[0]->realVars[202] /* particleReceiver1D.T_w[5] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[30] = data->localData[0]->realVars[201] /* particleReceiver1D.T_w[4] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[31] = data->localData[0]->realVars[200] /* particleReceiver1D.T_w[3] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[32] = data->localData[0]->realVars[170] /* particleReceiver1D.T_s[2] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[33] = data->localData[0]->realVars[171] /* particleReceiver1D.T_s[3] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[34] = data->localData[0]->realVars[172] /* particleReceiver1D.T_s[4] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[35] = data->localData[0]->realVars[173] /* particleReceiver1D.T_s[5] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[36] = data->localData[0]->realVars[174] /* particleReceiver1D.T_s[6] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[37] = data->localData[0]->realVars[175] /* particleReceiver1D.T_s[7] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[38] = data->localData[0]->realVars[176] /* particleReceiver1D.T_s[8] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[39] = data->localData[0]->realVars[177] /* particleReceiver1D.T_s[9] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[40] = data->localData[0]->realVars[178] /* particleReceiver1D.T_s[10] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[41] = data->localData[0]->realVars[179] /* particleReceiver1D.T_s[11] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[42] = data->localData[0]->realVars[180] /* particleReceiver1D.T_s[12] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[43] = data->localData[0]->realVars[182] /* particleReceiver1D.T_s[14] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[44] = data->localData[0]->realVars[183] /* particleReceiver1D.T_s[15] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[45] = data->localData[0]->realVars[184] /* particleReceiver1D.T_s[16] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[46] = data->localData[0]->realVars[185] /* particleReceiver1D.T_s[17] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[47] = data->localData[0]->realVars[186] /* particleReceiver1D.T_s[18] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[48] = data->localData[0]->realVars[187] /* particleReceiver1D.T_s[19] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[49] = data->localData[0]->realVars[188] /* particleReceiver1D.T_s[20] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[50] = data->localData[0]->realVars[189] /* particleReceiver1D.T_s[21] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[51] = data->localData[0]->realVars[190] /* particleReceiver1D.T_s[22] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[52] = data->localData[0]->realVars[191] /* particleReceiver1D.T_s[23] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[53] = data->localData[0]->realVars[193] /* particleReceiver1D.T_s[25] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[54] = data->localData[0]->realVars[195] /* particleReceiver1D.T_s[27] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[55] = data->localData[0]->realVars[196] /* particleReceiver1D.T_s[28] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[56] = data->localData[0]->realVars[198] /* particleReceiver1D.T_s[30] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[57] = data->localData[0]->realVars[181] /* particleReceiver1D.T_s[13] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[58] = data->localData[0]->realVars[192] /* particleReceiver1D.T_s[24] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[59] = data->localData[0]->realVars[197] /* particleReceiver1D.T_s[29] variable */;
  data->simulationInfo->nonlinearSystemData[1].nlsxOld[60] = data->localData[0]->realVars[194] /* particleReceiver1D.T_s[26] variable */;
  retValue = solve_nonlinear_system(data, threadData, 1);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,1195};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 1195 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[228] /* particleReceiver1D.T_w[32] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[0];
  data->localData[0]->realVars[352] /* particleReceiver1D.gc_b[29] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[1];
  data->localData[0]->realVars[199] /* particleReceiver1D.T_w[1] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[2];
  data->localData[0]->realVars[227] /* particleReceiver1D.T_w[30] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[3];
  data->localData[0]->realVars[226] /* particleReceiver1D.T_w[29] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[4];
  data->localData[0]->realVars[225] /* particleReceiver1D.T_w[28] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[5];
  data->localData[0]->realVars[224] /* particleReceiver1D.T_w[27] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[6];
  data->localData[0]->realVars[223] /* particleReceiver1D.T_w[26] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[7];
  data->localData[0]->realVars[222] /* particleReceiver1D.T_w[25] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[8];
  data->localData[0]->realVars[221] /* particleReceiver1D.T_w[24] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[9];
  data->localData[0]->realVars[220] /* particleReceiver1D.T_w[23] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[10];
  data->localData[0]->realVars[219] /* particleReceiver1D.T_w[22] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[11];
  data->localData[0]->realVars[218] /* particleReceiver1D.T_w[21] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[12];
  data->localData[0]->realVars[217] /* particleReceiver1D.T_w[20] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[13];
  data->localData[0]->realVars[216] /* particleReceiver1D.T_w[19] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[14];
  data->localData[0]->realVars[215] /* particleReceiver1D.T_w[18] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[15];
  data->localData[0]->realVars[214] /* particleReceiver1D.T_w[17] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[16];
  data->localData[0]->realVars[213] /* particleReceiver1D.T_w[16] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[17];
  data->localData[0]->realVars[212] /* particleReceiver1D.T_w[15] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[18];
  data->localData[0]->realVars[211] /* particleReceiver1D.T_w[14] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[19];
  data->localData[0]->realVars[210] /* particleReceiver1D.T_w[13] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[20];
  data->localData[0]->realVars[209] /* particleReceiver1D.T_w[12] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[21];
  data->localData[0]->realVars[208] /* particleReceiver1D.T_w[11] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[22];
  data->localData[0]->realVars[207] /* particleReceiver1D.T_w[10] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[23];
  data->localData[0]->realVars[206] /* particleReceiver1D.T_w[9] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[24];
  data->localData[0]->realVars[205] /* particleReceiver1D.T_w[8] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[25];
  data->localData[0]->realVars[204] /* particleReceiver1D.T_w[7] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[26];
  data->localData[0]->realVars[203] /* particleReceiver1D.T_w[6] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[27];
  data->localData[0]->realVars[354] /* particleReceiver1D.gc_f[30] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[28];
  data->localData[0]->realVars[202] /* particleReceiver1D.T_w[5] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[29];
  data->localData[0]->realVars[201] /* particleReceiver1D.T_w[4] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[30];
  data->localData[0]->realVars[200] /* particleReceiver1D.T_w[3] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[31];
  data->localData[0]->realVars[170] /* particleReceiver1D.T_s[2] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[32];
  data->localData[0]->realVars[171] /* particleReceiver1D.T_s[3] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[33];
  data->localData[0]->realVars[172] /* particleReceiver1D.T_s[4] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[34];
  data->localData[0]->realVars[173] /* particleReceiver1D.T_s[5] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[35];
  data->localData[0]->realVars[174] /* particleReceiver1D.T_s[6] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[36];
  data->localData[0]->realVars[175] /* particleReceiver1D.T_s[7] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[37];
  data->localData[0]->realVars[176] /* particleReceiver1D.T_s[8] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[38];
  data->localData[0]->realVars[177] /* particleReceiver1D.T_s[9] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[39];
  data->localData[0]->realVars[178] /* particleReceiver1D.T_s[10] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[40];
  data->localData[0]->realVars[179] /* particleReceiver1D.T_s[11] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[41];
  data->localData[0]->realVars[180] /* particleReceiver1D.T_s[12] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[42];
  data->localData[0]->realVars[182] /* particleReceiver1D.T_s[14] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[43];
  data->localData[0]->realVars[183] /* particleReceiver1D.T_s[15] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[44];
  data->localData[0]->realVars[184] /* particleReceiver1D.T_s[16] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[45];
  data->localData[0]->realVars[185] /* particleReceiver1D.T_s[17] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[46];
  data->localData[0]->realVars[186] /* particleReceiver1D.T_s[18] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[47];
  data->localData[0]->realVars[187] /* particleReceiver1D.T_s[19] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[48];
  data->localData[0]->realVars[188] /* particleReceiver1D.T_s[20] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[49];
  data->localData[0]->realVars[189] /* particleReceiver1D.T_s[21] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[50];
  data->localData[0]->realVars[190] /* particleReceiver1D.T_s[22] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[51];
  data->localData[0]->realVars[191] /* particleReceiver1D.T_s[23] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[52];
  data->localData[0]->realVars[193] /* particleReceiver1D.T_s[25] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[53];
  data->localData[0]->realVars[195] /* particleReceiver1D.T_s[27] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[54];
  data->localData[0]->realVars[196] /* particleReceiver1D.T_s[28] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[55];
  data->localData[0]->realVars[198] /* particleReceiver1D.T_s[30] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[56];
  data->localData[0]->realVars[181] /* particleReceiver1D.T_s[13] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[57];
  data->localData[0]->realVars[192] /* particleReceiver1D.T_s[24] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[58];
  data->localData[0]->realVars[197] /* particleReceiver1D.T_s[29] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[59];
  data->localData[0]->realVars[194] /* particleReceiver1D.T_s[26] variable */ = data->simulationInfo->nonlinearSystemData[1].nlsx[60];
  TRACE_POP
}
/*
equation index: 1196
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[1] = particleReceiver1D.gc_b[1] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1196(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1196};
  data->localData[0]->realVars[12] /* particleReceiver1D.Qgain_gcb_discrete[1] variable */ = (data->localData[0]->realVars[324] /* particleReceiver1D.gc_b[1] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1197
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[18] = particleReceiver1D.q_conv_wall[18] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1197(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1197};
  data->localData[0]->realVars[91] /* particleReceiver1D.Qloss_conv_wall_discrete[18] variable */ = (data->localData[0]->realVars[496] /* particleReceiver1D.q_conv_wall[18] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1198
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[18] = particleReceiver1D.g_w[18] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1198(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1198};
  data->localData[0]->realVars[122] /* particleReceiver1D.Qloss_jcb_discrete[18] variable */ = (data->localData[0]->realVars[311] /* particleReceiver1D.g_w[18] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1199
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[19] = particleReceiver1D.q_conv_wall[19] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1199(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1199};
  data->localData[0]->realVars[92] /* particleReceiver1D.Qloss_conv_wall_discrete[19] variable */ = (data->localData[0]->realVars[497] /* particleReceiver1D.q_conv_wall[19] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1200
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[19] = particleReceiver1D.q_conv_curtain[19] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1200(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1200};
  data->localData[0]->realVars[61] /* particleReceiver1D.Qloss_conv_curtain_discrete[19] variable */ = (data->localData[0]->realVars[467] /* particleReceiver1D.q_conv_curtain[19] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1201
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[20] = particleReceiver1D.q_conv_curtain[20] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1201(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1201};
  data->localData[0]->realVars[62] /* particleReceiver1D.Qloss_conv_curtain_discrete[20] variable */ = (data->localData[0]->realVars[468] /* particleReceiver1D.q_conv_curtain[20] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1202
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[25] = particleReceiver1D.q_conv_wall[25] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1202(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1202};
  data->localData[0]->realVars[98] /* particleReceiver1D.Qloss_conv_wall_discrete[25] variable */ = (data->localData[0]->realVars[503] /* particleReceiver1D.q_conv_wall[25] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1203
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[25] = particleReceiver1D.q_conv_curtain[25] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1203(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1203};
  data->localData[0]->realVars[67] /* particleReceiver1D.Qloss_conv_curtain_discrete[25] variable */ = (data->localData[0]->realVars[473] /* particleReceiver1D.q_conv_curtain[25] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1204
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[28] = particleReceiver1D.q_conv_curtain[28] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1204(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1204};
  data->localData[0]->realVars[70] /* particleReceiver1D.Qloss_conv_curtain_discrete[28] variable */ = (data->localData[0]->realVars[476] /* particleReceiver1D.q_conv_curtain[28] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1205
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[30] = particleReceiver1D.g_w[30] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1205(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1205};
  data->localData[0]->realVars[134] /* particleReceiver1D.Qloss_jcb_discrete[30] variable */ = (data->localData[0]->realVars[323] /* particleReceiver1D.g_w[30] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1206
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[25] = particleReceiver1D.gc_b[25] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1206(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1206};
  data->localData[0]->realVars[36] /* particleReceiver1D.Qgain_gcb_discrete[25] variable */ = (data->localData[0]->realVars[348] /* particleReceiver1D.gc_b[25] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1207
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[30] = particleReceiver1D.jc_f[30] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1207(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1207};
  data->localData[0]->realVars[165] /* particleReceiver1D.Qloss_jcf_discrete[30] variable */ = (data->localData[0]->realVars[416] /* particleReceiver1D.jc_f[30] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1208
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[25] = particleReceiver1D.jc_f[25] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1208(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1208};
  data->localData[0]->realVars[160] /* particleReceiver1D.Qloss_jcf_discrete[25] variable */ = (data->localData[0]->realVars[411] /* particleReceiver1D.jc_f[25] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1209
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[23] = particleReceiver1D.gc_b[23] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1209(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1209};
  data->localData[0]->realVars[34] /* particleReceiver1D.Qgain_gcb_discrete[23] variable */ = (data->localData[0]->realVars[346] /* particleReceiver1D.gc_b[23] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1210
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[23] = particleReceiver1D.g_w[23] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1210(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1210};
  data->localData[0]->realVars[127] /* particleReceiver1D.Qloss_jcb_discrete[23] variable */ = (data->localData[0]->realVars[316] /* particleReceiver1D.g_w[23] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1211
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[23] = particleReceiver1D.jc_f[23] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1211(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1211};
  data->localData[0]->realVars[158] /* particleReceiver1D.Qloss_jcf_discrete[23] variable */ = (data->localData[0]->realVars[409] /* particleReceiver1D.jc_f[23] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1212
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[23] = particleReceiver1D.q_conv_curtain[23] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1212(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1212};
  data->localData[0]->realVars[65] /* particleReceiver1D.Qloss_conv_curtain_discrete[23] variable */ = (data->localData[0]->realVars[471] /* particleReceiver1D.q_conv_curtain[23] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1213
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[20] = particleReceiver1D.q_conv_wall[20] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1213(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1213};
  data->localData[0]->realVars[93] /* particleReceiver1D.Qloss_conv_wall_discrete[20] variable */ = (data->localData[0]->realVars[498] /* particleReceiver1D.q_conv_wall[20] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1214
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[21] = particleReceiver1D.g_w[21] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1214(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1214};
  data->localData[0]->realVars[125] /* particleReceiver1D.Qloss_jcb_discrete[21] variable */ = (data->localData[0]->realVars[314] /* particleReceiver1D.g_w[21] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1215
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[21] = particleReceiver1D.q_conv_wall[21] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1215(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1215};
  data->localData[0]->realVars[94] /* particleReceiver1D.Qloss_conv_wall_discrete[21] variable */ = (data->localData[0]->realVars[499] /* particleReceiver1D.q_conv_wall[21] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1216
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[21] = particleReceiver1D.gc_b[21] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1216(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1216};
  data->localData[0]->realVars[32] /* particleReceiver1D.Qgain_gcb_discrete[21] variable */ = (data->localData[0]->realVars[344] /* particleReceiver1D.gc_b[21] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1217
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[19] = particleReceiver1D.g_w[19] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1217(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1217};
  data->localData[0]->realVars[123] /* particleReceiver1D.Qloss_jcb_discrete[19] variable */ = (data->localData[0]->realVars[312] /* particleReceiver1D.g_w[19] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1218
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[14] = particleReceiver1D.gc_b[14] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1218(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1218};
  data->localData[0]->realVars[25] /* particleReceiver1D.Qgain_gcb_discrete[14] variable */ = (data->localData[0]->realVars[337] /* particleReceiver1D.gc_b[14] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1219
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[14] = particleReceiver1D.q_conv_wall[14] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1219(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1219};
  data->localData[0]->realVars[87] /* particleReceiver1D.Qloss_conv_wall_discrete[14] variable */ = (data->localData[0]->realVars[492] /* particleReceiver1D.q_conv_wall[14] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1220
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[15] = particleReceiver1D.q_conv_wall[15] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1220(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1220};
  data->localData[0]->realVars[88] /* particleReceiver1D.Qloss_conv_wall_discrete[15] variable */ = (data->localData[0]->realVars[493] /* particleReceiver1D.q_conv_wall[15] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1221
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[15] = particleReceiver1D.g_w[15] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1221(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1221};
  data->localData[0]->realVars[119] /* particleReceiver1D.Qloss_jcb_discrete[15] variable */ = (data->localData[0]->realVars[308] /* particleReceiver1D.g_w[15] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1222
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[15] = particleReceiver1D.gc_b[15] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1222(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1222};
  data->localData[0]->realVars[26] /* particleReceiver1D.Qgain_gcb_discrete[15] variable */ = (data->localData[0]->realVars[338] /* particleReceiver1D.gc_b[15] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1223
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[14] = particleReceiver1D.jc_f[14] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1223(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1223};
  data->localData[0]->realVars[149] /* particleReceiver1D.Qloss_jcf_discrete[14] variable */ = (data->localData[0]->realVars[400] /* particleReceiver1D.jc_f[14] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1224
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[13] = particleReceiver1D.g_w[13] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1224(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1224};
  data->localData[0]->realVars[117] /* particleReceiver1D.Qloss_jcb_discrete[13] variable */ = (data->localData[0]->realVars[306] /* particleReceiver1D.g_w[13] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1225
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[13] = particleReceiver1D.jc_f[13] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1225(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1225};
  data->localData[0]->realVars[148] /* particleReceiver1D.Qloss_jcf_discrete[13] variable */ = (data->localData[0]->realVars[399] /* particleReceiver1D.jc_f[13] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1226
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[12] = particleReceiver1D.g_w[12] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1226(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1226};
  data->localData[0]->realVars[116] /* particleReceiver1D.Qloss_jcb_discrete[12] variable */ = (data->localData[0]->realVars[305] /* particleReceiver1D.g_w[12] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1227
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[12] = particleReceiver1D.gc_b[12] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1227(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1227};
  data->localData[0]->realVars[23] /* particleReceiver1D.Qgain_gcb_discrete[12] variable */ = (data->localData[0]->realVars[335] /* particleReceiver1D.gc_b[12] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1228
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[12] = particleReceiver1D.jc_f[12] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1228(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1228};
  data->localData[0]->realVars[147] /* particleReceiver1D.Qloss_jcf_discrete[12] variable */ = (data->localData[0]->realVars[398] /* particleReceiver1D.jc_f[12] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1229
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[12] = particleReceiver1D.q_conv_curtain[12] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1229(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1229};
  data->localData[0]->realVars[54] /* particleReceiver1D.Qloss_conv_curtain_discrete[12] variable */ = (data->localData[0]->realVars[460] /* particleReceiver1D.q_conv_curtain[12] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1230
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[10] = particleReceiver1D.g_w[10] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1230(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1230};
  data->localData[0]->realVars[114] /* particleReceiver1D.Qloss_jcb_discrete[10] variable */ = (data->localData[0]->realVars[303] /* particleReceiver1D.g_w[10] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1231
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[10] = particleReceiver1D.jc_f[10] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1231(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1231};
  data->localData[0]->realVars[145] /* particleReceiver1D.Qloss_jcf_discrete[10] variable */ = (data->localData[0]->realVars[396] /* particleReceiver1D.jc_f[10] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1232
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[8] = particleReceiver1D.g_w[8] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1232(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1232};
  data->localData[0]->realVars[112] /* particleReceiver1D.Qloss_jcb_discrete[8] variable */ = (data->localData[0]->realVars[301] /* particleReceiver1D.g_w[8] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1233
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[8] = particleReceiver1D.jc_f[8] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1233(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1233};
  data->localData[0]->realVars[143] /* particleReceiver1D.Qloss_jcf_discrete[8] variable */ = (data->localData[0]->realVars[394] /* particleReceiver1D.jc_f[8] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1234
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[6] = particleReceiver1D.jc_f[6] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1234(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1234};
  data->localData[0]->realVars[141] /* particleReceiver1D.Qloss_jcf_discrete[6] variable */ = (data->localData[0]->realVars[392] /* particleReceiver1D.jc_f[6] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1235
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[6] = particleReceiver1D.gc_b[6] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1235(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1235};
  data->localData[0]->realVars[17] /* particleReceiver1D.Qgain_gcb_discrete[6] variable */ = (data->localData[0]->realVars[329] /* particleReceiver1D.gc_b[6] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1236
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[6] = particleReceiver1D.g_w[6] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1236(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1236};
  data->localData[0]->realVars[110] /* particleReceiver1D.Qloss_jcb_discrete[6] variable */ = (data->localData[0]->realVars[299] /* particleReceiver1D.g_w[6] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1237
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[6] = particleReceiver1D.q_conv_wall[6] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1237(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1237};
  data->localData[0]->realVars[79] /* particleReceiver1D.Qloss_conv_wall_discrete[6] variable */ = (data->localData[0]->realVars[484] /* particleReceiver1D.q_conv_wall[6] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1238
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[5] = particleReceiver1D.q_conv_wall[5] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1238(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1238};
  data->localData[0]->realVars[78] /* particleReceiver1D.Qloss_conv_wall_discrete[5] variable */ = (data->localData[0]->realVars[483] /* particleReceiver1D.q_conv_wall[5] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1239
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[5] = particleReceiver1D.gc_b[5] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1239(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1239};
  data->localData[0]->realVars[16] /* particleReceiver1D.Qgain_gcb_discrete[5] variable */ = (data->localData[0]->realVars[328] /* particleReceiver1D.gc_b[5] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1240
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[5] = particleReceiver1D.g_w[5] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1240(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1240};
  data->localData[0]->realVars[109] /* particleReceiver1D.Qloss_jcb_discrete[5] variable */ = (data->localData[0]->realVars[298] /* particleReceiver1D.g_w[5] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1241
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[4] = particleReceiver1D.g_w[4] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1241(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1241};
  data->localData[0]->realVars[108] /* particleReceiver1D.Qloss_jcb_discrete[4] variable */ = (data->localData[0]->realVars[297] /* particleReceiver1D.g_w[4] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1242
type: SIMPLE_ASSIGN
Q_in_rcv_calculated = particleReceiver1D.gc_f[30] * particleReceiver1D.A_ap
*/
void ParticleReceiver1DCalculator_eqFunction_1242(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1242};
  data->localData[0]->realVars[1] /* Q_in_rcv_calculated variable */ = (data->localData[0]->realVars[354] /* particleReceiver1D.gc_f[30] variable */) * (data->localData[0]->realVars[4] /* particleReceiver1D.A_ap variable */);
  TRACE_POP
}
/*
equation index: 1243
type: SIMPLE_ASSIGN
particleReceiver1D._eta_rec_out = max(particleReceiver1D.Qdot_rec / Q_in_rcv_calculated, 0.0)
*/
void ParticleReceiver1DCalculator_eqFunction_1243(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1243};
  data->localData[0]->realVars[292] /* particleReceiver1D.eta_rec_out variable */ = fmax(DIVISION_SIM(data->localData[0]->realVars[10] /* particleReceiver1D.Qdot_rec variable */,data->localData[0]->realVars[1] /* Q_in_rcv_calculated variable */,"Q_in_rcv_calculated",equationIndexes),0.0);
  TRACE_POP
}
/*
equation index: 1244
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[30] = particleReceiver1D.gc_b[30] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1244(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1244};
  data->localData[0]->realVars[41] /* particleReceiver1D.Qgain_gcb_discrete[30] variable */ = (data->localData[0]->realVars[353] /* particleReceiver1D.gc_b[30] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1245
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[30] = particleReceiver1D.q_conv_wall[30] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1245(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1245};
  data->localData[0]->realVars[103] /* particleReceiver1D.Qloss_conv_wall_discrete[30] variable */ = (data->localData[0]->realVars[508] /* particleReceiver1D.q_conv_wall[30] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1246
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[27] = particleReceiver1D.q_conv_wall[27] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1246(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1246};
  data->localData[0]->realVars[100] /* particleReceiver1D.Qloss_conv_wall_discrete[27] variable */ = (data->localData[0]->realVars[505] /* particleReceiver1D.q_conv_wall[27] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1247
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[26] = particleReceiver1D.gc_b[26] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1247(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1247};
  data->localData[0]->realVars[37] /* particleReceiver1D.Qgain_gcb_discrete[26] variable */ = (data->localData[0]->realVars[349] /* particleReceiver1D.gc_b[26] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1248
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[26] = particleReceiver1D.q_conv_wall[26] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1248(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1248};
  data->localData[0]->realVars[99] /* particleReceiver1D.Qloss_conv_wall_discrete[26] variable */ = (data->localData[0]->realVars[504] /* particleReceiver1D.q_conv_wall[26] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1249
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[27] = particleReceiver1D.g_w[27] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1249(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1249};
  data->localData[0]->realVars[131] /* particleReceiver1D.Qloss_jcb_discrete[27] variable */ = (data->localData[0]->realVars[320] /* particleReceiver1D.g_w[27] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1250
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[28] = particleReceiver1D.jc_f[28] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1250(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1250};
  data->localData[0]->realVars[163] /* particleReceiver1D.Qloss_jcf_discrete[28] variable */ = (data->localData[0]->realVars[414] /* particleReceiver1D.jc_f[28] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1251
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[28] = particleReceiver1D.gc_b[28] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1251(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1251};
  data->localData[0]->realVars[39] /* particleReceiver1D.Qgain_gcb_discrete[28] variable */ = (data->localData[0]->realVars[351] /* particleReceiver1D.gc_b[28] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1252
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[28] = particleReceiver1D.g_w[28] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1252(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1252};
  data->localData[0]->realVars[132] /* particleReceiver1D.Qloss_jcb_discrete[28] variable */ = (data->localData[0]->realVars[321] /* particleReceiver1D.g_w[28] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1253
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[28] = particleReceiver1D.q_conv_wall[28] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1253(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1253};
  data->localData[0]->realVars[101] /* particleReceiver1D.Qloss_conv_wall_discrete[28] variable */ = (data->localData[0]->realVars[506] /* particleReceiver1D.q_conv_wall[28] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1254
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[29] = particleReceiver1D.q_conv_wall[29] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1254(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1254};
  data->localData[0]->realVars[102] /* particleReceiver1D.Qloss_conv_wall_discrete[29] variable */ = (data->localData[0]->realVars[507] /* particleReceiver1D.q_conv_wall[29] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1255
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[29] = particleReceiver1D.gc_b[29] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1255(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1255};
  data->localData[0]->realVars[40] /* particleReceiver1D.Qgain_gcb_discrete[29] variable */ = (data->localData[0]->realVars[352] /* particleReceiver1D.gc_b[29] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1256
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[29] = particleReceiver1D.g_w[29] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1256(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1256};
  data->localData[0]->realVars[133] /* particleReceiver1D.Qloss_jcb_discrete[29] variable */ = (data->localData[0]->realVars[322] /* particleReceiver1D.g_w[29] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1257
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[29] = particleReceiver1D.jc_f[29] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1257(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1257};
  data->localData[0]->realVars[164] /* particleReceiver1D.Qloss_jcf_discrete[29] variable */ = (data->localData[0]->realVars[415] /* particleReceiver1D.jc_f[29] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1258
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[29] = particleReceiver1D.q_conv_curtain[29] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1258(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1258};
  data->localData[0]->realVars[71] /* particleReceiver1D.Qloss_conv_curtain_discrete[29] variable */ = (data->localData[0]->realVars[477] /* particleReceiver1D.q_conv_curtain[29] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1259
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[27] = particleReceiver1D.q_conv_curtain[27] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1259(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1259};
  data->localData[0]->realVars[69] /* particleReceiver1D.Qloss_conv_curtain_discrete[27] variable */ = (data->localData[0]->realVars[475] /* particleReceiver1D.q_conv_curtain[27] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1260
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[27] = particleReceiver1D.jc_f[27] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1260(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1260};
  data->localData[0]->realVars[162] /* particleReceiver1D.Qloss_jcf_discrete[27] variable */ = (data->localData[0]->realVars[413] /* particleReceiver1D.jc_f[27] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1261
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[27] = particleReceiver1D.gc_b[27] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1261(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1261};
  data->localData[0]->realVars[38] /* particleReceiver1D.Qgain_gcb_discrete[27] variable */ = (data->localData[0]->realVars[350] /* particleReceiver1D.gc_b[27] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1262
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[26] = particleReceiver1D.jc_f[26] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1262(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1262};
  data->localData[0]->realVars[161] /* particleReceiver1D.Qloss_jcf_discrete[26] variable */ = (data->localData[0]->realVars[412] /* particleReceiver1D.jc_f[26] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1263
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[26] = particleReceiver1D.q_conv_curtain[26] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1263(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1263};
  data->localData[0]->realVars[68] /* particleReceiver1D.Qloss_conv_curtain_discrete[26] variable */ = (data->localData[0]->realVars[474] /* particleReceiver1D.q_conv_curtain[26] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1264
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[26] = particleReceiver1D.g_w[26] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1264(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1264};
  data->localData[0]->realVars[130] /* particleReceiver1D.Qloss_jcb_discrete[26] variable */ = (data->localData[0]->realVars[319] /* particleReceiver1D.g_w[26] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1265
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[25] = particleReceiver1D.g_w[25] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1265(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1265};
  data->localData[0]->realVars[129] /* particleReceiver1D.Qloss_jcb_discrete[25] variable */ = (data->localData[0]->realVars[318] /* particleReceiver1D.g_w[25] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1266
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[24] = particleReceiver1D.q_conv_wall[24] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1266(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1266};
  data->localData[0]->realVars[97] /* particleReceiver1D.Qloss_conv_wall_discrete[24] variable */ = (data->localData[0]->realVars[502] /* particleReceiver1D.q_conv_wall[24] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1267
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[24] = particleReceiver1D.gc_b[24] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1267(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1267};
  data->localData[0]->realVars[35] /* particleReceiver1D.Qgain_gcb_discrete[24] variable */ = (data->localData[0]->realVars[347] /* particleReceiver1D.gc_b[24] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1268
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[24] = particleReceiver1D.jc_f[24] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1268(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1268};
  data->localData[0]->realVars[159] /* particleReceiver1D.Qloss_jcf_discrete[24] variable */ = (data->localData[0]->realVars[410] /* particleReceiver1D.jc_f[24] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1269
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[24] = particleReceiver1D.q_conv_curtain[24] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1269(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1269};
  data->localData[0]->realVars[66] /* particleReceiver1D.Qloss_conv_curtain_discrete[24] variable */ = (data->localData[0]->realVars[472] /* particleReceiver1D.q_conv_curtain[24] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1270
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[24] = particleReceiver1D.g_w[24] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1270(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1270};
  data->localData[0]->realVars[128] /* particleReceiver1D.Qloss_jcb_discrete[24] variable */ = (data->localData[0]->realVars[317] /* particleReceiver1D.g_w[24] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1271
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[23] = particleReceiver1D.q_conv_wall[23] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1271(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1271};
  data->localData[0]->realVars[96] /* particleReceiver1D.Qloss_conv_wall_discrete[23] variable */ = (data->localData[0]->realVars[501] /* particleReceiver1D.q_conv_wall[23] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1272
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[22] = particleReceiver1D.g_w[22] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1272(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1272};
  data->localData[0]->realVars[126] /* particleReceiver1D.Qloss_jcb_discrete[22] variable */ = (data->localData[0]->realVars[315] /* particleReceiver1D.g_w[22] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1273
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[22] = particleReceiver1D.q_conv_wall[22] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1273(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1273};
  data->localData[0]->realVars[95] /* particleReceiver1D.Qloss_conv_wall_discrete[22] variable */ = (data->localData[0]->realVars[500] /* particleReceiver1D.q_conv_wall[22] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1274
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[22] = particleReceiver1D.gc_b[22] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1274(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1274};
  data->localData[0]->realVars[33] /* particleReceiver1D.Qgain_gcb_discrete[22] variable */ = (data->localData[0]->realVars[345] /* particleReceiver1D.gc_b[22] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1275
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[22] = particleReceiver1D.jc_f[22] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1275(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1275};
  data->localData[0]->realVars[157] /* particleReceiver1D.Qloss_jcf_discrete[22] variable */ = (data->localData[0]->realVars[408] /* particleReceiver1D.jc_f[22] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1276
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[22] = particleReceiver1D.q_conv_curtain[22] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1276(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1276};
  data->localData[0]->realVars[64] /* particleReceiver1D.Qloss_conv_curtain_discrete[22] variable */ = (data->localData[0]->realVars[470] /* particleReceiver1D.q_conv_curtain[22] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1277
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[21] = particleReceiver1D.q_conv_curtain[21] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1277(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1277};
  data->localData[0]->realVars[63] /* particleReceiver1D.Qloss_conv_curtain_discrete[21] variable */ = (data->localData[0]->realVars[469] /* particleReceiver1D.q_conv_curtain[21] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1278
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[21] = particleReceiver1D.jc_f[21] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1278(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1278};
  data->localData[0]->realVars[156] /* particleReceiver1D.Qloss_jcf_discrete[21] variable */ = (data->localData[0]->realVars[407] /* particleReceiver1D.jc_f[21] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1279
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[20] = particleReceiver1D.g_w[20] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1279(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1279};
  data->localData[0]->realVars[124] /* particleReceiver1D.Qloss_jcb_discrete[20] variable */ = (data->localData[0]->realVars[313] /* particleReceiver1D.g_w[20] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1280
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[20] = particleReceiver1D.jc_f[20] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1280(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1280};
  data->localData[0]->realVars[155] /* particleReceiver1D.Qloss_jcf_discrete[20] variable */ = (data->localData[0]->realVars[406] /* particleReceiver1D.jc_f[20] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1281
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[20] = particleReceiver1D.gc_b[20] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1281(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1281};
  data->localData[0]->realVars[31] /* particleReceiver1D.Qgain_gcb_discrete[20] variable */ = (data->localData[0]->realVars[343] /* particleReceiver1D.gc_b[20] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1282
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[19] = particleReceiver1D.jc_f[19] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1282(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1282};
  data->localData[0]->realVars[154] /* particleReceiver1D.Qloss_jcf_discrete[19] variable */ = (data->localData[0]->realVars[405] /* particleReceiver1D.jc_f[19] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1283
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[19] = particleReceiver1D.gc_b[19] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1283(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1283};
  data->localData[0]->realVars[30] /* particleReceiver1D.Qgain_gcb_discrete[19] variable */ = (data->localData[0]->realVars[342] /* particleReceiver1D.gc_b[19] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1284
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[18] = particleReceiver1D.gc_b[18] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1284(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1284};
  data->localData[0]->realVars[29] /* particleReceiver1D.Qgain_gcb_discrete[18] variable */ = (data->localData[0]->realVars[341] /* particleReceiver1D.gc_b[18] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1285
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[18] = particleReceiver1D.jc_f[18] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1285(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1285};
  data->localData[0]->realVars[153] /* particleReceiver1D.Qloss_jcf_discrete[18] variable */ = (data->localData[0]->realVars[404] /* particleReceiver1D.jc_f[18] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1286
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[18] = particleReceiver1D.q_conv_curtain[18] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1286(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1286};
  data->localData[0]->realVars[60] /* particleReceiver1D.Qloss_conv_curtain_discrete[18] variable */ = (data->localData[0]->realVars[466] /* particleReceiver1D.q_conv_curtain[18] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1287
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[17] = particleReceiver1D.g_w[17] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1287(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1287};
  data->localData[0]->realVars[121] /* particleReceiver1D.Qloss_jcb_discrete[17] variable */ = (data->localData[0]->realVars[310] /* particleReceiver1D.g_w[17] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1288
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[17] = particleReceiver1D.q_conv_curtain[17] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1288(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1288};
  data->localData[0]->realVars[59] /* particleReceiver1D.Qloss_conv_curtain_discrete[17] variable */ = (data->localData[0]->realVars[465] /* particleReceiver1D.q_conv_curtain[17] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1289
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[17] = particleReceiver1D.jc_f[17] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1289(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1289};
  data->localData[0]->realVars[152] /* particleReceiver1D.Qloss_jcf_discrete[17] variable */ = (data->localData[0]->realVars[403] /* particleReceiver1D.jc_f[17] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1290
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[17] = particleReceiver1D.gc_b[17] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1290(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1290};
  data->localData[0]->realVars[28] /* particleReceiver1D.Qgain_gcb_discrete[17] variable */ = (data->localData[0]->realVars[340] /* particleReceiver1D.gc_b[17] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1291
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[17] = particleReceiver1D.q_conv_wall[17] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1291(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1291};
  data->localData[0]->realVars[90] /* particleReceiver1D.Qloss_conv_wall_discrete[17] variable */ = (data->localData[0]->realVars[495] /* particleReceiver1D.q_conv_wall[17] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1292
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[16] = particleReceiver1D.g_w[16] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1292(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1292};
  data->localData[0]->realVars[120] /* particleReceiver1D.Qloss_jcb_discrete[16] variable */ = (data->localData[0]->realVars[309] /* particleReceiver1D.g_w[16] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1293
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[16] = particleReceiver1D.q_conv_wall[16] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1293(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1293};
  data->localData[0]->realVars[89] /* particleReceiver1D.Qloss_conv_wall_discrete[16] variable */ = (data->localData[0]->realVars[494] /* particleReceiver1D.q_conv_wall[16] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1294
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[16] = particleReceiver1D.gc_b[16] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1294(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1294};
  data->localData[0]->realVars[27] /* particleReceiver1D.Qgain_gcb_discrete[16] variable */ = (data->localData[0]->realVars[339] /* particleReceiver1D.gc_b[16] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1295
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[16] = particleReceiver1D.jc_f[16] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1295(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1295};
  data->localData[0]->realVars[151] /* particleReceiver1D.Qloss_jcf_discrete[16] variable */ = (data->localData[0]->realVars[402] /* particleReceiver1D.jc_f[16] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1296
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[16] = particleReceiver1D.q_conv_curtain[16] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1296(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1296};
  data->localData[0]->realVars[58] /* particleReceiver1D.Qloss_conv_curtain_discrete[16] variable */ = (data->localData[0]->realVars[464] /* particleReceiver1D.q_conv_curtain[16] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1297
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[15] = particleReceiver1D.q_conv_curtain[15] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1297(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1297};
  data->localData[0]->realVars[57] /* particleReceiver1D.Qloss_conv_curtain_discrete[15] variable */ = (data->localData[0]->realVars[463] /* particleReceiver1D.q_conv_curtain[15] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1298
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[15] = particleReceiver1D.jc_f[15] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1298(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1298};
  data->localData[0]->realVars[150] /* particleReceiver1D.Qloss_jcf_discrete[15] variable */ = (data->localData[0]->realVars[401] /* particleReceiver1D.jc_f[15] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1299
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[14] = particleReceiver1D.q_conv_curtain[14] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1299(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1299};
  data->localData[0]->realVars[56] /* particleReceiver1D.Qloss_conv_curtain_discrete[14] variable */ = (data->localData[0]->realVars[462] /* particleReceiver1D.q_conv_curtain[14] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1300
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[14] = particleReceiver1D.g_w[14] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1300(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1300};
  data->localData[0]->realVars[118] /* particleReceiver1D.Qloss_jcb_discrete[14] variable */ = (data->localData[0]->realVars[307] /* particleReceiver1D.g_w[14] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1301
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[13] = particleReceiver1D.q_conv_curtain[13] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1301(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1301};
  data->localData[0]->realVars[55] /* particleReceiver1D.Qloss_conv_curtain_discrete[13] variable */ = (data->localData[0]->realVars[461] /* particleReceiver1D.q_conv_curtain[13] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1302
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[13] = particleReceiver1D.gc_b[13] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1302(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1302};
  data->localData[0]->realVars[24] /* particleReceiver1D.Qgain_gcb_discrete[13] variable */ = (data->localData[0]->realVars[336] /* particleReceiver1D.gc_b[13] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1303
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[13] = particleReceiver1D.q_conv_wall[13] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1303(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1303};
  data->localData[0]->realVars[86] /* particleReceiver1D.Qloss_conv_wall_discrete[13] variable */ = (data->localData[0]->realVars[491] /* particleReceiver1D.q_conv_wall[13] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1304
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[12] = particleReceiver1D.q_conv_wall[12] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1304(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1304};
  data->localData[0]->realVars[85] /* particleReceiver1D.Qloss_conv_wall_discrete[12] variable */ = (data->localData[0]->realVars[490] /* particleReceiver1D.q_conv_wall[12] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1305
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[11] = particleReceiver1D.q_conv_wall[11] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1305(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1305};
  data->localData[0]->realVars[84] /* particleReceiver1D.Qloss_conv_wall_discrete[11] variable */ = (data->localData[0]->realVars[489] /* particleReceiver1D.q_conv_wall[11] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1306
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[11] = particleReceiver1D.g_w[11] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1306(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1306};
  data->localData[0]->realVars[115] /* particleReceiver1D.Qloss_jcb_discrete[11] variable */ = (data->localData[0]->realVars[304] /* particleReceiver1D.g_w[11] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1307
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[11] = particleReceiver1D.gc_b[11] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1307(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1307};
  data->localData[0]->realVars[22] /* particleReceiver1D.Qgain_gcb_discrete[11] variable */ = (data->localData[0]->realVars[334] /* particleReceiver1D.gc_b[11] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1308
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[11] = particleReceiver1D.jc_f[11] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1308(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1308};
  data->localData[0]->realVars[146] /* particleReceiver1D.Qloss_jcf_discrete[11] variable */ = (data->localData[0]->realVars[397] /* particleReceiver1D.jc_f[11] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1309
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[11] = particleReceiver1D.q_conv_curtain[11] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1309(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1309};
  data->localData[0]->realVars[53] /* particleReceiver1D.Qloss_conv_curtain_discrete[11] variable */ = (data->localData[0]->realVars[459] /* particleReceiver1D.q_conv_curtain[11] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1310
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[10] = particleReceiver1D.q_conv_curtain[10] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1310(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1310};
  data->localData[0]->realVars[52] /* particleReceiver1D.Qloss_conv_curtain_discrete[10] variable */ = (data->localData[0]->realVars[458] /* particleReceiver1D.q_conv_curtain[10] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1311
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[10] = particleReceiver1D.gc_b[10] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1311(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1311};
  data->localData[0]->realVars[21] /* particleReceiver1D.Qgain_gcb_discrete[10] variable */ = (data->localData[0]->realVars[333] /* particleReceiver1D.gc_b[10] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1312
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[10] = particleReceiver1D.q_conv_wall[10] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1312(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1312};
  data->localData[0]->realVars[83] /* particleReceiver1D.Qloss_conv_wall_discrete[10] variable */ = (data->localData[0]->realVars[488] /* particleReceiver1D.q_conv_wall[10] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1313
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[9] = particleReceiver1D.q_conv_wall[9] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1313(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1313};
  data->localData[0]->realVars[82] /* particleReceiver1D.Qloss_conv_wall_discrete[9] variable */ = (data->localData[0]->realVars[487] /* particleReceiver1D.q_conv_wall[9] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1314
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[9] = particleReceiver1D.g_w[9] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1314(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1314};
  data->localData[0]->realVars[113] /* particleReceiver1D.Qloss_jcb_discrete[9] variable */ = (data->localData[0]->realVars[302] /* particleReceiver1D.g_w[9] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1315
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[9] = particleReceiver1D.gc_b[9] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1315(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1315};
  data->localData[0]->realVars[20] /* particleReceiver1D.Qgain_gcb_discrete[9] variable */ = (data->localData[0]->realVars[332] /* particleReceiver1D.gc_b[9] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1316
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[9] = particleReceiver1D.jc_f[9] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1316(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1316};
  data->localData[0]->realVars[144] /* particleReceiver1D.Qloss_jcf_discrete[9] variable */ = (data->localData[0]->realVars[395] /* particleReceiver1D.jc_f[9] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1317
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[9] = particleReceiver1D.q_conv_curtain[9] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1317(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1317};
  data->localData[0]->realVars[51] /* particleReceiver1D.Qloss_conv_curtain_discrete[9] variable */ = (data->localData[0]->realVars[457] /* particleReceiver1D.q_conv_curtain[9] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1318
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[8] = particleReceiver1D.q_conv_curtain[8] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1318(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1318};
  data->localData[0]->realVars[50] /* particleReceiver1D.Qloss_conv_curtain_discrete[8] variable */ = (data->localData[0]->realVars[456] /* particleReceiver1D.q_conv_curtain[8] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1319
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[8] = particleReceiver1D.gc_b[8] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1319(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1319};
  data->localData[0]->realVars[19] /* particleReceiver1D.Qgain_gcb_discrete[8] variable */ = (data->localData[0]->realVars[331] /* particleReceiver1D.gc_b[8] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1320
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[8] = particleReceiver1D.q_conv_wall[8] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1320(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1320};
  data->localData[0]->realVars[81] /* particleReceiver1D.Qloss_conv_wall_discrete[8] variable */ = (data->localData[0]->realVars[486] /* particleReceiver1D.q_conv_wall[8] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1321
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[7] = particleReceiver1D.q_conv_wall[7] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1321(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1321};
  data->localData[0]->realVars[80] /* particleReceiver1D.Qloss_conv_wall_discrete[7] variable */ = (data->localData[0]->realVars[485] /* particleReceiver1D.q_conv_wall[7] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1322
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[7] = particleReceiver1D.g_w[7] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1322(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1322};
  data->localData[0]->realVars[111] /* particleReceiver1D.Qloss_jcb_discrete[7] variable */ = (data->localData[0]->realVars[300] /* particleReceiver1D.g_w[7] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1323
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[7] = particleReceiver1D.gc_b[7] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1323(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1323};
  data->localData[0]->realVars[18] /* particleReceiver1D.Qgain_gcb_discrete[7] variable */ = (data->localData[0]->realVars[330] /* particleReceiver1D.gc_b[7] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1324
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[7] = particleReceiver1D.jc_f[7] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1324(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1324};
  data->localData[0]->realVars[142] /* particleReceiver1D.Qloss_jcf_discrete[7] variable */ = (data->localData[0]->realVars[393] /* particleReceiver1D.jc_f[7] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1325
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[7] = particleReceiver1D.q_conv_curtain[7] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1325(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1325};
  data->localData[0]->realVars[49] /* particleReceiver1D.Qloss_conv_curtain_discrete[7] variable */ = (data->localData[0]->realVars[455] /* particleReceiver1D.q_conv_curtain[7] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1326
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[6] = particleReceiver1D.q_conv_curtain[6] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1326(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1326};
  data->localData[0]->realVars[48] /* particleReceiver1D.Qloss_conv_curtain_discrete[6] variable */ = (data->localData[0]->realVars[454] /* particleReceiver1D.q_conv_curtain[6] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1327
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[5] = particleReceiver1D.q_conv_curtain[5] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1327(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1327};
  data->localData[0]->realVars[47] /* particleReceiver1D.Qloss_conv_curtain_discrete[5] variable */ = (data->localData[0]->realVars[453] /* particleReceiver1D.q_conv_curtain[5] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1328
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[5] = particleReceiver1D.jc_f[5] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1328(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1328};
  data->localData[0]->realVars[140] /* particleReceiver1D.Qloss_jcf_discrete[5] variable */ = (data->localData[0]->realVars[391] /* particleReceiver1D.jc_f[5] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1329
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[4] = particleReceiver1D.q_conv_curtain[4] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1329(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1329};
  data->localData[0]->realVars[46] /* particleReceiver1D.Qloss_conv_curtain_discrete[4] variable */ = (data->localData[0]->realVars[452] /* particleReceiver1D.q_conv_curtain[4] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1330
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[4] = particleReceiver1D.jc_f[4] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1330(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1330};
  data->localData[0]->realVars[139] /* particleReceiver1D.Qloss_jcf_discrete[4] variable */ = (data->localData[0]->realVars[390] /* particleReceiver1D.jc_f[4] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1331
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[4] = particleReceiver1D.gc_b[4] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1331(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1331};
  data->localData[0]->realVars[15] /* particleReceiver1D.Qgain_gcb_discrete[4] variable */ = (data->localData[0]->realVars[327] /* particleReceiver1D.gc_b[4] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1332
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[4] = particleReceiver1D.q_conv_wall[4] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1332(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1332};
  data->localData[0]->realVars[77] /* particleReceiver1D.Qloss_conv_wall_discrete[4] variable */ = (data->localData[0]->realVars[482] /* particleReceiver1D.q_conv_wall[4] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1333
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[3] = particleReceiver1D.q_conv_wall[3] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1333(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1333};
  data->localData[0]->realVars[76] /* particleReceiver1D.Qloss_conv_wall_discrete[3] variable */ = (data->localData[0]->realVars[481] /* particleReceiver1D.q_conv_wall[3] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1334
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[3] = particleReceiver1D.g_w[3] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1334(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1334};
  data->localData[0]->realVars[107] /* particleReceiver1D.Qloss_jcb_discrete[3] variable */ = (data->localData[0]->realVars[296] /* particleReceiver1D.g_w[3] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1335
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[3] = particleReceiver1D.gc_b[3] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1335(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1335};
  data->localData[0]->realVars[14] /* particleReceiver1D.Qgain_gcb_discrete[3] variable */ = (data->localData[0]->realVars[326] /* particleReceiver1D.gc_b[3] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1336
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[3] = particleReceiver1D.jc_f[3] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1336(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1336};
  data->localData[0]->realVars[138] /* particleReceiver1D.Qloss_jcf_discrete[3] variable */ = (data->localData[0]->realVars[389] /* particleReceiver1D.jc_f[3] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1337
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[3] = particleReceiver1D.q_conv_curtain[3] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1337(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1337};
  data->localData[0]->realVars[45] /* particleReceiver1D.Qloss_conv_curtain_discrete[3] variable */ = (data->localData[0]->realVars[451] /* particleReceiver1D.q_conv_curtain[3] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1338
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb_discrete[2] = particleReceiver1D.gc_b[2] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1338(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1338};
  data->localData[0]->realVars[13] /* particleReceiver1D.Qgain_gcb_discrete[2] variable */ = (data->localData[0]->realVars[325] /* particleReceiver1D.gc_b[2] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1339
type: SIMPLE_ASSIGN
particleReceiver1D._Qgain_gcb = particleReceiver1D.Qgain_gcb_discrete[1] + particleReceiver1D.Qgain_gcb_discrete[2] + particleReceiver1D.Qgain_gcb_discrete[3] + particleReceiver1D.Qgain_gcb_discrete[4] + particleReceiver1D.Qgain_gcb_discrete[5] + particleReceiver1D.Qgain_gcb_discrete[6] + particleReceiver1D.Qgain_gcb_discrete[7] + particleReceiver1D.Qgain_gcb_discrete[8] + particleReceiver1D.Qgain_gcb_discrete[9] + particleReceiver1D.Qgain_gcb_discrete[10] + particleReceiver1D.Qgain_gcb_discrete[11] + particleReceiver1D.Qgain_gcb_discrete[12] + particleReceiver1D.Qgain_gcb_discrete[13] + particleReceiver1D.Qgain_gcb_discrete[14] + particleReceiver1D.Qgain_gcb_discrete[15] + particleReceiver1D.Qgain_gcb_discrete[16] + particleReceiver1D.Qgain_gcb_discrete[17] + particleReceiver1D.Qgain_gcb_discrete[18] + particleReceiver1D.Qgain_gcb_discrete[19] + particleReceiver1D.Qgain_gcb_discrete[20] + particleReceiver1D.Qgain_gcb_discrete[21] + particleReceiver1D.Qgain_gcb_discrete[22] + particleReceiver1D.Qgain_gcb_discrete[23] + particleReceiver1D.Qgain_gcb_discrete[24] + particleReceiver1D.Qgain_gcb_discrete[25] + particleReceiver1D.Qgain_gcb_discrete[26] + particleReceiver1D.Qgain_gcb_discrete[27] + particleReceiver1D.Qgain_gcb_discrete[28] + particleReceiver1D.Qgain_gcb_discrete[29] + particleReceiver1D.Qgain_gcb_discrete[30]
*/
void ParticleReceiver1DCalculator_eqFunction_1339(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1339};
  data->localData[0]->realVars[11] /* particleReceiver1D.Qgain_gcb variable */ = data->localData[0]->realVars[12] /* particleReceiver1D.Qgain_gcb_discrete[1] variable */ + data->localData[0]->realVars[13] /* particleReceiver1D.Qgain_gcb_discrete[2] variable */ + data->localData[0]->realVars[14] /* particleReceiver1D.Qgain_gcb_discrete[3] variable */ + data->localData[0]->realVars[15] /* particleReceiver1D.Qgain_gcb_discrete[4] variable */ + data->localData[0]->realVars[16] /* particleReceiver1D.Qgain_gcb_discrete[5] variable */ + data->localData[0]->realVars[17] /* particleReceiver1D.Qgain_gcb_discrete[6] variable */ + data->localData[0]->realVars[18] /* particleReceiver1D.Qgain_gcb_discrete[7] variable */ + data->localData[0]->realVars[19] /* particleReceiver1D.Qgain_gcb_discrete[8] variable */ + data->localData[0]->realVars[20] /* particleReceiver1D.Qgain_gcb_discrete[9] variable */ + data->localData[0]->realVars[21] /* particleReceiver1D.Qgain_gcb_discrete[10] variable */ + data->localData[0]->realVars[22] /* particleReceiver1D.Qgain_gcb_discrete[11] variable */ + data->localData[0]->realVars[23] /* particleReceiver1D.Qgain_gcb_discrete[12] variable */ + data->localData[0]->realVars[24] /* particleReceiver1D.Qgain_gcb_discrete[13] variable */ + data->localData[0]->realVars[25] /* particleReceiver1D.Qgain_gcb_discrete[14] variable */ + data->localData[0]->realVars[26] /* particleReceiver1D.Qgain_gcb_discrete[15] variable */ + data->localData[0]->realVars[27] /* particleReceiver1D.Qgain_gcb_discrete[16] variable */ + data->localData[0]->realVars[28] /* particleReceiver1D.Qgain_gcb_discrete[17] variable */ + data->localData[0]->realVars[29] /* particleReceiver1D.Qgain_gcb_discrete[18] variable */ + data->localData[0]->realVars[30] /* particleReceiver1D.Qgain_gcb_discrete[19] variable */ + data->localData[0]->realVars[31] /* particleReceiver1D.Qgain_gcb_discrete[20] variable */ + data->localData[0]->realVars[32] /* particleReceiver1D.Qgain_gcb_discrete[21] variable */ + data->localData[0]->realVars[33] /* particleReceiver1D.Qgain_gcb_discrete[22] variable */ + data->localData[0]->realVars[34] /* particleReceiver1D.Qgain_gcb_discrete[23] variable */ + data->localData[0]->realVars[35] /* particleReceiver1D.Qgain_gcb_discrete[24] variable */ + data->localData[0]->realVars[36] /* particleReceiver1D.Qgain_gcb_discrete[25] variable */ + data->localData[0]->realVars[37] /* particleReceiver1D.Qgain_gcb_discrete[26] variable */ + data->localData[0]->realVars[38] /* particleReceiver1D.Qgain_gcb_discrete[27] variable */ + data->localData[0]->realVars[39] /* particleReceiver1D.Qgain_gcb_discrete[28] variable */ + data->localData[0]->realVars[40] /* particleReceiver1D.Qgain_gcb_discrete[29] variable */ + data->localData[0]->realVars[41] /* particleReceiver1D.Qgain_gcb_discrete[30] variable */;
  TRACE_POP
}
/*
equation index: 1340
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[2] = particleReceiver1D.jc_f[2] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1340(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1340};
  data->localData[0]->realVars[137] /* particleReceiver1D.Qloss_jcf_discrete[2] variable */ = (data->localData[0]->realVars[388] /* particleReceiver1D.jc_f[2] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1341
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[2] = particleReceiver1D.q_conv_curtain[2] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1341(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1341};
  data->localData[0]->realVars[44] /* particleReceiver1D.Qloss_conv_curtain_discrete[2] variable */ = (data->localData[0]->realVars[450] /* particleReceiver1D.q_conv_curtain[2] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1342
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[2] = particleReceiver1D.g_w[2] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1342(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1342};
  data->localData[0]->realVars[106] /* particleReceiver1D.Qloss_jcb_discrete[2] variable */ = (data->localData[0]->realVars[295] /* particleReceiver1D.g_w[2] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1343
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[2] = particleReceiver1D.q_conv_wall[2] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1343(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1343};
  data->localData[0]->realVars[75] /* particleReceiver1D.Qloss_conv_wall_discrete[2] variable */ = (data->localData[0]->realVars[480] /* particleReceiver1D.q_conv_wall[2] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1344
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall_discrete[1] = particleReceiver1D.q_conv_wall[1] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1344(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1344};
  data->localData[0]->realVars[74] /* particleReceiver1D.Qloss_conv_wall_discrete[1] variable */ = (data->localData[0]->realVars[479] /* particleReceiver1D.q_conv_wall[1] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1345
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_wall = particleReceiver1D.Qloss_conv_wall_discrete[1] + particleReceiver1D.Qloss_conv_wall_discrete[2] + particleReceiver1D.Qloss_conv_wall_discrete[3] + particleReceiver1D.Qloss_conv_wall_discrete[4] + particleReceiver1D.Qloss_conv_wall_discrete[5] + particleReceiver1D.Qloss_conv_wall_discrete[6] + particleReceiver1D.Qloss_conv_wall_discrete[7] + particleReceiver1D.Qloss_conv_wall_discrete[8] + particleReceiver1D.Qloss_conv_wall_discrete[9] + particleReceiver1D.Qloss_conv_wall_discrete[10] + particleReceiver1D.Qloss_conv_wall_discrete[11] + particleReceiver1D.Qloss_conv_wall_discrete[12] + particleReceiver1D.Qloss_conv_wall_discrete[13] + particleReceiver1D.Qloss_conv_wall_discrete[14] + particleReceiver1D.Qloss_conv_wall_discrete[15] + particleReceiver1D.Qloss_conv_wall_discrete[16] + particleReceiver1D.Qloss_conv_wall_discrete[17] + particleReceiver1D.Qloss_conv_wall_discrete[18] + particleReceiver1D.Qloss_conv_wall_discrete[19] + particleReceiver1D.Qloss_conv_wall_discrete[20] + particleReceiver1D.Qloss_conv_wall_discrete[21] + particleReceiver1D.Qloss_conv_wall_discrete[22] + particleReceiver1D.Qloss_conv_wall_discrete[23] + particleReceiver1D.Qloss_conv_wall_discrete[24] + particleReceiver1D.Qloss_conv_wall_discrete[25] + particleReceiver1D.Qloss_conv_wall_discrete[26] + particleReceiver1D.Qloss_conv_wall_discrete[27] + particleReceiver1D.Qloss_conv_wall_discrete[28] + particleReceiver1D.Qloss_conv_wall_discrete[29] + particleReceiver1D.Qloss_conv_wall_discrete[30]
*/
void ParticleReceiver1DCalculator_eqFunction_1345(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1345};
  data->localData[0]->realVars[73] /* particleReceiver1D.Qloss_conv_wall variable */ = data->localData[0]->realVars[74] /* particleReceiver1D.Qloss_conv_wall_discrete[1] variable */ + data->localData[0]->realVars[75] /* particleReceiver1D.Qloss_conv_wall_discrete[2] variable */ + data->localData[0]->realVars[76] /* particleReceiver1D.Qloss_conv_wall_discrete[3] variable */ + data->localData[0]->realVars[77] /* particleReceiver1D.Qloss_conv_wall_discrete[4] variable */ + data->localData[0]->realVars[78] /* particleReceiver1D.Qloss_conv_wall_discrete[5] variable */ + data->localData[0]->realVars[79] /* particleReceiver1D.Qloss_conv_wall_discrete[6] variable */ + data->localData[0]->realVars[80] /* particleReceiver1D.Qloss_conv_wall_discrete[7] variable */ + data->localData[0]->realVars[81] /* particleReceiver1D.Qloss_conv_wall_discrete[8] variable */ + data->localData[0]->realVars[82] /* particleReceiver1D.Qloss_conv_wall_discrete[9] variable */ + data->localData[0]->realVars[83] /* particleReceiver1D.Qloss_conv_wall_discrete[10] variable */ + data->localData[0]->realVars[84] /* particleReceiver1D.Qloss_conv_wall_discrete[11] variable */ + data->localData[0]->realVars[85] /* particleReceiver1D.Qloss_conv_wall_discrete[12] variable */ + data->localData[0]->realVars[86] /* particleReceiver1D.Qloss_conv_wall_discrete[13] variable */ + data->localData[0]->realVars[87] /* particleReceiver1D.Qloss_conv_wall_discrete[14] variable */ + data->localData[0]->realVars[88] /* particleReceiver1D.Qloss_conv_wall_discrete[15] variable */ + data->localData[0]->realVars[89] /* particleReceiver1D.Qloss_conv_wall_discrete[16] variable */ + data->localData[0]->realVars[90] /* particleReceiver1D.Qloss_conv_wall_discrete[17] variable */ + data->localData[0]->realVars[91] /* particleReceiver1D.Qloss_conv_wall_discrete[18] variable */ + data->localData[0]->realVars[92] /* particleReceiver1D.Qloss_conv_wall_discrete[19] variable */ + data->localData[0]->realVars[93] /* particleReceiver1D.Qloss_conv_wall_discrete[20] variable */ + data->localData[0]->realVars[94] /* particleReceiver1D.Qloss_conv_wall_discrete[21] variable */ + data->localData[0]->realVars[95] /* particleReceiver1D.Qloss_conv_wall_discrete[22] variable */ + data->localData[0]->realVars[96] /* particleReceiver1D.Qloss_conv_wall_discrete[23] variable */ + data->localData[0]->realVars[97] /* particleReceiver1D.Qloss_conv_wall_discrete[24] variable */ + data->localData[0]->realVars[98] /* particleReceiver1D.Qloss_conv_wall_discrete[25] variable */ + data->localData[0]->realVars[99] /* particleReceiver1D.Qloss_conv_wall_discrete[26] variable */ + data->localData[0]->realVars[100] /* particleReceiver1D.Qloss_conv_wall_discrete[27] variable */ + data->localData[0]->realVars[101] /* particleReceiver1D.Qloss_conv_wall_discrete[28] variable */ + data->localData[0]->realVars[102] /* particleReceiver1D.Qloss_conv_wall_discrete[29] variable */ + data->localData[0]->realVars[103] /* particleReceiver1D.Qloss_conv_wall_discrete[30] variable */;
  TRACE_POP
}
/*
equation index: 1346
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb_discrete[1] = particleReceiver1D.g_w[1] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1346(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1346};
  data->localData[0]->realVars[105] /* particleReceiver1D.Qloss_jcb_discrete[1] variable */ = (data->localData[0]->realVars[294] /* particleReceiver1D.g_w[1] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1347
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcb = particleReceiver1D.Qloss_jcb_discrete[1] + particleReceiver1D.Qloss_jcb_discrete[2] + particleReceiver1D.Qloss_jcb_discrete[3] + particleReceiver1D.Qloss_jcb_discrete[4] + particleReceiver1D.Qloss_jcb_discrete[5] + particleReceiver1D.Qloss_jcb_discrete[6] + particleReceiver1D.Qloss_jcb_discrete[7] + particleReceiver1D.Qloss_jcb_discrete[8] + particleReceiver1D.Qloss_jcb_discrete[9] + particleReceiver1D.Qloss_jcb_discrete[10] + particleReceiver1D.Qloss_jcb_discrete[11] + particleReceiver1D.Qloss_jcb_discrete[12] + particleReceiver1D.Qloss_jcb_discrete[13] + particleReceiver1D.Qloss_jcb_discrete[14] + particleReceiver1D.Qloss_jcb_discrete[15] + particleReceiver1D.Qloss_jcb_discrete[16] + particleReceiver1D.Qloss_jcb_discrete[17] + particleReceiver1D.Qloss_jcb_discrete[18] + particleReceiver1D.Qloss_jcb_discrete[19] + particleReceiver1D.Qloss_jcb_discrete[20] + particleReceiver1D.Qloss_jcb_discrete[21] + particleReceiver1D.Qloss_jcb_discrete[22] + particleReceiver1D.Qloss_jcb_discrete[23] + particleReceiver1D.Qloss_jcb_discrete[24] + particleReceiver1D.Qloss_jcb_discrete[25] + particleReceiver1D.Qloss_jcb_discrete[26] + particleReceiver1D.Qloss_jcb_discrete[27] + particleReceiver1D.Qloss_jcb_discrete[28] + particleReceiver1D.Qloss_jcb_discrete[29] + particleReceiver1D.Qloss_jcb_discrete[30]
*/
void ParticleReceiver1DCalculator_eqFunction_1347(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1347};
  data->localData[0]->realVars[104] /* particleReceiver1D.Qloss_jcb variable */ = data->localData[0]->realVars[105] /* particleReceiver1D.Qloss_jcb_discrete[1] variable */ + data->localData[0]->realVars[106] /* particleReceiver1D.Qloss_jcb_discrete[2] variable */ + data->localData[0]->realVars[107] /* particleReceiver1D.Qloss_jcb_discrete[3] variable */ + data->localData[0]->realVars[108] /* particleReceiver1D.Qloss_jcb_discrete[4] variable */ + data->localData[0]->realVars[109] /* particleReceiver1D.Qloss_jcb_discrete[5] variable */ + data->localData[0]->realVars[110] /* particleReceiver1D.Qloss_jcb_discrete[6] variable */ + data->localData[0]->realVars[111] /* particleReceiver1D.Qloss_jcb_discrete[7] variable */ + data->localData[0]->realVars[112] /* particleReceiver1D.Qloss_jcb_discrete[8] variable */ + data->localData[0]->realVars[113] /* particleReceiver1D.Qloss_jcb_discrete[9] variable */ + data->localData[0]->realVars[114] /* particleReceiver1D.Qloss_jcb_discrete[10] variable */ + data->localData[0]->realVars[115] /* particleReceiver1D.Qloss_jcb_discrete[11] variable */ + data->localData[0]->realVars[116] /* particleReceiver1D.Qloss_jcb_discrete[12] variable */ + data->localData[0]->realVars[117] /* particleReceiver1D.Qloss_jcb_discrete[13] variable */ + data->localData[0]->realVars[118] /* particleReceiver1D.Qloss_jcb_discrete[14] variable */ + data->localData[0]->realVars[119] /* particleReceiver1D.Qloss_jcb_discrete[15] variable */ + data->localData[0]->realVars[120] /* particleReceiver1D.Qloss_jcb_discrete[16] variable */ + data->localData[0]->realVars[121] /* particleReceiver1D.Qloss_jcb_discrete[17] variable */ + data->localData[0]->realVars[122] /* particleReceiver1D.Qloss_jcb_discrete[18] variable */ + data->localData[0]->realVars[123] /* particleReceiver1D.Qloss_jcb_discrete[19] variable */ + data->localData[0]->realVars[124] /* particleReceiver1D.Qloss_jcb_discrete[20] variable */ + data->localData[0]->realVars[125] /* particleReceiver1D.Qloss_jcb_discrete[21] variable */ + data->localData[0]->realVars[126] /* particleReceiver1D.Qloss_jcb_discrete[22] variable */ + data->localData[0]->realVars[127] /* particleReceiver1D.Qloss_jcb_discrete[23] variable */ + data->localData[0]->realVars[128] /* particleReceiver1D.Qloss_jcb_discrete[24] variable */ + data->localData[0]->realVars[129] /* particleReceiver1D.Qloss_jcb_discrete[25] variable */ + data->localData[0]->realVars[130] /* particleReceiver1D.Qloss_jcb_discrete[26] variable */ + data->localData[0]->realVars[131] /* particleReceiver1D.Qloss_jcb_discrete[27] variable */ + data->localData[0]->realVars[132] /* particleReceiver1D.Qloss_jcb_discrete[28] variable */ + data->localData[0]->realVars[133] /* particleReceiver1D.Qloss_jcb_discrete[29] variable */ + data->localData[0]->realVars[134] /* particleReceiver1D.Qloss_jcb_discrete[30] variable */;
  TRACE_POP
}
/*
equation index: 1348
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf_discrete[1] = particleReceiver1D.jc_f[1] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1348(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1348};
  data->localData[0]->realVars[136] /* particleReceiver1D.Qloss_jcf_discrete[1] variable */ = (data->localData[0]->realVars[387] /* particleReceiver1D.jc_f[1] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1349
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_jcf = particleReceiver1D.Qloss_jcf_discrete[1] + particleReceiver1D.Qloss_jcf_discrete[2] + particleReceiver1D.Qloss_jcf_discrete[3] + particleReceiver1D.Qloss_jcf_discrete[4] + particleReceiver1D.Qloss_jcf_discrete[5] + particleReceiver1D.Qloss_jcf_discrete[6] + particleReceiver1D.Qloss_jcf_discrete[7] + particleReceiver1D.Qloss_jcf_discrete[8] + particleReceiver1D.Qloss_jcf_discrete[9] + particleReceiver1D.Qloss_jcf_discrete[10] + particleReceiver1D.Qloss_jcf_discrete[11] + particleReceiver1D.Qloss_jcf_discrete[12] + particleReceiver1D.Qloss_jcf_discrete[13] + particleReceiver1D.Qloss_jcf_discrete[14] + particleReceiver1D.Qloss_jcf_discrete[15] + particleReceiver1D.Qloss_jcf_discrete[16] + particleReceiver1D.Qloss_jcf_discrete[17] + particleReceiver1D.Qloss_jcf_discrete[18] + particleReceiver1D.Qloss_jcf_discrete[19] + particleReceiver1D.Qloss_jcf_discrete[20] + particleReceiver1D.Qloss_jcf_discrete[21] + particleReceiver1D.Qloss_jcf_discrete[22] + particleReceiver1D.Qloss_jcf_discrete[23] + particleReceiver1D.Qloss_jcf_discrete[24] + particleReceiver1D.Qloss_jcf_discrete[25] + particleReceiver1D.Qloss_jcf_discrete[26] + particleReceiver1D.Qloss_jcf_discrete[27] + particleReceiver1D.Qloss_jcf_discrete[28] + particleReceiver1D.Qloss_jcf_discrete[29] + particleReceiver1D.Qloss_jcf_discrete[30]
*/
void ParticleReceiver1DCalculator_eqFunction_1349(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1349};
  data->localData[0]->realVars[135] /* particleReceiver1D.Qloss_jcf variable */ = data->localData[0]->realVars[136] /* particleReceiver1D.Qloss_jcf_discrete[1] variable */ + data->localData[0]->realVars[137] /* particleReceiver1D.Qloss_jcf_discrete[2] variable */ + data->localData[0]->realVars[138] /* particleReceiver1D.Qloss_jcf_discrete[3] variable */ + data->localData[0]->realVars[139] /* particleReceiver1D.Qloss_jcf_discrete[4] variable */ + data->localData[0]->realVars[140] /* particleReceiver1D.Qloss_jcf_discrete[5] variable */ + data->localData[0]->realVars[141] /* particleReceiver1D.Qloss_jcf_discrete[6] variable */ + data->localData[0]->realVars[142] /* particleReceiver1D.Qloss_jcf_discrete[7] variable */ + data->localData[0]->realVars[143] /* particleReceiver1D.Qloss_jcf_discrete[8] variable */ + data->localData[0]->realVars[144] /* particleReceiver1D.Qloss_jcf_discrete[9] variable */ + data->localData[0]->realVars[145] /* particleReceiver1D.Qloss_jcf_discrete[10] variable */ + data->localData[0]->realVars[146] /* particleReceiver1D.Qloss_jcf_discrete[11] variable */ + data->localData[0]->realVars[147] /* particleReceiver1D.Qloss_jcf_discrete[12] variable */ + data->localData[0]->realVars[148] /* particleReceiver1D.Qloss_jcf_discrete[13] variable */ + data->localData[0]->realVars[149] /* particleReceiver1D.Qloss_jcf_discrete[14] variable */ + data->localData[0]->realVars[150] /* particleReceiver1D.Qloss_jcf_discrete[15] variable */ + data->localData[0]->realVars[151] /* particleReceiver1D.Qloss_jcf_discrete[16] variable */ + data->localData[0]->realVars[152] /* particleReceiver1D.Qloss_jcf_discrete[17] variable */ + data->localData[0]->realVars[153] /* particleReceiver1D.Qloss_jcf_discrete[18] variable */ + data->localData[0]->realVars[154] /* particleReceiver1D.Qloss_jcf_discrete[19] variable */ + data->localData[0]->realVars[155] /* particleReceiver1D.Qloss_jcf_discrete[20] variable */ + data->localData[0]->realVars[156] /* particleReceiver1D.Qloss_jcf_discrete[21] variable */ + data->localData[0]->realVars[157] /* particleReceiver1D.Qloss_jcf_discrete[22] variable */ + data->localData[0]->realVars[158] /* particleReceiver1D.Qloss_jcf_discrete[23] variable */ + data->localData[0]->realVars[159] /* particleReceiver1D.Qloss_jcf_discrete[24] variable */ + data->localData[0]->realVars[160] /* particleReceiver1D.Qloss_jcf_discrete[25] variable */ + data->localData[0]->realVars[161] /* particleReceiver1D.Qloss_jcf_discrete[26] variable */ + data->localData[0]->realVars[162] /* particleReceiver1D.Qloss_jcf_discrete[27] variable */ + data->localData[0]->realVars[163] /* particleReceiver1D.Qloss_jcf_discrete[28] variable */ + data->localData[0]->realVars[164] /* particleReceiver1D.Qloss_jcf_discrete[29] variable */ + data->localData[0]->realVars[165] /* particleReceiver1D.Qloss_jcf_discrete[30] variable */;
  TRACE_POP
}
/*
equation index: 1350
type: SIMPLE_ASSIGN
particleReceiver1D._Q_check_curtain = particleReceiver1D.Qabsorbed - particleReceiver1D.dx * particleReceiver1D.W_rcv * (particleReceiver1D.q_net[1] + particleReceiver1D.q_net[2] + particleReceiver1D.q_net[3] + particleReceiver1D.q_net[4] + particleReceiver1D.q_net[5] + particleReceiver1D.q_net[6] + particleReceiver1D.q_net[7] + particleReceiver1D.q_net[8] + particleReceiver1D.q_net[9] + particleReceiver1D.q_net[10] + particleReceiver1D.q_net[11] + particleReceiver1D.q_net[12] + particleReceiver1D.q_net[13] + particleReceiver1D.q_net[14] + particleReceiver1D.q_net[15] + particleReceiver1D.q_net[16] + particleReceiver1D.q_net[17] + particleReceiver1D.q_net[18] + particleReceiver1D.q_net[19] + particleReceiver1D.q_net[20] + particleReceiver1D.q_net[21] + particleReceiver1D.q_net[22] + particleReceiver1D.q_net[23] + particleReceiver1D.q_net[24] + particleReceiver1D.q_net[25] + particleReceiver1D.q_net[26] + particleReceiver1D.q_net[27] + particleReceiver1D.q_net[28] + particleReceiver1D.q_net[29] + particleReceiver1D.q_net[30])
*/
void ParticleReceiver1DCalculator_eqFunction_1350(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1350};
  data->localData[0]->realVars[8] /* particleReceiver1D.Q_check_curtain variable */ = data->localData[0]->realVars[9] /* particleReceiver1D.Qabsorbed variable */ - ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * ((data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[509] /* particleReceiver1D.q_net[1] variable */ + data->localData[0]->realVars[510] /* particleReceiver1D.q_net[2] variable */ + data->localData[0]->realVars[511] /* particleReceiver1D.q_net[3] variable */ + data->localData[0]->realVars[512] /* particleReceiver1D.q_net[4] variable */ + data->localData[0]->realVars[513] /* particleReceiver1D.q_net[5] variable */ + data->localData[0]->realVars[514] /* particleReceiver1D.q_net[6] variable */ + data->localData[0]->realVars[515] /* particleReceiver1D.q_net[7] variable */ + data->localData[0]->realVars[516] /* particleReceiver1D.q_net[8] variable */ + data->localData[0]->realVars[517] /* particleReceiver1D.q_net[9] variable */ + data->localData[0]->realVars[518] /* particleReceiver1D.q_net[10] variable */ + data->localData[0]->realVars[519] /* particleReceiver1D.q_net[11] variable */ + data->localData[0]->realVars[520] /* particleReceiver1D.q_net[12] variable */ + data->localData[0]->realVars[521] /* particleReceiver1D.q_net[13] variable */ + data->localData[0]->realVars[522] /* particleReceiver1D.q_net[14] variable */ + data->localData[0]->realVars[523] /* particleReceiver1D.q_net[15] variable */ + data->localData[0]->realVars[524] /* particleReceiver1D.q_net[16] variable */ + data->localData[0]->realVars[525] /* particleReceiver1D.q_net[17] variable */ + data->localData[0]->realVars[526] /* particleReceiver1D.q_net[18] variable */ + data->localData[0]->realVars[527] /* particleReceiver1D.q_net[19] variable */ + data->localData[0]->realVars[528] /* particleReceiver1D.q_net[20] variable */ + data->localData[0]->realVars[529] /* particleReceiver1D.q_net[21] variable */ + data->localData[0]->realVars[530] /* particleReceiver1D.q_net[22] variable */ + data->localData[0]->realVars[531] /* particleReceiver1D.q_net[23] variable */ + data->localData[0]->realVars[532] /* particleReceiver1D.q_net[24] variable */ + data->localData[0]->realVars[533] /* particleReceiver1D.q_net[25] variable */ + data->localData[0]->realVars[534] /* particleReceiver1D.q_net[26] variable */ + data->localData[0]->realVars[535] /* particleReceiver1D.q_net[27] variable */ + data->localData[0]->realVars[536] /* particleReceiver1D.q_net[28] variable */ + data->localData[0]->realVars[537] /* particleReceiver1D.q_net[29] variable */ + data->localData[0]->realVars[538] /* particleReceiver1D.q_net[30] variable */)));
  TRACE_POP
}
/*
equation index: 1351
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain_discrete[1] = particleReceiver1D.q_conv_curtain[1] * particleReceiver1D.dx * particleReceiver1D.W_rcv
*/
void ParticleReceiver1DCalculator_eqFunction_1351(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1351};
  data->localData[0]->realVars[43] /* particleReceiver1D.Qloss_conv_curtain_discrete[1] variable */ = (data->localData[0]->realVars[449] /* particleReceiver1D.q_conv_curtain[1] variable */) * ((data->localData[0]->realVars[261] /* particleReceiver1D.dx variable */) * (data->localData[0]->realVars[230] /* particleReceiver1D.W_rcv variable */));
  TRACE_POP
}
/*
equation index: 1352
type: SIMPLE_ASSIGN
particleReceiver1D._Qloss_conv_curtain = particleReceiver1D.Qloss_conv_curtain_discrete[1] + particleReceiver1D.Qloss_conv_curtain_discrete[2] + particleReceiver1D.Qloss_conv_curtain_discrete[3] + particleReceiver1D.Qloss_conv_curtain_discrete[4] + particleReceiver1D.Qloss_conv_curtain_discrete[5] + particleReceiver1D.Qloss_conv_curtain_discrete[6] + particleReceiver1D.Qloss_conv_curtain_discrete[7] + particleReceiver1D.Qloss_conv_curtain_discrete[8] + particleReceiver1D.Qloss_conv_curtain_discrete[9] + particleReceiver1D.Qloss_conv_curtain_discrete[10] + particleReceiver1D.Qloss_conv_curtain_discrete[11] + particleReceiver1D.Qloss_conv_curtain_discrete[12] + particleReceiver1D.Qloss_conv_curtain_discrete[13] + particleReceiver1D.Qloss_conv_curtain_discrete[14] + particleReceiver1D.Qloss_conv_curtain_discrete[15] + particleReceiver1D.Qloss_conv_curtain_discrete[16] + particleReceiver1D.Qloss_conv_curtain_discrete[17] + particleReceiver1D.Qloss_conv_curtain_discrete[18] + particleReceiver1D.Qloss_conv_curtain_discrete[19] + particleReceiver1D.Qloss_conv_curtain_discrete[20] + particleReceiver1D.Qloss_conv_curtain_discrete[21] + particleReceiver1D.Qloss_conv_curtain_discrete[22] + particleReceiver1D.Qloss_conv_curtain_discrete[23] + particleReceiver1D.Qloss_conv_curtain_discrete[24] + particleReceiver1D.Qloss_conv_curtain_discrete[25] + particleReceiver1D.Qloss_conv_curtain_discrete[26] + particleReceiver1D.Qloss_conv_curtain_discrete[27] + particleReceiver1D.Qloss_conv_curtain_discrete[28] + particleReceiver1D.Qloss_conv_curtain_discrete[29] + particleReceiver1D.Qloss_conv_curtain_discrete[30]
*/
void ParticleReceiver1DCalculator_eqFunction_1352(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1352};
  data->localData[0]->realVars[42] /* particleReceiver1D.Qloss_conv_curtain variable */ = data->localData[0]->realVars[43] /* particleReceiver1D.Qloss_conv_curtain_discrete[1] variable */ + data->localData[0]->realVars[44] /* particleReceiver1D.Qloss_conv_curtain_discrete[2] variable */ + data->localData[0]->realVars[45] /* particleReceiver1D.Qloss_conv_curtain_discrete[3] variable */ + data->localData[0]->realVars[46] /* particleReceiver1D.Qloss_conv_curtain_discrete[4] variable */ + data->localData[0]->realVars[47] /* particleReceiver1D.Qloss_conv_curtain_discrete[5] variable */ + data->localData[0]->realVars[48] /* particleReceiver1D.Qloss_conv_curtain_discrete[6] variable */ + data->localData[0]->realVars[49] /* particleReceiver1D.Qloss_conv_curtain_discrete[7] variable */ + data->localData[0]->realVars[50] /* particleReceiver1D.Qloss_conv_curtain_discrete[8] variable */ + data->localData[0]->realVars[51] /* particleReceiver1D.Qloss_conv_curtain_discrete[9] variable */ + data->localData[0]->realVars[52] /* particleReceiver1D.Qloss_conv_curtain_discrete[10] variable */ + data->localData[0]->realVars[53] /* particleReceiver1D.Qloss_conv_curtain_discrete[11] variable */ + data->localData[0]->realVars[54] /* particleReceiver1D.Qloss_conv_curtain_discrete[12] variable */ + data->localData[0]->realVars[55] /* particleReceiver1D.Qloss_conv_curtain_discrete[13] variable */ + data->localData[0]->realVars[56] /* particleReceiver1D.Qloss_conv_curtain_discrete[14] variable */ + data->localData[0]->realVars[57] /* particleReceiver1D.Qloss_conv_curtain_discrete[15] variable */ + data->localData[0]->realVars[58] /* particleReceiver1D.Qloss_conv_curtain_discrete[16] variable */ + data->localData[0]->realVars[59] /* particleReceiver1D.Qloss_conv_curtain_discrete[17] variable */ + data->localData[0]->realVars[60] /* particleReceiver1D.Qloss_conv_curtain_discrete[18] variable */ + data->localData[0]->realVars[61] /* particleReceiver1D.Qloss_conv_curtain_discrete[19] variable */ + data->localData[0]->realVars[62] /* particleReceiver1D.Qloss_conv_curtain_discrete[20] variable */ + data->localData[0]->realVars[63] /* particleReceiver1D.Qloss_conv_curtain_discrete[21] variable */ + data->localData[0]->realVars[64] /* particleReceiver1D.Qloss_conv_curtain_discrete[22] variable */ + data->localData[0]->realVars[65] /* particleReceiver1D.Qloss_conv_curtain_discrete[23] variable */ + data->localData[0]->realVars[66] /* particleReceiver1D.Qloss_conv_curtain_discrete[24] variable */ + data->localData[0]->realVars[67] /* particleReceiver1D.Qloss_conv_curtain_discrete[25] variable */ + data->localData[0]->realVars[68] /* particleReceiver1D.Qloss_conv_curtain_discrete[26] variable */ + data->localData[0]->realVars[69] /* particleReceiver1D.Qloss_conv_curtain_discrete[27] variable */ + data->localData[0]->realVars[70] /* particleReceiver1D.Qloss_conv_curtain_discrete[28] variable */ + data->localData[0]->realVars[71] /* particleReceiver1D.Qloss_conv_curtain_discrete[29] variable */ + data->localData[0]->realVars[72] /* particleReceiver1D.Qloss_conv_curtain_discrete[30] variable */;
  TRACE_POP
}
/*
equation index: 1386
type: ALGORITHM

  assert(sink.p >= 0.0, "Pressure (= " + String(sink.p, 6, 0, true) + " Pa) of medium \"" + "CARBO HSP 40/70" + "\" is negative
(Temperature = " + String(sink.medium.T, 6, 0, true) + " K)");
*/
void ParticleReceiver1DCalculator_eqFunction_1386(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1386};
  modelica_boolean tmp0;
  static const MMC_DEFSTRINGLIT(tmp1,12,"Pressure (= ");
  modelica_string tmp2;
  static const MMC_DEFSTRINGLIT(tmp3,16," Pa) of medium \"");
  static const MMC_DEFSTRINGLIT(tmp4,15,"CARBO HSP 40/70");
  static const MMC_DEFSTRINGLIT(tmp5,29,"\" is negative\n(Temperature = ");
  modelica_string tmp6;
  static const MMC_DEFSTRINGLIT(tmp7,3," K)");
  static int tmp8 = 0;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  {
    tmp0 = GreaterEq(data->simulationInfo->realParameter[132] /* sink.p PARAM */,0.0);
    if(!tmp0)
    {
      tmp2 = modelica_real_to_modelica_string(data->simulationInfo->realParameter[132] /* sink.p PARAM */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp1),tmp2);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp3));
      tmpMeta[2] = stringAppend(tmpMeta[1],MMC_REFSTRINGLIT(tmp4));
      tmpMeta[3] = stringAppend(tmpMeta[2],MMC_REFSTRINGLIT(tmp5));
      tmp6 = modelica_real_to_modelica_string(data->localData[0]->realVars[667] /* sink.medium.T variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[4] = stringAppend(tmpMeta[3],tmp6);
      tmpMeta[5] = stringAppend(tmpMeta[4],MMC_REFSTRINGLIT(tmp7));
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Media/package.mo",4529,7,4530,76,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.p >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(tmpMeta[5]));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1385
type: ALGORITHM

  Modelica.Fluid.Utilities.checkBoundary("CARBO HSP 40/70", {"Al2O3", "SiO2", "Fe2O3", "TiO2", "other"}, false, false, source.X, "FixedBoundary");
*/
void ParticleReceiver1DCalculator_eqFunction_1385(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1385};
  static const MMC_DEFSTRINGLIT(tmp9,15,"CARBO HSP 40/70");
  string_array tmp10;
  static const MMC_DEFSTRINGLIT(tmp11,5,"Al2O3");
  static const MMC_DEFSTRINGLIT(tmp12,4,"SiO2");
  static const MMC_DEFSTRINGLIT(tmp13,5,"Fe2O3");
  static const MMC_DEFSTRINGLIT(tmp14,4,"TiO2");
  static const MMC_DEFSTRINGLIT(tmp15,5,"other");
  real_array tmp16;
  static const MMC_DEFSTRINGLIT(tmp17,13,"FixedBoundary");
  array_alloc_scalar_string_array(&tmp10, 5, (modelica_string)MMC_REFSTRINGLIT(tmp11), (modelica_string)MMC_REFSTRINGLIT(tmp12), (modelica_string)MMC_REFSTRINGLIT(tmp13), (modelica_string)MMC_REFSTRINGLIT(tmp14), (modelica_string)MMC_REFSTRINGLIT(tmp15));
  real_array_create(&tmp16, ((modelica_real*)&((&data->simulationInfo->realParameter[137] /* source.X[1] PARAM */)[calc_base_index_dims_subs(1, 5, ((modelica_integer) 1))])), 1, 5);
  omc_Modelica_Fluid_Utilities_checkBoundary(threadData, MMC_REFSTRINGLIT(tmp9), tmp10, 0, 0, tmp16, MMC_REFSTRINGLIT(tmp17));
  TRACE_POP
}
/*
equation index: 1384
type: ALGORITHM

  Modelica.Fluid.Utilities.checkBoundary("CARBO HSP 40/70", {"Al2O3", "SiO2", "Fe2O3", "TiO2", "other"}, false, true, sink.X, "FixedBoundary");
*/
void ParticleReceiver1DCalculator_eqFunction_1384(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1384};
  static const MMC_DEFSTRINGLIT(tmp18,15,"CARBO HSP 40/70");
  string_array tmp19;
  static const MMC_DEFSTRINGLIT(tmp20,5,"Al2O3");
  static const MMC_DEFSTRINGLIT(tmp21,4,"SiO2");
  static const MMC_DEFSTRINGLIT(tmp22,5,"Fe2O3");
  static const MMC_DEFSTRINGLIT(tmp23,4,"TiO2");
  static const MMC_DEFSTRINGLIT(tmp24,5,"other");
  real_array tmp25;
  static const MMC_DEFSTRINGLIT(tmp26,13,"FixedBoundary");
  array_alloc_scalar_string_array(&tmp19, 5, (modelica_string)MMC_REFSTRINGLIT(tmp20), (modelica_string)MMC_REFSTRINGLIT(tmp21), (modelica_string)MMC_REFSTRINGLIT(tmp22), (modelica_string)MMC_REFSTRINGLIT(tmp23), (modelica_string)MMC_REFSTRINGLIT(tmp24));
  real_array_create(&tmp25, ((modelica_real*)&((&data->simulationInfo->realParameter[123] /* sink.X[1] PARAM */)[calc_base_index_dims_subs(1, 5, ((modelica_integer) 1))])), 1, 5);
  omc_Modelica_Fluid_Utilities_checkBoundary(threadData, MMC_REFSTRINGLIT(tmp18), tmp19, 0, 1, tmp25, MMC_REFSTRINGLIT(tmp26));
  TRACE_POP
}
/*
equation index: 1383
type: ALGORITHM

  assert(particleReceiver1D.Tab[1].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1383(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1383};
  static const MMC_DEFSTRINGLIT(tmp29,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp30,42,"tableOnFile = true and no table name given");
  static int tmp31 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[31] /* particleReceiver1D.Tab[1].tableName PARAM */, MMC_REFSTRINGLIT(tmp29))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[1].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp30)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1382
type: ALGORITHM

  assert(particleReceiver1D.Tab[2].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1382(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1382};
  static const MMC_DEFSTRINGLIT(tmp34,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp35,42,"tableOnFile = true and no table name given");
  static int tmp36 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[32] /* particleReceiver1D.Tab[2].tableName PARAM */, MMC_REFSTRINGLIT(tmp34))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[2].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp35)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1381
type: ALGORITHM

  assert(particleReceiver1D.Tab[3].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1381(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1381};
  static const MMC_DEFSTRINGLIT(tmp39,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp40,42,"tableOnFile = true and no table name given");
  static int tmp41 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[33] /* particleReceiver1D.Tab[3].tableName PARAM */, MMC_REFSTRINGLIT(tmp39))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[3].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp40)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1380
type: ALGORITHM

  assert(particleReceiver1D.Tab[4].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1380(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1380};
  static const MMC_DEFSTRINGLIT(tmp44,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp45,42,"tableOnFile = true and no table name given");
  static int tmp46 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[34] /* particleReceiver1D.Tab[4].tableName PARAM */, MMC_REFSTRINGLIT(tmp44))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[4].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp45)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1379
type: ALGORITHM

  assert(particleReceiver1D.Tab[5].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1379(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1379};
  static const MMC_DEFSTRINGLIT(tmp49,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp50,42,"tableOnFile = true and no table name given");
  static int tmp51 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[35] /* particleReceiver1D.Tab[5].tableName PARAM */, MMC_REFSTRINGLIT(tmp49))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[5].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp50)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1378
type: ALGORITHM

  assert(particleReceiver1D.Tab[6].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1378(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1378};
  static const MMC_DEFSTRINGLIT(tmp54,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp55,42,"tableOnFile = true and no table name given");
  static int tmp56 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[36] /* particleReceiver1D.Tab[6].tableName PARAM */, MMC_REFSTRINGLIT(tmp54))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[6].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp55)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1377
type: ALGORITHM

  assert(particleReceiver1D.Tab[7].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1377(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1377};
  static const MMC_DEFSTRINGLIT(tmp59,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp60,42,"tableOnFile = true and no table name given");
  static int tmp61 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[37] /* particleReceiver1D.Tab[7].tableName PARAM */, MMC_REFSTRINGLIT(tmp59))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[7].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp60)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1376
type: ALGORITHM

  assert(particleReceiver1D.Tab[8].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1376(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1376};
  static const MMC_DEFSTRINGLIT(tmp64,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp65,42,"tableOnFile = true and no table name given");
  static int tmp66 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[38] /* particleReceiver1D.Tab[8].tableName PARAM */, MMC_REFSTRINGLIT(tmp64))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[8].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp65)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1375
type: ALGORITHM

  assert(particleReceiver1D.Tab[9].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1375(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1375};
  static const MMC_DEFSTRINGLIT(tmp69,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp70,42,"tableOnFile = true and no table name given");
  static int tmp71 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[39] /* particleReceiver1D.Tab[9].tableName PARAM */, MMC_REFSTRINGLIT(tmp69))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[9].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp70)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1374
type: ALGORITHM

  assert(particleReceiver1D.Tab[10].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1374(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1374};
  static const MMC_DEFSTRINGLIT(tmp74,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp75,42,"tableOnFile = true and no table name given");
  static int tmp76 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[40] /* particleReceiver1D.Tab[10].tableName PARAM */, MMC_REFSTRINGLIT(tmp74))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[10].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp75)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1373
type: ALGORITHM

  assert(particleReceiver1D.Tab[11].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1373(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1373};
  static const MMC_DEFSTRINGLIT(tmp79,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp80,42,"tableOnFile = true and no table name given");
  static int tmp81 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[41] /* particleReceiver1D.Tab[11].tableName PARAM */, MMC_REFSTRINGLIT(tmp79))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[11].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp80)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1372
type: ALGORITHM

  assert(particleReceiver1D.Tab[12].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1372(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1372};
  static const MMC_DEFSTRINGLIT(tmp84,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp85,42,"tableOnFile = true and no table name given");
  static int tmp86 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[42] /* particleReceiver1D.Tab[12].tableName PARAM */, MMC_REFSTRINGLIT(tmp84))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[12].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp85)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1371
type: ALGORITHM

  assert(particleReceiver1D.Tab[13].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1371(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1371};
  static const MMC_DEFSTRINGLIT(tmp89,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp90,42,"tableOnFile = true and no table name given");
  static int tmp91 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[43] /* particleReceiver1D.Tab[13].tableName PARAM */, MMC_REFSTRINGLIT(tmp89))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[13].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp90)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1370
type: ALGORITHM

  assert(particleReceiver1D.Tab[14].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1370(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1370};
  static const MMC_DEFSTRINGLIT(tmp94,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp95,42,"tableOnFile = true and no table name given");
  static int tmp96 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[44] /* particleReceiver1D.Tab[14].tableName PARAM */, MMC_REFSTRINGLIT(tmp94))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[14].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp95)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1369
type: ALGORITHM

  assert(particleReceiver1D.Tab[15].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1369(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1369};
  static const MMC_DEFSTRINGLIT(tmp99,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp100,42,"tableOnFile = true and no table name given");
  static int tmp101 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[45] /* particleReceiver1D.Tab[15].tableName PARAM */, MMC_REFSTRINGLIT(tmp99))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[15].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp100)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1368
type: ALGORITHM

  assert(particleReceiver1D.Tab[16].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1368(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1368};
  static const MMC_DEFSTRINGLIT(tmp104,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp105,42,"tableOnFile = true and no table name given");
  static int tmp106 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[46] /* particleReceiver1D.Tab[16].tableName PARAM */, MMC_REFSTRINGLIT(tmp104))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[16].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp105)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1367
type: ALGORITHM

  assert(particleReceiver1D.Tab[17].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1367(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1367};
  static const MMC_DEFSTRINGLIT(tmp109,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp110,42,"tableOnFile = true and no table name given");
  static int tmp111 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[47] /* particleReceiver1D.Tab[17].tableName PARAM */, MMC_REFSTRINGLIT(tmp109))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[17].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp110)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1366
type: ALGORITHM

  assert(particleReceiver1D.Tab[18].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1366(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1366};
  static const MMC_DEFSTRINGLIT(tmp114,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp115,42,"tableOnFile = true and no table name given");
  static int tmp116 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[48] /* particleReceiver1D.Tab[18].tableName PARAM */, MMC_REFSTRINGLIT(tmp114))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[18].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp115)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1365
type: ALGORITHM

  assert(particleReceiver1D.Tab[19].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1365(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1365};
  static const MMC_DEFSTRINGLIT(tmp119,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp120,42,"tableOnFile = true and no table name given");
  static int tmp121 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[49] /* particleReceiver1D.Tab[19].tableName PARAM */, MMC_REFSTRINGLIT(tmp119))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[19].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp120)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1364
type: ALGORITHM

  assert(particleReceiver1D.Tab[20].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1364(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1364};
  static const MMC_DEFSTRINGLIT(tmp124,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp125,42,"tableOnFile = true and no table name given");
  static int tmp126 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[50] /* particleReceiver1D.Tab[20].tableName PARAM */, MMC_REFSTRINGLIT(tmp124))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[20].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp125)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1363
type: ALGORITHM

  assert(particleReceiver1D.Tab[21].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1363(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1363};
  static const MMC_DEFSTRINGLIT(tmp129,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp130,42,"tableOnFile = true and no table name given");
  static int tmp131 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[51] /* particleReceiver1D.Tab[21].tableName PARAM */, MMC_REFSTRINGLIT(tmp129))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[21].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp130)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1362
type: ALGORITHM

  assert(particleReceiver1D.Tab[22].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1362(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1362};
  static const MMC_DEFSTRINGLIT(tmp134,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp135,42,"tableOnFile = true and no table name given");
  static int tmp136 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[52] /* particleReceiver1D.Tab[22].tableName PARAM */, MMC_REFSTRINGLIT(tmp134))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[22].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp135)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1361
type: ALGORITHM

  assert(particleReceiver1D.Tab[23].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1361(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1361};
  static const MMC_DEFSTRINGLIT(tmp139,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp140,42,"tableOnFile = true and no table name given");
  static int tmp141 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[53] /* particleReceiver1D.Tab[23].tableName PARAM */, MMC_REFSTRINGLIT(tmp139))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[23].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp140)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1360
type: ALGORITHM

  assert(particleReceiver1D.Tab[24].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1360(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1360};
  static const MMC_DEFSTRINGLIT(tmp144,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp145,42,"tableOnFile = true and no table name given");
  static int tmp146 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[54] /* particleReceiver1D.Tab[24].tableName PARAM */, MMC_REFSTRINGLIT(tmp144))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[24].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp145)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1359
type: ALGORITHM

  assert(particleReceiver1D.Tab[25].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1359(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1359};
  static const MMC_DEFSTRINGLIT(tmp149,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp150,42,"tableOnFile = true and no table name given");
  static int tmp151 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[55] /* particleReceiver1D.Tab[25].tableName PARAM */, MMC_REFSTRINGLIT(tmp149))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[25].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp150)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1358
type: ALGORITHM

  assert(particleReceiver1D.Tab[26].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1358(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1358};
  static const MMC_DEFSTRINGLIT(tmp154,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp155,42,"tableOnFile = true and no table name given");
  static int tmp156 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[56] /* particleReceiver1D.Tab[26].tableName PARAM */, MMC_REFSTRINGLIT(tmp154))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[26].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp155)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1357
type: ALGORITHM

  assert(particleReceiver1D.Tab[27].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1357(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1357};
  static const MMC_DEFSTRINGLIT(tmp159,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp160,42,"tableOnFile = true and no table name given");
  static int tmp161 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[57] /* particleReceiver1D.Tab[27].tableName PARAM */, MMC_REFSTRINGLIT(tmp159))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[27].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp160)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1356
type: ALGORITHM

  assert(particleReceiver1D.Tab[28].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1356(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1356};
  static const MMC_DEFSTRINGLIT(tmp164,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp165,42,"tableOnFile = true and no table name given");
  static int tmp166 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[58] /* particleReceiver1D.Tab[28].tableName PARAM */, MMC_REFSTRINGLIT(tmp164))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[28].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp165)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1355
type: ALGORITHM

  assert(particleReceiver1D.Tab[29].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1355(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1355};
  static const MMC_DEFSTRINGLIT(tmp169,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp170,42,"tableOnFile = true and no table name given");
  static int tmp171 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[59] /* particleReceiver1D.Tab[29].tableName PARAM */, MMC_REFSTRINGLIT(tmp169))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[29].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp170)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1354
type: ALGORITHM

  assert(particleReceiver1D.Tab[30].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1354(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1354};
  static const MMC_DEFSTRINGLIT(tmp174,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp175,42,"tableOnFile = true and no table name given");
  static int tmp176 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[60] /* particleReceiver1D.Tab[30].tableName PARAM */, MMC_REFSTRINGLIT(tmp174))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[30].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp175)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 1353
type: ALGORITHM

  assert(particleReceiver1D.Tab[31].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void ParticleReceiver1DCalculator_eqFunction_1353(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1353};
  static const MMC_DEFSTRINGLIT(tmp179,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp180,42,"tableOnFile = true and no table name given");
  static int tmp181 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[61] /* particleReceiver1D.Tab[31].tableName PARAM */, MMC_REFSTRINGLIT(tmp179))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[31].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp180)));
      }
    }
  }
  TRACE_POP
}

OMC_DISABLE_OPT
int ParticleReceiver1DCalculator_functionDAE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  int equationIndexes[1] = {0};
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  data->simulationInfo->needToIterate = 0;
  data->simulationInfo->discreteCall = 1;
  ParticleReceiver1DCalculator_functionLocalKnownVars(data, threadData);
  ParticleReceiver1DCalculator_eqFunction_769(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_770(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_771(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_772(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_773(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_774(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_775(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_776(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_777(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_778(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_779(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_780(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_781(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_782(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_783(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_784(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_785(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_786(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_787(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_788(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_789(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_790(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_791(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_792(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_793(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_794(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_795(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_796(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_797(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_798(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_799(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_800(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_801(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_802(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_803(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_804(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_805(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_806(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_807(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_808(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_809(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_810(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_811(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_812(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_813(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_814(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_815(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_816(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_817(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_818(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_819(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_820(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_821(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_822(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_823(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_824(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_825(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_826(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_827(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_828(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_829(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_830(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_831(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_832(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_833(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_834(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_835(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_836(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_837(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_838(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_839(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_840(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_841(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_842(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_843(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_844(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_845(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_846(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_847(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_848(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_849(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_850(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_851(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_852(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_853(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_854(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_855(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_856(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_857(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_858(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_859(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_860(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_861(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_862(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_863(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_864(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_865(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_866(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_867(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_868(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_869(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_870(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_871(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_872(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_873(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_874(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_875(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_876(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_877(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_878(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_879(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_880(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_881(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_882(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_883(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_884(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_885(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_886(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_887(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_888(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_889(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_890(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_891(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_892(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_893(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_894(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_895(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_896(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_897(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_898(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_899(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_900(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_901(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_902(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_903(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_904(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_905(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_906(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_907(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_908(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_909(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_910(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_911(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_912(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_913(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_914(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_915(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_916(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_917(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_918(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_919(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_920(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_921(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_922(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_923(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_924(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_925(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_926(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1195(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1196(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1197(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1198(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1199(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1200(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1201(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1202(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1203(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1204(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1205(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1206(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1207(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1208(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1209(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1210(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1211(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1212(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1213(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1214(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1215(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1216(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1217(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1218(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1219(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1220(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1221(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1222(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1223(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1224(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1225(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1226(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1227(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1228(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1229(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1230(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1231(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1232(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1233(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1234(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1235(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1236(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1237(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1238(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1239(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1240(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1241(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1242(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1243(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1244(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1245(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1246(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1247(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1248(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1249(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1250(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1251(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1252(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1253(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1254(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1255(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1256(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1257(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1258(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1259(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1260(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1261(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1262(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1263(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1264(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1265(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1266(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1267(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1268(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1269(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1270(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1271(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1272(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1273(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1274(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1275(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1276(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1277(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1278(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1279(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1280(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1281(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1282(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1283(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1284(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1285(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1286(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1287(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1288(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1289(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1290(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1291(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1292(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1293(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1294(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1295(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1296(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1297(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1298(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1299(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1300(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1301(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1302(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1303(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1304(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1305(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1306(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1307(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1308(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1309(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1310(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1311(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1312(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1313(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1314(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1315(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1316(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1317(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1318(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1319(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1320(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1321(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1322(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1323(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1324(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1325(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1326(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1327(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1328(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1329(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1330(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1331(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1332(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1333(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1334(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1335(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1336(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1337(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1338(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1339(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1340(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1341(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1342(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1343(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1344(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1345(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1346(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1347(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1348(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1349(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1350(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1351(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1352(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1386(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1385(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1384(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1383(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1382(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1381(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1380(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1379(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1378(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1377(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1376(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1375(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1374(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1373(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1372(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1371(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1370(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1369(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1368(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1367(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1366(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1365(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1364(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1363(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1362(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1361(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1360(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1359(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1358(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1357(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1356(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1355(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1354(data, threadData);

  ParticleReceiver1DCalculator_eqFunction_1353(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif
  TRACE_POP
  return 0;
}


int ParticleReceiver1DCalculator_functionLocalKnownVars(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


int ParticleReceiver1DCalculator_functionODE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_FUNCTION_ODE);
#endif

  
  data->simulationInfo->callStatistics.functionODE++;
  
  ParticleReceiver1DCalculator_functionLocalKnownVars(data, threadData);
  /* no ODE systems */

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_FUNCTION_ODE);
#endif

  TRACE_POP
  return 0;
}

/* forward the main in the simulation runtime */
extern int _main_SimulationRuntime(int argc, char**argv, DATA *data, threadData_t *threadData);

#include "ParticleReceiver1DCalculator_12jac.h"
#include "ParticleReceiver1DCalculator_13opt.h"

struct OpenModelicaGeneratedFunctionCallbacks ParticleReceiver1DCalculator_callback = {
   (int (*)(DATA *, threadData_t *, void *)) ParticleReceiver1DCalculator_performSimulation,
   (int (*)(DATA *, threadData_t *, void *)) ParticleReceiver1DCalculator_performQSSSimulation,
   ParticleReceiver1DCalculator_updateContinuousSystem,
   ParticleReceiver1DCalculator_callExternalObjectDestructors,
   ParticleReceiver1DCalculator_initialNonLinearSystem,
   NULL,
   NULL,
   #if !defined(OMC_NO_STATESELECTION)
   ParticleReceiver1DCalculator_initializeStateSets,
   #else
   NULL,
   #endif
   ParticleReceiver1DCalculator_initializeDAEmodeData,
   ParticleReceiver1DCalculator_functionODE,
   ParticleReceiver1DCalculator_functionAlgebraics,
   ParticleReceiver1DCalculator_functionDAE,
   ParticleReceiver1DCalculator_functionLocalKnownVars,
   ParticleReceiver1DCalculator_input_function,
   ParticleReceiver1DCalculator_input_function_init,
   ParticleReceiver1DCalculator_input_function_updateStartValues,
   ParticleReceiver1DCalculator_data_function,
   ParticleReceiver1DCalculator_output_function,
   ParticleReceiver1DCalculator_setc_function,
   ParticleReceiver1DCalculator_function_storeDelayed,
   ParticleReceiver1DCalculator_updateBoundVariableAttributes,
   ParticleReceiver1DCalculator_functionInitialEquations,
   1, /* useHomotopy - 0: local homotopy (equidistant lambda), 1: global homotopy (equidistant lambda), 2: new global homotopy approach (adaptive lambda), 3: new local homotopy approach (adaptive lambda)*/
   ParticleReceiver1DCalculator_functionInitialEquations_lambda0,
   ParticleReceiver1DCalculator_functionRemovedInitialEquations,
   ParticleReceiver1DCalculator_updateBoundParameters,
   ParticleReceiver1DCalculator_checkForAsserts,
   ParticleReceiver1DCalculator_function_ZeroCrossingsEquations,
   ParticleReceiver1DCalculator_function_ZeroCrossings,
   ParticleReceiver1DCalculator_function_updateRelations,
   ParticleReceiver1DCalculator_zeroCrossingDescription,
   ParticleReceiver1DCalculator_relationDescription,
   ParticleReceiver1DCalculator_function_initSample,
   ParticleReceiver1DCalculator_INDEX_JAC_A,
   ParticleReceiver1DCalculator_INDEX_JAC_B,
   ParticleReceiver1DCalculator_INDEX_JAC_C,
   ParticleReceiver1DCalculator_INDEX_JAC_D,
   ParticleReceiver1DCalculator_INDEX_JAC_F,
   ParticleReceiver1DCalculator_initialAnalyticJacobianA,
   ParticleReceiver1DCalculator_initialAnalyticJacobianB,
   ParticleReceiver1DCalculator_initialAnalyticJacobianC,
   ParticleReceiver1DCalculator_initialAnalyticJacobianD,
   ParticleReceiver1DCalculator_initialAnalyticJacobianF,
   ParticleReceiver1DCalculator_functionJacA_column,
   ParticleReceiver1DCalculator_functionJacB_column,
   ParticleReceiver1DCalculator_functionJacC_column,
   ParticleReceiver1DCalculator_functionJacD_column,
   ParticleReceiver1DCalculator_functionJacF_column,
   ParticleReceiver1DCalculator_linear_model_frame,
   ParticleReceiver1DCalculator_linear_model_datarecovery_frame,
   ParticleReceiver1DCalculator_mayer,
   ParticleReceiver1DCalculator_lagrange,
   ParticleReceiver1DCalculator_pickUpBoundsForInputsInOptimization,
   ParticleReceiver1DCalculator_setInputData,
   ParticleReceiver1DCalculator_getTimeGrid,
   ParticleReceiver1DCalculator_symbolicInlineSystem,
   ParticleReceiver1DCalculator_function_initSynchronous,
   ParticleReceiver1DCalculator_function_updateSynchronous,
   ParticleReceiver1DCalculator_function_equationsSynchronous,
   ParticleReceiver1DCalculator_inputNames,
   NULL,
   NULL,
   NULL,
   -1

};

#define _OMC_LIT_RESOURCE_0_name_data "Complex"
#define _OMC_LIT_RESOURCE_0_dir_data "/usr/lib/omlibrary"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_0_name,7,_OMC_LIT_RESOURCE_0_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir,18,_OMC_LIT_RESOURCE_0_dir_data);

#define _OMC_LIT_RESOURCE_1_name_data "Modelica"
#define _OMC_LIT_RESOURCE_1_dir_data "/usr/lib/omlibrary/Modelica 3.2.2"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_1_name,8,_OMC_LIT_RESOURCE_1_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_1_dir,33,_OMC_LIT_RESOURCE_1_dir_data);

#define _OMC_LIT_RESOURCE_2_name_data "ModelicaServices"
#define _OMC_LIT_RESOURCE_2_dir_data "/usr/lib/omlibrary/ModelicaServices 3.2.2"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_2_name,16,_OMC_LIT_RESOURCE_2_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_2_dir,41,_OMC_LIT_RESOURCE_2_dir_data);

#define _OMC_LIT_RESOURCE_3_name_data "ParticleReceiver1DCalculator"
#define _OMC_LIT_RESOURCE_3_dir_data "/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_name,28,_OMC_LIT_RESOURCE_3_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir,73,_OMC_LIT_RESOURCE_3_dir_data);

#define _OMC_LIT_RESOURCE_4_name_data "SolarTherm"
#define _OMC_LIT_RESOURCE_4_dir_data "/home/philgun/.local/lib/omlibrary/SolarTherm"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_name,10,_OMC_LIT_RESOURCE_4_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir,45,_OMC_LIT_RESOURCE_4_dir_data);

static const MMC_DEFSTRUCTLIT(_OMC_LIT_RESOURCES,10,MMC_ARRAY_TAG) {MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir)}};
void ParticleReceiver1DCalculator_setupDataStruc(DATA *data, threadData_t *threadData)
{
  assertStreamPrint(threadData,0!=data, "Error while initialize Data");
  threadData->localRoots[LOCAL_ROOT_SIMULATION_DATA] = data;
  data->callback = &ParticleReceiver1DCalculator_callback;
  OpenModelica_updateUriMapping(threadData, MMC_REFSTRUCTLIT(_OMC_LIT_RESOURCES));
  data->modelData->modelName = "ParticleReceiver1DCalculator";
  data->modelData->modelFilePrefix = "ParticleReceiver1DCalculator";
  data->modelData->resultFileName = NULL;
  data->modelData->modelDir = "/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation";
  data->modelData->modelGUID = "{a9879f37-2c39-4b85-b48d-fa596b8a1354}";
  #if defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME)
  data->modelData->initXMLData = NULL;
  data->modelData->modelDataXml.infoXMLData = NULL;
  #else
  #if defined(_MSC_VER) /* handle joke compilers */
  {
  /* for MSVC we encode a string like char x[] = {'a', 'b', 'c', '\0'} */
  /* because the string constant limit is 65535 bytes */
  static const char contents_init[] =
    #include "ParticleReceiver1DCalculator_init.c"
    ;
  static const char contents_info[] =
    #include "ParticleReceiver1DCalculator_info.c"
    ;
    data->modelData->initXMLData = contents_init;
    data->modelData->modelDataXml.infoXMLData = contents_info;
  }
  #else /* handle real compilers */
  data->modelData->initXMLData =
  #include "ParticleReceiver1DCalculator_init.c"
    ;
  data->modelData->modelDataXml.infoXMLData =
  #include "ParticleReceiver1DCalculator_info.c"
    ;
  #endif /* defined(_MSC_VER) */
  #endif /* defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME) */
  
  data->modelData->nStates = 0;
  data->modelData->nVariablesReal = 692;
  data->modelData->nDiscreteReal = 0;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 1;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 148;
  data->modelData->nParametersInteger = 98;
  data->modelData->nParametersBoolean = 90;
  data->modelData->nParametersString = 63;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  
  data->modelData->nAliasReal = 172;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 1;
  data->modelData->nAliasString = 0;
  
  data->modelData->nZeroCrossings = 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 0;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 31;
  
  data->modelData->modelDataXml.fileName = "ParticleReceiver1DCalculator_info.json";
  data->modelData->modelDataXml.modelInfoXmlLength = 0;
  data->modelData->modelDataXml.nFunctions = 69;
  data->modelData->modelDataXml.nProfileBlocks = 0;
  data->modelData->modelDataXml.nEquations = 2250;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 0;
  data->modelData->nNonLinearSystems = 2;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 5;
  data->modelData->nOptimizeConstraints = 0;
  data->modelData->nOptimizeFinalConstraints = 0;
  
  data->modelData->nDelayExpressions = 0;
  
  data->modelData->nClocks = 0;
  data->modelData->nSubClocks = 0;
  
  data->modelData->nSensitivityVars = 0;
  data->modelData->nSensitivityParamVars = 0;
  data->modelData->nSetcVars = 0;
  data->modelData->ndataReconVars = 0;
}

static int rml_execution_failed()
{
  fflush(NULL);
  fprintf(stderr, "Execution failed!\n");
  fflush(NULL);
  return 1;
}

#if defined(threadData)
#undef threadData
#endif
/* call the simulation runtime main from our main! */
int main(int argc, char**argv)
{
  int res;
  DATA data;
  MODEL_DATA modelData;
  SIMULATION_INFO simInfo;
  data.modelData = &modelData;
  data.simulationInfo = &simInfo;
  measure_time_flag = 0;
  compiledInDAEMode = 0;
  compiledWithSymSolver = 0;
  MMC_INIT(0);
  omc_alloc_interface.init();
  {
    MMC_TRY_TOP()
  
    MMC_TRY_STACK()
  
    ParticleReceiver1DCalculator_setupDataStruc(&data, threadData);
    res = _main_SimulationRuntime(argc, argv, &data, threadData);
    
    MMC_ELSE()
    rml_execution_failed();
    fprintf(stderr, "Stack overflow detected and was not caught.\nSend us a bug report at https://trac.openmodelica.org/OpenModelica/newticket\n    Include the following trace:\n");
    printStacktraceMessages();
    fflush(NULL);
    return 1;
    MMC_CATCH_STACK()
    
    MMC_CATCH_TOP(return rml_execution_failed());
  }

  fflush(NULL);
  EXIT(res);
  return res;
}

#ifdef __cplusplus
}
#endif


