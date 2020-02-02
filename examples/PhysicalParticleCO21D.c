/* Main Simulation File */

#if defined(__cplusplus)
extern "C" {
#endif

#include "PhysicalParticleCO21D_model.h"
#include "simulation/solver/events.h"

#define prefixedName_performSimulation PhysicalParticleCO21D_performSimulation
#define prefixedName_updateContinuousSystem PhysicalParticleCO21D_updateContinuousSystem
#include <simulation/solver/perform_simulation.c.inc>

#define prefixedName_performQSSSimulation PhysicalParticleCO21D_performQSSSimulation
#include <simulation/solver/perform_qss_simulation.c.inc>

/* dummy VARINFO and FILEINFO */
const FILE_INFO dummyFILE_INFO = omc_dummyFileInfo;
const VAR_INFO dummyVAR_INFO = omc_dummyVarInfo;

int PhysicalParticleCO21D_input_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_input_function_init(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_input_function_updateStartValues(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_inputNames(DATA *data, char ** names){
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_data_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_output_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_setc_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


/*
equation index: 3834
type: SIMPLE_ASSIGN
particleReceiver1D.vp[4] = (particleReceiver1D.vp[3] ^ 2.0 + 19.6133 * (particleReceiver1D.x[4] - particleReceiver1D.x[3])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3834(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3834};
  modelica_real tmp0;
  modelica_real tmp1;
  tmp0 = data->localData[0]->realVars[407] /* particleReceiver1D.vp[3] variable */;
  tmp1 = (tmp0 * tmp0) + (19.6133) * (data->localData[0]->realVars[429] /* particleReceiver1D.x[4] variable */ - data->localData[0]->realVars[428] /* particleReceiver1D.x[3] variable */);
  if(!(tmp1 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[3] ^ 2.0 + 19.6133 * (particleReceiver1D.x[4] - particleReceiver1D.x[3])) was %g should be >= 0", tmp1);
  }
  data->localData[0]->realVars[408] /* particleReceiver1D.vp[4] variable */ = sqrt(tmp1);
  TRACE_POP
}
/*
equation index: 3835
type: SIMPLE_ASSIGN
particleReceiver1D.vp[5] = (particleReceiver1D.vp[4] ^ 2.0 + 19.6133 * (particleReceiver1D.x[5] - particleReceiver1D.x[4])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3835(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3835};
  modelica_real tmp2;
  modelica_real tmp3;
  tmp2 = data->localData[0]->realVars[408] /* particleReceiver1D.vp[4] variable */;
  tmp3 = (tmp2 * tmp2) + (19.6133) * (data->localData[0]->realVars[430] /* particleReceiver1D.x[5] variable */ - data->localData[0]->realVars[429] /* particleReceiver1D.x[4] variable */);
  if(!(tmp3 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[4] ^ 2.0 + 19.6133 * (particleReceiver1D.x[5] - particleReceiver1D.x[4])) was %g should be >= 0", tmp3);
  }
  data->localData[0]->realVars[409] /* particleReceiver1D.vp[5] variable */ = sqrt(tmp3);
  TRACE_POP
}
/*
equation index: 3836
type: SIMPLE_ASSIGN
particleReceiver1D.vp[6] = (particleReceiver1D.vp[5] ^ 2.0 + 19.6133 * (particleReceiver1D.x[6] - particleReceiver1D.x[5])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3836(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3836};
  modelica_real tmp4;
  modelica_real tmp5;
  tmp4 = data->localData[0]->realVars[409] /* particleReceiver1D.vp[5] variable */;
  tmp5 = (tmp4 * tmp4) + (19.6133) * (data->localData[0]->realVars[431] /* particleReceiver1D.x[6] variable */ - data->localData[0]->realVars[430] /* particleReceiver1D.x[5] variable */);
  if(!(tmp5 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[5] ^ 2.0 + 19.6133 * (particleReceiver1D.x[6] - particleReceiver1D.x[5])) was %g should be >= 0", tmp5);
  }
  data->localData[0]->realVars[410] /* particleReceiver1D.vp[6] variable */ = sqrt(tmp5);
  TRACE_POP
}
/*
equation index: 3837
type: SIMPLE_ASSIGN
particleReceiver1D.vp[7] = (particleReceiver1D.vp[6] ^ 2.0 + 19.6133 * (particleReceiver1D.x[7] - particleReceiver1D.x[6])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3837(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3837};
  modelica_real tmp6;
  modelica_real tmp7;
  tmp6 = data->localData[0]->realVars[410] /* particleReceiver1D.vp[6] variable */;
  tmp7 = (tmp6 * tmp6) + (19.6133) * (data->localData[0]->realVars[432] /* particleReceiver1D.x[7] variable */ - data->localData[0]->realVars[431] /* particleReceiver1D.x[6] variable */);
  if(!(tmp7 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[6] ^ 2.0 + 19.6133 * (particleReceiver1D.x[7] - particleReceiver1D.x[6])) was %g should be >= 0", tmp7);
  }
  data->localData[0]->realVars[411] /* particleReceiver1D.vp[7] variable */ = sqrt(tmp7);
  TRACE_POP
}
/*
equation index: 3838
type: SIMPLE_ASSIGN
particleReceiver1D.vp[8] = (particleReceiver1D.vp[7] ^ 2.0 + 19.6133 * (particleReceiver1D.x[8] - particleReceiver1D.x[7])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3838(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3838};
  modelica_real tmp8;
  modelica_real tmp9;
  tmp8 = data->localData[0]->realVars[411] /* particleReceiver1D.vp[7] variable */;
  tmp9 = (tmp8 * tmp8) + (19.6133) * (data->localData[0]->realVars[433] /* particleReceiver1D.x[8] variable */ - data->localData[0]->realVars[432] /* particleReceiver1D.x[7] variable */);
  if(!(tmp9 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[7] ^ 2.0 + 19.6133 * (particleReceiver1D.x[8] - particleReceiver1D.x[7])) was %g should be >= 0", tmp9);
  }
  data->localData[0]->realVars[412] /* particleReceiver1D.vp[8] variable */ = sqrt(tmp9);
  TRACE_POP
}
/*
equation index: 3839
type: SIMPLE_ASSIGN
particleReceiver1D.vp[9] = (particleReceiver1D.vp[8] ^ 2.0 + 19.6133 * (particleReceiver1D.x[9] - particleReceiver1D.x[8])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3839(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3839};
  modelica_real tmp10;
  modelica_real tmp11;
  tmp10 = data->localData[0]->realVars[412] /* particleReceiver1D.vp[8] variable */;
  tmp11 = (tmp10 * tmp10) + (19.6133) * (data->localData[0]->realVars[434] /* particleReceiver1D.x[9] variable */ - data->localData[0]->realVars[433] /* particleReceiver1D.x[8] variable */);
  if(!(tmp11 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[8] ^ 2.0 + 19.6133 * (particleReceiver1D.x[9] - particleReceiver1D.x[8])) was %g should be >= 0", tmp11);
  }
  data->localData[0]->realVars[413] /* particleReceiver1D.vp[9] variable */ = sqrt(tmp11);
  TRACE_POP
}
/*
equation index: 3840
type: SIMPLE_ASSIGN
particleReceiver1D.vp[10] = (particleReceiver1D.vp[9] ^ 2.0 + 19.6133 * (particleReceiver1D.x[10] - particleReceiver1D.x[9])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3840(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3840};
  modelica_real tmp12;
  modelica_real tmp13;
  tmp12 = data->localData[0]->realVars[413] /* particleReceiver1D.vp[9] variable */;
  tmp13 = (tmp12 * tmp12) + (19.6133) * (data->localData[0]->realVars[435] /* particleReceiver1D.x[10] variable */ - data->localData[0]->realVars[434] /* particleReceiver1D.x[9] variable */);
  if(!(tmp13 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[9] ^ 2.0 + 19.6133 * (particleReceiver1D.x[10] - particleReceiver1D.x[9])) was %g should be >= 0", tmp13);
  }
  data->localData[0]->realVars[414] /* particleReceiver1D.vp[10] variable */ = sqrt(tmp13);
  TRACE_POP
}
/*
equation index: 3841
type: SIMPLE_ASSIGN
particleReceiver1D.vp[11] = (particleReceiver1D.vp[10] ^ 2.0 + 19.6133 * (particleReceiver1D.x[11] - particleReceiver1D.x[10])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3841(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3841};
  modelica_real tmp14;
  modelica_real tmp15;
  tmp14 = data->localData[0]->realVars[414] /* particleReceiver1D.vp[10] variable */;
  tmp15 = (tmp14 * tmp14) + (19.6133) * (data->localData[0]->realVars[436] /* particleReceiver1D.x[11] variable */ - data->localData[0]->realVars[435] /* particleReceiver1D.x[10] variable */);
  if(!(tmp15 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[10] ^ 2.0 + 19.6133 * (particleReceiver1D.x[11] - particleReceiver1D.x[10])) was %g should be >= 0", tmp15);
  }
  data->localData[0]->realVars[415] /* particleReceiver1D.vp[11] variable */ = sqrt(tmp15);
  TRACE_POP
}
/*
equation index: 3842
type: SIMPLE_ASSIGN
particleReceiver1D.vp[12] = (particleReceiver1D.vp[11] ^ 2.0 + 19.6133 * (particleReceiver1D.x[12] - particleReceiver1D.x[11])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3842(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3842};
  modelica_real tmp16;
  modelica_real tmp17;
  tmp16 = data->localData[0]->realVars[415] /* particleReceiver1D.vp[11] variable */;
  tmp17 = (tmp16 * tmp16) + (19.6133) * (data->localData[0]->realVars[437] /* particleReceiver1D.x[12] variable */ - data->localData[0]->realVars[436] /* particleReceiver1D.x[11] variable */);
  if(!(tmp17 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[11] ^ 2.0 + 19.6133 * (particleReceiver1D.x[12] - particleReceiver1D.x[11])) was %g should be >= 0", tmp17);
  }
  data->localData[0]->realVars[416] /* particleReceiver1D.vp[12] variable */ = sqrt(tmp17);
  TRACE_POP
}
/*
equation index: 3843
type: SIMPLE_ASSIGN
particleReceiver1D.vp[13] = (particleReceiver1D.vp[12] ^ 2.0 + 19.6133 * (particleReceiver1D.x[13] - particleReceiver1D.x[12])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3843(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3843};
  modelica_real tmp18;
  modelica_real tmp19;
  tmp18 = data->localData[0]->realVars[416] /* particleReceiver1D.vp[12] variable */;
  tmp19 = (tmp18 * tmp18) + (19.6133) * (data->localData[0]->realVars[438] /* particleReceiver1D.x[13] variable */ - data->localData[0]->realVars[437] /* particleReceiver1D.x[12] variable */);
  if(!(tmp19 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[12] ^ 2.0 + 19.6133 * (particleReceiver1D.x[13] - particleReceiver1D.x[12])) was %g should be >= 0", tmp19);
  }
  data->localData[0]->realVars[417] /* particleReceiver1D.vp[13] variable */ = sqrt(tmp19);
  TRACE_POP
}
/*
equation index: 3844
type: SIMPLE_ASSIGN
particleReceiver1D.vp[14] = (particleReceiver1D.vp[13] ^ 2.0 + 19.6133 * (particleReceiver1D.x[14] - particleReceiver1D.x[13])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3844(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3844};
  modelica_real tmp20;
  modelica_real tmp21;
  tmp20 = data->localData[0]->realVars[417] /* particleReceiver1D.vp[13] variable */;
  tmp21 = (tmp20 * tmp20) + (19.6133) * (data->localData[0]->realVars[439] /* particleReceiver1D.x[14] variable */ - data->localData[0]->realVars[438] /* particleReceiver1D.x[13] variable */);
  if(!(tmp21 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[13] ^ 2.0 + 19.6133 * (particleReceiver1D.x[14] - particleReceiver1D.x[13])) was %g should be >= 0", tmp21);
  }
  data->localData[0]->realVars[418] /* particleReceiver1D.vp[14] variable */ = sqrt(tmp21);
  TRACE_POP
}
/*
equation index: 3845
type: SIMPLE_ASSIGN
particleReceiver1D.vp[15] = (particleReceiver1D.vp[14] ^ 2.0 + 19.6133 * (particleReceiver1D.x[15] - particleReceiver1D.x[14])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3845(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3845};
  modelica_real tmp22;
  modelica_real tmp23;
  tmp22 = data->localData[0]->realVars[418] /* particleReceiver1D.vp[14] variable */;
  tmp23 = (tmp22 * tmp22) + (19.6133) * (data->localData[0]->realVars[440] /* particleReceiver1D.x[15] variable */ - data->localData[0]->realVars[439] /* particleReceiver1D.x[14] variable */);
  if(!(tmp23 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[14] ^ 2.0 + 19.6133 * (particleReceiver1D.x[15] - particleReceiver1D.x[14])) was %g should be >= 0", tmp23);
  }
  data->localData[0]->realVars[419] /* particleReceiver1D.vp[15] variable */ = sqrt(tmp23);
  TRACE_POP
}
/*
equation index: 3846
type: SIMPLE_ASSIGN
particleReceiver1D.vp[16] = (particleReceiver1D.vp[15] ^ 2.0 + 19.6133 * (particleReceiver1D.x[16] - particleReceiver1D.x[15])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3846(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3846};
  modelica_real tmp24;
  modelica_real tmp25;
  tmp24 = data->localData[0]->realVars[419] /* particleReceiver1D.vp[15] variable */;
  tmp25 = (tmp24 * tmp24) + (19.6133) * (data->localData[0]->realVars[441] /* particleReceiver1D.x[16] variable */ - data->localData[0]->realVars[440] /* particleReceiver1D.x[15] variable */);
  if(!(tmp25 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[15] ^ 2.0 + 19.6133 * (particleReceiver1D.x[16] - particleReceiver1D.x[15])) was %g should be >= 0", tmp25);
  }
  data->localData[0]->realVars[420] /* particleReceiver1D.vp[16] variable */ = sqrt(tmp25);
  TRACE_POP
}
/*
equation index: 3847
type: SIMPLE_ASSIGN
particleReceiver1D.vp[17] = (particleReceiver1D.vp[16] ^ 2.0 + 19.6133 * (particleReceiver1D.x[17] - particleReceiver1D.x[16])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3847(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3847};
  modelica_real tmp26;
  modelica_real tmp27;
  tmp26 = data->localData[0]->realVars[420] /* particleReceiver1D.vp[16] variable */;
  tmp27 = (tmp26 * tmp26) + (19.6133) * (data->localData[0]->realVars[442] /* particleReceiver1D.x[17] variable */ - data->localData[0]->realVars[441] /* particleReceiver1D.x[16] variable */);
  if(!(tmp27 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[16] ^ 2.0 + 19.6133 * (particleReceiver1D.x[17] - particleReceiver1D.x[16])) was %g should be >= 0", tmp27);
  }
  data->localData[0]->realVars[421] /* particleReceiver1D.vp[17] variable */ = sqrt(tmp27);
  TRACE_POP
}
/*
equation index: 3848
type: SIMPLE_ASSIGN
particleReceiver1D.vp[18] = (particleReceiver1D.vp[17] ^ 2.0 + 19.6133 * (particleReceiver1D.x[18] - particleReceiver1D.x[17])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3848(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3848};
  modelica_real tmp28;
  modelica_real tmp29;
  tmp28 = data->localData[0]->realVars[421] /* particleReceiver1D.vp[17] variable */;
  tmp29 = (tmp28 * tmp28) + (19.6133) * (data->localData[0]->realVars[443] /* particleReceiver1D.x[18] variable */ - data->localData[0]->realVars[442] /* particleReceiver1D.x[17] variable */);
  if(!(tmp29 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[17] ^ 2.0 + 19.6133 * (particleReceiver1D.x[18] - particleReceiver1D.x[17])) was %g should be >= 0", tmp29);
  }
  data->localData[0]->realVars[422] /* particleReceiver1D.vp[18] variable */ = sqrt(tmp29);
  TRACE_POP
}
/*
equation index: 3849
type: SIMPLE_ASSIGN
particleReceiver1D.vp[19] = (particleReceiver1D.vp[18] ^ 2.0 + 19.6133 * (particleReceiver1D.x[19] - particleReceiver1D.x[18])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3849(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3849};
  modelica_real tmp30;
  modelica_real tmp31;
  tmp30 = data->localData[0]->realVars[422] /* particleReceiver1D.vp[18] variable */;
  tmp31 = (tmp30 * tmp30) + (19.6133) * (data->localData[0]->realVars[444] /* particleReceiver1D.x[19] variable */ - data->localData[0]->realVars[443] /* particleReceiver1D.x[18] variable */);
  if(!(tmp31 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[18] ^ 2.0 + 19.6133 * (particleReceiver1D.x[19] - particleReceiver1D.x[18])) was %g should be >= 0", tmp31);
  }
  data->localData[0]->realVars[423] /* particleReceiver1D.vp[19] variable */ = sqrt(tmp31);
  TRACE_POP
}
/*
equation index: 3850
type: SIMPLE_ASSIGN
particleReceiver1D.vp[20] = (particleReceiver1D.vp[19] ^ 2.0 + 19.6133 * (particleReceiver1D.x[20] - particleReceiver1D.x[19])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3850(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3850};
  modelica_real tmp32;
  modelica_real tmp33;
  tmp32 = data->localData[0]->realVars[423] /* particleReceiver1D.vp[19] variable */;
  tmp33 = (tmp32 * tmp32) + (19.6133) * (data->localData[0]->realVars[445] /* particleReceiver1D.x[20] variable */ - data->localData[0]->realVars[444] /* particleReceiver1D.x[19] variable */);
  if(!(tmp33 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[19] ^ 2.0 + 19.6133 * (particleReceiver1D.x[20] - particleReceiver1D.x[19])) was %g should be >= 0", tmp33);
  }
  data->localData[0]->realVars[424] /* particleReceiver1D.vp[20] variable */ = sqrt(tmp33);
  TRACE_POP
}
/*
equation index: 3851
type: SIMPLE_ASSIGN
particleReceiver1D.vp[21] = (particleReceiver1D.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1D.x[21] - particleReceiver1D.x[20])) ^ 0.5
*/
void PhysicalParticleCO21D_eqFunction_3851(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3851};
  modelica_real tmp34;
  modelica_real tmp35;
  tmp34 = data->localData[0]->realVars[424] /* particleReceiver1D.vp[20] variable */;
  tmp35 = (tmp34 * tmp34) + (19.6133) * (data->localData[0]->realVars[446] /* particleReceiver1D.x[21] variable */ - data->localData[0]->realVars[445] /* particleReceiver1D.x[20] variable */);
  if(!(tmp35 >= 0.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
    throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1D.x[21] - particleReceiver1D.x[20])) was %g should be >= 0", tmp35);
  }
  data->localData[0]->realVars[425] /* particleReceiver1D.vp[21] variable */ = sqrt(tmp35);
  TRACE_POP
}
/*
equation index: 3852
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.mdot = particleReceiver1DCalculator.liftSimple.m_flow_fixed
*/
void PhysicalParticleCO21D_eqFunction_3852(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3852};
  data->localData[0]->realVars[746] /* particleReceiver1DCalculator.particleReceiver1D_v11.mdot variable */ = data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */;
  TRACE_POP
}
/*
equation index: 3853
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.phi[1] = particleReceiver1DCalculator.particleReceiver1D_v11.phi_max
*/
void PhysicalParticleCO21D_eqFunction_3853(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3853};
  data->localData[0]->realVars[747] /* particleReceiver1DCalculator.particleReceiver1D_v11.phi[1] variable */ = data->simulationInfo->realParameter[315] /* particleReceiver1DCalculator.particleReceiver1D_v11.phi_max PARAM */;
  TRACE_POP
}
/*
equation index: 3854
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1DCalculator$particleReceiver1D_v11$Tab.getTableValue(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableID, 1, 1073.15, particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_3854(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3854};
  data->localData[0]->realVars[724] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] variable */ = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_getTableValue(threadData, data->simulationInfo->extObjs[43], ((modelica_integer) 1), 1073.15, data->simulationInfo->realParameter[299] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 3855
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1DCalculator$particleReceiver1D_v11$Tab.getTableValue(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableID, 1, particleReceiver1DCalculator.particleReceiver1D_v11.T_s[1], particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_3855(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3855};
  data->localData[0]->realVars[704] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] variable */ = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_getTableValue(threadData, data->simulationInfo->extObjs[23], ((modelica_integer) 1), data->localData[0]->realVars[580] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[1] variable */, data->simulationInfo->realParameter[279] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 3856
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec = max(particleReceiver1DCalculator.liftSimple.m_flow_fixed * (particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] - particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1]), 0.0)
*/
void PhysicalParticleCO21D_eqFunction_3856(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3856};
  data->localData[0]->realVars[573] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec variable */ = fmax((data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */) * (data->localData[0]->realVars[724] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] variable */ - data->localData[0]->realVars[704] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] variable */),0.0);
  TRACE_POP
}
void PhysicalParticleCO21D_eqFunction_3857(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3858(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3859(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3860(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3861(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3862(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3863(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3864(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3865(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3866(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3867(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3868(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3869(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3870(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3871(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3872(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3873(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3874(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3875(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3876(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3877(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3878(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3879(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3880(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3881(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3882(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3883(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3884(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3885(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3886(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3887(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3888(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3889(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3890(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3891(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3892(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3893(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3894(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3895(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3896(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3897(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3898(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3899(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3900(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3901(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3902(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3903(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3904(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3905(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3906(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3907(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3908(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3909(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3910(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3911(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3912(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3913(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3914(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3915(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3916(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3917(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3918(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3919(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3920(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3921(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3922(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3923(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3924(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3925(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3926(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3927(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3928(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3929(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3930(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3931(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3932(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3933(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3934(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3935(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3936(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3937(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3938(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3939(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3940(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3941(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3942(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3943(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3944(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3945(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3946(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3947(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3948(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3949(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3950(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3951(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3952(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3953(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3954(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3955(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3956(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3957(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3958(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3959(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3960(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3961(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3962(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3963(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3964(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3965(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3966(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3967(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3968(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3969(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3970(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3971(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3972(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3973(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3974(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3975(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3976(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3977(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3978(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3979(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3980(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3981(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3982(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3983(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3984(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3985(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3986(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3987(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3988(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3989(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3990(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3991(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3992(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3993(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3994(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3995(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3996(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3997(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3998(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_3999(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4000(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4001(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4002(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4003(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4004(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4005(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4006(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4007(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4008(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4009(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4010(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4011(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4012(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4013(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4014(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4015(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4016(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4017(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4018(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4019(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4020(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4021(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4022(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4023(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4024(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4025(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4026(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4027(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4028(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4029(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4030(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4031(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4032(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4033(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4034(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4035(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4036(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4037(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4097(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4096(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4095(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4094(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4093(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4092(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4091(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4090(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4089(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4088(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4087(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4086(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4085(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4084(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4083(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4082(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4081(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4080(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4079(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4078(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4077(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4076(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4075(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4074(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4073(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4072(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4071(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4070(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4069(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4068(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4067(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4066(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4065(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4064(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4063(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4062(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4061(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4060(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4059(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4058(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4057(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4056(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4055(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4054(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4053(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4052(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4051(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4050(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4049(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4048(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4047(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4046(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4045(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4044(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4043(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4042(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4041(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4040(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4039(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4038(DATA*, threadData_t*);
/*
equation index: 4098
indexNonlinear: 42
type: NONLINEAR

vars: {particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[22], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[1], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[12], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[20], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[19], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[18], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[16], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[17], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[15], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[14], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[13], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[11], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[10], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[9], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[8], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[7], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[6], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[4], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[5], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[3], particleReceiver1DCalculator.particleReceiver1D_v11.dx}
eqns: {3857, 3858, 3859, 3860, 3861, 3862, 3863, 3864, 3865, 3866, 3867, 3868, 3869, 3870, 3871, 3872, 3873, 3874, 3875, 3876, 3877, 3878, 3879, 3880, 3881, 3882, 3883, 3884, 3885, 3886, 3887, 3888, 3889, 3890, 3891, 3892, 3893, 3894, 3895, 3896, 3897, 3898, 3899, 3900, 3901, 3902, 3903, 3904, 3905, 3906, 3907, 3908, 3909, 3910, 3911, 3912, 3913, 3914, 3915, 3916, 3917, 3918, 3919, 3920, 3921, 3922, 3923, 3924, 3925, 3926, 3927, 3928, 3929, 3930, 3931, 3932, 3933, 3934, 3935, 3936, 3937, 3938, 3939, 3940, 3941, 3942, 3943, 3944, 3945, 3946, 3947, 3948, 3949, 3950, 3951, 3952, 3953, 3954, 3955, 3956, 3957, 3958, 3959, 3960, 3961, 3962, 3963, 3964, 3965, 3966, 3967, 3968, 3969, 3970, 3971, 3972, 3973, 3974, 3975, 3976, 3977, 3978, 3979, 3980, 3981, 3982, 3983, 3984, 3985, 3986, 3987, 3988, 3989, 3990, 3991, 3992, 3993, 3994, 3995, 3996, 3997, 3998, 3999, 4000, 4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008, 4009, 4010, 4011, 4012, 4013, 4014, 4015, 4016, 4017, 4018, 4019, 4020, 4021, 4022, 4023, 4024, 4025, 4026, 4027, 4028, 4029, 4030, 4031, 4032, 4033, 4034, 4035, 4036, 4037, 4097, 4096, 4095, 4094, 4093, 4092, 4091, 4090, 4089, 4088, 4087, 4086, 4085, 4084, 4083, 4082, 4081, 4080, 4079, 4078, 4077, 4076, 4075, 4074, 4073, 4072, 4071, 4070, 4069, 4068, 4067, 4066, 4065, 4064, 4063, 4062, 4061, 4060, 4059, 4058, 4057, 4056, 4055, 4054, 4053, 4052, 4051, 4050, 4049, 4048, 4047, 4046, 4045, 4044, 4043, 4042, 4041, 4040, 4039, 4038}
*/
void PhysicalParticleCO21D_eqFunction_4098(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4098};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 4098 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[0] = data->localData[0]->realVars[703] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[1] = data->localData[0]->realVars[619] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[22] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[2] = data->localData[0]->realVars[600] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[1] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[3] = data->localData[0]->realVars[599] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[4] = data->localData[0]->realVars[702] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[5] = data->localData[0]->realVars[598] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[6] = data->localData[0]->realVars[701] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[7] = data->localData[0]->realVars[597] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[8] = data->localData[0]->realVars[700] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[9] = data->localData[0]->realVars[596] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[10] = data->localData[0]->realVars[699] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[11] = data->localData[0]->realVars[595] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[12] = data->localData[0]->realVars[698] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[13] = data->localData[0]->realVars[594] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[14] = data->localData[0]->realVars[697] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[15] = data->localData[0]->realVars[593] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[16] = data->localData[0]->realVars[696] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[17] = data->localData[0]->realVars[592] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[18] = data->localData[0]->realVars[695] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[19] = data->localData[0]->realVars[591] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[20] = data->localData[0]->realVars[694] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[21] = data->localData[0]->realVars[590] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[22] = data->localData[0]->realVars[693] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[23] = data->localData[0]->realVars[589] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[24] = data->localData[0]->realVars[692] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[25] = data->localData[0]->realVars[588] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[26] = data->localData[0]->realVars[691] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[27] = data->localData[0]->realVars[587] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[28] = data->localData[0]->realVars[690] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[29] = data->localData[0]->realVars[586] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[30] = data->localData[0]->realVars[689] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[31] = data->localData[0]->realVars[585] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[32] = data->localData[0]->realVars[688] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[33] = data->localData[0]->realVars[584] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[34] = data->localData[0]->realVars[687] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[35] = data->localData[0]->realVars[583] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[36] = data->localData[0]->realVars[686] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[37] = data->localData[0]->realVars[582] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[38] = data->localData[0]->realVars[685] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[39] = data->localData[0]->realVars[581] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[40] = data->localData[0]->realVars[684] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[41] = data->localData[0]->realVars[610] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[12] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[42] = data->localData[0]->realVars[618] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[20] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[43] = data->localData[0]->realVars[617] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[19] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[44] = data->localData[0]->realVars[616] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[18] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[45] = data->localData[0]->realVars[614] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[16] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[46] = data->localData[0]->realVars[615] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[17] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[47] = data->localData[0]->realVars[613] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[15] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[48] = data->localData[0]->realVars[612] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[14] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[49] = data->localData[0]->realVars[611] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[13] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[50] = data->localData[0]->realVars[609] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[11] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[51] = data->localData[0]->realVars[608] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[10] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[52] = data->localData[0]->realVars[607] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[9] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[53] = data->localData[0]->realVars[606] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[8] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[54] = data->localData[0]->realVars[605] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[7] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[55] = data->localData[0]->realVars[604] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[6] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[56] = data->localData[0]->realVars[602] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[4] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[57] = data->localData[0]->realVars[603] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[5] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[58] = data->localData[0]->realVars[601] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[3] variable */;
  data->simulationInfo->nonlinearSystemData[42].nlsxOld[59] = data->localData[0]->realVars[641] /* particleReceiver1DCalculator.particleReceiver1D_v11.dx variable */;
  retValue = solve_nonlinear_system(data, threadData, 42);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,4098};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 4098 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[703] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[0];
  data->localData[0]->realVars[619] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[22] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[1];
  data->localData[0]->realVars[600] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[1] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[2];
  data->localData[0]->realVars[599] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[3];
  data->localData[0]->realVars[702] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[4];
  data->localData[0]->realVars[598] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[5];
  data->localData[0]->realVars[701] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[6];
  data->localData[0]->realVars[597] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[7];
  data->localData[0]->realVars[700] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[8];
  data->localData[0]->realVars[596] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[9];
  data->localData[0]->realVars[699] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[10];
  data->localData[0]->realVars[595] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[11];
  data->localData[0]->realVars[698] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[12];
  data->localData[0]->realVars[594] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[13];
  data->localData[0]->realVars[697] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[14];
  data->localData[0]->realVars[593] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[15];
  data->localData[0]->realVars[696] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[16];
  data->localData[0]->realVars[592] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[17];
  data->localData[0]->realVars[695] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[18];
  data->localData[0]->realVars[591] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[19];
  data->localData[0]->realVars[694] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[20];
  data->localData[0]->realVars[590] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[21];
  data->localData[0]->realVars[693] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[22];
  data->localData[0]->realVars[589] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[23];
  data->localData[0]->realVars[692] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[24];
  data->localData[0]->realVars[588] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[25];
  data->localData[0]->realVars[691] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[26];
  data->localData[0]->realVars[587] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[27];
  data->localData[0]->realVars[690] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[28];
  data->localData[0]->realVars[586] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[29];
  data->localData[0]->realVars[689] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[30];
  data->localData[0]->realVars[585] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[31];
  data->localData[0]->realVars[688] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[32];
  data->localData[0]->realVars[584] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[33];
  data->localData[0]->realVars[687] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[34];
  data->localData[0]->realVars[583] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[35];
  data->localData[0]->realVars[686] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[36];
  data->localData[0]->realVars[582] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[37];
  data->localData[0]->realVars[685] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[38];
  data->localData[0]->realVars[581] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[39];
  data->localData[0]->realVars[684] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[40];
  data->localData[0]->realVars[610] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[12] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[41];
  data->localData[0]->realVars[618] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[20] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[42];
  data->localData[0]->realVars[617] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[19] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[43];
  data->localData[0]->realVars[616] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[18] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[44];
  data->localData[0]->realVars[614] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[16] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[45];
  data->localData[0]->realVars[615] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[17] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[46];
  data->localData[0]->realVars[613] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[15] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[47];
  data->localData[0]->realVars[612] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[14] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[48];
  data->localData[0]->realVars[611] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[13] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[49];
  data->localData[0]->realVars[609] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[11] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[50];
  data->localData[0]->realVars[608] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[10] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[51];
  data->localData[0]->realVars[607] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[9] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[52];
  data->localData[0]->realVars[606] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[8] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[53];
  data->localData[0]->realVars[605] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[7] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[54];
  data->localData[0]->realVars[604] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[6] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[55];
  data->localData[0]->realVars[602] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[4] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[56];
  data->localData[0]->realVars[603] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[5] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[57];
  data->localData[0]->realVars[601] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[3] variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[58];
  data->localData[0]->realVars[641] /* particleReceiver1DCalculator.particleReceiver1D_v11.dx variable */ = data->simulationInfo->nonlinearSystemData[42].nlsx[59];
  TRACE_POP
}
/*
equation index: 4099
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.A_ap = particleReceiver1DCalculator.particleReceiver1D_v11.H_drop * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv
*/
void PhysicalParticleCO21D_eqFunction_4099(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4099};
  data->localData[0]->realVars[489] /* particleReceiver1DCalculator.particleReceiver1D_v11.A_ap variable */ = (data->localData[0]->realVars[530] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */) * (data->localData[0]->realVars[620] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */);
  TRACE_POP
}
/*
equation index: 4100
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc = particleReceiver1DCalculator.particleReceiver1D_v11.q_solar * particleReceiver1DCalculator.particleReceiver1D_v11.A_ap
*/
void PhysicalParticleCO21D_eqFunction_4100(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4100};
  data->localData[0]->realVars[572] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc variable */ = (data->localData[0]->realVars[848] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_solar variable */) * (data->localData[0]->realVars[489] /* particleReceiver1DCalculator.particleReceiver1D_v11.A_ap variable */);
  TRACE_POP
}
/*
equation index: 4101
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.eta_rec = max(particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec / particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc, 0.0)
*/
void PhysicalParticleCO21D_eqFunction_4101(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4101};
  data->localData[0]->realVars[662] /* particleReceiver1DCalculator.particleReceiver1D_v11.eta_rec variable */ = fmax(DIVISION_SIM(data->localData[0]->realVars[573] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec variable */,data->localData[0]->realVars[572] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc variable */,"particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc",equationIndexes),0.0);
  TRACE_POP
}
/*
equation index: 4102
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.t_c[22] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4102(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4102};
  modelica_boolean tmp0;
  tmp0 = Greater(data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[890] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c[22] variable */ = (tmp0?data->localData[0]->realVars[891] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[530] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */):0.0);
  TRACE_POP
}
/*
equation index: 4103
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1DCalculator.particleReceiver1D_v11.x[21] else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4103(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4103};
  modelica_boolean tmp1;
  tmp1 = Greater(data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[889] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] variable */ = (tmp1?data->localData[0]->realVars[891] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[952] /* particleReceiver1DCalculator.particleReceiver1D_v11.x[21] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4104
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1DCalculator.particleReceiver1D_v11.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1DCalculator.particleReceiver1D_v11.x[21] - particleReceiver1DCalculator.particleReceiver1D_v11.x[20])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4104(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4104};
  modelica_boolean tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_boolean tmp5;
  modelica_real tmp6;
  tmp2 = Greater(data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp5 = (modelica_boolean)tmp2;
  if(tmp5)
  {
    tmp3 = data->localData[0]->realVars[930] /* particleReceiver1DCalculator.particleReceiver1D_v11.vp[20] variable */;
    tmp4 = (tmp3 * tmp3) + (19.6133) * (data->localData[0]->realVars[952] /* particleReceiver1DCalculator.particleReceiver1D_v11.x[21] variable */ - data->localData[0]->realVars[951] /* particleReceiver1DCalculator.particleReceiver1D_v11.x[20] variable */);
    if(!(tmp4 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1DCalculator.particleReceiver1D_v11.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1DCalculator.particleReceiver1D_v11.x[21] - particleReceiver1DCalculator.particleReceiver1D_v11.x[20])) was %g should be >= 0", tmp4);
    }
    tmp6 = sqrt(tmp4);
  }
  else
  {
    tmp6 = 0.0;
  }
  data->localData[0]->realVars[931] /* particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] variable */ = tmp6;
  TRACE_POP
}
/*
equation index: 4105
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.phi[21] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then particleReceiver1DCalculator.liftSimple.m_flow_fixed / (particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] * particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] * particleReceiver1DCalculator.particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4105(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4105};
  modelica_boolean tmp7;
  tmp7 = Greater(data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[767] /* particleReceiver1DCalculator.particleReceiver1D_v11.phi[21] variable */ = (tmp7?DIVISION_SIM(data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[620] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[889] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] variable */)) * (data->localData[0]->realVars[931] /* particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] variable */)) * (data->simulationInfo->realParameter[318] /* particleReceiver1DCalculator.particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] * particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] * particleReceiver1DCalculator.particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4106
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4106(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4106};
  data->localData[0]->realVars[804] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[597] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4107
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4107(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4107};
  data->localData[0]->realVars[805] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[598] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4108
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4108(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4108};
  data->localData[0]->realVars[806] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[599] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4109
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4109(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4109};
  data->localData[0]->realVars[801] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[594] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4110
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4110(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4110};
  data->localData[0]->realVars[799] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[592] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4111
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4111(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4111};
  data->localData[0]->realVars[800] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[593] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4112
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4112(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4112};
  data->localData[0]->realVars[802] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[595] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4113
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4113(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4113};
  data->localData[0]->realVars[803] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[596] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4114
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4114(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4114};
  data->localData[0]->realVars[798] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[591] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4115
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4115(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4115};
  data->localData[0]->realVars[793] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[586] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4116
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4116(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4116};
  data->localData[0]->realVars[794] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[587] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4117
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4117(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4117};
  data->localData[0]->realVars[795] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[588] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4118
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4118(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4118};
  data->localData[0]->realVars[796] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[589] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4119
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4119(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4119};
  data->localData[0]->realVars[797] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[590] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4120
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4120(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4120};
  data->localData[0]->realVars[792] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[585] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4121
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4121(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4121};
  data->localData[0]->realVars[791] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[584] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4122
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4122(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4122};
  data->localData[0]->realVars[790] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[583] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4123
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4123(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4123};
  data->localData[0]->realVars[788] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[581] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4124
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_eqFunction_4124(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4124};
  data->localData[0]->realVars[789] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] variable */ = (data->simulationInfo->realParameter[312] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[582] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] variable */ - data->simulationInfo->realParameter[259] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4125
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain = (particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_eqFunction_4125(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4125};
  data->localData[0]->realVars[575] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain variable */ = (data->localData[0]->realVars[788] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] variable */ + data->localData[0]->realVars[789] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] variable */ + data->localData[0]->realVars[790] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] variable */ + data->localData[0]->realVars[791] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] variable */ + data->localData[0]->realVars[792] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] variable */ + data->localData[0]->realVars[793] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] variable */ + data->localData[0]->realVars[794] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] variable */ + data->localData[0]->realVars[795] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] variable */ + data->localData[0]->realVars[796] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] variable */ + data->localData[0]->realVars[797] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] variable */ + data->localData[0]->realVars[798] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] variable */ + data->localData[0]->realVars[799] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] variable */ + data->localData[0]->realVars[800] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] variable */ + data->localData[0]->realVars[801] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] variable */ + data->localData[0]->realVars[802] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] variable */ + data->localData[0]->realVars[803] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] variable */ + data->localData[0]->realVars[804] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] variable */ + data->localData[0]->realVars[805] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] variable */ + data->localData[0]->realVars[806] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] variable */ + data->localData[0]->realVars[807] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[20] variable */) * ((data->localData[0]->realVars[620] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[530] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4126
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_wall = (particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[1] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[2] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[3] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[4] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[5] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[6] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[7] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[8] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[9] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[10] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[11] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[12] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[13] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[14] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[15] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[16] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[17] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[18] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[19] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_eqFunction_4126(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4126};
  data->localData[0]->realVars[576] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_wall variable */ = (data->localData[0]->realVars[808] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[1] variable */ + data->localData[0]->realVars[809] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[2] variable */ + data->localData[0]->realVars[810] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[3] variable */ + data->localData[0]->realVars[811] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[4] variable */ + data->localData[0]->realVars[812] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[5] variable */ + data->localData[0]->realVars[813] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[6] variable */ + data->localData[0]->realVars[814] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[7] variable */ + data->localData[0]->realVars[815] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[8] variable */ + data->localData[0]->realVars[816] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[9] variable */ + data->localData[0]->realVars[817] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[10] variable */ + data->localData[0]->realVars[818] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[11] variable */ + data->localData[0]->realVars[819] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[12] variable */ + data->localData[0]->realVars[820] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[13] variable */ + data->localData[0]->realVars[821] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[14] variable */ + data->localData[0]->realVars[822] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[15] variable */ + data->localData[0]->realVars[823] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[16] variable */ + data->localData[0]->realVars[824] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[17] variable */ + data->localData[0]->realVars[825] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[18] variable */ + data->localData[0]->realVars[826] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[19] variable */ + data->localData[0]->realVars[827] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[20] variable */) * ((data->localData[0]->realVars[620] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[530] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4127
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb = (particleReceiver1DCalculator.particleReceiver1D_v11.g_w[1] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[2] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[3] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[4] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[5] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[6] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[7] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[8] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[9] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[10] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[11] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[12] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[13] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[14] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[15] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[16] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[17] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[18] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[19] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_eqFunction_4127(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4127};
  data->localData[0]->realVars[577] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb variable */ = (data->localData[0]->realVars[664] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[1] variable */ + data->localData[0]->realVars[665] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[2] variable */ + data->localData[0]->realVars[666] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[3] variable */ + data->localData[0]->realVars[667] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[4] variable */ + data->localData[0]->realVars[668] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[5] variable */ + data->localData[0]->realVars[669] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[6] variable */ + data->localData[0]->realVars[670] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[7] variable */ + data->localData[0]->realVars[671] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[8] variable */ + data->localData[0]->realVars[672] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[9] variable */ + data->localData[0]->realVars[673] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[10] variable */ + data->localData[0]->realVars[674] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[11] variable */ + data->localData[0]->realVars[675] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[12] variable */ + data->localData[0]->realVars[676] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[13] variable */ + data->localData[0]->realVars[677] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[14] variable */ + data->localData[0]->realVars[678] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[15] variable */ + data->localData[0]->realVars[679] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[16] variable */ + data->localData[0]->realVars[680] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[17] variable */ + data->localData[0]->realVars[681] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[18] variable */ + data->localData[0]->realVars[682] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[19] variable */ + data->localData[0]->realVars[683] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[20] variable */) * ((data->localData[0]->realVars[620] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[530] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4128
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qgain_gcb = (particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_eqFunction_4128(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4128};
  data->localData[0]->realVars[574] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qgain_gcb variable */ = (data->localData[0]->realVars[684] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] variable */ + data->localData[0]->realVars[685] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] variable */ + data->localData[0]->realVars[686] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] variable */ + data->localData[0]->realVars[687] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] variable */ + data->localData[0]->realVars[688] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] variable */ + data->localData[0]->realVars[689] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] variable */ + data->localData[0]->realVars[690] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] variable */ + data->localData[0]->realVars[691] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] variable */ + data->localData[0]->realVars[692] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] variable */ + data->localData[0]->realVars[693] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] variable */ + data->localData[0]->realVars[694] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] variable */ + data->localData[0]->realVars[695] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] variable */ + data->localData[0]->realVars[696] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] variable */ + data->localData[0]->realVars[697] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] variable */ + data->localData[0]->realVars[698] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] variable */ + data->localData[0]->realVars[699] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] variable */ + data->localData[0]->realVars[700] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] variable */ + data->localData[0]->realVars[701] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] variable */ + data->localData[0]->realVars[702] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] variable */ + data->localData[0]->realVars[703] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20] variable */) * ((data->localData[0]->realVars[620] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[530] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4129
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf = (particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[1] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[2] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[3] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[4] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[5] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[6] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[7] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[8] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[9] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[10] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[11] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[12] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[13] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[14] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[15] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[16] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[17] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[18] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[19] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_eqFunction_4129(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4129};
  data->localData[0]->realVars[578] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf variable */ = (data->localData[0]->realVars[726] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[1] variable */ + data->localData[0]->realVars[727] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[2] variable */ + data->localData[0]->realVars[728] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[3] variable */ + data->localData[0]->realVars[729] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[4] variable */ + data->localData[0]->realVars[730] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[5] variable */ + data->localData[0]->realVars[731] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[6] variable */ + data->localData[0]->realVars[732] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[7] variable */ + data->localData[0]->realVars[733] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[8] variable */ + data->localData[0]->realVars[734] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[9] variable */ + data->localData[0]->realVars[735] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[10] variable */ + data->localData[0]->realVars[736] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[11] variable */ + data->localData[0]->realVars[737] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[12] variable */ + data->localData[0]->realVars[738] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[13] variable */ + data->localData[0]->realVars[739] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[14] variable */ + data->localData[0]->realVars[740] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[15] variable */ + data->localData[0]->realVars[741] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[16] variable */ + data->localData[0]->realVars[742] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[17] variable */ + data->localData[0]->realVars[743] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[18] variable */ + data->localData[0]->realVars[744] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[19] variable */ + data->localData[0]->realVars[745] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[20] variable */) * ((data->localData[0]->realVars[620] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[530] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4130
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Q_check_curtain = particleReceiver1DCalculator.liftSimple.m_flow_fixed * (particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] - particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21]) + particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc + particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain + (-particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf) - particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb
*/
void PhysicalParticleCO21D_eqFunction_4130(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4130};
  data->localData[0]->realVars[571] /* particleReceiver1DCalculator.particleReceiver1D_v11.Q_check_curtain variable */ = (data->simulationInfo->realParameter[272] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */) * (data->localData[0]->realVars[704] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] variable */ - data->localData[0]->realVars[724] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] variable */) + data->localData[0]->realVars[572] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc variable */ + data->localData[0]->realVars[575] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain variable */ + (-data->localData[0]->realVars[578] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf variable */) - data->localData[0]->realVars[577] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb variable */;
  TRACE_POP
}
/*
equation index: 4131
type: ALGORITHM

  eta_solartoelec := $START.eta_solartoelec;
  eta_pb_net := $START.eta_pb_net;
  eta_pb_gross := $START.eta_pb_gross;
  eta_storage := $START.eta_storage;
  eta_recv_thermal := $START.eta_recv_thermal;
  eta_recv_abs := $START.eta_recv_abs;
  eta_curtail_defocus := $START.eta_curtail_defocus;
  eta_he_av := $START.eta_he_av;
  eta_optical := $START.eta_optical;
  eta_curtail_off := $START.eta_curtail_off;
  if time > 31449600.0 then
    eta_curtail_off := E_helio_incident / E_resource;
    eta_optical := E_helio_raw / (he_av_design * E_helio_incident);
    eta_he_av := he_av_design;
    eta_curtail_defocus := E_helio_net / E_helio_raw;
    eta_recv_abs := E_recv_incident / E_helio_net;
    eta_recv_thermal := E_recv_net / E_recv_incident;
    eta_storage := E_pb_input / E_recv_net;
    eta_pb_gross := E_pb_gross / E_pb_input;
    eta_pb_net := E_pb_net / E_pb_input;
    eta_solartoelec := E_pb_net / E_resource;
  end if;
*/
void PhysicalParticleCO21D_eqFunction_4131(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4131};
  modelica_boolean tmp8;
  data->localData[0]->realVars[82] /* eta_solartoelec variable */ = data->modelData->realVarsData[82].attribute /* eta_solartoelec variable */.start;

  data->localData[0]->realVars[79] /* eta_pb_net variable */ = data->modelData->realVarsData[79].attribute /* eta_pb_net variable */.start;

  data->localData[0]->realVars[78] /* eta_pb_gross variable */ = data->modelData->realVarsData[78].attribute /* eta_pb_gross variable */.start;

  data->localData[0]->realVars[83] /* eta_storage variable */ = data->modelData->realVarsData[83].attribute /* eta_storage variable */.start;

  data->localData[0]->realVars[81] /* eta_recv_thermal variable */ = data->modelData->realVarsData[81].attribute /* eta_recv_thermal variable */.start;

  data->localData[0]->realVars[80] /* eta_recv_abs variable */ = data->modelData->realVarsData[80].attribute /* eta_recv_abs variable */.start;

  data->localData[0]->realVars[74] /* eta_curtail_defocus variable */ = data->modelData->realVarsData[74].attribute /* eta_curtail_defocus variable */.start;

  data->localData[0]->realVars[76] /* eta_he_av variable */ = data->modelData->realVarsData[76].attribute /* eta_he_av variable */.start;

  data->localData[0]->realVars[77] /* eta_optical variable */ = data->modelData->realVarsData[77].attribute /* eta_optical variable */.start;

  data->localData[0]->realVars[75] /* eta_curtail_off variable */ = data->modelData->realVarsData[75].attribute /* eta_curtail_off variable */.start;

  RELATIONHYSTERESIS(tmp8, data->localData[0]->timeValue, 31449600.0, 10, Greater);
  if(tmp8)
  {
    data->localData[0]->realVars[75] /* eta_curtail_off variable */ = DIVISION_SIM(data->localData[0]->realVars[1] /* E_helio_incident STATE(1) */,data->localData[0]->realVars[9] /* E_resource STATE(1) */,"E_resource",equationIndexes);

    data->localData[0]->realVars[77] /* eta_optical variable */ = DIVISION_SIM(data->localData[0]->realVars[3] /* E_helio_raw STATE(1,heliostatsField.Q_raw) */,(data->simulationInfo->realParameter[142] /* he_av_design PARAM */) * (data->localData[0]->realVars[1] /* E_helio_incident STATE(1) */),"he_av_design * E_helio_incident",equationIndexes);

    data->localData[0]->realVars[76] /* eta_he_av variable */ = data->simulationInfo->realParameter[142] /* he_av_design PARAM */;

    data->localData[0]->realVars[74] /* eta_curtail_defocus variable */ = DIVISION_SIM(data->localData[0]->realVars[2] /* E_helio_net STATE(1,heliostatsField.Q_incident) */,data->localData[0]->realVars[3] /* E_helio_raw STATE(1,heliostatsField.Q_raw) */,"E_helio_raw",equationIndexes);

    data->localData[0]->realVars[80] /* eta_recv_abs variable */ = DIVISION_SIM(data->localData[0]->realVars[7] /* E_recv_incident STATE(1,heliostatsField.Q_incident) */,data->localData[0]->realVars[2] /* E_helio_net STATE(1,heliostatsField.Q_incident) */,"E_helio_net",equationIndexes);

    data->localData[0]->realVars[81] /* eta_recv_thermal variable */ = DIVISION_SIM(data->localData[0]->realVars[8] /* E_recv_net STATE(1,particleReceiver1D.Qdot_rec) */,data->localData[0]->realVars[7] /* E_recv_incident STATE(1,heliostatsField.Q_incident) */,"E_recv_incident",equationIndexes);

    data->localData[0]->realVars[83] /* eta_storage variable */ = DIVISION_SIM(data->localData[0]->realVars[5] /* E_pb_input STATE(1) */,data->localData[0]->realVars[8] /* E_recv_net STATE(1,particleReceiver1D.Qdot_rec) */,"E_recv_net",equationIndexes);

    data->localData[0]->realVars[78] /* eta_pb_gross variable */ = DIVISION_SIM(data->localData[0]->realVars[4] /* E_pb_gross STATE(1) */,data->localData[0]->realVars[5] /* E_pb_input STATE(1) */,"E_pb_input",equationIndexes);

    data->localData[0]->realVars[79] /* eta_pb_net variable */ = DIVISION_SIM(data->localData[0]->realVars[6] /* E_pb_net STATE(1,P_elec) */,data->localData[0]->realVars[5] /* E_pb_input STATE(1) */,"E_pb_input",equationIndexes);

    data->localData[0]->realVars[82] /* eta_solartoelec variable */ = DIVISION_SIM(data->localData[0]->realVars[6] /* E_pb_net STATE(1,P_elec) */,data->localData[0]->realVars[9] /* E_resource STATE(1) */,"E_resource",equationIndexes);
  }
  TRACE_POP
}
/*
equation index: 4132
type: SIMPLE_ASSIGN
tankCold.V = 0.0005 * tankCold.m
*/
void PhysicalParticleCO21D_eqFunction_4132(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4132};
  data->localData[0]->realVars[1130] /* tankCold.V variable */ = (0.0005) * (data->localData[0]->realVars[13] /* tankCold.m STATE(1) */);
  TRACE_POP
}
/*
equation index: 4133
type: SIMPLE_ASSIGN
simpleReceiverControl.defocusLogic.level_ref = 100.0 * tankCold.V / tankCold.V_t
*/
void PhysicalParticleCO21D_eqFunction_4133(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4133};
  data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */ = (100.0) * (DIVISION_SIM(data->localData[0]->realVars[1130] /* tankCold.V variable */,data->simulationInfo->realParameter[803] /* tankCold.V_t PARAM */,"tankCold.V_t",equationIndexes));
  TRACE_POP
}
/*
equation index: 4134
type: SIMPLE_ASSIGN
$whenCondition16 = simpleReceiverControl.defocusLogic.level_ref > simpleReceiverControl.defocusLogic.level_max
*/
void PhysicalParticleCO21D_eqFunction_4134(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4134};
  modelica_boolean tmp9;
  RELATIONHYSTERESIS(tmp9, data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[771] /* simpleReceiverControl.defocusLogic.level_max PARAM */, 6, Greater);
  data->localData[0]->booleanVars[7] /* $whenCondition16 DISCRETE */ = tmp9;
  TRACE_POP
}
/*
equation index: 4135
type: SIMPLE_ASSIGN
$whenCondition15 = simpleReceiverControl.defocusLogic.level_ref < simpleReceiverControl.defocusLogic.level_min
*/
void PhysicalParticleCO21D_eqFunction_4135(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4135};
  modelica_boolean tmp10;
  RELATIONHYSTERESIS(tmp10, data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_min PARAM */, 7, Less);
  data->localData[0]->booleanVars[6] /* $whenCondition15 DISCRETE */ = tmp10;
  TRACE_POP
}
/*
equation index: 4136
type: WHEN

when {$whenCondition16} then
  simpleReceiverControl.defocusLogic.y = true;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4136(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4136};
  if((data->localData[0]->booleanVars[7] /* $whenCondition16 DISCRETE */ && !data->simulationInfo->booleanVarsPre[7] /* $whenCondition16 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[27] /* simpleReceiverControl.defocusLogic.y DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[6] /* $whenCondition15 DISCRETE */ && !data->simulationInfo->booleanVarsPre[6] /* $whenCondition15 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[27] /* simpleReceiverControl.defocusLogic.y DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4138
type: SIMPLE_ASSIGN
$whenCondition14 = simpleReceiverControl.defocusLogic.level_ref > simpleReceiverControl.hotTank.level_max
*/
void PhysicalParticleCO21D_eqFunction_4138(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4138};
  modelica_boolean tmp11;
  RELATIONHYSTERESIS(tmp11, data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[774] /* simpleReceiverControl.hotTank.level_max PARAM */, 8, Greater);
  data->localData[0]->booleanVars[5] /* $whenCondition14 DISCRETE */ = tmp11;
  TRACE_POP
}
/*
equation index: 4139
type: SIMPLE_ASSIGN
$whenCondition13 = simpleReceiverControl.defocusLogic.level_ref < simpleReceiverControl.hotTank.level_min
*/
void PhysicalParticleCO21D_eqFunction_4139(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4139};
  modelica_boolean tmp12;
  RELATIONHYSTERESIS(tmp12, data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_min PARAM */, 9, Less);
  data->localData[0]->booleanVars[4] /* $whenCondition13 DISCRETE */ = tmp12;
  TRACE_POP
}
/*
equation index: 4140
type: WHEN

when {$whenCondition14} then
  simpleReceiverControl.hotTank.y = true;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4140(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4140};
  if((data->localData[0]->booleanVars[5] /* $whenCondition14 DISCRETE */ && !data->simulationInfo->booleanVarsPre[5] /* $whenCondition14 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[28] /* simpleReceiverControl.hotTank.y DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[4] /* $whenCondition13 DISCRETE */ && !data->simulationInfo->booleanVarsPre[4] /* $whenCondition13 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[28] /* simpleReceiverControl.hotTank.y DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4142
type: SIMPLE_ASSIGN
tankCold.A = 0.03141592653589793 * tankCold.D * tankCold.H * simpleReceiverControl.defocusLogic.level_ref
*/
void PhysicalParticleCO21D_eqFunction_4142(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4142};
  data->localData[0]->realVars[1128] /* tankCold.A variable */ = (0.03141592653589793) * ((data->simulationInfo->realParameter[798] /* tankCold.D PARAM */) * ((data->simulationInfo->realParameter[799] /* tankCold.H PARAM */) * (data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */)));
  TRACE_POP
}
/*
equation index: 4143
type: SIMPLE_ASSIGN
simpleReceiverControl.hotTank.level_ref = simpleReceiverControl.defocusLogic.level_ref
*/
void PhysicalParticleCO21D_eqFunction_4143(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4143};
  data->localData[0]->realVars[1120] /* simpleReceiverControl.hotTank.level_ref variable */ = data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */;
  TRACE_POP
}
/*
equation index: 4144
type: SIMPLE_ASSIGN
tankHot.V = 0.0005 * tankHot.m
*/
void PhysicalParticleCO21D_eqFunction_4144(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4144};
  data->localData[0]->realVars[1149] /* tankHot.V variable */ = (0.0005) * (data->localData[0]->realVars[15] /* tankHot.m STATE(1) */);
  TRACE_POP
}
/*
equation index: 4145
type: SIMPLE_ASSIGN
controlHot.defocus_logic.level_ref = 100.0 * tankHot.V / tankHot.V_t
*/
void PhysicalParticleCO21D_eqFunction_4145(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4145};
  data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */ = (100.0) * (DIVISION_SIM(data->localData[0]->realVars[1149] /* tankHot.V variable */,data->simulationInfo->realParameter[813] /* tankHot.V_t PARAM */,"tankHot.V_t",equationIndexes));
  TRACE_POP
}
/*
equation index: 4146
type: SIMPLE_ASSIGN
$whenCondition6 = controlHot.defocus_logic.level_ref > controlHot.defocus_logic.level_max
*/
void PhysicalParticleCO21D_eqFunction_4146(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4146};
  modelica_boolean tmp13;
  RELATIONHYSTERESIS(tmp13, data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */, 2, Greater);
  data->localData[0]->booleanVars[12] /* $whenCondition6 DISCRETE */ = tmp13;
  TRACE_POP
}
/*
equation index: 4147
type: SIMPLE_ASSIGN
$whenCondition5 = controlHot.defocus_logic.level_ref < controlHot.defocus_logic.level_min
*/
void PhysicalParticleCO21D_eqFunction_4147(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4147};
  modelica_boolean tmp14;
  RELATIONHYSTERESIS(tmp14, data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */, 3, Less);
  data->localData[0]->booleanVars[11] /* $whenCondition5 DISCRETE */ = tmp14;
  TRACE_POP
}
/*
equation index: 4148
type: WHEN

when {$whenCondition6} then
  controlHot.defocus_logic.y = true;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4148(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4148};
  if((data->localData[0]->booleanVars[12] /* $whenCondition6 DISCRETE */ && !data->simulationInfo->booleanVarsPre[12] /* $whenCondition6 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[16] /* controlHot.defocus_logic.y DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[11] /* $whenCondition5 DISCRETE */ && !data->simulationInfo->booleanVarsPre[11] /* $whenCondition5 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[16] /* controlHot.defocus_logic.y DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4150
type: SIMPLE_ASSIGN
heliostatsField.defocus = controlHot.defocus_logic.y or not simpleReceiverControl.defocusLogic.y
*/
void PhysicalParticleCO21D_eqFunction_4150(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4150};
  data->localData[0]->booleanVars[21] /* heliostatsField.defocus DISCRETE */ = (data->localData[0]->booleanVars[16] /* controlHot.defocus_logic.y DISCRETE */ || (!data->localData[0]->booleanVars[27] /* simpleReceiverControl.defocusLogic.y DISCRETE */));
  TRACE_POP
}
/*
equation index: 4151
type: SIMPLE_ASSIGN
$whenCondition8 = controlHot.defocus_logic.level_ref > controlHot.logic.level_on
*/
void PhysicalParticleCO21D_eqFunction_4151(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4151};
  modelica_boolean tmp15;
  RELATIONHYSTERESIS(tmp15, data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */, 4, Greater);
  data->localData[0]->booleanVars[14] /* $whenCondition8 DISCRETE */ = tmp15;
  TRACE_POP
}
/*
equation index: 4152
type: SIMPLE_ASSIGN
$whenCondition7 = controlHot.defocus_logic.level_ref < controlHot.logic.level_off
*/
void PhysicalParticleCO21D_eqFunction_4152(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4152};
  modelica_boolean tmp16;
  RELATIONHYSTERESIS(tmp16, data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */, 5, Less);
  data->localData[0]->booleanVars[13] /* $whenCondition7 DISCRETE */ = tmp16;
  TRACE_POP
}
/*
equation index: 4153
type: WHEN

when {$whenCondition8} then
  controlHot.logic.on_discharge = true;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4153(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4153};
  if((data->localData[0]->booleanVars[14] /* $whenCondition8 DISCRETE */ && !data->simulationInfo->booleanVarsPre[14] /* $whenCondition8 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[13] /* $whenCondition7 DISCRETE */ && !data->simulationInfo->booleanVarsPre[13] /* $whenCondition7 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4155
type: SIMPLE_ASSIGN
tankHot.A = 0.03141592653589793 * tankHot.D * tankHot.H * controlHot.defocus_logic.level_ref
*/
void PhysicalParticleCO21D_eqFunction_4155(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4155};
  data->localData[0]->realVars[1146] /* tankHot.A variable */ = (0.03141592653589793) * ((data->simulationInfo->realParameter[808] /* tankHot.D PARAM */) * ((data->simulationInfo->realParameter[809] /* tankHot.H PARAM */) * (data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */)));
  TRACE_POP
}
/*
equation index: 4156
type: SIMPLE_ASSIGN
controlHot.logic.level = controlHot.defocus_logic.level_ref
*/
void PhysicalParticleCO21D_eqFunction_4156(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4156};
  data->localData[0]->realVars[59] /* controlHot.logic.level variable */ = data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */;
  TRACE_POP
}
/*
equation index: 4157
type: SIMPLE_ASSIGN
data.table.timeScaled = time
*/
void PhysicalParticleCO21D_eqFunction_4157(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4157};
  data->localData[0]->realVars[68] /* data.table.timeScaled variable */ = data->localData[0]->timeValue;
  TRACE_POP
}
/*
equation index: 4158
type: SIMPLE_ASSIGN
$whenCondition1 = time >= pre(data.table.nextTimeEvent)
*/
void PhysicalParticleCO21D_eqFunction_4158(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4158};
  modelica_boolean tmp17;
  RELATIONHYSTERESIS(tmp17, data->localData[0]->timeValue, data->simulationInfo->realVarsPre[1168] /* data.table.nextTimeEvent DISCRETE */, 1, GreaterEq);
  data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ = tmp17;
  TRACE_POP
}
/*
equation index: 4159
type: WHEN

when {$whenCondition1} then
  data.table.nextTimeEventScaled = Modelica.Blocks.Sources.CombiTimeTable$data$table.getNextTimeEvent(data.table.tableID, data.table.timeScaled, data.table.tableOnFileRead);
end when;
*/
void PhysicalParticleCO21D_eqFunction_4159(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4159};
  if((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ && !data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getNextTimeEvent(threadData, data->simulationInfo->extObjs[0], data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  }
  TRACE_POP
}
/*
equation index: 4160
type: SIMPLE_ASSIGN
$cse13 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 1, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4160(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4160};
  data->localData[0]->realVars[44] /* $cse13 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 1), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4161
type: SIMPLE_ASSIGN
data.GHI = data.table.p_offset[1] + $cse13
*/
void PhysicalParticleCO21D_eqFunction_4161(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4161};
  data->localData[0]->realVars[64] /* data.GHI variable */ = data->simulationInfo->realParameter[102] /* data.table.p_offset[1] PARAM */ + data->localData[0]->realVars[44] /* $cse13 variable */;
  TRACE_POP
}
/*
equation index: 4162
type: SIMPLE_ASSIGN
$cse12 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 2, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4162(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4162};
  data->localData[0]->realVars[43] /* $cse12 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 2), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4163
type: SIMPLE_ASSIGN
data.table.y[2] = data.table.p_offset[2] + $cse12
*/
void PhysicalParticleCO21D_eqFunction_4163(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4163};
  data->localData[0]->realVars[69] /* data.table.y[2] variable */ = data->simulationInfo->realParameter[103] /* data.table.p_offset[2] PARAM */ + data->localData[0]->realVars[43] /* $cse12 variable */;
  TRACE_POP
}
/*
equation index: 4164
type: SIMPLE_ASSIGN
sun.dni = max(data.table.y[2], 0.0)
*/
void PhysicalParticleCO21D_eqFunction_4164(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4164};
  data->localData[0]->realVars[1126] /* sun.dni variable */ = fmax(data->localData[0]->realVars[69] /* data.table.y[2] variable */,0.0);
  TRACE_POP
}
/*
equation index: 4165
type: SIMPLE_ASSIGN
$cse1 = max(sun.dni * A_field, 0.0)
*/
void PhysicalParticleCO21D_eqFunction_4165(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4165};
  data->localData[0]->realVars[40] /* $cse1 variable */ = fmax((data->localData[0]->realVars[1126] /* sun.dni variable */) * (data->simulationInfo->realParameter[0] /* A_field PARAM */),0.0);
  TRACE_POP
}
/*
equation index: 4166
type: SIMPLE_ASSIGN
$DER.E_resource = $cse1
*/
void PhysicalParticleCO21D_eqFunction_4166(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4166};
  data->localData[0]->realVars[26] /* der(E_resource) STATE_DER */ = data->localData[0]->realVars[40] /* $cse1 variable */;
  TRACE_POP
}
/*
equation index: 4167
type: SIMPLE_ASSIGN
$cse11 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 3, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4167(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4167};
  data->localData[0]->realVars[42] /* $cse11 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 3), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4168
type: SIMPLE_ASSIGN
data.DHI = data.table.p_offset[3] + $cse11
*/
void PhysicalParticleCO21D_eqFunction_4168(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4168};
  data->localData[0]->realVars[63] /* data.DHI variable */ = data->simulationInfo->realParameter[104] /* data.table.p_offset[3] PARAM */ + data->localData[0]->realVars[42] /* $cse11 variable */;
  TRACE_POP
}
/*
equation index: 4169
type: SIMPLE_ASSIGN
$cse10 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 4, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4169(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4169};
  data->localData[0]->realVars[41] /* $cse10 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 4), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4170
type: SIMPLE_ASSIGN
data.table.y[4] = data.table.p_offset[4] + $cse10
*/
void PhysicalParticleCO21D_eqFunction_4170(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4170};
  data->localData[0]->realVars[70] /* data.table.y[4] variable */ = data->simulationInfo->realParameter[105] /* data.table.p_offset[4] PARAM */ + data->localData[0]->realVars[41] /* $cse10 variable */;
  TRACE_POP
}
/*
equation index: 4171
type: SIMPLE_ASSIGN
particleReceiver1D.Tamb = 273.15 + data.table.y[4]
*/
void PhysicalParticleCO21D_eqFunction_4171(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4171};
  data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */ = 273.15 + data->localData[0]->realVars[70] /* data.table.y[4] variable */;
  TRACE_POP
}
/*
equation index: 4172
type: SIMPLE_ASSIGN
$cse2 = max(3.0 + particleReceiver1D.Tamb, powerBlock.cooler.T_low)
*/
void PhysicalParticleCO21D_eqFunction_4172(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4172};
  data->localData[0]->realVars[45] /* $cse2 variable */ = fmax(3.0 + data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */,data->simulationInfo->realParameter[556] /* powerBlock.cooler.T_low PARAM */);
  TRACE_POP
}
/*
equation index: 4173
type: SIMPLE_ASSIGN
$cse9 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 5, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4173(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4173};
  data->localData[0]->realVars[52] /* $cse9 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 5), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4174
type: SIMPLE_ASSIGN
data.table.y[5] = data.table.p_offset[5] + $cse9
*/
void PhysicalParticleCO21D_eqFunction_4174(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4174};
  data->localData[0]->realVars[71] /* data.table.y[5] variable */ = data->simulationInfo->realParameter[106] /* data.table.p_offset[5] PARAM */ + data->localData[0]->realVars[52] /* $cse9 variable */;
  TRACE_POP
}
/*
equation index: 4175
type: SIMPLE_ASSIGN
data.Tdew = 273.15 + data.table.y[5]
*/
void PhysicalParticleCO21D_eqFunction_4175(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4175};
  data->localData[0]->realVars[66] /* data.Tdew variable */ = 273.15 + data->localData[0]->realVars[71] /* data.table.y[5] variable */;
  TRACE_POP
}
/*
equation index: 4176
type: SIMPLE_ASSIGN
$cse8 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 6, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4176(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4176};
  data->localData[0]->realVars[51] /* $cse8 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 6), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4177
type: SIMPLE_ASSIGN
data.RH = data.table.p_offset[6] + $cse8
*/
void PhysicalParticleCO21D_eqFunction_4177(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4177};
  data->localData[0]->realVars[65] /* data.RH variable */ = data->simulationInfo->realParameter[107] /* data.table.p_offset[6] PARAM */ + data->localData[0]->realVars[51] /* $cse8 variable */;
  TRACE_POP
}
/*
equation index: 4178
type: SIMPLE_ASSIGN
$cse7 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 7, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4178(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4178};
  data->localData[0]->realVars[50] /* $cse7 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 7), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4179
type: SIMPLE_ASSIGN
data.table.y[7] = data.table.p_offset[7] + $cse7
*/
void PhysicalParticleCO21D_eqFunction_4179(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4179};
  data->localData[0]->realVars[72] /* data.table.y[7] variable */ = data->simulationInfo->realParameter[108] /* data.table.p_offset[7] PARAM */ + data->localData[0]->realVars[50] /* $cse7 variable */;
  TRACE_POP
}
/*
equation index: 4180
type: SIMPLE_ASSIGN
tankHot.p_top = 100.0 * data.table.y[7]
*/
void PhysicalParticleCO21D_eqFunction_4180(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4180};
  data->localData[0]->realVars[1164] /* tankHot.p_top variable */ = (100.0) * (data->localData[0]->realVars[72] /* data.table.y[7] variable */);
  TRACE_POP
}
/*
equation index: 4181
type: SIMPLE_ASSIGN
powerBlock.exchanger.state_HTF[2].p = LiftCold.dp_fixed + tankHot.p_top
*/
void PhysicalParticleCO21D_eqFunction_4181(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4181};
  data->localData[0]->realVars[1086] /* powerBlock.exchanger.state_HTF[2].p variable */ = data->simulationInfo->realParameter[37] /* LiftCold.dp_fixed PARAM */ + data->localData[0]->realVars[1164] /* tankHot.p_top variable */;
  TRACE_POP
}
/*
equation index: 4182
type: SIMPLE_ASSIGN
tankCold.medium.u = tankCold.medium.h + (-0.0005) * tankHot.p_top
*/
void PhysicalParticleCO21D_eqFunction_4182(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4182};
  data->localData[0]->realVars[1144] /* tankCold.medium.u variable */ = data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */ + (-0.0005) * (data->localData[0]->realVars[1164] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4183
type: SIMPLE_ASSIGN
tankCold.medium.p_bar = 1e-05 * tankHot.p_top
*/
void PhysicalParticleCO21D_eqFunction_4183(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4183};
  data->localData[0]->realVars[1143] /* tankCold.medium.p_bar variable */ = (1e-05) * (data->localData[0]->realVars[1164] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4184
type: SIMPLE_ASSIGN
tankHot.medium.u = tankHot.medium.h + (-0.0005) * tankHot.p_top
*/
void PhysicalParticleCO21D_eqFunction_4184(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4184};
  data->localData[0]->realVars[1163] /* tankHot.medium.u variable */ = data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */ + (-0.0005) * (data->localData[0]->realVars[1164] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4185
type: SIMPLE_ASSIGN
tankHot.medium.p_bar = 1e-05 * tankHot.p_top
*/
void PhysicalParticleCO21D_eqFunction_4185(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4185};
  data->localData[0]->realVars[1162] /* tankHot.medium.p_bar variable */ = (1e-05) * (data->localData[0]->realVars[1164] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4186
type: SIMPLE_ASSIGN
$cse6 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 8, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4186(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4186};
  data->localData[0]->realVars[49] /* $cse6 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 8), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4187
type: SIMPLE_ASSIGN
Wspd_input.y = data.table.p_offset[8] + $cse6
*/
void PhysicalParticleCO21D_eqFunction_4187(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4187};
  data->localData[0]->realVars[57] /* Wspd_input.y variable */ = data->simulationInfo->realParameter[109] /* data.table.p_offset[8] PARAM */ + data->localData[0]->realVars[49] /* $cse6 variable */;
  TRACE_POP
}
/*
equation index: 4188
type: SIMPLE_ASSIGN
$cse5 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 9, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4188(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4188};
  data->localData[0]->realVars[48] /* $cse5 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 9), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4189
type: SIMPLE_ASSIGN
data.table.y[9] = data.table.p_offset[9] + $cse5
*/
void PhysicalParticleCO21D_eqFunction_4189(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4189};
  data->localData[0]->realVars[73] /* data.table.y[9] variable */ = data->simulationInfo->realParameter[110] /* data.table.p_offset[9] PARAM */ + data->localData[0]->realVars[48] /* $cse5 variable */;
  TRACE_POP
}
/*
equation index: 4190
type: SIMPLE_ASSIGN
data.Wdir = 0.0174532925199433 * data.table.y[9]
*/
void PhysicalParticleCO21D_eqFunction_4190(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4190};
  data->localData[0]->realVars[67] /* data.Wdir variable */ = (0.0174532925199433) * (data->localData[0]->realVars[73] /* data.table.y[9] variable */);
  TRACE_POP
}
/*
equation index: 4191
type: SIMPLE_ASSIGN
$cse4 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 10, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4191(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4191};
  data->localData[0]->realVars[47] /* $cse4 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 10), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1169] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4192
type: SIMPLE_ASSIGN
data.Albedo = data.table.p_offset[10] + $cse4
*/
void PhysicalParticleCO21D_eqFunction_4192(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4192};
  data->localData[0]->realVars[62] /* data.Albedo variable */ = data->simulationInfo->realParameter[111] /* data.table.p_offset[10] PARAM */ + data->localData[0]->realVars[47] /* $cse4 variable */;
  TRACE_POP
}
/*
equation index: 4193
type: WHEN

when {$whenCondition1} then
  data.table.nextTimeEvent = if data.table.nextTimeEventScaled < 1.797693134862316e+308 then data.table.nextTimeEventScaled else 1.797693134862316e+308;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4193(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4193};
  modelica_boolean tmp18;
  if((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ && !data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */ /* edge */))
  {
    tmp18 = Less(data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */,1.797693134862316e+308);
    data->localData[0]->realVars[1168] /* data.table.nextTimeEvent DISCRETE */ = (tmp18?data->localData[0]->realVars[1169] /* data.table.nextTimeEventScaled DISCRETE */:1.797693134862316e+308);
  }
  TRACE_POP
}
/*
equation index: 4194
type: ALGORITHM

  (sun.dec, sun.hra) := SolarTherm.Models.Sources.SolarModel.Sun$sun.solarPosition(time, sun.lon, sun.lat, sun.t_zone, sun.year);
*/
void PhysicalParticleCO21D_eqFunction_4194(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4194};
  data->localData[0]->realVars[1125] /* sun.dec variable */ = omc_SolarTherm_Models_Sources_SolarModel_D_Sun24sun_solarPosition(threadData, data->localData[0]->timeValue, data->simulationInfo->realParameter[794] /* sun.lon PARAM */, data->simulationInfo->realParameter[793] /* sun.lat PARAM */, data->simulationInfo->realParameter[795] /* sun.t_zone PARAM */, data->simulationInfo->integerParameter[160] /* sun.year PARAM */ ,&data->localData[0]->realVars[1127] /* sun.hra variable */);
  TRACE_POP
}
/*
equation index: 4195
type: SIMPLE_ASSIGN
heliostatsField.optical.angle2_input.y = 57.29577951308232 * sun.hra
*/
void PhysicalParticleCO21D_eqFunction_4195(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4195};
  data->localData[0]->realVars[95] /* heliostatsField.optical.angle2_input.y variable */ = (57.29577951308232) * (data->localData[0]->realVars[1127] /* sun.hra variable */);
  TRACE_POP
}
/*
equation index: 4196
type: SIMPLE_ASSIGN
heliostatsField.elo = SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(sun.dec)
*/
void PhysicalParticleCO21D_eqFunction_4196(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4196};
  data->localData[0]->realVars[93] /* heliostatsField.elo variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_eclipticLongitude(threadData, data->localData[0]->realVars[1125] /* sun.dec variable */);
  TRACE_POP
}
/*
equation index: 4197
type: SIMPLE_ASSIGN
heliostatsField.ele = SolarTherm.Models.Sources.SolarFunctions.elevationAngle(sun.dec, sun.hra, heliostatsField.lat)
*/
void PhysicalParticleCO21D_eqFunction_4197(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4197};
  data->localData[0]->realVars[92] /* heliostatsField.ele variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_elevationAngle(threadData, data->localData[0]->realVars[1125] /* sun.dec variable */, data->localData[0]->realVars[1127] /* sun.hra variable */, data->simulationInfo->realParameter[153] /* heliostatsField.lat PARAM */);
  TRACE_POP
}
/*
equation index: 4198
type: SIMPLE_ASSIGN
$whenCondition4 = heliostatsField.ele > 0.01
*/
void PhysicalParticleCO21D_eqFunction_4198(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4198};
  modelica_boolean tmp19;
  RELATIONHYSTERESIS(tmp19, data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, 0, Greater);
  data->localData[0]->booleanVars[10] /* $whenCondition4 DISCRETE */ = tmp19;
  TRACE_POP
}
/*
equation index: 4199
type: WHEN

when {$whenCondition4} then
  heliostatsField.t_on = time;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4199(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4199};
  if((data->localData[0]->booleanVars[10] /* $whenCondition4 DISCRETE */ && !data->simulationInfo->booleanVarsPre[10] /* $whenCondition4 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1170] /* heliostatsField.t_on DISCRETE */ = data->localData[0]->timeValue;
  }
  TRACE_POP
}
/*
equation index: 4200
type: SIMPLE_ASSIGN
heliostatsField.zen = 1.570796326794897 - heliostatsField.ele
*/
void PhysicalParticleCO21D_eqFunction_4200(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4200};
  data->localData[0]->realVars[98] /* heliostatsField.zen variable */ = 1.570796326794897 - data->localData[0]->realVars[92] /* heliostatsField.ele variable */;
  TRACE_POP
}
/*
equation index: 4201
type: SIMPLE_ASSIGN
heliostatsField.on_hf = heliostatsField.ele > heliostatsField.ele_min and Wspd_input.y < heliostatsField.Wspd_max
*/
void PhysicalParticleCO21D_eqFunction_4201(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4201};
  modelica_boolean tmp20;
  modelica_boolean tmp21;
  RELATIONHYSTERESIS(tmp20, data->localData[0]->realVars[92] /* heliostatsField.ele variable */, data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */, 13, Greater);
  RELATIONHYSTERESIS(tmp21, data->localData[0]->realVars[57] /* Wspd_input.y variable */, data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */, 14, Less);
  data->localData[0]->booleanVars[22] /* heliostatsField.on_hf DISCRETE */ = (tmp20 && tmp21);
  TRACE_POP
}
/*
equation index: 4202
type: SIMPLE_ASSIGN
heliostatsField.zen2 = SolarTherm.Models.Sources.SolarFunctions.aparentSolarZenith(sun.dec, sun.hra, heliostatsField.lat)
*/
void PhysicalParticleCO21D_eqFunction_4202(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4202};
  data->localData[0]->realVars[99] /* heliostatsField.zen2 variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_aparentSolarZenith(threadData, data->localData[0]->realVars[1125] /* sun.dec variable */, data->localData[0]->realVars[1127] /* sun.hra variable */, data->simulationInfo->realParameter[153] /* heliostatsField.lat PARAM */);
  TRACE_POP
}
/*
equation index: 4203
type: SIMPLE_ASSIGN
heliostatsField.azi = SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(sun.dec, sun.hra, heliostatsField.lat)
*/
void PhysicalParticleCO21D_eqFunction_4203(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4203};
  data->localData[0]->realVars[90] /* heliostatsField.azi variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_solarAzimuth(threadData, data->localData[0]->realVars[1125] /* sun.dec variable */, data->localData[0]->realVars[1127] /* sun.hra variable */, data->simulationInfo->realParameter[153] /* heliostatsField.lat PARAM */);
  TRACE_POP
}
/*
equation index: 4204
type: SIMPLE_ASSIGN
heliostatsField.optical.angle1_input.y = 57.29577951308232 * sun.dec
*/
void PhysicalParticleCO21D_eqFunction_4204(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4204};
  data->localData[0]->realVars[94] /* heliostatsField.optical.angle1_input.y variable */ = (57.29577951308232) * (data->localData[0]->realVars[1125] /* sun.dec variable */);
  TRACE_POP
}
/*
equation index: 4205
type: SIMPLE_ASSIGN
heliostatsField.optical.nu_table.y = Modelica.Blocks.Tables.CombiTable2D$heliostatsField$optical$nu_table.getTableValue(heliostatsField.optical.nu_table.tableID, heliostatsField.optical.angle1_input.y, heliostatsField.optical.angle2_input.y, heliostatsField.optical.nu_table.tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4205(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4205};
  data->localData[0]->realVars[97] /* heliostatsField.optical.nu_table.y variable */ = omc_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_getTableValue(threadData, data->simulationInfo->extObjs[1], data->localData[0]->realVars[94] /* heliostatsField.optical.angle1_input.y variable */, data->localData[0]->realVars[95] /* heliostatsField.optical.angle2_input.y variable */, data->simulationInfo->realParameter[160] /* heliostatsField.optical.nu_table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4206
type: SIMPLE_ASSIGN
heliostatsField.optical.nu = max(0.0, heliostatsField.optical.nu_table.y)
*/
void PhysicalParticleCO21D_eqFunction_4206(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4206};
  data->localData[0]->realVars[96] /* heliostatsField.optical.nu variable */ = fmax(0.0,data->localData[0]->realVars[97] /* heliostatsField.optical.nu_table.y variable */);
  TRACE_POP
}
/*
equation index: 4207
type: SIMPLE_ASSIGN
heliostatsField.Q_raw = if heliostatsField.on_hf then max(heliostatsField.he_av * heliostatsField.n_h * heliostatsField.A_h * sun.dni * heliostatsField.optical.nu, 0.0) else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4207(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4207};
  data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */ = (data->localData[0]->booleanVars[22] /* heliostatsField.on_hf DISCRETE */?fmax((data->simulationInfo->realParameter[152] /* heliostatsField.he_av PARAM */) * ((data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[143] /* heliostatsField.A_h PARAM */) * ((data->localData[0]->realVars[1126] /* sun.dni variable */) * (data->localData[0]->realVars[96] /* heliostatsField.optical.nu variable */)))),0.0):0.0);
  TRACE_POP
}
/*
equation index: 4208
type: SIMPLE_ASSIGN
$DER.E_helio_raw = heliostatsField.Q_raw
*/
void PhysicalParticleCO21D_eqFunction_4208(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4208};
  data->localData[0]->realVars[20] /* der(E_helio_raw) STATE_DER */ = data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */;
  TRACE_POP
}
/*
equation index: 4209
type: SIMPLE_ASSIGN
$whenCondition3 = heliostatsField.Q_raw > heliostatsField.Q_start
*/
void PhysicalParticleCO21D_eqFunction_4209(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4209};
  modelica_boolean tmp22;
  RELATIONHYSTERESIS(tmp22, data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */, 15, Greater);
  data->localData[0]->booleanVars[9] /* $whenCondition3 DISCRETE */ = tmp22;
  TRACE_POP
}
/*
equation index: 4210
type: SIMPLE_ASSIGN
$whenCondition2 = heliostatsField.Q_raw < heliostatsField.Q_min
*/
void PhysicalParticleCO21D_eqFunction_4210(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4210};
  modelica_boolean tmp23;
  RELATIONHYSTERESIS(tmp23, data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */, 16, Less);
  data->localData[0]->booleanVars[8] /* $whenCondition2 DISCRETE */ = tmp23;
  TRACE_POP
}
/*
equation index: 4211
type: WHEN

when {$whenCondition3} then
  heliostatsField.on_internal = true;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4211(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4211};
  if((data->localData[0]->booleanVars[9] /* $whenCondition3 DISCRETE */ && !data->simulationInfo->booleanVarsPre[9] /* $whenCondition3 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[8] /* $whenCondition2 DISCRETE */ && !data->simulationInfo->booleanVarsPre[8] /* $whenCondition2 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4213
type: SIMPLE_ASSIGN
$DER.E_helio_incident = if heliostatsField.on_internal then heliostatsField.n_h * heliostatsField.A_h * max(0.0, sun.dni) else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4213(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4213};
  data->localData[0]->realVars[18] /* der(E_helio_incident) STATE_DER */ = (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */?(data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[143] /* heliostatsField.A_h PARAM */) * (fmax(0.0,data->localData[0]->realVars[1126] /* sun.dni variable */))):0.0);
  TRACE_POP
}
/*
equation index: 4214
type: SIMPLE_ASSIGN
simpleReceiverControl.and1.y = simpleReceiverControl.hotTank.y and heliostatsField.on_internal
*/
void PhysicalParticleCO21D_eqFunction_4214(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4214};
  data->localData[0]->booleanVars[26] /* simpleReceiverControl.and1.y DISCRETE */ = (data->localData[0]->booleanVars[28] /* simpleReceiverControl.hotTank.y DISCRETE */ && data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */);
  TRACE_POP
}
/*
equation index: 4215
type: SIMPLE_ASSIGN
heliostatsField.Q_incident = if heliostatsField.on_internal then if heliostatsField.defocus then min(heliostatsField.Q_defocus, heliostatsField.Q_raw) else heliostatsField.Q_raw else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4215(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4215};
  data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */ = (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */?(data->localData[0]->booleanVars[21] /* heliostatsField.defocus DISCRETE */?fmin(data->simulationInfo->realParameter[145] /* heliostatsField.Q_defocus PARAM */,data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */):data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */):0.0);
  TRACE_POP
}
/*
equation index: 4216
type: SIMPLE_ASSIGN
$DER.E_recv_incident = heliostatsField.Q_incident
*/
void PhysicalParticleCO21D_eqFunction_4216(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4216};
  data->localData[0]->realVars[24] /* der(E_recv_incident) STATE_DER */ = data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */;
  TRACE_POP
}
/*
equation index: 4217
type: SIMPLE_ASSIGN
$DER.E_helio_net = heliostatsField.Q_incident
*/
void PhysicalParticleCO21D_eqFunction_4217(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4217};
  data->localData[0]->realVars[19] /* der(E_helio_net) STATE_DER */ = data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */;
  TRACE_POP
}
/*
equation index: 4218
type: SIMPLE_ASSIGN
particleReceiver1D.gc_f[20] = heliostatsField.Q_incident / particleReceiver1D.A_ap
*/
void PhysicalParticleCO21D_eqFunction_4218(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4218};
  data->localData[0]->realVars[241] /* particleReceiver1D.gc_f[20] variable */ = DIVISION_SIM(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */,data->localData[0]->realVars[105] /* particleReceiver1D.A_ap variable */,"particleReceiver1D.A_ap",equationIndexes);
  TRACE_POP
}
/*
equation index: 4219
type: SIMPLE_ASSIGN
particleReceiver1D.Qdot_inc = particleReceiver1D.gc_f[20] * particleReceiver1D.A_ap
*/
void PhysicalParticleCO21D_eqFunction_4219(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4219};
  data->localData[0]->realVars[107] /* particleReceiver1D.Qdot_inc variable */ = (data->localData[0]->realVars[241] /* particleReceiver1D.gc_f[20] variable */) * (data->localData[0]->realVars[105] /* particleReceiver1D.A_ap variable */);
  TRACE_POP
}
/*
equation index: 4220
type: SIMPLE_ASSIGN
heliostatsField.Q_total_loses_optical = max(heliostatsField.n_h * heliostatsField.A_h * sun.dni - heliostatsField.Q_incident, 0.0)
*/
void PhysicalParticleCO21D_eqFunction_4220(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4220};
  data->localData[0]->realVars[86] /* heliostatsField.Q_total_loses_optical variable */ = fmax((data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[143] /* heliostatsField.A_h PARAM */) * (data->localData[0]->realVars[1126] /* sun.dni variable */)) - data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */,0.0);
  TRACE_POP
}
/*
equation index: 4221
type: SIMPLE_ASSIGN
$DER.heliostatsField.E_total_loses_optical = -heliostatsField.Q_total_loses_optical
*/
void PhysicalParticleCO21D_eqFunction_4221(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4221};
  data->localData[0]->realVars[27] /* der(heliostatsField.E_total_loses_optical) STATE_DER */ = (-data->localData[0]->realVars[86] /* heliostatsField.Q_total_loses_optical variable */);
  TRACE_POP
}
/*
equation index: 4222
type: SIMPLE_ASSIGN
heliostatsField.damping = if heliostatsField.on_internal then heliostatsField.Q_incident / (0.001 + heliostatsField.Q_raw) else 1.0
*/
void PhysicalParticleCO21D_eqFunction_4222(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4222};
  data->localData[0]->realVars[91] /* heliostatsField.damping variable */ = (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */?DIVISION_SIM(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */,0.001 + data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */,"0.001 + heliostatsField.Q_raw",equationIndexes):1.0);
  TRACE_POP
}
/*
equation index: 4223
type: SIMPLE_ASSIGN
heliostatsField.W_loss2 = if time < heliostatsField.t_on + heliostatsField.t_start then heliostatsField.n_h * heliostatsField.he_av * heliostatsField.damping * heliostatsField.E_start / heliostatsField.t_start else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4223(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4223};
  modelica_boolean tmp24;
  RELATIONHYSTERESIS(tmp24, data->localData[0]->timeValue, data->localData[0]->realVars[1170] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */, 24, Less);
  data->localData[0]->realVars[89] /* heliostatsField.W_loss2 variable */ = (tmp24?(data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[152] /* heliostatsField.he_av PARAM */) * ((data->localData[0]->realVars[91] /* heliostatsField.damping variable */) * (DIVISION_SIM(data->simulationInfo->realParameter[144] /* heliostatsField.E_start PARAM */,data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */,"heliostatsField.t_start",equationIndexes)))):0.0);
  TRACE_POP
}
/*
equation index: 4224
type: SIMPLE_ASSIGN
heliostatsField.W_loss1 = if heliostatsField.ele > 0.01 then heliostatsField.n_h * heliostatsField.he_av * heliostatsField.damping * heliostatsField.W_track else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4224(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4224};
  modelica_boolean tmp25;
  RELATIONHYSTERESIS(tmp25, data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, 0, Greater);
  data->localData[0]->realVars[88] /* heliostatsField.W_loss1 variable */ = (tmp25?(data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[152] /* heliostatsField.he_av PARAM */) * ((data->localData[0]->realVars[91] /* heliostatsField.damping variable */) * (data->simulationInfo->realParameter[149] /* heliostatsField.W_track PARAM */))):0.0);
  TRACE_POP
}
/*
equation index: 4225
type: SIMPLE_ASSIGN
heliostatsField.W_loss = heliostatsField.W_loss1 + heliostatsField.W_loss2
*/
void PhysicalParticleCO21D_eqFunction_4225(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4225};
  data->localData[0]->realVars[87] /* heliostatsField.W_loss variable */ = data->localData[0]->realVars[88] /* heliostatsField.W_loss1 variable */ + data->localData[0]->realVars[89] /* heliostatsField.W_loss2 variable */;
  TRACE_POP
}
/*
equation index: 4226
type: SIMPLE_ASSIGN
tankHot.T_mea = SolarTherm.Media.SolidParticles.CarboHSP_utilities.T_h(tankHot.medium.h)
*/
void PhysicalParticleCO21D_eqFunction_4226(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4226};
  data->localData[0]->realVars[1148] /* tankHot.T_mea variable */ = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData, data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */);
  TRACE_POP
}
/*
equation index: 4227
type: SIMPLE_ASSIGN
tankHot.medium.T_degC = -273.15 + tankHot.T_mea
*/
void PhysicalParticleCO21D_eqFunction_4227(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4227};
  data->localData[0]->realVars[1155] /* tankHot.medium.T_degC variable */ = -273.15 + data->localData[0]->realVars[1148] /* tankHot.T_mea variable */;
  TRACE_POP
}
/*
equation index: 4228
type: SIMPLE_ASSIGN
tankHot.Q_losses = (-tankHot.A) * tankHot.alpha * (tankHot.T_mea - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4228(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4228};
  data->localData[0]->realVars[1147] /* tankHot.Q_losses variable */ = ((-data->localData[0]->realVars[1146] /* tankHot.A variable */)) * ((data->simulationInfo->realParameter[815] /* tankHot.alpha PARAM */) * (data->localData[0]->realVars[1148] /* tankHot.T_mea variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */));
  TRACE_POP
}
/*
equation index: 4229
type: SIMPLE_ASSIGN
tankHot.W_net = if tankHot.T_mea < tankHot.T_set then min(-tankHot.Q_losses, tankHot.W_max) else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4229(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4229};
  modelica_boolean tmp26;
  RELATIONHYSTERESIS(tmp26, data->localData[0]->realVars[1148] /* tankHot.T_mea variable */, data->simulationInfo->realParameter[811] /* tankHot.T_set PARAM */, 12, Less);
  data->localData[0]->realVars[1151] /* tankHot.W_net variable */ = (tmp26?fmin((-data->localData[0]->realVars[1147] /* tankHot.Q_losses variable */),data->simulationInfo->realParameter[814] /* tankHot.W_max PARAM */):0.0);
  TRACE_POP
}
/*
equation index: 4230
type: SIMPLE_ASSIGN
tankHot.W_loss = tankHot.W_net / tankHot.e_ht
*/
void PhysicalParticleCO21D_eqFunction_4230(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4230};
  data->localData[0]->realVars[1150] /* tankHot.W_loss variable */ = DIVISION_SIM(data->localData[0]->realVars[1151] /* tankHot.W_net variable */,data->simulationInfo->realParameter[816] /* tankHot.e_ht PARAM */,"tankHot.e_ht",equationIndexes);
  TRACE_POP
}
/*
equation index: 4231
type: SIMPLE_ASSIGN
particleReceiver1D.T_s[1] = SolarTherm.Media.SolidParticles.CarboHSP_utilities.T_h(tankCold.medium.h)
*/
void PhysicalParticleCO21D_eqFunction_4231(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4231};
  data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */ = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData, data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */);
  TRACE_POP
}
/*
equation index: 4232
type: SIMPLE_ASSIGN
tankCold.medium.T_degC = -273.15 + particleReceiver1D.T_s[1]
*/
void PhysicalParticleCO21D_eqFunction_4232(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4232};
  data->localData[0]->realVars[1136] /* tankCold.medium.T_degC variable */ = -273.15 + data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */;
  TRACE_POP
}
/*
equation index: 4233
type: SIMPLE_ASSIGN
particleReceiver1D.h_s[1] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1D$Tab.getTableValue(particleReceiver1D.Tab[1].tableID, 1, particleReceiver1D.T_s[1], particleReceiver1D.Tab[1].tableOnFileRead)
*/
void PhysicalParticleCO21D_eqFunction_4233(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4233};
  data->localData[0]->realVars[242] /* particleReceiver1D.h_s[1] variable */ = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D24Tab_getTableValue(threadData, data->simulationInfo->extObjs[2], ((modelica_integer) 1), data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */, data->simulationInfo->realParameter[212] /* particleReceiver1D.Tab[1].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4234
type: SIMPLE_ASSIGN
tankCold.Q_losses = (-tankCold.A) * tankCold.alpha * (particleReceiver1D.T_s[1] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4234(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4234};
  data->localData[0]->realVars[1129] /* tankCold.Q_losses variable */ = ((-data->localData[0]->realVars[1128] /* tankCold.A variable */)) * ((data->simulationInfo->realParameter[805] /* tankCold.alpha PARAM */) * (data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */));
  TRACE_POP
}
/*
equation index: 4235
type: SIMPLE_ASSIGN
tankCold.W_net = if particleReceiver1D.T_s[1] < tankCold.T_set then min(-tankCold.Q_losses, tankCold.W_max) else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4235(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4235};
  modelica_boolean tmp27;
  RELATIONHYSTERESIS(tmp27, data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */, data->simulationInfo->realParameter[801] /* tankCold.T_set PARAM */, 11, Less);
  data->localData[0]->realVars[1132] /* tankCold.W_net variable */ = (tmp27?fmin((-data->localData[0]->realVars[1129] /* tankCold.Q_losses variable */),data->simulationInfo->realParameter[804] /* tankCold.W_max PARAM */):0.0);
  TRACE_POP
}
/*
equation index: 4236
type: SIMPLE_ASSIGN
tankCold.W_loss = tankCold.W_net / tankCold.e_ht
*/
void PhysicalParticleCO21D_eqFunction_4236(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4236};
  data->localData[0]->realVars[1131] /* tankCold.W_loss variable */ = DIVISION_SIM(data->localData[0]->realVars[1132] /* tankCold.W_net variable */,data->simulationInfo->realParameter[806] /* tankCold.e_ht PARAM */,"tankCold.e_ht",equationIndexes);
  TRACE_POP
}
/*
equation index: 4237
type: ALGORITHM

  simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete := $START.simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete;
  simpleReceiverControl.idealMassflowBlockCalculation.m_flow := $START.simpleReceiverControl.idealMassflowBlockCalculation.m_flow;
  if heliostatsField.Q_incident <= 1e-06 then
    simpleReceiverControl.idealMassflowBlockCalculation.m_flow := 0.0;
  elseif heliostatsField.Q_incident > 1e-06 then
    if simpleReceiverControl.idealMassflowBlockCalculation.eta_rec < 9.999999999999999e-21 then
      simpleReceiverControl.idealMassflowBlockCalculation.m_flow := heliostatsField.Q_incident * simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete / abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D.T_s[1]));
    else
      simpleReceiverControl.idealMassflowBlockCalculation.m_flow := heliostatsField.Q_incident * simpleReceiverControl.idealMassflowBlockCalculation.eta_rec / abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D.T_s[1]));
      simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete := simpleReceiverControl.idealMassflowBlockCalculation.eta_rec;
    end if;
  end if;
*/
void PhysicalParticleCO21D_eqFunction_4237(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4237};
  modelica_boolean tmp28;
  modelica_boolean tmp29;
  modelica_boolean tmp30;
  data->localData[0]->realVars[1121] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */ = data->modelData->realVarsData[1121].attribute /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */.start;

  data->localData[0]->realVars[1122] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = data->modelData->realVarsData[1122].attribute /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */.start;

  RELATIONHYSTERESIS(tmp28, data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, 18, LessEq);
  if(tmp28)
  {
    data->localData[0]->realVars[1122] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = 0.0;
  }
  else
  {
    RELATIONHYSTERESIS(tmp29, data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, 17, Greater);
    if(tmp29)
    {
      tmp30 = Less(data->simulationInfo->realParameter[777] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec PARAM */,9.999999999999999e-21);
      if(tmp30)
      {
        data->localData[0]->realVars[1122] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */) * (DIVISION_SIM(data->localData[0]->realVars[1121] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */,fabs(omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->simulationInfo->realParameter[768] /* simpleReceiverControl.T_ref PARAM */) - omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */)),"abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D.T_s[1]))",equationIndexes));
      }
      else
      {
        data->localData[0]->realVars[1122] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */) * (DIVISION_SIM(data->simulationInfo->realParameter[777] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec PARAM */,fabs(omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->simulationInfo->realParameter[768] /* simpleReceiverControl.T_ref PARAM */) - omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */)),"abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D.T_s[1]))",equationIndexes));

        data->localData[0]->realVars[1121] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */ = data->simulationInfo->realParameter[777] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec PARAM */;
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4238
type: SIMPLE_ASSIGN
simpleReceiverControl.limiter.y = smooth(0, if simpleReceiverControl.idealMassflowBlockCalculation.m_flow > simpleReceiverControl.limiter.uMax then simpleReceiverControl.limiter.uMax else if simpleReceiverControl.idealMassflowBlockCalculation.m_flow < simpleReceiverControl.limiter.uMin then simpleReceiverControl.limiter.uMin else simpleReceiverControl.idealMassflowBlockCalculation.m_flow)
*/
void PhysicalParticleCO21D_eqFunction_4238(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4238};
  modelica_boolean tmp31;
  modelica_boolean tmp32;
  modelica_boolean tmp33;
  modelica_real tmp34;
  tmp31 = Greater(data->localData[0]->realVars[1122] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */,data->simulationInfo->realParameter[779] /* simpleReceiverControl.limiter.uMax PARAM */);
  tmp33 = (modelica_boolean)tmp31;
  if(tmp33)
  {
    tmp34 = data->simulationInfo->realParameter[779] /* simpleReceiverControl.limiter.uMax PARAM */;
  }
  else
  {
    tmp32 = Less(data->localData[0]->realVars[1122] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */,data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMin PARAM */);
    tmp34 = (tmp32?data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMin PARAM */:data->localData[0]->realVars[1122] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */);
  }
  data->localData[0]->realVars[1123] /* simpleReceiverControl.limiter.y variable */ = tmp34;
  TRACE_POP
}
/*
equation index: 4239
type: SIMPLE_ASSIGN
controlHot.m_flow_in = if simpleReceiverControl.and1.y then simpleReceiverControl.limiter.y else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4239(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4239};
  data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */ = (data->localData[0]->booleanVars[26] /* simpleReceiverControl.and1.y DISCRETE */?data->localData[0]->realVars[1123] /* simpleReceiverControl.limiter.y variable */:0.0);
  TRACE_POP
}
/*
equation index: 4240
type: SIMPLE_ASSIGN
controlHot.logic.on_charge = controlHot.m_flow_in > 0.0
*/
void PhysicalParticleCO21D_eqFunction_4240(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4240};
  modelica_boolean tmp35;
  RELATIONHYSTERESIS(tmp35, data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */, 0.0, 19, Greater);
  data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ = tmp35;
  TRACE_POP
}
/*
equation index: 4241
type: SIMPLE_ASSIGN
$whenCondition9 = controlHot.logic.on_charge or controlHot.logic.on_discharge
*/
void PhysicalParticleCO21D_eqFunction_4241(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4241};
  data->localData[0]->booleanVars[15] /* $whenCondition9 DISCRETE */ = (data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ || data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */);
  TRACE_POP
}
/*
equation index: 4242
type: WHEN

when {$whenCondition9} then
  controlHot.logic.t_on = time;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4242(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4242};
  if((data->localData[0]->booleanVars[15] /* $whenCondition9 DISCRETE */ && !data->simulationInfo->booleanVarsPre[15] /* $whenCondition9 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1167] /* controlHot.logic.t_on DISCRETE */ = data->localData[0]->timeValue;
  }
  TRACE_POP
}
/*
equation index: 4243
type: SIMPLE_ASSIGN
$whenCondition11 = time - controlHot.logic.t_on > controlHot.logic.t_start
*/
void PhysicalParticleCO21D_eqFunction_4243(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4243};
  modelica_boolean tmp36;
  RELATIONHYSTERESIS(tmp36, data->localData[0]->timeValue - data->localData[0]->realVars[1167] /* controlHot.logic.t_on DISCRETE */, data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */, 20, Greater);
  data->localData[0]->booleanVars[2] /* $whenCondition11 DISCRETE */ = tmp36;
  TRACE_POP
}
/*
equation index: 4244
type: SIMPLE_ASSIGN
$whenCondition10 = not (controlHot.logic.on_charge or controlHot.logic.on_discharge)
*/
void PhysicalParticleCO21D_eqFunction_4244(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4244};
  data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ = (!(data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ || data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */));
  TRACE_POP
}
/*
equation index: 4245
type: WHEN

when {$whenCondition10} then
  controlHot.logic.t_off = time;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4245(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4245};
  if((data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ && !data->simulationInfo->booleanVarsPre[1] /* $whenCondition10 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1166] /* controlHot.logic.t_off DISCRETE */ = data->localData[0]->timeValue;
  }
  TRACE_POP
}
/*
equation index: 4246
type: SIMPLE_ASSIGN
controlHot.logic.standby = time - controlHot.logic.t_off < controlHot.logic.t_standby
*/
void PhysicalParticleCO21D_eqFunction_4246(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4246};
  modelica_boolean tmp37;
  RELATIONHYSTERESIS(tmp37, data->localData[0]->timeValue - data->localData[0]->realVars[1166] /* controlHot.logic.t_off DISCRETE */, data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */, 21, Less);
  data->localData[0]->booleanVars[19] /* controlHot.logic.standby DISCRETE */ = tmp37;
  TRACE_POP
}
/*
equation index: 4247
type: SIMPLE_ASSIGN
$whenCondition12 = controlHot.logic.t_on + (-controlHot.logic.t_off) - controlHot.logic.t_standby > 0.0
*/
void PhysicalParticleCO21D_eqFunction_4247(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4247};
  modelica_boolean tmp38;
  tmp38 = Greater(data->localData[0]->realVars[1167] /* controlHot.logic.t_on DISCRETE */ + (-data->localData[0]->realVars[1166] /* controlHot.logic.t_off DISCRETE */) - data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */,0.0);
  data->localData[0]->booleanVars[3] /* $whenCondition12 DISCRETE */ = tmp38;
  TRACE_POP
}
/*
equation index: 4248
type: WHEN

when {$whenCondition12} then
  controlHot.logic.startup = true;
end when;
*/
void PhysicalParticleCO21D_eqFunction_4248(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4248};
  if((data->localData[0]->booleanVars[3] /* $whenCondition12 DISCRETE */ && !data->simulationInfo->booleanVarsPre[3] /* $whenCondition12 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[20] /* controlHot.logic.startup DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[2] /* $whenCondition11 DISCRETE */ && !data->simulationInfo->booleanVarsPre[2] /* $whenCondition11 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[20] /* controlHot.logic.startup DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4250
type: SIMPLE_ASSIGN
controlHot.m_flow = if controlHot.logic.on_charge or controlHot.logic.on_discharge then if controlHot.logic.startup then controlHot.logic.m_flow_startup else if controlHot.logic.on_discharge then controlHot.logic.m_flow_max else min(controlHot.m_flow_in, controlHot.logic.m_flow_max) else if controlHot.logic.standby then controlHot.logic.m_flow_standby else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4250(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4250};
  data->localData[0]->realVars[60] /* controlHot.m_flow variable */ = ((data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ || data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */)?(data->localData[0]->booleanVars[20] /* controlHot.logic.startup DISCRETE */?data->simulationInfo->realParameter[92] /* controlHot.logic.m_flow_startup PARAM */:(data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */?data->simulationInfo->realParameter[90] /* controlHot.logic.m_flow_max PARAM */:fmin(data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */,data->simulationInfo->realParameter[90] /* controlHot.logic.m_flow_max PARAM */))):(data->localData[0]->booleanVars[19] /* controlHot.logic.standby DISCRETE */?data->simulationInfo->realParameter[91] /* controlHot.logic.m_flow_standby PARAM */:0.0));
  TRACE_POP
}
/*
equation index: 4251
type: SIMPLE_ASSIGN
LiftCold.fluid_b.m_flow = -(if liftHX.use_input then controlHot.m_flow else liftHX.m_flow_fixed)
*/
void PhysicalParticleCO21D_eqFunction_4251(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4251};
  data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */ = (-((data->simulationInfo->booleanParameter[14] /* liftHX.use_input PARAM */?data->localData[0]->realVars[60] /* controlHot.m_flow variable */:data->simulationInfo->realParameter[173] /* liftHX.m_flow_fixed PARAM */)));
  TRACE_POP
}
/*
equation index: 4252
type: SIMPLE_ASSIGN
powerBlock.m_sup = (-LiftCold.fluid_b.m_flow) >= powerBlock.exchanger.m_HTF_des * powerBlock.nu_min
*/
void PhysicalParticleCO21D_eqFunction_4252(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4252};
  modelica_boolean tmp39;
  RELATIONHYSTERESIS(tmp39, (-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */), (data->simulationInfo->realParameter[657] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[693] /* powerBlock.nu_min PARAM */), 22, GreaterEq);
  data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ = tmp39;
  TRACE_POP
}
/*
equation index: 4253
type: SIMPLE_ASSIGN
powerBlock.exchanger.h_HTF[2] = if powerBlock.m_sup then tankHot.medium.h else powerBlock.exchanger.h_in_HTF_des
*/
void PhysicalParticleCO21D_eqFunction_4253(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4253};
  data->localData[0]->realVars[1083] /* powerBlock.exchanger.h_HTF[2] variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */:data->simulationInfo->realParameter[653] /* powerBlock.exchanger.h_in_HTF_des PARAM */);
  TRACE_POP
}
/*
equation index: 4254
type: SIMPLE_ASSIGN
powerBlock.exchanger.m_HTF_bis = if powerBlock.m_sup then -LiftCold.fluid_b.m_flow else powerBlock.exchanger.m_HTF_des
*/
void PhysicalParticleCO21D_eqFunction_4254(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4254};
  data->localData[0]->realVars[1084] /* powerBlock.exchanger.m_HTF_bis variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?(-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */):data->simulationInfo->realParameter[657] /* powerBlock.exchanger.m_HTF_des PARAM */);
  TRACE_POP
}
void PhysicalParticleCO21D_eqFunction_4255(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4256(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4257(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4258(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4259(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4260(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4261(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4262(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4263(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4264(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4265(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4266(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4267(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4268(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4269(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4270(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4271(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4272(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4273(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4274(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4275(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4276(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4277(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4278(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4279(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4280(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4281(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4282(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4283(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4284(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4285(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4286(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4287(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4288(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4289(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4290(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4291(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4292(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4293(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4294(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4295(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4296(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4297(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4298(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4299(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4300(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4301(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4302(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4303(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4304(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4305(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4306(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4307(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4308(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4309(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4310(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4311(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4312(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4313(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4314(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4315(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4316(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4317(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4318(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4355(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4354(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4353(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4352(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4351(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4350(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4349(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4348(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4347(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4346(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4345(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4344(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4343(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4342(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4341(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4340(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4339(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4338(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4337(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4336(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4335(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4334(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4333(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4332(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4331(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4330(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4329(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4328(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4327(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4326(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4325(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4324(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4323(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4322(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4321(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4320(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4319(DATA*, threadData_t*);
/*
equation index: 4356
indexNonlinear: 43
type: NONLINEAR

vars: {powerBlock.exchanger.h_CO2[2], powerBlock.LTR.h_from_turb[1], powerBlock.exchanger.CO2_port_b.m_flow, powerBlock.exchanger.h_HTF[1], powerBlock.exchanger.h_CO2[1], powerBlock.HTR.h_from_turb[14], powerBlock.HTR.h_from_turb[13], powerBlock.HTR.h_from_comp[14], powerBlock.HTR.h_from_comp[13], powerBlock.HTR.h_from_turb[12], powerBlock.HTR.h_from_comp[12], powerBlock.HTR.h_from_turb[11], powerBlock.HTR.h_from_comp[11], powerBlock.HTR.h_from_turb[10], powerBlock.HTR.h_from_comp[10], powerBlock.HTR.h_from_turb[9], powerBlock.HTR.h_from_turb[8], powerBlock.HTR.h_from_comp[8], powerBlock.HTR.h_from_comp[9], powerBlock.HTR.h_from_comp[7], powerBlock.HTR.h_from_turb[7], powerBlock.HTR.h_from_comp[6], powerBlock.HTR.h_from_turb[6], powerBlock.HTR.h_from_turb[5], powerBlock.HTR.h_from_comp[5], powerBlock.HTR.h_from_comp[4], powerBlock.HTR.h_from_turb[4], powerBlock.HTR.h_from_turb[3], powerBlock.HTR.h_from_comp[3], powerBlock.HTR.h_from_turb[2], powerBlock.HTR.h_from_comp[2], powerBlock.reCompressor.p_out, powerBlock.LTR.h_from_turb[2], powerBlock.LTR.h_from_comp[2], powerBlock.turbine.C_spouting, powerBlock.turbine.p_out, powerBlock.mainCompressor.p_out}
eqns: {4255, 4256, 4257, 4258, 4259, 4260, 4261, 4262, 4263, 4264, 4265, 4266, 4267, 4268, 4269, 4270, 4271, 4272, 4273, 4274, 4275, 4276, 4277, 4278, 4279, 4280, 4281, 4282, 4283, 4284, 4285, 4286, 4287, 4288, 4289, 4290, 4291, 4292, 4293, 4294, 4295, 4296, 4297, 4298, 4299, 4300, 4301, 4302, 4303, 4304, 4305, 4306, 4307, 4308, 4309, 4310, 4311, 4312, 4313, 4314, 4315, 4316, 4317, 4318, 4355, 4354, 4353, 4352, 4351, 4350, 4349, 4348, 4347, 4346, 4345, 4344, 4343, 4342, 4341, 4340, 4339, 4338, 4337, 4336, 4335, 4334, 4333, 4332, 4331, 4330, 4329, 4328, 4327, 4326, 4325, 4324, 4323, 4322, 4321, 4320, 4319}
*/
void PhysicalParticleCO21D_eqFunction_4356(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4356};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 4356 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[0] = data->localData[0]->realVars[1081] /* powerBlock.exchanger.h_CO2[2] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[1] = data->localData[0]->realVars[1064] /* powerBlock.LTR.h_from_turb[1] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[2] = data->localData[0]->realVars[1073] /* powerBlock.exchanger.CO2_port_b.m_flow variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[3] = data->localData[0]->realVars[1082] /* powerBlock.exchanger.h_HTF[1] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[4] = data->localData[0]->realVars[1080] /* powerBlock.exchanger.h_CO2[1] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[5] = data->localData[0]->realVars[1053] /* powerBlock.HTR.h_from_turb[14] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[6] = data->localData[0]->realVars[1052] /* powerBlock.HTR.h_from_turb[13] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[7] = data->localData[0]->realVars[1040] /* powerBlock.HTR.h_from_comp[14] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[8] = data->localData[0]->realVars[1039] /* powerBlock.HTR.h_from_comp[13] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[9] = data->localData[0]->realVars[1051] /* powerBlock.HTR.h_from_turb[12] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[10] = data->localData[0]->realVars[1038] /* powerBlock.HTR.h_from_comp[12] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[11] = data->localData[0]->realVars[1050] /* powerBlock.HTR.h_from_turb[11] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[12] = data->localData[0]->realVars[1037] /* powerBlock.HTR.h_from_comp[11] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[13] = data->localData[0]->realVars[1049] /* powerBlock.HTR.h_from_turb[10] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[14] = data->localData[0]->realVars[1036] /* powerBlock.HTR.h_from_comp[10] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[15] = data->localData[0]->realVars[1048] /* powerBlock.HTR.h_from_turb[9] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[16] = data->localData[0]->realVars[1047] /* powerBlock.HTR.h_from_turb[8] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[17] = data->localData[0]->realVars[1034] /* powerBlock.HTR.h_from_comp[8] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[18] = data->localData[0]->realVars[1035] /* powerBlock.HTR.h_from_comp[9] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[19] = data->localData[0]->realVars[1033] /* powerBlock.HTR.h_from_comp[7] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[20] = data->localData[0]->realVars[1046] /* powerBlock.HTR.h_from_turb[7] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[21] = data->localData[0]->realVars[1032] /* powerBlock.HTR.h_from_comp[6] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[22] = data->localData[0]->realVars[1045] /* powerBlock.HTR.h_from_turb[6] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[23] = data->localData[0]->realVars[1044] /* powerBlock.HTR.h_from_turb[5] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[24] = data->localData[0]->realVars[1031] /* powerBlock.HTR.h_from_comp[5] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[25] = data->localData[0]->realVars[1030] /* powerBlock.HTR.h_from_comp[4] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[26] = data->localData[0]->realVars[1043] /* powerBlock.HTR.h_from_turb[4] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[27] = data->localData[0]->realVars[1042] /* powerBlock.HTR.h_from_turb[3] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[28] = data->localData[0]->realVars[1029] /* powerBlock.HTR.h_from_comp[3] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[29] = data->localData[0]->realVars[1041] /* powerBlock.HTR.h_from_turb[2] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[30] = data->localData[0]->realVars[1028] /* powerBlock.HTR.h_from_comp[2] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[31] = data->localData[0]->realVars[1101] /* powerBlock.reCompressor.p_out variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[32] = data->localData[0]->realVars[1065] /* powerBlock.LTR.h_from_turb[2] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[33] = data->localData[0]->realVars[1063] /* powerBlock.LTR.h_from_comp[2] variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[34] = data->localData[0]->realVars[1109] /* powerBlock.turbine.C_spouting variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[35] = data->localData[0]->realVars[1114] /* powerBlock.turbine.p_out variable */;
  data->simulationInfo->nonlinearSystemData[43].nlsxOld[36] = data->localData[0]->realVars[1091] /* powerBlock.mainCompressor.p_out variable */;
  retValue = solve_nonlinear_system(data, threadData, 43);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,4356};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 4356 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[1081] /* powerBlock.exchanger.h_CO2[2] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[0];
  data->localData[0]->realVars[1064] /* powerBlock.LTR.h_from_turb[1] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[1];
  data->localData[0]->realVars[1073] /* powerBlock.exchanger.CO2_port_b.m_flow variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[2];
  data->localData[0]->realVars[1082] /* powerBlock.exchanger.h_HTF[1] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[3];
  data->localData[0]->realVars[1080] /* powerBlock.exchanger.h_CO2[1] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[4];
  data->localData[0]->realVars[1053] /* powerBlock.HTR.h_from_turb[14] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[5];
  data->localData[0]->realVars[1052] /* powerBlock.HTR.h_from_turb[13] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[6];
  data->localData[0]->realVars[1040] /* powerBlock.HTR.h_from_comp[14] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[7];
  data->localData[0]->realVars[1039] /* powerBlock.HTR.h_from_comp[13] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[8];
  data->localData[0]->realVars[1051] /* powerBlock.HTR.h_from_turb[12] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[9];
  data->localData[0]->realVars[1038] /* powerBlock.HTR.h_from_comp[12] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[10];
  data->localData[0]->realVars[1050] /* powerBlock.HTR.h_from_turb[11] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[11];
  data->localData[0]->realVars[1037] /* powerBlock.HTR.h_from_comp[11] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[12];
  data->localData[0]->realVars[1049] /* powerBlock.HTR.h_from_turb[10] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[13];
  data->localData[0]->realVars[1036] /* powerBlock.HTR.h_from_comp[10] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[14];
  data->localData[0]->realVars[1048] /* powerBlock.HTR.h_from_turb[9] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[15];
  data->localData[0]->realVars[1047] /* powerBlock.HTR.h_from_turb[8] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[16];
  data->localData[0]->realVars[1034] /* powerBlock.HTR.h_from_comp[8] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[17];
  data->localData[0]->realVars[1035] /* powerBlock.HTR.h_from_comp[9] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[18];
  data->localData[0]->realVars[1033] /* powerBlock.HTR.h_from_comp[7] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[19];
  data->localData[0]->realVars[1046] /* powerBlock.HTR.h_from_turb[7] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[20];
  data->localData[0]->realVars[1032] /* powerBlock.HTR.h_from_comp[6] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[21];
  data->localData[0]->realVars[1045] /* powerBlock.HTR.h_from_turb[6] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[22];
  data->localData[0]->realVars[1044] /* powerBlock.HTR.h_from_turb[5] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[23];
  data->localData[0]->realVars[1031] /* powerBlock.HTR.h_from_comp[5] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[24];
  data->localData[0]->realVars[1030] /* powerBlock.HTR.h_from_comp[4] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[25];
  data->localData[0]->realVars[1043] /* powerBlock.HTR.h_from_turb[4] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[26];
  data->localData[0]->realVars[1042] /* powerBlock.HTR.h_from_turb[3] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[27];
  data->localData[0]->realVars[1029] /* powerBlock.HTR.h_from_comp[3] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[28];
  data->localData[0]->realVars[1041] /* powerBlock.HTR.h_from_turb[2] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[29];
  data->localData[0]->realVars[1028] /* powerBlock.HTR.h_from_comp[2] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[30];
  data->localData[0]->realVars[1101] /* powerBlock.reCompressor.p_out variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[31];
  data->localData[0]->realVars[1065] /* powerBlock.LTR.h_from_turb[2] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[32];
  data->localData[0]->realVars[1063] /* powerBlock.LTR.h_from_comp[2] variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[33];
  data->localData[0]->realVars[1109] /* powerBlock.turbine.C_spouting variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[34];
  data->localData[0]->realVars[1114] /* powerBlock.turbine.p_out variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[35];
  data->localData[0]->realVars[1091] /* powerBlock.mainCompressor.p_out variable */ = data->simulationInfo->nonlinearSystemData[43].nlsx[36];
  TRACE_POP
}
/*
equation index: 4357
type: SIMPLE_ASSIGN
$cse3 = SolarTherm.Media.CO2.CO2_utilities.T_p_h(powerBlock.turbine.p_out, powerBlock.mainCompressor.state_a.h, tableIDT_p_h)
*/
void PhysicalParticleCO21D_eqFunction_4357(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4357};
  data->localData[0]->realVars[46] /* $cse3 variable */ = omc_SolarTherm_Media_CO2_CO2__utilities_T__p__h(threadData, data->localData[0]->realVars[1114] /* powerBlock.turbine.p_out variable */, data->localData[0]->realVars[1096] /* powerBlock.mainCompressor.state_a.h variable */, data->simulationInfo->extObjs[84]);
  TRACE_POP
}
/*
equation index: 4358
type: SIMPLE_ASSIGN
powerBlock.cooler.deltaT[2] = $cse3 - particleReceiver1D.Tamb
*/
void PhysicalParticleCO21D_eqFunction_4358(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4358};
  data->localData[0]->realVars[1070] /* powerBlock.cooler.deltaT[2] variable */ = data->localData[0]->realVars[46] /* $cse3 variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */;
  TRACE_POP
}
/*
equation index: 4359
type: SIMPLE_ASSIGN
powerBlock.mainCompressor.W_comp = powerBlock.cooler.port_b.m_flow * (powerBlock.mainCompressor.state_a.h - powerBlock.LTR.h_from_comp[1])
*/
void PhysicalParticleCO21D_eqFunction_4359(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4359};
  data->localData[0]->realVars[1088] /* powerBlock.mainCompressor.W_comp variable */ = (data->localData[0]->realVars[1071] /* powerBlock.cooler.port_b.m_flow variable */) * (data->localData[0]->realVars[1096] /* powerBlock.mainCompressor.state_a.h variable */ - data->localData[0]->realVars[1062] /* powerBlock.LTR.h_from_comp[1] variable */);
  TRACE_POP
}
/*
equation index: 4360
type: SIMPLE_ASSIGN
$DER.E_pb_input = if powerBlock.m_sup == true then powerBlock.exchanger.Q_HX else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4360(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4360};
  data->localData[0]->realVars[22] /* der(E_pb_input) STATE_DER */ = (((!data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && !1) || (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && 1))?data->localData[0]->realVars[1074] /* powerBlock.exchanger.Q_HX variable */:0.0);
  TRACE_POP
}
/*
equation index: 4361
type: SIMPLE_ASSIGN
powerBlock.turbine.W_turb = powerBlock.exchanger.CO2_port_b.m_flow * (powerBlock.exchanger.h_CO2[2] - powerBlock.HTR.h_from_turb[15])
*/
void PhysicalParticleCO21D_eqFunction_4361(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4361};
  data->localData[0]->realVars[1110] /* powerBlock.turbine.W_turb variable */ = (data->localData[0]->realVars[1073] /* powerBlock.exchanger.CO2_port_b.m_flow variable */) * (data->localData[0]->realVars[1081] /* powerBlock.exchanger.h_CO2[2] variable */ - data->localData[0]->realVars[1054] /* powerBlock.HTR.h_from_turb[15] variable */);
  TRACE_POP
}
/*
equation index: 4362
type: SIMPLE_ASSIGN
$DER.E_pb_gross = if powerBlock.m_sup == true then -powerBlock.turbine.W_turb else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4362(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4362};
  data->localData[0]->realVars[21] /* der(E_pb_gross) STATE_DER */ = (((!data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && !1) || (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && 1))?(-data->localData[0]->realVars[1110] /* powerBlock.turbine.W_turb variable */):0.0);
  TRACE_POP
}
/*
equation index: 4363
type: SIMPLE_ASSIGN
powerBlock.turbine.W_turb_abs = abs(powerBlock.turbine.W_turb)
*/
void PhysicalParticleCO21D_eqFunction_4363(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4363};
  data->localData[0]->realVars[1111] /* powerBlock.turbine.W_turb_abs variable */ = fabs(data->localData[0]->realVars[1110] /* powerBlock.turbine.W_turb variable */);
  TRACE_POP
}
/*
equation index: 4364
type: SIMPLE_ASSIGN
powerBlock.exchanger.deltaTAve = 0.5 * (powerBlock.exchanger.deltaT[1] + powerBlock.exchanger.deltaT[2])
*/
void PhysicalParticleCO21D_eqFunction_4364(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4364};
  data->localData[0]->realVars[1079] /* powerBlock.exchanger.deltaTAve variable */ = (0.5) * (data->localData[0]->realVars[1077] /* powerBlock.exchanger.deltaT[1] variable */ + data->localData[0]->realVars[1078] /* powerBlock.exchanger.deltaT[2] variable */);
  TRACE_POP
}
/*
equation index: 4365
type: SIMPLE_ASSIGN
powerBlock.LTR.deltaT[1] = powerBlock.LTR.T_from_turb[1] - powerBlock.LTR.T_from_comp[1]
*/
void PhysicalParticleCO21D_eqFunction_4365(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4365};
  data->localData[0]->realVars[1060] /* powerBlock.LTR.deltaT[1] variable */ = data->localData[0]->realVars[1058] /* powerBlock.LTR.T_from_turb[1] variable */ - data->localData[0]->realVars[1056] /* powerBlock.LTR.T_from_comp[1] variable */;
  TRACE_POP
}
/*
equation index: 4366
type: SIMPLE_ASSIGN
powerBlock.cooler.deltaT[1] = powerBlock.LTR.T_from_turb[1] - particleReceiver1D.Tamb
*/
void PhysicalParticleCO21D_eqFunction_4366(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4366};
  data->localData[0]->realVars[1069] /* powerBlock.cooler.deltaT[1] variable */ = data->localData[0]->realVars[1058] /* powerBlock.LTR.T_from_turb[1] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */;
  TRACE_POP
}
/*
equation index: 4367
type: SIMPLE_ASSIGN
powerBlock.HTR.Q_HX = powerBlock.exchanger.CO2_port_b.m_flow * (powerBlock.LTR.h_from_turb[2] - powerBlock.HTR.h_from_turb[15])
*/
void PhysicalParticleCO21D_eqFunction_4367(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4367};
  data->localData[0]->realVars[980] /* powerBlock.HTR.Q_HX variable */ = (data->localData[0]->realVars[1073] /* powerBlock.exchanger.CO2_port_b.m_flow variable */) * (data->localData[0]->realVars[1065] /* powerBlock.LTR.h_from_turb[2] variable */ - data->localData[0]->realVars[1054] /* powerBlock.HTR.h_from_turb[15] variable */);
  TRACE_POP
}
/*
equation index: 4368
type: SIMPLE_ASSIGN
powerBlock.LTR.deltaT[2] = powerBlock.LTR.T_from_turb[2] - powerBlock.LTR.T_from_comp[2]
*/
void PhysicalParticleCO21D_eqFunction_4368(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4368};
  data->localData[0]->realVars[1061] /* powerBlock.LTR.deltaT[2] variable */ = data->localData[0]->realVars[1059] /* powerBlock.LTR.T_from_turb[2] variable */ - data->localData[0]->realVars[1057] /* powerBlock.LTR.T_from_comp[2] variable */;
  TRACE_POP
}
/*
equation index: 4369
type: SIMPLE_ASSIGN
powerBlock.HTR.T_from_turb[1] = powerBlock.LTR.T_from_turb[2]
*/
void PhysicalParticleCO21D_eqFunction_4369(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4369};
  data->localData[0]->realVars[996] /* powerBlock.HTR.T_from_turb[1] variable */ = data->localData[0]->realVars[1059] /* powerBlock.LTR.T_from_turb[2] variable */;
  TRACE_POP
}
/*
equation index: 4370
type: SIMPLE_ASSIGN
powerBlock.reCompressor.W_comp = powerBlock.splitter.gamma_port_b.m_flow * (powerBlock.LTR.h_from_turb[1] - powerBlock.reCompressor.state_b.h)
*/
void PhysicalParticleCO21D_eqFunction_4370(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4370};
  data->localData[0]->realVars[1098] /* powerBlock.reCompressor.W_comp variable */ = (data->localData[0]->realVars[1108] /* powerBlock.splitter.gamma_port_b.m_flow variable */) * (data->localData[0]->realVars[1064] /* powerBlock.LTR.h_from_turb[1] variable */ - data->localData[0]->realVars[1106] /* powerBlock.reCompressor.state_b.h variable */);
  TRACE_POP
}
/*
equation index: 4371
type: SIMPLE_ASSIGN
powerBlock.W_total_compressor = powerBlock.mainCompressor.W_comp + powerBlock.reCompressor.W_comp
*/
void PhysicalParticleCO21D_eqFunction_4371(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4371};
  data->localData[0]->realVars[1066] /* powerBlock.W_total_compressor variable */ = data->localData[0]->realVars[1088] /* powerBlock.mainCompressor.W_comp variable */ + data->localData[0]->realVars[1098] /* powerBlock.reCompressor.W_comp variable */;
  TRACE_POP
}
/*
equation index: 4372
type: SIMPLE_ASSIGN
P_elec = if powerBlock.m_sup then (-powerBlock.turbine.W_turb) - powerBlock.reCompressor.W_comp - powerBlock.mainCompressor.W_comp else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4372(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4372};
  data->localData[0]->realVars[56] /* P_elec variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?(-data->localData[0]->realVars[1110] /* powerBlock.turbine.W_turb variable */) - data->localData[0]->realVars[1098] /* powerBlock.reCompressor.W_comp variable */ - data->localData[0]->realVars[1088] /* powerBlock.mainCompressor.W_comp variable */:0.0);
  TRACE_POP
}
/*
equation index: 4373
type: SIMPLE_ASSIGN
$DER.E_elec = P_elec
*/
void PhysicalParticleCO21D_eqFunction_4373(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4373};
  data->localData[0]->realVars[17] /* der(E_elec) STATE_DER */ = data->localData[0]->realVars[56] /* P_elec variable */;
  TRACE_POP
}
/*
equation index: 4374
type: SIMPLE_ASSIGN
$DER.E_pb_net = P_elec
*/
void PhysicalParticleCO21D_eqFunction_4374(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4374};
  data->localData[0]->realVars[23] /* der(E_pb_net) STATE_DER */ = data->localData[0]->realVars[56] /* P_elec variable */;
  TRACE_POP
}
/*
equation index: 4375
type: SIMPLE_ASSIGN
$DER.market.profit = 2.777777777777778e-10 * P_elec * market.price.price_annual
*/
void PhysicalParticleCO21D_eqFunction_4375(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4375};
  data->localData[0]->realVars[28] /* der(market.profit) STATE_DER */ = (2.777777777777778e-10) * ((data->localData[0]->realVars[56] /* P_elec variable */) * (data->simulationInfo->realParameter[187] /* market.price.price_annual PARAM */));
  TRACE_POP
}
/*
equation index: 4376
type: SIMPLE_ASSIGN
$DER.powerBlock.E_net = P_elec
*/
void PhysicalParticleCO21D_eqFunction_4376(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4376};
  data->localData[0]->realVars[29] /* der(powerBlock.E_net) STATE_DER */ = data->localData[0]->realVars[56] /* P_elec variable */;
  TRACE_POP
}
/*
equation index: 4377
type: SIMPLE_ASSIGN
powerBlock.eta_cycle = P_elec / powerBlock.exchanger.Q_HX
*/
void PhysicalParticleCO21D_eqFunction_4377(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4377};
  data->localData[0]->realVars[1072] /* powerBlock.eta_cycle variable */ = DIVISION_SIM(data->localData[0]->realVars[56] /* P_elec variable */,data->localData[0]->realVars[1074] /* powerBlock.exchanger.Q_HX variable */,"powerBlock.exchanger.Q_HX",equationIndexes);
  TRACE_POP
}
/*
equation index: 4378
type: SIMPLE_ASSIGN
powerBlock.cooler.Q_cooler = powerBlock.cooler.port_b.m_flow * (powerBlock.LTR.h_from_turb[1] - powerBlock.mainCompressor.state_a.h)
*/
void PhysicalParticleCO21D_eqFunction_4378(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4378};
  data->localData[0]->realVars[1068] /* powerBlock.cooler.Q_cooler variable */ = (data->localData[0]->realVars[1071] /* powerBlock.cooler.port_b.m_flow variable */) * (data->localData[0]->realVars[1064] /* powerBlock.LTR.h_from_turb[1] variable */ - data->localData[0]->realVars[1096] /* powerBlock.mainCompressor.state_a.h variable */);
  TRACE_POP
}
/*
equation index: 4379
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[1] = powerBlock.LTR.T_from_turb[2] - powerBlock.HTR.T_from_comp[1]
*/
void PhysicalParticleCO21D_eqFunction_4379(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4379};
  data->localData[0]->realVars[1011] /* powerBlock.HTR.deltaT[1] variable */ = data->localData[0]->realVars[1059] /* powerBlock.LTR.T_from_turb[2] variable */ - data->localData[0]->realVars[981] /* powerBlock.HTR.T_from_comp[1] variable */;
  TRACE_POP
}
/*
equation index: 4380
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[2] = powerBlock.HTR.T_from_turb[2] - powerBlock.HTR.T_from_comp[2]
*/
void PhysicalParticleCO21D_eqFunction_4380(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4380};
  data->localData[0]->realVars[1012] /* powerBlock.HTR.deltaT[2] variable */ = data->localData[0]->realVars[997] /* powerBlock.HTR.T_from_turb[2] variable */ - data->localData[0]->realVars[982] /* powerBlock.HTR.T_from_comp[2] variable */;
  TRACE_POP
}
/*
equation index: 4381
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[4] = powerBlock.HTR.T_from_turb[4] - powerBlock.HTR.T_from_comp[4]
*/
void PhysicalParticleCO21D_eqFunction_4381(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4381};
  data->localData[0]->realVars[1014] /* powerBlock.HTR.deltaT[4] variable */ = data->localData[0]->realVars[999] /* powerBlock.HTR.T_from_turb[4] variable */ - data->localData[0]->realVars[984] /* powerBlock.HTR.T_from_comp[4] variable */;
  TRACE_POP
}
/*
equation index: 4382
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[3] = powerBlock.HTR.T_from_turb[3] - powerBlock.HTR.T_from_comp[3]
*/
void PhysicalParticleCO21D_eqFunction_4382(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4382};
  data->localData[0]->realVars[1013] /* powerBlock.HTR.deltaT[3] variable */ = data->localData[0]->realVars[998] /* powerBlock.HTR.T_from_turb[3] variable */ - data->localData[0]->realVars[983] /* powerBlock.HTR.T_from_comp[3] variable */;
  TRACE_POP
}
/*
equation index: 4383
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[6] = powerBlock.HTR.T_from_turb[6] - powerBlock.HTR.T_from_comp[6]
*/
void PhysicalParticleCO21D_eqFunction_4383(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4383};
  data->localData[0]->realVars[1016] /* powerBlock.HTR.deltaT[6] variable */ = data->localData[0]->realVars[1001] /* powerBlock.HTR.T_from_turb[6] variable */ - data->localData[0]->realVars[986] /* powerBlock.HTR.T_from_comp[6] variable */;
  TRACE_POP
}
/*
equation index: 4384
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[5] = powerBlock.HTR.T_from_turb[5] - powerBlock.HTR.T_from_comp[5]
*/
void PhysicalParticleCO21D_eqFunction_4384(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4384};
  data->localData[0]->realVars[1015] /* powerBlock.HTR.deltaT[5] variable */ = data->localData[0]->realVars[1000] /* powerBlock.HTR.T_from_turb[5] variable */ - data->localData[0]->realVars[985] /* powerBlock.HTR.T_from_comp[5] variable */;
  TRACE_POP
}
/*
equation index: 4385
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[7] = powerBlock.HTR.T_from_turb[7] - powerBlock.HTR.T_from_comp[7]
*/
void PhysicalParticleCO21D_eqFunction_4385(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4385};
  data->localData[0]->realVars[1017] /* powerBlock.HTR.deltaT[7] variable */ = data->localData[0]->realVars[1002] /* powerBlock.HTR.T_from_turb[7] variable */ - data->localData[0]->realVars[987] /* powerBlock.HTR.T_from_comp[7] variable */;
  TRACE_POP
}
/*
equation index: 4386
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[8] = powerBlock.HTR.T_from_turb[8] - powerBlock.HTR.T_from_comp[8]
*/
void PhysicalParticleCO21D_eqFunction_4386(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4386};
  data->localData[0]->realVars[1018] /* powerBlock.HTR.deltaT[8] variable */ = data->localData[0]->realVars[1003] /* powerBlock.HTR.T_from_turb[8] variable */ - data->localData[0]->realVars[988] /* powerBlock.HTR.T_from_comp[8] variable */;
  TRACE_POP
}
/*
equation index: 4387
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[9] = powerBlock.HTR.T_from_turb[9] - powerBlock.HTR.T_from_comp[9]
*/
void PhysicalParticleCO21D_eqFunction_4387(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4387};
  data->localData[0]->realVars[1019] /* powerBlock.HTR.deltaT[9] variable */ = data->localData[0]->realVars[1004] /* powerBlock.HTR.T_from_turb[9] variable */ - data->localData[0]->realVars[989] /* powerBlock.HTR.T_from_comp[9] variable */;
  TRACE_POP
}
/*
equation index: 4388
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[10] = powerBlock.HTR.T_from_turb[10] - powerBlock.HTR.T_from_comp[10]
*/
void PhysicalParticleCO21D_eqFunction_4388(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4388};
  data->localData[0]->realVars[1020] /* powerBlock.HTR.deltaT[10] variable */ = data->localData[0]->realVars[1005] /* powerBlock.HTR.T_from_turb[10] variable */ - data->localData[0]->realVars[990] /* powerBlock.HTR.T_from_comp[10] variable */;
  TRACE_POP
}
/*
equation index: 4389
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[11] = powerBlock.HTR.T_from_turb[11] - powerBlock.HTR.T_from_comp[11]
*/
void PhysicalParticleCO21D_eqFunction_4389(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4389};
  data->localData[0]->realVars[1021] /* powerBlock.HTR.deltaT[11] variable */ = data->localData[0]->realVars[1006] /* powerBlock.HTR.T_from_turb[11] variable */ - data->localData[0]->realVars[991] /* powerBlock.HTR.T_from_comp[11] variable */;
  TRACE_POP
}
/*
equation index: 4390
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[12] = powerBlock.HTR.T_from_turb[12] - powerBlock.HTR.T_from_comp[12]
*/
void PhysicalParticleCO21D_eqFunction_4390(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4390};
  data->localData[0]->realVars[1022] /* powerBlock.HTR.deltaT[12] variable */ = data->localData[0]->realVars[1007] /* powerBlock.HTR.T_from_turb[12] variable */ - data->localData[0]->realVars[992] /* powerBlock.HTR.T_from_comp[12] variable */;
  TRACE_POP
}
/*
equation index: 4391
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[13] = powerBlock.HTR.T_from_turb[13] - powerBlock.HTR.T_from_comp[13]
*/
void PhysicalParticleCO21D_eqFunction_4391(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4391};
  data->localData[0]->realVars[1023] /* powerBlock.HTR.deltaT[13] variable */ = data->localData[0]->realVars[1008] /* powerBlock.HTR.T_from_turb[13] variable */ - data->localData[0]->realVars[993] /* powerBlock.HTR.T_from_comp[13] variable */;
  TRACE_POP
}
/*
equation index: 4392
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[14] = powerBlock.HTR.T_from_turb[14] - powerBlock.HTR.T_from_comp[14]
*/
void PhysicalParticleCO21D_eqFunction_4392(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4392};
  data->localData[0]->realVars[1024] /* powerBlock.HTR.deltaT[14] variable */ = data->localData[0]->realVars[1009] /* powerBlock.HTR.T_from_turb[14] variable */ - data->localData[0]->realVars[994] /* powerBlock.HTR.T_from_comp[14] variable */;
  TRACE_POP
}
/*
equation index: 4393
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[15] = powerBlock.HTR.T_from_turb[15] - powerBlock.HTR.T_from_comp[15]
*/
void PhysicalParticleCO21D_eqFunction_4393(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4393};
  data->localData[0]->realVars[1025] /* powerBlock.HTR.deltaT[15] variable */ = data->localData[0]->realVars[1010] /* powerBlock.HTR.T_from_turb[15] variable */ - data->localData[0]->realVars[995] /* powerBlock.HTR.T_from_comp[15] variable */;
  TRACE_POP
}
/*
equation index: 4394
type: SIMPLE_ASSIGN
powerBlock.fluid_b.h_outflow = if powerBlock.m_sup then powerBlock.exchanger.h_HTF[1] else tankHot.medium.h
*/
void PhysicalParticleCO21D_eqFunction_4394(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4394};
  data->localData[0]->realVars[1087] /* powerBlock.fluid_b.h_outflow variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?data->localData[0]->realVars[1082] /* powerBlock.exchanger.h_HTF[1] variable */:data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */);
  TRACE_POP
}
/*
equation index: 4395
type: SIMPLE_ASSIGN
LiftCold.W_loss = 9.806649999999999 * (-LiftCold.fluid_b.m_flow) * LiftCold.dh * (1.0 - LiftCold.CF) / LiftCold.eff
*/
void PhysicalParticleCO21D_eqFunction_4395(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4395};
  data->localData[0]->realVars[53] /* LiftCold.W_loss variable */ = (9.806649999999999) * (((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */)) * ((data->simulationInfo->realParameter[36] /* LiftCold.dh PARAM */) * (DIVISION_SIM(1.0 - data->simulationInfo->realParameter[35] /* LiftCold.CF PARAM */,data->simulationInfo->realParameter[38] /* LiftCold.eff PARAM */,"LiftCold.eff",equationIndexes))));
  TRACE_POP
}
/*
equation index: 4396
type: SIMPLE_ASSIGN
liftHX.W_loss = 9.806649999999999 * (-LiftCold.fluid_b.m_flow) * liftHX.dh * (1.0 - liftHX.CF) / liftHX.eff
*/
void PhysicalParticleCO21D_eqFunction_4396(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4396};
  data->localData[0]->realVars[100] /* liftHX.W_loss variable */ = (9.806649999999999) * (((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */)) * ((data->simulationInfo->realParameter[170] /* liftHX.dh PARAM */) * (DIVISION_SIM(1.0 - data->simulationInfo->realParameter[169] /* liftHX.CF PARAM */,data->simulationInfo->realParameter[172] /* liftHX.eff PARAM */,"liftHX.eff",equationIndexes))));
  TRACE_POP
}
/*
equation index: 4397
type: SIMPLE_ASSIGN
particleReceiver1D.mdot = if liftRC.use_input then controlHot.m_flow_in else liftRC.m_flow_fixed
*/
void PhysicalParticleCO21D_eqFunction_4397(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4397};
  data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ = (data->simulationInfo->booleanParameter[16] /* liftRC.use_input PARAM */?data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */:data->simulationInfo->realParameter[178] /* liftRC.m_flow_fixed PARAM */);
  TRACE_POP
}
/*
equation index: 4398
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[1] = particleReceiver1D.mdot / (particleReceiver1D.rho_s * particleReceiver1D.W_rcv * particleReceiver1D.vp_in * particleReceiver1D.phi_max)
*/
void PhysicalParticleCO21D_eqFunction_4398(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4398};
  data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */) * (data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */)) * (data->simulationInfo->realParameter[249] /* particleReceiver1D.vp_in PARAM */)) * (data->simulationInfo->realParameter[243] /* particleReceiver1D.phi_max PARAM */),"particleReceiver1D.rho_s * particleReceiver1D.W_rcv * particleReceiver1D.vp_in * particleReceiver1D.phi_max",equationIndexes);
  TRACE_POP
}
/*
equation index: 4399
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[22] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.H_drop_design
*/
void PhysicalParticleCO21D_eqFunction_4399(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4399};
  data->localData[0]->realVars[385] /* particleReceiver1D.t_c[22] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->simulationInfo->realParameter[209] /* particleReceiver1D.H_drop_design PARAM */);
  TRACE_POP
}
/*
equation index: 4400
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[21] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[21]
*/
void PhysicalParticleCO21D_eqFunction_4400(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4400};
  data->localData[0]->realVars[384] /* particleReceiver1D.t_c[21] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[446] /* particleReceiver1D.x[21] variable */);
  TRACE_POP
}
/*
equation index: 4401
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[20] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[20]
*/
void PhysicalParticleCO21D_eqFunction_4401(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4401};
  data->localData[0]->realVars[383] /* particleReceiver1D.t_c[20] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[445] /* particleReceiver1D.x[20] variable */);
  TRACE_POP
}
/*
equation index: 4402
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[19] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[19]
*/
void PhysicalParticleCO21D_eqFunction_4402(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4402};
  data->localData[0]->realVars[382] /* particleReceiver1D.t_c[19] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[444] /* particleReceiver1D.x[19] variable */);
  TRACE_POP
}
/*
equation index: 4403
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[18] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[18]
*/
void PhysicalParticleCO21D_eqFunction_4403(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4403};
  data->localData[0]->realVars[381] /* particleReceiver1D.t_c[18] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[443] /* particleReceiver1D.x[18] variable */);
  TRACE_POP
}
/*
equation index: 4404
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[17] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[17]
*/
void PhysicalParticleCO21D_eqFunction_4404(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4404};
  data->localData[0]->realVars[380] /* particleReceiver1D.t_c[17] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[442] /* particleReceiver1D.x[17] variable */);
  TRACE_POP
}
/*
equation index: 4405
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[16] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[16]
*/
void PhysicalParticleCO21D_eqFunction_4405(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4405};
  data->localData[0]->realVars[379] /* particleReceiver1D.t_c[16] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[441] /* particleReceiver1D.x[16] variable */);
  TRACE_POP
}
/*
equation index: 4406
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[15] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[15]
*/
void PhysicalParticleCO21D_eqFunction_4406(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4406};
  data->localData[0]->realVars[378] /* particleReceiver1D.t_c[15] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[440] /* particleReceiver1D.x[15] variable */);
  TRACE_POP
}
/*
equation index: 4407
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[14] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[14]
*/
void PhysicalParticleCO21D_eqFunction_4407(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4407};
  data->localData[0]->realVars[377] /* particleReceiver1D.t_c[14] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[439] /* particleReceiver1D.x[14] variable */);
  TRACE_POP
}
/*
equation index: 4408
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[13] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[13]
*/
void PhysicalParticleCO21D_eqFunction_4408(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4408};
  data->localData[0]->realVars[376] /* particleReceiver1D.t_c[13] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[438] /* particleReceiver1D.x[13] variable */);
  TRACE_POP
}
/*
equation index: 4409
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[12] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[12]
*/
void PhysicalParticleCO21D_eqFunction_4409(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4409};
  data->localData[0]->realVars[375] /* particleReceiver1D.t_c[12] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[437] /* particleReceiver1D.x[12] variable */);
  TRACE_POP
}
/*
equation index: 4410
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[11] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[11]
*/
void PhysicalParticleCO21D_eqFunction_4410(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4410};
  data->localData[0]->realVars[374] /* particleReceiver1D.t_c[11] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[436] /* particleReceiver1D.x[11] variable */);
  TRACE_POP
}
/*
equation index: 4411
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[10] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[10]
*/
void PhysicalParticleCO21D_eqFunction_4411(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4411};
  data->localData[0]->realVars[373] /* particleReceiver1D.t_c[10] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[435] /* particleReceiver1D.x[10] variable */);
  TRACE_POP
}
/*
equation index: 4412
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[9] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[9]
*/
void PhysicalParticleCO21D_eqFunction_4412(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4412};
  data->localData[0]->realVars[372] /* particleReceiver1D.t_c[9] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[434] /* particleReceiver1D.x[9] variable */);
  TRACE_POP
}
/*
equation index: 4413
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[8] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[8]
*/
void PhysicalParticleCO21D_eqFunction_4413(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4413};
  data->localData[0]->realVars[371] /* particleReceiver1D.t_c[8] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[433] /* particleReceiver1D.x[8] variable */);
  TRACE_POP
}
/*
equation index: 4414
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[7] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[7]
*/
void PhysicalParticleCO21D_eqFunction_4414(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4414};
  data->localData[0]->realVars[370] /* particleReceiver1D.t_c[7] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[432] /* particleReceiver1D.x[7] variable */);
  TRACE_POP
}
/*
equation index: 4415
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[6] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[6]
*/
void PhysicalParticleCO21D_eqFunction_4415(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4415};
  data->localData[0]->realVars[369] /* particleReceiver1D.t_c[6] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[431] /* particleReceiver1D.x[6] variable */);
  TRACE_POP
}
/*
equation index: 4416
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[5] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[5]
*/
void PhysicalParticleCO21D_eqFunction_4416(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4416};
  data->localData[0]->realVars[368] /* particleReceiver1D.t_c[5] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[430] /* particleReceiver1D.x[5] variable */);
  TRACE_POP
}
/*
equation index: 4417
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[4] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[4]
*/
void PhysicalParticleCO21D_eqFunction_4417(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4417};
  data->localData[0]->realVars[367] /* particleReceiver1D.t_c[4] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[429] /* particleReceiver1D.x[4] variable */);
  TRACE_POP
}
/*
equation index: 4418
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[3] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[3]
*/
void PhysicalParticleCO21D_eqFunction_4418(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4418};
  data->localData[0]->realVars[366] /* particleReceiver1D.t_c[3] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[428] /* particleReceiver1D.x[3] variable */);
  TRACE_POP
}
/*
equation index: 4419
type: SIMPLE_ASSIGN
particleReceiver1D.t_c[2] = particleReceiver1D.t_c[1] + 0.008699999999999999 * particleReceiver1D.x[2]
*/
void PhysicalParticleCO21D_eqFunction_4419(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4419};
  data->localData[0]->realVars[365] /* particleReceiver1D.t_c[2] variable */ = data->localData[0]->realVars[364] /* particleReceiver1D.t_c[1] variable */ + (0.008699999999999999) * (data->localData[0]->realVars[427] /* particleReceiver1D.x[2] variable */);
  TRACE_POP
}
/*
equation index: 4420
type: SIMPLE_ASSIGN
particleReceiver1D.phi[21] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[21] * particleReceiver1D.vp[21] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4420(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4420};
  data->localData[0]->realVars[303] /* particleReceiver1D.phi[21] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[384] /* particleReceiver1D.t_c[21] variable */)) * (data->localData[0]->realVars[425] /* particleReceiver1D.vp[21] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[21] * particleReceiver1D.vp[21] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4421
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[20] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[21] * particleReceiver1D.t_c[21] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4421(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4421};
  data->localData[0]->realVars[405] /* particleReceiver1D.tau_c[20] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[303] /* particleReceiver1D.phi[21] variable */) * (DIVISION_SIM(data->localData[0]->realVars[384] /* particleReceiver1D.t_c[21] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4422
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[20] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[21] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[21] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[20])
*/
void PhysicalParticleCO21D_eqFunction_4422(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4422};
  modelica_real tmp4;
  modelica_boolean tmp5;
  modelica_real tmp6;
  tmp5 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp5)
  {
    tmp6 = 0.0;
  }
  else
  {
    tmp4 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp6 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[303] /* particleReceiver1D.phi[21] variable */)),(3.141592653589793) * ((tmp4 * tmp4 * tmp4)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[384] /* particleReceiver1D.t_c[21] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[405] /* particleReceiver1D.tau_c[20] variable */,"1.0 - particleReceiver1D.tau_c[20]",equationIndexes);
  }
  data->localData[0]->realVars[198] /* particleReceiver1D.eps_c[20] variable */ = tmp6;
  TRACE_POP
}
/*
equation index: 4423
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[20] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[21] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[21] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[20])
*/
void PhysicalParticleCO21D_eqFunction_4423(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4423};
  modelica_real tmp8;
  modelica_boolean tmp9;
  modelica_real tmp10;
  tmp9 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp9)
  {
    tmp10 = 0.0;
  }
  else
  {
    tmp8 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp10 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[303] /* particleReceiver1D.phi[21] variable */)),(3.141592653589793) * ((tmp8 * tmp8 * tmp8)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[384] /* particleReceiver1D.t_c[21] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[405] /* particleReceiver1D.tau_c[20] variable */,"1.0 - particleReceiver1D.tau_c[20]",equationIndexes);
  }
  data->localData[0]->realVars[177] /* particleReceiver1D.abs_c[20] variable */ = tmp10;
  TRACE_POP
}
/*
equation index: 4424
type: SIMPLE_ASSIGN
particleReceiver1D.phi[20] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[20] * particleReceiver1D.vp[20] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4424(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4424};
  data->localData[0]->realVars[302] /* particleReceiver1D.phi[20] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[383] /* particleReceiver1D.t_c[20] variable */)) * (data->localData[0]->realVars[424] /* particleReceiver1D.vp[20] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[20] * particleReceiver1D.vp[20] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4425
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[19] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[20] * particleReceiver1D.t_c[20] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4425(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4425};
  data->localData[0]->realVars[404] /* particleReceiver1D.tau_c[19] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[302] /* particleReceiver1D.phi[20] variable */) * (DIVISION_SIM(data->localData[0]->realVars[383] /* particleReceiver1D.t_c[20] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4426
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[19] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[20] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[20] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[19])
*/
void PhysicalParticleCO21D_eqFunction_4426(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4426};
  modelica_real tmp13;
  modelica_boolean tmp14;
  modelica_real tmp15;
  tmp14 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp14)
  {
    tmp15 = 0.0;
  }
  else
  {
    tmp13 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp15 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[302] /* particleReceiver1D.phi[20] variable */)),(3.141592653589793) * ((tmp13 * tmp13 * tmp13)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[383] /* particleReceiver1D.t_c[20] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[404] /* particleReceiver1D.tau_c[19] variable */,"1.0 - particleReceiver1D.tau_c[19]",equationIndexes);
  }
  data->localData[0]->realVars[197] /* particleReceiver1D.eps_c[19] variable */ = tmp15;
  TRACE_POP
}
/*
equation index: 4427
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[19] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[20] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[20] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[19])
*/
void PhysicalParticleCO21D_eqFunction_4427(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4427};
  modelica_real tmp17;
  modelica_boolean tmp18;
  modelica_real tmp19;
  tmp18 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp18)
  {
    tmp19 = 0.0;
  }
  else
  {
    tmp17 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp19 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[302] /* particleReceiver1D.phi[20] variable */)),(3.141592653589793) * ((tmp17 * tmp17 * tmp17)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[383] /* particleReceiver1D.t_c[20] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[404] /* particleReceiver1D.tau_c[19] variable */,"1.0 - particleReceiver1D.tau_c[19]",equationIndexes);
  }
  data->localData[0]->realVars[176] /* particleReceiver1D.abs_c[19] variable */ = tmp19;
  TRACE_POP
}
/*
equation index: 4428
type: SIMPLE_ASSIGN
particleReceiver1D.phi[19] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[19] * particleReceiver1D.vp[19] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4428(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4428};
  data->localData[0]->realVars[301] /* particleReceiver1D.phi[19] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[382] /* particleReceiver1D.t_c[19] variable */)) * (data->localData[0]->realVars[423] /* particleReceiver1D.vp[19] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[19] * particleReceiver1D.vp[19] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4429
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[18] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[19] * particleReceiver1D.t_c[19] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4429(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4429};
  data->localData[0]->realVars[403] /* particleReceiver1D.tau_c[18] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[301] /* particleReceiver1D.phi[19] variable */) * (DIVISION_SIM(data->localData[0]->realVars[382] /* particleReceiver1D.t_c[19] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4430
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[18] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[19] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[19] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[18])
*/
void PhysicalParticleCO21D_eqFunction_4430(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4430};
  modelica_real tmp22;
  modelica_boolean tmp23;
  modelica_real tmp24;
  tmp23 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp23)
  {
    tmp24 = 0.0;
  }
  else
  {
    tmp22 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp24 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[301] /* particleReceiver1D.phi[19] variable */)),(3.141592653589793) * ((tmp22 * tmp22 * tmp22)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[382] /* particleReceiver1D.t_c[19] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[403] /* particleReceiver1D.tau_c[18] variable */,"1.0 - particleReceiver1D.tau_c[18]",equationIndexes);
  }
  data->localData[0]->realVars[196] /* particleReceiver1D.eps_c[18] variable */ = tmp24;
  TRACE_POP
}
/*
equation index: 4431
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[18] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[19] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[19] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[18])
*/
void PhysicalParticleCO21D_eqFunction_4431(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4431};
  modelica_real tmp26;
  modelica_boolean tmp27;
  modelica_real tmp28;
  tmp27 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp27)
  {
    tmp28 = 0.0;
  }
  else
  {
    tmp26 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp28 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[301] /* particleReceiver1D.phi[19] variable */)),(3.141592653589793) * ((tmp26 * tmp26 * tmp26)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[382] /* particleReceiver1D.t_c[19] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[403] /* particleReceiver1D.tau_c[18] variable */,"1.0 - particleReceiver1D.tau_c[18]",equationIndexes);
  }
  data->localData[0]->realVars[175] /* particleReceiver1D.abs_c[18] variable */ = tmp28;
  TRACE_POP
}
/*
equation index: 4432
type: SIMPLE_ASSIGN
particleReceiver1D.phi[18] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[18] * particleReceiver1D.vp[18] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4432(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4432};
  data->localData[0]->realVars[300] /* particleReceiver1D.phi[18] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[381] /* particleReceiver1D.t_c[18] variable */)) * (data->localData[0]->realVars[422] /* particleReceiver1D.vp[18] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[18] * particleReceiver1D.vp[18] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4433
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[17] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[18] * particleReceiver1D.t_c[18] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4433(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4433};
  data->localData[0]->realVars[402] /* particleReceiver1D.tau_c[17] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[300] /* particleReceiver1D.phi[18] variable */) * (DIVISION_SIM(data->localData[0]->realVars[381] /* particleReceiver1D.t_c[18] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4434
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[17] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[18] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[18] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[17])
*/
void PhysicalParticleCO21D_eqFunction_4434(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4434};
  modelica_real tmp31;
  modelica_boolean tmp32;
  modelica_real tmp33;
  tmp32 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp32)
  {
    tmp33 = 0.0;
  }
  else
  {
    tmp31 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp33 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[300] /* particleReceiver1D.phi[18] variable */)),(3.141592653589793) * ((tmp31 * tmp31 * tmp31)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[381] /* particleReceiver1D.t_c[18] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[402] /* particleReceiver1D.tau_c[17] variable */,"1.0 - particleReceiver1D.tau_c[17]",equationIndexes);
  }
  data->localData[0]->realVars[195] /* particleReceiver1D.eps_c[17] variable */ = tmp33;
  TRACE_POP
}
/*
equation index: 4435
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[17] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[18] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[18] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[17])
*/
void PhysicalParticleCO21D_eqFunction_4435(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4435};
  modelica_real tmp35;
  modelica_boolean tmp36;
  modelica_real tmp37;
  tmp36 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp36)
  {
    tmp37 = 0.0;
  }
  else
  {
    tmp35 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp37 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[300] /* particleReceiver1D.phi[18] variable */)),(3.141592653589793) * ((tmp35 * tmp35 * tmp35)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[381] /* particleReceiver1D.t_c[18] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[402] /* particleReceiver1D.tau_c[17] variable */,"1.0 - particleReceiver1D.tau_c[17]",equationIndexes);
  }
  data->localData[0]->realVars[174] /* particleReceiver1D.abs_c[17] variable */ = tmp37;
  TRACE_POP
}
/*
equation index: 4436
type: SIMPLE_ASSIGN
particleReceiver1D.phi[17] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[17] * particleReceiver1D.vp[17] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4436(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4436};
  data->localData[0]->realVars[299] /* particleReceiver1D.phi[17] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[380] /* particleReceiver1D.t_c[17] variable */)) * (data->localData[0]->realVars[421] /* particleReceiver1D.vp[17] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[17] * particleReceiver1D.vp[17] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4437
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[16] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[17] * particleReceiver1D.t_c[17] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4437(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4437};
  data->localData[0]->realVars[401] /* particleReceiver1D.tau_c[16] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[299] /* particleReceiver1D.phi[17] variable */) * (DIVISION_SIM(data->localData[0]->realVars[380] /* particleReceiver1D.t_c[17] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4438
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[16] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[17] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[17] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[16])
*/
void PhysicalParticleCO21D_eqFunction_4438(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4438};
  modelica_real tmp40;
  modelica_boolean tmp41;
  modelica_real tmp42;
  tmp41 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp41)
  {
    tmp42 = 0.0;
  }
  else
  {
    tmp40 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp42 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[299] /* particleReceiver1D.phi[17] variable */)),(3.141592653589793) * ((tmp40 * tmp40 * tmp40)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[380] /* particleReceiver1D.t_c[17] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[401] /* particleReceiver1D.tau_c[16] variable */,"1.0 - particleReceiver1D.tau_c[16]",equationIndexes);
  }
  data->localData[0]->realVars[194] /* particleReceiver1D.eps_c[16] variable */ = tmp42;
  TRACE_POP
}
/*
equation index: 4439
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[16] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[17] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[17] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[16])
*/
void PhysicalParticleCO21D_eqFunction_4439(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4439};
  modelica_real tmp44;
  modelica_boolean tmp45;
  modelica_real tmp46;
  tmp45 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp45)
  {
    tmp46 = 0.0;
  }
  else
  {
    tmp44 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp46 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[299] /* particleReceiver1D.phi[17] variable */)),(3.141592653589793) * ((tmp44 * tmp44 * tmp44)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[380] /* particleReceiver1D.t_c[17] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[401] /* particleReceiver1D.tau_c[16] variable */,"1.0 - particleReceiver1D.tau_c[16]",equationIndexes);
  }
  data->localData[0]->realVars[173] /* particleReceiver1D.abs_c[16] variable */ = tmp46;
  TRACE_POP
}
/*
equation index: 4440
type: SIMPLE_ASSIGN
particleReceiver1D.phi[16] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[16] * particleReceiver1D.vp[16] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4440(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4440};
  data->localData[0]->realVars[298] /* particleReceiver1D.phi[16] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[379] /* particleReceiver1D.t_c[16] variable */)) * (data->localData[0]->realVars[420] /* particleReceiver1D.vp[16] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[16] * particleReceiver1D.vp[16] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4441
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[15] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[16] * particleReceiver1D.t_c[16] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4441(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4441};
  data->localData[0]->realVars[400] /* particleReceiver1D.tau_c[15] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[298] /* particleReceiver1D.phi[16] variable */) * (DIVISION_SIM(data->localData[0]->realVars[379] /* particleReceiver1D.t_c[16] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4442
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[15] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[16] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[16] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[15])
*/
void PhysicalParticleCO21D_eqFunction_4442(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4442};
  modelica_real tmp49;
  modelica_boolean tmp50;
  modelica_real tmp51;
  tmp50 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp50)
  {
    tmp51 = 0.0;
  }
  else
  {
    tmp49 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp51 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[298] /* particleReceiver1D.phi[16] variable */)),(3.141592653589793) * ((tmp49 * tmp49 * tmp49)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[379] /* particleReceiver1D.t_c[16] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[400] /* particleReceiver1D.tau_c[15] variable */,"1.0 - particleReceiver1D.tau_c[15]",equationIndexes);
  }
  data->localData[0]->realVars[193] /* particleReceiver1D.eps_c[15] variable */ = tmp51;
  TRACE_POP
}
/*
equation index: 4443
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[15] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[16] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[16] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[15])
*/
void PhysicalParticleCO21D_eqFunction_4443(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4443};
  modelica_real tmp53;
  modelica_boolean tmp54;
  modelica_real tmp55;
  tmp54 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp54)
  {
    tmp55 = 0.0;
  }
  else
  {
    tmp53 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp55 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[298] /* particleReceiver1D.phi[16] variable */)),(3.141592653589793) * ((tmp53 * tmp53 * tmp53)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[379] /* particleReceiver1D.t_c[16] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[400] /* particleReceiver1D.tau_c[15] variable */,"1.0 - particleReceiver1D.tau_c[15]",equationIndexes);
  }
  data->localData[0]->realVars[172] /* particleReceiver1D.abs_c[15] variable */ = tmp55;
  TRACE_POP
}
/*
equation index: 4444
type: SIMPLE_ASSIGN
particleReceiver1D.phi[15] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[15] * particleReceiver1D.vp[15] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4444(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4444};
  data->localData[0]->realVars[297] /* particleReceiver1D.phi[15] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[378] /* particleReceiver1D.t_c[15] variable */)) * (data->localData[0]->realVars[419] /* particleReceiver1D.vp[15] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[15] * particleReceiver1D.vp[15] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4445
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[14] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[15] * particleReceiver1D.t_c[15] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4445(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4445};
  data->localData[0]->realVars[399] /* particleReceiver1D.tau_c[14] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[297] /* particleReceiver1D.phi[15] variable */) * (DIVISION_SIM(data->localData[0]->realVars[378] /* particleReceiver1D.t_c[15] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4446
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[14] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[15] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[15] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[14])
*/
void PhysicalParticleCO21D_eqFunction_4446(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4446};
  modelica_real tmp58;
  modelica_boolean tmp59;
  modelica_real tmp60;
  tmp59 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp59)
  {
    tmp60 = 0.0;
  }
  else
  {
    tmp58 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp60 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[297] /* particleReceiver1D.phi[15] variable */)),(3.141592653589793) * ((tmp58 * tmp58 * tmp58)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[378] /* particleReceiver1D.t_c[15] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[399] /* particleReceiver1D.tau_c[14] variable */,"1.0 - particleReceiver1D.tau_c[14]",equationIndexes);
  }
  data->localData[0]->realVars[192] /* particleReceiver1D.eps_c[14] variable */ = tmp60;
  TRACE_POP
}
/*
equation index: 4447
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[14] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[15] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[15] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[14])
*/
void PhysicalParticleCO21D_eqFunction_4447(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4447};
  modelica_real tmp62;
  modelica_boolean tmp63;
  modelica_real tmp64;
  tmp63 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp63)
  {
    tmp64 = 0.0;
  }
  else
  {
    tmp62 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp64 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[297] /* particleReceiver1D.phi[15] variable */)),(3.141592653589793) * ((tmp62 * tmp62 * tmp62)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[378] /* particleReceiver1D.t_c[15] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[399] /* particleReceiver1D.tau_c[14] variable */,"1.0 - particleReceiver1D.tau_c[14]",equationIndexes);
  }
  data->localData[0]->realVars[171] /* particleReceiver1D.abs_c[14] variable */ = tmp64;
  TRACE_POP
}
/*
equation index: 4448
type: SIMPLE_ASSIGN
particleReceiver1D.phi[14] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[14] * particleReceiver1D.vp[14] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4448(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4448};
  data->localData[0]->realVars[296] /* particleReceiver1D.phi[14] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[377] /* particleReceiver1D.t_c[14] variable */)) * (data->localData[0]->realVars[418] /* particleReceiver1D.vp[14] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[14] * particleReceiver1D.vp[14] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4449
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[13] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[14] * particleReceiver1D.t_c[14] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4449(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4449};
  data->localData[0]->realVars[398] /* particleReceiver1D.tau_c[13] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[296] /* particleReceiver1D.phi[14] variable */) * (DIVISION_SIM(data->localData[0]->realVars[377] /* particleReceiver1D.t_c[14] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4450
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[13] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[14] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[14] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[13])
*/
void PhysicalParticleCO21D_eqFunction_4450(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4450};
  modelica_real tmp67;
  modelica_boolean tmp68;
  modelica_real tmp69;
  tmp68 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp68)
  {
    tmp69 = 0.0;
  }
  else
  {
    tmp67 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp69 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[296] /* particleReceiver1D.phi[14] variable */)),(3.141592653589793) * ((tmp67 * tmp67 * tmp67)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[377] /* particleReceiver1D.t_c[14] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[398] /* particleReceiver1D.tau_c[13] variable */,"1.0 - particleReceiver1D.tau_c[13]",equationIndexes);
  }
  data->localData[0]->realVars[191] /* particleReceiver1D.eps_c[13] variable */ = tmp69;
  TRACE_POP
}
/*
equation index: 4451
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[13] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[14] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[14] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[13])
*/
void PhysicalParticleCO21D_eqFunction_4451(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4451};
  modelica_real tmp71;
  modelica_boolean tmp72;
  modelica_real tmp73;
  tmp72 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp72)
  {
    tmp73 = 0.0;
  }
  else
  {
    tmp71 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp73 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[296] /* particleReceiver1D.phi[14] variable */)),(3.141592653589793) * ((tmp71 * tmp71 * tmp71)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[377] /* particleReceiver1D.t_c[14] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[398] /* particleReceiver1D.tau_c[13] variable */,"1.0 - particleReceiver1D.tau_c[13]",equationIndexes);
  }
  data->localData[0]->realVars[170] /* particleReceiver1D.abs_c[13] variable */ = tmp73;
  TRACE_POP
}
/*
equation index: 4452
type: SIMPLE_ASSIGN
particleReceiver1D.phi[13] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[13] * particleReceiver1D.vp[13] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4452(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4452};
  data->localData[0]->realVars[295] /* particleReceiver1D.phi[13] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[376] /* particleReceiver1D.t_c[13] variable */)) * (data->localData[0]->realVars[417] /* particleReceiver1D.vp[13] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[13] * particleReceiver1D.vp[13] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4453
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[12] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[13] * particleReceiver1D.t_c[13] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4453(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4453};
  data->localData[0]->realVars[397] /* particleReceiver1D.tau_c[12] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[295] /* particleReceiver1D.phi[13] variable */) * (DIVISION_SIM(data->localData[0]->realVars[376] /* particleReceiver1D.t_c[13] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4454
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[12] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[13] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[13] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[12])
*/
void PhysicalParticleCO21D_eqFunction_4454(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4454};
  modelica_real tmp76;
  modelica_boolean tmp77;
  modelica_real tmp78;
  tmp77 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp77)
  {
    tmp78 = 0.0;
  }
  else
  {
    tmp76 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp78 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[295] /* particleReceiver1D.phi[13] variable */)),(3.141592653589793) * ((tmp76 * tmp76 * tmp76)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[376] /* particleReceiver1D.t_c[13] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[397] /* particleReceiver1D.tau_c[12] variable */,"1.0 - particleReceiver1D.tau_c[12]",equationIndexes);
  }
  data->localData[0]->realVars[190] /* particleReceiver1D.eps_c[12] variable */ = tmp78;
  TRACE_POP
}
/*
equation index: 4455
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[12] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[13] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[13] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[12])
*/
void PhysicalParticleCO21D_eqFunction_4455(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4455};
  modelica_real tmp80;
  modelica_boolean tmp81;
  modelica_real tmp82;
  tmp81 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp81)
  {
    tmp82 = 0.0;
  }
  else
  {
    tmp80 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp82 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[295] /* particleReceiver1D.phi[13] variable */)),(3.141592653589793) * ((tmp80 * tmp80 * tmp80)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[376] /* particleReceiver1D.t_c[13] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[397] /* particleReceiver1D.tau_c[12] variable */,"1.0 - particleReceiver1D.tau_c[12]",equationIndexes);
  }
  data->localData[0]->realVars[169] /* particleReceiver1D.abs_c[12] variable */ = tmp82;
  TRACE_POP
}
/*
equation index: 4456
type: SIMPLE_ASSIGN
particleReceiver1D.phi[12] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[12] * particleReceiver1D.vp[12] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4456(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4456};
  data->localData[0]->realVars[294] /* particleReceiver1D.phi[12] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[375] /* particleReceiver1D.t_c[12] variable */)) * (data->localData[0]->realVars[416] /* particleReceiver1D.vp[12] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[12] * particleReceiver1D.vp[12] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4457
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[11] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[12] * particleReceiver1D.t_c[12] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4457(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4457};
  data->localData[0]->realVars[396] /* particleReceiver1D.tau_c[11] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[294] /* particleReceiver1D.phi[12] variable */) * (DIVISION_SIM(data->localData[0]->realVars[375] /* particleReceiver1D.t_c[12] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4458
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[11] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[12] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[12] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[11])
*/
void PhysicalParticleCO21D_eqFunction_4458(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4458};
  modelica_real tmp85;
  modelica_boolean tmp86;
  modelica_real tmp87;
  tmp86 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp86)
  {
    tmp87 = 0.0;
  }
  else
  {
    tmp85 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp87 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[294] /* particleReceiver1D.phi[12] variable */)),(3.141592653589793) * ((tmp85 * tmp85 * tmp85)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[375] /* particleReceiver1D.t_c[12] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[396] /* particleReceiver1D.tau_c[11] variable */,"1.0 - particleReceiver1D.tau_c[11]",equationIndexes);
  }
  data->localData[0]->realVars[189] /* particleReceiver1D.eps_c[11] variable */ = tmp87;
  TRACE_POP
}
/*
equation index: 4459
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[11] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[12] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[12] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[11])
*/
void PhysicalParticleCO21D_eqFunction_4459(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4459};
  modelica_real tmp89;
  modelica_boolean tmp90;
  modelica_real tmp91;
  tmp90 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp90)
  {
    tmp91 = 0.0;
  }
  else
  {
    tmp89 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp91 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[294] /* particleReceiver1D.phi[12] variable */)),(3.141592653589793) * ((tmp89 * tmp89 * tmp89)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[375] /* particleReceiver1D.t_c[12] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[396] /* particleReceiver1D.tau_c[11] variable */,"1.0 - particleReceiver1D.tau_c[11]",equationIndexes);
  }
  data->localData[0]->realVars[168] /* particleReceiver1D.abs_c[11] variable */ = tmp91;
  TRACE_POP
}
/*
equation index: 4460
type: SIMPLE_ASSIGN
particleReceiver1D.phi[11] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[11] * particleReceiver1D.vp[11] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4460(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4460};
  data->localData[0]->realVars[293] /* particleReceiver1D.phi[11] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[374] /* particleReceiver1D.t_c[11] variable */)) * (data->localData[0]->realVars[415] /* particleReceiver1D.vp[11] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[11] * particleReceiver1D.vp[11] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4461
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[10] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[11] * particleReceiver1D.t_c[11] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4461(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4461};
  data->localData[0]->realVars[395] /* particleReceiver1D.tau_c[10] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[293] /* particleReceiver1D.phi[11] variable */) * (DIVISION_SIM(data->localData[0]->realVars[374] /* particleReceiver1D.t_c[11] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4462
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[10] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[11] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[11] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[10])
*/
void PhysicalParticleCO21D_eqFunction_4462(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4462};
  modelica_real tmp94;
  modelica_boolean tmp95;
  modelica_real tmp96;
  tmp95 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp95)
  {
    tmp96 = 0.0;
  }
  else
  {
    tmp94 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp96 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[293] /* particleReceiver1D.phi[11] variable */)),(3.141592653589793) * ((tmp94 * tmp94 * tmp94)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[374] /* particleReceiver1D.t_c[11] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[395] /* particleReceiver1D.tau_c[10] variable */,"1.0 - particleReceiver1D.tau_c[10]",equationIndexes);
  }
  data->localData[0]->realVars[188] /* particleReceiver1D.eps_c[10] variable */ = tmp96;
  TRACE_POP
}
/*
equation index: 4463
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[10] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[11] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[11] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[10])
*/
void PhysicalParticleCO21D_eqFunction_4463(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4463};
  modelica_real tmp98;
  modelica_boolean tmp99;
  modelica_real tmp100;
  tmp99 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp99)
  {
    tmp100 = 0.0;
  }
  else
  {
    tmp98 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp100 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[293] /* particleReceiver1D.phi[11] variable */)),(3.141592653589793) * ((tmp98 * tmp98 * tmp98)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[374] /* particleReceiver1D.t_c[11] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[395] /* particleReceiver1D.tau_c[10] variable */,"1.0 - particleReceiver1D.tau_c[10]",equationIndexes);
  }
  data->localData[0]->realVars[167] /* particleReceiver1D.abs_c[10] variable */ = tmp100;
  TRACE_POP
}
/*
equation index: 4464
type: SIMPLE_ASSIGN
particleReceiver1D.phi[10] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[10] * particleReceiver1D.vp[10] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4464(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4464};
  data->localData[0]->realVars[292] /* particleReceiver1D.phi[10] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[373] /* particleReceiver1D.t_c[10] variable */)) * (data->localData[0]->realVars[414] /* particleReceiver1D.vp[10] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[10] * particleReceiver1D.vp[10] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4465
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[9] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[10] * particleReceiver1D.t_c[10] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4465(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4465};
  data->localData[0]->realVars[394] /* particleReceiver1D.tau_c[9] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[292] /* particleReceiver1D.phi[10] variable */) * (DIVISION_SIM(data->localData[0]->realVars[373] /* particleReceiver1D.t_c[10] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4466
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[9] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[10] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[10] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[9])
*/
void PhysicalParticleCO21D_eqFunction_4466(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4466};
  modelica_real tmp103;
  modelica_boolean tmp104;
  modelica_real tmp105;
  tmp104 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp104)
  {
    tmp105 = 0.0;
  }
  else
  {
    tmp103 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp105 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[292] /* particleReceiver1D.phi[10] variable */)),(3.141592653589793) * ((tmp103 * tmp103 * tmp103)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[373] /* particleReceiver1D.t_c[10] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[394] /* particleReceiver1D.tau_c[9] variable */,"1.0 - particleReceiver1D.tau_c[9]",equationIndexes);
  }
  data->localData[0]->realVars[187] /* particleReceiver1D.eps_c[9] variable */ = tmp105;
  TRACE_POP
}
/*
equation index: 4467
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[9] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[10] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[10] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[9])
*/
void PhysicalParticleCO21D_eqFunction_4467(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4467};
  modelica_real tmp107;
  modelica_boolean tmp108;
  modelica_real tmp109;
  tmp108 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp108)
  {
    tmp109 = 0.0;
  }
  else
  {
    tmp107 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp109 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[292] /* particleReceiver1D.phi[10] variable */)),(3.141592653589793) * ((tmp107 * tmp107 * tmp107)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[373] /* particleReceiver1D.t_c[10] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[394] /* particleReceiver1D.tau_c[9] variable */,"1.0 - particleReceiver1D.tau_c[9]",equationIndexes);
  }
  data->localData[0]->realVars[166] /* particleReceiver1D.abs_c[9] variable */ = tmp109;
  TRACE_POP
}
/*
equation index: 4468
type: SIMPLE_ASSIGN
particleReceiver1D.phi[9] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[9] * particleReceiver1D.vp[9] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4468(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4468};
  data->localData[0]->realVars[291] /* particleReceiver1D.phi[9] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[372] /* particleReceiver1D.t_c[9] variable */)) * (data->localData[0]->realVars[413] /* particleReceiver1D.vp[9] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[9] * particleReceiver1D.vp[9] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4469
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[8] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[9] * particleReceiver1D.t_c[9] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4469(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4469};
  data->localData[0]->realVars[393] /* particleReceiver1D.tau_c[8] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[291] /* particleReceiver1D.phi[9] variable */) * (DIVISION_SIM(data->localData[0]->realVars[372] /* particleReceiver1D.t_c[9] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4470
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[8] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[9] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[9] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[8])
*/
void PhysicalParticleCO21D_eqFunction_4470(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4470};
  modelica_real tmp112;
  modelica_boolean tmp113;
  modelica_real tmp114;
  tmp113 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp113)
  {
    tmp114 = 0.0;
  }
  else
  {
    tmp112 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp114 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[291] /* particleReceiver1D.phi[9] variable */)),(3.141592653589793) * ((tmp112 * tmp112 * tmp112)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[372] /* particleReceiver1D.t_c[9] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[393] /* particleReceiver1D.tau_c[8] variable */,"1.0 - particleReceiver1D.tau_c[8]",equationIndexes);
  }
  data->localData[0]->realVars[186] /* particleReceiver1D.eps_c[8] variable */ = tmp114;
  TRACE_POP
}
/*
equation index: 4471
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[8] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[9] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[9] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[8])
*/
void PhysicalParticleCO21D_eqFunction_4471(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4471};
  modelica_real tmp116;
  modelica_boolean tmp117;
  modelica_real tmp118;
  tmp117 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp117)
  {
    tmp118 = 0.0;
  }
  else
  {
    tmp116 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp118 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[291] /* particleReceiver1D.phi[9] variable */)),(3.141592653589793) * ((tmp116 * tmp116 * tmp116)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[372] /* particleReceiver1D.t_c[9] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[393] /* particleReceiver1D.tau_c[8] variable */,"1.0 - particleReceiver1D.tau_c[8]",equationIndexes);
  }
  data->localData[0]->realVars[165] /* particleReceiver1D.abs_c[8] variable */ = tmp118;
  TRACE_POP
}
/*
equation index: 4472
type: SIMPLE_ASSIGN
particleReceiver1D.phi[8] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[8] * particleReceiver1D.vp[8] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4472(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4472};
  data->localData[0]->realVars[290] /* particleReceiver1D.phi[8] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[371] /* particleReceiver1D.t_c[8] variable */)) * (data->localData[0]->realVars[412] /* particleReceiver1D.vp[8] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[8] * particleReceiver1D.vp[8] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4473
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[7] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[8] * particleReceiver1D.t_c[8] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4473(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4473};
  data->localData[0]->realVars[392] /* particleReceiver1D.tau_c[7] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[290] /* particleReceiver1D.phi[8] variable */) * (DIVISION_SIM(data->localData[0]->realVars[371] /* particleReceiver1D.t_c[8] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4474
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[7] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[8] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[8] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[7])
*/
void PhysicalParticleCO21D_eqFunction_4474(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4474};
  modelica_real tmp121;
  modelica_boolean tmp122;
  modelica_real tmp123;
  tmp122 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp122)
  {
    tmp123 = 0.0;
  }
  else
  {
    tmp121 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp123 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[290] /* particleReceiver1D.phi[8] variable */)),(3.141592653589793) * ((tmp121 * tmp121 * tmp121)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[371] /* particleReceiver1D.t_c[8] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[392] /* particleReceiver1D.tau_c[7] variable */,"1.0 - particleReceiver1D.tau_c[7]",equationIndexes);
  }
  data->localData[0]->realVars[185] /* particleReceiver1D.eps_c[7] variable */ = tmp123;
  TRACE_POP
}
/*
equation index: 4475
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[7] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[8] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[8] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[7])
*/
void PhysicalParticleCO21D_eqFunction_4475(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4475};
  modelica_real tmp125;
  modelica_boolean tmp126;
  modelica_real tmp127;
  tmp126 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp126)
  {
    tmp127 = 0.0;
  }
  else
  {
    tmp125 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp127 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[290] /* particleReceiver1D.phi[8] variable */)),(3.141592653589793) * ((tmp125 * tmp125 * tmp125)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[371] /* particleReceiver1D.t_c[8] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[392] /* particleReceiver1D.tau_c[7] variable */,"1.0 - particleReceiver1D.tau_c[7]",equationIndexes);
  }
  data->localData[0]->realVars[164] /* particleReceiver1D.abs_c[7] variable */ = tmp127;
  TRACE_POP
}
/*
equation index: 4476
type: SIMPLE_ASSIGN
particleReceiver1D.phi[7] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[7] * particleReceiver1D.vp[7] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4476(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4476};
  data->localData[0]->realVars[289] /* particleReceiver1D.phi[7] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[370] /* particleReceiver1D.t_c[7] variable */)) * (data->localData[0]->realVars[411] /* particleReceiver1D.vp[7] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[7] * particleReceiver1D.vp[7] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4477
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[6] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[7] * particleReceiver1D.t_c[7] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4477(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4477};
  data->localData[0]->realVars[391] /* particleReceiver1D.tau_c[6] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[289] /* particleReceiver1D.phi[7] variable */) * (DIVISION_SIM(data->localData[0]->realVars[370] /* particleReceiver1D.t_c[7] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4478
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[6] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[7] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[7] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[6])
*/
void PhysicalParticleCO21D_eqFunction_4478(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4478};
  modelica_real tmp130;
  modelica_boolean tmp131;
  modelica_real tmp132;
  tmp131 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp131)
  {
    tmp132 = 0.0;
  }
  else
  {
    tmp130 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp132 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[289] /* particleReceiver1D.phi[7] variable */)),(3.141592653589793) * ((tmp130 * tmp130 * tmp130)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[370] /* particleReceiver1D.t_c[7] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[391] /* particleReceiver1D.tau_c[6] variable */,"1.0 - particleReceiver1D.tau_c[6]",equationIndexes);
  }
  data->localData[0]->realVars[184] /* particleReceiver1D.eps_c[6] variable */ = tmp132;
  TRACE_POP
}
/*
equation index: 4479
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[6] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[7] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[7] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[6])
*/
void PhysicalParticleCO21D_eqFunction_4479(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4479};
  modelica_real tmp134;
  modelica_boolean tmp135;
  modelica_real tmp136;
  tmp135 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp135)
  {
    tmp136 = 0.0;
  }
  else
  {
    tmp134 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp136 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[289] /* particleReceiver1D.phi[7] variable */)),(3.141592653589793) * ((tmp134 * tmp134 * tmp134)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[370] /* particleReceiver1D.t_c[7] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[391] /* particleReceiver1D.tau_c[6] variable */,"1.0 - particleReceiver1D.tau_c[6]",equationIndexes);
  }
  data->localData[0]->realVars[163] /* particleReceiver1D.abs_c[6] variable */ = tmp136;
  TRACE_POP
}
/*
equation index: 4480
type: SIMPLE_ASSIGN
particleReceiver1D.phi[6] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[6] * particleReceiver1D.vp[6] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4480(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4480};
  data->localData[0]->realVars[288] /* particleReceiver1D.phi[6] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[369] /* particleReceiver1D.t_c[6] variable */)) * (data->localData[0]->realVars[410] /* particleReceiver1D.vp[6] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[6] * particleReceiver1D.vp[6] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4481
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[5] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[6] * particleReceiver1D.t_c[6] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4481(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4481};
  data->localData[0]->realVars[390] /* particleReceiver1D.tau_c[5] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[288] /* particleReceiver1D.phi[6] variable */) * (DIVISION_SIM(data->localData[0]->realVars[369] /* particleReceiver1D.t_c[6] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4482
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[5] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[6] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[6] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[5])
*/
void PhysicalParticleCO21D_eqFunction_4482(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4482};
  modelica_real tmp139;
  modelica_boolean tmp140;
  modelica_real tmp141;
  tmp140 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp140)
  {
    tmp141 = 0.0;
  }
  else
  {
    tmp139 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp141 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[288] /* particleReceiver1D.phi[6] variable */)),(3.141592653589793) * ((tmp139 * tmp139 * tmp139)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[369] /* particleReceiver1D.t_c[6] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[390] /* particleReceiver1D.tau_c[5] variable */,"1.0 - particleReceiver1D.tau_c[5]",equationIndexes);
  }
  data->localData[0]->realVars[183] /* particleReceiver1D.eps_c[5] variable */ = tmp141;
  TRACE_POP
}
/*
equation index: 4483
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[5] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[6] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[6] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[5])
*/
void PhysicalParticleCO21D_eqFunction_4483(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4483};
  modelica_real tmp143;
  modelica_boolean tmp144;
  modelica_real tmp145;
  tmp144 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp144)
  {
    tmp145 = 0.0;
  }
  else
  {
    tmp143 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp145 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[288] /* particleReceiver1D.phi[6] variable */)),(3.141592653589793) * ((tmp143 * tmp143 * tmp143)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[369] /* particleReceiver1D.t_c[6] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[390] /* particleReceiver1D.tau_c[5] variable */,"1.0 - particleReceiver1D.tau_c[5]",equationIndexes);
  }
  data->localData[0]->realVars[162] /* particleReceiver1D.abs_c[5] variable */ = tmp145;
  TRACE_POP
}
/*
equation index: 4484
type: SIMPLE_ASSIGN
particleReceiver1D.phi[5] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[5] * particleReceiver1D.vp[5] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4484(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4484};
  data->localData[0]->realVars[287] /* particleReceiver1D.phi[5] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[368] /* particleReceiver1D.t_c[5] variable */)) * (data->localData[0]->realVars[409] /* particleReceiver1D.vp[5] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[5] * particleReceiver1D.vp[5] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4485
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[4] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[5] * particleReceiver1D.t_c[5] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4485(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4485};
  data->localData[0]->realVars[389] /* particleReceiver1D.tau_c[4] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[287] /* particleReceiver1D.phi[5] variable */) * (DIVISION_SIM(data->localData[0]->realVars[368] /* particleReceiver1D.t_c[5] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4486
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[4] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[5] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[5] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[4])
*/
void PhysicalParticleCO21D_eqFunction_4486(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4486};
  modelica_real tmp148;
  modelica_boolean tmp149;
  modelica_real tmp150;
  tmp149 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp149)
  {
    tmp150 = 0.0;
  }
  else
  {
    tmp148 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp150 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[287] /* particleReceiver1D.phi[5] variable */)),(3.141592653589793) * ((tmp148 * tmp148 * tmp148)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[368] /* particleReceiver1D.t_c[5] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[389] /* particleReceiver1D.tau_c[4] variable */,"1.0 - particleReceiver1D.tau_c[4]",equationIndexes);
  }
  data->localData[0]->realVars[182] /* particleReceiver1D.eps_c[4] variable */ = tmp150;
  TRACE_POP
}
/*
equation index: 4487
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[4] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[5] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[5] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[4])
*/
void PhysicalParticleCO21D_eqFunction_4487(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4487};
  modelica_real tmp152;
  modelica_boolean tmp153;
  modelica_real tmp154;
  tmp153 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp153)
  {
    tmp154 = 0.0;
  }
  else
  {
    tmp152 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp154 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[287] /* particleReceiver1D.phi[5] variable */)),(3.141592653589793) * ((tmp152 * tmp152 * tmp152)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[368] /* particleReceiver1D.t_c[5] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[389] /* particleReceiver1D.tau_c[4] variable */,"1.0 - particleReceiver1D.tau_c[4]",equationIndexes);
  }
  data->localData[0]->realVars[161] /* particleReceiver1D.abs_c[4] variable */ = tmp154;
  TRACE_POP
}
/*
equation index: 4488
type: SIMPLE_ASSIGN
particleReceiver1D.phi[4] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[4] * particleReceiver1D.vp[4] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4488(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4488};
  data->localData[0]->realVars[286] /* particleReceiver1D.phi[4] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[367] /* particleReceiver1D.t_c[4] variable */)) * (data->localData[0]->realVars[408] /* particleReceiver1D.vp[4] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[4] * particleReceiver1D.vp[4] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4489
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[3] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[4] * particleReceiver1D.t_c[4] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4489(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4489};
  data->localData[0]->realVars[388] /* particleReceiver1D.tau_c[3] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[286] /* particleReceiver1D.phi[4] variable */) * (DIVISION_SIM(data->localData[0]->realVars[367] /* particleReceiver1D.t_c[4] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4490
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[3] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[4] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[4] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[3])
*/
void PhysicalParticleCO21D_eqFunction_4490(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4490};
  modelica_real tmp157;
  modelica_boolean tmp158;
  modelica_real tmp159;
  tmp158 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp158)
  {
    tmp159 = 0.0;
  }
  else
  {
    tmp157 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp159 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[286] /* particleReceiver1D.phi[4] variable */)),(3.141592653589793) * ((tmp157 * tmp157 * tmp157)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[367] /* particleReceiver1D.t_c[4] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[388] /* particleReceiver1D.tau_c[3] variable */,"1.0 - particleReceiver1D.tau_c[3]",equationIndexes);
  }
  data->localData[0]->realVars[181] /* particleReceiver1D.eps_c[3] variable */ = tmp159;
  TRACE_POP
}
/*
equation index: 4491
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[3] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[4] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[4] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[3])
*/
void PhysicalParticleCO21D_eqFunction_4491(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4491};
  modelica_real tmp161;
  modelica_boolean tmp162;
  modelica_real tmp163;
  tmp162 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp162)
  {
    tmp163 = 0.0;
  }
  else
  {
    tmp161 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp163 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[286] /* particleReceiver1D.phi[4] variable */)),(3.141592653589793) * ((tmp161 * tmp161 * tmp161)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[367] /* particleReceiver1D.t_c[4] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[388] /* particleReceiver1D.tau_c[3] variable */,"1.0 - particleReceiver1D.tau_c[3]",equationIndexes);
  }
  data->localData[0]->realVars[160] /* particleReceiver1D.abs_c[3] variable */ = tmp163;
  TRACE_POP
}
/*
equation index: 4492
type: SIMPLE_ASSIGN
particleReceiver1D.phi[3] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[3] * particleReceiver1D.vp[3] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4492(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4492};
  data->localData[0]->realVars[285] /* particleReceiver1D.phi[3] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[366] /* particleReceiver1D.t_c[3] variable */)) * (data->localData[0]->realVars[407] /* particleReceiver1D.vp[3] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[3] * particleReceiver1D.vp[3] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4493
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[2] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[3] * particleReceiver1D.t_c[3] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4493(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4493};
  data->localData[0]->realVars[387] /* particleReceiver1D.tau_c[2] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[285] /* particleReceiver1D.phi[3] variable */) * (DIVISION_SIM(data->localData[0]->realVars[366] /* particleReceiver1D.t_c[3] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4494
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[2] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[3] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[3] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[2])
*/
void PhysicalParticleCO21D_eqFunction_4494(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4494};
  modelica_real tmp166;
  modelica_boolean tmp167;
  modelica_real tmp168;
  tmp167 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp167)
  {
    tmp168 = 0.0;
  }
  else
  {
    tmp166 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp168 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[285] /* particleReceiver1D.phi[3] variable */)),(3.141592653589793) * ((tmp166 * tmp166 * tmp166)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[366] /* particleReceiver1D.t_c[3] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[387] /* particleReceiver1D.tau_c[2] variable */,"1.0 - particleReceiver1D.tau_c[2]",equationIndexes);
  }
  data->localData[0]->realVars[180] /* particleReceiver1D.eps_c[2] variable */ = tmp168;
  TRACE_POP
}
/*
equation index: 4495
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[2] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[3] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[3] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[2])
*/
void PhysicalParticleCO21D_eqFunction_4495(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4495};
  modelica_real tmp170;
  modelica_boolean tmp171;
  modelica_real tmp172;
  tmp171 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp171)
  {
    tmp172 = 0.0;
  }
  else
  {
    tmp170 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp172 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[285] /* particleReceiver1D.phi[3] variable */)),(3.141592653589793) * ((tmp170 * tmp170 * tmp170)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[366] /* particleReceiver1D.t_c[3] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[387] /* particleReceiver1D.tau_c[2] variable */,"1.0 - particleReceiver1D.tau_c[2]",equationIndexes);
  }
  data->localData[0]->realVars[159] /* particleReceiver1D.abs_c[2] variable */ = tmp172;
  TRACE_POP
}
/*
equation index: 4496
type: SIMPLE_ASSIGN
particleReceiver1D.phi[2] = particleReceiver1D.mdot / (particleReceiver1D.W_rcv * particleReceiver1D.t_c[2] * particleReceiver1D.vp[2] * particleReceiver1D.rho_s)
*/
void PhysicalParticleCO21D_eqFunction_4496(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4496};
  data->localData[0]->realVars[284] /* particleReceiver1D.phi[2] variable */ = DIVISION_SIM(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */,(((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->localData[0]->realVars[365] /* particleReceiver1D.t_c[2] variable */)) * (data->localData[0]->realVars[406] /* particleReceiver1D.vp[2] variable */)) * (data->simulationInfo->realParameter[244] /* particleReceiver1D.rho_s PARAM */),"particleReceiver1D.W_rcv * particleReceiver1D.t_c[2] * particleReceiver1D.vp[2] * particleReceiver1D.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4497
type: SIMPLE_ASSIGN
particleReceiver1D.tau_c[1] = if particleReceiver1D.mdot == 0.0 then 0.0 else exp((-1.5) * particleReceiver1D.phi[2] * particleReceiver1D.t_c[2] / (cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p))
*/
void PhysicalParticleCO21D_eqFunction_4497(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4497};
  data->localData[0]->realVars[386] /* particleReceiver1D.tau_c[1] variable */ = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)?0.0:exp((-1.5) * ((data->localData[0]->realVars[284] /* particleReceiver1D.phi[2] variable */) * (DIVISION_SIM(data->localData[0]->realVars[365] /* particleReceiver1D.t_c[2] variable */,(cos(data->simulationInfo->realParameter[247] /* particleReceiver1D.theta_c PARAM */)) * (data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */),"cos(particleReceiver1D.theta_c) * particleReceiver1D.d_p",equationIndexes)))));
  TRACE_POP
}
/*
equation index: 4498
type: SIMPLE_ASSIGN
particleReceiver1D.eps_c[1] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.eps_s * particleReceiver1D.phi[2] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[2] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[1])
*/
void PhysicalParticleCO21D_eqFunction_4498(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4498};
  modelica_real tmp175;
  modelica_boolean tmp176;
  modelica_real tmp177;
  tmp176 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp176)
  {
    tmp177 = 0.0;
  }
  else
  {
    tmp175 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp177 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[237] /* particleReceiver1D.eps_s PARAM */) * (data->localData[0]->realVars[284] /* particleReceiver1D.phi[2] variable */)),(3.141592653589793) * ((tmp175 * tmp175 * tmp175)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[365] /* particleReceiver1D.t_c[2] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[386] /* particleReceiver1D.tau_c[1] variable */,"1.0 - particleReceiver1D.tau_c[1]",equationIndexes);
  }
  data->localData[0]->realVars[179] /* particleReceiver1D.eps_c[1] variable */ = tmp177;
  TRACE_POP
}
/*
equation index: 4499
type: SIMPLE_ASSIGN
particleReceiver1D.abs_c[1] = if particleReceiver1D.mdot == 0.0 then 0.0 else SolarTherm.Models.CSP.CRS.function_1(6.0 * particleReceiver1D.abs_s * particleReceiver1D.phi[2] / (3.141592653589793 * particleReceiver1D.d_p ^ 3.0) * particleReceiver1D.t_c[2] * particleReceiver1D.a) / (1.0 - particleReceiver1D.tau_c[1])
*/
void PhysicalParticleCO21D_eqFunction_4499(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4499};
  modelica_real tmp179;
  modelica_boolean tmp180;
  modelica_real tmp181;
  tmp180 = (modelica_boolean)(data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
  if(tmp180)
  {
    tmp181 = 0.0;
  }
  else
  {
    tmp179 = data->simulationInfo->realParameter[235] /* particleReceiver1D.d_p PARAM */;
    tmp181 = DIVISION_SIM(omc_SolarTherm_Models_CSP_CRS_function__1(threadData, ((DIVISION_SIM((6.0) * ((data->simulationInfo->realParameter[234] /* particleReceiver1D.abs_s PARAM */) * (data->localData[0]->realVars[284] /* particleReceiver1D.phi[2] variable */)),(3.141592653589793) * ((tmp179 * tmp179 * tmp179)),"3.141592653589793 * particleReceiver1D.d_p ^ 3.0",equationIndexes)) * (data->localData[0]->realVars[365] /* particleReceiver1D.t_c[2] variable */)) * (data->simulationInfo->realParameter[233] /* particleReceiver1D.a PARAM */)),1.0 - data->localData[0]->realVars[386] /* particleReceiver1D.tau_c[1] variable */,"1.0 - particleReceiver1D.tau_c[1]",equationIndexes);
  }
  data->localData[0]->realVars[158] /* particleReceiver1D.abs_c[1] variable */ = tmp181;
  TRACE_POP
}
/*
equation index: 4500
type: SIMPLE_ASSIGN
liftRC.W_loss = 9.806649999999999 * particleReceiver1D.mdot * liftRC.dh * (1.0 - liftRC.CF) / liftRC.eff
*/
void PhysicalParticleCO21D_eqFunction_4500(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4500};
  data->localData[0]->realVars[102] /* liftRC.W_loss variable */ = (9.806649999999999) * ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */) * ((data->simulationInfo->realParameter[175] /* liftRC.dh PARAM */) * (DIVISION_SIM(1.0 - data->simulationInfo->realParameter[174] /* liftRC.CF PARAM */,data->simulationInfo->realParameter[177] /* liftRC.eff PARAM */,"liftRC.eff",equationIndexes))));
  TRACE_POP
}
/*
equation index: 4501
type: SIMPLE_ASSIGN
parasities_input.y = heliostatsField.W_loss + liftHX.W_loss + liftRC.W_loss + tankHot.W_loss + tankCold.W_loss
*/
void PhysicalParticleCO21D_eqFunction_4501(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4501};
  data->localData[0]->realVars[104] /* parasities_input.y variable */ = data->localData[0]->realVars[87] /* heliostatsField.W_loss variable */ + data->localData[0]->realVars[100] /* liftHX.W_loss variable */ + data->localData[0]->realVars[102] /* liftRC.W_loss variable */ + data->localData[0]->realVars[1150] /* tankHot.W_loss variable */ + data->localData[0]->realVars[1131] /* tankCold.W_loss variable */;
  TRACE_POP
}
/*
equation index: 4502
type: SIMPLE_ASSIGN
$DER.tankCold.m = (-LiftCold.fluid_b.m_flow) - particleReceiver1D.mdot
*/
void PhysicalParticleCO21D_eqFunction_4502(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4502};
  data->localData[0]->realVars[30] /* der(tankCold.m) STATE_DER */ = (-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */) - data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */;
  TRACE_POP
}
/*
equation index: 4503
type: SIMPLE_ASSIGN
$DER.tankCold.medium.h = (tankCold.Q_losses + tankCold.W_net + (-LiftCold.fluid_b.m_flow) * powerBlock.fluid_b.h_outflow - particleReceiver1D.mdot * tankCold.medium.h - der(tankCold.m) * tankCold.medium.h) / tankCold.m
*/
void PhysicalParticleCO21D_eqFunction_4503(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4503};
  data->localData[0]->realVars[31] /* der(tankCold.medium.h) STATE_DER */ = DIVISION_SIM(data->localData[0]->realVars[1129] /* tankCold.Q_losses variable */ + data->localData[0]->realVars[1132] /* tankCold.W_net variable */ + ((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */)) * (data->localData[0]->realVars[1087] /* powerBlock.fluid_b.h_outflow variable */) - ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */) * (data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */)) - ((data->localData[0]->realVars[30] /* der(tankCold.m) STATE_DER */) * (data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */)),data->localData[0]->realVars[13] /* tankCold.m STATE(1) */,"tankCold.m",equationIndexes);
  TRACE_POP
}
/*
equation index: 4504
type: SIMPLE_ASSIGN
$DER.tankHot.m = particleReceiver1D.mdot + LiftCold.fluid_b.m_flow
*/
void PhysicalParticleCO21D_eqFunction_4504(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4504};
  data->localData[0]->realVars[32] /* der(tankHot.m) STATE_DER */ = data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ + data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */;
  TRACE_POP
}
void PhysicalParticleCO21D_eqFunction_4505(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4506(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4507(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4508(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4509(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4510(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4511(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4512(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4513(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4514(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4515(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4516(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4517(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4518(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4519(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4520(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4521(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4522(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4523(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4524(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4525(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4526(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4527(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4528(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4529(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4530(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4531(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4532(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4533(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4534(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4535(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4536(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4537(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4538(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4539(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4540(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4541(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4542(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4543(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4544(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4545(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4546(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4547(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4548(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4549(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4550(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4551(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4552(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4553(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4554(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4555(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4556(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4557(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4558(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4559(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4560(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4561(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4562(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4563(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4564(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4565(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4566(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4567(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4568(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4569(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4570(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4571(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4572(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4573(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4574(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4575(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4576(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4577(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4578(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4579(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4580(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4581(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4582(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4583(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4584(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4585(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4586(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4587(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4588(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4589(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4590(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4591(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4592(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4593(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4594(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4595(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4596(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4597(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4598(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4599(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4600(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4601(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4602(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4603(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4604(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4605(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4606(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4607(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4608(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4609(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4610(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4611(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4612(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4613(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4614(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4615(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4616(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4617(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4618(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4619(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4620(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4621(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4622(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4623(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4624(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4664(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4663(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4662(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4661(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4660(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4659(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4658(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4657(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4656(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4655(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4654(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4653(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4652(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4651(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4650(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4649(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4648(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4647(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4646(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4645(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4644(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4643(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4642(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4641(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4640(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4639(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4638(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4637(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4636(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4635(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4634(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4633(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4632(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4631(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4630(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4629(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4628(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4627(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4626(DATA*, threadData_t*);
void PhysicalParticleCO21D_eqFunction_4625(DATA*, threadData_t*);
/*
equation index: 4665
indexNonlinear: 44
type: NONLINEAR

vars: {particleReceiver1D.T_s[2], particleReceiver1D.T_s[3], particleReceiver1D.T_w[1], particleReceiver1D.T_s[4], particleReceiver1D.T_s[5], particleReceiver1D.T_s[6], particleReceiver1D.T_s[7], particleReceiver1D.T_s[8], particleReceiver1D.T_s[10], particleReceiver1D.T_s[11], particleReceiver1D.T_s[9], particleReceiver1D.T_s[12], particleReceiver1D.T_s[13], particleReceiver1D.T_s[14], particleReceiver1D.T_s[15], particleReceiver1D.T_s[16], particleReceiver1D.T_s[17], particleReceiver1D.T_s[18], particleReceiver1D.T_s[20], particleReceiver1D.T_s[19], particleReceiver1D.T_s[21], particleReceiver1D.T_w[22], particleReceiver1D.T_w[3], particleReceiver1D.T_w[4], particleReceiver1D.T_w[5], particleReceiver1D.T_w[6], particleReceiver1D.T_w[7], particleReceiver1D.T_w[8], particleReceiver1D.T_w[9], particleReceiver1D.T_w[10], particleReceiver1D.T_w[11], particleReceiver1D.T_w[12], particleReceiver1D.T_w[13], particleReceiver1D.T_w[14], particleReceiver1D.T_w[15], particleReceiver1D.T_w[16], particleReceiver1D.T_w[17], particleReceiver1D.T_w[18], particleReceiver1D.T_w[19], particleReceiver1D.T_w[20]}
eqns: {4505, 4506, 4507, 4508, 4509, 4510, 4511, 4512, 4513, 4514, 4515, 4516, 4517, 4518, 4519, 4520, 4521, 4522, 4523, 4524, 4525, 4526, 4527, 4528, 4529, 4530, 4531, 4532, 4533, 4534, 4535, 4536, 4537, 4538, 4539, 4540, 4541, 4542, 4543, 4544, 4545, 4546, 4547, 4548, 4549, 4550, 4551, 4552, 4553, 4554, 4555, 4556, 4557, 4558, 4559, 4560, 4561, 4562, 4563, 4564, 4565, 4566, 4567, 4568, 4569, 4570, 4571, 4572, 4573, 4574, 4575, 4576, 4577, 4578, 4579, 4580, 4581, 4582, 4583, 4584, 4585, 4586, 4587, 4588, 4589, 4590, 4591, 4592, 4593, 4594, 4595, 4596, 4597, 4598, 4599, 4600, 4601, 4602, 4603, 4604, 4605, 4606, 4607, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4664, 4663, 4662, 4661, 4660, 4659, 4658, 4657, 4656, 4655, 4654, 4653, 4652, 4651, 4650, 4649, 4648, 4647, 4646, 4645, 4644, 4643, 4642, 4641, 4640, 4639, 4638, 4637, 4636, 4635, 4634, 4633, 4632, 4631, 4630, 4629, 4628, 4627, 4626, 4625}
*/
void PhysicalParticleCO21D_eqFunction_4665(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4665};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 4665 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[0] = data->localData[0]->realVars[116] /* particleReceiver1D.T_s[2] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[1] = data->localData[0]->realVars[117] /* particleReceiver1D.T_s[3] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[2] = data->localData[0]->realVars[136] /* particleReceiver1D.T_w[1] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[3] = data->localData[0]->realVars[118] /* particleReceiver1D.T_s[4] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[4] = data->localData[0]->realVars[119] /* particleReceiver1D.T_s[5] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[5] = data->localData[0]->realVars[120] /* particleReceiver1D.T_s[6] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[6] = data->localData[0]->realVars[121] /* particleReceiver1D.T_s[7] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[7] = data->localData[0]->realVars[122] /* particleReceiver1D.T_s[8] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[8] = data->localData[0]->realVars[124] /* particleReceiver1D.T_s[10] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[9] = data->localData[0]->realVars[125] /* particleReceiver1D.T_s[11] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[10] = data->localData[0]->realVars[123] /* particleReceiver1D.T_s[9] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[11] = data->localData[0]->realVars[126] /* particleReceiver1D.T_s[12] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[12] = data->localData[0]->realVars[127] /* particleReceiver1D.T_s[13] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[13] = data->localData[0]->realVars[128] /* particleReceiver1D.T_s[14] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[14] = data->localData[0]->realVars[129] /* particleReceiver1D.T_s[15] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[15] = data->localData[0]->realVars[130] /* particleReceiver1D.T_s[16] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[16] = data->localData[0]->realVars[131] /* particleReceiver1D.T_s[17] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[17] = data->localData[0]->realVars[132] /* particleReceiver1D.T_s[18] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[18] = data->localData[0]->realVars[134] /* particleReceiver1D.T_s[20] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[19] = data->localData[0]->realVars[133] /* particleReceiver1D.T_s[19] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[20] = data->localData[0]->realVars[135] /* particleReceiver1D.T_s[21] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[21] = data->localData[0]->realVars[155] /* particleReceiver1D.T_w[22] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[22] = data->localData[0]->realVars[137] /* particleReceiver1D.T_w[3] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[23] = data->localData[0]->realVars[138] /* particleReceiver1D.T_w[4] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[24] = data->localData[0]->realVars[139] /* particleReceiver1D.T_w[5] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[25] = data->localData[0]->realVars[140] /* particleReceiver1D.T_w[6] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[26] = data->localData[0]->realVars[141] /* particleReceiver1D.T_w[7] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[27] = data->localData[0]->realVars[142] /* particleReceiver1D.T_w[8] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[28] = data->localData[0]->realVars[143] /* particleReceiver1D.T_w[9] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[29] = data->localData[0]->realVars[144] /* particleReceiver1D.T_w[10] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[30] = data->localData[0]->realVars[145] /* particleReceiver1D.T_w[11] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[31] = data->localData[0]->realVars[146] /* particleReceiver1D.T_w[12] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[32] = data->localData[0]->realVars[147] /* particleReceiver1D.T_w[13] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[33] = data->localData[0]->realVars[148] /* particleReceiver1D.T_w[14] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[34] = data->localData[0]->realVars[149] /* particleReceiver1D.T_w[15] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[35] = data->localData[0]->realVars[150] /* particleReceiver1D.T_w[16] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[36] = data->localData[0]->realVars[151] /* particleReceiver1D.T_w[17] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[37] = data->localData[0]->realVars[152] /* particleReceiver1D.T_w[18] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[38] = data->localData[0]->realVars[153] /* particleReceiver1D.T_w[19] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[39] = data->localData[0]->realVars[154] /* particleReceiver1D.T_w[20] variable */;
  retValue = solve_nonlinear_system(data, threadData, 44);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,4665};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 4665 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[116] /* particleReceiver1D.T_s[2] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[0];
  data->localData[0]->realVars[117] /* particleReceiver1D.T_s[3] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[1];
  data->localData[0]->realVars[136] /* particleReceiver1D.T_w[1] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[2];
  data->localData[0]->realVars[118] /* particleReceiver1D.T_s[4] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[3];
  data->localData[0]->realVars[119] /* particleReceiver1D.T_s[5] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[4];
  data->localData[0]->realVars[120] /* particleReceiver1D.T_s[6] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[5];
  data->localData[0]->realVars[121] /* particleReceiver1D.T_s[7] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[6];
  data->localData[0]->realVars[122] /* particleReceiver1D.T_s[8] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[7];
  data->localData[0]->realVars[124] /* particleReceiver1D.T_s[10] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[8];
  data->localData[0]->realVars[125] /* particleReceiver1D.T_s[11] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[9];
  data->localData[0]->realVars[123] /* particleReceiver1D.T_s[9] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[10];
  data->localData[0]->realVars[126] /* particleReceiver1D.T_s[12] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[11];
  data->localData[0]->realVars[127] /* particleReceiver1D.T_s[13] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[12];
  data->localData[0]->realVars[128] /* particleReceiver1D.T_s[14] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[13];
  data->localData[0]->realVars[129] /* particleReceiver1D.T_s[15] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[14];
  data->localData[0]->realVars[130] /* particleReceiver1D.T_s[16] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[15];
  data->localData[0]->realVars[131] /* particleReceiver1D.T_s[17] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[16];
  data->localData[0]->realVars[132] /* particleReceiver1D.T_s[18] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[17];
  data->localData[0]->realVars[134] /* particleReceiver1D.T_s[20] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[18];
  data->localData[0]->realVars[133] /* particleReceiver1D.T_s[19] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[19];
  data->localData[0]->realVars[135] /* particleReceiver1D.T_s[21] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[20];
  data->localData[0]->realVars[155] /* particleReceiver1D.T_w[22] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[21];
  data->localData[0]->realVars[137] /* particleReceiver1D.T_w[3] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[22];
  data->localData[0]->realVars[138] /* particleReceiver1D.T_w[4] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[23];
  data->localData[0]->realVars[139] /* particleReceiver1D.T_w[5] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[24];
  data->localData[0]->realVars[140] /* particleReceiver1D.T_w[6] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[25];
  data->localData[0]->realVars[141] /* particleReceiver1D.T_w[7] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[26];
  data->localData[0]->realVars[142] /* particleReceiver1D.T_w[8] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[27];
  data->localData[0]->realVars[143] /* particleReceiver1D.T_w[9] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[28];
  data->localData[0]->realVars[144] /* particleReceiver1D.T_w[10] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[29];
  data->localData[0]->realVars[145] /* particleReceiver1D.T_w[11] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[30];
  data->localData[0]->realVars[146] /* particleReceiver1D.T_w[12] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[31];
  data->localData[0]->realVars[147] /* particleReceiver1D.T_w[13] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[32];
  data->localData[0]->realVars[148] /* particleReceiver1D.T_w[14] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[33];
  data->localData[0]->realVars[149] /* particleReceiver1D.T_w[15] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[34];
  data->localData[0]->realVars[150] /* particleReceiver1D.T_w[16] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[35];
  data->localData[0]->realVars[151] /* particleReceiver1D.T_w[17] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[36];
  data->localData[0]->realVars[152] /* particleReceiver1D.T_w[18] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[37];
  data->localData[0]->realVars[153] /* particleReceiver1D.T_w[19] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[38];
  data->localData[0]->realVars[154] /* particleReceiver1D.T_w[20] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[39];
  TRACE_POP
}
/*
equation index: 4666
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[1] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[2] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4666(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4666};
  data->localData[0]->realVars[304] /* particleReceiver1D.q_conv_curtain[1] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[116] /* particleReceiver1D.T_s[2] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4667
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[2] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[3] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4667(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4667};
  data->localData[0]->realVars[305] /* particleReceiver1D.q_conv_curtain[2] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[117] /* particleReceiver1D.T_s[3] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4668
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[3] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[4] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4668(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4668};
  data->localData[0]->realVars[306] /* particleReceiver1D.q_conv_curtain[3] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[118] /* particleReceiver1D.T_s[4] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4669
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[4] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[5] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4669(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4669};
  data->localData[0]->realVars[307] /* particleReceiver1D.q_conv_curtain[4] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[119] /* particleReceiver1D.T_s[5] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4670
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[5] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[6] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4670(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4670};
  data->localData[0]->realVars[308] /* particleReceiver1D.q_conv_curtain[5] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[120] /* particleReceiver1D.T_s[6] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4671
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[6] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[7] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4671(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4671};
  data->localData[0]->realVars[309] /* particleReceiver1D.q_conv_curtain[6] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[121] /* particleReceiver1D.T_s[7] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4672
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[7] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[8] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4672(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4672};
  data->localData[0]->realVars[310] /* particleReceiver1D.q_conv_curtain[7] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[122] /* particleReceiver1D.T_s[8] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4673
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[9] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[10] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4673(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4673};
  data->localData[0]->realVars[312] /* particleReceiver1D.q_conv_curtain[9] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[124] /* particleReceiver1D.T_s[10] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4674
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[10] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[11] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4674(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4674};
  data->localData[0]->realVars[313] /* particleReceiver1D.q_conv_curtain[10] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[125] /* particleReceiver1D.T_s[11] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4675
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[8] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[9] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4675(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4675};
  data->localData[0]->realVars[311] /* particleReceiver1D.q_conv_curtain[8] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[123] /* particleReceiver1D.T_s[9] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4676
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[11] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[12] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4676(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4676};
  data->localData[0]->realVars[314] /* particleReceiver1D.q_conv_curtain[11] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[126] /* particleReceiver1D.T_s[12] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4677
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[12] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[13] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4677(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4677};
  data->localData[0]->realVars[315] /* particleReceiver1D.q_conv_curtain[12] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[127] /* particleReceiver1D.T_s[13] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4678
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[13] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[14] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4678(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4678};
  data->localData[0]->realVars[316] /* particleReceiver1D.q_conv_curtain[13] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[128] /* particleReceiver1D.T_s[14] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4679
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[14] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[15] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4679(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4679};
  data->localData[0]->realVars[317] /* particleReceiver1D.q_conv_curtain[14] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[129] /* particleReceiver1D.T_s[15] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4680
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[15] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[16] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4680(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4680};
  data->localData[0]->realVars[318] /* particleReceiver1D.q_conv_curtain[15] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[130] /* particleReceiver1D.T_s[16] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4681
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[16] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[17] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4681(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4681};
  data->localData[0]->realVars[319] /* particleReceiver1D.q_conv_curtain[16] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[131] /* particleReceiver1D.T_s[17] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4682
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[17] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[18] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4682(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4682};
  data->localData[0]->realVars[320] /* particleReceiver1D.q_conv_curtain[17] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[132] /* particleReceiver1D.T_s[18] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4683
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[19] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[20] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4683(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4683};
  data->localData[0]->realVars[322] /* particleReceiver1D.q_conv_curtain[19] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[134] /* particleReceiver1D.T_s[20] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4684
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[18] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[19] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4684(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4684};
  data->localData[0]->realVars[321] /* particleReceiver1D.q_conv_curtain[18] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[133] /* particleReceiver1D.T_s[19] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4685
type: SIMPLE_ASSIGN
particleReceiver1D.Qloss_conv_wall = (particleReceiver1D.q_conv_wall[1] + particleReceiver1D.q_conv_wall[2] + particleReceiver1D.q_conv_wall[3] + particleReceiver1D.q_conv_wall[4] + particleReceiver1D.q_conv_wall[5] + particleReceiver1D.q_conv_wall[6] + particleReceiver1D.q_conv_wall[7] + particleReceiver1D.q_conv_wall[8] + particleReceiver1D.q_conv_wall[9] + particleReceiver1D.q_conv_wall[10] + particleReceiver1D.q_conv_wall[11] + particleReceiver1D.q_conv_wall[12] + particleReceiver1D.q_conv_wall[13] + particleReceiver1D.q_conv_wall[14] + particleReceiver1D.q_conv_wall[15] + particleReceiver1D.q_conv_wall[16] + particleReceiver1D.q_conv_wall[17] + particleReceiver1D.q_conv_wall[18] + particleReceiver1D.q_conv_wall[19] + particleReceiver1D.q_conv_wall[20]) * particleReceiver1D.W_rcv * particleReceiver1D.H_drop_design
*/
void PhysicalParticleCO21D_eqFunction_4685(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4685};
  data->localData[0]->realVars[111] /* particleReceiver1D.Qloss_conv_wall variable */ = (data->localData[0]->realVars[324] /* particleReceiver1D.q_conv_wall[1] variable */ + data->localData[0]->realVars[325] /* particleReceiver1D.q_conv_wall[2] variable */ + data->localData[0]->realVars[326] /* particleReceiver1D.q_conv_wall[3] variable */ + data->localData[0]->realVars[327] /* particleReceiver1D.q_conv_wall[4] variable */ + data->localData[0]->realVars[328] /* particleReceiver1D.q_conv_wall[5] variable */ + data->localData[0]->realVars[329] /* particleReceiver1D.q_conv_wall[6] variable */ + data->localData[0]->realVars[330] /* particleReceiver1D.q_conv_wall[7] variable */ + data->localData[0]->realVars[331] /* particleReceiver1D.q_conv_wall[8] variable */ + data->localData[0]->realVars[332] /* particleReceiver1D.q_conv_wall[9] variable */ + data->localData[0]->realVars[333] /* particleReceiver1D.q_conv_wall[10] variable */ + data->localData[0]->realVars[334] /* particleReceiver1D.q_conv_wall[11] variable */ + data->localData[0]->realVars[335] /* particleReceiver1D.q_conv_wall[12] variable */ + data->localData[0]->realVars[336] /* particleReceiver1D.q_conv_wall[13] variable */ + data->localData[0]->realVars[337] /* particleReceiver1D.q_conv_wall[14] variable */ + data->localData[0]->realVars[338] /* particleReceiver1D.q_conv_wall[15] variable */ + data->localData[0]->realVars[339] /* particleReceiver1D.q_conv_wall[16] variable */ + data->localData[0]->realVars[340] /* particleReceiver1D.q_conv_wall[17] variable */ + data->localData[0]->realVars[341] /* particleReceiver1D.q_conv_wall[18] variable */ + data->localData[0]->realVars[342] /* particleReceiver1D.q_conv_wall[19] variable */ + data->localData[0]->realVars[343] /* particleReceiver1D.q_conv_wall[20] variable */) * ((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->simulationInfo->realParameter[209] /* particleReceiver1D.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4686
type: SIMPLE_ASSIGN
particleReceiver1D.Qgain_gcb = (particleReceiver1D.gc_b[1] + particleReceiver1D.gc_b[2] + particleReceiver1D.gc_b[3] + particleReceiver1D.gc_b[4] + particleReceiver1D.gc_b[5] + particleReceiver1D.gc_b[6] + particleReceiver1D.gc_b[7] + particleReceiver1D.gc_b[8] + particleReceiver1D.gc_b[9] + particleReceiver1D.gc_b[10] + particleReceiver1D.gc_b[11] + particleReceiver1D.gc_b[12] + particleReceiver1D.gc_b[13] + particleReceiver1D.gc_b[14] + particleReceiver1D.gc_b[15] + particleReceiver1D.gc_b[16] + particleReceiver1D.gc_b[17] + particleReceiver1D.gc_b[18] + particleReceiver1D.gc_b[19] + particleReceiver1D.gc_b[20]) * particleReceiver1D.W_rcv * particleReceiver1D.H_drop_design
*/
void PhysicalParticleCO21D_eqFunction_4686(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4686};
  data->localData[0]->realVars[109] /* particleReceiver1D.Qgain_gcb variable */ = (data->localData[0]->realVars[221] /* particleReceiver1D.gc_b[1] variable */ + data->localData[0]->realVars[222] /* particleReceiver1D.gc_b[2] variable */ + data->localData[0]->realVars[223] /* particleReceiver1D.gc_b[3] variable */ + data->localData[0]->realVars[224] /* particleReceiver1D.gc_b[4] variable */ + data->localData[0]->realVars[225] /* particleReceiver1D.gc_b[5] variable */ + data->localData[0]->realVars[226] /* particleReceiver1D.gc_b[6] variable */ + data->localData[0]->realVars[227] /* particleReceiver1D.gc_b[7] variable */ + data->localData[0]->realVars[228] /* particleReceiver1D.gc_b[8] variable */ + data->localData[0]->realVars[229] /* particleReceiver1D.gc_b[9] variable */ + data->localData[0]->realVars[230] /* particleReceiver1D.gc_b[10] variable */ + data->localData[0]->realVars[231] /* particleReceiver1D.gc_b[11] variable */ + data->localData[0]->realVars[232] /* particleReceiver1D.gc_b[12] variable */ + data->localData[0]->realVars[233] /* particleReceiver1D.gc_b[13] variable */ + data->localData[0]->realVars[234] /* particleReceiver1D.gc_b[14] variable */ + data->localData[0]->realVars[235] /* particleReceiver1D.gc_b[15] variable */ + data->localData[0]->realVars[236] /* particleReceiver1D.gc_b[16] variable */ + data->localData[0]->realVars[237] /* particleReceiver1D.gc_b[17] variable */ + data->localData[0]->realVars[238] /* particleReceiver1D.gc_b[18] variable */ + data->localData[0]->realVars[239] /* particleReceiver1D.gc_b[19] variable */ + data->localData[0]->realVars[240] /* particleReceiver1D.gc_b[20] variable */) * ((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->simulationInfo->realParameter[209] /* particleReceiver1D.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4687
type: SIMPLE_ASSIGN
simpleReceiverControl.T_out_receiver = SolarTherm.Media.SolidParticles.CarboHSP_utilities.T_h(particleReceiver1D.h_s[21])
*/
void PhysicalParticleCO21D_eqFunction_4687(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4687};
  data->localData[0]->realVars[1118] /* simpleReceiverControl.T_out_receiver variable */ = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData, data->localData[0]->realVars[262] /* particleReceiver1D.h_s[21] variable */);
  TRACE_POP
}
/*
equation index: 4688
type: SIMPLE_ASSIGN
particleReceiver1D.Qloss_jcf = (particleReceiver1D.jc_f[1] + particleReceiver1D.jc_f[2] + particleReceiver1D.jc_f[3] + particleReceiver1D.jc_f[4] + particleReceiver1D.jc_f[5] + particleReceiver1D.jc_f[6] + particleReceiver1D.jc_f[7] + particleReceiver1D.jc_f[8] + particleReceiver1D.jc_f[9] + particleReceiver1D.jc_f[10] + particleReceiver1D.jc_f[11] + particleReceiver1D.jc_f[12] + particleReceiver1D.jc_f[13] + particleReceiver1D.jc_f[14] + particleReceiver1D.jc_f[15] + particleReceiver1D.jc_f[16] + particleReceiver1D.jc_f[17] + particleReceiver1D.jc_f[18] + particleReceiver1D.jc_f[19] + particleReceiver1D.jc_f[20]) * particleReceiver1D.W_rcv * particleReceiver1D.H_drop_design
*/
void PhysicalParticleCO21D_eqFunction_4688(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4688};
  data->localData[0]->realVars[113] /* particleReceiver1D.Qloss_jcf variable */ = (data->localData[0]->realVars[263] /* particleReceiver1D.jc_f[1] variable */ + data->localData[0]->realVars[264] /* particleReceiver1D.jc_f[2] variable */ + data->localData[0]->realVars[265] /* particleReceiver1D.jc_f[3] variable */ + data->localData[0]->realVars[266] /* particleReceiver1D.jc_f[4] variable */ + data->localData[0]->realVars[267] /* particleReceiver1D.jc_f[5] variable */ + data->localData[0]->realVars[268] /* particleReceiver1D.jc_f[6] variable */ + data->localData[0]->realVars[269] /* particleReceiver1D.jc_f[7] variable */ + data->localData[0]->realVars[270] /* particleReceiver1D.jc_f[8] variable */ + data->localData[0]->realVars[271] /* particleReceiver1D.jc_f[9] variable */ + data->localData[0]->realVars[272] /* particleReceiver1D.jc_f[10] variable */ + data->localData[0]->realVars[273] /* particleReceiver1D.jc_f[11] variable */ + data->localData[0]->realVars[274] /* particleReceiver1D.jc_f[12] variable */ + data->localData[0]->realVars[275] /* particleReceiver1D.jc_f[13] variable */ + data->localData[0]->realVars[276] /* particleReceiver1D.jc_f[14] variable */ + data->localData[0]->realVars[277] /* particleReceiver1D.jc_f[15] variable */ + data->localData[0]->realVars[278] /* particleReceiver1D.jc_f[16] variable */ + data->localData[0]->realVars[279] /* particleReceiver1D.jc_f[17] variable */ + data->localData[0]->realVars[280] /* particleReceiver1D.jc_f[18] variable */ + data->localData[0]->realVars[281] /* particleReceiver1D.jc_f[19] variable */ + data->localData[0]->realVars[282] /* particleReceiver1D.jc_f[20] variable */) * ((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->simulationInfo->realParameter[209] /* particleReceiver1D.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4689
type: SIMPLE_ASSIGN
particleReceiver1D.q_conv_curtain[20] = particleReceiver1D.h_conv * (particleReceiver1D.T_s[21] - particleReceiver1D.Tamb)
*/
void PhysicalParticleCO21D_eqFunction_4689(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4689};
  data->localData[0]->realVars[323] /* particleReceiver1D.q_conv_curtain[20] variable */ = (data->simulationInfo->realParameter[240] /* particleReceiver1D.h_conv PARAM */) * (data->localData[0]->realVars[135] /* particleReceiver1D.T_s[21] variable */ - data->localData[0]->realVars[156] /* particleReceiver1D.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4690
type: SIMPLE_ASSIGN
particleReceiver1D.Qloss_conv_curtain = (particleReceiver1D.q_conv_curtain[1] + particleReceiver1D.q_conv_curtain[2] + particleReceiver1D.q_conv_curtain[3] + particleReceiver1D.q_conv_curtain[4] + particleReceiver1D.q_conv_curtain[5] + particleReceiver1D.q_conv_curtain[6] + particleReceiver1D.q_conv_curtain[7] + particleReceiver1D.q_conv_curtain[8] + particleReceiver1D.q_conv_curtain[9] + particleReceiver1D.q_conv_curtain[10] + particleReceiver1D.q_conv_curtain[11] + particleReceiver1D.q_conv_curtain[12] + particleReceiver1D.q_conv_curtain[13] + particleReceiver1D.q_conv_curtain[14] + particleReceiver1D.q_conv_curtain[15] + particleReceiver1D.q_conv_curtain[16] + particleReceiver1D.q_conv_curtain[17] + particleReceiver1D.q_conv_curtain[18] + particleReceiver1D.q_conv_curtain[19] + particleReceiver1D.q_conv_curtain[20]) * particleReceiver1D.W_rcv * particleReceiver1D.H_drop_design
*/
void PhysicalParticleCO21D_eqFunction_4690(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4690};
  data->localData[0]->realVars[110] /* particleReceiver1D.Qloss_conv_curtain variable */ = (data->localData[0]->realVars[304] /* particleReceiver1D.q_conv_curtain[1] variable */ + data->localData[0]->realVars[305] /* particleReceiver1D.q_conv_curtain[2] variable */ + data->localData[0]->realVars[306] /* particleReceiver1D.q_conv_curtain[3] variable */ + data->localData[0]->realVars[307] /* particleReceiver1D.q_conv_curtain[4] variable */ + data->localData[0]->realVars[308] /* particleReceiver1D.q_conv_curtain[5] variable */ + data->localData[0]->realVars[309] /* particleReceiver1D.q_conv_curtain[6] variable */ + data->localData[0]->realVars[310] /* particleReceiver1D.q_conv_curtain[7] variable */ + data->localData[0]->realVars[311] /* particleReceiver1D.q_conv_curtain[8] variable */ + data->localData[0]->realVars[312] /* particleReceiver1D.q_conv_curtain[9] variable */ + data->localData[0]->realVars[313] /* particleReceiver1D.q_conv_curtain[10] variable */ + data->localData[0]->realVars[314] /* particleReceiver1D.q_conv_curtain[11] variable */ + data->localData[0]->realVars[315] /* particleReceiver1D.q_conv_curtain[12] variable */ + data->localData[0]->realVars[316] /* particleReceiver1D.q_conv_curtain[13] variable */ + data->localData[0]->realVars[317] /* particleReceiver1D.q_conv_curtain[14] variable */ + data->localData[0]->realVars[318] /* particleReceiver1D.q_conv_curtain[15] variable */ + data->localData[0]->realVars[319] /* particleReceiver1D.q_conv_curtain[16] variable */ + data->localData[0]->realVars[320] /* particleReceiver1D.q_conv_curtain[17] variable */ + data->localData[0]->realVars[321] /* particleReceiver1D.q_conv_curtain[18] variable */ + data->localData[0]->realVars[322] /* particleReceiver1D.q_conv_curtain[19] variable */ + data->localData[0]->realVars[323] /* particleReceiver1D.q_conv_curtain[20] variable */) * ((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->simulationInfo->realParameter[209] /* particleReceiver1D.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4691
type: SIMPLE_ASSIGN
particleReceiver1D.Qloss_jcb = (particleReceiver1D.g_w[1] + particleReceiver1D.g_w[2] + particleReceiver1D.g_w[3] + particleReceiver1D.g_w[4] + particleReceiver1D.g_w[5] + particleReceiver1D.g_w[6] + particleReceiver1D.g_w[7] + particleReceiver1D.g_w[8] + particleReceiver1D.g_w[9] + particleReceiver1D.g_w[10] + particleReceiver1D.g_w[11] + particleReceiver1D.g_w[12] + particleReceiver1D.g_w[13] + particleReceiver1D.g_w[14] + particleReceiver1D.g_w[15] + particleReceiver1D.g_w[16] + particleReceiver1D.g_w[17] + particleReceiver1D.g_w[18] + particleReceiver1D.g_w[19] + particleReceiver1D.g_w[20]) * particleReceiver1D.W_rcv * particleReceiver1D.H_drop_design
*/
void PhysicalParticleCO21D_eqFunction_4691(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4691};
  data->localData[0]->realVars[112] /* particleReceiver1D.Qloss_jcb variable */ = (data->localData[0]->realVars[201] /* particleReceiver1D.g_w[1] variable */ + data->localData[0]->realVars[202] /* particleReceiver1D.g_w[2] variable */ + data->localData[0]->realVars[203] /* particleReceiver1D.g_w[3] variable */ + data->localData[0]->realVars[204] /* particleReceiver1D.g_w[4] variable */ + data->localData[0]->realVars[205] /* particleReceiver1D.g_w[5] variable */ + data->localData[0]->realVars[206] /* particleReceiver1D.g_w[6] variable */ + data->localData[0]->realVars[207] /* particleReceiver1D.g_w[7] variable */ + data->localData[0]->realVars[208] /* particleReceiver1D.g_w[8] variable */ + data->localData[0]->realVars[209] /* particleReceiver1D.g_w[9] variable */ + data->localData[0]->realVars[210] /* particleReceiver1D.g_w[10] variable */ + data->localData[0]->realVars[211] /* particleReceiver1D.g_w[11] variable */ + data->localData[0]->realVars[212] /* particleReceiver1D.g_w[12] variable */ + data->localData[0]->realVars[213] /* particleReceiver1D.g_w[13] variable */ + data->localData[0]->realVars[214] /* particleReceiver1D.g_w[14] variable */ + data->localData[0]->realVars[215] /* particleReceiver1D.g_w[15] variable */ + data->localData[0]->realVars[216] /* particleReceiver1D.g_w[16] variable */ + data->localData[0]->realVars[217] /* particleReceiver1D.g_w[17] variable */ + data->localData[0]->realVars[218] /* particleReceiver1D.g_w[18] variable */ + data->localData[0]->realVars[219] /* particleReceiver1D.g_w[19] variable */ + data->localData[0]->realVars[220] /* particleReceiver1D.g_w[20] variable */) * ((data->localData[0]->realVars[157] /* particleReceiver1D.W_rcv variable */) * (data->simulationInfo->realParameter[209] /* particleReceiver1D.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4692
type: SIMPLE_ASSIGN
particleReceiver1D.Qdot_rec = if heliostatsField.on_internal == true then max(particleReceiver1D.mdot * (particleReceiver1D.h_s[21] - particleReceiver1D.h_s[1]), 0.0) else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4692(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4692};
  data->localData[0]->realVars[108] /* particleReceiver1D.Qdot_rec variable */ = (((!data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && !1) || (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && 1))?fmax((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */) * (data->localData[0]->realVars[262] /* particleReceiver1D.h_s[21] variable */ - data->localData[0]->realVars[242] /* particleReceiver1D.h_s[1] variable */),0.0):0.0);
  TRACE_POP
}
/*
equation index: 4693
type: SIMPLE_ASSIGN
$DER.E_recv_net = particleReceiver1D.Qdot_rec
*/
void PhysicalParticleCO21D_eqFunction_4693(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4693};
  data->localData[0]->realVars[25] /* der(E_recv_net) STATE_DER */ = data->localData[0]->realVars[108] /* particleReceiver1D.Qdot_rec variable */;
  TRACE_POP
}
/*
equation index: 4694
type: SIMPLE_ASSIGN
particleReceiver1D.eta_rec = if heliostatsField.on_internal == true then max(particleReceiver1D.Qdot_rec / particleReceiver1D.Qdot_inc, 0.0) else 0.0
*/
void PhysicalParticleCO21D_eqFunction_4694(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4694};
  data->localData[0]->realVars[199] /* particleReceiver1D.eta_rec variable */ = (((!data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && !1) || (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && 1))?fmax(DIVISION_SIM(data->localData[0]->realVars[108] /* particleReceiver1D.Qdot_rec variable */,data->localData[0]->realVars[107] /* particleReceiver1D.Qdot_inc variable */,"particleReceiver1D.Qdot_inc",equationIndexes),0.0):0.0);
  TRACE_POP
}
/*
equation index: 4695
type: SIMPLE_ASSIGN
$DER.tankHot.medium.h = (tankHot.Q_losses + tankHot.W_net + particleReceiver1D.mdot * particleReceiver1D.h_s[21] + LiftCold.fluid_b.m_flow * tankHot.medium.h - der(tankHot.m) * tankHot.medium.h) / tankHot.m
*/
void PhysicalParticleCO21D_eqFunction_4695(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4695};
  data->localData[0]->realVars[33] /* der(tankHot.medium.h) STATE_DER */ = DIVISION_SIM(data->localData[0]->realVars[1147] /* tankHot.Q_losses variable */ + data->localData[0]->realVars[1151] /* tankHot.W_net variable */ + (data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */) * (data->localData[0]->realVars[262] /* particleReceiver1D.h_s[21] variable */) + (data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */) * (data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */) - ((data->localData[0]->realVars[32] /* der(tankHot.m) STATE_DER */) * (data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */)),data->localData[0]->realVars[15] /* tankHot.m STATE(1) */,"tankHot.m",equationIndexes);
  TRACE_POP
}
/*
equation index: 4696
type: SIMPLE_ASSIGN
particleReceiver1D.Q_check_curtain = particleReceiver1D.mdot * (particleReceiver1D.h_s[1] - particleReceiver1D.h_s[21]) + particleReceiver1D.Qdot_inc + particleReceiver1D.Qloss_conv_curtain + (-particleReceiver1D.Qloss_jcf) - particleReceiver1D.Qloss_jcb
*/
void PhysicalParticleCO21D_eqFunction_4696(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4696};
  data->localData[0]->realVars[106] /* particleReceiver1D.Q_check_curtain variable */ = (data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */) * (data->localData[0]->realVars[242] /* particleReceiver1D.h_s[1] variable */ - data->localData[0]->realVars[262] /* particleReceiver1D.h_s[21] variable */) + data->localData[0]->realVars[107] /* particleReceiver1D.Qdot_inc variable */ + data->localData[0]->realVars[110] /* particleReceiver1D.Qloss_conv_curtain variable */ + (-data->localData[0]->realVars[113] /* particleReceiver1D.Qloss_jcf variable */) - data->localData[0]->realVars[112] /* particleReceiver1D.Qloss_jcb variable */;
  TRACE_POP
}
/*
equation index: 4697
type: SIMPLE_ASSIGN
simpleReceiverControl.T_mea = particleReceiver1D.T_s[1]
*/
void PhysicalParticleCO21D_eqFunction_4697(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4697};
  data->localData[0]->realVars[1117] /* simpleReceiverControl.T_mea variable */ = data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */;
  TRACE_POP
}
/*
equation index: 4747
type: ALGORITHM

  assert(particleReceiver1DCalculator.sink.p >= 0.0, "Pressure (= " + String(particleReceiver1DCalculator.sink.p, 6, 0, true) + " Pa) of medium \"" + "CARBO HSP 40/70" + "\" is negative
(Temperature = " + String(particleReceiver1DCalculator.sink.medium.T, 6, 0, true) + " K)");
*/
void PhysicalParticleCO21D_eqFunction_4747(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4747};
  modelica_boolean tmp2;
  static const MMC_DEFSTRINGLIT(tmp3,12,"Pressure (= ");
  modelica_string tmp4;
  static const MMC_DEFSTRINGLIT(tmp5,16," Pa) of medium \"");
  static const MMC_DEFSTRINGLIT(tmp6,15,"CARBO HSP 40/70");
  static const MMC_DEFSTRINGLIT(tmp7,29,"\" is negative\n(Temperature = ");
  modelica_string tmp8;
  static const MMC_DEFSTRINGLIT(tmp9,3," K)");
  static int tmp10 = 0;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  {
    tmp2 = GreaterEq(data->simulationInfo->realParameter[335] /* particleReceiver1DCalculator.sink.p PARAM */,0.0);
    if(!tmp2)
    {
      tmp4 = modelica_real_to_modelica_string(data->simulationInfo->realParameter[335] /* particleReceiver1DCalculator.sink.p PARAM */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp3),tmp4);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp5));
      tmpMeta[2] = stringAppend(tmpMeta[1],MMC_REFSTRINGLIT(tmp6));
      tmpMeta[3] = stringAppend(tmpMeta[2],MMC_REFSTRINGLIT(tmp7));
      tmp8 = modelica_real_to_modelica_string(data->localData[0]->realVars[955] /* particleReceiver1DCalculator.sink.medium.T variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[4] = stringAppend(tmpMeta[3],tmp8);
      tmpMeta[5] = stringAppend(tmpMeta[4],MMC_REFSTRINGLIT(tmp9));
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Media/package.mo",4529,7,4530,76,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.sink.p >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(tmpMeta[5]));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4746
type: ALGORITHM

  assert(data.table.tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4746(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4746};
  static const MMC_DEFSTRINGLIT(tmp13,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp14,42,"tableOnFile = true and no table name given");
  static int tmp15 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[2] /* data.table.tableName PARAM */, MMC_REFSTRINGLIT(tmp13))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Sources.mo",2401,7,2402,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\ndata.table.tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp14)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4745
type: ALGORITHM

  assert(heliostatsField.optical.nu_table.tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4745(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4745};
  static const MMC_DEFSTRINGLIT(tmp18,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp19,42,"tableOnFile = true and no table name given");
  static int tmp20 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[5] /* heliostatsField.optical.nu_table.tableName PARAM */, MMC_REFSTRINGLIT(tmp18))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",743,7,744,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nheliostatsField.optical.nu_table.tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp19)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4744
type: ALGORITHM

  assert(particleReceiver1D.Tab[1].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4744(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4744};
  static const MMC_DEFSTRINGLIT(tmp23,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp24,42,"tableOnFile = true and no table name given");
  static int tmp25 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[28] /* particleReceiver1D.Tab[1].tableName PARAM */, MMC_REFSTRINGLIT(tmp23))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[1].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp24)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4743
type: ALGORITHM

  assert(particleReceiver1D.Tab[2].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4743(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4743};
  static const MMC_DEFSTRINGLIT(tmp28,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp29,42,"tableOnFile = true and no table name given");
  static int tmp30 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[29] /* particleReceiver1D.Tab[2].tableName PARAM */, MMC_REFSTRINGLIT(tmp28))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[2].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp29)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4742
type: ALGORITHM

  assert(particleReceiver1D.Tab[3].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4742(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4742};
  static const MMC_DEFSTRINGLIT(tmp33,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp34,42,"tableOnFile = true and no table name given");
  static int tmp35 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[30] /* particleReceiver1D.Tab[3].tableName PARAM */, MMC_REFSTRINGLIT(tmp33))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[3].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp34)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4741
type: ALGORITHM

  assert(particleReceiver1D.Tab[4].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4741(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4741};
  static const MMC_DEFSTRINGLIT(tmp38,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp39,42,"tableOnFile = true and no table name given");
  static int tmp40 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[31] /* particleReceiver1D.Tab[4].tableName PARAM */, MMC_REFSTRINGLIT(tmp38))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[4].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp39)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4740
type: ALGORITHM

  assert(particleReceiver1D.Tab[5].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4740(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4740};
  static const MMC_DEFSTRINGLIT(tmp43,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp44,42,"tableOnFile = true and no table name given");
  static int tmp45 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[32] /* particleReceiver1D.Tab[5].tableName PARAM */, MMC_REFSTRINGLIT(tmp43))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[5].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp44)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4739
type: ALGORITHM

  assert(particleReceiver1D.Tab[6].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4739(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4739};
  static const MMC_DEFSTRINGLIT(tmp48,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp49,42,"tableOnFile = true and no table name given");
  static int tmp50 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[33] /* particleReceiver1D.Tab[6].tableName PARAM */, MMC_REFSTRINGLIT(tmp48))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[6].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp49)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4738
type: ALGORITHM

  assert(particleReceiver1D.Tab[7].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4738(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4738};
  static const MMC_DEFSTRINGLIT(tmp53,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp54,42,"tableOnFile = true and no table name given");
  static int tmp55 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[34] /* particleReceiver1D.Tab[7].tableName PARAM */, MMC_REFSTRINGLIT(tmp53))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[7].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp54)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4737
type: ALGORITHM

  assert(particleReceiver1D.Tab[8].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4737(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4737};
  static const MMC_DEFSTRINGLIT(tmp58,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp59,42,"tableOnFile = true and no table name given");
  static int tmp60 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[35] /* particleReceiver1D.Tab[8].tableName PARAM */, MMC_REFSTRINGLIT(tmp58))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[8].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp59)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4736
type: ALGORITHM

  assert(particleReceiver1D.Tab[9].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4736(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4736};
  static const MMC_DEFSTRINGLIT(tmp63,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp64,42,"tableOnFile = true and no table name given");
  static int tmp65 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[36] /* particleReceiver1D.Tab[9].tableName PARAM */, MMC_REFSTRINGLIT(tmp63))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[9].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp64)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4735
type: ALGORITHM

  assert(particleReceiver1D.Tab[10].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4735(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4735};
  static const MMC_DEFSTRINGLIT(tmp68,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp69,42,"tableOnFile = true and no table name given");
  static int tmp70 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[37] /* particleReceiver1D.Tab[10].tableName PARAM */, MMC_REFSTRINGLIT(tmp68))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[10].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp69)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4734
type: ALGORITHM

  assert(particleReceiver1D.Tab[11].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4734(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4734};
  static const MMC_DEFSTRINGLIT(tmp73,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp74,42,"tableOnFile = true and no table name given");
  static int tmp75 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[38] /* particleReceiver1D.Tab[11].tableName PARAM */, MMC_REFSTRINGLIT(tmp73))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[11].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp74)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4733
type: ALGORITHM

  assert(particleReceiver1D.Tab[12].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4733(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4733};
  static const MMC_DEFSTRINGLIT(tmp78,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp79,42,"tableOnFile = true and no table name given");
  static int tmp80 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[39] /* particleReceiver1D.Tab[12].tableName PARAM */, MMC_REFSTRINGLIT(tmp78))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[12].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp79)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4732
type: ALGORITHM

  assert(particleReceiver1D.Tab[13].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4732(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4732};
  static const MMC_DEFSTRINGLIT(tmp83,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp84,42,"tableOnFile = true and no table name given");
  static int tmp85 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[40] /* particleReceiver1D.Tab[13].tableName PARAM */, MMC_REFSTRINGLIT(tmp83))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[13].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp84)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4731
type: ALGORITHM

  assert(particleReceiver1D.Tab[14].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4731(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4731};
  static const MMC_DEFSTRINGLIT(tmp88,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp89,42,"tableOnFile = true and no table name given");
  static int tmp90 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[41] /* particleReceiver1D.Tab[14].tableName PARAM */, MMC_REFSTRINGLIT(tmp88))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[14].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp89)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4730
type: ALGORITHM

  assert(particleReceiver1D.Tab[15].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4730(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4730};
  static const MMC_DEFSTRINGLIT(tmp93,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp94,42,"tableOnFile = true and no table name given");
  static int tmp95 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[42] /* particleReceiver1D.Tab[15].tableName PARAM */, MMC_REFSTRINGLIT(tmp93))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[15].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp94)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4729
type: ALGORITHM

  assert(particleReceiver1D.Tab[16].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4729(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4729};
  static const MMC_DEFSTRINGLIT(tmp98,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp99,42,"tableOnFile = true and no table name given");
  static int tmp100 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[43] /* particleReceiver1D.Tab[16].tableName PARAM */, MMC_REFSTRINGLIT(tmp98))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[16].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp99)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4728
type: ALGORITHM

  assert(particleReceiver1D.Tab[17].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4728(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4728};
  static const MMC_DEFSTRINGLIT(tmp103,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp104,42,"tableOnFile = true and no table name given");
  static int tmp105 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[44] /* particleReceiver1D.Tab[17].tableName PARAM */, MMC_REFSTRINGLIT(tmp103))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[17].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp104)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4727
type: ALGORITHM

  assert(particleReceiver1D.Tab[18].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4727(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4727};
  static const MMC_DEFSTRINGLIT(tmp108,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp109,42,"tableOnFile = true and no table name given");
  static int tmp110 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[45] /* particleReceiver1D.Tab[18].tableName PARAM */, MMC_REFSTRINGLIT(tmp108))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[18].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp109)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4726
type: ALGORITHM

  assert(particleReceiver1D.Tab[19].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4726(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4726};
  static const MMC_DEFSTRINGLIT(tmp113,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp114,42,"tableOnFile = true and no table name given");
  static int tmp115 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[46] /* particleReceiver1D.Tab[19].tableName PARAM */, MMC_REFSTRINGLIT(tmp113))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[19].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp114)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4725
type: ALGORITHM

  assert(particleReceiver1D.Tab[20].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4725(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4725};
  static const MMC_DEFSTRINGLIT(tmp118,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp119,42,"tableOnFile = true and no table name given");
  static int tmp120 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[47] /* particleReceiver1D.Tab[20].tableName PARAM */, MMC_REFSTRINGLIT(tmp118))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[20].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp119)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4724
type: ALGORITHM

  assert(particleReceiver1D.Tab[21].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4724(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4724};
  static const MMC_DEFSTRINGLIT(tmp123,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp124,42,"tableOnFile = true and no table name given");
  static int tmp125 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[48] /* particleReceiver1D.Tab[21].tableName PARAM */, MMC_REFSTRINGLIT(tmp123))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D.Tab[21].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp124)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4723
type: ALGORITHM

  assert(simpleReceiverControl.limiter.uMax >= simpleReceiverControl.limiter.uMin, "Limiter: Limits must be consistent. However, uMax (=" + String(simpleReceiverControl.limiter.uMax, 6, 0, true) + ") < uMin (=" + String(simpleReceiverControl.limiter.uMin, 6, 0, true) + ")");
*/
void PhysicalParticleCO21D_eqFunction_4723(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4723};
  modelica_boolean tmp126;
  static const MMC_DEFSTRINGLIT(tmp127,52,"Limiter: Limits must be consistent. However, uMax (=");
  modelica_string tmp128;
  static const MMC_DEFSTRINGLIT(tmp129,11,") < uMin (=");
  modelica_string tmp130;
  static int tmp131 = 0;
  modelica_metatype tmpMeta[4] __attribute__((unused)) = {0};
  {
    tmp126 = GreaterEq(data->simulationInfo->realParameter[779] /* simpleReceiverControl.limiter.uMax PARAM */,data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMin PARAM */);
    if(!tmp126)
    {
      tmp128 = modelica_real_to_modelica_string(data->simulationInfo->realParameter[779] /* simpleReceiverControl.limiter.uMax PARAM */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp127),tmp128);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp129));
      tmp130 = modelica_real_to_modelica_string(data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMin PARAM */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[2] = stringAppend(tmpMeta[1],tmp130);
      tmpMeta[3] = stringAppend(tmpMeta[2],(modelica_string) mmc_strings_len1[41]);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Nonlinear.mo",19,9,20,65,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsimpleReceiverControl.limiter.uMax >= simpleReceiverControl.limiter.uMin", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(tmpMeta[3]));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4722
type: ALGORITHM

  Modelica.Fluid.Utilities.checkBoundary("CARBO HSP 40/70", {"Al2O3", "SiO2", "Fe2O3", "TiO2", "other"}, false, false, particleReceiver1DCalculator.source.X, "FixedBoundary");
*/
void PhysicalParticleCO21D_eqFunction_4722(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4722};
  static const MMC_DEFSTRINGLIT(tmp132,15,"CARBO HSP 40/70");
  string_array tmp133;
  static const MMC_DEFSTRINGLIT(tmp134,5,"Al2O3");
  static const MMC_DEFSTRINGLIT(tmp135,4,"SiO2");
  static const MMC_DEFSTRINGLIT(tmp136,5,"Fe2O3");
  static const MMC_DEFSTRINGLIT(tmp137,4,"TiO2");
  static const MMC_DEFSTRINGLIT(tmp138,5,"other");
  real_array tmp139;
  static const MMC_DEFSTRINGLIT(tmp140,13,"FixedBoundary");
  array_alloc_scalar_string_array(&tmp133, 5, (modelica_string)MMC_REFSTRINGLIT(tmp134), (modelica_string)MMC_REFSTRINGLIT(tmp135), (modelica_string)MMC_REFSTRINGLIT(tmp136), (modelica_string)MMC_REFSTRINGLIT(tmp137), (modelica_string)MMC_REFSTRINGLIT(tmp138));
  real_array_create(&tmp139, ((modelica_real*)&((&data->simulationInfo->realParameter[340] /* particleReceiver1DCalculator.source.X[1] PARAM */)[calc_base_index_dims_subs(1, 5, ((modelica_integer) 1))])), 1, 5);
  omc_Modelica_Fluid_Utilities_checkBoundary(threadData, MMC_REFSTRINGLIT(tmp132), tmp133, 0, 0, tmp139, MMC_REFSTRINGLIT(tmp140));
  TRACE_POP
}
/*
equation index: 4721
type: ALGORITHM

  Modelica.Fluid.Utilities.checkBoundary("CARBO HSP 40/70", {"Al2O3", "SiO2", "Fe2O3", "TiO2", "other"}, false, true, particleReceiver1DCalculator.sink.X, "FixedBoundary");
*/
void PhysicalParticleCO21D_eqFunction_4721(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4721};
  static const MMC_DEFSTRINGLIT(tmp141,15,"CARBO HSP 40/70");
  string_array tmp142;
  static const MMC_DEFSTRINGLIT(tmp143,5,"Al2O3");
  static const MMC_DEFSTRINGLIT(tmp144,4,"SiO2");
  static const MMC_DEFSTRINGLIT(tmp145,5,"Fe2O3");
  static const MMC_DEFSTRINGLIT(tmp146,4,"TiO2");
  static const MMC_DEFSTRINGLIT(tmp147,5,"other");
  real_array tmp148;
  static const MMC_DEFSTRINGLIT(tmp149,13,"FixedBoundary");
  array_alloc_scalar_string_array(&tmp142, 5, (modelica_string)MMC_REFSTRINGLIT(tmp143), (modelica_string)MMC_REFSTRINGLIT(tmp144), (modelica_string)MMC_REFSTRINGLIT(tmp145), (modelica_string)MMC_REFSTRINGLIT(tmp146), (modelica_string)MMC_REFSTRINGLIT(tmp147));
  real_array_create(&tmp148, ((modelica_real*)&((&data->simulationInfo->realParameter[326] /* particleReceiver1DCalculator.sink.X[1] PARAM */)[calc_base_index_dims_subs(1, 5, ((modelica_integer) 1))])), 1, 5);
  omc_Modelica_Fluid_Utilities_checkBoundary(threadData, MMC_REFSTRINGLIT(tmp141), tmp142, 0, 1, tmp148, MMC_REFSTRINGLIT(tmp149));
  TRACE_POP
}
/*
equation index: 4720
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4720(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4720};
  static const MMC_DEFSTRINGLIT(tmp152,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp153,42,"tableOnFile = true and no table name given");
  static int tmp154 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[71] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableName PARAM */, MMC_REFSTRINGLIT(tmp152))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp153)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4719
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[2].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4719(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4719};
  static const MMC_DEFSTRINGLIT(tmp157,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp158,42,"tableOnFile = true and no table name given");
  static int tmp159 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[72] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[2].tableName PARAM */, MMC_REFSTRINGLIT(tmp157))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[2].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp158)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4718
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[3].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4718(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4718};
  static const MMC_DEFSTRINGLIT(tmp162,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp163,42,"tableOnFile = true and no table name given");
  static int tmp164 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[73] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[3].tableName PARAM */, MMC_REFSTRINGLIT(tmp162))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[3].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp163)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4717
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[4].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4717(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4717};
  static const MMC_DEFSTRINGLIT(tmp167,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp168,42,"tableOnFile = true and no table name given");
  static int tmp169 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[74] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[4].tableName PARAM */, MMC_REFSTRINGLIT(tmp167))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[4].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp168)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4716
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[5].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4716(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4716};
  static const MMC_DEFSTRINGLIT(tmp172,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp173,42,"tableOnFile = true and no table name given");
  static int tmp174 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[75] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[5].tableName PARAM */, MMC_REFSTRINGLIT(tmp172))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[5].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp173)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4715
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[6].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4715(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4715};
  static const MMC_DEFSTRINGLIT(tmp177,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp178,42,"tableOnFile = true and no table name given");
  static int tmp179 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[76] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[6].tableName PARAM */, MMC_REFSTRINGLIT(tmp177))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[6].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp178)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4714
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[7].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4714(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4714};
  static const MMC_DEFSTRINGLIT(tmp182,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp183,42,"tableOnFile = true and no table name given");
  static int tmp184 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[77] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[7].tableName PARAM */, MMC_REFSTRINGLIT(tmp182))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[7].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp183)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4713
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[8].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4713(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4713};
  static const MMC_DEFSTRINGLIT(tmp187,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp188,42,"tableOnFile = true and no table name given");
  static int tmp189 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[78] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[8].tableName PARAM */, MMC_REFSTRINGLIT(tmp187))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[8].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp188)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4712
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[9].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4712(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4712};
  static const MMC_DEFSTRINGLIT(tmp192,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp193,42,"tableOnFile = true and no table name given");
  static int tmp194 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[79] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[9].tableName PARAM */, MMC_REFSTRINGLIT(tmp192))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[9].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp193)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4711
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[10].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4711(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4711};
  static const MMC_DEFSTRINGLIT(tmp197,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp198,42,"tableOnFile = true and no table name given");
  static int tmp199 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[80] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[10].tableName PARAM */, MMC_REFSTRINGLIT(tmp197))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[10].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp198)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4710
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[11].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4710(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4710};
  static const MMC_DEFSTRINGLIT(tmp202,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp203,42,"tableOnFile = true and no table name given");
  static int tmp204 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[81] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[11].tableName PARAM */, MMC_REFSTRINGLIT(tmp202))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[11].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp203)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4709
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[12].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4709(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4709};
  static const MMC_DEFSTRINGLIT(tmp207,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp208,42,"tableOnFile = true and no table name given");
  static int tmp209 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[82] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[12].tableName PARAM */, MMC_REFSTRINGLIT(tmp207))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[12].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp208)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4708
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[13].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4708(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4708};
  static const MMC_DEFSTRINGLIT(tmp212,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp213,42,"tableOnFile = true and no table name given");
  static int tmp214 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[83] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[13].tableName PARAM */, MMC_REFSTRINGLIT(tmp212))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[13].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp213)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4707
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[14].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4707(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4707};
  static const MMC_DEFSTRINGLIT(tmp217,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp218,42,"tableOnFile = true and no table name given");
  static int tmp219 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[84] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[14].tableName PARAM */, MMC_REFSTRINGLIT(tmp217))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[14].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp218)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4706
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[15].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4706(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4706};
  static const MMC_DEFSTRINGLIT(tmp222,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp223,42,"tableOnFile = true and no table name given");
  static int tmp224 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[85] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[15].tableName PARAM */, MMC_REFSTRINGLIT(tmp222))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[15].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp223)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4705
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[16].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4705(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4705};
  static const MMC_DEFSTRINGLIT(tmp227,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp228,42,"tableOnFile = true and no table name given");
  static int tmp229 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[86] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[16].tableName PARAM */, MMC_REFSTRINGLIT(tmp227))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[16].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp228)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4704
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[17].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4704(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4704};
  static const MMC_DEFSTRINGLIT(tmp232,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp233,42,"tableOnFile = true and no table name given");
  static int tmp234 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[87] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[17].tableName PARAM */, MMC_REFSTRINGLIT(tmp232))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[17].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp233)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4703
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[18].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4703(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4703};
  static const MMC_DEFSTRINGLIT(tmp237,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp238,42,"tableOnFile = true and no table name given");
  static int tmp239 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[88] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[18].tableName PARAM */, MMC_REFSTRINGLIT(tmp237))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[18].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp238)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4702
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[19].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4702(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4702};
  static const MMC_DEFSTRINGLIT(tmp242,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp243,42,"tableOnFile = true and no table name given");
  static int tmp244 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[89] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[19].tableName PARAM */, MMC_REFSTRINGLIT(tmp242))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[19].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp243)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4701
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[20].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4701(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4701};
  static const MMC_DEFSTRINGLIT(tmp247,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp248,42,"tableOnFile = true and no table name given");
  static int tmp249 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[90] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[20].tableName PARAM */, MMC_REFSTRINGLIT(tmp247))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[20].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp248)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4700
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_eqFunction_4700(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4700};
  static const MMC_DEFSTRINGLIT(tmp252,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp253,42,"tableOnFile = true and no table name given");
  static int tmp254 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[91] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableName PARAM */, MMC_REFSTRINGLIT(tmp252))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp253)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4699
type: ALGORITHM

  assert(tankHot.p_top >= 0.0, "Pressure (= " + String(tankHot.p_top, 6, 0, true) + " Pa) of medium \"" + "CARBO HSP 40/70" + "\" is negative
(Temperature = " + String(tankHot.T_mea, 6, 0, true) + " K)");
*/
void PhysicalParticleCO21D_eqFunction_4699(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4699};
  modelica_boolean tmp255;
  static const MMC_DEFSTRINGLIT(tmp256,12,"Pressure (= ");
  modelica_string tmp257;
  static const MMC_DEFSTRINGLIT(tmp258,16," Pa) of medium \"");
  static const MMC_DEFSTRINGLIT(tmp259,15,"CARBO HSP 40/70");
  static const MMC_DEFSTRINGLIT(tmp260,29,"\" is negative\n(Temperature = ");
  modelica_string tmp261;
  static const MMC_DEFSTRINGLIT(tmp262,3," K)");
  static int tmp263 = 0;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  {
    tmp255 = GreaterEq(data->localData[0]->realVars[1164] /* tankHot.p_top variable */,0.0);
    if(!tmp255)
    {
      tmp257 = modelica_real_to_modelica_string(data->localData[0]->realVars[1164] /* tankHot.p_top variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp256),tmp257);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp258));
      tmpMeta[2] = stringAppend(tmpMeta[1],MMC_REFSTRINGLIT(tmp259));
      tmpMeta[3] = stringAppend(tmpMeta[2],MMC_REFSTRINGLIT(tmp260));
      tmp261 = modelica_real_to_modelica_string(data->localData[0]->realVars[1148] /* tankHot.T_mea variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[4] = stringAppend(tmpMeta[3],tmp261);
      tmpMeta[5] = stringAppend(tmpMeta[4],MMC_REFSTRINGLIT(tmp262));
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Media/package.mo",4529,7,4530,76,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\ntankHot.p_top >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(tmpMeta[5]));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4698
type: ALGORITHM

  assert(tankHot.p_top >= 0.0, "Pressure (= " + String(tankHot.p_top, 6, 0, true) + " Pa) of medium \"" + "CARBO HSP 40/70" + "\" is negative
(Temperature = " + String(particleReceiver1D.T_s[1], 6, 0, true) + " K)");
*/
void PhysicalParticleCO21D_eqFunction_4698(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4698};
  modelica_boolean tmp264;
  static const MMC_DEFSTRINGLIT(tmp265,12,"Pressure (= ");
  modelica_string tmp266;
  static const MMC_DEFSTRINGLIT(tmp267,16," Pa) of medium \"");
  static const MMC_DEFSTRINGLIT(tmp268,15,"CARBO HSP 40/70");
  static const MMC_DEFSTRINGLIT(tmp269,29,"\" is negative\n(Temperature = ");
  modelica_string tmp270;
  static const MMC_DEFSTRINGLIT(tmp271,3," K)");
  static int tmp272 = 0;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  {
    tmp264 = GreaterEq(data->localData[0]->realVars[1164] /* tankHot.p_top variable */,0.0);
    if(!tmp264)
    {
      tmp266 = modelica_real_to_modelica_string(data->localData[0]->realVars[1164] /* tankHot.p_top variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp265),tmp266);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp267));
      tmpMeta[2] = stringAppend(tmpMeta[1],MMC_REFSTRINGLIT(tmp268));
      tmpMeta[3] = stringAppend(tmpMeta[2],MMC_REFSTRINGLIT(tmp269));
      tmp270 = modelica_real_to_modelica_string(data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[4] = stringAppend(tmpMeta[3],tmp270);
      tmpMeta[5] = stringAppend(tmpMeta[4],MMC_REFSTRINGLIT(tmp271));
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Media/package.mo",4529,7,4530,76,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\ntankHot.p_top >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(tmpMeta[5]));
      }
    }
  }
  TRACE_POP
}

OMC_DISABLE_OPT
int PhysicalParticleCO21D_functionDAE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  int equationIndexes[1] = {0};
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  data->simulationInfo->needToIterate = 0;
  data->simulationInfo->discreteCall = 1;
  PhysicalParticleCO21D_functionLocalKnownVars(data, threadData);
  PhysicalParticleCO21D_eqFunction_3834(data, threadData);

  PhysicalParticleCO21D_eqFunction_3835(data, threadData);

  PhysicalParticleCO21D_eqFunction_3836(data, threadData);

  PhysicalParticleCO21D_eqFunction_3837(data, threadData);

  PhysicalParticleCO21D_eqFunction_3838(data, threadData);

  PhysicalParticleCO21D_eqFunction_3839(data, threadData);

  PhysicalParticleCO21D_eqFunction_3840(data, threadData);

  PhysicalParticleCO21D_eqFunction_3841(data, threadData);

  PhysicalParticleCO21D_eqFunction_3842(data, threadData);

  PhysicalParticleCO21D_eqFunction_3843(data, threadData);

  PhysicalParticleCO21D_eqFunction_3844(data, threadData);

  PhysicalParticleCO21D_eqFunction_3845(data, threadData);

  PhysicalParticleCO21D_eqFunction_3846(data, threadData);

  PhysicalParticleCO21D_eqFunction_3847(data, threadData);

  PhysicalParticleCO21D_eqFunction_3848(data, threadData);

  PhysicalParticleCO21D_eqFunction_3849(data, threadData);

  PhysicalParticleCO21D_eqFunction_3850(data, threadData);

  PhysicalParticleCO21D_eqFunction_3851(data, threadData);

  PhysicalParticleCO21D_eqFunction_3852(data, threadData);

  PhysicalParticleCO21D_eqFunction_3853(data, threadData);

  PhysicalParticleCO21D_eqFunction_3854(data, threadData);

  PhysicalParticleCO21D_eqFunction_3855(data, threadData);

  PhysicalParticleCO21D_eqFunction_3856(data, threadData);

  PhysicalParticleCO21D_eqFunction_4098(data, threadData);

  PhysicalParticleCO21D_eqFunction_4099(data, threadData);

  PhysicalParticleCO21D_eqFunction_4100(data, threadData);

  PhysicalParticleCO21D_eqFunction_4101(data, threadData);

  PhysicalParticleCO21D_eqFunction_4102(data, threadData);

  PhysicalParticleCO21D_eqFunction_4103(data, threadData);

  PhysicalParticleCO21D_eqFunction_4104(data, threadData);

  PhysicalParticleCO21D_eqFunction_4105(data, threadData);

  PhysicalParticleCO21D_eqFunction_4106(data, threadData);

  PhysicalParticleCO21D_eqFunction_4107(data, threadData);

  PhysicalParticleCO21D_eqFunction_4108(data, threadData);

  PhysicalParticleCO21D_eqFunction_4109(data, threadData);

  PhysicalParticleCO21D_eqFunction_4110(data, threadData);

  PhysicalParticleCO21D_eqFunction_4111(data, threadData);

  PhysicalParticleCO21D_eqFunction_4112(data, threadData);

  PhysicalParticleCO21D_eqFunction_4113(data, threadData);

  PhysicalParticleCO21D_eqFunction_4114(data, threadData);

  PhysicalParticleCO21D_eqFunction_4115(data, threadData);

  PhysicalParticleCO21D_eqFunction_4116(data, threadData);

  PhysicalParticleCO21D_eqFunction_4117(data, threadData);

  PhysicalParticleCO21D_eqFunction_4118(data, threadData);

  PhysicalParticleCO21D_eqFunction_4119(data, threadData);

  PhysicalParticleCO21D_eqFunction_4120(data, threadData);

  PhysicalParticleCO21D_eqFunction_4121(data, threadData);

  PhysicalParticleCO21D_eqFunction_4122(data, threadData);

  PhysicalParticleCO21D_eqFunction_4123(data, threadData);

  PhysicalParticleCO21D_eqFunction_4124(data, threadData);

  PhysicalParticleCO21D_eqFunction_4125(data, threadData);

  PhysicalParticleCO21D_eqFunction_4126(data, threadData);

  PhysicalParticleCO21D_eqFunction_4127(data, threadData);

  PhysicalParticleCO21D_eqFunction_4128(data, threadData);

  PhysicalParticleCO21D_eqFunction_4129(data, threadData);

  PhysicalParticleCO21D_eqFunction_4130(data, threadData);

  PhysicalParticleCO21D_eqFunction_4131(data, threadData);

  PhysicalParticleCO21D_eqFunction_4132(data, threadData);

  PhysicalParticleCO21D_eqFunction_4133(data, threadData);

  PhysicalParticleCO21D_eqFunction_4134(data, threadData);

  PhysicalParticleCO21D_eqFunction_4135(data, threadData);

  PhysicalParticleCO21D_eqFunction_4136(data, threadData);

  PhysicalParticleCO21D_eqFunction_4138(data, threadData);

  PhysicalParticleCO21D_eqFunction_4139(data, threadData);

  PhysicalParticleCO21D_eqFunction_4140(data, threadData);

  PhysicalParticleCO21D_eqFunction_4142(data, threadData);

  PhysicalParticleCO21D_eqFunction_4143(data, threadData);

  PhysicalParticleCO21D_eqFunction_4144(data, threadData);

  PhysicalParticleCO21D_eqFunction_4145(data, threadData);

  PhysicalParticleCO21D_eqFunction_4146(data, threadData);

  PhysicalParticleCO21D_eqFunction_4147(data, threadData);

  PhysicalParticleCO21D_eqFunction_4148(data, threadData);

  PhysicalParticleCO21D_eqFunction_4150(data, threadData);

  PhysicalParticleCO21D_eqFunction_4151(data, threadData);

  PhysicalParticleCO21D_eqFunction_4152(data, threadData);

  PhysicalParticleCO21D_eqFunction_4153(data, threadData);

  PhysicalParticleCO21D_eqFunction_4155(data, threadData);

  PhysicalParticleCO21D_eqFunction_4156(data, threadData);

  PhysicalParticleCO21D_eqFunction_4157(data, threadData);

  PhysicalParticleCO21D_eqFunction_4158(data, threadData);

  PhysicalParticleCO21D_eqFunction_4159(data, threadData);

  PhysicalParticleCO21D_eqFunction_4160(data, threadData);

  PhysicalParticleCO21D_eqFunction_4161(data, threadData);

  PhysicalParticleCO21D_eqFunction_4162(data, threadData);

  PhysicalParticleCO21D_eqFunction_4163(data, threadData);

  PhysicalParticleCO21D_eqFunction_4164(data, threadData);

  PhysicalParticleCO21D_eqFunction_4165(data, threadData);

  PhysicalParticleCO21D_eqFunction_4166(data, threadData);

  PhysicalParticleCO21D_eqFunction_4167(data, threadData);

  PhysicalParticleCO21D_eqFunction_4168(data, threadData);

  PhysicalParticleCO21D_eqFunction_4169(data, threadData);

  PhysicalParticleCO21D_eqFunction_4170(data, threadData);

  PhysicalParticleCO21D_eqFunction_4171(data, threadData);

  PhysicalParticleCO21D_eqFunction_4172(data, threadData);

  PhysicalParticleCO21D_eqFunction_4173(data, threadData);

  PhysicalParticleCO21D_eqFunction_4174(data, threadData);

  PhysicalParticleCO21D_eqFunction_4175(data, threadData);

  PhysicalParticleCO21D_eqFunction_4176(data, threadData);

  PhysicalParticleCO21D_eqFunction_4177(data, threadData);

  PhysicalParticleCO21D_eqFunction_4178(data, threadData);

  PhysicalParticleCO21D_eqFunction_4179(data, threadData);

  PhysicalParticleCO21D_eqFunction_4180(data, threadData);

  PhysicalParticleCO21D_eqFunction_4181(data, threadData);

  PhysicalParticleCO21D_eqFunction_4182(data, threadData);

  PhysicalParticleCO21D_eqFunction_4183(data, threadData);

  PhysicalParticleCO21D_eqFunction_4184(data, threadData);

  PhysicalParticleCO21D_eqFunction_4185(data, threadData);

  PhysicalParticleCO21D_eqFunction_4186(data, threadData);

  PhysicalParticleCO21D_eqFunction_4187(data, threadData);

  PhysicalParticleCO21D_eqFunction_4188(data, threadData);

  PhysicalParticleCO21D_eqFunction_4189(data, threadData);

  PhysicalParticleCO21D_eqFunction_4190(data, threadData);

  PhysicalParticleCO21D_eqFunction_4191(data, threadData);

  PhysicalParticleCO21D_eqFunction_4192(data, threadData);

  PhysicalParticleCO21D_eqFunction_4193(data, threadData);

  PhysicalParticleCO21D_eqFunction_4194(data, threadData);

  PhysicalParticleCO21D_eqFunction_4195(data, threadData);

  PhysicalParticleCO21D_eqFunction_4196(data, threadData);

  PhysicalParticleCO21D_eqFunction_4197(data, threadData);

  PhysicalParticleCO21D_eqFunction_4198(data, threadData);

  PhysicalParticleCO21D_eqFunction_4199(data, threadData);

  PhysicalParticleCO21D_eqFunction_4200(data, threadData);

  PhysicalParticleCO21D_eqFunction_4201(data, threadData);

  PhysicalParticleCO21D_eqFunction_4202(data, threadData);

  PhysicalParticleCO21D_eqFunction_4203(data, threadData);

  PhysicalParticleCO21D_eqFunction_4204(data, threadData);

  PhysicalParticleCO21D_eqFunction_4205(data, threadData);

  PhysicalParticleCO21D_eqFunction_4206(data, threadData);

  PhysicalParticleCO21D_eqFunction_4207(data, threadData);

  PhysicalParticleCO21D_eqFunction_4208(data, threadData);

  PhysicalParticleCO21D_eqFunction_4209(data, threadData);

  PhysicalParticleCO21D_eqFunction_4210(data, threadData);

  PhysicalParticleCO21D_eqFunction_4211(data, threadData);

  PhysicalParticleCO21D_eqFunction_4213(data, threadData);

  PhysicalParticleCO21D_eqFunction_4214(data, threadData);

  PhysicalParticleCO21D_eqFunction_4215(data, threadData);

  PhysicalParticleCO21D_eqFunction_4216(data, threadData);

  PhysicalParticleCO21D_eqFunction_4217(data, threadData);

  PhysicalParticleCO21D_eqFunction_4218(data, threadData);

  PhysicalParticleCO21D_eqFunction_4219(data, threadData);

  PhysicalParticleCO21D_eqFunction_4220(data, threadData);

  PhysicalParticleCO21D_eqFunction_4221(data, threadData);

  PhysicalParticleCO21D_eqFunction_4222(data, threadData);

  PhysicalParticleCO21D_eqFunction_4223(data, threadData);

  PhysicalParticleCO21D_eqFunction_4224(data, threadData);

  PhysicalParticleCO21D_eqFunction_4225(data, threadData);

  PhysicalParticleCO21D_eqFunction_4226(data, threadData);

  PhysicalParticleCO21D_eqFunction_4227(data, threadData);

  PhysicalParticleCO21D_eqFunction_4228(data, threadData);

  PhysicalParticleCO21D_eqFunction_4229(data, threadData);

  PhysicalParticleCO21D_eqFunction_4230(data, threadData);

  PhysicalParticleCO21D_eqFunction_4231(data, threadData);

  PhysicalParticleCO21D_eqFunction_4232(data, threadData);

  PhysicalParticleCO21D_eqFunction_4233(data, threadData);

  PhysicalParticleCO21D_eqFunction_4234(data, threadData);

  PhysicalParticleCO21D_eqFunction_4235(data, threadData);

  PhysicalParticleCO21D_eqFunction_4236(data, threadData);

  PhysicalParticleCO21D_eqFunction_4237(data, threadData);

  PhysicalParticleCO21D_eqFunction_4238(data, threadData);

  PhysicalParticleCO21D_eqFunction_4239(data, threadData);

  PhysicalParticleCO21D_eqFunction_4240(data, threadData);

  PhysicalParticleCO21D_eqFunction_4241(data, threadData);

  PhysicalParticleCO21D_eqFunction_4242(data, threadData);

  PhysicalParticleCO21D_eqFunction_4243(data, threadData);

  PhysicalParticleCO21D_eqFunction_4244(data, threadData);

  PhysicalParticleCO21D_eqFunction_4245(data, threadData);

  PhysicalParticleCO21D_eqFunction_4246(data, threadData);

  PhysicalParticleCO21D_eqFunction_4247(data, threadData);

  PhysicalParticleCO21D_eqFunction_4248(data, threadData);

  PhysicalParticleCO21D_eqFunction_4250(data, threadData);

  PhysicalParticleCO21D_eqFunction_4251(data, threadData);

  PhysicalParticleCO21D_eqFunction_4252(data, threadData);

  PhysicalParticleCO21D_eqFunction_4253(data, threadData);

  PhysicalParticleCO21D_eqFunction_4254(data, threadData);

  PhysicalParticleCO21D_eqFunction_4356(data, threadData);

  PhysicalParticleCO21D_eqFunction_4357(data, threadData);

  PhysicalParticleCO21D_eqFunction_4358(data, threadData);

  PhysicalParticleCO21D_eqFunction_4359(data, threadData);

  PhysicalParticleCO21D_eqFunction_4360(data, threadData);

  PhysicalParticleCO21D_eqFunction_4361(data, threadData);

  PhysicalParticleCO21D_eqFunction_4362(data, threadData);

  PhysicalParticleCO21D_eqFunction_4363(data, threadData);

  PhysicalParticleCO21D_eqFunction_4364(data, threadData);

  PhysicalParticleCO21D_eqFunction_4365(data, threadData);

  PhysicalParticleCO21D_eqFunction_4366(data, threadData);

  PhysicalParticleCO21D_eqFunction_4367(data, threadData);

  PhysicalParticleCO21D_eqFunction_4368(data, threadData);

  PhysicalParticleCO21D_eqFunction_4369(data, threadData);

  PhysicalParticleCO21D_eqFunction_4370(data, threadData);

  PhysicalParticleCO21D_eqFunction_4371(data, threadData);

  PhysicalParticleCO21D_eqFunction_4372(data, threadData);

  PhysicalParticleCO21D_eqFunction_4373(data, threadData);

  PhysicalParticleCO21D_eqFunction_4374(data, threadData);

  PhysicalParticleCO21D_eqFunction_4375(data, threadData);

  PhysicalParticleCO21D_eqFunction_4376(data, threadData);

  PhysicalParticleCO21D_eqFunction_4377(data, threadData);

  PhysicalParticleCO21D_eqFunction_4378(data, threadData);

  PhysicalParticleCO21D_eqFunction_4379(data, threadData);

  PhysicalParticleCO21D_eqFunction_4380(data, threadData);

  PhysicalParticleCO21D_eqFunction_4381(data, threadData);

  PhysicalParticleCO21D_eqFunction_4382(data, threadData);

  PhysicalParticleCO21D_eqFunction_4383(data, threadData);

  PhysicalParticleCO21D_eqFunction_4384(data, threadData);

  PhysicalParticleCO21D_eqFunction_4385(data, threadData);

  PhysicalParticleCO21D_eqFunction_4386(data, threadData);

  PhysicalParticleCO21D_eqFunction_4387(data, threadData);

  PhysicalParticleCO21D_eqFunction_4388(data, threadData);

  PhysicalParticleCO21D_eqFunction_4389(data, threadData);

  PhysicalParticleCO21D_eqFunction_4390(data, threadData);

  PhysicalParticleCO21D_eqFunction_4391(data, threadData);

  PhysicalParticleCO21D_eqFunction_4392(data, threadData);

  PhysicalParticleCO21D_eqFunction_4393(data, threadData);

  PhysicalParticleCO21D_eqFunction_4394(data, threadData);

  PhysicalParticleCO21D_eqFunction_4395(data, threadData);

  PhysicalParticleCO21D_eqFunction_4396(data, threadData);

  PhysicalParticleCO21D_eqFunction_4397(data, threadData);

  PhysicalParticleCO21D_eqFunction_4398(data, threadData);

  PhysicalParticleCO21D_eqFunction_4399(data, threadData);

  PhysicalParticleCO21D_eqFunction_4400(data, threadData);

  PhysicalParticleCO21D_eqFunction_4401(data, threadData);

  PhysicalParticleCO21D_eqFunction_4402(data, threadData);

  PhysicalParticleCO21D_eqFunction_4403(data, threadData);

  PhysicalParticleCO21D_eqFunction_4404(data, threadData);

  PhysicalParticleCO21D_eqFunction_4405(data, threadData);

  PhysicalParticleCO21D_eqFunction_4406(data, threadData);

  PhysicalParticleCO21D_eqFunction_4407(data, threadData);

  PhysicalParticleCO21D_eqFunction_4408(data, threadData);

  PhysicalParticleCO21D_eqFunction_4409(data, threadData);

  PhysicalParticleCO21D_eqFunction_4410(data, threadData);

  PhysicalParticleCO21D_eqFunction_4411(data, threadData);

  PhysicalParticleCO21D_eqFunction_4412(data, threadData);

  PhysicalParticleCO21D_eqFunction_4413(data, threadData);

  PhysicalParticleCO21D_eqFunction_4414(data, threadData);

  PhysicalParticleCO21D_eqFunction_4415(data, threadData);

  PhysicalParticleCO21D_eqFunction_4416(data, threadData);

  PhysicalParticleCO21D_eqFunction_4417(data, threadData);

  PhysicalParticleCO21D_eqFunction_4418(data, threadData);

  PhysicalParticleCO21D_eqFunction_4419(data, threadData);

  PhysicalParticleCO21D_eqFunction_4420(data, threadData);

  PhysicalParticleCO21D_eqFunction_4421(data, threadData);

  PhysicalParticleCO21D_eqFunction_4422(data, threadData);

  PhysicalParticleCO21D_eqFunction_4423(data, threadData);

  PhysicalParticleCO21D_eqFunction_4424(data, threadData);

  PhysicalParticleCO21D_eqFunction_4425(data, threadData);

  PhysicalParticleCO21D_eqFunction_4426(data, threadData);

  PhysicalParticleCO21D_eqFunction_4427(data, threadData);

  PhysicalParticleCO21D_eqFunction_4428(data, threadData);

  PhysicalParticleCO21D_eqFunction_4429(data, threadData);

  PhysicalParticleCO21D_eqFunction_4430(data, threadData);

  PhysicalParticleCO21D_eqFunction_4431(data, threadData);

  PhysicalParticleCO21D_eqFunction_4432(data, threadData);

  PhysicalParticleCO21D_eqFunction_4433(data, threadData);

  PhysicalParticleCO21D_eqFunction_4434(data, threadData);

  PhysicalParticleCO21D_eqFunction_4435(data, threadData);

  PhysicalParticleCO21D_eqFunction_4436(data, threadData);

  PhysicalParticleCO21D_eqFunction_4437(data, threadData);

  PhysicalParticleCO21D_eqFunction_4438(data, threadData);

  PhysicalParticleCO21D_eqFunction_4439(data, threadData);

  PhysicalParticleCO21D_eqFunction_4440(data, threadData);

  PhysicalParticleCO21D_eqFunction_4441(data, threadData);

  PhysicalParticleCO21D_eqFunction_4442(data, threadData);

  PhysicalParticleCO21D_eqFunction_4443(data, threadData);

  PhysicalParticleCO21D_eqFunction_4444(data, threadData);

  PhysicalParticleCO21D_eqFunction_4445(data, threadData);

  PhysicalParticleCO21D_eqFunction_4446(data, threadData);

  PhysicalParticleCO21D_eqFunction_4447(data, threadData);

  PhysicalParticleCO21D_eqFunction_4448(data, threadData);

  PhysicalParticleCO21D_eqFunction_4449(data, threadData);

  PhysicalParticleCO21D_eqFunction_4450(data, threadData);

  PhysicalParticleCO21D_eqFunction_4451(data, threadData);

  PhysicalParticleCO21D_eqFunction_4452(data, threadData);

  PhysicalParticleCO21D_eqFunction_4453(data, threadData);

  PhysicalParticleCO21D_eqFunction_4454(data, threadData);

  PhysicalParticleCO21D_eqFunction_4455(data, threadData);

  PhysicalParticleCO21D_eqFunction_4456(data, threadData);

  PhysicalParticleCO21D_eqFunction_4457(data, threadData);

  PhysicalParticleCO21D_eqFunction_4458(data, threadData);

  PhysicalParticleCO21D_eqFunction_4459(data, threadData);

  PhysicalParticleCO21D_eqFunction_4460(data, threadData);

  PhysicalParticleCO21D_eqFunction_4461(data, threadData);

  PhysicalParticleCO21D_eqFunction_4462(data, threadData);

  PhysicalParticleCO21D_eqFunction_4463(data, threadData);

  PhysicalParticleCO21D_eqFunction_4464(data, threadData);

  PhysicalParticleCO21D_eqFunction_4465(data, threadData);

  PhysicalParticleCO21D_eqFunction_4466(data, threadData);

  PhysicalParticleCO21D_eqFunction_4467(data, threadData);

  PhysicalParticleCO21D_eqFunction_4468(data, threadData);

  PhysicalParticleCO21D_eqFunction_4469(data, threadData);

  PhysicalParticleCO21D_eqFunction_4470(data, threadData);

  PhysicalParticleCO21D_eqFunction_4471(data, threadData);

  PhysicalParticleCO21D_eqFunction_4472(data, threadData);

  PhysicalParticleCO21D_eqFunction_4473(data, threadData);

  PhysicalParticleCO21D_eqFunction_4474(data, threadData);

  PhysicalParticleCO21D_eqFunction_4475(data, threadData);

  PhysicalParticleCO21D_eqFunction_4476(data, threadData);

  PhysicalParticleCO21D_eqFunction_4477(data, threadData);

  PhysicalParticleCO21D_eqFunction_4478(data, threadData);

  PhysicalParticleCO21D_eqFunction_4479(data, threadData);

  PhysicalParticleCO21D_eqFunction_4480(data, threadData);

  PhysicalParticleCO21D_eqFunction_4481(data, threadData);

  PhysicalParticleCO21D_eqFunction_4482(data, threadData);

  PhysicalParticleCO21D_eqFunction_4483(data, threadData);

  PhysicalParticleCO21D_eqFunction_4484(data, threadData);

  PhysicalParticleCO21D_eqFunction_4485(data, threadData);

  PhysicalParticleCO21D_eqFunction_4486(data, threadData);

  PhysicalParticleCO21D_eqFunction_4487(data, threadData);

  PhysicalParticleCO21D_eqFunction_4488(data, threadData);

  PhysicalParticleCO21D_eqFunction_4489(data, threadData);

  PhysicalParticleCO21D_eqFunction_4490(data, threadData);

  PhysicalParticleCO21D_eqFunction_4491(data, threadData);

  PhysicalParticleCO21D_eqFunction_4492(data, threadData);

  PhysicalParticleCO21D_eqFunction_4493(data, threadData);

  PhysicalParticleCO21D_eqFunction_4494(data, threadData);

  PhysicalParticleCO21D_eqFunction_4495(data, threadData);

  PhysicalParticleCO21D_eqFunction_4496(data, threadData);

  PhysicalParticleCO21D_eqFunction_4497(data, threadData);

  PhysicalParticleCO21D_eqFunction_4498(data, threadData);

  PhysicalParticleCO21D_eqFunction_4499(data, threadData);

  PhysicalParticleCO21D_eqFunction_4500(data, threadData);

  PhysicalParticleCO21D_eqFunction_4501(data, threadData);

  PhysicalParticleCO21D_eqFunction_4502(data, threadData);

  PhysicalParticleCO21D_eqFunction_4503(data, threadData);

  PhysicalParticleCO21D_eqFunction_4504(data, threadData);

  PhysicalParticleCO21D_eqFunction_4665(data, threadData);

  PhysicalParticleCO21D_eqFunction_4666(data, threadData);

  PhysicalParticleCO21D_eqFunction_4667(data, threadData);

  PhysicalParticleCO21D_eqFunction_4668(data, threadData);

  PhysicalParticleCO21D_eqFunction_4669(data, threadData);

  PhysicalParticleCO21D_eqFunction_4670(data, threadData);

  PhysicalParticleCO21D_eqFunction_4671(data, threadData);

  PhysicalParticleCO21D_eqFunction_4672(data, threadData);

  PhysicalParticleCO21D_eqFunction_4673(data, threadData);

  PhysicalParticleCO21D_eqFunction_4674(data, threadData);

  PhysicalParticleCO21D_eqFunction_4675(data, threadData);

  PhysicalParticleCO21D_eqFunction_4676(data, threadData);

  PhysicalParticleCO21D_eqFunction_4677(data, threadData);

  PhysicalParticleCO21D_eqFunction_4678(data, threadData);

  PhysicalParticleCO21D_eqFunction_4679(data, threadData);

  PhysicalParticleCO21D_eqFunction_4680(data, threadData);

  PhysicalParticleCO21D_eqFunction_4681(data, threadData);

  PhysicalParticleCO21D_eqFunction_4682(data, threadData);

  PhysicalParticleCO21D_eqFunction_4683(data, threadData);

  PhysicalParticleCO21D_eqFunction_4684(data, threadData);

  PhysicalParticleCO21D_eqFunction_4685(data, threadData);

  PhysicalParticleCO21D_eqFunction_4686(data, threadData);

  PhysicalParticleCO21D_eqFunction_4687(data, threadData);

  PhysicalParticleCO21D_eqFunction_4688(data, threadData);

  PhysicalParticleCO21D_eqFunction_4689(data, threadData);

  PhysicalParticleCO21D_eqFunction_4690(data, threadData);

  PhysicalParticleCO21D_eqFunction_4691(data, threadData);

  PhysicalParticleCO21D_eqFunction_4692(data, threadData);

  PhysicalParticleCO21D_eqFunction_4693(data, threadData);

  PhysicalParticleCO21D_eqFunction_4694(data, threadData);

  PhysicalParticleCO21D_eqFunction_4695(data, threadData);

  PhysicalParticleCO21D_eqFunction_4696(data, threadData);

  PhysicalParticleCO21D_eqFunction_4697(data, threadData);

  PhysicalParticleCO21D_eqFunction_4747(data, threadData);

  PhysicalParticleCO21D_eqFunction_4746(data, threadData);

  PhysicalParticleCO21D_eqFunction_4745(data, threadData);

  PhysicalParticleCO21D_eqFunction_4744(data, threadData);

  PhysicalParticleCO21D_eqFunction_4743(data, threadData);

  PhysicalParticleCO21D_eqFunction_4742(data, threadData);

  PhysicalParticleCO21D_eqFunction_4741(data, threadData);

  PhysicalParticleCO21D_eqFunction_4740(data, threadData);

  PhysicalParticleCO21D_eqFunction_4739(data, threadData);

  PhysicalParticleCO21D_eqFunction_4738(data, threadData);

  PhysicalParticleCO21D_eqFunction_4737(data, threadData);

  PhysicalParticleCO21D_eqFunction_4736(data, threadData);

  PhysicalParticleCO21D_eqFunction_4735(data, threadData);

  PhysicalParticleCO21D_eqFunction_4734(data, threadData);

  PhysicalParticleCO21D_eqFunction_4733(data, threadData);

  PhysicalParticleCO21D_eqFunction_4732(data, threadData);

  PhysicalParticleCO21D_eqFunction_4731(data, threadData);

  PhysicalParticleCO21D_eqFunction_4730(data, threadData);

  PhysicalParticleCO21D_eqFunction_4729(data, threadData);

  PhysicalParticleCO21D_eqFunction_4728(data, threadData);

  PhysicalParticleCO21D_eqFunction_4727(data, threadData);

  PhysicalParticleCO21D_eqFunction_4726(data, threadData);

  PhysicalParticleCO21D_eqFunction_4725(data, threadData);

  PhysicalParticleCO21D_eqFunction_4724(data, threadData);

  PhysicalParticleCO21D_eqFunction_4723(data, threadData);

  PhysicalParticleCO21D_eqFunction_4722(data, threadData);

  PhysicalParticleCO21D_eqFunction_4721(data, threadData);

  PhysicalParticleCO21D_eqFunction_4720(data, threadData);

  PhysicalParticleCO21D_eqFunction_4719(data, threadData);

  PhysicalParticleCO21D_eqFunction_4718(data, threadData);

  PhysicalParticleCO21D_eqFunction_4717(data, threadData);

  PhysicalParticleCO21D_eqFunction_4716(data, threadData);

  PhysicalParticleCO21D_eqFunction_4715(data, threadData);

  PhysicalParticleCO21D_eqFunction_4714(data, threadData);

  PhysicalParticleCO21D_eqFunction_4713(data, threadData);

  PhysicalParticleCO21D_eqFunction_4712(data, threadData);

  PhysicalParticleCO21D_eqFunction_4711(data, threadData);

  PhysicalParticleCO21D_eqFunction_4710(data, threadData);

  PhysicalParticleCO21D_eqFunction_4709(data, threadData);

  PhysicalParticleCO21D_eqFunction_4708(data, threadData);

  PhysicalParticleCO21D_eqFunction_4707(data, threadData);

  PhysicalParticleCO21D_eqFunction_4706(data, threadData);

  PhysicalParticleCO21D_eqFunction_4705(data, threadData);

  PhysicalParticleCO21D_eqFunction_4704(data, threadData);

  PhysicalParticleCO21D_eqFunction_4703(data, threadData);

  PhysicalParticleCO21D_eqFunction_4702(data, threadData);

  PhysicalParticleCO21D_eqFunction_4701(data, threadData);

  PhysicalParticleCO21D_eqFunction_4700(data, threadData);

  PhysicalParticleCO21D_eqFunction_4699(data, threadData);

  PhysicalParticleCO21D_eqFunction_4698(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif
  TRACE_POP
  return 0;
}


int PhysicalParticleCO21D_functionLocalKnownVars(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


/* forwarded equations */
extern void PhysicalParticleCO21D_eqFunction_4132(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4133(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4134(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4135(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4138(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4139(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4142(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4144(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4145(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4146(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4147(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4150(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4151(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4152(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4155(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4157(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4158(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4162(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4163(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4164(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4165(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4166(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4169(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4170(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4171(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4172(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4186(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4187(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4194(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4195(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4197(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4201(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4204(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4205(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4206(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4207(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4208(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4209(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4210(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4213(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4214(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4215(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4216(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4217(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4218(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4220(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4221(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4226(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4228(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4229(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4231(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4233(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4234(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4235(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4237(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4238(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4239(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4240(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4241(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4243(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4244(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4246(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4247(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4250(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4251(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4252(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4253(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4254(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4356(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4359(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4360(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4361(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4362(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4370(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4372(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4373(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4374(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4375(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4376(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4394(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4397(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4398(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4400(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4401(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4402(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4403(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4404(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4405(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4406(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4407(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4408(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4409(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4410(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4411(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4412(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4413(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4414(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4415(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4416(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4417(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4418(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4419(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4420(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4421(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4422(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4423(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4424(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4425(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4426(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4427(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4428(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4429(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4430(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4431(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4432(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4433(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4434(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4435(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4436(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4437(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4438(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4439(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4440(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4441(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4442(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4443(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4444(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4445(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4446(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4447(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4448(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4449(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4450(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4451(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4452(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4453(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4454(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4455(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4456(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4457(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4458(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4459(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4460(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4461(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4462(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4463(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4464(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4465(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4466(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4467(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4468(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4469(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4470(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4471(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4472(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4473(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4474(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4475(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4476(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4477(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4478(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4479(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4480(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4481(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4482(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4483(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4484(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4485(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4486(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4487(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4488(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4489(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4490(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4491(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4492(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4493(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4494(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4495(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4496(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4497(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4498(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4499(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4502(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4503(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4504(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4665(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4692(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4693(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4695(DATA* data, threadData_t *threadData);

static void functionODE_system0(DATA *data, threadData_t *threadData)
{
    PhysicalParticleCO21D_eqFunction_4132(data, threadData);

    PhysicalParticleCO21D_eqFunction_4133(data, threadData);

    PhysicalParticleCO21D_eqFunction_4134(data, threadData);

    PhysicalParticleCO21D_eqFunction_4135(data, threadData);

    PhysicalParticleCO21D_eqFunction_4138(data, threadData);

    PhysicalParticleCO21D_eqFunction_4139(data, threadData);

    PhysicalParticleCO21D_eqFunction_4142(data, threadData);

    PhysicalParticleCO21D_eqFunction_4144(data, threadData);

    PhysicalParticleCO21D_eqFunction_4145(data, threadData);

    PhysicalParticleCO21D_eqFunction_4146(data, threadData);

    PhysicalParticleCO21D_eqFunction_4147(data, threadData);

    PhysicalParticleCO21D_eqFunction_4150(data, threadData);

    PhysicalParticleCO21D_eqFunction_4151(data, threadData);

    PhysicalParticleCO21D_eqFunction_4152(data, threadData);

    PhysicalParticleCO21D_eqFunction_4155(data, threadData);

    PhysicalParticleCO21D_eqFunction_4157(data, threadData);

    PhysicalParticleCO21D_eqFunction_4158(data, threadData);

    PhysicalParticleCO21D_eqFunction_4162(data, threadData);

    PhysicalParticleCO21D_eqFunction_4163(data, threadData);

    PhysicalParticleCO21D_eqFunction_4164(data, threadData);

    PhysicalParticleCO21D_eqFunction_4165(data, threadData);

    PhysicalParticleCO21D_eqFunction_4166(data, threadData);

    PhysicalParticleCO21D_eqFunction_4169(data, threadData);

    PhysicalParticleCO21D_eqFunction_4170(data, threadData);

    PhysicalParticleCO21D_eqFunction_4171(data, threadData);

    PhysicalParticleCO21D_eqFunction_4172(data, threadData);

    PhysicalParticleCO21D_eqFunction_4186(data, threadData);

    PhysicalParticleCO21D_eqFunction_4187(data, threadData);

    PhysicalParticleCO21D_eqFunction_4194(data, threadData);

    PhysicalParticleCO21D_eqFunction_4195(data, threadData);

    PhysicalParticleCO21D_eqFunction_4197(data, threadData);

    PhysicalParticleCO21D_eqFunction_4201(data, threadData);

    PhysicalParticleCO21D_eqFunction_4204(data, threadData);

    PhysicalParticleCO21D_eqFunction_4205(data, threadData);

    PhysicalParticleCO21D_eqFunction_4206(data, threadData);

    PhysicalParticleCO21D_eqFunction_4207(data, threadData);

    PhysicalParticleCO21D_eqFunction_4208(data, threadData);

    PhysicalParticleCO21D_eqFunction_4209(data, threadData);

    PhysicalParticleCO21D_eqFunction_4210(data, threadData);

    PhysicalParticleCO21D_eqFunction_4213(data, threadData);

    PhysicalParticleCO21D_eqFunction_4214(data, threadData);

    PhysicalParticleCO21D_eqFunction_4215(data, threadData);

    PhysicalParticleCO21D_eqFunction_4216(data, threadData);

    PhysicalParticleCO21D_eqFunction_4217(data, threadData);

    PhysicalParticleCO21D_eqFunction_4218(data, threadData);

    PhysicalParticleCO21D_eqFunction_4220(data, threadData);

    PhysicalParticleCO21D_eqFunction_4221(data, threadData);

    PhysicalParticleCO21D_eqFunction_4226(data, threadData);

    PhysicalParticleCO21D_eqFunction_4228(data, threadData);

    PhysicalParticleCO21D_eqFunction_4229(data, threadData);

    PhysicalParticleCO21D_eqFunction_4231(data, threadData);

    PhysicalParticleCO21D_eqFunction_4233(data, threadData);

    PhysicalParticleCO21D_eqFunction_4234(data, threadData);

    PhysicalParticleCO21D_eqFunction_4235(data, threadData);

    PhysicalParticleCO21D_eqFunction_4237(data, threadData);

    PhysicalParticleCO21D_eqFunction_4238(data, threadData);

    PhysicalParticleCO21D_eqFunction_4239(data, threadData);

    PhysicalParticleCO21D_eqFunction_4240(data, threadData);

    PhysicalParticleCO21D_eqFunction_4241(data, threadData);

    PhysicalParticleCO21D_eqFunction_4243(data, threadData);

    PhysicalParticleCO21D_eqFunction_4244(data, threadData);

    PhysicalParticleCO21D_eqFunction_4246(data, threadData);

    PhysicalParticleCO21D_eqFunction_4247(data, threadData);

    PhysicalParticleCO21D_eqFunction_4250(data, threadData);

    PhysicalParticleCO21D_eqFunction_4251(data, threadData);

    PhysicalParticleCO21D_eqFunction_4252(data, threadData);

    PhysicalParticleCO21D_eqFunction_4253(data, threadData);

    PhysicalParticleCO21D_eqFunction_4254(data, threadData);

    PhysicalParticleCO21D_eqFunction_4356(data, threadData);

    PhysicalParticleCO21D_eqFunction_4359(data, threadData);

    PhysicalParticleCO21D_eqFunction_4360(data, threadData);

    PhysicalParticleCO21D_eqFunction_4361(data, threadData);

    PhysicalParticleCO21D_eqFunction_4362(data, threadData);

    PhysicalParticleCO21D_eqFunction_4370(data, threadData);

    PhysicalParticleCO21D_eqFunction_4372(data, threadData);

    PhysicalParticleCO21D_eqFunction_4373(data, threadData);

    PhysicalParticleCO21D_eqFunction_4374(data, threadData);

    PhysicalParticleCO21D_eqFunction_4375(data, threadData);

    PhysicalParticleCO21D_eqFunction_4376(data, threadData);

    PhysicalParticleCO21D_eqFunction_4394(data, threadData);

    PhysicalParticleCO21D_eqFunction_4397(data, threadData);

    PhysicalParticleCO21D_eqFunction_4398(data, threadData);

    PhysicalParticleCO21D_eqFunction_4400(data, threadData);

    PhysicalParticleCO21D_eqFunction_4401(data, threadData);

    PhysicalParticleCO21D_eqFunction_4402(data, threadData);

    PhysicalParticleCO21D_eqFunction_4403(data, threadData);

    PhysicalParticleCO21D_eqFunction_4404(data, threadData);

    PhysicalParticleCO21D_eqFunction_4405(data, threadData);

    PhysicalParticleCO21D_eqFunction_4406(data, threadData);

    PhysicalParticleCO21D_eqFunction_4407(data, threadData);

    PhysicalParticleCO21D_eqFunction_4408(data, threadData);

    PhysicalParticleCO21D_eqFunction_4409(data, threadData);

    PhysicalParticleCO21D_eqFunction_4410(data, threadData);

    PhysicalParticleCO21D_eqFunction_4411(data, threadData);

    PhysicalParticleCO21D_eqFunction_4412(data, threadData);

    PhysicalParticleCO21D_eqFunction_4413(data, threadData);

    PhysicalParticleCO21D_eqFunction_4414(data, threadData);

    PhysicalParticleCO21D_eqFunction_4415(data, threadData);

    PhysicalParticleCO21D_eqFunction_4416(data, threadData);

    PhysicalParticleCO21D_eqFunction_4417(data, threadData);

    PhysicalParticleCO21D_eqFunction_4418(data, threadData);

    PhysicalParticleCO21D_eqFunction_4419(data, threadData);

    PhysicalParticleCO21D_eqFunction_4420(data, threadData);

    PhysicalParticleCO21D_eqFunction_4421(data, threadData);

    PhysicalParticleCO21D_eqFunction_4422(data, threadData);

    PhysicalParticleCO21D_eqFunction_4423(data, threadData);

    PhysicalParticleCO21D_eqFunction_4424(data, threadData);

    PhysicalParticleCO21D_eqFunction_4425(data, threadData);

    PhysicalParticleCO21D_eqFunction_4426(data, threadData);

    PhysicalParticleCO21D_eqFunction_4427(data, threadData);

    PhysicalParticleCO21D_eqFunction_4428(data, threadData);

    PhysicalParticleCO21D_eqFunction_4429(data, threadData);

    PhysicalParticleCO21D_eqFunction_4430(data, threadData);

    PhysicalParticleCO21D_eqFunction_4431(data, threadData);

    PhysicalParticleCO21D_eqFunction_4432(data, threadData);

    PhysicalParticleCO21D_eqFunction_4433(data, threadData);

    PhysicalParticleCO21D_eqFunction_4434(data, threadData);

    PhysicalParticleCO21D_eqFunction_4435(data, threadData);

    PhysicalParticleCO21D_eqFunction_4436(data, threadData);

    PhysicalParticleCO21D_eqFunction_4437(data, threadData);

    PhysicalParticleCO21D_eqFunction_4438(data, threadData);

    PhysicalParticleCO21D_eqFunction_4439(data, threadData);

    PhysicalParticleCO21D_eqFunction_4440(data, threadData);

    PhysicalParticleCO21D_eqFunction_4441(data, threadData);

    PhysicalParticleCO21D_eqFunction_4442(data, threadData);

    PhysicalParticleCO21D_eqFunction_4443(data, threadData);

    PhysicalParticleCO21D_eqFunction_4444(data, threadData);

    PhysicalParticleCO21D_eqFunction_4445(data, threadData);

    PhysicalParticleCO21D_eqFunction_4446(data, threadData);

    PhysicalParticleCO21D_eqFunction_4447(data, threadData);

    PhysicalParticleCO21D_eqFunction_4448(data, threadData);

    PhysicalParticleCO21D_eqFunction_4449(data, threadData);

    PhysicalParticleCO21D_eqFunction_4450(data, threadData);

    PhysicalParticleCO21D_eqFunction_4451(data, threadData);

    PhysicalParticleCO21D_eqFunction_4452(data, threadData);

    PhysicalParticleCO21D_eqFunction_4453(data, threadData);

    PhysicalParticleCO21D_eqFunction_4454(data, threadData);

    PhysicalParticleCO21D_eqFunction_4455(data, threadData);

    PhysicalParticleCO21D_eqFunction_4456(data, threadData);

    PhysicalParticleCO21D_eqFunction_4457(data, threadData);

    PhysicalParticleCO21D_eqFunction_4458(data, threadData);

    PhysicalParticleCO21D_eqFunction_4459(data, threadData);

    PhysicalParticleCO21D_eqFunction_4460(data, threadData);

    PhysicalParticleCO21D_eqFunction_4461(data, threadData);

    PhysicalParticleCO21D_eqFunction_4462(data, threadData);

    PhysicalParticleCO21D_eqFunction_4463(data, threadData);

    PhysicalParticleCO21D_eqFunction_4464(data, threadData);

    PhysicalParticleCO21D_eqFunction_4465(data, threadData);

    PhysicalParticleCO21D_eqFunction_4466(data, threadData);

    PhysicalParticleCO21D_eqFunction_4467(data, threadData);

    PhysicalParticleCO21D_eqFunction_4468(data, threadData);

    PhysicalParticleCO21D_eqFunction_4469(data, threadData);

    PhysicalParticleCO21D_eqFunction_4470(data, threadData);

    PhysicalParticleCO21D_eqFunction_4471(data, threadData);

    PhysicalParticleCO21D_eqFunction_4472(data, threadData);

    PhysicalParticleCO21D_eqFunction_4473(data, threadData);

    PhysicalParticleCO21D_eqFunction_4474(data, threadData);

    PhysicalParticleCO21D_eqFunction_4475(data, threadData);

    PhysicalParticleCO21D_eqFunction_4476(data, threadData);

    PhysicalParticleCO21D_eqFunction_4477(data, threadData);

    PhysicalParticleCO21D_eqFunction_4478(data, threadData);

    PhysicalParticleCO21D_eqFunction_4479(data, threadData);

    PhysicalParticleCO21D_eqFunction_4480(data, threadData);

    PhysicalParticleCO21D_eqFunction_4481(data, threadData);

    PhysicalParticleCO21D_eqFunction_4482(data, threadData);

    PhysicalParticleCO21D_eqFunction_4483(data, threadData);

    PhysicalParticleCO21D_eqFunction_4484(data, threadData);

    PhysicalParticleCO21D_eqFunction_4485(data, threadData);

    PhysicalParticleCO21D_eqFunction_4486(data, threadData);

    PhysicalParticleCO21D_eqFunction_4487(data, threadData);

    PhysicalParticleCO21D_eqFunction_4488(data, threadData);

    PhysicalParticleCO21D_eqFunction_4489(data, threadData);

    PhysicalParticleCO21D_eqFunction_4490(data, threadData);

    PhysicalParticleCO21D_eqFunction_4491(data, threadData);

    PhysicalParticleCO21D_eqFunction_4492(data, threadData);

    PhysicalParticleCO21D_eqFunction_4493(data, threadData);

    PhysicalParticleCO21D_eqFunction_4494(data, threadData);

    PhysicalParticleCO21D_eqFunction_4495(data, threadData);

    PhysicalParticleCO21D_eqFunction_4496(data, threadData);

    PhysicalParticleCO21D_eqFunction_4497(data, threadData);

    PhysicalParticleCO21D_eqFunction_4498(data, threadData);

    PhysicalParticleCO21D_eqFunction_4499(data, threadData);

    PhysicalParticleCO21D_eqFunction_4502(data, threadData);

    PhysicalParticleCO21D_eqFunction_4503(data, threadData);

    PhysicalParticleCO21D_eqFunction_4504(data, threadData);

    PhysicalParticleCO21D_eqFunction_4665(data, threadData);

    PhysicalParticleCO21D_eqFunction_4692(data, threadData);

    PhysicalParticleCO21D_eqFunction_4693(data, threadData);

    PhysicalParticleCO21D_eqFunction_4695(data, threadData);
}

int PhysicalParticleCO21D_functionODE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_FUNCTION_ODE);
#endif

  
  data->simulationInfo->callStatistics.functionODE++;
  
  PhysicalParticleCO21D_functionLocalKnownVars(data, threadData);
  functionODE_system0(data, threadData);

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_FUNCTION_ODE);
#endif

  TRACE_POP
  return 0;
}

/* forward the main in the simulation runtime */
extern int _main_SimulationRuntime(int argc, char**argv, DATA *data, threadData_t *threadData);

#include "PhysicalParticleCO21D_12jac.h"
#include "PhysicalParticleCO21D_13opt.h"

struct OpenModelicaGeneratedFunctionCallbacks PhysicalParticleCO21D_callback = {
   (int (*)(DATA *, threadData_t *, void *)) PhysicalParticleCO21D_performSimulation,
   (int (*)(DATA *, threadData_t *, void *)) PhysicalParticleCO21D_performQSSSimulation,
   PhysicalParticleCO21D_updateContinuousSystem,
   PhysicalParticleCO21D_callExternalObjectDestructors,
   PhysicalParticleCO21D_initialNonLinearSystem,
   PhysicalParticleCO21D_initialLinearSystem,
   NULL,
   #if !defined(OMC_NO_STATESELECTION)
   PhysicalParticleCO21D_initializeStateSets,
   #else
   NULL,
   #endif
   PhysicalParticleCO21D_initializeDAEmodeData,
   PhysicalParticleCO21D_functionODE,
   PhysicalParticleCO21D_functionAlgebraics,
   PhysicalParticleCO21D_functionDAE,
   PhysicalParticleCO21D_functionLocalKnownVars,
   PhysicalParticleCO21D_input_function,
   PhysicalParticleCO21D_input_function_init,
   PhysicalParticleCO21D_input_function_updateStartValues,
   PhysicalParticleCO21D_data_function,
   PhysicalParticleCO21D_output_function,
   PhysicalParticleCO21D_setc_function,
   PhysicalParticleCO21D_function_storeDelayed,
   PhysicalParticleCO21D_updateBoundVariableAttributes,
   PhysicalParticleCO21D_functionInitialEquations,
   1, /* useHomotopy - 0: local homotopy (equidistant lambda), 1: global homotopy (equidistant lambda), 2: new global homotopy approach (adaptive lambda), 3: new local homotopy approach (adaptive lambda)*/
   PhysicalParticleCO21D_functionInitialEquations_lambda0,
   PhysicalParticleCO21D_functionRemovedInitialEquations,
   PhysicalParticleCO21D_updateBoundParameters,
   PhysicalParticleCO21D_checkForAsserts,
   PhysicalParticleCO21D_function_ZeroCrossingsEquations,
   PhysicalParticleCO21D_function_ZeroCrossings,
   PhysicalParticleCO21D_function_updateRelations,
   PhysicalParticleCO21D_zeroCrossingDescription,
   PhysicalParticleCO21D_relationDescription,
   PhysicalParticleCO21D_function_initSample,
   PhysicalParticleCO21D_INDEX_JAC_A,
   PhysicalParticleCO21D_INDEX_JAC_B,
   PhysicalParticleCO21D_INDEX_JAC_C,
   PhysicalParticleCO21D_INDEX_JAC_D,
   PhysicalParticleCO21D_INDEX_JAC_F,
   PhysicalParticleCO21D_initialAnalyticJacobianA,
   PhysicalParticleCO21D_initialAnalyticJacobianB,
   PhysicalParticleCO21D_initialAnalyticJacobianC,
   PhysicalParticleCO21D_initialAnalyticJacobianD,
   PhysicalParticleCO21D_initialAnalyticJacobianF,
   PhysicalParticleCO21D_functionJacA_column,
   PhysicalParticleCO21D_functionJacB_column,
   PhysicalParticleCO21D_functionJacC_column,
   PhysicalParticleCO21D_functionJacD_column,
   PhysicalParticleCO21D_functionJacF_column,
   PhysicalParticleCO21D_linear_model_frame,
   PhysicalParticleCO21D_linear_model_datarecovery_frame,
   PhysicalParticleCO21D_mayer,
   PhysicalParticleCO21D_lagrange,
   PhysicalParticleCO21D_pickUpBoundsForInputsInOptimization,
   PhysicalParticleCO21D_setInputData,
   PhysicalParticleCO21D_getTimeGrid,
   PhysicalParticleCO21D_symbolicInlineSystem,
   PhysicalParticleCO21D_function_initSynchronous,
   PhysicalParticleCO21D_function_updateSynchronous,
   PhysicalParticleCO21D_function_equationsSynchronous,
   PhysicalParticleCO21D_inputNames,
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

#define _OMC_LIT_RESOURCE_3_name_data "PhysicalParticleCO21D"
#define _OMC_LIT_RESOURCE_3_dir_data "/home/philgun/solartherm/examples"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_name,21,_OMC_LIT_RESOURCE_3_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir,33,_OMC_LIT_RESOURCE_3_dir_data);

#define _OMC_LIT_RESOURCE_4_name_data "SolarTherm"
#define _OMC_LIT_RESOURCE_4_dir_data "/home/philgun/.local/lib/omlibrary/SolarTherm"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_name,10,_OMC_LIT_RESOURCE_4_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir,45,_OMC_LIT_RESOURCE_4_dir_data);

static const MMC_DEFSTRUCTLIT(_OMC_LIT_RESOURCES,10,MMC_ARRAY_TAG) {MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir)}};
void PhysicalParticleCO21D_setupDataStruc(DATA *data, threadData_t *threadData)
{
  assertStreamPrint(threadData,0!=data, "Error while initialize Data");
  threadData->localRoots[LOCAL_ROOT_SIMULATION_DATA] = data;
  data->callback = &PhysicalParticleCO21D_callback;
  OpenModelica_updateUriMapping(threadData, MMC_REFSTRUCTLIT(_OMC_LIT_RESOURCES));
  data->modelData->modelName = "PhysicalParticleCO21D";
  data->modelData->modelFilePrefix = "PhysicalParticleCO21D";
  data->modelData->resultFileName = NULL;
  data->modelData->modelDir = "/home/philgun/solartherm/examples";
  data->modelData->modelGUID = "{56297921-d335-4320-a133-36b56da3e230}";
  #if defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME)
  data->modelData->initXMLData = NULL;
  data->modelData->modelDataXml.infoXMLData = NULL;
  #else
  #if defined(_MSC_VER) /* handle joke compilers */
  {
  /* for MSVC we encode a string like char x[] = {'a', 'b', 'c', '\0'} */
  /* because the string constant limit is 65535 bytes */
  static const char contents_init[] =
    #include "PhysicalParticleCO21D_init.c"
    ;
  static const char contents_info[] =
    #include "PhysicalParticleCO21D_info.c"
    ;
    data->modelData->initXMLData = contents_init;
    data->modelData->modelDataXml.infoXMLData = contents_info;
  }
  #else /* handle real compilers */
  data->modelData->initXMLData =
  #include "PhysicalParticleCO21D_init.c"
    ;
  data->modelData->modelDataXml.infoXMLData =
  #include "PhysicalParticleCO21D_info.c"
    ;
  #endif /* defined(_MSC_VER) */
  #endif /* defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME) */
  
  data->modelData->nStates = 17;
  data->modelData->nVariablesReal = 1171;
  data->modelData->nDiscreteReal = 5;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 29;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 830;
  data->modelData->nParametersInteger = 164;
  data->modelData->nParametersBoolean = 141;
  data->modelData->nParametersString = 95;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  
  data->modelData->nAliasReal = 511;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 17;
  data->modelData->nAliasString = 0;
  
  data->modelData->nZeroCrossings = 24;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 25;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 88;
  
  data->modelData->modelDataXml.fileName = "PhysicalParticleCO21D_info.json";
  data->modelData->modelDataXml.modelInfoXmlLength = 0;
  data->modelData->modelDataXml.nFunctions = 130;
  data->modelData->modelDataXml.nProfileBlocks = 0;
  data->modelData->modelDataXml.nEquations = 6395;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 2;
  data->modelData->nNonLinearSystems = 45;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 7;
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
  
    PhysicalParticleCO21D_setupDataStruc(&data, threadData);
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


