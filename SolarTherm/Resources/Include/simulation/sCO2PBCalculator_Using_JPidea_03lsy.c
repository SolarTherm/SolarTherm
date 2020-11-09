/* Linear Systems */
#include "sCO2PBCalculator_Using_JPidea_model.h"
#include "sCO2PBCalculator_Using_JPidea_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* linear systems */

/*
equation index: 554
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[2] = powerBlock.cooler.h_CO2_des[1] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_554(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,554};
  data->simulationInfo->realParameter[375] /* powerBlock.cooler.h_CO2_des[2] PARAM */ = data->simulationInfo->realParameter[374] /* powerBlock.cooler.h_CO2_des[1] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 555
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[3] = powerBlock.cooler.h_CO2_des[2] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_555(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,555};
  data->simulationInfo->realParameter[376] /* powerBlock.cooler.h_CO2_des[3] PARAM */ = data->simulationInfo->realParameter[375] /* powerBlock.cooler.h_CO2_des[2] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 556
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[4] = powerBlock.cooler.h_CO2_des[3] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_556(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,556};
  data->simulationInfo->realParameter[377] /* powerBlock.cooler.h_CO2_des[4] PARAM */ = data->simulationInfo->realParameter[376] /* powerBlock.cooler.h_CO2_des[3] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 557
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[5] = powerBlock.cooler.h_CO2_des[4] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_557(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,557};
  data->simulationInfo->realParameter[378] /* powerBlock.cooler.h_CO2_des[5] PARAM */ = data->simulationInfo->realParameter[377] /* powerBlock.cooler.h_CO2_des[4] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 558
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[6] = powerBlock.cooler.h_CO2_des[5] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_558(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,558};
  data->simulationInfo->realParameter[379] /* powerBlock.cooler.h_CO2_des[6] PARAM */ = data->simulationInfo->realParameter[378] /* powerBlock.cooler.h_CO2_des[5] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 559
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[7] = powerBlock.cooler.h_CO2_des[6] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_559(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,559};
  data->simulationInfo->realParameter[380] /* powerBlock.cooler.h_CO2_des[7] PARAM */ = data->simulationInfo->realParameter[379] /* powerBlock.cooler.h_CO2_des[6] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 560
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[8] = powerBlock.cooler.h_CO2_des[7] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_560(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,560};
  data->simulationInfo->realParameter[381] /* powerBlock.cooler.h_CO2_des[8] PARAM */ = data->simulationInfo->realParameter[380] /* powerBlock.cooler.h_CO2_des[7] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 561
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[9] = powerBlock.cooler.h_CO2_des[8] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_561(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,561};
  data->simulationInfo->realParameter[382] /* powerBlock.cooler.h_CO2_des[9] PARAM */ = data->simulationInfo->realParameter[381] /* powerBlock.cooler.h_CO2_des[8] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 562
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[10] = powerBlock.cooler.h_CO2_des[9] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_562(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,562};
  data->simulationInfo->realParameter[383] /* powerBlock.cooler.h_CO2_des[10] PARAM */ = data->simulationInfo->realParameter[382] /* powerBlock.cooler.h_CO2_des[9] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 563
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[11] = powerBlock.cooler.h_CO2_des[10] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_563(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,563};
  data->simulationInfo->realParameter[384] /* powerBlock.cooler.h_CO2_des[11] PARAM */ = data->simulationInfo->realParameter[383] /* powerBlock.cooler.h_CO2_des[10] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 564
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[12] = powerBlock.cooler.h_CO2_des[11] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_564(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,564};
  data->simulationInfo->realParameter[385] /* powerBlock.cooler.h_CO2_des[12] PARAM */ = data->simulationInfo->realParameter[384] /* powerBlock.cooler.h_CO2_des[11] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 565
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[13] = powerBlock.cooler.h_CO2_des[12] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_565(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,565};
  data->simulationInfo->realParameter[386] /* powerBlock.cooler.h_CO2_des[13] PARAM */ = data->simulationInfo->realParameter[385] /* powerBlock.cooler.h_CO2_des[12] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 566
type: SIMPLE_ASSIGN
powerBlock._cooler._h_CO2_des[14] = powerBlock.cooler.h_CO2_des[13] + powerBlock.cooler.Q_dis_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_566(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,566};
  data->simulationInfo->realParameter[387] /* powerBlock.cooler.h_CO2_des[14] PARAM */ = data->simulationInfo->realParameter[386] /* powerBlock.cooler.h_CO2_des[13] PARAM */ + data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}

