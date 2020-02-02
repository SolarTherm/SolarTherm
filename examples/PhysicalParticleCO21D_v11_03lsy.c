/* Linear Systems */
#include "PhysicalParticleCO21D_v11_model.h"
#include "PhysicalParticleCO21D_v11_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* linear systems */

/*
equation index: 3004
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[2] = powerBlock.cooler.h_CO2_des[1] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3004(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3004};
  data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[2] PARAM */ = data->simulationInfo->realParameter[589] /* powerBlock.cooler.h_CO2_des[1] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3005
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[3] = powerBlock.cooler.h_CO2_des[2] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3005(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3005};
  data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[3] PARAM */ = data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[2] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3006
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[4] = powerBlock.cooler.h_CO2_des[3] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3006(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3006};
  data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[4] PARAM */ = data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[3] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3007
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[5] = powerBlock.cooler.h_CO2_des[4] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3007(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3007};
  data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[5] PARAM */ = data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[4] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3008
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[6] = powerBlock.cooler.h_CO2_des[5] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3008(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3008};
  data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[6] PARAM */ = data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[5] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3009
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[7] = powerBlock.cooler.h_CO2_des[6] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3009(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3009};
  data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[7] PARAM */ = data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[6] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3010
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[8] = powerBlock.cooler.h_CO2_des[7] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3010(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3010};
  data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[8] PARAM */ = data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[7] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3011
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[9] = powerBlock.cooler.h_CO2_des[8] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3011(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3011};
  data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[9] PARAM */ = data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[8] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3012
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[10] = powerBlock.cooler.h_CO2_des[9] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3012(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3012};
  data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[10] PARAM */ = data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[9] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3013
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[11] = powerBlock.cooler.h_CO2_des[10] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3013(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3013};
  data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[11] PARAM */ = data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[10] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3014
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[12] = powerBlock.cooler.h_CO2_des[11] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3014(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3014};
  data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[12] PARAM */ = data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[11] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3015
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[13] = powerBlock.cooler.h_CO2_des[12] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3015(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3015};
  data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[13] PARAM */ = data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[12] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 3016
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[14] = powerBlock.cooler.h_CO2_des[13] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_3016(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3016};
  data->simulationInfo->realParameter[602] /* powerBlock.cooler.h_CO2_des[14] PARAM */ = data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[13] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}

