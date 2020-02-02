/* Linear Systems */
#include "PhysicalParticleCO21D_model.h"
#include "PhysicalParticleCO21D_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* linear systems */

/*
equation index: 3040
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[2] = powerBlock.cooler.h_CO2_des[1] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3040(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3040};
  data->simulationInfo->realParameter[589] /* powerBlock.cooler.h_CO2_des[2] PARAM */ = data->simulationInfo->realParameter[588] /* powerBlock.cooler.h_CO2_des[1] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3041
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[3] = powerBlock.cooler.h_CO2_des[2] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3041(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3041};
  data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[3] PARAM */ = data->simulationInfo->realParameter[589] /* powerBlock.cooler.h_CO2_des[2] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3042
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[4] = powerBlock.cooler.h_CO2_des[3] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3042(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3042};
  data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[4] PARAM */ = data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[3] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3043
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[5] = powerBlock.cooler.h_CO2_des[4] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3043(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3043};
  data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[5] PARAM */ = data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[4] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3044
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[6] = powerBlock.cooler.h_CO2_des[5] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3044(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3044};
  data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[6] PARAM */ = data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[5] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3045
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[7] = powerBlock.cooler.h_CO2_des[6] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3045(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3045};
  data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[7] PARAM */ = data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[6] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3046
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[8] = powerBlock.cooler.h_CO2_des[7] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3046(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3046};
  data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[8] PARAM */ = data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[7] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3047
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[9] = powerBlock.cooler.h_CO2_des[8] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3047(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3047};
  data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[9] PARAM */ = data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[8] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3048
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[10] = powerBlock.cooler.h_CO2_des[9] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3048(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3048};
  data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[10] PARAM */ = data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[9] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3049
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[11] = powerBlock.cooler.h_CO2_des[10] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3049(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3049};
  data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[11] PARAM */ = data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[10] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3050
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[12] = powerBlock.cooler.h_CO2_des[11] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3050(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3050};
  data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[12] PARAM */ = data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[11] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3051
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[13] = powerBlock.cooler.h_CO2_des[12] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3051(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3051};
  data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[13] PARAM */ = data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[12] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3052
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[14] = powerBlock.cooler.h_CO2_des[13] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_3052(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3052};
  data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[14] PARAM */ = data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[13] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}

