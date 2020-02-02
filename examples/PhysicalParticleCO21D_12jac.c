/* Jacobians 7 */
#include "PhysicalParticleCO21D_model.h"
#include "PhysicalParticleCO21D_12jac.h"
/* constant equations */
/* dynamic equations */

/*
equation index: 686
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] = 2.0 * powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_686(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,686};
  jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] JACOBIAN_DIFF_VAR */ = (2.0) * (jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */);
  TRACE_POP
}

/*
equation index: 687
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_687(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,687};
  jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 688
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_688(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,688};
  jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 689
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_689(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,689};
  jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 690
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_690(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,690};
  jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 691
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_691(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,691};
  jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 692
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_692(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,692};
  jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 693
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_693(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,693};
  jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 694
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_694(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,694};
  jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 695
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_695(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,695};
  jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 696
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_696(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,696};
  jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 697
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_697(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,697};
  jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 698
type: SIMPLE_ASSIGN
$res1.$pDERLSJac7.dummyVarLSJac7 = (-powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14]) - powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_eqFunction_698(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,698};
  jacobian->resultVars[0] /* $res1.$pDERLSJac7.dummyVarLSJac7 JACOBIAN_VAR */ = (-jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14] JACOBIAN_DIFF_VAR */) - jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

OMC_DISABLE_OPT
int PhysicalParticleCO21D_functionJacLSJac7_constantEqns(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_INDEX_JAC_LSJac7;
  
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_functionJacLSJac7_column(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_INDEX_JAC_LSJac7;
  PhysicalParticleCO21D_eqFunction_686(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_687(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_688(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_689(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_690(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_691(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_692(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_693(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_694(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_695(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_696(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_697(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_698(data, threadData, jacobian, parentJacobian);
  TRACE_POP
  return 0;
}
/* constant equations */
/* dynamic equations */

/*
equation index: 3054
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[3] = 2.0 * powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3054(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3054};
  jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[3] JACOBIAN_DIFF_VAR */ = (2.0) * (jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */);
  TRACE_POP
}

/*
equation index: 3055
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[4] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[3] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3055(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3055};
  jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[4] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[3] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3056
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[5] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[4] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3056(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3056};
  jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[5] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[4] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3057
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[6] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[5] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3057(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3057};
  jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[6] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[5] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3058
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[7] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[6] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3058(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3058};
  jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[7] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[6] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3059
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[8] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[7] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3059(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3059};
  jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[8] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[7] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3060
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[9] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[8] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3060(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3060};
  jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[9] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[8] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3061
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[10] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[9] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3061(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3061};
  jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[10] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[9] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3062
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[11] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[10] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3062(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3062};
  jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[11] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[10] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3063
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[12] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[11] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3063(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3063};
  jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[12] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[11] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3064
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[13] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[12] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3064(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3064};
  jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[13] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[12] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3065
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[14] = powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[13] + powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3065(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3065};
  jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[14] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[13] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3066
type: SIMPLE_ASSIGN
$res1.$pDERLSJac32.dummyVarLSJac32 = (-powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[14]) - powerBlock.cooler.Q_dis_des.SeedLSJac32
*/
void PhysicalParticleCO21D_eqFunction_3066(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3066};
  jacobian->resultVars[0] /* $res1.$pDERLSJac32.dummyVarLSJac32 JACOBIAN_VAR */ = (-jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac32.dummyVarLSJac32[14] JACOBIAN_DIFF_VAR */) - jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac32 SEED_VAR */;
  TRACE_POP
}

OMC_DISABLE_OPT
int PhysicalParticleCO21D_functionJacLSJac32_constantEqns(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_INDEX_JAC_LSJac32;
  
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_functionJacLSJac32_column(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_INDEX_JAC_LSJac32;
  PhysicalParticleCO21D_eqFunction_3054(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3055(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3056(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3057(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3058(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3059(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3060(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3061(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3062(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3063(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3064(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3065(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_eqFunction_3066(data, threadData, jacobian, parentJacobian);
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_functionJacF_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_functionJacD_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_functionJacC_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_functionJacB_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
/* constant equations */
/* dynamic equations */

OMC_DISABLE_OPT
int PhysicalParticleCO21D_functionJacA_constantEqns(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_INDEX_JAC_A;
  
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_functionJacA_column(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_INDEX_JAC_A;
  TRACE_POP
  return 0;
}

OMC_DISABLE_OPT
int PhysicalParticleCO21D_initialAnalyticJacobianLSJac7(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  DATA* data = ((DATA*)inData);
  const int colPtrIndex[1+1] = {0,1};
  const int rowIndex[1] = {0};
  int i = 0;
  
  jacobian->sizeCols = 1;
  jacobian->sizeRows = 1;
  jacobian->sizeTmpVars = 14;
  jacobian->seedVars = (modelica_real*) calloc(1,sizeof(modelica_real));
  jacobian->resultVars = (modelica_real*) calloc(1,sizeof(modelica_real));
  jacobian->tmpVars = (modelica_real*) calloc(14,sizeof(modelica_real));
  jacobian->sparsePattern = (SPARSE_PATTERN*) malloc(sizeof(SPARSE_PATTERN));
  jacobian->sparsePattern->leadindex = (unsigned int*) malloc((1+1)*sizeof(int));
  jacobian->sparsePattern->index = (unsigned int*) malloc(1*sizeof(int));
  jacobian->sparsePattern->numberOfNoneZeros = 1;
  jacobian->sparsePattern->colorCols = (unsigned int*) malloc(1*sizeof(int));
  jacobian->sparsePattern->maxColors = 1;
  jacobian->constantEqns = NULL;
  
  /* write lead index of compressed sparse column */
  memcpy(jacobian->sparsePattern->leadindex, colPtrIndex, (1+1)*sizeof(int));
  
  for(i=2;i<1+1;++i)
    jacobian->sparsePattern->leadindex[i] += jacobian->sparsePattern->leadindex[i-1];
  
  /* call sparse index */
  memcpy(jacobian->sparsePattern->index, rowIndex, 1*sizeof(int));
  
  /* write color array */
  jacobian->sparsePattern->colorCols[0] = 1;
  TRACE_POP
  return 0;
}
OMC_DISABLE_OPT
int PhysicalParticleCO21D_initialAnalyticJacobianLSJac32(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  DATA* data = ((DATA*)inData);
  const int colPtrIndex[1+1] = {0,1};
  const int rowIndex[1] = {0};
  int i = 0;
  
  jacobian->sizeCols = 1;
  jacobian->sizeRows = 1;
  jacobian->sizeTmpVars = 14;
  jacobian->seedVars = (modelica_real*) calloc(1,sizeof(modelica_real));
  jacobian->resultVars = (modelica_real*) calloc(1,sizeof(modelica_real));
  jacobian->tmpVars = (modelica_real*) calloc(14,sizeof(modelica_real));
  jacobian->sparsePattern = (SPARSE_PATTERN*) malloc(sizeof(SPARSE_PATTERN));
  jacobian->sparsePattern->leadindex = (unsigned int*) malloc((1+1)*sizeof(int));
  jacobian->sparsePattern->index = (unsigned int*) malloc(1*sizeof(int));
  jacobian->sparsePattern->numberOfNoneZeros = 1;
  jacobian->sparsePattern->colorCols = (unsigned int*) malloc(1*sizeof(int));
  jacobian->sparsePattern->maxColors = 1;
  jacobian->constantEqns = NULL;
  
  /* write lead index of compressed sparse column */
  memcpy(jacobian->sparsePattern->leadindex, colPtrIndex, (1+1)*sizeof(int));
  
  for(i=2;i<1+1;++i)
    jacobian->sparsePattern->leadindex[i] += jacobian->sparsePattern->leadindex[i-1];
  
  /* call sparse index */
  memcpy(jacobian->sparsePattern->index, rowIndex, 1*sizeof(int));
  
  /* write color array */
  jacobian->sparsePattern->colorCols[0] = 1;
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_initialAnalyticJacobianF(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
int PhysicalParticleCO21D_initialAnalyticJacobianD(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
int PhysicalParticleCO21D_initialAnalyticJacobianC(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
int PhysicalParticleCO21D_initialAnalyticJacobianB(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
OMC_DISABLE_OPT
int PhysicalParticleCO21D_initialAnalyticJacobianA(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  DATA* data = ((DATA*)inData);
  const int colPtrIndex[1+17] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,11,14,8};
  const int rowIndex[47] = {0,2,4,5,6,7,8,10,11,12,13,14,15,16,0,4,5,6,8,11,12,13,14,15,16,0,2,4,5,6,7,8,10,11,12,13,14,15,16,0,4,5,6,11,12,14,16};
  int i = 0;
  
  jacobian->sizeCols = 17;
  jacobian->sizeRows = 17;
  jacobian->sizeTmpVars = 0;
  jacobian->seedVars = (modelica_real*) calloc(17,sizeof(modelica_real));
  jacobian->resultVars = (modelica_real*) calloc(17,sizeof(modelica_real));
  jacobian->tmpVars = (modelica_real*) calloc(0,sizeof(modelica_real));
  jacobian->sparsePattern = (SPARSE_PATTERN*) malloc(sizeof(SPARSE_PATTERN));
  jacobian->sparsePattern->leadindex = (unsigned int*) malloc((17+1)*sizeof(int));
  jacobian->sparsePattern->index = (unsigned int*) malloc(47*sizeof(int));
  jacobian->sparsePattern->numberOfNoneZeros = 47;
  jacobian->sparsePattern->colorCols = (unsigned int*) malloc(17*sizeof(int));
  jacobian->sparsePattern->maxColors = 4;
  jacobian->constantEqns = NULL;
  
  /* write lead index of compressed sparse column */
  memcpy(jacobian->sparsePattern->leadindex, colPtrIndex, (17+1)*sizeof(int));
  
  for(i=2;i<17+1;++i)
    jacobian->sparsePattern->leadindex[i] += jacobian->sparsePattern->leadindex[i-1];
  
  /* call sparse index */
  memcpy(jacobian->sparsePattern->index, rowIndex, 47*sizeof(int));
  
  /* write color array */
  jacobian->sparsePattern->colorCols[14] = 1;
  jacobian->sparsePattern->colorCols[13] = 2;
  jacobian->sparsePattern->colorCols[16] = 3;
  jacobian->sparsePattern->colorCols[10] = 4;
  jacobian->sparsePattern->colorCols[15] = 4;
  jacobian->sparsePattern->colorCols[12] = 4;
  jacobian->sparsePattern->colorCols[11] = 4;
  jacobian->sparsePattern->colorCols[0] = 4;
  jacobian->sparsePattern->colorCols[9] = 4;
  jacobian->sparsePattern->colorCols[1] = 4;
  jacobian->sparsePattern->colorCols[3] = 4;
  jacobian->sparsePattern->colorCols[2] = 4;
  jacobian->sparsePattern->colorCols[7] = 4;
  jacobian->sparsePattern->colorCols[8] = 4;
  jacobian->sparsePattern->colorCols[5] = 4;
  jacobian->sparsePattern->colorCols[4] = 4;
  jacobian->sparsePattern->colorCols[6] = 4;
  TRACE_POP
  return 0;
}