void residualFunc3031(void** dataIn, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = (DATA*) ((void**)dataIn[0]);
  threadData_t *threadData = (threadData_t*) ((void**)dataIn[1]);
  const int equationIndexes[2] = {1,3031};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */ = xloc[0];
  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3004(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3005(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3006(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3007(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3008(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3009(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3010(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3011(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3012(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3013(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3014(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3015(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_3016(data, threadData);
  res[0] = data->simulationInfo->realParameter[603] /* powerBlock.cooler.h_CO2_des[15] PARAM */ + (-data->simulationInfo->realParameter[602] /* powerBlock.cooler.h_CO2_des[14] PARAM */) - data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData3031(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for powerBlock.cooler.Q_dis_des */
  linearSystemData->nominal[i] = data->modelData->realParameterData[540].attribute /* powerBlock.cooler.Q_dis_des */.nominal;
  linearSystemData->min[i]     = data->modelData->realParameterData[540].attribute /* powerBlock.cooler.Q_dis_des */.min;
  linearSystemData->max[i++]   = data->modelData->realParameterData[540].attribute /* powerBlock.cooler.Q_dis_des */.max;
}


/*
equation index: 651
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[2] = powerBlock.cooler.h_CO2_des[1] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_651(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,651};
  data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[2] PARAM */ = data->simulationInfo->realParameter[589] /* powerBlock.cooler.h_CO2_des[1] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 652
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[3] = powerBlock.cooler.h_CO2_des[2] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_652(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,652};
  data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[3] PARAM */ = data->simulationInfo->realParameter[590] /* powerBlock.cooler.h_CO2_des[2] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 653
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[4] = powerBlock.cooler.h_CO2_des[3] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_653(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,653};
  data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[4] PARAM */ = data->simulationInfo->realParameter[591] /* powerBlock.cooler.h_CO2_des[3] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 654
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[5] = powerBlock.cooler.h_CO2_des[4] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_654(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,654};
  data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[5] PARAM */ = data->simulationInfo->realParameter[592] /* powerBlock.cooler.h_CO2_des[4] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 655
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[6] = powerBlock.cooler.h_CO2_des[5] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_655(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,655};
  data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[6] PARAM */ = data->simulationInfo->realParameter[593] /* powerBlock.cooler.h_CO2_des[5] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 656
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[7] = powerBlock.cooler.h_CO2_des[6] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_656(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,656};
  data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[7] PARAM */ = data->simulationInfo->realParameter[594] /* powerBlock.cooler.h_CO2_des[6] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 657
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[8] = powerBlock.cooler.h_CO2_des[7] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_657(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,657};
  data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[8] PARAM */ = data->simulationInfo->realParameter[595] /* powerBlock.cooler.h_CO2_des[7] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 658
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[9] = powerBlock.cooler.h_CO2_des[8] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_658(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,658};
  data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[9] PARAM */ = data->simulationInfo->realParameter[596] /* powerBlock.cooler.h_CO2_des[8] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 659
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[10] = powerBlock.cooler.h_CO2_des[9] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_659(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,659};
  data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[10] PARAM */ = data->simulationInfo->realParameter[597] /* powerBlock.cooler.h_CO2_des[9] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 660
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[11] = powerBlock.cooler.h_CO2_des[10] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_660(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,660};
  data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[11] PARAM */ = data->simulationInfo->realParameter[598] /* powerBlock.cooler.h_CO2_des[10] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 661
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[12] = powerBlock.cooler.h_CO2_des[11] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_661(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,661};
  data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[12] PARAM */ = data->simulationInfo->realParameter[599] /* powerBlock.cooler.h_CO2_des[11] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 662
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[13] = powerBlock.cooler.h_CO2_des[12] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_662(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,662};
  data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[13] PARAM */ = data->simulationInfo->realParameter[600] /* powerBlock.cooler.h_CO2_des[12] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
/*
equation index: 663
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des[14] = powerBlock.cooler.h_CO2_des[13] + powerBlock.cooler.Q_dis_des
*/
void PhysicalParticleCO21D_v11_eqFunction_663(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,663};
  data->simulationInfo->realParameter[602] /* powerBlock.cooler.h_CO2_des[14] PARAM */ = data->simulationInfo->realParameter[601] /* powerBlock.cooler.h_CO2_des[13] PARAM */ + data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}

void residualFunc678(void** dataIn, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = (DATA*) ((void**)dataIn[0]);
  threadData_t *threadData = (threadData_t*) ((void**)dataIn[1]);
  const int equationIndexes[2] = {1,678};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */ = xloc[0];
  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_651(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_652(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_653(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_654(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_655(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_656(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_657(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_658(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_659(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_660(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_661(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_662(data, threadData);

  /* local constraints */
  PhysicalParticleCO21D_v11_eqFunction_663(data, threadData);
  res[0] = data->simulationInfo->realParameter[603] /* powerBlock.cooler.h_CO2_des[15] PARAM */ + (-data->simulationInfo->realParameter[602] /* powerBlock.cooler.h_CO2_des[14] PARAM */) - data->simulationInfo->realParameter[540] /* powerBlock.cooler.Q_dis_des PARAM */;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData678(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for powerBlock.cooler.Q_dis_des */
  linearSystemData->nominal[i] = data->modelData->realParameterData[540].attribute /* powerBlock.cooler.Q_dis_des */.nominal;
  linearSystemData->min[i]     = data->modelData->realParameterData[540].attribute /* powerBlock.cooler.Q_dis_des */.min;
  linearSystemData->max[i++]   = data->modelData->realParameterData[540].attribute /* powerBlock.cooler.Q_dis_des */.max;
}

/* Prototypes for the strict sets (Dynamic Tearing) */

/* Global constraints for the casual sets */
/* function initialize linear systems */
void PhysicalParticleCO21D_v11_initialLinearSystem(int nLinearSystems, LINEAR_SYSTEM_DATA* linearSystemData)
{
  /* linear systems */
  assertStreamPrint(NULL, nLinearSystems > 1, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[1].equationIndex = 3031;
  linearSystemData[1].size = 1;
  linearSystemData[1].nnz = 0;
  linearSystemData[1].method = 1;   /* Symbolic Jacobian available */
  linearSystemData[1].residualFunc = residualFunc3031;
  linearSystemData[1].strictTearingFunctionCall = NULL;
  linearSystemData[1].analyticalJacobianColumn = PhysicalParticleCO21D_v11_functionJacLSJac33_column;
  linearSystemData[1].initialAnalyticalJacobian = PhysicalParticleCO21D_v11_initialAnalyticJacobianLSJac33;
  linearSystemData[1].jacobianIndex = 1 /*jacInx*/;
  linearSystemData[1].setA = NULL;  //setLinearMatrixA3031;
  linearSystemData[1].setb = NULL;  //setLinearVectorb3031;
  linearSystemData[1].initializeStaticLSData = initializeStaticLSData3031;
  
  assertStreamPrint(NULL, nLinearSystems > 0, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[0].equationIndex = 678;
  linearSystemData[0].size = 1;
  linearSystemData[0].nnz = 0;
  linearSystemData[0].method = 1;   /* Symbolic Jacobian available */
  linearSystemData[0].residualFunc = residualFunc678;
  linearSystemData[0].strictTearingFunctionCall = NULL;
  linearSystemData[0].analyticalJacobianColumn = PhysicalParticleCO21D_v11_functionJacLSJac7_column;
  linearSystemData[0].initialAnalyticalJacobian = PhysicalParticleCO21D_v11_initialAnalyticJacobianLSJac7;
  linearSystemData[0].jacobianIndex = 0 /*jacInx*/;
  linearSystemData[0].setA = NULL;  //setLinearMatrixA678;
  linearSystemData[0].setb = NULL;  //setLinearVectorb678;
  linearSystemData[0].initializeStaticLSData = initializeStaticLSData678;
}

#if defined(__cplusplus)
}
#endif