void residualFunc3067(void** dataIn, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = (DATA*) ((void**)dataIn[0]);
  threadData_t *threadData = (threadData_t*) ((void**)dataIn[1]);
  const int equationIndexes[2] = {1,3067};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */ = xloc[0];
  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3040(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3041(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3042(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3043(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3044(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3045(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3046(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3047(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3048(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3049(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3050(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3051(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_3052(data, threadData);
  res[0] = data->simulationInfo->realParameter[602] /* powerBlock.cooler.h_CO2_des[15] PARAM */ + (-data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[14] PARAM */) - data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData3067(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for powerBlock.cooler.Q_dis_des */
  linearSystemData->nominal[i] = data->modelData->realParameterData[539].attribute /* powerBlock.cooler.Q_dis_des */.nominal;
  linearSystemData->min[i]     = data->modelData->realParameterData[539].attribute /* powerBlock.cooler.Q_dis_des */.min;
  linearSystemData->max[i++]   = data->modelData->realParameterData[539].attribute /* powerBlock.cooler.Q_dis_des */.max;
}


/*
equation index: 672
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[2] = powerBlock.cooler.h_CO2_des[1] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_672(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,672};
  data->simulationInfo->realParameter[589] /* powerBlock.cooler.h_CO2_des[2] PARAM */ = data->simulationInfo->realParameter[588] /* powerBlock.cooler.h_CO2_des[1] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 673
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[3] = powerBlock.cooler.h_CO2_des[2] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_673(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,673};
  data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[3] PARAM */ = data->simulationInfo->realParameter[589] /* powerBlock.cooler.h_CO2_des[2] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 674
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[4] = powerBlock.cooler.h_CO2_des[3] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_674(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,674};
  data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[4] PARAM */ = data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[3] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 675
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[5] = powerBlock.cooler.h_CO2_des[4] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_675(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,675};
  data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[5] PARAM */ = data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[4] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 676
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[6] = powerBlock.cooler.h_CO2_des[5] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_676(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,676};
  data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[6] PARAM */ = data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[5] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 677
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[7] = powerBlock.cooler.h_CO2_des[6] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_677(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,677};
  data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[7] PARAM */ = data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[6] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 678
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[8] = powerBlock.cooler.h_CO2_des[7] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_678(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,678};
  data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[8] PARAM */ = data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[7] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 679
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[9] = powerBlock.cooler.h_CO2_des[8] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_679(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,679};
  data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[9] PARAM */ = data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[8] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 680
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[10] = powerBlock.cooler.h_CO2_des[9] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_680(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,680};
  data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[10] PARAM */ = data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[9] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 681
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[11] = powerBlock.cooler.h_CO2_des[10] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_681(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,681};
  data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[11] PARAM */ = data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[10] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 682
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[12] = powerBlock.cooler.h_CO2_des[11] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_682(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,682};
  data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[12] PARAM */ = data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[11] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 683
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[13] = powerBlock.cooler.h_CO2_des[12] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_683(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,683};
  data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[13] PARAM */ = data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[12] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 684
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[14] = powerBlock.cooler.h_CO2_des[13] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_eqFunction_684(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,684};
  data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[14] PARAM */ = data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[13] PARAM */ + data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}

void residualFunc699(void** dataIn, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = (DATA*) ((void**)dataIn[0]);
  threadData_t *threadData = (threadData_t*) ((void**)dataIn[1]);
  const int equationIndexes[2] = {1,699};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */ = xloc[0];
  /* local constraints */
  PhysicalParticleCO21D_eqFunction_672(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_673(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_674(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_675(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_676(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_677(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_678(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_679(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_680(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_681(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_682(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_683(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_eqFunction_684(data, threadData);
  res[0] = data->simulationInfo->realParameter[602] /* powerBlock.cooler.h_CO2_des[15] PARAM */ + (-data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[14] PARAM */) - data->simulationInfo->realParameter[539] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData699(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for powerBlock.cooler.Q_dis_des */
  linearSystemData->nominal[i] = data->modelData->realParameterData[539].attribute /* powerBlock.cooler.Q_dis_des */.nominal;
  linearSystemData->min[i]     = data->modelData->realParameterData[539].attribute /* powerBlock.cooler.Q_dis_des */.min;
  linearSystemData->max[i++]   = data->modelData->realParameterData[539].attribute /* powerBlock.cooler.Q_dis_des */.max;
}

/* Prototypes for the strict sets (Dynamic Tearing) */

/* Global constraints for the casual sets */
/* function initialize linear systems */
void PhysicalParticleCO21D_initialLinearSystem(int nLinearSystems, LINEAR_SYSTEM_DATA* linearSystemData)
{
  /* linear systems */
  assertStreamPrint(NULL, nLinearSystems > 1, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[1].equationIndex = 3067;
  linearSystemData[1].size = 1;
  linearSystemData[1].nnz = 0;
  linearSystemData[1].method = 1;   /* Symbolic Jacobian available */
  linearSystemData[1].residualFunc = residualFunc3067;
  linearSystemData[1].strictTearingFunctionCall = NULL;
  linearSystemData[1].analyticalJacobianColumn = PhysicalParticleCO21D_functionJacLSJac32_column;
  linearSystemData[1].initialAnalyticalJacobian = PhysicalParticleCO21D_initialAnalyticJacobianLSJac32;
  linearSystemData[1].jacobianIndex = 1 /*jacInx*/;
  linearSystemData[1].setA = NULL;  //setLinearMatrixA3067;
  linearSystemData[1].setb = NULL;  //setLinearVectorb3067;
  linearSystemData[1].initializeStaticLSData = initializeStaticLSData3067;
  
  assertStreamPrint(NULL, nLinearSystems > 0, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[0].equationIndex = 699;
  linearSystemData[0].size = 1;
  linearSystemData[0].nnz = 0;
  linearSystemData[0].method = 1;   /* Symbolic Jacobian available */
  linearSystemData[0].residualFunc = residualFunc699;
  linearSystemData[0].strictTearingFunctionCall = NULL;
  linearSystemData[0].analyticalJacobianColumn = PhysicalParticleCO21D_functionJacLSJac7_column;
  linearSystemData[0].initialAnalyticalJacobian = PhysicalParticleCO21D_initialAnalyticJacobianLSJac7;
  linearSystemData[0].jacobianIndex = 0 /*jacInx*/;
  linearSystemData[0].setA = NULL;  //setLinearMatrixA699;
  linearSystemData[0].setb = NULL;  //setLinearVectorb699;
  linearSystemData[0].initializeStaticLSData = initializeStaticLSData699;
}

#if defined(__cplusplus)
}
#endif

