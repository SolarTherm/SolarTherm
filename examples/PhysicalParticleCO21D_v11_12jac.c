/* Jacobians 7 */
#include "PhysicalParticleCO21D_v11_model.h"
#include "PhysicalParticleCO21D_v11_12jac.h"
/* constant equations */
/* dynamic equations */

/*
equation index: 665
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] = 2.0 * powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_665(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,665};
  jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] JACOBIAN_DIFF_VAR */ = (2.0) * (jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */);
  TRACE_POP
}

/*
equation index: 666
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_666(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,666};
  jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[3] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 667
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_667(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,667};
  jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[4] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 668
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_668(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,668};
  jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[5] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 669
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_669(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,669};
  jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[6] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 670
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_670(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,670};
  jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[7] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 671
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_671(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,671};
  jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[8] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 672
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_672(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,672};
  jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[9] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 673
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_673(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,673};
  jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[10] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 674
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_674(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,674};
  jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[11] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 675
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_675(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,675};
  jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[12] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 676
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14] = powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] + powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_676(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,676};
  jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[13] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 677
type: SIMPLE_ASSIGN
$res1.$pDERLSJac7.dummyVarLSJac7 = (-powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14]) - powerBlock.cooler.Q_dis_des.SeedLSJac7
*/
void PhysicalParticleCO21D_v11_eqFunction_677(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,677};
  jacobian->resultVars[0] /* $res1.$pDERLSJac7.dummyVarLSJac7 JACOBIAN_VAR */ = (-jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac7.dummyVarLSJac7[14] JACOBIAN_DIFF_VAR */) - jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac7 SEED_VAR */;
  TRACE_POP
}

OMC_DISABLE_OPT
int PhysicalParticleCO21D_v11_functionJacLSJac7_constantEqns(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_v11_INDEX_JAC_LSJac7;
  
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_functionJacLSJac7_column(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_v11_INDEX_JAC_LSJac7;
  PhysicalParticleCO21D_v11_eqFunction_665(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_666(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_667(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_668(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_669(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_670(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_671(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_672(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_673(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_674(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_675(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_676(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_677(data, threadData, jacobian, parentJacobian);
  TRACE_POP
  return 0;
}
/* constant equations */
/* dynamic equations */

/*
equation index: 3018
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[3] = 2.0 * powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3018(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3018};
  jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[3] JACOBIAN_DIFF_VAR */ = (2.0) * (jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */);
  TRACE_POP
}

/*
equation index: 3019
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[4] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[3] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3019(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3019};
  jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[4] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[1] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[3] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3020
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[5] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[4] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3020(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3020};
  jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[5] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[2] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[4] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3021
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[6] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[5] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3021(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3021};
  jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[6] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[3] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[5] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3022
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[7] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[6] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3022(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3022};
  jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[7] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[4] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[6] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3023
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[8] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[7] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3023(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3023};
  jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[8] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[5] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[7] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3024
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[9] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[8] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3024(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3024};
  jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[9] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[6] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[8] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3025
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[10] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[9] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3025(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3025};
  jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[10] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[7] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[9] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3026
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[11] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[10] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3026(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3026};
  jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[11] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[8] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[10] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3027
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[12] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[11] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3027(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3027};
  jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[12] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[9] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[11] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3028
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[13] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[12] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3028(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3028};
  jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[13] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[10] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[12] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3029
type: SIMPLE_ASSIGN
powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[14] = powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[13] + powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3029(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3029};
  jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[14] JACOBIAN_DIFF_VAR */ = jacobian->tmpVars[11] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[13] JACOBIAN_DIFF_VAR */ + jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

/*
equation index: 3030
type: SIMPLE_ASSIGN
$res1.$pDERLSJac33.dummyVarLSJac33 = (-powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[14]) - powerBlock.cooler.Q_dis_des.SeedLSJac33
*/
void PhysicalParticleCO21D_v11_eqFunction_3030(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int clockIndex = 0;
  const int equationIndexes[2] = {1,3030};
  jacobian->resultVars[0] /* $res1.$pDERLSJac33.dummyVarLSJac33 JACOBIAN_VAR */ = (-jacobian->tmpVars[12] /* powerBlock.cooler.h_CO2_des.$pDERLSJac33.dummyVarLSJac33[14] JACOBIAN_DIFF_VAR */) - jacobian->seedVars[0] /* powerBlock.cooler.Q_dis_des.SeedLSJac33 SEED_VAR */;
  TRACE_POP
}

OMC_DISABLE_OPT
int PhysicalParticleCO21D_v11_functionJacLSJac33_constantEqns(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_v11_INDEX_JAC_LSJac33;
  
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_functionJacLSJac33_column(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_v11_INDEX_JAC_LSJac33;
  PhysicalParticleCO21D_v11_eqFunction_3018(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3019(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3020(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3021(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3022(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3023(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3024(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3025(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3026(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3027(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3028(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3029(data, threadData, jacobian, parentJacobian);
  PhysicalParticleCO21D_v11_eqFunction_3030(data, threadData, jacobian, parentJacobian);
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_v11_functionJacF_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_v11_functionJacD_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_v11_functionJacC_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int PhysicalParticleCO21D_v11_functionJacB_column(void* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
/* constant equations */
/* dynamic equations */

OMC_DISABLE_OPT
int PhysicalParticleCO21D_v11_functionJacA_constantEqns(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_v11_INDEX_JAC_A;
  
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_functionJacA_column(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  DATA* data = ((DATA*)inData);
  int index = PhysicalParticleCO21D_v11_INDEX_JAC_A;
  TRACE_POP
  return 0;
}

OMC_DISABLE_OPT
int PhysicalParticleCO21D_v11_initialAnalyticJacobianLSJac7(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
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
int PhysicalParticleCO21D_v11_initialAnalyticJacobianLSJac33(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
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
int PhysicalParticleCO21D_v11_initialAnalyticJacobianF(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
int PhysicalParticleCO21D_v11_initialAnalyticJacobianD(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
int PhysicalParticleCO21D_v11_initialAnalyticJacobianC(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
int PhysicalParticleCO21D_v11_initialAnalyticJacobianB(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 1;
}
OMC_DISABLE_OPT
int PhysicalParticleCO21D_v11_initialAnalyticJacobianA(void* inData, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
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