void residualFunc581(void** dataIn, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = (DATA*) ((void**)dataIn[0]);
  threadData_t *threadData = (threadData_t*) ((void**)dataIn[1]);
  const int equationIndexes[2] = {1,581};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */ = xloc[0];
  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_554(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_555(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_556(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_557(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_558(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_559(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_560(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_561(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_562(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_563(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_564(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_565(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_566(data, threadData);
  res[0] = data->simulationInfo->realParameter[388] /* powerBlock.cooler.h_CO2_des[15] PARAM */ + (-data->simulationInfo->realParameter[387] /* powerBlock.cooler.h_CO2_des[14] PARAM */) - data->simulationInfo->realParameter[324] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData581(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for powerBlock.cooler.Q_dis_des */
  linearSystemData->nominal[i] = data->modelData->realParameterData[324].attribute /* powerBlock.cooler.Q_dis_des */.nominal;
  linearSystemData->min[i]     = data->modelData->realParameterData[324].attribute /* powerBlock.cooler.Q_dis_des */.min;
  linearSystemData->max[i++]   = data->modelData->realParameterData[324].attribute /* powerBlock.cooler.Q_dis_des */.max;
}


/*
equation index: 459
type: SIMPLE_ASSIGN
powerBlock._cooler._m_des = powerBlock.LTR.m_turb_des * powerBlock.ratio_m_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_459(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,459};
  data->simulationInfo->realParameter[391] /* powerBlock.cooler.m_des PARAM */ = (data->simulationInfo->realParameter[240] /* powerBlock.LTR.m_turb_des PARAM */) * (data->simulationInfo->realParameter[620] /* powerBlock.ratio_m_des PARAM */);
  TRACE_POP
}
/*
equation index: 460
type: SIMPLE_ASSIGN
powerBlock._reCompressor._m_des = powerBlock.gamma * powerBlock.LTR.m_turb_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_460(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,460};
  data->simulationInfo->realParameter[631] /* powerBlock.reCompressor.m_des PARAM */ = (data->simulationInfo->realParameter[587] /* powerBlock.gamma PARAM */) * (data->simulationInfo->realParameter[240] /* powerBlock.LTR.m_turb_des PARAM */);
  TRACE_POP
}
/*
equation index: 461
type: SIMPLE_ASSIGN
powerBlock._reCompressor._W_comp_des = powerBlock.reCompressor.m_des * (powerBlock.reCompressor.h_out_des - powerBlock.reCompressor.state_in_des.h)
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_461(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,461};
  data->simulationInfo->realParameter[626] /* powerBlock.reCompressor.W_comp_des PARAM */ = (data->simulationInfo->realParameter[631] /* powerBlock.reCompressor.m_des PARAM */) * (data->simulationInfo->realParameter[630] /* powerBlock.reCompressor.h_out_des PARAM */ - data->simulationInfo->realParameter[637] /* powerBlock.reCompressor.state_in_des.h PARAM */);
  TRACE_POP
}
/*
equation index: 462
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._m_des = powerBlock.cooler.m_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_462(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,462};
  data->simulationInfo->realParameter[598] /* powerBlock.mainCompressor.m_des PARAM */ = data->simulationInfo->realParameter[391] /* powerBlock.cooler.m_des PARAM */;
  TRACE_POP
}
/*
equation index: 463
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._W_comp_des = powerBlock.mainCompressor.m_des * (powerBlock.mainCompressor.h_out_des - powerBlock.mainCompressor.state_in_des.h)
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_463(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,463};
  data->simulationInfo->realParameter[593] /* powerBlock.mainCompressor.W_comp_des PARAM */ = (data->simulationInfo->realParameter[598] /* powerBlock.mainCompressor.m_des PARAM */) * (data->simulationInfo->realParameter[597] /* powerBlock.mainCompressor.h_out_des PARAM */ - data->simulationInfo->realParameter[604] /* powerBlock.mainCompressor.state_in_des.h PARAM */);
  TRACE_POP
}
/*
equation index: 464
type: SIMPLE_ASSIGN
powerBlock._turbine._W_turb_des = ((-20000000.0) / (1.0 - powerBlock.f_fixed_load) - (powerBlock.mainCompressor.W_comp_des + powerBlock.reCompressor.W_comp_des) * (1.0 - powerBlock.par_fr) * powerBlock.eta_motor) / (powerBlock.eta_motor * (1.0 - powerBlock.par_fr))
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_464(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,464};
  data->simulationInfo->realParameter[651] /* powerBlock.turbine.W_turb_des PARAM */ = DIVISION_SIM(DIVISION_SIM(-20000000.0,1.0 - data->simulationInfo->realParameter[584] /* powerBlock.f_fixed_load PARAM */,"1.0 - powerBlock.f_fixed_load",equationIndexes) - (((data->simulationInfo->realParameter[593] /* powerBlock.mainCompressor.W_comp_des PARAM */ + data->simulationInfo->realParameter[626] /* powerBlock.reCompressor.W_comp_des PARAM */) * (1.0 - data->simulationInfo->realParameter[611] /* powerBlock.par_fr PARAM */)) * (data->simulationInfo->realParameter[427] /* powerBlock.eta_motor PARAM */)),(data->simulationInfo->realParameter[427] /* powerBlock.eta_motor PARAM */) * (1.0 - data->simulationInfo->realParameter[611] /* powerBlock.par_fr PARAM */),"powerBlock.eta_motor * (1.0 - powerBlock.par_fr)",equationIndexes);
  TRACE_POP
}
/*
equation index: 465
type: SIMPLE_ASSIGN
powerBlock._turbine._m_des = powerBlock.turbine.W_turb_des / (powerBlock.turbine.h_out_des - powerBlock.turbine.state_in_des.h)
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_465(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,465};
  data->simulationInfo->realParameter[656] /* powerBlock.turbine.m_des PARAM */ = DIVISION_SIM(data->simulationInfo->realParameter[651] /* powerBlock.turbine.W_turb_des PARAM */,data->simulationInfo->realParameter[655] /* powerBlock.turbine.h_out_des PARAM */ - data->simulationInfo->realParameter[659] /* powerBlock.turbine.state_in_des.h PARAM */,"powerBlock.turbine.h_out_des - powerBlock.turbine.state_in_des.h",equationIndexes);
  TRACE_POP
}
/*
equation index: 466
type: SIMPLE_ASSIGN
powerBlock._HTR._m_turb_des = powerBlock.LTR.m_turb_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_466(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,466};
  data->simulationInfo->realParameter[105] /* powerBlock.HTR.m_turb_des PARAM */ = data->simulationInfo->realParameter[240] /* powerBlock.LTR.m_turb_des PARAM */;
  TRACE_POP
}

void residualFunc475(void** dataIn, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = (DATA*) ((void**)dataIn[0]);
  threadData_t *threadData = (threadData_t*) ((void**)dataIn[1]);
  const int equationIndexes[2] = {1,475};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  data->simulationInfo->realParameter[240] /* powerBlock.LTR.m_turb_des PARAM */ = xloc[0];
  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_459(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_460(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_461(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_462(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_463(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_464(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_465(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_466(data, threadData);
  res[0] = data->simulationInfo->realParameter[656] /* powerBlock.turbine.m_des PARAM */ - data->simulationInfo->realParameter[105] /* powerBlock.HTR.m_turb_des PARAM */;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData475(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for powerBlock.LTR.m_turb_des */
  linearSystemData->nominal[i] = data->modelData->realParameterData[240].attribute /* powerBlock.LTR.m_turb_des */.nominal;
  linearSystemData->min[i]     = data->modelData->realParameterData[240].attribute /* powerBlock.LTR.m_turb_des */.min;
  linearSystemData->max[i++]   = data->modelData->realParameterData[240].attribute /* powerBlock.LTR.m_turb_des */.max;
}


/*
equation index: 36
type: SIMPLE_ASSIGN
powerBlock._exchanger._Q_HX_des = powerBlock.exchanger.state_HTF_des[2].h - powerBlock.exchanger.state_HTF_des[1].h
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_36(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,36};
  data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */ = data->simulationInfo->realParameter[555] /* powerBlock.exchanger.state_HTF_des[2].h PARAM */ - data->simulationInfo->realParameter[554] /* powerBlock.exchanger.state_HTF_des[1].h PARAM */;
  TRACE_POP
}
/*
equation index: 37
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[3]._h = powerBlock.exchanger.state_HTF_des[2].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_37(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,37};
  data->simulationInfo->realParameter[556] /* powerBlock.exchanger.state_HTF_des[3].h PARAM */ = data->simulationInfo->realParameter[555] /* powerBlock.exchanger.state_HTF_des[2].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 38
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[4]._h = powerBlock.exchanger.state_HTF_des[3].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_38(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,38};
  data->simulationInfo->realParameter[557] /* powerBlock.exchanger.state_HTF_des[4].h PARAM */ = data->simulationInfo->realParameter[556] /* powerBlock.exchanger.state_HTF_des[3].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 39
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[5]._h = powerBlock.exchanger.state_HTF_des[4].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_39(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,39};
  data->simulationInfo->realParameter[558] /* powerBlock.exchanger.state_HTF_des[5].h PARAM */ = data->simulationInfo->realParameter[557] /* powerBlock.exchanger.state_HTF_des[4].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 40
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[6]._h = powerBlock.exchanger.state_HTF_des[5].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_40(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,40};
  data->simulationInfo->realParameter[559] /* powerBlock.exchanger.state_HTF_des[6].h PARAM */ = data->simulationInfo->realParameter[558] /* powerBlock.exchanger.state_HTF_des[5].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 41
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[7]._h = powerBlock.exchanger.state_HTF_des[6].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_41(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,41};
  data->simulationInfo->realParameter[560] /* powerBlock.exchanger.state_HTF_des[7].h PARAM */ = data->simulationInfo->realParameter[559] /* powerBlock.exchanger.state_HTF_des[6].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 42
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[8]._h = powerBlock.exchanger.state_HTF_des[7].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_42(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,42};
  data->simulationInfo->realParameter[561] /* powerBlock.exchanger.state_HTF_des[8].h PARAM */ = data->simulationInfo->realParameter[560] /* powerBlock.exchanger.state_HTF_des[7].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 43
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[9]._h = powerBlock.exchanger.state_HTF_des[8].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_43(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,43};
  data->simulationInfo->realParameter[562] /* powerBlock.exchanger.state_HTF_des[9].h PARAM */ = data->simulationInfo->realParameter[561] /* powerBlock.exchanger.state_HTF_des[8].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 44
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[10]._h = powerBlock.exchanger.state_HTF_des[9].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_44(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,44};
  data->simulationInfo->realParameter[563] /* powerBlock.exchanger.state_HTF_des[10].h PARAM */ = data->simulationInfo->realParameter[562] /* powerBlock.exchanger.state_HTF_des[9].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 45
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[11]._h = powerBlock.exchanger.state_HTF_des[10].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_45(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,45};
  data->simulationInfo->realParameter[564] /* powerBlock.exchanger.state_HTF_des[11].h PARAM */ = data->simulationInfo->realParameter[563] /* powerBlock.exchanger.state_HTF_des[10].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 46
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[12]._h = powerBlock.exchanger.state_HTF_des[11].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_46(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,46};
  data->simulationInfo->realParameter[565] /* powerBlock.exchanger.state_HTF_des[12].h PARAM */ = data->simulationInfo->realParameter[564] /* powerBlock.exchanger.state_HTF_des[11].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 47
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[13]._h = powerBlock.exchanger.state_HTF_des[12].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_47(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,47};
  data->simulationInfo->realParameter[566] /* powerBlock.exchanger.state_HTF_des[13].h PARAM */ = data->simulationInfo->realParameter[565] /* powerBlock.exchanger.state_HTF_des[12].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
/*
equation index: 48
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF_des[14]._h = powerBlock.exchanger.state_HTF_des[13].h + powerBlock.exchanger.Q_HX_des
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_48(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,48};
  data->simulationInfo->realParameter[567] /* powerBlock.exchanger.state_HTF_des[14].h PARAM */ = data->simulationInfo->realParameter[566] /* powerBlock.exchanger.state_HTF_des[13].h PARAM */ + data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}

void residualFunc63(void** dataIn, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = (DATA*) ((void**)dataIn[0]);
  threadData_t *threadData = (threadData_t*) ((void**)dataIn[1]);
  const int equationIndexes[2] = {1,63};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  data->simulationInfo->realParameter[555] /* powerBlock.exchanger.state_HTF_des[2].h PARAM */ = xloc[0];
  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_36(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_37(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_38(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_39(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_40(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_41(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_42(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_43(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_44(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_45(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_46(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_47(data, threadData);

  /* local constraints */
  sCO2PBCalculator_Using_JPidea_eqFunction_48(data, threadData);
  res[0] = data->simulationInfo->realParameter[568] /* powerBlock.exchanger.state_HTF_des[15].h PARAM */ + (-data->simulationInfo->realParameter[567] /* powerBlock.exchanger.state_HTF_des[14].h PARAM */) - data->simulationInfo->realParameter[433] /* powerBlock.exchanger.Q_HX_des PARAM */;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData63(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for powerBlock.exchanger.state_HTF_des[2].h */
  linearSystemData->nominal[i] = data->modelData->realParameterData[555].attribute /* powerBlock.exchanger.state_HTF_des[2].h */.nominal;
  linearSystemData->min[i]     = data->modelData->realParameterData[555].attribute /* powerBlock.exchanger.state_HTF_des[2].h */.min;
  linearSystemData->max[i++]   = data->modelData->realParameterData[555].attribute /* powerBlock.exchanger.state_HTF_des[2].h */.max;
}

/* Prototypes for the strict sets (Dynamic Tearing) */

/* Global constraints for the casual sets */
/* function initialize linear systems */
void sCO2PBCalculator_Using_JPidea_initialLinearSystem(int nLinearSystems, LINEAR_SYSTEM_DATA* linearSystemData)
{
  /* linear systems */
  assertStreamPrint(NULL, nLinearSystems > 2, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[2].equationIndex = 581;
  linearSystemData[2].size = 1;
  linearSystemData[2].nnz = 0;
  linearSystemData[2].method = 1;
  linearSystemData[2].residualFunc = residualFunc581;
  linearSystemData[2].strictTearingFunctionCall = NULL;
  linearSystemData[2].analyticalJacobianColumn = sCO2PBCalculator_Using_JPidea_functionJacLSJac35_column;
  linearSystemData[2].initialAnalyticalJacobian = sCO2PBCalculator_Using_JPidea_initialAnalyticJacobianLSJac35;
  linearSystemData[2].jacobianIndex = 2 /*jacInx*/;
  linearSystemData[2].setA = NULL;//setLinearMatrixA581;
  linearSystemData[2].setb = NULL; //setLinearVectorb581;
  linearSystemData[2].initializeStaticLSData = initializeStaticLSData581;
  linearSystemData[2].parentJacobian = NULL;
  
  assertStreamPrint(NULL, nLinearSystems > 1, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[1].equationIndex = 475;
  linearSystemData[1].size = 1;
  linearSystemData[1].nnz = 0;
  linearSystemData[1].method = 1;
  linearSystemData[1].residualFunc = residualFunc475;
  linearSystemData[1].strictTearingFunctionCall = NULL;
  linearSystemData[1].analyticalJacobianColumn = sCO2PBCalculator_Using_JPidea_functionJacLSJac33_column;
  linearSystemData[1].initialAnalyticalJacobian = sCO2PBCalculator_Using_JPidea_initialAnalyticJacobianLSJac33;
  linearSystemData[1].jacobianIndex = 1 /*jacInx*/;
  linearSystemData[1].setA = NULL;//setLinearMatrixA475;
  linearSystemData[1].setb = NULL; //setLinearVectorb475;
  linearSystemData[1].initializeStaticLSData = initializeStaticLSData475;
  linearSystemData[1].parentJacobian = NULL;
  
  assertStreamPrint(NULL, nLinearSystems > 0, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[0].equationIndex = 63;
  linearSystemData[0].size = 1;
  linearSystemData[0].nnz = 0;
  linearSystemData[0].method = 1;
  linearSystemData[0].residualFunc = residualFunc63;
  linearSystemData[0].strictTearingFunctionCall = NULL;
  linearSystemData[0].analyticalJacobianColumn = sCO2PBCalculator_Using_JPidea_functionJacLSJac1_column;
  linearSystemData[0].initialAnalyticalJacobian = sCO2PBCalculator_Using_JPidea_initialAnalyticJacobianLSJac1;
  linearSystemData[0].jacobianIndex = 0 /*jacInx*/;
  linearSystemData[0].setA = NULL;//setLinearMatrixA63;
  linearSystemData[0].setb = NULL; //setLinearVectorb63;
  linearSystemData[0].initializeStaticLSData = initializeStaticLSData63;
  linearSystemData[0].parentJacobian = NULL;
}

#if defined(__cplusplus)
}
#endif

