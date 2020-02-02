/* Main Simulation File */

#if defined(__cplusplus)
extern "C" {
#endif

#include "PhysicalParticleCO21D_v11_model.h"
#include "simulation/solver/events.h"

#define prefixedName_performSimulation PhysicalParticleCO21D_v11_performSimulation
#define prefixedName_updateContinuousSystem PhysicalParticleCO21D_v11_updateContinuousSystem
#include <simulation/solver/perform_simulation.c.inc>

#define prefixedName_performQSSSimulation PhysicalParticleCO21D_v11_performQSSSimulation
#include <simulation/solver/perform_qss_simulation.c.inc>

/* dummy VARINFO and FILEINFO */
const FILE_INFO dummyFILE_INFO = omc_dummyFileInfo;
const VAR_INFO dummyVAR_INFO = omc_dummyVarInfo;

int PhysicalParticleCO21D_v11_input_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_input_function_init(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_input_function_updateStartValues(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_inputNames(DATA *data, char ** names){
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_data_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_output_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_setc_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


/*
equation index: 3803
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.mdot = particleReceiver1DCalculator.liftSimple.m_flow_fixed
*/
void PhysicalParticleCO21D_v11_eqFunction_3803(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3803};
  data->localData[0]->realVars[404] /* particleReceiver1DCalculator.particleReceiver1D_v11.mdot variable */ = data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */;
  TRACE_POP
}
/*
equation index: 3804
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.phi[1] = particleReceiver1DCalculator.particleReceiver1D_v11.phi_max
*/
void PhysicalParticleCO21D_v11_eqFunction_3804(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3804};
  data->localData[0]->realVars[405] /* particleReceiver1DCalculator.particleReceiver1D_v11.phi[1] variable */ = data->simulationInfo->realParameter[270] /* particleReceiver1DCalculator.particleReceiver1D_v11.phi_max PARAM */;
  TRACE_POP
}
/*
equation index: 3805
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1DCalculator$particleReceiver1D_v11$Tab.getTableValue(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableID, 1, 1073.15, particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_3805(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3805};
  data->localData[0]->realVars[382] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] variable */ = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_getTableValue(threadData, data->simulationInfo->extObjs[22], ((modelica_integer) 1), 1073.15, data->simulationInfo->realParameter[254] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 3806
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1DCalculator$particleReceiver1D_v11$Tab.getTableValue(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableID, 1, particleReceiver1DCalculator.particleReceiver1D_v11.T_s[1], particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_3806(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3806};
  data->localData[0]->realVars[362] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] variable */ = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_getTableValue(threadData, data->simulationInfo->extObjs[2], ((modelica_integer) 1), data->localData[0]->realVars[238] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[1] variable */, data->simulationInfo->realParameter[234] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 3807
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec = max(particleReceiver1DCalculator.liftSimple.m_flow_fixed * (particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] - particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1]), 0.0)
*/
void PhysicalParticleCO21D_v11_eqFunction_3807(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3807};
  data->localData[0]->realVars[231] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec variable */ = fmax((data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */) * (data->localData[0]->realVars[382] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] variable */ - data->localData[0]->realVars[362] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] variable */),0.0);
  TRACE_POP
}
void PhysicalParticleCO21D_v11_eqFunction_3808(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3809(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3810(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3811(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3812(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3813(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3814(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3815(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3816(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3817(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3818(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3819(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3820(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3821(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3822(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3823(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3824(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3825(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3826(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3827(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3828(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3829(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3830(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3831(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3832(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3833(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3834(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3835(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3836(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3837(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3838(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3839(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3840(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3841(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3842(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3843(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3844(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3845(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3846(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3847(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3848(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3849(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3850(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3851(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3852(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3853(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3854(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3855(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3856(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3857(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3858(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3859(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3860(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3861(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3862(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3863(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3864(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3865(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3866(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3867(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3868(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3869(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3870(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3871(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3872(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3873(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3874(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3875(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3876(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3877(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3878(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3879(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3880(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3881(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3882(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3883(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3884(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3885(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3886(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3887(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3888(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3889(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3890(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3891(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3892(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3893(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3894(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3895(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3896(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3897(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3898(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3899(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3900(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3901(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3902(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3903(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3904(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3905(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3906(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3907(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3908(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3909(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3910(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3911(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3912(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3913(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3914(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3915(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3916(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3917(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3918(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3919(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3920(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3921(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3922(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3923(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3924(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3925(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3926(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3927(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3928(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3929(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3930(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3931(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3932(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3933(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3934(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3935(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3936(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3937(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3938(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3939(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3940(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3941(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3942(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3943(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3944(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3945(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3946(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3947(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3948(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3949(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3950(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3951(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3952(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3953(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3954(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3955(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3956(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3957(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3958(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3959(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3960(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3961(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3962(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3963(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3964(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3965(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3966(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3967(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3968(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3969(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3970(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3971(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3972(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3973(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3974(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3975(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3976(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3977(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3978(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3979(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3980(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3981(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3982(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3983(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3984(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3985(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3986(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3987(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3988(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4048(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4047(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4046(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4045(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4044(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4043(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4042(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4041(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4040(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4039(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4038(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4037(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4036(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4035(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4034(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4033(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4032(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4031(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4030(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4029(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4028(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4027(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4026(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4025(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4024(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4023(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4022(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4021(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4020(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4019(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4018(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4017(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4016(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4015(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4014(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4013(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4012(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4011(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4010(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4009(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4008(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4007(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4006(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4005(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4004(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4003(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4002(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4001(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4000(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3999(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3998(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3997(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3996(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3995(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3994(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3993(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3992(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3991(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3990(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_3989(DATA*, threadData_t*);
/*
equation index: 4049
indexNonlinear: 44
type: NONLINEAR

vars: {particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[22], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[1], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2], particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2], particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[12], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[20], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[19], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[18], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[16], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[17], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[15], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[14], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[13], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[11], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[10], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[9], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[8], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[7], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[6], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[4], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[5], particleReceiver1DCalculator.particleReceiver1D_v11.T_w[3], particleReceiver1DCalculator.particleReceiver1D_v11.dx}
eqns: {3808, 3809, 3810, 3811, 3812, 3813, 3814, 3815, 3816, 3817, 3818, 3819, 3820, 3821, 3822, 3823, 3824, 3825, 3826, 3827, 3828, 3829, 3830, 3831, 3832, 3833, 3834, 3835, 3836, 3837, 3838, 3839, 3840, 3841, 3842, 3843, 3844, 3845, 3846, 3847, 3848, 3849, 3850, 3851, 3852, 3853, 3854, 3855, 3856, 3857, 3858, 3859, 3860, 3861, 3862, 3863, 3864, 3865, 3866, 3867, 3868, 3869, 3870, 3871, 3872, 3873, 3874, 3875, 3876, 3877, 3878, 3879, 3880, 3881, 3882, 3883, 3884, 3885, 3886, 3887, 3888, 3889, 3890, 3891, 3892, 3893, 3894, 3895, 3896, 3897, 3898, 3899, 3900, 3901, 3902, 3903, 3904, 3905, 3906, 3907, 3908, 3909, 3910, 3911, 3912, 3913, 3914, 3915, 3916, 3917, 3918, 3919, 3920, 3921, 3922, 3923, 3924, 3925, 3926, 3927, 3928, 3929, 3930, 3931, 3932, 3933, 3934, 3935, 3936, 3937, 3938, 3939, 3940, 3941, 3942, 3943, 3944, 3945, 3946, 3947, 3948, 3949, 3950, 3951, 3952, 3953, 3954, 3955, 3956, 3957, 3958, 3959, 3960, 3961, 3962, 3963, 3964, 3965, 3966, 3967, 3968, 3969, 3970, 3971, 3972, 3973, 3974, 3975, 3976, 3977, 3978, 3979, 3980, 3981, 3982, 3983, 3984, 3985, 3986, 3987, 3988, 4048, 4047, 4046, 4045, 4044, 4043, 4042, 4041, 4040, 4039, 4038, 4037, 4036, 4035, 4034, 4033, 4032, 4031, 4030, 4029, 4028, 4027, 4026, 4025, 4024, 4023, 4022, 4021, 4020, 4019, 4018, 4017, 4016, 4015, 4014, 4013, 4012, 4011, 4010, 4009, 4008, 4007, 4006, 4005, 4004, 4003, 4002, 4001, 4000, 3999, 3998, 3997, 3996, 3995, 3994, 3993, 3992, 3991, 3990, 3989}
*/
void PhysicalParticleCO21D_v11_eqFunction_4049(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4049};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 4049 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[0] = data->localData[0]->realVars[361] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[1] = data->localData[0]->realVars[277] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[22] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[2] = data->localData[0]->realVars[258] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[1] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[3] = data->localData[0]->realVars[257] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[4] = data->localData[0]->realVars[360] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[5] = data->localData[0]->realVars[256] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[6] = data->localData[0]->realVars[359] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[7] = data->localData[0]->realVars[255] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[8] = data->localData[0]->realVars[358] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[9] = data->localData[0]->realVars[254] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[10] = data->localData[0]->realVars[357] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[11] = data->localData[0]->realVars[253] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[12] = data->localData[0]->realVars[356] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[13] = data->localData[0]->realVars[252] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[14] = data->localData[0]->realVars[355] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[15] = data->localData[0]->realVars[251] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[16] = data->localData[0]->realVars[354] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[17] = data->localData[0]->realVars[250] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[18] = data->localData[0]->realVars[353] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[19] = data->localData[0]->realVars[249] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[20] = data->localData[0]->realVars[352] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[21] = data->localData[0]->realVars[248] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[22] = data->localData[0]->realVars[351] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[23] = data->localData[0]->realVars[247] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[24] = data->localData[0]->realVars[350] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[25] = data->localData[0]->realVars[246] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[26] = data->localData[0]->realVars[349] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[27] = data->localData[0]->realVars[245] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[28] = data->localData[0]->realVars[348] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[29] = data->localData[0]->realVars[244] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[30] = data->localData[0]->realVars[347] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[31] = data->localData[0]->realVars[243] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[32] = data->localData[0]->realVars[346] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[33] = data->localData[0]->realVars[242] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[34] = data->localData[0]->realVars[345] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[35] = data->localData[0]->realVars[241] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[36] = data->localData[0]->realVars[344] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[37] = data->localData[0]->realVars[240] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[38] = data->localData[0]->realVars[343] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[39] = data->localData[0]->realVars[239] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[40] = data->localData[0]->realVars[342] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[41] = data->localData[0]->realVars[268] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[12] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[42] = data->localData[0]->realVars[276] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[20] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[43] = data->localData[0]->realVars[275] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[19] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[44] = data->localData[0]->realVars[274] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[18] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[45] = data->localData[0]->realVars[272] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[16] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[46] = data->localData[0]->realVars[273] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[17] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[47] = data->localData[0]->realVars[271] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[15] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[48] = data->localData[0]->realVars[270] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[14] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[49] = data->localData[0]->realVars[269] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[13] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[50] = data->localData[0]->realVars[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[11] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[51] = data->localData[0]->realVars[266] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[10] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[52] = data->localData[0]->realVars[265] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[9] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[53] = data->localData[0]->realVars[264] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[8] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[54] = data->localData[0]->realVars[263] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[7] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[55] = data->localData[0]->realVars[262] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[6] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[56] = data->localData[0]->realVars[260] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[4] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[57] = data->localData[0]->realVars[261] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[5] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[58] = data->localData[0]->realVars[259] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[3] variable */;
  data->simulationInfo->nonlinearSystemData[44].nlsxOld[59] = data->localData[0]->realVars[299] /* particleReceiver1DCalculator.particleReceiver1D_v11.dx variable */;
  retValue = solve_nonlinear_system(data, threadData, 44);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,4049};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 4049 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[361] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[0];
  data->localData[0]->realVars[277] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[22] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[1];
  data->localData[0]->realVars[258] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[1] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[2];
  data->localData[0]->realVars[257] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[3];
  data->localData[0]->realVars[360] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[4];
  data->localData[0]->realVars[256] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[5];
  data->localData[0]->realVars[359] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[6];
  data->localData[0]->realVars[255] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[7];
  data->localData[0]->realVars[358] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[8];
  data->localData[0]->realVars[254] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[9];
  data->localData[0]->realVars[357] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[10];
  data->localData[0]->realVars[253] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[11];
  data->localData[0]->realVars[356] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[12];
  data->localData[0]->realVars[252] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[13];
  data->localData[0]->realVars[355] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[14];
  data->localData[0]->realVars[251] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[15];
  data->localData[0]->realVars[354] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[16];
  data->localData[0]->realVars[250] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[17];
  data->localData[0]->realVars[353] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[18];
  data->localData[0]->realVars[249] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[19];
  data->localData[0]->realVars[352] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[20];
  data->localData[0]->realVars[248] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[21];
  data->localData[0]->realVars[351] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[22];
  data->localData[0]->realVars[247] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[23];
  data->localData[0]->realVars[350] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[24];
  data->localData[0]->realVars[246] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[25];
  data->localData[0]->realVars[349] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[26];
  data->localData[0]->realVars[245] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[27];
  data->localData[0]->realVars[348] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[28];
  data->localData[0]->realVars[244] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[29];
  data->localData[0]->realVars[347] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[30];
  data->localData[0]->realVars[243] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[31];
  data->localData[0]->realVars[346] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[32];
  data->localData[0]->realVars[242] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[33];
  data->localData[0]->realVars[345] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[34];
  data->localData[0]->realVars[241] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[35];
  data->localData[0]->realVars[344] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[36];
  data->localData[0]->realVars[240] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[37];
  data->localData[0]->realVars[343] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[38];
  data->localData[0]->realVars[239] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[39];
  data->localData[0]->realVars[342] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[40];
  data->localData[0]->realVars[268] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[12] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[41];
  data->localData[0]->realVars[276] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[20] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[42];
  data->localData[0]->realVars[275] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[19] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[43];
  data->localData[0]->realVars[274] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[18] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[44];
  data->localData[0]->realVars[272] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[16] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[45];
  data->localData[0]->realVars[273] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[17] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[46];
  data->localData[0]->realVars[271] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[15] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[47];
  data->localData[0]->realVars[270] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[14] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[48];
  data->localData[0]->realVars[269] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[13] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[49];
  data->localData[0]->realVars[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[11] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[50];
  data->localData[0]->realVars[266] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[10] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[51];
  data->localData[0]->realVars[265] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[9] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[52];
  data->localData[0]->realVars[264] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[8] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[53];
  data->localData[0]->realVars[263] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[7] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[54];
  data->localData[0]->realVars[262] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[6] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[55];
  data->localData[0]->realVars[260] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[4] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[56];
  data->localData[0]->realVars[261] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[5] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[57];
  data->localData[0]->realVars[259] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_w[3] variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[58];
  data->localData[0]->realVars[299] /* particleReceiver1DCalculator.particleReceiver1D_v11.dx variable */ = data->simulationInfo->nonlinearSystemData[44].nlsx[59];
  TRACE_POP
}
/*
equation index: 4050
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.A_ap = particleReceiver1DCalculator.particleReceiver1D_v11.H_drop * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv
*/
void PhysicalParticleCO21D_v11_eqFunction_4050(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4050};
  data->localData[0]->realVars[147] /* particleReceiver1DCalculator.particleReceiver1D_v11.A_ap variable */ = (data->localData[0]->realVars[188] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */) * (data->localData[0]->realVars[278] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */);
  TRACE_POP
}
/*
equation index: 4051
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc = particleReceiver1DCalculator.particleReceiver1D_v11.q_solar * particleReceiver1DCalculator.particleReceiver1D_v11.A_ap
*/
void PhysicalParticleCO21D_v11_eqFunction_4051(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4051};
  data->localData[0]->realVars[230] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc variable */ = (data->localData[0]->realVars[506] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_solar variable */) * (data->localData[0]->realVars[147] /* particleReceiver1DCalculator.particleReceiver1D_v11.A_ap variable */);
  TRACE_POP
}
/*
equation index: 4052
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.eta_rec = max(particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec / particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc, 0.0)
*/
void PhysicalParticleCO21D_v11_eqFunction_4052(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4052};
  data->localData[0]->realVars[320] /* particleReceiver1DCalculator.particleReceiver1D_v11.eta_rec variable */ = fmax(DIVISION_SIM(data->localData[0]->realVars[231] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_rec variable */,data->localData[0]->realVars[230] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc variable */,"particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc",equationIndexes),0.0);
  TRACE_POP
}
/*
equation index: 4053
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.t_c[22] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4053(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4053};
  modelica_boolean tmp0;
  tmp0 = Greater(data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[548] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c[22] variable */ = (tmp0?data->localData[0]->realVars[549] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[188] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */):0.0);
  TRACE_POP
}
/*
equation index: 4054
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1DCalculator.particleReceiver1D_v11.x[21] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4054(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4054};
  modelica_boolean tmp1;
  tmp1 = Greater(data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[547] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] variable */ = (tmp1?data->localData[0]->realVars[549] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[610] /* particleReceiver1DCalculator.particleReceiver1D_v11.x[21] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4055
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then (particleReceiver1DCalculator.particleReceiver1D_v11.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1DCalculator.particleReceiver1D_v11.x[21] - particleReceiver1DCalculator.particleReceiver1D_v11.x[20])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4055(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4055};
  modelica_boolean tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_boolean tmp5;
  modelica_real tmp6;
  tmp2 = Greater(data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  tmp5 = (modelica_boolean)tmp2;
  if(tmp5)
  {
    tmp3 = data->localData[0]->realVars[588] /* particleReceiver1DCalculator.particleReceiver1D_v11.vp[20] variable */;
    tmp4 = (tmp3 * tmp3) + (19.6133) * (data->localData[0]->realVars[610] /* particleReceiver1DCalculator.particleReceiver1D_v11.x[21] variable */ - data->localData[0]->realVars[609] /* particleReceiver1DCalculator.particleReceiver1D_v11.x[20] variable */);
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
  data->localData[0]->realVars[589] /* particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] variable */ = tmp6;
  TRACE_POP
}
/*
equation index: 4056
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.phi[21] = if particleReceiver1DCalculator.liftSimple.m_flow_fixed > 1e-06 then particleReceiver1DCalculator.liftSimple.m_flow_fixed / (particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] * particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] * particleReceiver1DCalculator.particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4056(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4056};
  modelica_boolean tmp7;
  tmp7 = Greater(data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,1e-06);
  data->localData[0]->realVars[425] /* particleReceiver1DCalculator.particleReceiver1D_v11.phi[21] variable */ = (tmp7?DIVISION_SIM(data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */,(((data->localData[0]->realVars[278] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[547] /* particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] variable */)) * (data->localData[0]->realVars[589] /* particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] variable */)) * (data->simulationInfo->realParameter[273] /* particleReceiver1DCalculator.particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.t_c[21] * particleReceiver1DCalculator.particleReceiver1D_v11.vp[21] * particleReceiver1DCalculator.particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4057
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4057(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4057};
  data->localData[0]->realVars[462] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[255] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[18] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4058
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4058(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4058};
  data->localData[0]->realVars[463] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[256] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[19] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4059
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4059(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4059};
  data->localData[0]->realVars[464] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[257] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[20] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4060
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4060(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4060};
  data->localData[0]->realVars[459] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[252] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[15] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4061
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4061(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4061};
  data->localData[0]->realVars[457] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[250] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[13] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4062
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4062(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4062};
  data->localData[0]->realVars[458] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[251] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[14] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4063
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4063(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4063};
  data->localData[0]->realVars[460] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[253] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[16] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4064
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4064(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4064};
  data->localData[0]->realVars[461] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[254] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[17] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4065
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4065(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4065};
  data->localData[0]->realVars[456] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[249] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[12] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4066
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4066(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4066};
  data->localData[0]->realVars[451] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[244] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[7] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4067
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4067(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4067};
  data->localData[0]->realVars[452] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[245] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[8] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4068
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4068(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4068};
  data->localData[0]->realVars[453] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[246] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[9] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4069
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4069(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4069};
  data->localData[0]->realVars[454] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[247] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[10] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4070
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4070(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4070};
  data->localData[0]->realVars[455] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[248] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[11] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4071
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4071(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4071};
  data->localData[0]->realVars[450] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[243] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[6] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4072
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4072(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4072};
  data->localData[0]->realVars[449] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[242] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[5] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4073
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4073(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4073};
  data->localData[0]->realVars[448] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[241] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[4] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4074
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4074(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4074};
  data->localData[0]->realVars[446] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[239] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[2] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4075
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] = particleReceiver1DCalculator.particleReceiver1D_v11.h_conv * (particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] - particleReceiver1DCalculator.T_amb_design)
*/
void PhysicalParticleCO21D_v11_eqFunction_4075(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4075};
  data->localData[0]->realVars[447] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] variable */ = (data->simulationInfo->realParameter[267] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[240] /* particleReceiver1DCalculator.particleReceiver1D_v11.T_s[3] variable */ - data->simulationInfo->realParameter[214] /* particleReceiver1DCalculator.T_amb_design PARAM */);
  TRACE_POP
}
/*
equation index: 4076
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain = (particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_v11_eqFunction_4076(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4076};
  data->localData[0]->realVars[233] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain variable */ = (data->localData[0]->realVars[446] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[1] variable */ + data->localData[0]->realVars[447] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[2] variable */ + data->localData[0]->realVars[448] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[3] variable */ + data->localData[0]->realVars[449] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[4] variable */ + data->localData[0]->realVars[450] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[5] variable */ + data->localData[0]->realVars[451] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[6] variable */ + data->localData[0]->realVars[452] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[7] variable */ + data->localData[0]->realVars[453] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[8] variable */ + data->localData[0]->realVars[454] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[9] variable */ + data->localData[0]->realVars[455] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[10] variable */ + data->localData[0]->realVars[456] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[11] variable */ + data->localData[0]->realVars[457] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[12] variable */ + data->localData[0]->realVars[458] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[13] variable */ + data->localData[0]->realVars[459] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[14] variable */ + data->localData[0]->realVars[460] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[15] variable */ + data->localData[0]->realVars[461] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[16] variable */ + data->localData[0]->realVars[462] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[17] variable */ + data->localData[0]->realVars[463] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[18] variable */ + data->localData[0]->realVars[464] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[19] variable */ + data->localData[0]->realVars[465] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_curtain[20] variable */) * ((data->localData[0]->realVars[278] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[188] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4077
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_wall = (particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[1] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[2] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[3] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[4] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[5] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[6] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[7] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[8] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[9] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[10] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[11] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[12] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[13] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[14] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[15] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[16] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[17] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[18] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[19] + particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_v11_eqFunction_4077(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4077};
  data->localData[0]->realVars[234] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_wall variable */ = (data->localData[0]->realVars[466] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[1] variable */ + data->localData[0]->realVars[467] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[2] variable */ + data->localData[0]->realVars[468] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[3] variable */ + data->localData[0]->realVars[469] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[4] variable */ + data->localData[0]->realVars[470] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[5] variable */ + data->localData[0]->realVars[471] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[6] variable */ + data->localData[0]->realVars[472] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[7] variable */ + data->localData[0]->realVars[473] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[8] variable */ + data->localData[0]->realVars[474] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[9] variable */ + data->localData[0]->realVars[475] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[10] variable */ + data->localData[0]->realVars[476] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[11] variable */ + data->localData[0]->realVars[477] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[12] variable */ + data->localData[0]->realVars[478] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[13] variable */ + data->localData[0]->realVars[479] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[14] variable */ + data->localData[0]->realVars[480] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[15] variable */ + data->localData[0]->realVars[481] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[16] variable */ + data->localData[0]->realVars[482] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[17] variable */ + data->localData[0]->realVars[483] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[18] variable */ + data->localData[0]->realVars[484] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[19] variable */ + data->localData[0]->realVars[485] /* particleReceiver1DCalculator.particleReceiver1D_v11.q_conv_wall[20] variable */) * ((data->localData[0]->realVars[278] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[188] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4078
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb = (particleReceiver1DCalculator.particleReceiver1D_v11.g_w[1] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[2] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[3] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[4] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[5] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[6] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[7] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[8] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[9] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[10] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[11] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[12] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[13] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[14] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[15] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[16] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[17] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[18] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[19] + particleReceiver1DCalculator.particleReceiver1D_v11.g_w[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_v11_eqFunction_4078(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4078};
  data->localData[0]->realVars[235] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb variable */ = (data->localData[0]->realVars[322] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[1] variable */ + data->localData[0]->realVars[323] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[2] variable */ + data->localData[0]->realVars[324] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[3] variable */ + data->localData[0]->realVars[325] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[4] variable */ + data->localData[0]->realVars[326] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[5] variable */ + data->localData[0]->realVars[327] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[6] variable */ + data->localData[0]->realVars[328] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[7] variable */ + data->localData[0]->realVars[329] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[8] variable */ + data->localData[0]->realVars[330] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[9] variable */ + data->localData[0]->realVars[331] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[10] variable */ + data->localData[0]->realVars[332] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[11] variable */ + data->localData[0]->realVars[333] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[12] variable */ + data->localData[0]->realVars[334] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[13] variable */ + data->localData[0]->realVars[335] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[14] variable */ + data->localData[0]->realVars[336] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[15] variable */ + data->localData[0]->realVars[337] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[16] variable */ + data->localData[0]->realVars[338] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[17] variable */ + data->localData[0]->realVars[339] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[18] variable */ + data->localData[0]->realVars[340] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[19] variable */ + data->localData[0]->realVars[341] /* particleReceiver1DCalculator.particleReceiver1D_v11.g_w[20] variable */) * ((data->localData[0]->realVars[278] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[188] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4079
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qgain_gcb = (particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] + particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_v11_eqFunction_4079(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4079};
  data->localData[0]->realVars[232] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qgain_gcb variable */ = (data->localData[0]->realVars[342] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[1] variable */ + data->localData[0]->realVars[343] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[2] variable */ + data->localData[0]->realVars[344] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[3] variable */ + data->localData[0]->realVars[345] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[4] variable */ + data->localData[0]->realVars[346] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[5] variable */ + data->localData[0]->realVars[347] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[6] variable */ + data->localData[0]->realVars[348] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[7] variable */ + data->localData[0]->realVars[349] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[8] variable */ + data->localData[0]->realVars[350] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[9] variable */ + data->localData[0]->realVars[351] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[10] variable */ + data->localData[0]->realVars[352] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[11] variable */ + data->localData[0]->realVars[353] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[12] variable */ + data->localData[0]->realVars[354] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[13] variable */ + data->localData[0]->realVars[355] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[14] variable */ + data->localData[0]->realVars[356] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[15] variable */ + data->localData[0]->realVars[357] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[16] variable */ + data->localData[0]->realVars[358] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[17] variable */ + data->localData[0]->realVars[359] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[18] variable */ + data->localData[0]->realVars[360] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[19] variable */ + data->localData[0]->realVars[361] /* particleReceiver1DCalculator.particleReceiver1D_v11.gc_b[20] variable */) * ((data->localData[0]->realVars[278] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[188] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4080
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf = (particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[1] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[2] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[3] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[4] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[5] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[6] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[7] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[8] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[9] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[10] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[11] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[12] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[13] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[14] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[15] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[16] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[17] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[18] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[19] + particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[20]) * particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv * particleReceiver1DCalculator.particleReceiver1D_v11.H_drop
*/
void PhysicalParticleCO21D_v11_eqFunction_4080(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4080};
  data->localData[0]->realVars[236] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf variable */ = (data->localData[0]->realVars[384] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[1] variable */ + data->localData[0]->realVars[385] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[2] variable */ + data->localData[0]->realVars[386] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[3] variable */ + data->localData[0]->realVars[387] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[4] variable */ + data->localData[0]->realVars[388] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[5] variable */ + data->localData[0]->realVars[389] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[6] variable */ + data->localData[0]->realVars[390] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[7] variable */ + data->localData[0]->realVars[391] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[8] variable */ + data->localData[0]->realVars[392] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[9] variable */ + data->localData[0]->realVars[393] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[10] variable */ + data->localData[0]->realVars[394] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[11] variable */ + data->localData[0]->realVars[395] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[12] variable */ + data->localData[0]->realVars[396] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[13] variable */ + data->localData[0]->realVars[397] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[14] variable */ + data->localData[0]->realVars[398] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[15] variable */ + data->localData[0]->realVars[399] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[16] variable */ + data->localData[0]->realVars[400] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[17] variable */ + data->localData[0]->realVars[401] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[18] variable */ + data->localData[0]->realVars[402] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[19] variable */ + data->localData[0]->realVars[403] /* particleReceiver1DCalculator.particleReceiver1D_v11.jc_f[20] variable */) * ((data->localData[0]->realVars[278] /* particleReceiver1DCalculator.particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[188] /* particleReceiver1DCalculator.particleReceiver1D_v11.H_drop variable */));
  TRACE_POP
}
/*
equation index: 4081
type: SIMPLE_ASSIGN
particleReceiver1DCalculator.particleReceiver1D_v11.Q_check_curtain = particleReceiver1DCalculator.liftSimple.m_flow_fixed * (particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] - particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21]) + particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc + particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain + (-particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf) - particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb
*/
void PhysicalParticleCO21D_v11_eqFunction_4081(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4081};
  data->localData[0]->realVars[229] /* particleReceiver1DCalculator.particleReceiver1D_v11.Q_check_curtain variable */ = (data->simulationInfo->realParameter[227] /* particleReceiver1DCalculator.liftSimple.m_flow_fixed PARAM */) * (data->localData[0]->realVars[362] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[1] variable */ - data->localData[0]->realVars[382] /* particleReceiver1DCalculator.particleReceiver1D_v11.h_s[21] variable */) + data->localData[0]->realVars[230] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qdot_inc variable */ + data->localData[0]->realVars[233] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_conv_curtain variable */ + (-data->localData[0]->realVars[236] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcf variable */) - data->localData[0]->realVars[235] /* particleReceiver1DCalculator.particleReceiver1D_v11.Qloss_jcb variable */;
  TRACE_POP
}
/*
equation index: 4082
type: SIMPLE_ASSIGN
data.table.timeScaled = time
*/
void PhysicalParticleCO21D_v11_eqFunction_4082(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4082};
  data->localData[0]->realVars[68] /* data.table.timeScaled variable */ = data->localData[0]->timeValue;
  TRACE_POP
}
/*
equation index: 4083
type: SIMPLE_ASSIGN
tankHot.V = 0.0005 * tankHot.m
*/
void PhysicalParticleCO21D_v11_eqFunction_4083(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4083};
  data->localData[0]->realVars[1351] /* tankHot.V variable */ = (0.0005) * (data->localData[0]->realVars[15] /* tankHot.m STATE(1) */);
  TRACE_POP
}
/*
equation index: 4084
type: SIMPLE_ASSIGN
controlHot.logic.level = 100.0 * tankHot.V / tankHot.V_t
*/
void PhysicalParticleCO21D_v11_eqFunction_4084(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4084};
  data->localData[0]->realVars[59] /* controlHot.logic.level variable */ = (100.0) * (DIVISION_SIM(data->localData[0]->realVars[1351] /* tankHot.V variable */,data->simulationInfo->realParameter[814] /* tankHot.V_t PARAM */,"tankHot.V_t",equationIndexes));
  TRACE_POP
}
/*
equation index: 4085
type: SIMPLE_ASSIGN
tankHot.A = 0.03141592653589793 * tankHot.D * tankHot.H * controlHot.logic.level
*/
void PhysicalParticleCO21D_v11_eqFunction_4085(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4085};
  data->localData[0]->realVars[1348] /* tankHot.A variable */ = (0.03141592653589793) * ((data->simulationInfo->realParameter[809] /* tankHot.D PARAM */) * ((data->simulationInfo->realParameter[810] /* tankHot.H PARAM */) * (data->localData[0]->realVars[59] /* controlHot.logic.level variable */)));
  TRACE_POP
}
/*
equation index: 4086
type: SIMPLE_ASSIGN
$whenCondition12 = controlHot.logic.level > controlHot.defocus_logic.level_max
*/
void PhysicalParticleCO21D_v11_eqFunction_4086(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4086};
  modelica_boolean tmp8;
  RELATIONHYSTERESIS(tmp8, data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */, 7, Greater);
  data->localData[0]->booleanVars[3] /* $whenCondition12 DISCRETE */ = tmp8;
  TRACE_POP
}
/*
equation index: 4087
type: SIMPLE_ASSIGN
$whenCondition11 = controlHot.logic.level < controlHot.defocus_logic.level_min
*/
void PhysicalParticleCO21D_v11_eqFunction_4087(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4087};
  modelica_boolean tmp9;
  RELATIONHYSTERESIS(tmp9, data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */, 8, Less);
  data->localData[0]->booleanVars[2] /* $whenCondition11 DISCRETE */ = tmp9;
  TRACE_POP
}
/*
equation index: 4088
type: WHEN

when {$whenCondition12} then
  controlHot.defocus_logic.y = true;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4088(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4088};
  if((data->localData[0]->booleanVars[3] /* $whenCondition12 DISCRETE */ && !data->simulationInfo->booleanVarsPre[3] /* $whenCondition12 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[16] /* controlHot.defocus_logic.y DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[2] /* $whenCondition11 DISCRETE */ && !data->simulationInfo->booleanVarsPre[2] /* $whenCondition11 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[16] /* controlHot.defocus_logic.y DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4090
type: SIMPLE_ASSIGN
$whenCondition10 = controlHot.logic.level > controlHot.logic.level_on
*/
void PhysicalParticleCO21D_v11_eqFunction_4090(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4090};
  modelica_boolean tmp10;
  RELATIONHYSTERESIS(tmp10, data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */, 9, Greater);
  data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ = tmp10;
  TRACE_POP
}
/*
equation index: 4091
type: SIMPLE_ASSIGN
$whenCondition9 = controlHot.logic.level < controlHot.logic.level_off
*/
void PhysicalParticleCO21D_v11_eqFunction_4091(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4091};
  modelica_boolean tmp11;
  RELATIONHYSTERESIS(tmp11, data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */, 10, Less);
  data->localData[0]->booleanVars[15] /* $whenCondition9 DISCRETE */ = tmp11;
  TRACE_POP
}
/*
equation index: 4092
type: WHEN

when {$whenCondition10} then
  controlHot.logic.on_discharge = true;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4092(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4092};
  if((data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ && !data->simulationInfo->booleanVarsPre[1] /* $whenCondition10 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[15] /* $whenCondition9 DISCRETE */ && !data->simulationInfo->booleanVarsPre[15] /* $whenCondition9 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4094
type: SIMPLE_ASSIGN
controlHot.defocus_logic.level_ref = controlHot.logic.level
*/
void PhysicalParticleCO21D_v11_eqFunction_4094(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4094};
  data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */ = data->localData[0]->realVars[59] /* controlHot.logic.level variable */;
  TRACE_POP
}
/*
equation index: 4095
type: SIMPLE_ASSIGN
tankCold.V = 0.0005 * tankCold.m
*/
void PhysicalParticleCO21D_v11_eqFunction_4095(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4095};
  data->localData[0]->realVars[1332] /* tankCold.V variable */ = (0.0005) * (data->localData[0]->realVars[13] /* tankCold.m STATE(1) */);
  TRACE_POP
}
/*
equation index: 4096
type: SIMPLE_ASSIGN
simpleReceiverControl.hotTank.level_ref = 100.0 * tankCold.V / tankCold.V_t
*/
void PhysicalParticleCO21D_v11_eqFunction_4096(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4096};
  data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */ = (100.0) * (DIVISION_SIM(data->localData[0]->realVars[1332] /* tankCold.V variable */,data->simulationInfo->realParameter[804] /* tankCold.V_t PARAM */,"tankCold.V_t",equationIndexes));
  TRACE_POP
}
/*
equation index: 4097
type: SIMPLE_ASSIGN
tankCold.A = 0.03141592653589793 * tankCold.D * tankCold.H * simpleReceiverControl.hotTank.level_ref
*/
void PhysicalParticleCO21D_v11_eqFunction_4097(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4097};
  data->localData[0]->realVars[1330] /* tankCold.A variable */ = (0.03141592653589793) * ((data->simulationInfo->realParameter[799] /* tankCold.D PARAM */) * ((data->simulationInfo->realParameter[800] /* tankCold.H PARAM */) * (data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */)));
  TRACE_POP
}
/*
equation index: 4098
type: SIMPLE_ASSIGN
$whenCondition2 = simpleReceiverControl.hotTank.level_ref > simpleReceiverControl.defocusLogic.level_max
*/
void PhysicalParticleCO21D_v11_eqFunction_4098(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4098};
  modelica_boolean tmp12;
  RELATIONHYSTERESIS(tmp12, data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_max PARAM */, 3, Greater);
  data->localData[0]->booleanVars[8] /* $whenCondition2 DISCRETE */ = tmp12;
  TRACE_POP
}
/*
equation index: 4099
type: SIMPLE_ASSIGN
$whenCondition1 = simpleReceiverControl.hotTank.level_ref < simpleReceiverControl.defocusLogic.level_min
*/
void PhysicalParticleCO21D_v11_eqFunction_4099(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4099};
  modelica_boolean tmp13;
  RELATIONHYSTERESIS(tmp13, data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[773] /* simpleReceiverControl.defocusLogic.level_min PARAM */, 4, Less);
  data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ = tmp13;
  TRACE_POP
}
/*
equation index: 4100
type: WHEN

when {$whenCondition2} then
  simpleReceiverControl.defocusLogic.y = true;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4100(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4100};
  if((data->localData[0]->booleanVars[8] /* $whenCondition2 DISCRETE */ && !data->simulationInfo->booleanVarsPre[8] /* $whenCondition2 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[27] /* simpleReceiverControl.defocusLogic.y DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ && !data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[27] /* simpleReceiverControl.defocusLogic.y DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4102
type: SIMPLE_ASSIGN
heliostatsField.defocus = controlHot.defocus_logic.y or not simpleReceiverControl.defocusLogic.y
*/
void PhysicalParticleCO21D_v11_eqFunction_4102(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4102};
  data->localData[0]->booleanVars[21] /* heliostatsField.defocus DISCRETE */ = (data->localData[0]->booleanVars[16] /* controlHot.defocus_logic.y DISCRETE */ || (!data->localData[0]->booleanVars[27] /* simpleReceiverControl.defocusLogic.y DISCRETE */));
  TRACE_POP
}
/*
equation index: 4103
type: SIMPLE_ASSIGN
$whenCondition4 = simpleReceiverControl.hotTank.level_ref > simpleReceiverControl.hotTank.level_max
*/
void PhysicalParticleCO21D_v11_eqFunction_4103(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4103};
  modelica_boolean tmp14;
  RELATIONHYSTERESIS(tmp14, data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_max PARAM */, 5, Greater);
  data->localData[0]->booleanVars[10] /* $whenCondition4 DISCRETE */ = tmp14;
  TRACE_POP
}
/*
equation index: 4104
type: SIMPLE_ASSIGN
$whenCondition3 = simpleReceiverControl.hotTank.level_ref < simpleReceiverControl.hotTank.level_min
*/
void PhysicalParticleCO21D_v11_eqFunction_4104(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4104};
  modelica_boolean tmp15;
  RELATIONHYSTERESIS(tmp15, data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[776] /* simpleReceiverControl.hotTank.level_min PARAM */, 6, Less);
  data->localData[0]->booleanVars[9] /* $whenCondition3 DISCRETE */ = tmp15;
  TRACE_POP
}
/*
equation index: 4105
type: WHEN

when {$whenCondition4} then
  simpleReceiverControl.hotTank.y = true;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4105(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4105};
  if((data->localData[0]->booleanVars[10] /* $whenCondition4 DISCRETE */ && !data->simulationInfo->booleanVarsPre[10] /* $whenCondition4 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[28] /* simpleReceiverControl.hotTank.y DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[9] /* $whenCondition3 DISCRETE */ && !data->simulationInfo->booleanVarsPre[9] /* $whenCondition3 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[28] /* simpleReceiverControl.hotTank.y DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4107
type: SIMPLE_ASSIGN
simpleReceiverControl.defocusLogic.level_ref = simpleReceiverControl.hotTank.level_ref
*/
void PhysicalParticleCO21D_v11_eqFunction_4107(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4107};
  data->localData[0]->realVars[1321] /* simpleReceiverControl.defocusLogic.level_ref variable */ = data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */;
  TRACE_POP
}
/*
equation index: 4108
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
void PhysicalParticleCO21D_v11_eqFunction_4108(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4108};
  modelica_boolean tmp16;
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

  RELATIONHYSTERESIS(tmp16, data->localData[0]->timeValue, 31449600.0, 2, Greater);
  if(tmp16)
  {
    data->localData[0]->realVars[75] /* eta_curtail_off variable */ = DIVISION_SIM(data->localData[0]->realVars[1] /* E_helio_incident STATE(1) */,data->localData[0]->realVars[9] /* E_resource STATE(1) */,"E_resource",equationIndexes);

    data->localData[0]->realVars[77] /* eta_optical variable */ = DIVISION_SIM(data->localData[0]->realVars[3] /* E_helio_raw STATE(1,heliostatsField.Q_raw) */,(data->simulationInfo->realParameter[142] /* he_av_design PARAM */) * (data->localData[0]->realVars[1] /* E_helio_incident STATE(1) */),"he_av_design * E_helio_incident",equationIndexes);

    data->localData[0]->realVars[76] /* eta_he_av variable */ = data->simulationInfo->realParameter[142] /* he_av_design PARAM */;

    data->localData[0]->realVars[74] /* eta_curtail_defocus variable */ = DIVISION_SIM(data->localData[0]->realVars[2] /* E_helio_net STATE(1,heliostatsField.Q_incident) */,data->localData[0]->realVars[3] /* E_helio_raw STATE(1,heliostatsField.Q_raw) */,"E_helio_raw",equationIndexes);

    data->localData[0]->realVars[80] /* eta_recv_abs variable */ = DIVISION_SIM(data->localData[0]->realVars[7] /* E_recv_incident STATE(1,heliostatsField.Q_incident) */,data->localData[0]->realVars[2] /* E_helio_net STATE(1,heliostatsField.Q_incident) */,"E_helio_net",equationIndexes);

    data->localData[0]->realVars[81] /* eta_recv_thermal variable */ = DIVISION_SIM(data->localData[0]->realVars[8] /* E_recv_net STATE(1,particleReceiver1D_v11.Qdot_rec) */,data->localData[0]->realVars[7] /* E_recv_incident STATE(1,heliostatsField.Q_incident) */,"E_recv_incident",equationIndexes);

    data->localData[0]->realVars[83] /* eta_storage variable */ = DIVISION_SIM(data->localData[0]->realVars[5] /* E_pb_input STATE(1) */,data->localData[0]->realVars[8] /* E_recv_net STATE(1,particleReceiver1D_v11.Qdot_rec) */,"E_recv_net",equationIndexes);

    data->localData[0]->realVars[78] /* eta_pb_gross variable */ = DIVISION_SIM(data->localData[0]->realVars[4] /* E_pb_gross STATE(1) */,data->localData[0]->realVars[5] /* E_pb_input STATE(1) */,"E_pb_input",equationIndexes);

    data->localData[0]->realVars[79] /* eta_pb_net variable */ = DIVISION_SIM(data->localData[0]->realVars[6] /* E_pb_net STATE(1,P_elec) */,data->localData[0]->realVars[5] /* E_pb_input STATE(1) */,"E_pb_input",equationIndexes);

    data->localData[0]->realVars[82] /* eta_solartoelec variable */ = DIVISION_SIM(data->localData[0]->realVars[6] /* E_pb_net STATE(1,P_elec) */,data->localData[0]->realVars[9] /* E_resource STATE(1) */,"E_resource",equationIndexes);
  }
  TRACE_POP
}
/*
equation index: 4109
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[1] = particleReceiver1D_v11.phi_max
*/
void PhysicalParticleCO21D_v11_eqFunction_4109(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4109};
  data->localData[0]->realVars[976] /* particleReceiver1D_v11.phi[1] variable */ = data->simulationInfo->realParameter[340] /* particleReceiver1D_v11.phi_max PARAM */;
  TRACE_POP
}
/*
equation index: 4110
type: SIMPLE_ASSIGN
$whenCondition16 = time >= pre(data.table.nextTimeEvent)
*/
void PhysicalParticleCO21D_v11_eqFunction_4110(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4110};
  modelica_boolean tmp17;
  RELATIONHYSTERESIS(tmp17, data->localData[0]->timeValue, data->simulationInfo->realVarsPre[1370] /* data.table.nextTimeEvent DISCRETE */, 0, GreaterEq);
  data->localData[0]->booleanVars[7] /* $whenCondition16 DISCRETE */ = tmp17;
  TRACE_POP
}
/*
equation index: 4111
type: WHEN

when {$whenCondition16} then
  data.table.nextTimeEventScaled = Modelica.Blocks.Sources.CombiTimeTable$data$table.getNextTimeEvent(data.table.tableID, data.table.timeScaled, data.table.tableOnFileRead);
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4111(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4111};
  if((data->localData[0]->booleanVars[7] /* $whenCondition16 DISCRETE */ && !data->simulationInfo->booleanVarsPre[7] /* $whenCondition16 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getNextTimeEvent(threadData, data->simulationInfo->extObjs[0], data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  }
  TRACE_POP
}
/*
equation index: 4112
type: SIMPLE_ASSIGN
$cse10 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 10, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4112(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4112};
  data->localData[0]->realVars[41] /* $cse10 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 10), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4113
type: SIMPLE_ASSIGN
data.Albedo = data.table.p_offset[10] + $cse10
*/
void PhysicalParticleCO21D_v11_eqFunction_4113(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4113};
  data->localData[0]->realVars[62] /* data.Albedo variable */ = data->simulationInfo->realParameter[111] /* data.table.p_offset[10] PARAM */ + data->localData[0]->realVars[41] /* $cse10 variable */;
  TRACE_POP
}
/*
equation index: 4114
type: SIMPLE_ASSIGN
$cse9 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 9, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4114(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4114};
  data->localData[0]->realVars[52] /* $cse9 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 9), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4115
type: SIMPLE_ASSIGN
data.table.y[9] = data.table.p_offset[9] + $cse9
*/
void PhysicalParticleCO21D_v11_eqFunction_4115(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4115};
  data->localData[0]->realVars[73] /* data.table.y[9] variable */ = data->simulationInfo->realParameter[110] /* data.table.p_offset[9] PARAM */ + data->localData[0]->realVars[52] /* $cse9 variable */;
  TRACE_POP
}
/*
equation index: 4116
type: SIMPLE_ASSIGN
data.Wdir = 0.0174532925199433 * data.table.y[9]
*/
void PhysicalParticleCO21D_v11_eqFunction_4116(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4116};
  data->localData[0]->realVars[67] /* data.Wdir variable */ = (0.0174532925199433) * (data->localData[0]->realVars[73] /* data.table.y[9] variable */);
  TRACE_POP
}
/*
equation index: 4117
type: SIMPLE_ASSIGN
$cse8 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 8, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4117(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4117};
  data->localData[0]->realVars[51] /* $cse8 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 8), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4118
type: SIMPLE_ASSIGN
Wspd_input.y = data.table.p_offset[8] + $cse8
*/
void PhysicalParticleCO21D_v11_eqFunction_4118(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4118};
  data->localData[0]->realVars[57] /* Wspd_input.y variable */ = data->simulationInfo->realParameter[109] /* data.table.p_offset[8] PARAM */ + data->localData[0]->realVars[51] /* $cse8 variable */;
  TRACE_POP
}
/*
equation index: 4119
type: SIMPLE_ASSIGN
$cse7 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 7, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4119(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4119};
  data->localData[0]->realVars[50] /* $cse7 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 7), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4120
type: SIMPLE_ASSIGN
data.table.y[7] = data.table.p_offset[7] + $cse7
*/
void PhysicalParticleCO21D_v11_eqFunction_4120(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4120};
  data->localData[0]->realVars[72] /* data.table.y[7] variable */ = data->simulationInfo->realParameter[108] /* data.table.p_offset[7] PARAM */ + data->localData[0]->realVars[50] /* $cse7 variable */;
  TRACE_POP
}
/*
equation index: 4121
type: SIMPLE_ASSIGN
tankHot.p_top = 100.0 * data.table.y[7]
*/
void PhysicalParticleCO21D_v11_eqFunction_4121(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4121};
  data->localData[0]->realVars[1366] /* tankHot.p_top variable */ = (100.0) * (data->localData[0]->realVars[72] /* data.table.y[7] variable */);
  TRACE_POP
}
/*
equation index: 4122
type: SIMPLE_ASSIGN
tankHot.medium.p_bar = 1e-05 * tankHot.p_top
*/
void PhysicalParticleCO21D_v11_eqFunction_4122(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4122};
  data->localData[0]->realVars[1364] /* tankHot.medium.p_bar variable */ = (1e-05) * (data->localData[0]->realVars[1366] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4123
type: SIMPLE_ASSIGN
tankHot.medium.u = tankHot.medium.h + (-0.0005) * tankHot.p_top
*/
void PhysicalParticleCO21D_v11_eqFunction_4123(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4123};
  data->localData[0]->realVars[1365] /* tankHot.medium.u variable */ = data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */ + (-0.0005) * (data->localData[0]->realVars[1366] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4124
type: SIMPLE_ASSIGN
tankCold.medium.p_bar = 1e-05 * tankHot.p_top
*/
void PhysicalParticleCO21D_v11_eqFunction_4124(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4124};
  data->localData[0]->realVars[1345] /* tankCold.medium.p_bar variable */ = (1e-05) * (data->localData[0]->realVars[1366] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4125
type: SIMPLE_ASSIGN
tankCold.medium.u = tankCold.medium.h + (-0.0005) * tankHot.p_top
*/
void PhysicalParticleCO21D_v11_eqFunction_4125(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4125};
  data->localData[0]->realVars[1346] /* tankCold.medium.u variable */ = data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */ + (-0.0005) * (data->localData[0]->realVars[1366] /* tankHot.p_top variable */);
  TRACE_POP
}
/*
equation index: 4126
type: SIMPLE_ASSIGN
powerBlock.exchanger.state_HTF[2].p = LiftCold.dp_fixed + tankHot.p_top
*/
void PhysicalParticleCO21D_v11_eqFunction_4126(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4126};
  data->localData[0]->realVars[1288] /* powerBlock.exchanger.state_HTF[2].p variable */ = data->simulationInfo->realParameter[37] /* LiftCold.dp_fixed PARAM */ + data->localData[0]->realVars[1366] /* tankHot.p_top variable */;
  TRACE_POP
}
/*
equation index: 4127
type: SIMPLE_ASSIGN
$cse6 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 6, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4127(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4127};
  data->localData[0]->realVars[49] /* $cse6 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 6), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4128
type: SIMPLE_ASSIGN
data.RH = data.table.p_offset[6] + $cse6
*/
void PhysicalParticleCO21D_v11_eqFunction_4128(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4128};
  data->localData[0]->realVars[65] /* data.RH variable */ = data->simulationInfo->realParameter[107] /* data.table.p_offset[6] PARAM */ + data->localData[0]->realVars[49] /* $cse6 variable */;
  TRACE_POP
}
/*
equation index: 4129
type: SIMPLE_ASSIGN
$cse5 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 5, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4129(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4129};
  data->localData[0]->realVars[48] /* $cse5 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 5), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4130
type: SIMPLE_ASSIGN
data.table.y[5] = data.table.p_offset[5] + $cse5
*/
void PhysicalParticleCO21D_v11_eqFunction_4130(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4130};
  data->localData[0]->realVars[71] /* data.table.y[5] variable */ = data->simulationInfo->realParameter[106] /* data.table.p_offset[5] PARAM */ + data->localData[0]->realVars[48] /* $cse5 variable */;
  TRACE_POP
}
/*
equation index: 4131
type: SIMPLE_ASSIGN
data.Tdew = 273.15 + data.table.y[5]
*/
void PhysicalParticleCO21D_v11_eqFunction_4131(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4131};
  data->localData[0]->realVars[66] /* data.Tdew variable */ = 273.15 + data->localData[0]->realVars[71] /* data.table.y[5] variable */;
  TRACE_POP
}
/*
equation index: 4132
type: SIMPLE_ASSIGN
$cse4 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 4, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4132(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4132};
  data->localData[0]->realVars[47] /* $cse4 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 4), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4133
type: SIMPLE_ASSIGN
data.table.y[4] = data.table.p_offset[4] + $cse4
*/
void PhysicalParticleCO21D_v11_eqFunction_4133(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4133};
  data->localData[0]->realVars[70] /* data.table.y[4] variable */ = data->simulationInfo->realParameter[105] /* data.table.p_offset[4] PARAM */ + data->localData[0]->realVars[47] /* $cse4 variable */;
  TRACE_POP
}
/*
equation index: 4134
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Tamb = 273.15 + data.table.y[4]
*/
void PhysicalParticleCO21D_v11_eqFunction_4134(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4134};
  data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */ = 273.15 + data->localData[0]->realVars[70] /* data.table.y[4] variable */;
  TRACE_POP
}
/*
equation index: 4135
type: SIMPLE_ASSIGN
$cse13 = max(3.0 + particleReceiver1D_v11.Tamb, powerBlock.cooler.T_low)
*/
void PhysicalParticleCO21D_v11_eqFunction_4135(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4135};
  data->localData[0]->realVars[43] /* $cse13 variable */ = fmax(3.0 + data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */,data->simulationInfo->realParameter[557] /* powerBlock.cooler.T_low PARAM */);
  TRACE_POP
}
/*
equation index: 4136
type: SIMPLE_ASSIGN
$cse3 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 3, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4136(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4136};
  data->localData[0]->realVars[46] /* $cse3 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 3), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4137
type: SIMPLE_ASSIGN
data.DHI = data.table.p_offset[3] + $cse3
*/
void PhysicalParticleCO21D_v11_eqFunction_4137(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4137};
  data->localData[0]->realVars[63] /* data.DHI variable */ = data->simulationInfo->realParameter[104] /* data.table.p_offset[3] PARAM */ + data->localData[0]->realVars[46] /* $cse3 variable */;
  TRACE_POP
}
/*
equation index: 4138
type: SIMPLE_ASSIGN
$cse2 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 2, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4138(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4138};
  data->localData[0]->realVars[45] /* $cse2 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 2), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4139
type: SIMPLE_ASSIGN
data.table.y[2] = data.table.p_offset[2] + $cse2
*/
void PhysicalParticleCO21D_v11_eqFunction_4139(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4139};
  data->localData[0]->realVars[69] /* data.table.y[2] variable */ = data->simulationInfo->realParameter[103] /* data.table.p_offset[2] PARAM */ + data->localData[0]->realVars[45] /* $cse2 variable */;
  TRACE_POP
}
/*
equation index: 4140
type: SIMPLE_ASSIGN
sun.dni = max(data.table.y[2], 0.0)
*/
void PhysicalParticleCO21D_v11_eqFunction_4140(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4140};
  data->localData[0]->realVars[1328] /* sun.dni variable */ = fmax(data->localData[0]->realVars[69] /* data.table.y[2] variable */,0.0);
  TRACE_POP
}
/*
equation index: 4141
type: SIMPLE_ASSIGN
$cse14 = max(sun.dni * A_field, 0.0)
*/
void PhysicalParticleCO21D_v11_eqFunction_4141(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4141};
  data->localData[0]->realVars[44] /* $cse14 variable */ = fmax((data->localData[0]->realVars[1328] /* sun.dni variable */) * (data->simulationInfo->realParameter[0] /* A_field PARAM */),0.0);
  TRACE_POP
}
/*
equation index: 4142
type: SIMPLE_ASSIGN
$DER.E_resource = $cse14
*/
void PhysicalParticleCO21D_v11_eqFunction_4142(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4142};
  data->localData[0]->realVars[26] /* der(E_resource) STATE_DER */ = data->localData[0]->realVars[44] /* $cse14 variable */;
  TRACE_POP
}
/*
equation index: 4143
type: SIMPLE_ASSIGN
$cse1 = Modelica.Blocks.Sources.CombiTimeTable$data$table.getTableValue(data.table.tableID, 1, data.table.timeScaled, data.table.nextTimeEventScaled, pre(data.table.nextTimeEventScaled), data.table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4143(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4143};
  data->localData[0]->realVars[40] /* $cse1 variable */ = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, data->simulationInfo->extObjs[0], ((modelica_integer) 1), data->localData[0]->realVars[68] /* data.table.timeScaled variable */, data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realVarsPre[1371] /* data.table.nextTimeEventScaled DISCRETE */, data->simulationInfo->realParameter[117] /* data.table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4144
type: SIMPLE_ASSIGN
data.GHI = data.table.p_offset[1] + $cse1
*/
void PhysicalParticleCO21D_v11_eqFunction_4144(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4144};
  data->localData[0]->realVars[64] /* data.GHI variable */ = data->simulationInfo->realParameter[102] /* data.table.p_offset[1] PARAM */ + data->localData[0]->realVars[40] /* $cse1 variable */;
  TRACE_POP
}
/*
equation index: 4145
type: WHEN

when {$whenCondition16} then
  data.table.nextTimeEvent = if data.table.nextTimeEventScaled < 1.797693134862316e+308 then data.table.nextTimeEventScaled else 1.797693134862316e+308;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4145(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4145};
  modelica_boolean tmp18;
  if((data->localData[0]->booleanVars[7] /* $whenCondition16 DISCRETE */ && !data->simulationInfo->booleanVarsPre[7] /* $whenCondition16 DISCRETE */ /* edge */))
  {
    tmp18 = Less(data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */,1.797693134862316e+308);
    data->localData[0]->realVars[1370] /* data.table.nextTimeEvent DISCRETE */ = (tmp18?data->localData[0]->realVars[1371] /* data.table.nextTimeEventScaled DISCRETE */:1.797693134862316e+308);
  }
  TRACE_POP
}
/*
equation index: 4146
type: SIMPLE_ASSIGN
particleReceiver1D_v11.T_s[1] = SolarTherm.Media.SolidParticles.CarboHSP_utilities.T_h(tankCold.medium.h)
*/
void PhysicalParticleCO21D_v11_eqFunction_4146(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4146};
  data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */ = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData, data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */);
  TRACE_POP
}
/*
equation index: 4147
type: SIMPLE_ASSIGN
particleReceiver1D_v11.h_s[1] = Modelica.Blocks.Tables.CombiTable1Ds$particleReceiver1D_v11$Tab.getTableValue(particleReceiver1D_v11.Tab[1].tableID, 1, particleReceiver1D_v11.T_s[1], particleReceiver1D_v11.Tab[1].tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4147(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4147};
  data->localData[0]->realVars[894] /* particleReceiver1D_v11.h_s[1] variable */ = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D__v1124Tab_getTableValue(threadData, data->simulationInfo->extObjs[23], ((modelica_integer) 1), data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */, data->simulationInfo->realParameter[310] /* particleReceiver1D_v11.Tab[1].tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4148
type: SIMPLE_ASSIGN
tankCold.medium.T_degC = -273.15 + particleReceiver1D_v11.T_s[1]
*/
void PhysicalParticleCO21D_v11_eqFunction_4148(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4148};
  data->localData[0]->realVars[1338] /* tankCold.medium.T_degC variable */ = -273.15 + data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */;
  TRACE_POP
}
/*
equation index: 4149
type: SIMPLE_ASSIGN
tankCold.Q_losses = (-tankCold.A) * tankCold.alpha * (particleReceiver1D_v11.T_s[1] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4149(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4149};
  data->localData[0]->realVars[1331] /* tankCold.Q_losses variable */ = ((-data->localData[0]->realVars[1330] /* tankCold.A variable */)) * ((data->simulationInfo->realParameter[806] /* tankCold.alpha PARAM */) * (data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */));
  TRACE_POP
}
/*
equation index: 4150
type: SIMPLE_ASSIGN
tankCold.W_net = if particleReceiver1D_v11.T_s[1] < tankCold.T_set then min(-tankCold.Q_losses, tankCold.W_max) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4150(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4150};
  modelica_boolean tmp19;
  RELATIONHYSTERESIS(tmp19, data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */, data->simulationInfo->realParameter[802] /* tankCold.T_set PARAM */, 14, Less);
  data->localData[0]->realVars[1334] /* tankCold.W_net variable */ = (tmp19?fmin((-data->localData[0]->realVars[1331] /* tankCold.Q_losses variable */),data->simulationInfo->realParameter[805] /* tankCold.W_max PARAM */):0.0);
  TRACE_POP
}
/*
equation index: 4151
type: SIMPLE_ASSIGN
tankCold.W_loss = tankCold.W_net / tankCold.e_ht
*/
void PhysicalParticleCO21D_v11_eqFunction_4151(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4151};
  data->localData[0]->realVars[1333] /* tankCold.W_loss variable */ = DIVISION_SIM(data->localData[0]->realVars[1334] /* tankCold.W_net variable */,data->simulationInfo->realParameter[807] /* tankCold.e_ht PARAM */,"tankCold.e_ht",equationIndexes);
  TRACE_POP
}
/*
equation index: 4152
type: SIMPLE_ASSIGN
simpleReceiverControl.T_mea = particleReceiver1D_v11.T_s[1]
*/
void PhysicalParticleCO21D_v11_eqFunction_4152(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4152};
  data->localData[0]->realVars[1319] /* simpleReceiverControl.T_mea variable */ = data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */;
  TRACE_POP
}
/*
equation index: 4153
type: SIMPLE_ASSIGN
tankHot.T_mea = SolarTherm.Media.SolidParticles.CarboHSP_utilities.T_h(tankHot.medium.h)
*/
void PhysicalParticleCO21D_v11_eqFunction_4153(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4153};
  data->localData[0]->realVars[1350] /* tankHot.T_mea variable */ = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData, data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */);
  TRACE_POP
}
/*
equation index: 4154
type: SIMPLE_ASSIGN
tankHot.medium.T_degC = -273.15 + tankHot.T_mea
*/
void PhysicalParticleCO21D_v11_eqFunction_4154(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4154};
  data->localData[0]->realVars[1357] /* tankHot.medium.T_degC variable */ = -273.15 + data->localData[0]->realVars[1350] /* tankHot.T_mea variable */;
  TRACE_POP
}
/*
equation index: 4155
type: SIMPLE_ASSIGN
tankHot.Q_losses = (-tankHot.A) * tankHot.alpha * (tankHot.T_mea - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4155(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4155};
  data->localData[0]->realVars[1349] /* tankHot.Q_losses variable */ = ((-data->localData[0]->realVars[1348] /* tankHot.A variable */)) * ((data->simulationInfo->realParameter[816] /* tankHot.alpha PARAM */) * (data->localData[0]->realVars[1350] /* tankHot.T_mea variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */));
  TRACE_POP
}
/*
equation index: 4156
type: SIMPLE_ASSIGN
tankHot.W_net = if tankHot.T_mea < tankHot.T_set then min(-tankHot.Q_losses, tankHot.W_max) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4156(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4156};
  modelica_boolean tmp20;
  RELATIONHYSTERESIS(tmp20, data->localData[0]->realVars[1350] /* tankHot.T_mea variable */, data->simulationInfo->realParameter[812] /* tankHot.T_set PARAM */, 13, Less);
  data->localData[0]->realVars[1353] /* tankHot.W_net variable */ = (tmp20?fmin((-data->localData[0]->realVars[1349] /* tankHot.Q_losses variable */),data->simulationInfo->realParameter[815] /* tankHot.W_max PARAM */):0.0);
  TRACE_POP
}
/*
equation index: 4157
type: SIMPLE_ASSIGN
tankHot.W_loss = tankHot.W_net / tankHot.e_ht
*/
void PhysicalParticleCO21D_v11_eqFunction_4157(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4157};
  data->localData[0]->realVars[1352] /* tankHot.W_loss variable */ = DIVISION_SIM(data->localData[0]->realVars[1353] /* tankHot.W_net variable */,data->simulationInfo->realParameter[817] /* tankHot.e_ht PARAM */,"tankHot.e_ht",equationIndexes);
  TRACE_POP
}
/*
equation index: 4158
type: ALGORITHM

  (sun.dec, sun.hra) := SolarTherm.Models.Sources.SolarModel.Sun$sun.solarPosition(time, sun.lon, sun.lat, sun.t_zone, sun.year);
*/
void PhysicalParticleCO21D_v11_eqFunction_4158(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4158};
  data->localData[0]->realVars[1327] /* sun.dec variable */ = omc_SolarTherm_Models_Sources_SolarModel_D_Sun24sun_solarPosition(threadData, data->localData[0]->timeValue, data->simulationInfo->realParameter[795] /* sun.lon PARAM */, data->simulationInfo->realParameter[794] /* sun.lat PARAM */, data->simulationInfo->realParameter[796] /* sun.t_zone PARAM */, data->simulationInfo->integerParameter[160] /* sun.year PARAM */ ,&data->localData[0]->realVars[1329] /* sun.hra variable */);
  TRACE_POP
}
/*
equation index: 4159
type: SIMPLE_ASSIGN
heliostatsField.optical.angle2_input.y = 57.29577951308232 * sun.hra
*/
void PhysicalParticleCO21D_v11_eqFunction_4159(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4159};
  data->localData[0]->realVars[95] /* heliostatsField.optical.angle2_input.y variable */ = (57.29577951308232) * (data->localData[0]->realVars[1329] /* sun.hra variable */);
  TRACE_POP
}
/*
equation index: 4160
type: SIMPLE_ASSIGN
heliostatsField.elo = SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(sun.dec)
*/
void PhysicalParticleCO21D_v11_eqFunction_4160(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4160};
  data->localData[0]->realVars[93] /* heliostatsField.elo variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_eclipticLongitude(threadData, data->localData[0]->realVars[1327] /* sun.dec variable */);
  TRACE_POP
}
/*
equation index: 4161
type: SIMPLE_ASSIGN
heliostatsField.ele = SolarTherm.Models.Sources.SolarFunctions.elevationAngle(sun.dec, sun.hra, heliostatsField.lat)
*/
void PhysicalParticleCO21D_v11_eqFunction_4161(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4161};
  data->localData[0]->realVars[92] /* heliostatsField.ele variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_elevationAngle(threadData, data->localData[0]->realVars[1327] /* sun.dec variable */, data->localData[0]->realVars[1329] /* sun.hra variable */, data->simulationInfo->realParameter[153] /* heliostatsField.lat PARAM */);
  TRACE_POP
}
/*
equation index: 4162
type: SIMPLE_ASSIGN
$whenCondition13 = heliostatsField.ele > 0.01
*/
void PhysicalParticleCO21D_v11_eqFunction_4162(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4162};
  modelica_boolean tmp21;
  RELATIONHYSTERESIS(tmp21, data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, 1, Greater);
  data->localData[0]->booleanVars[4] /* $whenCondition13 DISCRETE */ = tmp21;
  TRACE_POP
}
/*
equation index: 4163
type: WHEN

when {$whenCondition13} then
  heliostatsField.t_on = time;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4163(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4163};
  if((data->localData[0]->booleanVars[4] /* $whenCondition13 DISCRETE */ && !data->simulationInfo->booleanVarsPre[4] /* $whenCondition13 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1372] /* heliostatsField.t_on DISCRETE */ = data->localData[0]->timeValue;
  }
  TRACE_POP
}
/*
equation index: 4164
type: SIMPLE_ASSIGN
heliostatsField.zen = 1.570796326794897 - heliostatsField.ele
*/
void PhysicalParticleCO21D_v11_eqFunction_4164(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4164};
  data->localData[0]->realVars[98] /* heliostatsField.zen variable */ = 1.570796326794897 - data->localData[0]->realVars[92] /* heliostatsField.ele variable */;
  TRACE_POP
}
/*
equation index: 4165
type: SIMPLE_ASSIGN
heliostatsField.on_hf = heliostatsField.ele > heliostatsField.ele_min and Wspd_input.y < heliostatsField.Wspd_max
*/
void PhysicalParticleCO21D_v11_eqFunction_4165(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4165};
  modelica_boolean tmp22;
  modelica_boolean tmp23;
  RELATIONHYSTERESIS(tmp22, data->localData[0]->realVars[92] /* heliostatsField.ele variable */, data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */, 11, Greater);
  RELATIONHYSTERESIS(tmp23, data->localData[0]->realVars[57] /* Wspd_input.y variable */, data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */, 12, Less);
  data->localData[0]->booleanVars[22] /* heliostatsField.on_hf DISCRETE */ = (tmp22 && tmp23);
  TRACE_POP
}
/*
equation index: 4166
type: SIMPLE_ASSIGN
heliostatsField.zen2 = SolarTherm.Models.Sources.SolarFunctions.aparentSolarZenith(sun.dec, sun.hra, heliostatsField.lat)
*/
void PhysicalParticleCO21D_v11_eqFunction_4166(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4166};
  data->localData[0]->realVars[99] /* heliostatsField.zen2 variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_aparentSolarZenith(threadData, data->localData[0]->realVars[1327] /* sun.dec variable */, data->localData[0]->realVars[1329] /* sun.hra variable */, data->simulationInfo->realParameter[153] /* heliostatsField.lat PARAM */);
  TRACE_POP
}
/*
equation index: 4167
type: SIMPLE_ASSIGN
heliostatsField.azi = SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(sun.dec, sun.hra, heliostatsField.lat)
*/
void PhysicalParticleCO21D_v11_eqFunction_4167(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4167};
  data->localData[0]->realVars[90] /* heliostatsField.azi variable */ = omc_SolarTherm_Models_Sources_SolarFunctions_solarAzimuth(threadData, data->localData[0]->realVars[1327] /* sun.dec variable */, data->localData[0]->realVars[1329] /* sun.hra variable */, data->simulationInfo->realParameter[153] /* heliostatsField.lat PARAM */);
  TRACE_POP
}
/*
equation index: 4168
type: SIMPLE_ASSIGN
heliostatsField.optical.angle1_input.y = 57.29577951308232 * sun.dec
*/
void PhysicalParticleCO21D_v11_eqFunction_4168(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4168};
  data->localData[0]->realVars[94] /* heliostatsField.optical.angle1_input.y variable */ = (57.29577951308232) * (data->localData[0]->realVars[1327] /* sun.dec variable */);
  TRACE_POP
}
/*
equation index: 4169
type: SIMPLE_ASSIGN
heliostatsField.optical.nu_table.y = Modelica.Blocks.Tables.CombiTable2D$heliostatsField$optical$nu_table.getTableValue(heliostatsField.optical.nu_table.tableID, heliostatsField.optical.angle1_input.y, heliostatsField.optical.angle2_input.y, heliostatsField.optical.nu_table.tableOnFileRead)
*/
void PhysicalParticleCO21D_v11_eqFunction_4169(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4169};
  data->localData[0]->realVars[97] /* heliostatsField.optical.nu_table.y variable */ = omc_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_getTableValue(threadData, data->simulationInfo->extObjs[1], data->localData[0]->realVars[94] /* heliostatsField.optical.angle1_input.y variable */, data->localData[0]->realVars[95] /* heliostatsField.optical.angle2_input.y variable */, data->simulationInfo->realParameter[160] /* heliostatsField.optical.nu_table.tableOnFileRead PARAM */);
  TRACE_POP
}
/*
equation index: 4170
type: SIMPLE_ASSIGN
heliostatsField.optical.nu = max(0.0, heliostatsField.optical.nu_table.y)
*/
void PhysicalParticleCO21D_v11_eqFunction_4170(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4170};
  data->localData[0]->realVars[96] /* heliostatsField.optical.nu variable */ = fmax(0.0,data->localData[0]->realVars[97] /* heliostatsField.optical.nu_table.y variable */);
  TRACE_POP
}
/*
equation index: 4171
type: SIMPLE_ASSIGN
heliostatsField.Q_raw = if heliostatsField.on_hf then max(heliostatsField.he_av * heliostatsField.n_h * heliostatsField.A_h * sun.dni * heliostatsField.optical.nu, 0.0) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4171(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4171};
  data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */ = (data->localData[0]->booleanVars[22] /* heliostatsField.on_hf DISCRETE */?fmax((data->simulationInfo->realParameter[152] /* heliostatsField.he_av PARAM */) * ((data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[143] /* heliostatsField.A_h PARAM */) * ((data->localData[0]->realVars[1328] /* sun.dni variable */) * (data->localData[0]->realVars[96] /* heliostatsField.optical.nu variable */)))),0.0):0.0);
  TRACE_POP
}
/*
equation index: 4172
type: SIMPLE_ASSIGN
$DER.E_helio_raw = heliostatsField.Q_raw
*/
void PhysicalParticleCO21D_v11_eqFunction_4172(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4172};
  data->localData[0]->realVars[20] /* der(E_helio_raw) STATE_DER */ = data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */;
  TRACE_POP
}
/*
equation index: 4173
type: SIMPLE_ASSIGN
$whenCondition15 = heliostatsField.Q_raw > heliostatsField.Q_start
*/
void PhysicalParticleCO21D_v11_eqFunction_4173(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4173};
  modelica_boolean tmp24;
  RELATIONHYSTERESIS(tmp24, data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */, 15, Greater);
  data->localData[0]->booleanVars[6] /* $whenCondition15 DISCRETE */ = tmp24;
  TRACE_POP
}
/*
equation index: 4174
type: SIMPLE_ASSIGN
$whenCondition14 = heliostatsField.Q_raw < heliostatsField.Q_min
*/
void PhysicalParticleCO21D_v11_eqFunction_4174(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4174};
  modelica_boolean tmp25;
  RELATIONHYSTERESIS(tmp25, data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */, 16, Less);
  data->localData[0]->booleanVars[5] /* $whenCondition14 DISCRETE */ = tmp25;
  TRACE_POP
}
/*
equation index: 4175
type: WHEN

when {$whenCondition15} then
  heliostatsField.on_internal = true;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4175(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4175};
  if((data->localData[0]->booleanVars[6] /* $whenCondition15 DISCRETE */ && !data->simulationInfo->booleanVarsPre[6] /* $whenCondition15 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[5] /* $whenCondition14 DISCRETE */ && !data->simulationInfo->booleanVarsPre[5] /* $whenCondition14 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4177
type: SIMPLE_ASSIGN
simpleReceiverControl.and1.y = simpleReceiverControl.hotTank.y and heliostatsField.on_internal
*/
void PhysicalParticleCO21D_v11_eqFunction_4177(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4177};
  data->localData[0]->booleanVars[26] /* simpleReceiverControl.and1.y DISCRETE */ = (data->localData[0]->booleanVars[28] /* simpleReceiverControl.hotTank.y DISCRETE */ && data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */);
  TRACE_POP
}
/*
equation index: 4178
type: SIMPLE_ASSIGN
$DER.E_helio_incident = if heliostatsField.on_internal then heliostatsField.n_h * heliostatsField.A_h * max(0.0, sun.dni) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4178(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4178};
  data->localData[0]->realVars[18] /* der(E_helio_incident) STATE_DER */ = (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */?(data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[143] /* heliostatsField.A_h PARAM */) * (fmax(0.0,data->localData[0]->realVars[1328] /* sun.dni variable */))):0.0);
  TRACE_POP
}
/*
equation index: 4179
type: SIMPLE_ASSIGN
heliostatsField.Q_incident = if heliostatsField.on_internal then if heliostatsField.defocus then min(heliostatsField.Q_defocus, heliostatsField.Q_raw) else heliostatsField.Q_raw else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4179(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4179};
  data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */ = (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */?(data->localData[0]->booleanVars[21] /* heliostatsField.defocus DISCRETE */?fmin(data->simulationInfo->realParameter[145] /* heliostatsField.Q_defocus PARAM */,data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */):data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */):0.0);
  TRACE_POP
}
/*
equation index: 4180
type: ALGORITHM

  simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete := $START.simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete;
  simpleReceiverControl.idealMassflowBlockCalculation.m_flow := $START.simpleReceiverControl.idealMassflowBlockCalculation.m_flow;
  if heliostatsField.Q_incident <= 1e-06 then
    simpleReceiverControl.idealMassflowBlockCalculation.m_flow := 0.0;
  elseif heliostatsField.Q_incident > 1e-06 then
    if simpleReceiverControl.idealMassflowBlockCalculation.eta_rec < 9.999999999999999e-21 then
      simpleReceiverControl.idealMassflowBlockCalculation.m_flow := heliostatsField.Q_incident * simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete / abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D_v11.T_s[1]));
    else
      simpleReceiverControl.idealMassflowBlockCalculation.m_flow := heliostatsField.Q_incident * simpleReceiverControl.idealMassflowBlockCalculation.eta_rec / abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D_v11.T_s[1]));
      simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete := simpleReceiverControl.idealMassflowBlockCalculation.eta_rec;
    end if;
  end if;
*/
void PhysicalParticleCO21D_v11_eqFunction_4180(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4180};
  modelica_boolean tmp26;
  modelica_boolean tmp27;
  modelica_boolean tmp28;
  data->localData[0]->realVars[1323] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */ = data->modelData->realVarsData[1323].attribute /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */.start;

  data->localData[0]->realVars[1324] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = data->modelData->realVarsData[1324].attribute /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */.start;

  RELATIONHYSTERESIS(tmp26, data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, 18, LessEq);
  if(tmp26)
  {
    data->localData[0]->realVars[1324] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = 0.0;
  }
  else
  {
    RELATIONHYSTERESIS(tmp27, data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, 17, Greater);
    if(tmp27)
    {
      tmp28 = Less(data->simulationInfo->realParameter[778] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec PARAM */,9.999999999999999e-21);
      if(tmp28)
      {
        data->localData[0]->realVars[1324] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */) * (DIVISION_SIM(data->localData[0]->realVars[1323] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */,fabs(omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->simulationInfo->realParameter[769] /* simpleReceiverControl.T_ref PARAM */) - omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */)),"abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D_v11.T_s[1]))",equationIndexes));
      }
      else
      {
        data->localData[0]->realVars[1324] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */ = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */) * (DIVISION_SIM(data->simulationInfo->realParameter[778] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec PARAM */,fabs(omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->simulationInfo->realParameter[769] /* simpleReceiverControl.T_ref PARAM */) - omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */)),"abs(SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(simpleReceiverControl.T_ref) - SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(particleReceiver1D_v11.T_s[1]))",equationIndexes));

        data->localData[0]->realVars[1323] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec_discrete variable */ = data->simulationInfo->realParameter[778] /* simpleReceiverControl.idealMassflowBlockCalculation.eta_rec PARAM */;
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4181
type: SIMPLE_ASSIGN
simpleReceiverControl.limiter.y = smooth(0, if simpleReceiverControl.idealMassflowBlockCalculation.m_flow > simpleReceiverControl.limiter.uMax then simpleReceiverControl.limiter.uMax else if simpleReceiverControl.idealMassflowBlockCalculation.m_flow < simpleReceiverControl.limiter.uMin then simpleReceiverControl.limiter.uMin else simpleReceiverControl.idealMassflowBlockCalculation.m_flow)
*/
void PhysicalParticleCO21D_v11_eqFunction_4181(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4181};
  modelica_boolean tmp29;
  modelica_boolean tmp30;
  modelica_boolean tmp31;
  modelica_real tmp32;
  tmp29 = Greater(data->localData[0]->realVars[1324] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */,data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMax PARAM */);
  tmp31 = (modelica_boolean)tmp29;
  if(tmp31)
  {
    tmp32 = data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMax PARAM */;
  }
  else
  {
    tmp30 = Less(data->localData[0]->realVars[1324] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */,data->simulationInfo->realParameter[781] /* simpleReceiverControl.limiter.uMin PARAM */);
    tmp32 = (tmp30?data->simulationInfo->realParameter[781] /* simpleReceiverControl.limiter.uMin PARAM */:data->localData[0]->realVars[1324] /* simpleReceiverControl.idealMassflowBlockCalculation.m_flow variable */);
  }
  data->localData[0]->realVars[1325] /* simpleReceiverControl.limiter.y variable */ = tmp32;
  TRACE_POP
}
/*
equation index: 4182
type: SIMPLE_ASSIGN
controlHot.m_flow_in = if simpleReceiverControl.and1.y then simpleReceiverControl.limiter.y else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4182(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4182};
  data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */ = (data->localData[0]->booleanVars[26] /* simpleReceiverControl.and1.y DISCRETE */?data->localData[0]->realVars[1325] /* simpleReceiverControl.limiter.y variable */:0.0);
  TRACE_POP
}
/*
equation index: 4183
type: SIMPLE_ASSIGN
particleReceiver1D_v11.mdot = if liftRC.use_input then controlHot.m_flow_in else liftRC.m_flow_fixed
*/
void PhysicalParticleCO21D_v11_eqFunction_4183(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4183};
  data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */ = (data->simulationInfo->booleanParameter[16] /* liftRC.use_input PARAM */?data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */:data->simulationInfo->realParameter[178] /* liftRC.m_flow_fixed PARAM */);
  TRACE_POP
}
/*
equation index: 4184
type: SIMPLE_ASSIGN
liftRC.W_loss = 9.806649999999999 * particleReceiver1D_v11.mdot * liftRC.dh * (1.0 - liftRC.CF) / liftRC.eff
*/
void PhysicalParticleCO21D_v11_eqFunction_4184(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4184};
  data->localData[0]->realVars[102] /* liftRC.W_loss variable */ = (9.806649999999999) * ((data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */) * ((data->simulationInfo->realParameter[175] /* liftRC.dh PARAM */) * (DIVISION_SIM(1.0 - data->simulationInfo->realParameter[174] /* liftRC.CF PARAM */,data->simulationInfo->realParameter[177] /* liftRC.eff PARAM */,"liftRC.eff",equationIndexes))));
  TRACE_POP
}
/*
equation index: 4185
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c_in = particleReceiver1D_v11.mdot / (particleReceiver1D_v11.phi_max * particleReceiver1D_v11.vp_in * particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.rho_s)
*/
void PhysicalParticleCO21D_v11_eqFunction_4185(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4185};
  data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ = DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->simulationInfo->realParameter[340] /* particleReceiver1D_v11.phi_max PARAM */) * (data->simulationInfo->realParameter[348] /* particleReceiver1D_v11.vp_in PARAM */)) * (data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.phi_max * particleReceiver1D_v11.vp_in * particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.rho_s",equationIndexes);
  TRACE_POP
}
/*
equation index: 4186
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[1] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4186(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4186};
  modelica_boolean tmp33;
  RELATIONHYSTERESIS(tmp33, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1098] /* particleReceiver1D_v11.t_c[1] variable */ = (tmp33?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */:0.0);
  TRACE_POP
}
/*
equation index: 4187
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[2] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[2] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4187(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4187};
  modelica_boolean tmp34;
  RELATIONHYSTERESIS(tmp34, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1099] /* particleReceiver1D_v11.t_c[2] variable */ = (tmp34?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1162] /* particleReceiver1D_v11.x[2] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4188
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[3] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[3] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4188(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4188};
  modelica_boolean tmp35;
  RELATIONHYSTERESIS(tmp35, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1100] /* particleReceiver1D_v11.t_c[3] variable */ = (tmp35?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1163] /* particleReceiver1D_v11.x[3] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4189
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[4] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[4] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4189(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4189};
  modelica_boolean tmp36;
  RELATIONHYSTERESIS(tmp36, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1101] /* particleReceiver1D_v11.t_c[4] variable */ = (tmp36?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1164] /* particleReceiver1D_v11.x[4] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4190
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[5] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[5] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4190(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4190};
  modelica_boolean tmp37;
  RELATIONHYSTERESIS(tmp37, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1102] /* particleReceiver1D_v11.t_c[5] variable */ = (tmp37?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1165] /* particleReceiver1D_v11.x[5] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4191
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[6] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[6] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4191(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4191};
  modelica_boolean tmp38;
  RELATIONHYSTERESIS(tmp38, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1103] /* particleReceiver1D_v11.t_c[6] variable */ = (tmp38?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1166] /* particleReceiver1D_v11.x[6] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4192
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[7] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[7] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4192(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4192};
  modelica_boolean tmp39;
  RELATIONHYSTERESIS(tmp39, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1104] /* particleReceiver1D_v11.t_c[7] variable */ = (tmp39?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1167] /* particleReceiver1D_v11.x[7] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4193
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[8] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[8] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4193(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4193};
  modelica_boolean tmp40;
  RELATIONHYSTERESIS(tmp40, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1105] /* particleReceiver1D_v11.t_c[8] variable */ = (tmp40?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1168] /* particleReceiver1D_v11.x[8] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4194
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[9] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[9] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4194(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4194};
  modelica_boolean tmp41;
  RELATIONHYSTERESIS(tmp41, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1106] /* particleReceiver1D_v11.t_c[9] variable */ = (tmp41?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1169] /* particleReceiver1D_v11.x[9] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4195
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[10] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[10] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4195(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4195};
  modelica_boolean tmp42;
  RELATIONHYSTERESIS(tmp42, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1107] /* particleReceiver1D_v11.t_c[10] variable */ = (tmp42?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1170] /* particleReceiver1D_v11.x[10] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4196
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[11] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[11] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4196(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4196};
  modelica_boolean tmp43;
  RELATIONHYSTERESIS(tmp43, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1108] /* particleReceiver1D_v11.t_c[11] variable */ = (tmp43?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1171] /* particleReceiver1D_v11.x[11] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4197
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[12] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[12] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4197(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4197};
  modelica_boolean tmp44;
  RELATIONHYSTERESIS(tmp44, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1109] /* particleReceiver1D_v11.t_c[12] variable */ = (tmp44?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1172] /* particleReceiver1D_v11.x[12] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4198
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[13] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[13] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4198(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4198};
  modelica_boolean tmp45;
  RELATIONHYSTERESIS(tmp45, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1110] /* particleReceiver1D_v11.t_c[13] variable */ = (tmp45?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1173] /* particleReceiver1D_v11.x[13] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4199
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[14] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[14] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4199(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4199};
  modelica_boolean tmp46;
  RELATIONHYSTERESIS(tmp46, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1111] /* particleReceiver1D_v11.t_c[14] variable */ = (tmp46?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1174] /* particleReceiver1D_v11.x[14] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4200
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[15] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[15] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4200(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4200};
  modelica_boolean tmp47;
  RELATIONHYSTERESIS(tmp47, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1112] /* particleReceiver1D_v11.t_c[15] variable */ = (tmp47?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1175] /* particleReceiver1D_v11.x[15] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4201
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[16] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[16] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4201(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4201};
  modelica_boolean tmp48;
  RELATIONHYSTERESIS(tmp48, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1113] /* particleReceiver1D_v11.t_c[16] variable */ = (tmp48?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1176] /* particleReceiver1D_v11.x[16] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4202
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[17] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[17] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4202(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4202};
  modelica_boolean tmp49;
  RELATIONHYSTERESIS(tmp49, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1114] /* particleReceiver1D_v11.t_c[17] variable */ = (tmp49?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1177] /* particleReceiver1D_v11.x[17] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4203
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[18] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[18] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4203(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4203};
  modelica_boolean tmp50;
  RELATIONHYSTERESIS(tmp50, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1115] /* particleReceiver1D_v11.t_c[18] variable */ = (tmp50?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1178] /* particleReceiver1D_v11.x[18] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4204
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[19] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[19] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4204(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4204};
  modelica_boolean tmp51;
  RELATIONHYSTERESIS(tmp51, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1116] /* particleReceiver1D_v11.t_c[19] variable */ = (tmp51?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1179] /* particleReceiver1D_v11.x[19] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4205
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[20] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[20] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4205(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4205};
  modelica_boolean tmp52;
  RELATIONHYSTERESIS(tmp52, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1117] /* particleReceiver1D_v11.t_c[20] variable */ = (tmp52?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1180] /* particleReceiver1D_v11.x[20] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4206
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[21] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.x[21] else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4206(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4206};
  modelica_boolean tmp53;
  RELATIONHYSTERESIS(tmp53, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1118] /* particleReceiver1D_v11.t_c[21] variable */ = (tmp53?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->localData[0]->realVars[1181] /* particleReceiver1D_v11.x[21] variable */):0.0);
  TRACE_POP
}
/*
equation index: 4207
type: SIMPLE_ASSIGN
particleReceiver1D_v11.t_c[22] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.t_c_in + 0.008699999999999999 * particleReceiver1D_v11.H_drop_design else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4207(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4207};
  modelica_boolean tmp54;
  RELATIONHYSTERESIS(tmp54, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[1119] /* particleReceiver1D_v11.t_c[22] variable */ = (tmp54?data->localData[0]->realVars[1120] /* particleReceiver1D_v11.t_c_in variable */ + (0.008699999999999999) * (data->simulationInfo->realParameter[307] /* particleReceiver1D_v11.H_drop_design PARAM */):0.0);
  TRACE_POP
}
/*
equation index: 4208
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[2] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp_in ^ 2.0 + 19.6133 * particleReceiver1D_v11.x[2]) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4208(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4208};
  modelica_boolean tmp55;
  modelica_real tmp56;
  modelica_real tmp57;
  modelica_boolean tmp58;
  modelica_real tmp59;
  RELATIONHYSTERESIS(tmp55, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp58 = (modelica_boolean)tmp55;
  if(tmp58)
  {
    tmp56 = data->simulationInfo->realParameter[348] /* particleReceiver1D_v11.vp_in PARAM */;
    tmp57 = (tmp56 * tmp56) + (19.6133) * (data->localData[0]->realVars[1162] /* particleReceiver1D_v11.x[2] variable */);
    if(!(tmp57 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp_in ^ 2.0 + 19.6133 * particleReceiver1D_v11.x[2]) was %g should be >= 0", tmp57);
    }
    tmp59 = sqrt(tmp57);
  }
  else
  {
    tmp59 = 0.0;
  }
  data->localData[0]->realVars[1141] /* particleReceiver1D_v11.vp[2] variable */ = tmp59;
  TRACE_POP
}
/*
equation index: 4209
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[2] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[2] * particleReceiver1D_v11.vp[2] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4209(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4209};
  modelica_boolean tmp60;
  RELATIONHYSTERESIS(tmp60, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[977] /* particleReceiver1D_v11.phi[2] variable */ = (tmp60?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1099] /* particleReceiver1D_v11.t_c[2] variable */)) * (data->localData[0]->realVars[1141] /* particleReceiver1D_v11.vp[2] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[2] * particleReceiver1D_v11.vp[2] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4210
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[3] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[2] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[3] - particleReceiver1D_v11.x[2])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4210(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4210};
  modelica_boolean tmp61;
  modelica_real tmp62;
  modelica_real tmp63;
  modelica_boolean tmp64;
  modelica_real tmp65;
  RELATIONHYSTERESIS(tmp61, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp64 = (modelica_boolean)tmp61;
  if(tmp64)
  {
    tmp62 = data->localData[0]->realVars[1141] /* particleReceiver1D_v11.vp[2] variable */;
    tmp63 = (tmp62 * tmp62) + (19.6133) * (data->localData[0]->realVars[1163] /* particleReceiver1D_v11.x[3] variable */ - data->localData[0]->realVars[1162] /* particleReceiver1D_v11.x[2] variable */);
    if(!(tmp63 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[2] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[3] - particleReceiver1D_v11.x[2])) was %g should be >= 0", tmp63);
    }
    tmp65 = sqrt(tmp63);
  }
  else
  {
    tmp65 = 0.0;
  }
  data->localData[0]->realVars[1142] /* particleReceiver1D_v11.vp[3] variable */ = tmp65;
  TRACE_POP
}
/*
equation index: 4211
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[3] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[3] * particleReceiver1D_v11.vp[3] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4211(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4211};
  modelica_boolean tmp66;
  RELATIONHYSTERESIS(tmp66, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[978] /* particleReceiver1D_v11.phi[3] variable */ = (tmp66?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1100] /* particleReceiver1D_v11.t_c[3] variable */)) * (data->localData[0]->realVars[1142] /* particleReceiver1D_v11.vp[3] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[3] * particleReceiver1D_v11.vp[3] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4212
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[4] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[3] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[4] - particleReceiver1D_v11.x[3])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4212(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4212};
  modelica_boolean tmp67;
  modelica_real tmp68;
  modelica_real tmp69;
  modelica_boolean tmp70;
  modelica_real tmp71;
  RELATIONHYSTERESIS(tmp67, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp70 = (modelica_boolean)tmp67;
  if(tmp70)
  {
    tmp68 = data->localData[0]->realVars[1142] /* particleReceiver1D_v11.vp[3] variable */;
    tmp69 = (tmp68 * tmp68) + (19.6133) * (data->localData[0]->realVars[1164] /* particleReceiver1D_v11.x[4] variable */ - data->localData[0]->realVars[1163] /* particleReceiver1D_v11.x[3] variable */);
    if(!(tmp69 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[3] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[4] - particleReceiver1D_v11.x[3])) was %g should be >= 0", tmp69);
    }
    tmp71 = sqrt(tmp69);
  }
  else
  {
    tmp71 = 0.0;
  }
  data->localData[0]->realVars[1143] /* particleReceiver1D_v11.vp[4] variable */ = tmp71;
  TRACE_POP
}
/*
equation index: 4213
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[4] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[4] * particleReceiver1D_v11.vp[4] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4213(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4213};
  modelica_boolean tmp72;
  RELATIONHYSTERESIS(tmp72, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[979] /* particleReceiver1D_v11.phi[4] variable */ = (tmp72?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1101] /* particleReceiver1D_v11.t_c[4] variable */)) * (data->localData[0]->realVars[1143] /* particleReceiver1D_v11.vp[4] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[4] * particleReceiver1D_v11.vp[4] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4214
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[5] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[4] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[5] - particleReceiver1D_v11.x[4])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4214(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4214};
  modelica_boolean tmp73;
  modelica_real tmp74;
  modelica_real tmp75;
  modelica_boolean tmp76;
  modelica_real tmp77;
  RELATIONHYSTERESIS(tmp73, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp76 = (modelica_boolean)tmp73;
  if(tmp76)
  {
    tmp74 = data->localData[0]->realVars[1143] /* particleReceiver1D_v11.vp[4] variable */;
    tmp75 = (tmp74 * tmp74) + (19.6133) * (data->localData[0]->realVars[1165] /* particleReceiver1D_v11.x[5] variable */ - data->localData[0]->realVars[1164] /* particleReceiver1D_v11.x[4] variable */);
    if(!(tmp75 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[4] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[5] - particleReceiver1D_v11.x[4])) was %g should be >= 0", tmp75);
    }
    tmp77 = sqrt(tmp75);
  }
  else
  {
    tmp77 = 0.0;
  }
  data->localData[0]->realVars[1144] /* particleReceiver1D_v11.vp[5] variable */ = tmp77;
  TRACE_POP
}
/*
equation index: 4215
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[5] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[5] * particleReceiver1D_v11.vp[5] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4215(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4215};
  modelica_boolean tmp78;
  RELATIONHYSTERESIS(tmp78, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[980] /* particleReceiver1D_v11.phi[5] variable */ = (tmp78?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1102] /* particleReceiver1D_v11.t_c[5] variable */)) * (data->localData[0]->realVars[1144] /* particleReceiver1D_v11.vp[5] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[5] * particleReceiver1D_v11.vp[5] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4216
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[6] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[5] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[6] - particleReceiver1D_v11.x[5])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4216(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4216};
  modelica_boolean tmp79;
  modelica_real tmp80;
  modelica_real tmp81;
  modelica_boolean tmp82;
  modelica_real tmp83;
  RELATIONHYSTERESIS(tmp79, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp82 = (modelica_boolean)tmp79;
  if(tmp82)
  {
    tmp80 = data->localData[0]->realVars[1144] /* particleReceiver1D_v11.vp[5] variable */;
    tmp81 = (tmp80 * tmp80) + (19.6133) * (data->localData[0]->realVars[1166] /* particleReceiver1D_v11.x[6] variable */ - data->localData[0]->realVars[1165] /* particleReceiver1D_v11.x[5] variable */);
    if(!(tmp81 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[5] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[6] - particleReceiver1D_v11.x[5])) was %g should be >= 0", tmp81);
    }
    tmp83 = sqrt(tmp81);
  }
  else
  {
    tmp83 = 0.0;
  }
  data->localData[0]->realVars[1145] /* particleReceiver1D_v11.vp[6] variable */ = tmp83;
  TRACE_POP
}
/*
equation index: 4217
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[6] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[6] * particleReceiver1D_v11.vp[6] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4217(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4217};
  modelica_boolean tmp84;
  RELATIONHYSTERESIS(tmp84, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[981] /* particleReceiver1D_v11.phi[6] variable */ = (tmp84?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1103] /* particleReceiver1D_v11.t_c[6] variable */)) * (data->localData[0]->realVars[1145] /* particleReceiver1D_v11.vp[6] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[6] * particleReceiver1D_v11.vp[6] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4218
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[7] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[6] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[7] - particleReceiver1D_v11.x[6])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4218(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4218};
  modelica_boolean tmp85;
  modelica_real tmp86;
  modelica_real tmp87;
  modelica_boolean tmp88;
  modelica_real tmp89;
  RELATIONHYSTERESIS(tmp85, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp88 = (modelica_boolean)tmp85;
  if(tmp88)
  {
    tmp86 = data->localData[0]->realVars[1145] /* particleReceiver1D_v11.vp[6] variable */;
    tmp87 = (tmp86 * tmp86) + (19.6133) * (data->localData[0]->realVars[1167] /* particleReceiver1D_v11.x[7] variable */ - data->localData[0]->realVars[1166] /* particleReceiver1D_v11.x[6] variable */);
    if(!(tmp87 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[6] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[7] - particleReceiver1D_v11.x[6])) was %g should be >= 0", tmp87);
    }
    tmp89 = sqrt(tmp87);
  }
  else
  {
    tmp89 = 0.0;
  }
  data->localData[0]->realVars[1146] /* particleReceiver1D_v11.vp[7] variable */ = tmp89;
  TRACE_POP
}
/*
equation index: 4219
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[7] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[7] * particleReceiver1D_v11.vp[7] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4219(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4219};
  modelica_boolean tmp90;
  RELATIONHYSTERESIS(tmp90, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[982] /* particleReceiver1D_v11.phi[7] variable */ = (tmp90?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1104] /* particleReceiver1D_v11.t_c[7] variable */)) * (data->localData[0]->realVars[1146] /* particleReceiver1D_v11.vp[7] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[7] * particleReceiver1D_v11.vp[7] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4220
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[8] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[7] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[8] - particleReceiver1D_v11.x[7])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4220(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4220};
  modelica_boolean tmp91;
  modelica_real tmp92;
  modelica_real tmp93;
  modelica_boolean tmp94;
  modelica_real tmp95;
  RELATIONHYSTERESIS(tmp91, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp94 = (modelica_boolean)tmp91;
  if(tmp94)
  {
    tmp92 = data->localData[0]->realVars[1146] /* particleReceiver1D_v11.vp[7] variable */;
    tmp93 = (tmp92 * tmp92) + (19.6133) * (data->localData[0]->realVars[1168] /* particleReceiver1D_v11.x[8] variable */ - data->localData[0]->realVars[1167] /* particleReceiver1D_v11.x[7] variable */);
    if(!(tmp93 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[7] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[8] - particleReceiver1D_v11.x[7])) was %g should be >= 0", tmp93);
    }
    tmp95 = sqrt(tmp93);
  }
  else
  {
    tmp95 = 0.0;
  }
  data->localData[0]->realVars[1147] /* particleReceiver1D_v11.vp[8] variable */ = tmp95;
  TRACE_POP
}
/*
equation index: 4221
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[8] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[8] * particleReceiver1D_v11.vp[8] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4221(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4221};
  modelica_boolean tmp96;
  RELATIONHYSTERESIS(tmp96, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[983] /* particleReceiver1D_v11.phi[8] variable */ = (tmp96?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1105] /* particleReceiver1D_v11.t_c[8] variable */)) * (data->localData[0]->realVars[1147] /* particleReceiver1D_v11.vp[8] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[8] * particleReceiver1D_v11.vp[8] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4222
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[9] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[8] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[9] - particleReceiver1D_v11.x[8])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4222(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4222};
  modelica_boolean tmp97;
  modelica_real tmp98;
  modelica_real tmp99;
  modelica_boolean tmp100;
  modelica_real tmp101;
  RELATIONHYSTERESIS(tmp97, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp100 = (modelica_boolean)tmp97;
  if(tmp100)
  {
    tmp98 = data->localData[0]->realVars[1147] /* particleReceiver1D_v11.vp[8] variable */;
    tmp99 = (tmp98 * tmp98) + (19.6133) * (data->localData[0]->realVars[1169] /* particleReceiver1D_v11.x[9] variable */ - data->localData[0]->realVars[1168] /* particleReceiver1D_v11.x[8] variable */);
    if(!(tmp99 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[8] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[9] - particleReceiver1D_v11.x[8])) was %g should be >= 0", tmp99);
    }
    tmp101 = sqrt(tmp99);
  }
  else
  {
    tmp101 = 0.0;
  }
  data->localData[0]->realVars[1148] /* particleReceiver1D_v11.vp[9] variable */ = tmp101;
  TRACE_POP
}
/*
equation index: 4223
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[9] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[9] * particleReceiver1D_v11.vp[9] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4223(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4223};
  modelica_boolean tmp102;
  RELATIONHYSTERESIS(tmp102, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[984] /* particleReceiver1D_v11.phi[9] variable */ = (tmp102?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1106] /* particleReceiver1D_v11.t_c[9] variable */)) * (data->localData[0]->realVars[1148] /* particleReceiver1D_v11.vp[9] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[9] * particleReceiver1D_v11.vp[9] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4224
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[10] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[9] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[10] - particleReceiver1D_v11.x[9])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4224(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4224};
  modelica_boolean tmp103;
  modelica_real tmp104;
  modelica_real tmp105;
  modelica_boolean tmp106;
  modelica_real tmp107;
  RELATIONHYSTERESIS(tmp103, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp106 = (modelica_boolean)tmp103;
  if(tmp106)
  {
    tmp104 = data->localData[0]->realVars[1148] /* particleReceiver1D_v11.vp[9] variable */;
    tmp105 = (tmp104 * tmp104) + (19.6133) * (data->localData[0]->realVars[1170] /* particleReceiver1D_v11.x[10] variable */ - data->localData[0]->realVars[1169] /* particleReceiver1D_v11.x[9] variable */);
    if(!(tmp105 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[9] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[10] - particleReceiver1D_v11.x[9])) was %g should be >= 0", tmp105);
    }
    tmp107 = sqrt(tmp105);
  }
  else
  {
    tmp107 = 0.0;
  }
  data->localData[0]->realVars[1149] /* particleReceiver1D_v11.vp[10] variable */ = tmp107;
  TRACE_POP
}
/*
equation index: 4225
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[10] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[10] * particleReceiver1D_v11.vp[10] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4225(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4225};
  modelica_boolean tmp108;
  RELATIONHYSTERESIS(tmp108, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[985] /* particleReceiver1D_v11.phi[10] variable */ = (tmp108?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1107] /* particleReceiver1D_v11.t_c[10] variable */)) * (data->localData[0]->realVars[1149] /* particleReceiver1D_v11.vp[10] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[10] * particleReceiver1D_v11.vp[10] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4226
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[11] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[10] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[11] - particleReceiver1D_v11.x[10])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4226(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4226};
  modelica_boolean tmp109;
  modelica_real tmp110;
  modelica_real tmp111;
  modelica_boolean tmp112;
  modelica_real tmp113;
  RELATIONHYSTERESIS(tmp109, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp112 = (modelica_boolean)tmp109;
  if(tmp112)
  {
    tmp110 = data->localData[0]->realVars[1149] /* particleReceiver1D_v11.vp[10] variable */;
    tmp111 = (tmp110 * tmp110) + (19.6133) * (data->localData[0]->realVars[1171] /* particleReceiver1D_v11.x[11] variable */ - data->localData[0]->realVars[1170] /* particleReceiver1D_v11.x[10] variable */);
    if(!(tmp111 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[10] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[11] - particleReceiver1D_v11.x[10])) was %g should be >= 0", tmp111);
    }
    tmp113 = sqrt(tmp111);
  }
  else
  {
    tmp113 = 0.0;
  }
  data->localData[0]->realVars[1150] /* particleReceiver1D_v11.vp[11] variable */ = tmp113;
  TRACE_POP
}
/*
equation index: 4227
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[11] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[11] * particleReceiver1D_v11.vp[11] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4227(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4227};
  modelica_boolean tmp114;
  RELATIONHYSTERESIS(tmp114, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[986] /* particleReceiver1D_v11.phi[11] variable */ = (tmp114?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1108] /* particleReceiver1D_v11.t_c[11] variable */)) * (data->localData[0]->realVars[1150] /* particleReceiver1D_v11.vp[11] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[11] * particleReceiver1D_v11.vp[11] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4228
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[12] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[11] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[12] - particleReceiver1D_v11.x[11])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4228(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4228};
  modelica_boolean tmp115;
  modelica_real tmp116;
  modelica_real tmp117;
  modelica_boolean tmp118;
  modelica_real tmp119;
  RELATIONHYSTERESIS(tmp115, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp118 = (modelica_boolean)tmp115;
  if(tmp118)
  {
    tmp116 = data->localData[0]->realVars[1150] /* particleReceiver1D_v11.vp[11] variable */;
    tmp117 = (tmp116 * tmp116) + (19.6133) * (data->localData[0]->realVars[1172] /* particleReceiver1D_v11.x[12] variable */ - data->localData[0]->realVars[1171] /* particleReceiver1D_v11.x[11] variable */);
    if(!(tmp117 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[11] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[12] - particleReceiver1D_v11.x[11])) was %g should be >= 0", tmp117);
    }
    tmp119 = sqrt(tmp117);
  }
  else
  {
    tmp119 = 0.0;
  }
  data->localData[0]->realVars[1151] /* particleReceiver1D_v11.vp[12] variable */ = tmp119;
  TRACE_POP
}
/*
equation index: 4229
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[12] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[12] * particleReceiver1D_v11.vp[12] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4229(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4229};
  modelica_boolean tmp120;
  RELATIONHYSTERESIS(tmp120, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[987] /* particleReceiver1D_v11.phi[12] variable */ = (tmp120?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1109] /* particleReceiver1D_v11.t_c[12] variable */)) * (data->localData[0]->realVars[1151] /* particleReceiver1D_v11.vp[12] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[12] * particleReceiver1D_v11.vp[12] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4230
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[13] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[12] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[13] - particleReceiver1D_v11.x[12])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4230(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4230};
  modelica_boolean tmp121;
  modelica_real tmp122;
  modelica_real tmp123;
  modelica_boolean tmp124;
  modelica_real tmp125;
  RELATIONHYSTERESIS(tmp121, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp124 = (modelica_boolean)tmp121;
  if(tmp124)
  {
    tmp122 = data->localData[0]->realVars[1151] /* particleReceiver1D_v11.vp[12] variable */;
    tmp123 = (tmp122 * tmp122) + (19.6133) * (data->localData[0]->realVars[1173] /* particleReceiver1D_v11.x[13] variable */ - data->localData[0]->realVars[1172] /* particleReceiver1D_v11.x[12] variable */);
    if(!(tmp123 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[12] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[13] - particleReceiver1D_v11.x[12])) was %g should be >= 0", tmp123);
    }
    tmp125 = sqrt(tmp123);
  }
  else
  {
    tmp125 = 0.0;
  }
  data->localData[0]->realVars[1152] /* particleReceiver1D_v11.vp[13] variable */ = tmp125;
  TRACE_POP
}
/*
equation index: 4231
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[13] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[13] * particleReceiver1D_v11.vp[13] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4231(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4231};
  modelica_boolean tmp126;
  RELATIONHYSTERESIS(tmp126, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[988] /* particleReceiver1D_v11.phi[13] variable */ = (tmp126?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1110] /* particleReceiver1D_v11.t_c[13] variable */)) * (data->localData[0]->realVars[1152] /* particleReceiver1D_v11.vp[13] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[13] * particleReceiver1D_v11.vp[13] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4232
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[14] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[13] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[14] - particleReceiver1D_v11.x[13])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4232(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4232};
  modelica_boolean tmp127;
  modelica_real tmp128;
  modelica_real tmp129;
  modelica_boolean tmp130;
  modelica_real tmp131;
  RELATIONHYSTERESIS(tmp127, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp130 = (modelica_boolean)tmp127;
  if(tmp130)
  {
    tmp128 = data->localData[0]->realVars[1152] /* particleReceiver1D_v11.vp[13] variable */;
    tmp129 = (tmp128 * tmp128) + (19.6133) * (data->localData[0]->realVars[1174] /* particleReceiver1D_v11.x[14] variable */ - data->localData[0]->realVars[1173] /* particleReceiver1D_v11.x[13] variable */);
    if(!(tmp129 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[13] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[14] - particleReceiver1D_v11.x[13])) was %g should be >= 0", tmp129);
    }
    tmp131 = sqrt(tmp129);
  }
  else
  {
    tmp131 = 0.0;
  }
  data->localData[0]->realVars[1153] /* particleReceiver1D_v11.vp[14] variable */ = tmp131;
  TRACE_POP
}
/*
equation index: 4233
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[14] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[14] * particleReceiver1D_v11.vp[14] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4233(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4233};
  modelica_boolean tmp132;
  RELATIONHYSTERESIS(tmp132, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[989] /* particleReceiver1D_v11.phi[14] variable */ = (tmp132?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1111] /* particleReceiver1D_v11.t_c[14] variable */)) * (data->localData[0]->realVars[1153] /* particleReceiver1D_v11.vp[14] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[14] * particleReceiver1D_v11.vp[14] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4234
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[15] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[14] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[15] - particleReceiver1D_v11.x[14])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4234(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4234};
  modelica_boolean tmp133;
  modelica_real tmp134;
  modelica_real tmp135;
  modelica_boolean tmp136;
  modelica_real tmp137;
  RELATIONHYSTERESIS(tmp133, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp136 = (modelica_boolean)tmp133;
  if(tmp136)
  {
    tmp134 = data->localData[0]->realVars[1153] /* particleReceiver1D_v11.vp[14] variable */;
    tmp135 = (tmp134 * tmp134) + (19.6133) * (data->localData[0]->realVars[1175] /* particleReceiver1D_v11.x[15] variable */ - data->localData[0]->realVars[1174] /* particleReceiver1D_v11.x[14] variable */);
    if(!(tmp135 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[14] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[15] - particleReceiver1D_v11.x[14])) was %g should be >= 0", tmp135);
    }
    tmp137 = sqrt(tmp135);
  }
  else
  {
    tmp137 = 0.0;
  }
  data->localData[0]->realVars[1154] /* particleReceiver1D_v11.vp[15] variable */ = tmp137;
  TRACE_POP
}
/*
equation index: 4235
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[15] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[15] * particleReceiver1D_v11.vp[15] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4235(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4235};
  modelica_boolean tmp138;
  RELATIONHYSTERESIS(tmp138, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[990] /* particleReceiver1D_v11.phi[15] variable */ = (tmp138?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1112] /* particleReceiver1D_v11.t_c[15] variable */)) * (data->localData[0]->realVars[1154] /* particleReceiver1D_v11.vp[15] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[15] * particleReceiver1D_v11.vp[15] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4236
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[16] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[15] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[16] - particleReceiver1D_v11.x[15])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4236(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4236};
  modelica_boolean tmp139;
  modelica_real tmp140;
  modelica_real tmp141;
  modelica_boolean tmp142;
  modelica_real tmp143;
  RELATIONHYSTERESIS(tmp139, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp142 = (modelica_boolean)tmp139;
  if(tmp142)
  {
    tmp140 = data->localData[0]->realVars[1154] /* particleReceiver1D_v11.vp[15] variable */;
    tmp141 = (tmp140 * tmp140) + (19.6133) * (data->localData[0]->realVars[1176] /* particleReceiver1D_v11.x[16] variable */ - data->localData[0]->realVars[1175] /* particleReceiver1D_v11.x[15] variable */);
    if(!(tmp141 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[15] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[16] - particleReceiver1D_v11.x[15])) was %g should be >= 0", tmp141);
    }
    tmp143 = sqrt(tmp141);
  }
  else
  {
    tmp143 = 0.0;
  }
  data->localData[0]->realVars[1155] /* particleReceiver1D_v11.vp[16] variable */ = tmp143;
  TRACE_POP
}
/*
equation index: 4237
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[16] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[16] * particleReceiver1D_v11.vp[16] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4237(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4237};
  modelica_boolean tmp144;
  RELATIONHYSTERESIS(tmp144, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[991] /* particleReceiver1D_v11.phi[16] variable */ = (tmp144?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1113] /* particleReceiver1D_v11.t_c[16] variable */)) * (data->localData[0]->realVars[1155] /* particleReceiver1D_v11.vp[16] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[16] * particleReceiver1D_v11.vp[16] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4238
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[17] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[16] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[17] - particleReceiver1D_v11.x[16])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4238(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4238};
  modelica_boolean tmp145;
  modelica_real tmp146;
  modelica_real tmp147;
  modelica_boolean tmp148;
  modelica_real tmp149;
  RELATIONHYSTERESIS(tmp145, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp148 = (modelica_boolean)tmp145;
  if(tmp148)
  {
    tmp146 = data->localData[0]->realVars[1155] /* particleReceiver1D_v11.vp[16] variable */;
    tmp147 = (tmp146 * tmp146) + (19.6133) * (data->localData[0]->realVars[1177] /* particleReceiver1D_v11.x[17] variable */ - data->localData[0]->realVars[1176] /* particleReceiver1D_v11.x[16] variable */);
    if(!(tmp147 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[16] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[17] - particleReceiver1D_v11.x[16])) was %g should be >= 0", tmp147);
    }
    tmp149 = sqrt(tmp147);
  }
  else
  {
    tmp149 = 0.0;
  }
  data->localData[0]->realVars[1156] /* particleReceiver1D_v11.vp[17] variable */ = tmp149;
  TRACE_POP
}
/*
equation index: 4239
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[17] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[17] * particleReceiver1D_v11.vp[17] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4239(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4239};
  modelica_boolean tmp150;
  RELATIONHYSTERESIS(tmp150, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[992] /* particleReceiver1D_v11.phi[17] variable */ = (tmp150?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1114] /* particleReceiver1D_v11.t_c[17] variable */)) * (data->localData[0]->realVars[1156] /* particleReceiver1D_v11.vp[17] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[17] * particleReceiver1D_v11.vp[17] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4240
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[18] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[17] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[18] - particleReceiver1D_v11.x[17])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4240(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4240};
  modelica_boolean tmp151;
  modelica_real tmp152;
  modelica_real tmp153;
  modelica_boolean tmp154;
  modelica_real tmp155;
  RELATIONHYSTERESIS(tmp151, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp154 = (modelica_boolean)tmp151;
  if(tmp154)
  {
    tmp152 = data->localData[0]->realVars[1156] /* particleReceiver1D_v11.vp[17] variable */;
    tmp153 = (tmp152 * tmp152) + (19.6133) * (data->localData[0]->realVars[1178] /* particleReceiver1D_v11.x[18] variable */ - data->localData[0]->realVars[1177] /* particleReceiver1D_v11.x[17] variable */);
    if(!(tmp153 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[17] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[18] - particleReceiver1D_v11.x[17])) was %g should be >= 0", tmp153);
    }
    tmp155 = sqrt(tmp153);
  }
  else
  {
    tmp155 = 0.0;
  }
  data->localData[0]->realVars[1157] /* particleReceiver1D_v11.vp[18] variable */ = tmp155;
  TRACE_POP
}
/*
equation index: 4241
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[18] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[18] * particleReceiver1D_v11.vp[18] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4241(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4241};
  modelica_boolean tmp156;
  RELATIONHYSTERESIS(tmp156, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[993] /* particleReceiver1D_v11.phi[18] variable */ = (tmp156?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1115] /* particleReceiver1D_v11.t_c[18] variable */)) * (data->localData[0]->realVars[1157] /* particleReceiver1D_v11.vp[18] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[18] * particleReceiver1D_v11.vp[18] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4242
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[19] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[18] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[19] - particleReceiver1D_v11.x[18])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4242(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4242};
  modelica_boolean tmp157;
  modelica_real tmp158;
  modelica_real tmp159;
  modelica_boolean tmp160;
  modelica_real tmp161;
  RELATIONHYSTERESIS(tmp157, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp160 = (modelica_boolean)tmp157;
  if(tmp160)
  {
    tmp158 = data->localData[0]->realVars[1157] /* particleReceiver1D_v11.vp[18] variable */;
    tmp159 = (tmp158 * tmp158) + (19.6133) * (data->localData[0]->realVars[1179] /* particleReceiver1D_v11.x[19] variable */ - data->localData[0]->realVars[1178] /* particleReceiver1D_v11.x[18] variable */);
    if(!(tmp159 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[18] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[19] - particleReceiver1D_v11.x[18])) was %g should be >= 0", tmp159);
    }
    tmp161 = sqrt(tmp159);
  }
  else
  {
    tmp161 = 0.0;
  }
  data->localData[0]->realVars[1158] /* particleReceiver1D_v11.vp[19] variable */ = tmp161;
  TRACE_POP
}
/*
equation index: 4243
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[19] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[19] * particleReceiver1D_v11.vp[19] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4243(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4243};
  modelica_boolean tmp162;
  RELATIONHYSTERESIS(tmp162, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[994] /* particleReceiver1D_v11.phi[19] variable */ = (tmp162?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1116] /* particleReceiver1D_v11.t_c[19] variable */)) * (data->localData[0]->realVars[1158] /* particleReceiver1D_v11.vp[19] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[19] * particleReceiver1D_v11.vp[19] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4244
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[20] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[19] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[20] - particleReceiver1D_v11.x[19])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4244(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4244};
  modelica_boolean tmp163;
  modelica_real tmp164;
  modelica_real tmp165;
  modelica_boolean tmp166;
  modelica_real tmp167;
  RELATIONHYSTERESIS(tmp163, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp166 = (modelica_boolean)tmp163;
  if(tmp166)
  {
    tmp164 = data->localData[0]->realVars[1158] /* particleReceiver1D_v11.vp[19] variable */;
    tmp165 = (tmp164 * tmp164) + (19.6133) * (data->localData[0]->realVars[1180] /* particleReceiver1D_v11.x[20] variable */ - data->localData[0]->realVars[1179] /* particleReceiver1D_v11.x[19] variable */);
    if(!(tmp165 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[19] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[20] - particleReceiver1D_v11.x[19])) was %g should be >= 0", tmp165);
    }
    tmp167 = sqrt(tmp165);
  }
  else
  {
    tmp167 = 0.0;
  }
  data->localData[0]->realVars[1159] /* particleReceiver1D_v11.vp[20] variable */ = tmp167;
  TRACE_POP
}
/*
equation index: 4245
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[20] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[20] * particleReceiver1D_v11.vp[20] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4245(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4245};
  modelica_boolean tmp168;
  RELATIONHYSTERESIS(tmp168, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[995] /* particleReceiver1D_v11.phi[20] variable */ = (tmp168?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1117] /* particleReceiver1D_v11.t_c[20] variable */)) * (data->localData[0]->realVars[1159] /* particleReceiver1D_v11.vp[20] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[20] * particleReceiver1D_v11.vp[20] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4246
type: SIMPLE_ASSIGN
particleReceiver1D_v11.vp[21] = if particleReceiver1D_v11.mdot > 1e-06 then (particleReceiver1D_v11.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[21] - particleReceiver1D_v11.x[20])) ^ 0.5 else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4246(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4246};
  modelica_boolean tmp169;
  modelica_real tmp170;
  modelica_real tmp171;
  modelica_boolean tmp172;
  modelica_real tmp173;
  RELATIONHYSTERESIS(tmp169, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  tmp172 = (modelica_boolean)tmp169;
  if(tmp172)
  {
    tmp170 = data->localData[0]->realVars[1159] /* particleReceiver1D_v11.vp[20] variable */;
    tmp171 = (tmp170 * tmp170) + (19.6133) * (data->localData[0]->realVars[1181] /* particleReceiver1D_v11.x[21] variable */ - data->localData[0]->realVars[1180] /* particleReceiver1D_v11.x[20] variable */);
    if(!(tmp171 >= 0.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert_warning(info, "The following assertion has been violated %sat time %f", initial() ? "during initialization " : "", data->localData[0]->timeValue);
      throwStreamPrintWithEquationIndexes(threadData, equationIndexes, "Model error: Argument of sqrt(particleReceiver1D_v11.vp[20] ^ 2.0 + 19.6133 * (particleReceiver1D_v11.x[21] - particleReceiver1D_v11.x[20])) was %g should be >= 0", tmp171);
    }
    tmp173 = sqrt(tmp171);
  }
  else
  {
    tmp173 = 0.0;
  }
  data->localData[0]->realVars[1160] /* particleReceiver1D_v11.vp[21] variable */ = tmp173;
  TRACE_POP
}
/*
equation index: 4247
type: SIMPLE_ASSIGN
particleReceiver1D_v11.phi[21] = if particleReceiver1D_v11.mdot > 1e-06 then particleReceiver1D_v11.mdot / (particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[21] * particleReceiver1D_v11.vp[21] * particleReceiver1D_v11.rho_s) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4247(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4247};
  modelica_boolean tmp174;
  RELATIONHYSTERESIS(tmp174, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 20, Greater);
  data->localData[0]->realVars[996] /* particleReceiver1D_v11.phi[21] variable */ = (tmp174?DIVISION_SIM(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */,(((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->localData[0]->realVars[1118] /* particleReceiver1D_v11.t_c[21] variable */)) * (data->localData[0]->realVars[1160] /* particleReceiver1D_v11.vp[21] variable */)) * (data->simulationInfo->realParameter[343] /* particleReceiver1D_v11.rho_s PARAM */),"particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.t_c[21] * particleReceiver1D_v11.vp[21] * particleReceiver1D_v11.rho_s",equationIndexes):0.0);
  TRACE_POP
}
/*
equation index: 4248
type: ALGORITHM

  particleReceiver1D_v11.reflectivity_c[20] := $START.particleReceiver1D_v11.reflectivity_c[20];
  particleReceiver1D_v11.reflectivity_c[19] := $START.particleReceiver1D_v11.reflectivity_c[19];
  particleReceiver1D_v11.reflectivity_c[18] := $START.particleReceiver1D_v11.reflectivity_c[18];
  particleReceiver1D_v11.reflectivity_c[17] := $START.particleReceiver1D_v11.reflectivity_c[17];
  particleReceiver1D_v11.reflectivity_c[16] := $START.particleReceiver1D_v11.reflectivity_c[16];
  particleReceiver1D_v11.reflectivity_c[15] := $START.particleReceiver1D_v11.reflectivity_c[15];
  particleReceiver1D_v11.reflectivity_c[14] := $START.particleReceiver1D_v11.reflectivity_c[14];
  particleReceiver1D_v11.reflectivity_c[13] := $START.particleReceiver1D_v11.reflectivity_c[13];
  particleReceiver1D_v11.reflectivity_c[12] := $START.particleReceiver1D_v11.reflectivity_c[12];
  particleReceiver1D_v11.reflectivity_c[11] := $START.particleReceiver1D_v11.reflectivity_c[11];
  particleReceiver1D_v11.reflectivity_c[10] := $START.particleReceiver1D_v11.reflectivity_c[10];
  particleReceiver1D_v11.reflectivity_c[9] := $START.particleReceiver1D_v11.reflectivity_c[9];
  particleReceiver1D_v11.reflectivity_c[8] := $START.particleReceiver1D_v11.reflectivity_c[8];
  particleReceiver1D_v11.reflectivity_c[7] := $START.particleReceiver1D_v11.reflectivity_c[7];
  particleReceiver1D_v11.reflectivity_c[6] := $START.particleReceiver1D_v11.reflectivity_c[6];
  particleReceiver1D_v11.reflectivity_c[5] := $START.particleReceiver1D_v11.reflectivity_c[5];
  particleReceiver1D_v11.reflectivity_c[4] := $START.particleReceiver1D_v11.reflectivity_c[4];
  particleReceiver1D_v11.reflectivity_c[3] := $START.particleReceiver1D_v11.reflectivity_c[3];
  particleReceiver1D_v11.reflectivity_c[2] := $START.particleReceiver1D_v11.reflectivity_c[2];
  particleReceiver1D_v11.reflectivity_c[1] := $START.particleReceiver1D_v11.reflectivity_c[1];
  particleReceiver1D_v11.tau_c[20] := $START.particleReceiver1D_v11.tau_c[20];
  particleReceiver1D_v11.tau_c[19] := $START.particleReceiver1D_v11.tau_c[19];
  particleReceiver1D_v11.tau_c[18] := $START.particleReceiver1D_v11.tau_c[18];
  particleReceiver1D_v11.tau_c[17] := $START.particleReceiver1D_v11.tau_c[17];
  particleReceiver1D_v11.tau_c[16] := $START.particleReceiver1D_v11.tau_c[16];
  particleReceiver1D_v11.tau_c[15] := $START.particleReceiver1D_v11.tau_c[15];
  particleReceiver1D_v11.tau_c[14] := $START.particleReceiver1D_v11.tau_c[14];
  particleReceiver1D_v11.tau_c[13] := $START.particleReceiver1D_v11.tau_c[13];
  particleReceiver1D_v11.tau_c[12] := $START.particleReceiver1D_v11.tau_c[12];
  particleReceiver1D_v11.tau_c[11] := $START.particleReceiver1D_v11.tau_c[11];
  particleReceiver1D_v11.tau_c[10] := $START.particleReceiver1D_v11.tau_c[10];
  particleReceiver1D_v11.tau_c[9] := $START.particleReceiver1D_v11.tau_c[9];
  particleReceiver1D_v11.tau_c[8] := $START.particleReceiver1D_v11.tau_c[8];
  particleReceiver1D_v11.tau_c[7] := $START.particleReceiver1D_v11.tau_c[7];
  particleReceiver1D_v11.tau_c[6] := $START.particleReceiver1D_v11.tau_c[6];
  particleReceiver1D_v11.tau_c[5] := $START.particleReceiver1D_v11.tau_c[5];
  particleReceiver1D_v11.tau_c[4] := $START.particleReceiver1D_v11.tau_c[4];
  particleReceiver1D_v11.tau_c[3] := $START.particleReceiver1D_v11.tau_c[3];
  particleReceiver1D_v11.tau_c[2] := $START.particleReceiver1D_v11.tau_c[2];
  particleReceiver1D_v11.tau_c[1] := $START.particleReceiver1D_v11.tau_c[1];
  particleReceiver1D_v11.abs_c[20] := $START.particleReceiver1D_v11.abs_c[20];
  particleReceiver1D_v11.abs_c[19] := $START.particleReceiver1D_v11.abs_c[19];
  particleReceiver1D_v11.abs_c[18] := $START.particleReceiver1D_v11.abs_c[18];
  particleReceiver1D_v11.abs_c[17] := $START.particleReceiver1D_v11.abs_c[17];
  particleReceiver1D_v11.abs_c[16] := $START.particleReceiver1D_v11.abs_c[16];
  particleReceiver1D_v11.abs_c[15] := $START.particleReceiver1D_v11.abs_c[15];
  particleReceiver1D_v11.abs_c[14] := $START.particleReceiver1D_v11.abs_c[14];
  particleReceiver1D_v11.abs_c[13] := $START.particleReceiver1D_v11.abs_c[13];
  particleReceiver1D_v11.abs_c[12] := $START.particleReceiver1D_v11.abs_c[12];
  particleReceiver1D_v11.abs_c[11] := $START.particleReceiver1D_v11.abs_c[11];
  particleReceiver1D_v11.abs_c[10] := $START.particleReceiver1D_v11.abs_c[10];
  particleReceiver1D_v11.abs_c[9] := $START.particleReceiver1D_v11.abs_c[9];
  particleReceiver1D_v11.abs_c[8] := $START.particleReceiver1D_v11.abs_c[8];
  particleReceiver1D_v11.abs_c[7] := $START.particleReceiver1D_v11.abs_c[7];
  particleReceiver1D_v11.abs_c[6] := $START.particleReceiver1D_v11.abs_c[6];
  particleReceiver1D_v11.abs_c[5] := $START.particleReceiver1D_v11.abs_c[5];
  particleReceiver1D_v11.abs_c[4] := $START.particleReceiver1D_v11.abs_c[4];
  particleReceiver1D_v11.abs_c[3] := $START.particleReceiver1D_v11.abs_c[3];
  particleReceiver1D_v11.abs_c[2] := $START.particleReceiver1D_v11.abs_c[2];
  particleReceiver1D_v11.abs_c[1] := $START.particleReceiver1D_v11.abs_c[1];
  particleReceiver1D_v11.eps_c[20] := $START.particleReceiver1D_v11.eps_c[20];
  particleReceiver1D_v11.eps_c[19] := $START.particleReceiver1D_v11.eps_c[19];
  particleReceiver1D_v11.eps_c[18] := $START.particleReceiver1D_v11.eps_c[18];
  particleReceiver1D_v11.eps_c[17] := $START.particleReceiver1D_v11.eps_c[17];
  particleReceiver1D_v11.eps_c[16] := $START.particleReceiver1D_v11.eps_c[16];
  particleReceiver1D_v11.eps_c[15] := $START.particleReceiver1D_v11.eps_c[15];
  particleReceiver1D_v11.eps_c[14] := $START.particleReceiver1D_v11.eps_c[14];
  particleReceiver1D_v11.eps_c[13] := $START.particleReceiver1D_v11.eps_c[13];
  particleReceiver1D_v11.eps_c[12] := $START.particleReceiver1D_v11.eps_c[12];
  particleReceiver1D_v11.eps_c[11] := $START.particleReceiver1D_v11.eps_c[11];
  particleReceiver1D_v11.eps_c[10] := $START.particleReceiver1D_v11.eps_c[10];
  particleReceiver1D_v11.eps_c[9] := $START.particleReceiver1D_v11.eps_c[9];
  particleReceiver1D_v11.eps_c[8] := $START.particleReceiver1D_v11.eps_c[8];
  particleReceiver1D_v11.eps_c[7] := $START.particleReceiver1D_v11.eps_c[7];
  particleReceiver1D_v11.eps_c[6] := $START.particleReceiver1D_v11.eps_c[6];
  particleReceiver1D_v11.eps_c[5] := $START.particleReceiver1D_v11.eps_c[5];
  particleReceiver1D_v11.eps_c[4] := $START.particleReceiver1D_v11.eps_c[4];
  particleReceiver1D_v11.eps_c[3] := $START.particleReceiver1D_v11.eps_c[3];
  particleReceiver1D_v11.eps_c[2] := $START.particleReceiver1D_v11.eps_c[2];
  particleReceiver1D_v11.eps_c[1] := $START.particleReceiver1D_v11.eps_c[1];
  particleReceiver1D_v11.A2[20] := $START.particleReceiver1D_v11.A2[20];
  particleReceiver1D_v11.A2[19] := $START.particleReceiver1D_v11.A2[19];
  particleReceiver1D_v11.A2[18] := $START.particleReceiver1D_v11.A2[18];
  particleReceiver1D_v11.A2[17] := $START.particleReceiver1D_v11.A2[17];
  particleReceiver1D_v11.A2[16] := $START.particleReceiver1D_v11.A2[16];
  particleReceiver1D_v11.A2[15] := $START.particleReceiver1D_v11.A2[15];
  particleReceiver1D_v11.A2[14] := $START.particleReceiver1D_v11.A2[14];
  particleReceiver1D_v11.A2[13] := $START.particleReceiver1D_v11.A2[13];
  particleReceiver1D_v11.A2[12] := $START.particleReceiver1D_v11.A2[12];
  particleReceiver1D_v11.A2[11] := $START.particleReceiver1D_v11.A2[11];
  particleReceiver1D_v11.A2[10] := $START.particleReceiver1D_v11.A2[10];
  particleReceiver1D_v11.A2[9] := $START.particleReceiver1D_v11.A2[9];
  particleReceiver1D_v11.A2[8] := $START.particleReceiver1D_v11.A2[8];
  particleReceiver1D_v11.A2[7] := $START.particleReceiver1D_v11.A2[7];
  particleReceiver1D_v11.A2[6] := $START.particleReceiver1D_v11.A2[6];
  particleReceiver1D_v11.A2[5] := $START.particleReceiver1D_v11.A2[5];
  particleReceiver1D_v11.A2[4] := $START.particleReceiver1D_v11.A2[4];
  particleReceiver1D_v11.A2[3] := $START.particleReceiver1D_v11.A2[3];
  particleReceiver1D_v11.A2[2] := $START.particleReceiver1D_v11.A2[2];
  particleReceiver1D_v11.A2[1] := $START.particleReceiver1D_v11.A2[1];
  particleReceiver1D_v11.B[20] := $START.particleReceiver1D_v11.B[20];
  particleReceiver1D_v11.B[19] := $START.particleReceiver1D_v11.B[19];
  particleReceiver1D_v11.B[18] := $START.particleReceiver1D_v11.B[18];
  particleReceiver1D_v11.B[17] := $START.particleReceiver1D_v11.B[17];
  particleReceiver1D_v11.B[16] := $START.particleReceiver1D_v11.B[16];
  particleReceiver1D_v11.B[15] := $START.particleReceiver1D_v11.B[15];
  particleReceiver1D_v11.B[14] := $START.particleReceiver1D_v11.B[14];
  particleReceiver1D_v11.B[13] := $START.particleReceiver1D_v11.B[13];
  particleReceiver1D_v11.B[12] := $START.particleReceiver1D_v11.B[12];
  particleReceiver1D_v11.B[11] := $START.particleReceiver1D_v11.B[11];
  particleReceiver1D_v11.B[10] := $START.particleReceiver1D_v11.B[10];
  particleReceiver1D_v11.B[9] := $START.particleReceiver1D_v11.B[9];
  particleReceiver1D_v11.B[8] := $START.particleReceiver1D_v11.B[8];
  particleReceiver1D_v11.B[7] := $START.particleReceiver1D_v11.B[7];
  particleReceiver1D_v11.B[6] := $START.particleReceiver1D_v11.B[6];
  particleReceiver1D_v11.B[5] := $START.particleReceiver1D_v11.B[5];
  particleReceiver1D_v11.B[4] := $START.particleReceiver1D_v11.B[4];
  particleReceiver1D_v11.B[3] := $START.particleReceiver1D_v11.B[3];
  particleReceiver1D_v11.B[2] := $START.particleReceiver1D_v11.B[2];
  particleReceiver1D_v11.B[1] := $START.particleReceiver1D_v11.B[1];
  particleReceiver1D_v11.A[20] := $START.particleReceiver1D_v11.A[20];
  particleReceiver1D_v11.A[19] := $START.particleReceiver1D_v11.A[19];
  particleReceiver1D_v11.A[18] := $START.particleReceiver1D_v11.A[18];
  particleReceiver1D_v11.A[17] := $START.particleReceiver1D_v11.A[17];
  particleReceiver1D_v11.A[16] := $START.particleReceiver1D_v11.A[16];
  particleReceiver1D_v11.A[15] := $START.particleReceiver1D_v11.A[15];
  particleReceiver1D_v11.A[14] := $START.particleReceiver1D_v11.A[14];
  particleReceiver1D_v11.A[13] := $START.particleReceiver1D_v11.A[13];
  particleReceiver1D_v11.A[12] := $START.particleReceiver1D_v11.A[12];
  particleReceiver1D_v11.A[11] := $START.particleReceiver1D_v11.A[11];
  particleReceiver1D_v11.A[10] := $START.particleReceiver1D_v11.A[10];
  particleReceiver1D_v11.A[9] := $START.particleReceiver1D_v11.A[9];
  particleReceiver1D_v11.A[8] := $START.particleReceiver1D_v11.A[8];
  particleReceiver1D_v11.A[7] := $START.particleReceiver1D_v11.A[7];
  particleReceiver1D_v11.A[6] := $START.particleReceiver1D_v11.A[6];
  particleReceiver1D_v11.A[5] := $START.particleReceiver1D_v11.A[5];
  particleReceiver1D_v11.A[4] := $START.particleReceiver1D_v11.A[4];
  particleReceiver1D_v11.A[3] := $START.particleReceiver1D_v11.A[3];
  particleReceiver1D_v11.A[2] := $START.particleReceiver1D_v11.A[2];
  particleReceiver1D_v11.A[1] := $START.particleReceiver1D_v11.A[1];
  particleReceiver1D_v11.N_layers[20] := $START.particleReceiver1D_v11.N_layers[20];
  particleReceiver1D_v11.N_layers[19] := $START.particleReceiver1D_v11.N_layers[19];
  particleReceiver1D_v11.N_layers[18] := $START.particleReceiver1D_v11.N_layers[18];
  particleReceiver1D_v11.N_layers[17] := $START.particleReceiver1D_v11.N_layers[17];
  particleReceiver1D_v11.N_layers[16] := $START.particleReceiver1D_v11.N_layers[16];
  particleReceiver1D_v11.N_layers[15] := $START.particleReceiver1D_v11.N_layers[15];
  particleReceiver1D_v11.N_layers[14] := $START.particleReceiver1D_v11.N_layers[14];
  particleReceiver1D_v11.N_layers[13] := $START.particleReceiver1D_v11.N_layers[13];
  particleReceiver1D_v11.N_layers[12] := $START.particleReceiver1D_v11.N_layers[12];
  particleReceiver1D_v11.N_layers[11] := $START.particleReceiver1D_v11.N_layers[11];
  particleReceiver1D_v11.N_layers[10] := $START.particleReceiver1D_v11.N_layers[10];
  particleReceiver1D_v11.N_layers[9] := $START.particleReceiver1D_v11.N_layers[9];
  particleReceiver1D_v11.N_layers[8] := $START.particleReceiver1D_v11.N_layers[8];
  particleReceiver1D_v11.N_layers[7] := $START.particleReceiver1D_v11.N_layers[7];
  particleReceiver1D_v11.N_layers[6] := $START.particleReceiver1D_v11.N_layers[6];
  particleReceiver1D_v11.N_layers[5] := $START.particleReceiver1D_v11.N_layers[5];
  particleReceiver1D_v11.N_layers[4] := $START.particleReceiver1D_v11.N_layers[4];
  particleReceiver1D_v11.N_layers[3] := $START.particleReceiver1D_v11.N_layers[3];
  particleReceiver1D_v11.N_layers[2] := $START.particleReceiver1D_v11.N_layers[2];
  particleReceiver1D_v11.N_layers[1] := $START.particleReceiver1D_v11.N_layers[1];
  particleReceiver1D_v11.phi_area[20] := $START.particleReceiver1D_v11.phi_area[20];
  particleReceiver1D_v11.phi_area[19] := $START.particleReceiver1D_v11.phi_area[19];
  particleReceiver1D_v11.phi_area[18] := $START.particleReceiver1D_v11.phi_area[18];
  particleReceiver1D_v11.phi_area[17] := $START.particleReceiver1D_v11.phi_area[17];
  particleReceiver1D_v11.phi_area[16] := $START.particleReceiver1D_v11.phi_area[16];
  particleReceiver1D_v11.phi_area[15] := $START.particleReceiver1D_v11.phi_area[15];
  particleReceiver1D_v11.phi_area[14] := $START.particleReceiver1D_v11.phi_area[14];
  particleReceiver1D_v11.phi_area[13] := $START.particleReceiver1D_v11.phi_area[13];
  particleReceiver1D_v11.phi_area[12] := $START.particleReceiver1D_v11.phi_area[12];
  particleReceiver1D_v11.phi_area[11] := $START.particleReceiver1D_v11.phi_area[11];
  particleReceiver1D_v11.phi_area[10] := $START.particleReceiver1D_v11.phi_area[10];
  particleReceiver1D_v11.phi_area[9] := $START.particleReceiver1D_v11.phi_area[9];
  particleReceiver1D_v11.phi_area[8] := $START.particleReceiver1D_v11.phi_area[8];
  particleReceiver1D_v11.phi_area[7] := $START.particleReceiver1D_v11.phi_area[7];
  particleReceiver1D_v11.phi_area[6] := $START.particleReceiver1D_v11.phi_area[6];
  particleReceiver1D_v11.phi_area[5] := $START.particleReceiver1D_v11.phi_area[5];
  particleReceiver1D_v11.phi_area[4] := $START.particleReceiver1D_v11.phi_area[4];
  particleReceiver1D_v11.phi_area[3] := $START.particleReceiver1D_v11.phi_area[3];
  particleReceiver1D_v11.phi_area[2] := $START.particleReceiver1D_v11.phi_area[2];
  particleReceiver1D_v11.phi_area[1] := $START.particleReceiver1D_v11.phi_area[1];
  particleReceiver1D_v11.L[20] := $START.particleReceiver1D_v11.L[20];
  particleReceiver1D_v11.L[19] := $START.particleReceiver1D_v11.L[19];
  particleReceiver1D_v11.L[18] := $START.particleReceiver1D_v11.L[18];
  particleReceiver1D_v11.L[17] := $START.particleReceiver1D_v11.L[17];
  particleReceiver1D_v11.L[16] := $START.particleReceiver1D_v11.L[16];
  particleReceiver1D_v11.L[15] := $START.particleReceiver1D_v11.L[15];
  particleReceiver1D_v11.L[14] := $START.particleReceiver1D_v11.L[14];
  particleReceiver1D_v11.L[13] := $START.particleReceiver1D_v11.L[13];
  particleReceiver1D_v11.L[12] := $START.particleReceiver1D_v11.L[12];
  particleReceiver1D_v11.L[11] := $START.particleReceiver1D_v11.L[11];
  particleReceiver1D_v11.L[10] := $START.particleReceiver1D_v11.L[10];
  particleReceiver1D_v11.L[9] := $START.particleReceiver1D_v11.L[9];
  particleReceiver1D_v11.L[8] := $START.particleReceiver1D_v11.L[8];
  particleReceiver1D_v11.L[7] := $START.particleReceiver1D_v11.L[7];
  particleReceiver1D_v11.L[6] := $START.particleReceiver1D_v11.L[6];
  particleReceiver1D_v11.L[5] := $START.particleReceiver1D_v11.L[5];
  particleReceiver1D_v11.L[4] := $START.particleReceiver1D_v11.L[4];
  particleReceiver1D_v11.L[3] := $START.particleReceiver1D_v11.L[3];
  particleReceiver1D_v11.L[2] := $START.particleReceiver1D_v11.L[2];
  particleReceiver1D_v11.L[1] := $START.particleReceiver1D_v11.L[1];
  particleReceiver1D_v11.C[20] := $START.particleReceiver1D_v11.C[20];
  particleReceiver1D_v11.C[19] := $START.particleReceiver1D_v11.C[19];
  particleReceiver1D_v11.C[18] := $START.particleReceiver1D_v11.C[18];
  particleReceiver1D_v11.C[17] := $START.particleReceiver1D_v11.C[17];
  particleReceiver1D_v11.C[16] := $START.particleReceiver1D_v11.C[16];
  particleReceiver1D_v11.C[15] := $START.particleReceiver1D_v11.C[15];
  particleReceiver1D_v11.C[14] := $START.particleReceiver1D_v11.C[14];
  particleReceiver1D_v11.C[13] := $START.particleReceiver1D_v11.C[13];
  particleReceiver1D_v11.C[12] := $START.particleReceiver1D_v11.C[12];
  particleReceiver1D_v11.C[11] := $START.particleReceiver1D_v11.C[11];
  particleReceiver1D_v11.C[10] := $START.particleReceiver1D_v11.C[10];
  particleReceiver1D_v11.C[9] := $START.particleReceiver1D_v11.C[9];
  particleReceiver1D_v11.C[8] := $START.particleReceiver1D_v11.C[8];
  particleReceiver1D_v11.C[7] := $START.particleReceiver1D_v11.C[7];
  particleReceiver1D_v11.C[6] := $START.particleReceiver1D_v11.C[6];
  particleReceiver1D_v11.C[5] := $START.particleReceiver1D_v11.C[5];
  particleReceiver1D_v11.C[4] := $START.particleReceiver1D_v11.C[4];
  particleReceiver1D_v11.C[3] := $START.particleReceiver1D_v11.C[3];
  particleReceiver1D_v11.C[2] := $START.particleReceiver1D_v11.C[2];
  particleReceiver1D_v11.C[1] := $START.particleReceiver1D_v11.C[1];
  for i in 1:20 loop
    if particleReceiver1D_v11.with_uniform_curtain_props then
      particleReceiver1D_v11.C[i] := 0.0;
      particleReceiver1D_v11.L[i] := 0.0;
      particleReceiver1D_v11.phi_area[i] := 0.0;
      particleReceiver1D_v11.N_layers[i] := 0.0;
      particleReceiver1D_v11.A[i] := 0.0;
      particleReceiver1D_v11.B[i] := 0.0;
      particleReceiver1D_v11.A2[i] := 0.0;
      particleReceiver1D_v11.eps_c[i] := particleReceiver1D_v11.eps_s;
      particleReceiver1D_v11.abs_c[i] := particleReceiver1D_v11.abs_s;
      particleReceiver1D_v11.tau_c[i] := 0.4;
      particleReceiver1D_v11.reflectivity_c[i] := 1.0 - (particleReceiver1D_v11.abs_c[i] + particleReceiver1D_v11.tau_c[i]);
    else
      if particleReceiver1D_v11.mdot < 1e-06 then
        particleReceiver1D_v11.C[i] := 0.0;
        particleReceiver1D_v11.L[i] := 0.0;
        particleReceiver1D_v11.phi_area[i] := 0.0;
        particleReceiver1D_v11.N_layers[i] := 0.0;
        particleReceiver1D_v11.A[i] := 0.0;
        particleReceiver1D_v11.B[i] := 0.0;
        particleReceiver1D_v11.A2[i] := 0.0;
        particleReceiver1D_v11.eps_c[i] := 0.0;
        particleReceiver1D_v11.abs_c[i] := 0.0;
        particleReceiver1D_v11.tau_c[i] := 0.0;
        particleReceiver1D_v11.reflectivity_c[i] := 0.0;
      else
        particleReceiver1D_v11.C[i] := 6.0 * particleReceiver1D_v11.phi[i] / (3.141592653589793 * particleReceiver1D_v11.d_p ^ 3.0);
        particleReceiver1D_v11.L[i] := 0.8059959770082348 * particleReceiver1D_v11.d_p * (1.0 / particleReceiver1D_v11.phi[i]) ^ 0.3333333333333333;
        particleReceiver1D_v11.phi_area[i] := 0.7853981633974483 * (particleReceiver1D_v11.d_p / particleReceiver1D_v11.L[i]) ^ 2.0;
        particleReceiver1D_v11.N_layers[i] := particleReceiver1D_v11.t_c[i] / particleReceiver1D_v11.L[i];
        particleReceiver1D_v11.A[i] := particleReceiver1D_v11.prob_center * (1.0 - particleReceiver1D_v11.abs_s) * particleReceiver1D_v11.phi_area[i] + 2.0 * (particleReceiver1D_v11.prob_side * (1.0 - particleReceiver1D_v11.abs_s) * particleReceiver1D_v11.phi_area[i]) ^ 2.0 / (particleReceiver1D_v11.phi_area[i] * particleReceiver1D_v11.abs_s);
        particleReceiver1D_v11.B[i] := min((1.0 - particleReceiver1D_v11.phi_area[i]) ^ 2.0, 0.99999);
        particleReceiver1D_v11.A2[i] := particleReceiver1D_v11.prob_center * (1.0 - particleReceiver1D_v11.eps_s) * particleReceiver1D_v11.phi_area[i] + 2.0 * (particleReceiver1D_v11.prob_side * (1.0 - particleReceiver1D_v11.eps_s) * particleReceiver1D_v11.phi_area[i]) ^ 2.0 / (particleReceiver1D_v11.phi_area[i] * particleReceiver1D_v11.eps_s);
        particleReceiver1D_v11.eps_c[i] := particleReceiver1D_v11.eps_s;
        particleReceiver1D_v11.abs_c[i] := 1.0 - particleReceiver1D_v11.A[i] * (1.0 - particleReceiver1D_v11.B[i] ^ particleReceiver1D_v11.N_layers[i]) / (1.0 - (particleReceiver1D_v11.B[i] + particleReceiver1D_v11.tau_c[i]));
        particleReceiver1D_v11.tau_c[i] := max((1.0 - particleReceiver1D_v11.phi_area[i]) ^ particleReceiver1D_v11.N_layers[i], 1e-30);
        particleReceiver1D_v11.reflectivity_c[i] := 1.0 - (particleReceiver1D_v11.abs_c[i] + particleReceiver1D_v11.tau_c[i]);
      end if;
    end if;
  end for;
*/
void PhysicalParticleCO21D_v11_eqFunction_4248(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4248};
  modelica_boolean tmp175;
  modelica_real tmp176;
  modelica_real tmp177;
  modelica_real tmp178;
  modelica_real tmp179;
  modelica_real tmp180;
  modelica_real tmp181;
  modelica_real tmp182;
  modelica_real tmp183;
  modelica_real tmp184;
  modelica_real tmp185;
  modelica_real tmp186;
  modelica_real tmp187;
  modelica_real tmp188;
  modelica_real tmp189;
  modelica_real tmp190;
  modelica_real tmp191;
  modelica_real tmp192;
  modelica_real tmp193;
  modelica_real tmp194;
  modelica_real tmp195;
  modelica_real tmp196;
  modelica_real tmp197;
  modelica_real tmp198;
  modelica_real tmp199;
  modelica_real tmp200;
  modelica_real tmp201;
  modelica_integer tmp202;
  modelica_integer tmp203;
  modelica_integer tmp204;
  data->localData[0]->realVars[1097] /* particleReceiver1D_v11.reflectivity_c[20] variable */ = data->modelData->realVarsData[1097].attribute /* particleReceiver1D_v11.reflectivity_c[20] variable */.start;

  data->localData[0]->realVars[1096] /* particleReceiver1D_v11.reflectivity_c[19] variable */ = data->modelData->realVarsData[1096].attribute /* particleReceiver1D_v11.reflectivity_c[19] variable */.start;

  data->localData[0]->realVars[1095] /* particleReceiver1D_v11.reflectivity_c[18] variable */ = data->modelData->realVarsData[1095].attribute /* particleReceiver1D_v11.reflectivity_c[18] variable */.start;

  data->localData[0]->realVars[1094] /* particleReceiver1D_v11.reflectivity_c[17] variable */ = data->modelData->realVarsData[1094].attribute /* particleReceiver1D_v11.reflectivity_c[17] variable */.start;

  data->localData[0]->realVars[1093] /* particleReceiver1D_v11.reflectivity_c[16] variable */ = data->modelData->realVarsData[1093].attribute /* particleReceiver1D_v11.reflectivity_c[16] variable */.start;

  data->localData[0]->realVars[1092] /* particleReceiver1D_v11.reflectivity_c[15] variable */ = data->modelData->realVarsData[1092].attribute /* particleReceiver1D_v11.reflectivity_c[15] variable */.start;

  data->localData[0]->realVars[1091] /* particleReceiver1D_v11.reflectivity_c[14] variable */ = data->modelData->realVarsData[1091].attribute /* particleReceiver1D_v11.reflectivity_c[14] variable */.start;

  data->localData[0]->realVars[1090] /* particleReceiver1D_v11.reflectivity_c[13] variable */ = data->modelData->realVarsData[1090].attribute /* particleReceiver1D_v11.reflectivity_c[13] variable */.start;

  data->localData[0]->realVars[1089] /* particleReceiver1D_v11.reflectivity_c[12] variable */ = data->modelData->realVarsData[1089].attribute /* particleReceiver1D_v11.reflectivity_c[12] variable */.start;

  data->localData[0]->realVars[1088] /* particleReceiver1D_v11.reflectivity_c[11] variable */ = data->modelData->realVarsData[1088].attribute /* particleReceiver1D_v11.reflectivity_c[11] variable */.start;

  data->localData[0]->realVars[1087] /* particleReceiver1D_v11.reflectivity_c[10] variable */ = data->modelData->realVarsData[1087].attribute /* particleReceiver1D_v11.reflectivity_c[10] variable */.start;

  data->localData[0]->realVars[1086] /* particleReceiver1D_v11.reflectivity_c[9] variable */ = data->modelData->realVarsData[1086].attribute /* particleReceiver1D_v11.reflectivity_c[9] variable */.start;

  data->localData[0]->realVars[1085] /* particleReceiver1D_v11.reflectivity_c[8] variable */ = data->modelData->realVarsData[1085].attribute /* particleReceiver1D_v11.reflectivity_c[8] variable */.start;

  data->localData[0]->realVars[1084] /* particleReceiver1D_v11.reflectivity_c[7] variable */ = data->modelData->realVarsData[1084].attribute /* particleReceiver1D_v11.reflectivity_c[7] variable */.start;

  data->localData[0]->realVars[1083] /* particleReceiver1D_v11.reflectivity_c[6] variable */ = data->modelData->realVarsData[1083].attribute /* particleReceiver1D_v11.reflectivity_c[6] variable */.start;

  data->localData[0]->realVars[1082] /* particleReceiver1D_v11.reflectivity_c[5] variable */ = data->modelData->realVarsData[1082].attribute /* particleReceiver1D_v11.reflectivity_c[5] variable */.start;

  data->localData[0]->realVars[1081] /* particleReceiver1D_v11.reflectivity_c[4] variable */ = data->modelData->realVarsData[1081].attribute /* particleReceiver1D_v11.reflectivity_c[4] variable */.start;

  data->localData[0]->realVars[1080] /* particleReceiver1D_v11.reflectivity_c[3] variable */ = data->modelData->realVarsData[1080].attribute /* particleReceiver1D_v11.reflectivity_c[3] variable */.start;

  data->localData[0]->realVars[1079] /* particleReceiver1D_v11.reflectivity_c[2] variable */ = data->modelData->realVarsData[1079].attribute /* particleReceiver1D_v11.reflectivity_c[2] variable */.start;

  data->localData[0]->realVars[1078] /* particleReceiver1D_v11.reflectivity_c[1] variable */ = data->modelData->realVarsData[1078].attribute /* particleReceiver1D_v11.reflectivity_c[1] variable */.start;

  data->localData[0]->realVars[1140] /* particleReceiver1D_v11.tau_c[20] variable */ = data->modelData->realVarsData[1140].attribute /* particleReceiver1D_v11.tau_c[20] variable */.start;

  data->localData[0]->realVars[1139] /* particleReceiver1D_v11.tau_c[19] variable */ = data->modelData->realVarsData[1139].attribute /* particleReceiver1D_v11.tau_c[19] variable */.start;

  data->localData[0]->realVars[1138] /* particleReceiver1D_v11.tau_c[18] variable */ = data->modelData->realVarsData[1138].attribute /* particleReceiver1D_v11.tau_c[18] variable */.start;

  data->localData[0]->realVars[1137] /* particleReceiver1D_v11.tau_c[17] variable */ = data->modelData->realVarsData[1137].attribute /* particleReceiver1D_v11.tau_c[17] variable */.start;

  data->localData[0]->realVars[1136] /* particleReceiver1D_v11.tau_c[16] variable */ = data->modelData->realVarsData[1136].attribute /* particleReceiver1D_v11.tau_c[16] variable */.start;

  data->localData[0]->realVars[1135] /* particleReceiver1D_v11.tau_c[15] variable */ = data->modelData->realVarsData[1135].attribute /* particleReceiver1D_v11.tau_c[15] variable */.start;

  data->localData[0]->realVars[1134] /* particleReceiver1D_v11.tau_c[14] variable */ = data->modelData->realVarsData[1134].attribute /* particleReceiver1D_v11.tau_c[14] variable */.start;

  data->localData[0]->realVars[1133] /* particleReceiver1D_v11.tau_c[13] variable */ = data->modelData->realVarsData[1133].attribute /* particleReceiver1D_v11.tau_c[13] variable */.start;

  data->localData[0]->realVars[1132] /* particleReceiver1D_v11.tau_c[12] variable */ = data->modelData->realVarsData[1132].attribute /* particleReceiver1D_v11.tau_c[12] variable */.start;

  data->localData[0]->realVars[1131] /* particleReceiver1D_v11.tau_c[11] variable */ = data->modelData->realVarsData[1131].attribute /* particleReceiver1D_v11.tau_c[11] variable */.start;

  data->localData[0]->realVars[1130] /* particleReceiver1D_v11.tau_c[10] variable */ = data->modelData->realVarsData[1130].attribute /* particleReceiver1D_v11.tau_c[10] variable */.start;

  data->localData[0]->realVars[1129] /* particleReceiver1D_v11.tau_c[9] variable */ = data->modelData->realVarsData[1129].attribute /* particleReceiver1D_v11.tau_c[9] variable */.start;

  data->localData[0]->realVars[1128] /* particleReceiver1D_v11.tau_c[8] variable */ = data->modelData->realVarsData[1128].attribute /* particleReceiver1D_v11.tau_c[8] variable */.start;

  data->localData[0]->realVars[1127] /* particleReceiver1D_v11.tau_c[7] variable */ = data->modelData->realVarsData[1127].attribute /* particleReceiver1D_v11.tau_c[7] variable */.start;

  data->localData[0]->realVars[1126] /* particleReceiver1D_v11.tau_c[6] variable */ = data->modelData->realVarsData[1126].attribute /* particleReceiver1D_v11.tau_c[6] variable */.start;

  data->localData[0]->realVars[1125] /* particleReceiver1D_v11.tau_c[5] variable */ = data->modelData->realVarsData[1125].attribute /* particleReceiver1D_v11.tau_c[5] variable */.start;

  data->localData[0]->realVars[1124] /* particleReceiver1D_v11.tau_c[4] variable */ = data->modelData->realVarsData[1124].attribute /* particleReceiver1D_v11.tau_c[4] variable */.start;

  data->localData[0]->realVars[1123] /* particleReceiver1D_v11.tau_c[3] variable */ = data->modelData->realVarsData[1123].attribute /* particleReceiver1D_v11.tau_c[3] variable */.start;

  data->localData[0]->realVars[1122] /* particleReceiver1D_v11.tau_c[2] variable */ = data->modelData->realVarsData[1122].attribute /* particleReceiver1D_v11.tau_c[2] variable */.start;

  data->localData[0]->realVars[1121] /* particleReceiver1D_v11.tau_c[1] variable */ = data->modelData->realVarsData[1121].attribute /* particleReceiver1D_v11.tau_c[1] variable */.start;

  data->localData[0]->realVars[829] /* particleReceiver1D_v11.abs_c[20] variable */ = data->modelData->realVarsData[829].attribute /* particleReceiver1D_v11.abs_c[20] variable */.start;

  data->localData[0]->realVars[828] /* particleReceiver1D_v11.abs_c[19] variable */ = data->modelData->realVarsData[828].attribute /* particleReceiver1D_v11.abs_c[19] variable */.start;

  data->localData[0]->realVars[827] /* particleReceiver1D_v11.abs_c[18] variable */ = data->modelData->realVarsData[827].attribute /* particleReceiver1D_v11.abs_c[18] variable */.start;

  data->localData[0]->realVars[826] /* particleReceiver1D_v11.abs_c[17] variable */ = data->modelData->realVarsData[826].attribute /* particleReceiver1D_v11.abs_c[17] variable */.start;

  data->localData[0]->realVars[825] /* particleReceiver1D_v11.abs_c[16] variable */ = data->modelData->realVarsData[825].attribute /* particleReceiver1D_v11.abs_c[16] variable */.start;

  data->localData[0]->realVars[824] /* particleReceiver1D_v11.abs_c[15] variable */ = data->modelData->realVarsData[824].attribute /* particleReceiver1D_v11.abs_c[15] variable */.start;

  data->localData[0]->realVars[823] /* particleReceiver1D_v11.abs_c[14] variable */ = data->modelData->realVarsData[823].attribute /* particleReceiver1D_v11.abs_c[14] variable */.start;

  data->localData[0]->realVars[822] /* particleReceiver1D_v11.abs_c[13] variable */ = data->modelData->realVarsData[822].attribute /* particleReceiver1D_v11.abs_c[13] variable */.start;

  data->localData[0]->realVars[821] /* particleReceiver1D_v11.abs_c[12] variable */ = data->modelData->realVarsData[821].attribute /* particleReceiver1D_v11.abs_c[12] variable */.start;

  data->localData[0]->realVars[820] /* particleReceiver1D_v11.abs_c[11] variable */ = data->modelData->realVarsData[820].attribute /* particleReceiver1D_v11.abs_c[11] variable */.start;

  data->localData[0]->realVars[819] /* particleReceiver1D_v11.abs_c[10] variable */ = data->modelData->realVarsData[819].attribute /* particleReceiver1D_v11.abs_c[10] variable */.start;

  data->localData[0]->realVars[818] /* particleReceiver1D_v11.abs_c[9] variable */ = data->modelData->realVarsData[818].attribute /* particleReceiver1D_v11.abs_c[9] variable */.start;

  data->localData[0]->realVars[817] /* particleReceiver1D_v11.abs_c[8] variable */ = data->modelData->realVarsData[817].attribute /* particleReceiver1D_v11.abs_c[8] variable */.start;

  data->localData[0]->realVars[816] /* particleReceiver1D_v11.abs_c[7] variable */ = data->modelData->realVarsData[816].attribute /* particleReceiver1D_v11.abs_c[7] variable */.start;

  data->localData[0]->realVars[815] /* particleReceiver1D_v11.abs_c[6] variable */ = data->modelData->realVarsData[815].attribute /* particleReceiver1D_v11.abs_c[6] variable */.start;

  data->localData[0]->realVars[814] /* particleReceiver1D_v11.abs_c[5] variable */ = data->modelData->realVarsData[814].attribute /* particleReceiver1D_v11.abs_c[5] variable */.start;

  data->localData[0]->realVars[813] /* particleReceiver1D_v11.abs_c[4] variable */ = data->modelData->realVarsData[813].attribute /* particleReceiver1D_v11.abs_c[4] variable */.start;

  data->localData[0]->realVars[812] /* particleReceiver1D_v11.abs_c[3] variable */ = data->modelData->realVarsData[812].attribute /* particleReceiver1D_v11.abs_c[3] variable */.start;

  data->localData[0]->realVars[811] /* particleReceiver1D_v11.abs_c[2] variable */ = data->modelData->realVarsData[811].attribute /* particleReceiver1D_v11.abs_c[2] variable */.start;

  data->localData[0]->realVars[810] /* particleReceiver1D_v11.abs_c[1] variable */ = data->modelData->realVarsData[810].attribute /* particleReceiver1D_v11.abs_c[1] variable */.start;

  data->localData[0]->realVars[850] /* particleReceiver1D_v11.eps_c[20] variable */ = data->modelData->realVarsData[850].attribute /* particleReceiver1D_v11.eps_c[20] variable */.start;

  data->localData[0]->realVars[849] /* particleReceiver1D_v11.eps_c[19] variable */ = data->modelData->realVarsData[849].attribute /* particleReceiver1D_v11.eps_c[19] variable */.start;

  data->localData[0]->realVars[848] /* particleReceiver1D_v11.eps_c[18] variable */ = data->modelData->realVarsData[848].attribute /* particleReceiver1D_v11.eps_c[18] variable */.start;

  data->localData[0]->realVars[847] /* particleReceiver1D_v11.eps_c[17] variable */ = data->modelData->realVarsData[847].attribute /* particleReceiver1D_v11.eps_c[17] variable */.start;

  data->localData[0]->realVars[846] /* particleReceiver1D_v11.eps_c[16] variable */ = data->modelData->realVarsData[846].attribute /* particleReceiver1D_v11.eps_c[16] variable */.start;

  data->localData[0]->realVars[845] /* particleReceiver1D_v11.eps_c[15] variable */ = data->modelData->realVarsData[845].attribute /* particleReceiver1D_v11.eps_c[15] variable */.start;

  data->localData[0]->realVars[844] /* particleReceiver1D_v11.eps_c[14] variable */ = data->modelData->realVarsData[844].attribute /* particleReceiver1D_v11.eps_c[14] variable */.start;

  data->localData[0]->realVars[843] /* particleReceiver1D_v11.eps_c[13] variable */ = data->modelData->realVarsData[843].attribute /* particleReceiver1D_v11.eps_c[13] variable */.start;

  data->localData[0]->realVars[842] /* particleReceiver1D_v11.eps_c[12] variable */ = data->modelData->realVarsData[842].attribute /* particleReceiver1D_v11.eps_c[12] variable */.start;

  data->localData[0]->realVars[841] /* particleReceiver1D_v11.eps_c[11] variable */ = data->modelData->realVarsData[841].attribute /* particleReceiver1D_v11.eps_c[11] variable */.start;

  data->localData[0]->realVars[840] /* particleReceiver1D_v11.eps_c[10] variable */ = data->modelData->realVarsData[840].attribute /* particleReceiver1D_v11.eps_c[10] variable */.start;

  data->localData[0]->realVars[839] /* particleReceiver1D_v11.eps_c[9] variable */ = data->modelData->realVarsData[839].attribute /* particleReceiver1D_v11.eps_c[9] variable */.start;

  data->localData[0]->realVars[838] /* particleReceiver1D_v11.eps_c[8] variable */ = data->modelData->realVarsData[838].attribute /* particleReceiver1D_v11.eps_c[8] variable */.start;

  data->localData[0]->realVars[837] /* particleReceiver1D_v11.eps_c[7] variable */ = data->modelData->realVarsData[837].attribute /* particleReceiver1D_v11.eps_c[7] variable */.start;

  data->localData[0]->realVars[836] /* particleReceiver1D_v11.eps_c[6] variable */ = data->modelData->realVarsData[836].attribute /* particleReceiver1D_v11.eps_c[6] variable */.start;

  data->localData[0]->realVars[835] /* particleReceiver1D_v11.eps_c[5] variable */ = data->modelData->realVarsData[835].attribute /* particleReceiver1D_v11.eps_c[5] variable */.start;

  data->localData[0]->realVars[834] /* particleReceiver1D_v11.eps_c[4] variable */ = data->modelData->realVarsData[834].attribute /* particleReceiver1D_v11.eps_c[4] variable */.start;

  data->localData[0]->realVars[833] /* particleReceiver1D_v11.eps_c[3] variable */ = data->modelData->realVarsData[833].attribute /* particleReceiver1D_v11.eps_c[3] variable */.start;

  data->localData[0]->realVars[832] /* particleReceiver1D_v11.eps_c[2] variable */ = data->modelData->realVarsData[832].attribute /* particleReceiver1D_v11.eps_c[2] variable */.start;

  data->localData[0]->realVars[831] /* particleReceiver1D_v11.eps_c[1] variable */ = data->modelData->realVarsData[831].attribute /* particleReceiver1D_v11.eps_c[1] variable */.start;

  data->localData[0]->realVars[677] /* particleReceiver1D_v11.A2[20] variable */ = data->modelData->realVarsData[677].attribute /* particleReceiver1D_v11.A2[20] variable */.start;

  data->localData[0]->realVars[676] /* particleReceiver1D_v11.A2[19] variable */ = data->modelData->realVarsData[676].attribute /* particleReceiver1D_v11.A2[19] variable */.start;

  data->localData[0]->realVars[675] /* particleReceiver1D_v11.A2[18] variable */ = data->modelData->realVarsData[675].attribute /* particleReceiver1D_v11.A2[18] variable */.start;

  data->localData[0]->realVars[674] /* particleReceiver1D_v11.A2[17] variable */ = data->modelData->realVarsData[674].attribute /* particleReceiver1D_v11.A2[17] variable */.start;

  data->localData[0]->realVars[673] /* particleReceiver1D_v11.A2[16] variable */ = data->modelData->realVarsData[673].attribute /* particleReceiver1D_v11.A2[16] variable */.start;

  data->localData[0]->realVars[672] /* particleReceiver1D_v11.A2[15] variable */ = data->modelData->realVarsData[672].attribute /* particleReceiver1D_v11.A2[15] variable */.start;

  data->localData[0]->realVars[671] /* particleReceiver1D_v11.A2[14] variable */ = data->modelData->realVarsData[671].attribute /* particleReceiver1D_v11.A2[14] variable */.start;

  data->localData[0]->realVars[670] /* particleReceiver1D_v11.A2[13] variable */ = data->modelData->realVarsData[670].attribute /* particleReceiver1D_v11.A2[13] variable */.start;

  data->localData[0]->realVars[669] /* particleReceiver1D_v11.A2[12] variable */ = data->modelData->realVarsData[669].attribute /* particleReceiver1D_v11.A2[12] variable */.start;

  data->localData[0]->realVars[668] /* particleReceiver1D_v11.A2[11] variable */ = data->modelData->realVarsData[668].attribute /* particleReceiver1D_v11.A2[11] variable */.start;

  data->localData[0]->realVars[667] /* particleReceiver1D_v11.A2[10] variable */ = data->modelData->realVarsData[667].attribute /* particleReceiver1D_v11.A2[10] variable */.start;

  data->localData[0]->realVars[666] /* particleReceiver1D_v11.A2[9] variable */ = data->modelData->realVarsData[666].attribute /* particleReceiver1D_v11.A2[9] variable */.start;

  data->localData[0]->realVars[665] /* particleReceiver1D_v11.A2[8] variable */ = data->modelData->realVarsData[665].attribute /* particleReceiver1D_v11.A2[8] variable */.start;

  data->localData[0]->realVars[664] /* particleReceiver1D_v11.A2[7] variable */ = data->modelData->realVarsData[664].attribute /* particleReceiver1D_v11.A2[7] variable */.start;

  data->localData[0]->realVars[663] /* particleReceiver1D_v11.A2[6] variable */ = data->modelData->realVarsData[663].attribute /* particleReceiver1D_v11.A2[6] variable */.start;

  data->localData[0]->realVars[662] /* particleReceiver1D_v11.A2[5] variable */ = data->modelData->realVarsData[662].attribute /* particleReceiver1D_v11.A2[5] variable */.start;

  data->localData[0]->realVars[661] /* particleReceiver1D_v11.A2[4] variable */ = data->modelData->realVarsData[661].attribute /* particleReceiver1D_v11.A2[4] variable */.start;

  data->localData[0]->realVars[660] /* particleReceiver1D_v11.A2[3] variable */ = data->modelData->realVarsData[660].attribute /* particleReceiver1D_v11.A2[3] variable */.start;

  data->localData[0]->realVars[659] /* particleReceiver1D_v11.A2[2] variable */ = data->modelData->realVarsData[659].attribute /* particleReceiver1D_v11.A2[2] variable */.start;

  data->localData[0]->realVars[658] /* particleReceiver1D_v11.A2[1] variable */ = data->modelData->realVarsData[658].attribute /* particleReceiver1D_v11.A2[1] variable */.start;

  data->localData[0]->realVars[698] /* particleReceiver1D_v11.B[20] variable */ = data->modelData->realVarsData[698].attribute /* particleReceiver1D_v11.B[20] variable */.start;

  data->localData[0]->realVars[697] /* particleReceiver1D_v11.B[19] variable */ = data->modelData->realVarsData[697].attribute /* particleReceiver1D_v11.B[19] variable */.start;

  data->localData[0]->realVars[696] /* particleReceiver1D_v11.B[18] variable */ = data->modelData->realVarsData[696].attribute /* particleReceiver1D_v11.B[18] variable */.start;

  data->localData[0]->realVars[695] /* particleReceiver1D_v11.B[17] variable */ = data->modelData->realVarsData[695].attribute /* particleReceiver1D_v11.B[17] variable */.start;

  data->localData[0]->realVars[694] /* particleReceiver1D_v11.B[16] variable */ = data->modelData->realVarsData[694].attribute /* particleReceiver1D_v11.B[16] variable */.start;

  data->localData[0]->realVars[693] /* particleReceiver1D_v11.B[15] variable */ = data->modelData->realVarsData[693].attribute /* particleReceiver1D_v11.B[15] variable */.start;

  data->localData[0]->realVars[692] /* particleReceiver1D_v11.B[14] variable */ = data->modelData->realVarsData[692].attribute /* particleReceiver1D_v11.B[14] variable */.start;

  data->localData[0]->realVars[691] /* particleReceiver1D_v11.B[13] variable */ = data->modelData->realVarsData[691].attribute /* particleReceiver1D_v11.B[13] variable */.start;

  data->localData[0]->realVars[690] /* particleReceiver1D_v11.B[12] variable */ = data->modelData->realVarsData[690].attribute /* particleReceiver1D_v11.B[12] variable */.start;

  data->localData[0]->realVars[689] /* particleReceiver1D_v11.B[11] variable */ = data->modelData->realVarsData[689].attribute /* particleReceiver1D_v11.B[11] variable */.start;

  data->localData[0]->realVars[688] /* particleReceiver1D_v11.B[10] variable */ = data->modelData->realVarsData[688].attribute /* particleReceiver1D_v11.B[10] variable */.start;

  data->localData[0]->realVars[687] /* particleReceiver1D_v11.B[9] variable */ = data->modelData->realVarsData[687].attribute /* particleReceiver1D_v11.B[9] variable */.start;

  data->localData[0]->realVars[686] /* particleReceiver1D_v11.B[8] variable */ = data->modelData->realVarsData[686].attribute /* particleReceiver1D_v11.B[8] variable */.start;

  data->localData[0]->realVars[685] /* particleReceiver1D_v11.B[7] variable */ = data->modelData->realVarsData[685].attribute /* particleReceiver1D_v11.B[7] variable */.start;

  data->localData[0]->realVars[684] /* particleReceiver1D_v11.B[6] variable */ = data->modelData->realVarsData[684].attribute /* particleReceiver1D_v11.B[6] variable */.start;

  data->localData[0]->realVars[683] /* particleReceiver1D_v11.B[5] variable */ = data->modelData->realVarsData[683].attribute /* particleReceiver1D_v11.B[5] variable */.start;

  data->localData[0]->realVars[682] /* particleReceiver1D_v11.B[4] variable */ = data->modelData->realVarsData[682].attribute /* particleReceiver1D_v11.B[4] variable */.start;

  data->localData[0]->realVars[681] /* particleReceiver1D_v11.B[3] variable */ = data->modelData->realVarsData[681].attribute /* particleReceiver1D_v11.B[3] variable */.start;

  data->localData[0]->realVars[680] /* particleReceiver1D_v11.B[2] variable */ = data->modelData->realVarsData[680].attribute /* particleReceiver1D_v11.B[2] variable */.start;

  data->localData[0]->realVars[679] /* particleReceiver1D_v11.B[1] variable */ = data->modelData->realVarsData[679].attribute /* particleReceiver1D_v11.B[1] variable */.start;

  data->localData[0]->realVars[657] /* particleReceiver1D_v11.A[20] variable */ = data->modelData->realVarsData[657].attribute /* particleReceiver1D_v11.A[20] variable */.start;

  data->localData[0]->realVars[656] /* particleReceiver1D_v11.A[19] variable */ = data->modelData->realVarsData[656].attribute /* particleReceiver1D_v11.A[19] variable */.start;

  data->localData[0]->realVars[655] /* particleReceiver1D_v11.A[18] variable */ = data->modelData->realVarsData[655].attribute /* particleReceiver1D_v11.A[18] variable */.start;

  data->localData[0]->realVars[654] /* particleReceiver1D_v11.A[17] variable */ = data->modelData->realVarsData[654].attribute /* particleReceiver1D_v11.A[17] variable */.start;

  data->localData[0]->realVars[653] /* particleReceiver1D_v11.A[16] variable */ = data->modelData->realVarsData[653].attribute /* particleReceiver1D_v11.A[16] variable */.start;

  data->localData[0]->realVars[652] /* particleReceiver1D_v11.A[15] variable */ = data->modelData->realVarsData[652].attribute /* particleReceiver1D_v11.A[15] variable */.start;

  data->localData[0]->realVars[651] /* particleReceiver1D_v11.A[14] variable */ = data->modelData->realVarsData[651].attribute /* particleReceiver1D_v11.A[14] variable */.start;

  data->localData[0]->realVars[650] /* particleReceiver1D_v11.A[13] variable */ = data->modelData->realVarsData[650].attribute /* particleReceiver1D_v11.A[13] variable */.start;

  data->localData[0]->realVars[649] /* particleReceiver1D_v11.A[12] variable */ = data->modelData->realVarsData[649].attribute /* particleReceiver1D_v11.A[12] variable */.start;

  data->localData[0]->realVars[648] /* particleReceiver1D_v11.A[11] variable */ = data->modelData->realVarsData[648].attribute /* particleReceiver1D_v11.A[11] variable */.start;

  data->localData[0]->realVars[647] /* particleReceiver1D_v11.A[10] variable */ = data->modelData->realVarsData[647].attribute /* particleReceiver1D_v11.A[10] variable */.start;

  data->localData[0]->realVars[646] /* particleReceiver1D_v11.A[9] variable */ = data->modelData->realVarsData[646].attribute /* particleReceiver1D_v11.A[9] variable */.start;

  data->localData[0]->realVars[645] /* particleReceiver1D_v11.A[8] variable */ = data->modelData->realVarsData[645].attribute /* particleReceiver1D_v11.A[8] variable */.start;

  data->localData[0]->realVars[644] /* particleReceiver1D_v11.A[7] variable */ = data->modelData->realVarsData[644].attribute /* particleReceiver1D_v11.A[7] variable */.start;

  data->localData[0]->realVars[643] /* particleReceiver1D_v11.A[6] variable */ = data->modelData->realVarsData[643].attribute /* particleReceiver1D_v11.A[6] variable */.start;

  data->localData[0]->realVars[642] /* particleReceiver1D_v11.A[5] variable */ = data->modelData->realVarsData[642].attribute /* particleReceiver1D_v11.A[5] variable */.start;

  data->localData[0]->realVars[641] /* particleReceiver1D_v11.A[4] variable */ = data->modelData->realVarsData[641].attribute /* particleReceiver1D_v11.A[4] variable */.start;

  data->localData[0]->realVars[640] /* particleReceiver1D_v11.A[3] variable */ = data->modelData->realVarsData[640].attribute /* particleReceiver1D_v11.A[3] variable */.start;

  data->localData[0]->realVars[639] /* particleReceiver1D_v11.A[2] variable */ = data->modelData->realVarsData[639].attribute /* particleReceiver1D_v11.A[2] variable */.start;

  data->localData[0]->realVars[638] /* particleReceiver1D_v11.A[1] variable */ = data->modelData->realVarsData[638].attribute /* particleReceiver1D_v11.A[1] variable */.start;

  data->localData[0]->realVars[758] /* particleReceiver1D_v11.N_layers[20] variable */ = data->modelData->realVarsData[758].attribute /* particleReceiver1D_v11.N_layers[20] variable */.start;

  data->localData[0]->realVars[757] /* particleReceiver1D_v11.N_layers[19] variable */ = data->modelData->realVarsData[757].attribute /* particleReceiver1D_v11.N_layers[19] variable */.start;

  data->localData[0]->realVars[756] /* particleReceiver1D_v11.N_layers[18] variable */ = data->modelData->realVarsData[756].attribute /* particleReceiver1D_v11.N_layers[18] variable */.start;

  data->localData[0]->realVars[755] /* particleReceiver1D_v11.N_layers[17] variable */ = data->modelData->realVarsData[755].attribute /* particleReceiver1D_v11.N_layers[17] variable */.start;

  data->localData[0]->realVars[754] /* particleReceiver1D_v11.N_layers[16] variable */ = data->modelData->realVarsData[754].attribute /* particleReceiver1D_v11.N_layers[16] variable */.start;

  data->localData[0]->realVars[753] /* particleReceiver1D_v11.N_layers[15] variable */ = data->modelData->realVarsData[753].attribute /* particleReceiver1D_v11.N_layers[15] variable */.start;

  data->localData[0]->realVars[752] /* particleReceiver1D_v11.N_layers[14] variable */ = data->modelData->realVarsData[752].attribute /* particleReceiver1D_v11.N_layers[14] variable */.start;

  data->localData[0]->realVars[751] /* particleReceiver1D_v11.N_layers[13] variable */ = data->modelData->realVarsData[751].attribute /* particleReceiver1D_v11.N_layers[13] variable */.start;

  data->localData[0]->realVars[750] /* particleReceiver1D_v11.N_layers[12] variable */ = data->modelData->realVarsData[750].attribute /* particleReceiver1D_v11.N_layers[12] variable */.start;

  data->localData[0]->realVars[749] /* particleReceiver1D_v11.N_layers[11] variable */ = data->modelData->realVarsData[749].attribute /* particleReceiver1D_v11.N_layers[11] variable */.start;

  data->localData[0]->realVars[748] /* particleReceiver1D_v11.N_layers[10] variable */ = data->modelData->realVarsData[748].attribute /* particleReceiver1D_v11.N_layers[10] variable */.start;

  data->localData[0]->realVars[747] /* particleReceiver1D_v11.N_layers[9] variable */ = data->modelData->realVarsData[747].attribute /* particleReceiver1D_v11.N_layers[9] variable */.start;

  data->localData[0]->realVars[746] /* particleReceiver1D_v11.N_layers[8] variable */ = data->modelData->realVarsData[746].attribute /* particleReceiver1D_v11.N_layers[8] variable */.start;

  data->localData[0]->realVars[745] /* particleReceiver1D_v11.N_layers[7] variable */ = data->modelData->realVarsData[745].attribute /* particleReceiver1D_v11.N_layers[7] variable */.start;

  data->localData[0]->realVars[744] /* particleReceiver1D_v11.N_layers[6] variable */ = data->modelData->realVarsData[744].attribute /* particleReceiver1D_v11.N_layers[6] variable */.start;

  data->localData[0]->realVars[743] /* particleReceiver1D_v11.N_layers[5] variable */ = data->modelData->realVarsData[743].attribute /* particleReceiver1D_v11.N_layers[5] variable */.start;

  data->localData[0]->realVars[742] /* particleReceiver1D_v11.N_layers[4] variable */ = data->modelData->realVarsData[742].attribute /* particleReceiver1D_v11.N_layers[4] variable */.start;

  data->localData[0]->realVars[741] /* particleReceiver1D_v11.N_layers[3] variable */ = data->modelData->realVarsData[741].attribute /* particleReceiver1D_v11.N_layers[3] variable */.start;

  data->localData[0]->realVars[740] /* particleReceiver1D_v11.N_layers[2] variable */ = data->modelData->realVarsData[740].attribute /* particleReceiver1D_v11.N_layers[2] variable */.start;

  data->localData[0]->realVars[739] /* particleReceiver1D_v11.N_layers[1] variable */ = data->modelData->realVarsData[739].attribute /* particleReceiver1D_v11.N_layers[1] variable */.start;

  data->localData[0]->realVars[1016] /* particleReceiver1D_v11.phi_area[20] variable */ = data->modelData->realVarsData[1016].attribute /* particleReceiver1D_v11.phi_area[20] variable */.start;

  data->localData[0]->realVars[1015] /* particleReceiver1D_v11.phi_area[19] variable */ = data->modelData->realVarsData[1015].attribute /* particleReceiver1D_v11.phi_area[19] variable */.start;

  data->localData[0]->realVars[1014] /* particleReceiver1D_v11.phi_area[18] variable */ = data->modelData->realVarsData[1014].attribute /* particleReceiver1D_v11.phi_area[18] variable */.start;

  data->localData[0]->realVars[1013] /* particleReceiver1D_v11.phi_area[17] variable */ = data->modelData->realVarsData[1013].attribute /* particleReceiver1D_v11.phi_area[17] variable */.start;

  data->localData[0]->realVars[1012] /* particleReceiver1D_v11.phi_area[16] variable */ = data->modelData->realVarsData[1012].attribute /* particleReceiver1D_v11.phi_area[16] variable */.start;

  data->localData[0]->realVars[1011] /* particleReceiver1D_v11.phi_area[15] variable */ = data->modelData->realVarsData[1011].attribute /* particleReceiver1D_v11.phi_area[15] variable */.start;

  data->localData[0]->realVars[1010] /* particleReceiver1D_v11.phi_area[14] variable */ = data->modelData->realVarsData[1010].attribute /* particleReceiver1D_v11.phi_area[14] variable */.start;

  data->localData[0]->realVars[1009] /* particleReceiver1D_v11.phi_area[13] variable */ = data->modelData->realVarsData[1009].attribute /* particleReceiver1D_v11.phi_area[13] variable */.start;

  data->localData[0]->realVars[1008] /* particleReceiver1D_v11.phi_area[12] variable */ = data->modelData->realVarsData[1008].attribute /* particleReceiver1D_v11.phi_area[12] variable */.start;

  data->localData[0]->realVars[1007] /* particleReceiver1D_v11.phi_area[11] variable */ = data->modelData->realVarsData[1007].attribute /* particleReceiver1D_v11.phi_area[11] variable */.start;

  data->localData[0]->realVars[1006] /* particleReceiver1D_v11.phi_area[10] variable */ = data->modelData->realVarsData[1006].attribute /* particleReceiver1D_v11.phi_area[10] variable */.start;

  data->localData[0]->realVars[1005] /* particleReceiver1D_v11.phi_area[9] variable */ = data->modelData->realVarsData[1005].attribute /* particleReceiver1D_v11.phi_area[9] variable */.start;

  data->localData[0]->realVars[1004] /* particleReceiver1D_v11.phi_area[8] variable */ = data->modelData->realVarsData[1004].attribute /* particleReceiver1D_v11.phi_area[8] variable */.start;

  data->localData[0]->realVars[1003] /* particleReceiver1D_v11.phi_area[7] variable */ = data->modelData->realVarsData[1003].attribute /* particleReceiver1D_v11.phi_area[7] variable */.start;

  data->localData[0]->realVars[1002] /* particleReceiver1D_v11.phi_area[6] variable */ = data->modelData->realVarsData[1002].attribute /* particleReceiver1D_v11.phi_area[6] variable */.start;

  data->localData[0]->realVars[1001] /* particleReceiver1D_v11.phi_area[5] variable */ = data->modelData->realVarsData[1001].attribute /* particleReceiver1D_v11.phi_area[5] variable */.start;

  data->localData[0]->realVars[1000] /* particleReceiver1D_v11.phi_area[4] variable */ = data->modelData->realVarsData[1000].attribute /* particleReceiver1D_v11.phi_area[4] variable */.start;

  data->localData[0]->realVars[999] /* particleReceiver1D_v11.phi_area[3] variable */ = data->modelData->realVarsData[999].attribute /* particleReceiver1D_v11.phi_area[3] variable */.start;

  data->localData[0]->realVars[998] /* particleReceiver1D_v11.phi_area[2] variable */ = data->modelData->realVarsData[998].attribute /* particleReceiver1D_v11.phi_area[2] variable */.start;

  data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */ = data->modelData->realVarsData[997].attribute /* particleReceiver1D_v11.phi_area[1] variable */.start;

  data->localData[0]->realVars[738] /* particleReceiver1D_v11.L[20] variable */ = data->modelData->realVarsData[738].attribute /* particleReceiver1D_v11.L[20] variable */.start;

  data->localData[0]->realVars[737] /* particleReceiver1D_v11.L[19] variable */ = data->modelData->realVarsData[737].attribute /* particleReceiver1D_v11.L[19] variable */.start;

  data->localData[0]->realVars[736] /* particleReceiver1D_v11.L[18] variable */ = data->modelData->realVarsData[736].attribute /* particleReceiver1D_v11.L[18] variable */.start;

  data->localData[0]->realVars[735] /* particleReceiver1D_v11.L[17] variable */ = data->modelData->realVarsData[735].attribute /* particleReceiver1D_v11.L[17] variable */.start;

  data->localData[0]->realVars[734] /* particleReceiver1D_v11.L[16] variable */ = data->modelData->realVarsData[734].attribute /* particleReceiver1D_v11.L[16] variable */.start;

  data->localData[0]->realVars[733] /* particleReceiver1D_v11.L[15] variable */ = data->modelData->realVarsData[733].attribute /* particleReceiver1D_v11.L[15] variable */.start;

  data->localData[0]->realVars[732] /* particleReceiver1D_v11.L[14] variable */ = data->modelData->realVarsData[732].attribute /* particleReceiver1D_v11.L[14] variable */.start;

  data->localData[0]->realVars[731] /* particleReceiver1D_v11.L[13] variable */ = data->modelData->realVarsData[731].attribute /* particleReceiver1D_v11.L[13] variable */.start;

  data->localData[0]->realVars[730] /* particleReceiver1D_v11.L[12] variable */ = data->modelData->realVarsData[730].attribute /* particleReceiver1D_v11.L[12] variable */.start;

  data->localData[0]->realVars[729] /* particleReceiver1D_v11.L[11] variable */ = data->modelData->realVarsData[729].attribute /* particleReceiver1D_v11.L[11] variable */.start;

  data->localData[0]->realVars[728] /* particleReceiver1D_v11.L[10] variable */ = data->modelData->realVarsData[728].attribute /* particleReceiver1D_v11.L[10] variable */.start;

  data->localData[0]->realVars[727] /* particleReceiver1D_v11.L[9] variable */ = data->modelData->realVarsData[727].attribute /* particleReceiver1D_v11.L[9] variable */.start;

  data->localData[0]->realVars[726] /* particleReceiver1D_v11.L[8] variable */ = data->modelData->realVarsData[726].attribute /* particleReceiver1D_v11.L[8] variable */.start;

  data->localData[0]->realVars[725] /* particleReceiver1D_v11.L[7] variable */ = data->modelData->realVarsData[725].attribute /* particleReceiver1D_v11.L[7] variable */.start;

  data->localData[0]->realVars[724] /* particleReceiver1D_v11.L[6] variable */ = data->modelData->realVarsData[724].attribute /* particleReceiver1D_v11.L[6] variable */.start;

  data->localData[0]->realVars[723] /* particleReceiver1D_v11.L[5] variable */ = data->modelData->realVarsData[723].attribute /* particleReceiver1D_v11.L[5] variable */.start;

  data->localData[0]->realVars[722] /* particleReceiver1D_v11.L[4] variable */ = data->modelData->realVarsData[722].attribute /* particleReceiver1D_v11.L[4] variable */.start;

  data->localData[0]->realVars[721] /* particleReceiver1D_v11.L[3] variable */ = data->modelData->realVarsData[721].attribute /* particleReceiver1D_v11.L[3] variable */.start;

  data->localData[0]->realVars[720] /* particleReceiver1D_v11.L[2] variable */ = data->modelData->realVarsData[720].attribute /* particleReceiver1D_v11.L[2] variable */.start;

  data->localData[0]->realVars[719] /* particleReceiver1D_v11.L[1] variable */ = data->modelData->realVarsData[719].attribute /* particleReceiver1D_v11.L[1] variable */.start;

  data->localData[0]->realVars[718] /* particleReceiver1D_v11.C[20] variable */ = data->modelData->realVarsData[718].attribute /* particleReceiver1D_v11.C[20] variable */.start;

  data->localData[0]->realVars[717] /* particleReceiver1D_v11.C[19] variable */ = data->modelData->realVarsData[717].attribute /* particleReceiver1D_v11.C[19] variable */.start;

  data->localData[0]->realVars[716] /* particleReceiver1D_v11.C[18] variable */ = data->modelData->realVarsData[716].attribute /* particleReceiver1D_v11.C[18] variable */.start;

  data->localData[0]->realVars[715] /* particleReceiver1D_v11.C[17] variable */ = data->modelData->realVarsData[715].attribute /* particleReceiver1D_v11.C[17] variable */.start;

  data->localData[0]->realVars[714] /* particleReceiver1D_v11.C[16] variable */ = data->modelData->realVarsData[714].attribute /* particleReceiver1D_v11.C[16] variable */.start;

  data->localData[0]->realVars[713] /* particleReceiver1D_v11.C[15] variable */ = data->modelData->realVarsData[713].attribute /* particleReceiver1D_v11.C[15] variable */.start;

  data->localData[0]->realVars[712] /* particleReceiver1D_v11.C[14] variable */ = data->modelData->realVarsData[712].attribute /* particleReceiver1D_v11.C[14] variable */.start;

  data->localData[0]->realVars[711] /* particleReceiver1D_v11.C[13] variable */ = data->modelData->realVarsData[711].attribute /* particleReceiver1D_v11.C[13] variable */.start;

  data->localData[0]->realVars[710] /* particleReceiver1D_v11.C[12] variable */ = data->modelData->realVarsData[710].attribute /* particleReceiver1D_v11.C[12] variable */.start;

  data->localData[0]->realVars[709] /* particleReceiver1D_v11.C[11] variable */ = data->modelData->realVarsData[709].attribute /* particleReceiver1D_v11.C[11] variable */.start;

  data->localData[0]->realVars[708] /* particleReceiver1D_v11.C[10] variable */ = data->modelData->realVarsData[708].attribute /* particleReceiver1D_v11.C[10] variable */.start;

  data->localData[0]->realVars[707] /* particleReceiver1D_v11.C[9] variable */ = data->modelData->realVarsData[707].attribute /* particleReceiver1D_v11.C[9] variable */.start;

  data->localData[0]->realVars[706] /* particleReceiver1D_v11.C[8] variable */ = data->modelData->realVarsData[706].attribute /* particleReceiver1D_v11.C[8] variable */.start;

  data->localData[0]->realVars[705] /* particleReceiver1D_v11.C[7] variable */ = data->modelData->realVarsData[705].attribute /* particleReceiver1D_v11.C[7] variable */.start;

  data->localData[0]->realVars[704] /* particleReceiver1D_v11.C[6] variable */ = data->modelData->realVarsData[704].attribute /* particleReceiver1D_v11.C[6] variable */.start;

  data->localData[0]->realVars[703] /* particleReceiver1D_v11.C[5] variable */ = data->modelData->realVarsData[703].attribute /* particleReceiver1D_v11.C[5] variable */.start;

  data->localData[0]->realVars[702] /* particleReceiver1D_v11.C[4] variable */ = data->modelData->realVarsData[702].attribute /* particleReceiver1D_v11.C[4] variable */.start;

  data->localData[0]->realVars[701] /* particleReceiver1D_v11.C[3] variable */ = data->modelData->realVarsData[701].attribute /* particleReceiver1D_v11.C[3] variable */.start;

  data->localData[0]->realVars[700] /* particleReceiver1D_v11.C[2] variable */ = data->modelData->realVarsData[700].attribute /* particleReceiver1D_v11.C[2] variable */.start;

  data->localData[0]->realVars[699] /* particleReceiver1D_v11.C[1] variable */ = data->modelData->realVarsData[699].attribute /* particleReceiver1D_v11.C[1] variable */.start;

  tmp202 = ((modelica_integer) 1); tmp203 = 1; tmp204 = ((modelica_integer) 20);
  if(!(((tmp203 > 0) && (tmp202 > tmp204)) || ((tmp203 < 0) && (tmp202 < tmp204))))
  {
    modelica_integer i;
    for(i = ((modelica_integer) 1); in_range_integer(i, tmp202, tmp204); i += tmp203)
    {
      if(data->simulationInfo->booleanParameter[122] /* particleReceiver1D_v11.with_uniform_curtain_props PARAM */)
      {
        (&data->localData[0]->realVars[699] /* particleReceiver1D_v11.C[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

        (&data->localData[0]->realVars[719] /* particleReceiver1D_v11.L[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

        (&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

        (&data->localData[0]->realVars[739] /* particleReceiver1D_v11.N_layers[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

        (&data->localData[0]->realVars[638] /* particleReceiver1D_v11.A[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

        (&data->localData[0]->realVars[679] /* particleReceiver1D_v11.B[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

        (&data->localData[0]->realVars[658] /* particleReceiver1D_v11.A2[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

        (&data->localData[0]->realVars[831] /* particleReceiver1D_v11.eps_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = data->simulationInfo->realParameter[335] /* particleReceiver1D_v11.eps_s PARAM */;

        (&data->localData[0]->realVars[810] /* particleReceiver1D_v11.abs_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = data->simulationInfo->realParameter[332] /* particleReceiver1D_v11.abs_s PARAM */;

        (&data->localData[0]->realVars[1121] /* particleReceiver1D_v11.tau_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.4;

        (&data->localData[0]->realVars[1078] /* particleReceiver1D_v11.reflectivity_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 1.0 - ((&data->localData[0]->realVars[810] /* particleReceiver1D_v11.abs_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] + (&data->localData[0]->realVars[1121] /* particleReceiver1D_v11.tau_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)]);
      }
      else
      {
        RELATIONHYSTERESIS(tmp175, data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, 21, Less);
        if(tmp175)
        {
          (&data->localData[0]->realVars[699] /* particleReceiver1D_v11.C[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[719] /* particleReceiver1D_v11.L[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[739] /* particleReceiver1D_v11.N_layers[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[638] /* particleReceiver1D_v11.A[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[679] /* particleReceiver1D_v11.B[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[658] /* particleReceiver1D_v11.A2[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[831] /* particleReceiver1D_v11.eps_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[810] /* particleReceiver1D_v11.abs_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[1121] /* particleReceiver1D_v11.tau_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;

          (&data->localData[0]->realVars[1078] /* particleReceiver1D_v11.reflectivity_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 0.0;
        }
        else
        {
          tmp176 = data->simulationInfo->realParameter[333] /* particleReceiver1D_v11.d_p PARAM */;
          (&data->localData[0]->realVars[699] /* particleReceiver1D_v11.C[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = DIVISION_SIM((6.0) * ((&data->localData[0]->realVars[976] /* particleReceiver1D_v11.phi[1] variable */)[calc_base_index_dims_subs(1, 21, i)]),(3.141592653589793) * ((tmp176 * tmp176 * tmp176)),"3.141592653589793 * particleReceiver1D_v11.d_p ^ 3.0",equationIndexes);

          tmp177 = DIVISION_SIM(1.0,(&data->localData[0]->realVars[976] /* particleReceiver1D_v11.phi[1] variable */)[calc_base_index_dims_subs(1, 21, i)],"particleReceiver1D_v11.phi[i]",equationIndexes);
          tmp178 = 0.3333333333333333;
          if(tmp177 < 0.0 && tmp178 != 0.0)
          {
            tmp180 = modf(tmp178, &tmp181);
            
            if(tmp180 > 0.5)
            {
              tmp180 -= 1.0;
              tmp181 += 1.0;
            }
            else if(tmp180 < -0.5)
            {
              tmp180 += 1.0;
              tmp181 -= 1.0;
            }
            
            if(fabs(tmp180) < 1e-10)
              tmp179 = pow(tmp177, tmp181);
            else
            {
              tmp183 = modf(1.0/tmp178, &tmp182);
              if(tmp183 > 0.5)
              {
                tmp183 -= 1.0;
                tmp182 += 1.0;
              }
              else if(tmp183 < -0.5)
              {
                tmp183 += 1.0;
                tmp182 -= 1.0;
              }
              if(fabs(tmp183) < 1e-10 && ((unsigned long)tmp182 & 1))
              {
                tmp179 = -pow(-tmp177, tmp180)*pow(tmp177, tmp181);
              }
              else
              {
                throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp177, tmp178);
              }
            }
          }
          else
          {
            tmp179 = pow(tmp177, tmp178);
          }
          if(isnan(tmp179) || isinf(tmp179))
          {
            throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp177, tmp178);
          }
          (&data->localData[0]->realVars[719] /* particleReceiver1D_v11.L[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = (0.8059959770082348) * ((data->simulationInfo->realParameter[333] /* particleReceiver1D_v11.d_p PARAM */) * (tmp179));

          tmp184 = DIVISION_SIM(data->simulationInfo->realParameter[333] /* particleReceiver1D_v11.d_p PARAM */,(&data->localData[0]->realVars[719] /* particleReceiver1D_v11.L[1] variable */)[calc_base_index_dims_subs(1, 20, i)],"particleReceiver1D_v11.L[i]",equationIndexes);
          (&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = (0.7853981633974483) * ((tmp184 * tmp184));

          (&data->localData[0]->realVars[739] /* particleReceiver1D_v11.N_layers[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = DIVISION_SIM((&data->localData[0]->realVars[1098] /* particleReceiver1D_v11.t_c[1] variable */)[calc_base_index_dims_subs(1, 22, i)],(&data->localData[0]->realVars[719] /* particleReceiver1D_v11.L[1] variable */)[calc_base_index_dims_subs(1, 20, i)],"particleReceiver1D_v11.L[i]",equationIndexes);

          tmp185 = (data->simulationInfo->realParameter[342] /* particleReceiver1D_v11.prob_side PARAM */) * ((1.0 - data->simulationInfo->realParameter[332] /* particleReceiver1D_v11.abs_s PARAM */) * ((&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)]));
          (&data->localData[0]->realVars[638] /* particleReceiver1D_v11.A[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = (data->simulationInfo->realParameter[341] /* particleReceiver1D_v11.prob_center PARAM */) * ((1.0 - data->simulationInfo->realParameter[332] /* particleReceiver1D_v11.abs_s PARAM */) * ((&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)])) + (2.0) * (DIVISION_SIM((tmp185 * tmp185),((&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)]) * (data->simulationInfo->realParameter[332] /* particleReceiver1D_v11.abs_s PARAM */),"particleReceiver1D_v11.phi_area[i] * particleReceiver1D_v11.abs_s",equationIndexes));

          tmp186 = 1.0 - (&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)];
          (&data->localData[0]->realVars[679] /* particleReceiver1D_v11.B[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = fmin((tmp186 * tmp186),0.99999);

          tmp187 = (data->simulationInfo->realParameter[342] /* particleReceiver1D_v11.prob_side PARAM */) * ((1.0 - data->simulationInfo->realParameter[335] /* particleReceiver1D_v11.eps_s PARAM */) * ((&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)]));
          (&data->localData[0]->realVars[658] /* particleReceiver1D_v11.A2[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = (data->simulationInfo->realParameter[341] /* particleReceiver1D_v11.prob_center PARAM */) * ((1.0 - data->simulationInfo->realParameter[335] /* particleReceiver1D_v11.eps_s PARAM */) * ((&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)])) + (2.0) * (DIVISION_SIM((tmp187 * tmp187),((&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)]) * (data->simulationInfo->realParameter[335] /* particleReceiver1D_v11.eps_s PARAM */),"particleReceiver1D_v11.phi_area[i] * particleReceiver1D_v11.eps_s",equationIndexes));

          (&data->localData[0]->realVars[831] /* particleReceiver1D_v11.eps_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = data->simulationInfo->realParameter[335] /* particleReceiver1D_v11.eps_s PARAM */;

          tmp188 = (&data->localData[0]->realVars[679] /* particleReceiver1D_v11.B[1] variable */)[calc_base_index_dims_subs(1, 20, i)];
          tmp189 = (&data->localData[0]->realVars[739] /* particleReceiver1D_v11.N_layers[1] variable */)[calc_base_index_dims_subs(1, 20, i)];
          if(tmp188 < 0.0 && tmp189 != 0.0)
          {
            tmp191 = modf(tmp189, &tmp192);
            
            if(tmp191 > 0.5)
            {
              tmp191 -= 1.0;
              tmp192 += 1.0;
            }
            else if(tmp191 < -0.5)
            {
              tmp191 += 1.0;
              tmp192 -= 1.0;
            }
            
            if(fabs(tmp191) < 1e-10)
              tmp190 = pow(tmp188, tmp192);
            else
            {
              tmp194 = modf(1.0/tmp189, &tmp193);
              if(tmp194 > 0.5)
              {
                tmp194 -= 1.0;
                tmp193 += 1.0;
              }
              else if(tmp194 < -0.5)
              {
                tmp194 += 1.0;
                tmp193 -= 1.0;
              }
              if(fabs(tmp194) < 1e-10 && ((unsigned long)tmp193 & 1))
              {
                tmp190 = -pow(-tmp188, tmp191)*pow(tmp188, tmp192);
              }
              else
              {
                throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp188, tmp189);
              }
            }
          }
          else
          {
            tmp190 = pow(tmp188, tmp189);
          }
          if(isnan(tmp190) || isinf(tmp190))
          {
            throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp188, tmp189);
          }
          (&data->localData[0]->realVars[810] /* particleReceiver1D_v11.abs_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 1.0 - (((&data->localData[0]->realVars[638] /* particleReceiver1D_v11.A[1] variable */)[calc_base_index_dims_subs(1, 20, i)]) * (DIVISION_SIM(1.0 - (tmp190),1.0 - ((&data->localData[0]->realVars[679] /* particleReceiver1D_v11.B[1] variable */)[calc_base_index_dims_subs(1, 20, i)] + (&data->localData[0]->realVars[1121] /* particleReceiver1D_v11.tau_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)]),"1.0 - (particleReceiver1D_v11.B[i] + particleReceiver1D_v11.tau_c[i])",equationIndexes)));

          tmp195 = 1.0 - (&data->localData[0]->realVars[997] /* particleReceiver1D_v11.phi_area[1] variable */)[calc_base_index_dims_subs(1, 20, i)];
          tmp196 = (&data->localData[0]->realVars[739] /* particleReceiver1D_v11.N_layers[1] variable */)[calc_base_index_dims_subs(1, 20, i)];
          if(tmp195 < 0.0 && tmp196 != 0.0)
          {
            tmp198 = modf(tmp196, &tmp199);
            
            if(tmp198 > 0.5)
            {
              tmp198 -= 1.0;
              tmp199 += 1.0;
            }
            else if(tmp198 < -0.5)
            {
              tmp198 += 1.0;
              tmp199 -= 1.0;
            }
            
            if(fabs(tmp198) < 1e-10)
              tmp197 = pow(tmp195, tmp199);
            else
            {
              tmp201 = modf(1.0/tmp196, &tmp200);
              if(tmp201 > 0.5)
              {
                tmp201 -= 1.0;
                tmp200 += 1.0;
              }
              else if(tmp201 < -0.5)
              {
                tmp201 += 1.0;
                tmp200 -= 1.0;
              }
              if(fabs(tmp201) < 1e-10 && ((unsigned long)tmp200 & 1))
              {
                tmp197 = -pow(-tmp195, tmp198)*pow(tmp195, tmp199);
              }
              else
              {
                throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp195, tmp196);
              }
            }
          }
          else
          {
            tmp197 = pow(tmp195, tmp196);
          }
          if(isnan(tmp197) || isinf(tmp197))
          {
            throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp195, tmp196);
          }
          (&data->localData[0]->realVars[1121] /* particleReceiver1D_v11.tau_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = fmax(tmp197,1e-30);

          (&data->localData[0]->realVars[1078] /* particleReceiver1D_v11.reflectivity_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] = 1.0 - ((&data->localData[0]->realVars[810] /* particleReceiver1D_v11.abs_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)] + (&data->localData[0]->realVars[1121] /* particleReceiver1D_v11.tau_c[1] variable */)[calc_base_index_dims_subs(1, 20, i)]);
        }
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4249
type: SIMPLE_ASSIGN
controlHot.logic.on_charge = controlHot.m_flow_in > 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4249(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4249};
  modelica_boolean tmp205;
  RELATIONHYSTERESIS(tmp205, data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */, 0.0, 22, Greater);
  data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ = tmp205;
  TRACE_POP
}
/*
equation index: 4250
type: SIMPLE_ASSIGN
$whenCondition7 = not (controlHot.logic.on_charge or controlHot.logic.on_discharge)
*/
void PhysicalParticleCO21D_v11_eqFunction_4250(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4250};
  data->localData[0]->booleanVars[13] /* $whenCondition7 DISCRETE */ = (!(data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ || data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */));
  TRACE_POP
}
/*
equation index: 4251
type: WHEN

when {$whenCondition7} then
  controlHot.logic.t_off = time;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4251(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4251};
  if((data->localData[0]->booleanVars[13] /* $whenCondition7 DISCRETE */ && !data->simulationInfo->booleanVarsPre[13] /* $whenCondition7 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1368] /* controlHot.logic.t_off DISCRETE */ = data->localData[0]->timeValue;
  }
  TRACE_POP
}
/*
equation index: 4252
type: SIMPLE_ASSIGN
controlHot.logic.standby = time - controlHot.logic.t_off < controlHot.logic.t_standby
*/
void PhysicalParticleCO21D_v11_eqFunction_4252(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4252};
  modelica_boolean tmp206;
  RELATIONHYSTERESIS(tmp206, data->localData[0]->timeValue - data->localData[0]->realVars[1368] /* controlHot.logic.t_off DISCRETE */, data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */, 23, Less);
  data->localData[0]->booleanVars[19] /* controlHot.logic.standby DISCRETE */ = tmp206;
  TRACE_POP
}
/*
equation index: 4253
type: SIMPLE_ASSIGN
$whenCondition8 = controlHot.logic.on_charge or controlHot.logic.on_discharge
*/
void PhysicalParticleCO21D_v11_eqFunction_4253(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4253};
  data->localData[0]->booleanVars[14] /* $whenCondition8 DISCRETE */ = (data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ || data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */);
  TRACE_POP
}
/*
equation index: 4254
type: WHEN

when {$whenCondition8} then
  controlHot.logic.t_on = time;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4254(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4254};
  if((data->localData[0]->booleanVars[14] /* $whenCondition8 DISCRETE */ && !data->simulationInfo->booleanVarsPre[14] /* $whenCondition8 DISCRETE */ /* edge */))
  {
    data->localData[0]->realVars[1369] /* controlHot.logic.t_on DISCRETE */ = data->localData[0]->timeValue;
  }
  TRACE_POP
}
/*
equation index: 4255
type: SIMPLE_ASSIGN
$whenCondition6 = controlHot.logic.t_on + (-controlHot.logic.t_off) - controlHot.logic.t_standby > 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4255(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4255};
  modelica_boolean tmp207;
  tmp207 = Greater(data->localData[0]->realVars[1369] /* controlHot.logic.t_on DISCRETE */ + (-data->localData[0]->realVars[1368] /* controlHot.logic.t_off DISCRETE */) - data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */,0.0);
  data->localData[0]->booleanVars[12] /* $whenCondition6 DISCRETE */ = tmp207;
  TRACE_POP
}
/*
equation index: 4256
type: SIMPLE_ASSIGN
$whenCondition5 = time - controlHot.logic.t_on > controlHot.logic.t_start
*/
void PhysicalParticleCO21D_v11_eqFunction_4256(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4256};
  modelica_boolean tmp208;
  RELATIONHYSTERESIS(tmp208, data->localData[0]->timeValue - data->localData[0]->realVars[1369] /* controlHot.logic.t_on DISCRETE */, data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */, 24, Greater);
  data->localData[0]->booleanVars[11] /* $whenCondition5 DISCRETE */ = tmp208;
  TRACE_POP
}
/*
equation index: 4257
type: WHEN

when {$whenCondition6} then
  controlHot.logic.startup = true;
end when;
*/
void PhysicalParticleCO21D_v11_eqFunction_4257(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4257};
  if((data->localData[0]->booleanVars[12] /* $whenCondition6 DISCRETE */ && !data->simulationInfo->booleanVarsPre[12] /* $whenCondition6 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[20] /* controlHot.logic.startup DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[11] /* $whenCondition5 DISCRETE */ && !data->simulationInfo->booleanVarsPre[11] /* $whenCondition5 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[20] /* controlHot.logic.startup DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 4259
type: SIMPLE_ASSIGN
controlHot.m_flow = if controlHot.logic.on_charge or controlHot.logic.on_discharge then if controlHot.logic.startup then controlHot.logic.m_flow_startup else if controlHot.logic.on_discharge then controlHot.logic.m_flow_max else min(controlHot.m_flow_in, controlHot.logic.m_flow_max) else if controlHot.logic.standby then controlHot.logic.m_flow_standby else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4259(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4259};
  data->localData[0]->realVars[60] /* controlHot.m_flow variable */ = ((data->localData[0]->booleanVars[17] /* controlHot.logic.on_charge DISCRETE */ || data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */)?(data->localData[0]->booleanVars[20] /* controlHot.logic.startup DISCRETE */?data->simulationInfo->realParameter[92] /* controlHot.logic.m_flow_startup PARAM */:(data->localData[0]->booleanVars[18] /* controlHot.logic.on_discharge DISCRETE */?data->simulationInfo->realParameter[90] /* controlHot.logic.m_flow_max PARAM */:fmin(data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */,data->simulationInfo->realParameter[90] /* controlHot.logic.m_flow_max PARAM */))):(data->localData[0]->booleanVars[19] /* controlHot.logic.standby DISCRETE */?data->simulationInfo->realParameter[91] /* controlHot.logic.m_flow_standby PARAM */:0.0));
  TRACE_POP
}
/*
equation index: 4260
type: SIMPLE_ASSIGN
LiftCold.fluid_b.m_flow = -(if liftHX.use_input then controlHot.m_flow else liftHX.m_flow_fixed)
*/
void PhysicalParticleCO21D_v11_eqFunction_4260(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4260};
  data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */ = (-((data->simulationInfo->booleanParameter[14] /* liftHX.use_input PARAM */?data->localData[0]->realVars[60] /* controlHot.m_flow variable */:data->simulationInfo->realParameter[173] /* liftHX.m_flow_fixed PARAM */)));
  TRACE_POP
}
/*
equation index: 4261
type: SIMPLE_ASSIGN
$DER.tankHot.m = particleReceiver1D_v11.mdot + LiftCold.fluid_b.m_flow
*/
void PhysicalParticleCO21D_v11_eqFunction_4261(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4261};
  data->localData[0]->realVars[32] /* der(tankHot.m) STATE_DER */ = data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */ + data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */;
  TRACE_POP
}
/*
equation index: 4262
type: SIMPLE_ASSIGN
$DER.tankCold.m = (-LiftCold.fluid_b.m_flow) - particleReceiver1D_v11.mdot
*/
void PhysicalParticleCO21D_v11_eqFunction_4262(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4262};
  data->localData[0]->realVars[30] /* der(tankCold.m) STATE_DER */ = (-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */) - data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */;
  TRACE_POP
}
/*
equation index: 4263
type: SIMPLE_ASSIGN
liftHX.W_loss = 9.806649999999999 * (-LiftCold.fluid_b.m_flow) * liftHX.dh * (1.0 - liftHX.CF) / liftHX.eff
*/
void PhysicalParticleCO21D_v11_eqFunction_4263(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4263};
  data->localData[0]->realVars[100] /* liftHX.W_loss variable */ = (9.806649999999999) * (((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */)) * ((data->simulationInfo->realParameter[170] /* liftHX.dh PARAM */) * (DIVISION_SIM(1.0 - data->simulationInfo->realParameter[169] /* liftHX.CF PARAM */,data->simulationInfo->realParameter[172] /* liftHX.eff PARAM */,"liftHX.eff",equationIndexes))));
  TRACE_POP
}
/*
equation index: 4264
type: SIMPLE_ASSIGN
LiftCold.W_loss = 9.806649999999999 * (-LiftCold.fluid_b.m_flow) * LiftCold.dh * (1.0 - LiftCold.CF) / LiftCold.eff
*/
void PhysicalParticleCO21D_v11_eqFunction_4264(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4264};
  data->localData[0]->realVars[53] /* LiftCold.W_loss variable */ = (9.806649999999999) * (((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */)) * ((data->simulationInfo->realParameter[36] /* LiftCold.dh PARAM */) * (DIVISION_SIM(1.0 - data->simulationInfo->realParameter[35] /* LiftCold.CF PARAM */,data->simulationInfo->realParameter[38] /* LiftCold.eff PARAM */,"LiftCold.eff",equationIndexes))));
  TRACE_POP
}
/*
equation index: 4265
type: SIMPLE_ASSIGN
powerBlock.m_sup = (-LiftCold.fluid_b.m_flow) >= powerBlock.exchanger.m_HTF_des * powerBlock.nu_min
*/
void PhysicalParticleCO21D_v11_eqFunction_4265(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4265};
  modelica_boolean tmp209;
  RELATIONHYSTERESIS(tmp209, (-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */), (data->simulationInfo->realParameter[658] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[694] /* powerBlock.nu_min PARAM */), 25, GreaterEq);
  data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ = tmp209;
  TRACE_POP
}
/*
equation index: 4266
type: SIMPLE_ASSIGN
powerBlock.exchanger.h_HTF[2] = if powerBlock.m_sup then tankHot.medium.h else powerBlock.exchanger.h_in_HTF_des
*/
void PhysicalParticleCO21D_v11_eqFunction_4266(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4266};
  data->localData[0]->realVars[1285] /* powerBlock.exchanger.h_HTF[2] variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */:data->simulationInfo->realParameter[654] /* powerBlock.exchanger.h_in_HTF_des PARAM */);
  TRACE_POP
}
/*
equation index: 4267
type: SIMPLE_ASSIGN
powerBlock.exchanger.m_HTF_bis = if powerBlock.m_sup then -LiftCold.fluid_b.m_flow else powerBlock.exchanger.m_HTF_des
*/
void PhysicalParticleCO21D_v11_eqFunction_4267(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4267};
  data->localData[0]->realVars[1286] /* powerBlock.exchanger.m_HTF_bis variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?(-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */):data->simulationInfo->realParameter[658] /* powerBlock.exchanger.m_HTF_des PARAM */);
  TRACE_POP
}
void PhysicalParticleCO21D_v11_eqFunction_4268(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4269(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4270(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4271(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4272(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4273(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4274(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4275(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4276(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4277(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4278(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4279(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4280(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4281(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4282(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4283(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4284(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4285(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4286(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4287(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4288(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4289(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4290(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4291(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4292(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4293(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4294(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4295(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4296(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4297(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4298(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4299(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4300(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4301(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4302(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4303(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4304(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4305(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4306(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4307(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4308(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4309(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4310(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4311(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4312(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4313(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4314(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4315(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4316(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4317(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4318(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4319(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4320(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4321(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4322(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4323(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4324(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4325(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4326(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4327(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4328(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4329(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4330(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4331(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4368(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4367(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4366(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4365(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4364(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4363(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4362(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4361(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4360(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4359(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4358(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4357(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4356(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4355(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4354(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4353(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4352(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4351(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4350(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4349(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4348(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4347(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4346(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4345(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4344(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4343(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4342(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4341(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4340(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4339(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4338(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4337(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4336(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4335(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4334(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4333(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4332(DATA*, threadData_t*);
/*
equation index: 4369
indexNonlinear: 45
type: NONLINEAR

vars: {powerBlock.exchanger.h_CO2[2], powerBlock.LTR.h_from_turb[1], powerBlock.exchanger.CO2_port_b.m_flow, powerBlock.LTR.h_from_comp[2], powerBlock.reCompressor.p_out, powerBlock.HTR.h_from_comp[2], powerBlock.HTR.h_from_turb[2], powerBlock.HTR.h_from_comp[3], powerBlock.HTR.h_from_turb[4], powerBlock.HTR.h_from_turb[3], powerBlock.HTR.h_from_comp[4], powerBlock.HTR.h_from_turb[5], powerBlock.HTR.h_from_turb[6], powerBlock.HTR.h_from_comp[6], powerBlock.HTR.h_from_comp[7], powerBlock.HTR.h_from_turb[7], powerBlock.HTR.h_from_comp[8], powerBlock.HTR.h_from_comp[9], powerBlock.HTR.h_from_turb[8], powerBlock.HTR.h_from_turb[9], powerBlock.HTR.h_from_comp[10], powerBlock.HTR.h_from_turb[10], powerBlock.HTR.h_from_turb[11], powerBlock.HTR.h_from_comp[11], powerBlock.HTR.h_from_turb[12], powerBlock.HTR.h_from_comp[13], powerBlock.HTR.h_from_comp[12], powerBlock.HTR.h_from_turb[14], powerBlock.HTR.h_from_turb[13], powerBlock.HTR.h_from_comp[14], powerBlock.exchanger.h_CO2[1], powerBlock.exchanger.h_HTF[1], powerBlock.HTR.h_from_comp[5], powerBlock.mainCompressor.p_out, powerBlock.turbine.p_out, powerBlock.LTR.h_from_turb[2], powerBlock.turbine.C_spouting}
eqns: {4268, 4269, 4270, 4271, 4272, 4273, 4274, 4275, 4276, 4277, 4278, 4279, 4280, 4281, 4282, 4283, 4284, 4285, 4286, 4287, 4288, 4289, 4290, 4291, 4292, 4293, 4294, 4295, 4296, 4297, 4298, 4299, 4300, 4301, 4302, 4303, 4304, 4305, 4306, 4307, 4308, 4309, 4310, 4311, 4312, 4313, 4314, 4315, 4316, 4317, 4318, 4319, 4320, 4321, 4322, 4323, 4324, 4325, 4326, 4327, 4328, 4329, 4330, 4331, 4368, 4367, 4366, 4365, 4364, 4363, 4362, 4361, 4360, 4359, 4358, 4357, 4356, 4355, 4354, 4353, 4352, 4351, 4350, 4349, 4348, 4347, 4346, 4345, 4344, 4343, 4342, 4341, 4340, 4339, 4338, 4337, 4336, 4335, 4334, 4333, 4332}
*/
void PhysicalParticleCO21D_v11_eqFunction_4369(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4369};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 4369 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[0] = data->localData[0]->realVars[1283] /* powerBlock.exchanger.h_CO2[2] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[1] = data->localData[0]->realVars[1266] /* powerBlock.LTR.h_from_turb[1] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[2] = data->localData[0]->realVars[1275] /* powerBlock.exchanger.CO2_port_b.m_flow variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[3] = data->localData[0]->realVars[1265] /* powerBlock.LTR.h_from_comp[2] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[4] = data->localData[0]->realVars[1303] /* powerBlock.reCompressor.p_out variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[5] = data->localData[0]->realVars[1230] /* powerBlock.HTR.h_from_comp[2] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[6] = data->localData[0]->realVars[1243] /* powerBlock.HTR.h_from_turb[2] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[7] = data->localData[0]->realVars[1231] /* powerBlock.HTR.h_from_comp[3] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[8] = data->localData[0]->realVars[1245] /* powerBlock.HTR.h_from_turb[4] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[9] = data->localData[0]->realVars[1244] /* powerBlock.HTR.h_from_turb[3] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[10] = data->localData[0]->realVars[1232] /* powerBlock.HTR.h_from_comp[4] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[11] = data->localData[0]->realVars[1246] /* powerBlock.HTR.h_from_turb[5] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[12] = data->localData[0]->realVars[1247] /* powerBlock.HTR.h_from_turb[6] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[13] = data->localData[0]->realVars[1234] /* powerBlock.HTR.h_from_comp[6] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[14] = data->localData[0]->realVars[1235] /* powerBlock.HTR.h_from_comp[7] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[15] = data->localData[0]->realVars[1248] /* powerBlock.HTR.h_from_turb[7] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[16] = data->localData[0]->realVars[1236] /* powerBlock.HTR.h_from_comp[8] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[17] = data->localData[0]->realVars[1237] /* powerBlock.HTR.h_from_comp[9] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[18] = data->localData[0]->realVars[1249] /* powerBlock.HTR.h_from_turb[8] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[19] = data->localData[0]->realVars[1250] /* powerBlock.HTR.h_from_turb[9] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[20] = data->localData[0]->realVars[1238] /* powerBlock.HTR.h_from_comp[10] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[21] = data->localData[0]->realVars[1251] /* powerBlock.HTR.h_from_turb[10] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[22] = data->localData[0]->realVars[1252] /* powerBlock.HTR.h_from_turb[11] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[23] = data->localData[0]->realVars[1239] /* powerBlock.HTR.h_from_comp[11] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[24] = data->localData[0]->realVars[1253] /* powerBlock.HTR.h_from_turb[12] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[25] = data->localData[0]->realVars[1241] /* powerBlock.HTR.h_from_comp[13] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[26] = data->localData[0]->realVars[1240] /* powerBlock.HTR.h_from_comp[12] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[27] = data->localData[0]->realVars[1255] /* powerBlock.HTR.h_from_turb[14] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[28] = data->localData[0]->realVars[1254] /* powerBlock.HTR.h_from_turb[13] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[29] = data->localData[0]->realVars[1242] /* powerBlock.HTR.h_from_comp[14] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[30] = data->localData[0]->realVars[1282] /* powerBlock.exchanger.h_CO2[1] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[31] = data->localData[0]->realVars[1284] /* powerBlock.exchanger.h_HTF[1] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[32] = data->localData[0]->realVars[1233] /* powerBlock.HTR.h_from_comp[5] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[33] = data->localData[0]->realVars[1293] /* powerBlock.mainCompressor.p_out variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[34] = data->localData[0]->realVars[1316] /* powerBlock.turbine.p_out variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[35] = data->localData[0]->realVars[1267] /* powerBlock.LTR.h_from_turb[2] variable */;
  data->simulationInfo->nonlinearSystemData[45].nlsxOld[36] = data->localData[0]->realVars[1311] /* powerBlock.turbine.C_spouting variable */;
  retValue = solve_nonlinear_system(data, threadData, 45);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,4369};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 4369 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[1283] /* powerBlock.exchanger.h_CO2[2] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[0];
  data->localData[0]->realVars[1266] /* powerBlock.LTR.h_from_turb[1] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[1];
  data->localData[0]->realVars[1275] /* powerBlock.exchanger.CO2_port_b.m_flow variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[2];
  data->localData[0]->realVars[1265] /* powerBlock.LTR.h_from_comp[2] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[3];
  data->localData[0]->realVars[1303] /* powerBlock.reCompressor.p_out variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[4];
  data->localData[0]->realVars[1230] /* powerBlock.HTR.h_from_comp[2] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[5];
  data->localData[0]->realVars[1243] /* powerBlock.HTR.h_from_turb[2] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[6];
  data->localData[0]->realVars[1231] /* powerBlock.HTR.h_from_comp[3] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[7];
  data->localData[0]->realVars[1245] /* powerBlock.HTR.h_from_turb[4] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[8];
  data->localData[0]->realVars[1244] /* powerBlock.HTR.h_from_turb[3] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[9];
  data->localData[0]->realVars[1232] /* powerBlock.HTR.h_from_comp[4] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[10];
  data->localData[0]->realVars[1246] /* powerBlock.HTR.h_from_turb[5] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[11];
  data->localData[0]->realVars[1247] /* powerBlock.HTR.h_from_turb[6] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[12];
  data->localData[0]->realVars[1234] /* powerBlock.HTR.h_from_comp[6] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[13];
  data->localData[0]->realVars[1235] /* powerBlock.HTR.h_from_comp[7] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[14];
  data->localData[0]->realVars[1248] /* powerBlock.HTR.h_from_turb[7] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[15];
  data->localData[0]->realVars[1236] /* powerBlock.HTR.h_from_comp[8] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[16];
  data->localData[0]->realVars[1237] /* powerBlock.HTR.h_from_comp[9] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[17];
  data->localData[0]->realVars[1249] /* powerBlock.HTR.h_from_turb[8] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[18];
  data->localData[0]->realVars[1250] /* powerBlock.HTR.h_from_turb[9] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[19];
  data->localData[0]->realVars[1238] /* powerBlock.HTR.h_from_comp[10] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[20];
  data->localData[0]->realVars[1251] /* powerBlock.HTR.h_from_turb[10] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[21];
  data->localData[0]->realVars[1252] /* powerBlock.HTR.h_from_turb[11] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[22];
  data->localData[0]->realVars[1239] /* powerBlock.HTR.h_from_comp[11] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[23];
  data->localData[0]->realVars[1253] /* powerBlock.HTR.h_from_turb[12] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[24];
  data->localData[0]->realVars[1241] /* powerBlock.HTR.h_from_comp[13] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[25];
  data->localData[0]->realVars[1240] /* powerBlock.HTR.h_from_comp[12] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[26];
  data->localData[0]->realVars[1255] /* powerBlock.HTR.h_from_turb[14] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[27];
  data->localData[0]->realVars[1254] /* powerBlock.HTR.h_from_turb[13] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[28];
  data->localData[0]->realVars[1242] /* powerBlock.HTR.h_from_comp[14] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[29];
  data->localData[0]->realVars[1282] /* powerBlock.exchanger.h_CO2[1] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[30];
  data->localData[0]->realVars[1284] /* powerBlock.exchanger.h_HTF[1] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[31];
  data->localData[0]->realVars[1233] /* powerBlock.HTR.h_from_comp[5] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[32];
  data->localData[0]->realVars[1293] /* powerBlock.mainCompressor.p_out variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[33];
  data->localData[0]->realVars[1316] /* powerBlock.turbine.p_out variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[34];
  data->localData[0]->realVars[1267] /* powerBlock.LTR.h_from_turb[2] variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[35];
  data->localData[0]->realVars[1311] /* powerBlock.turbine.C_spouting variable */ = data->simulationInfo->nonlinearSystemData[45].nlsx[36];
  TRACE_POP
}
/*
equation index: 4370
type: SIMPLE_ASSIGN
powerBlock.HTR.Q_HX = powerBlock.exchanger.CO2_port_b.m_flow * (powerBlock.LTR.h_from_turb[2] - powerBlock.HTR.h_from_turb[15])
*/
void PhysicalParticleCO21D_v11_eqFunction_4370(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4370};
  data->localData[0]->realVars[1182] /* powerBlock.HTR.Q_HX variable */ = (data->localData[0]->realVars[1275] /* powerBlock.exchanger.CO2_port_b.m_flow variable */) * (data->localData[0]->realVars[1267] /* powerBlock.LTR.h_from_turb[2] variable */ - data->localData[0]->realVars[1256] /* powerBlock.HTR.h_from_turb[15] variable */);
  TRACE_POP
}
/*
equation index: 4371
type: SIMPLE_ASSIGN
$cse12 = SolarTherm.Media.CO2.CO2_utilities.T_p_h(powerBlock.turbine.p_out, powerBlock.mainCompressor.state_a.h, tableIDT_p_h)
*/
void PhysicalParticleCO21D_v11_eqFunction_4371(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4371};
  data->localData[0]->realVars[42] /* $cse12 variable */ = omc_SolarTherm_Media_CO2_CO2__utilities_T__p__h(threadData, data->localData[0]->realVars[1316] /* powerBlock.turbine.p_out variable */, data->localData[0]->realVars[1298] /* powerBlock.mainCompressor.state_a.h variable */, data->simulationInfo->extObjs[84]);
  TRACE_POP
}
/*
equation index: 4372
type: SIMPLE_ASSIGN
powerBlock.cooler.deltaT[2] = $cse12 - particleReceiver1D_v11.Tamb
*/
void PhysicalParticleCO21D_v11_eqFunction_4372(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4372};
  data->localData[0]->realVars[1272] /* powerBlock.cooler.deltaT[2] variable */ = data->localData[0]->realVars[42] /* $cse12 variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */;
  TRACE_POP
}
/*
equation index: 4373
type: SIMPLE_ASSIGN
powerBlock.mainCompressor.W_comp = powerBlock.cooler.port_b.m_flow * (powerBlock.mainCompressor.state_a.h - powerBlock.LTR.h_from_comp[1])
*/
void PhysicalParticleCO21D_v11_eqFunction_4373(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4373};
  data->localData[0]->realVars[1290] /* powerBlock.mainCompressor.W_comp variable */ = (data->localData[0]->realVars[1273] /* powerBlock.cooler.port_b.m_flow variable */) * (data->localData[0]->realVars[1298] /* powerBlock.mainCompressor.state_a.h variable */ - data->localData[0]->realVars[1264] /* powerBlock.LTR.h_from_comp[1] variable */);
  TRACE_POP
}
/*
equation index: 4374
type: SIMPLE_ASSIGN
powerBlock.fluid_b.h_outflow = if powerBlock.m_sup then powerBlock.exchanger.h_HTF[1] else tankHot.medium.h
*/
void PhysicalParticleCO21D_v11_eqFunction_4374(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4374};
  data->localData[0]->realVars[1289] /* powerBlock.fluid_b.h_outflow variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?data->localData[0]->realVars[1284] /* powerBlock.exchanger.h_HTF[1] variable */:data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */);
  TRACE_POP
}
/*
equation index: 4375
type: SIMPLE_ASSIGN
$DER.E_pb_input = if powerBlock.m_sup == true then powerBlock.exchanger.Q_HX else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4375(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4375};
  data->localData[0]->realVars[22] /* der(E_pb_input) STATE_DER */ = (((!data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && !1) || (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && 1))?data->localData[0]->realVars[1276] /* powerBlock.exchanger.Q_HX variable */:0.0);
  TRACE_POP
}
/*
equation index: 4376
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[15] = powerBlock.HTR.T_from_turb[15] - powerBlock.HTR.T_from_comp[15]
*/
void PhysicalParticleCO21D_v11_eqFunction_4376(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4376};
  data->localData[0]->realVars[1227] /* powerBlock.HTR.deltaT[15] variable */ = data->localData[0]->realVars[1212] /* powerBlock.HTR.T_from_turb[15] variable */ - data->localData[0]->realVars[1197] /* powerBlock.HTR.T_from_comp[15] variable */;
  TRACE_POP
}
/*
equation index: 4377
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[14] = powerBlock.HTR.T_from_turb[14] - powerBlock.HTR.T_from_comp[14]
*/
void PhysicalParticleCO21D_v11_eqFunction_4377(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4377};
  data->localData[0]->realVars[1226] /* powerBlock.HTR.deltaT[14] variable */ = data->localData[0]->realVars[1211] /* powerBlock.HTR.T_from_turb[14] variable */ - data->localData[0]->realVars[1196] /* powerBlock.HTR.T_from_comp[14] variable */;
  TRACE_POP
}
/*
equation index: 4378
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[12] = powerBlock.HTR.T_from_turb[12] - powerBlock.HTR.T_from_comp[12]
*/
void PhysicalParticleCO21D_v11_eqFunction_4378(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4378};
  data->localData[0]->realVars[1224] /* powerBlock.HTR.deltaT[12] variable */ = data->localData[0]->realVars[1209] /* powerBlock.HTR.T_from_turb[12] variable */ - data->localData[0]->realVars[1194] /* powerBlock.HTR.T_from_comp[12] variable */;
  TRACE_POP
}
/*
equation index: 4379
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[13] = powerBlock.HTR.T_from_turb[13] - powerBlock.HTR.T_from_comp[13]
*/
void PhysicalParticleCO21D_v11_eqFunction_4379(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4379};
  data->localData[0]->realVars[1225] /* powerBlock.HTR.deltaT[13] variable */ = data->localData[0]->realVars[1210] /* powerBlock.HTR.T_from_turb[13] variable */ - data->localData[0]->realVars[1195] /* powerBlock.HTR.T_from_comp[13] variable */;
  TRACE_POP
}
/*
equation index: 4380
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[11] = powerBlock.HTR.T_from_turb[11] - powerBlock.HTR.T_from_comp[11]
*/
void PhysicalParticleCO21D_v11_eqFunction_4380(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4380};
  data->localData[0]->realVars[1223] /* powerBlock.HTR.deltaT[11] variable */ = data->localData[0]->realVars[1208] /* powerBlock.HTR.T_from_turb[11] variable */ - data->localData[0]->realVars[1193] /* powerBlock.HTR.T_from_comp[11] variable */;
  TRACE_POP
}
/*
equation index: 4381
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[10] = powerBlock.HTR.T_from_turb[10] - powerBlock.HTR.T_from_comp[10]
*/
void PhysicalParticleCO21D_v11_eqFunction_4381(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4381};
  data->localData[0]->realVars[1222] /* powerBlock.HTR.deltaT[10] variable */ = data->localData[0]->realVars[1207] /* powerBlock.HTR.T_from_turb[10] variable */ - data->localData[0]->realVars[1192] /* powerBlock.HTR.T_from_comp[10] variable */;
  TRACE_POP
}
/*
equation index: 4382
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[8] = powerBlock.HTR.T_from_turb[8] - powerBlock.HTR.T_from_comp[8]
*/
void PhysicalParticleCO21D_v11_eqFunction_4382(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4382};
  data->localData[0]->realVars[1220] /* powerBlock.HTR.deltaT[8] variable */ = data->localData[0]->realVars[1205] /* powerBlock.HTR.T_from_turb[8] variable */ - data->localData[0]->realVars[1190] /* powerBlock.HTR.T_from_comp[8] variable */;
  TRACE_POP
}
/*
equation index: 4383
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[9] = powerBlock.HTR.T_from_turb[9] - powerBlock.HTR.T_from_comp[9]
*/
void PhysicalParticleCO21D_v11_eqFunction_4383(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4383};
  data->localData[0]->realVars[1221] /* powerBlock.HTR.deltaT[9] variable */ = data->localData[0]->realVars[1206] /* powerBlock.HTR.T_from_turb[9] variable */ - data->localData[0]->realVars[1191] /* powerBlock.HTR.T_from_comp[9] variable */;
  TRACE_POP
}
/*
equation index: 4384
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[7] = powerBlock.HTR.T_from_turb[7] - powerBlock.HTR.T_from_comp[7]
*/
void PhysicalParticleCO21D_v11_eqFunction_4384(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4384};
  data->localData[0]->realVars[1219] /* powerBlock.HTR.deltaT[7] variable */ = data->localData[0]->realVars[1204] /* powerBlock.HTR.T_from_turb[7] variable */ - data->localData[0]->realVars[1189] /* powerBlock.HTR.T_from_comp[7] variable */;
  TRACE_POP
}
/*
equation index: 4385
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[6] = powerBlock.HTR.T_from_turb[6] - powerBlock.HTR.T_from_comp[6]
*/
void PhysicalParticleCO21D_v11_eqFunction_4385(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4385};
  data->localData[0]->realVars[1218] /* powerBlock.HTR.deltaT[6] variable */ = data->localData[0]->realVars[1203] /* powerBlock.HTR.T_from_turb[6] variable */ - data->localData[0]->realVars[1188] /* powerBlock.HTR.T_from_comp[6] variable */;
  TRACE_POP
}
/*
equation index: 4386
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[5] = powerBlock.HTR.T_from_turb[5] - powerBlock.HTR.T_from_comp[5]
*/
void PhysicalParticleCO21D_v11_eqFunction_4386(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4386};
  data->localData[0]->realVars[1217] /* powerBlock.HTR.deltaT[5] variable */ = data->localData[0]->realVars[1202] /* powerBlock.HTR.T_from_turb[5] variable */ - data->localData[0]->realVars[1187] /* powerBlock.HTR.T_from_comp[5] variable */;
  TRACE_POP
}
/*
equation index: 4387
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[4] = powerBlock.HTR.T_from_turb[4] - powerBlock.HTR.T_from_comp[4]
*/
void PhysicalParticleCO21D_v11_eqFunction_4387(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4387};
  data->localData[0]->realVars[1216] /* powerBlock.HTR.deltaT[4] variable */ = data->localData[0]->realVars[1201] /* powerBlock.HTR.T_from_turb[4] variable */ - data->localData[0]->realVars[1186] /* powerBlock.HTR.T_from_comp[4] variable */;
  TRACE_POP
}
/*
equation index: 4388
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[3] = powerBlock.HTR.T_from_turb[3] - powerBlock.HTR.T_from_comp[3]
*/
void PhysicalParticleCO21D_v11_eqFunction_4388(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4388};
  data->localData[0]->realVars[1215] /* powerBlock.HTR.deltaT[3] variable */ = data->localData[0]->realVars[1200] /* powerBlock.HTR.T_from_turb[3] variable */ - data->localData[0]->realVars[1185] /* powerBlock.HTR.T_from_comp[3] variable */;
  TRACE_POP
}
/*
equation index: 4389
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[2] = powerBlock.HTR.T_from_turb[2] - powerBlock.HTR.T_from_comp[2]
*/
void PhysicalParticleCO21D_v11_eqFunction_4389(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4389};
  data->localData[0]->realVars[1214] /* powerBlock.HTR.deltaT[2] variable */ = data->localData[0]->realVars[1199] /* powerBlock.HTR.T_from_turb[2] variable */ - data->localData[0]->realVars[1184] /* powerBlock.HTR.T_from_comp[2] variable */;
  TRACE_POP
}
/*
equation index: 4390
type: SIMPLE_ASSIGN
powerBlock.cooler.deltaT[1] = powerBlock.LTR.T_from_turb[1] - particleReceiver1D_v11.Tamb
*/
void PhysicalParticleCO21D_v11_eqFunction_4390(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4390};
  data->localData[0]->realVars[1271] /* powerBlock.cooler.deltaT[1] variable */ = data->localData[0]->realVars[1260] /* powerBlock.LTR.T_from_turb[1] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */;
  TRACE_POP
}
/*
equation index: 4391
type: SIMPLE_ASSIGN
powerBlock.LTR.deltaT[1] = powerBlock.LTR.T_from_turb[1] - powerBlock.LTR.T_from_comp[1]
*/
void PhysicalParticleCO21D_v11_eqFunction_4391(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4391};
  data->localData[0]->realVars[1262] /* powerBlock.LTR.deltaT[1] variable */ = data->localData[0]->realVars[1260] /* powerBlock.LTR.T_from_turb[1] variable */ - data->localData[0]->realVars[1258] /* powerBlock.LTR.T_from_comp[1] variable */;
  TRACE_POP
}
/*
equation index: 4392
type: SIMPLE_ASSIGN
powerBlock.cooler.Q_cooler = powerBlock.cooler.port_b.m_flow * (powerBlock.LTR.h_from_turb[1] - powerBlock.mainCompressor.state_a.h)
*/
void PhysicalParticleCO21D_v11_eqFunction_4392(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4392};
  data->localData[0]->realVars[1270] /* powerBlock.cooler.Q_cooler variable */ = (data->localData[0]->realVars[1273] /* powerBlock.cooler.port_b.m_flow variable */) * (data->localData[0]->realVars[1266] /* powerBlock.LTR.h_from_turb[1] variable */ - data->localData[0]->realVars[1298] /* powerBlock.mainCompressor.state_a.h variable */);
  TRACE_POP
}
/*
equation index: 4393
type: SIMPLE_ASSIGN
powerBlock.reCompressor.W_comp = powerBlock.splitter.gamma_port_b.m_flow * (powerBlock.LTR.h_from_turb[1] - powerBlock.reCompressor.state_b.h)
*/
void PhysicalParticleCO21D_v11_eqFunction_4393(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4393};
  data->localData[0]->realVars[1300] /* powerBlock.reCompressor.W_comp variable */ = (data->localData[0]->realVars[1310] /* powerBlock.splitter.gamma_port_b.m_flow variable */) * (data->localData[0]->realVars[1266] /* powerBlock.LTR.h_from_turb[1] variable */ - data->localData[0]->realVars[1308] /* powerBlock.reCompressor.state_b.h variable */);
  TRACE_POP
}
/*
equation index: 4394
type: SIMPLE_ASSIGN
powerBlock.W_total_compressor = powerBlock.mainCompressor.W_comp + powerBlock.reCompressor.W_comp
*/
void PhysicalParticleCO21D_v11_eqFunction_4394(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4394};
  data->localData[0]->realVars[1268] /* powerBlock.W_total_compressor variable */ = data->localData[0]->realVars[1290] /* powerBlock.mainCompressor.W_comp variable */ + data->localData[0]->realVars[1300] /* powerBlock.reCompressor.W_comp variable */;
  TRACE_POP
}
/*
equation index: 4395
type: SIMPLE_ASSIGN
powerBlock.LTR.deltaT[2] = powerBlock.HTR.T_from_turb[1] - powerBlock.LTR.T_from_comp[2]
*/
void PhysicalParticleCO21D_v11_eqFunction_4395(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4395};
  data->localData[0]->realVars[1263] /* powerBlock.LTR.deltaT[2] variable */ = data->localData[0]->realVars[1198] /* powerBlock.HTR.T_from_turb[1] variable */ - data->localData[0]->realVars[1259] /* powerBlock.LTR.T_from_comp[2] variable */;
  TRACE_POP
}
/*
equation index: 4396
type: SIMPLE_ASSIGN
powerBlock.LTR.T_from_turb[2] = powerBlock.HTR.T_from_turb[1]
*/
void PhysicalParticleCO21D_v11_eqFunction_4396(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4396};
  data->localData[0]->realVars[1261] /* powerBlock.LTR.T_from_turb[2] variable */ = data->localData[0]->realVars[1198] /* powerBlock.HTR.T_from_turb[1] variable */;
  TRACE_POP
}
/*
equation index: 4397
type: SIMPLE_ASSIGN
powerBlock.HTR.deltaT[1] = powerBlock.HTR.T_from_turb[1] - powerBlock.HTR.T_from_comp[1]
*/
void PhysicalParticleCO21D_v11_eqFunction_4397(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4397};
  data->localData[0]->realVars[1213] /* powerBlock.HTR.deltaT[1] variable */ = data->localData[0]->realVars[1198] /* powerBlock.HTR.T_from_turb[1] variable */ - data->localData[0]->realVars[1183] /* powerBlock.HTR.T_from_comp[1] variable */;
  TRACE_POP
}
/*
equation index: 4398
type: SIMPLE_ASSIGN
powerBlock.turbine.W_turb = powerBlock.exchanger.CO2_port_b.m_flow * (powerBlock.exchanger.h_CO2[2] - powerBlock.HTR.h_from_turb[15])
*/
void PhysicalParticleCO21D_v11_eqFunction_4398(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4398};
  data->localData[0]->realVars[1312] /* powerBlock.turbine.W_turb variable */ = (data->localData[0]->realVars[1275] /* powerBlock.exchanger.CO2_port_b.m_flow variable */) * (data->localData[0]->realVars[1283] /* powerBlock.exchanger.h_CO2[2] variable */ - data->localData[0]->realVars[1256] /* powerBlock.HTR.h_from_turb[15] variable */);
  TRACE_POP
}
/*
equation index: 4399
type: SIMPLE_ASSIGN
powerBlock.turbine.W_turb_abs = abs(powerBlock.turbine.W_turb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4399(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4399};
  data->localData[0]->realVars[1313] /* powerBlock.turbine.W_turb_abs variable */ = fabs(data->localData[0]->realVars[1312] /* powerBlock.turbine.W_turb variable */);
  TRACE_POP
}
/*
equation index: 4400
type: SIMPLE_ASSIGN
P_elec = if powerBlock.m_sup then (-powerBlock.turbine.W_turb) - powerBlock.reCompressor.W_comp - powerBlock.mainCompressor.W_comp else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4400(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4400};
  data->localData[0]->realVars[56] /* P_elec variable */ = (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */?(-data->localData[0]->realVars[1312] /* powerBlock.turbine.W_turb variable */) - data->localData[0]->realVars[1300] /* powerBlock.reCompressor.W_comp variable */ - data->localData[0]->realVars[1290] /* powerBlock.mainCompressor.W_comp variable */:0.0);
  TRACE_POP
}
/*
equation index: 4401
type: SIMPLE_ASSIGN
powerBlock.eta_cycle = P_elec / powerBlock.exchanger.Q_HX
*/
void PhysicalParticleCO21D_v11_eqFunction_4401(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4401};
  data->localData[0]->realVars[1274] /* powerBlock.eta_cycle variable */ = DIVISION_SIM(data->localData[0]->realVars[56] /* P_elec variable */,data->localData[0]->realVars[1276] /* powerBlock.exchanger.Q_HX variable */,"powerBlock.exchanger.Q_HX",equationIndexes);
  TRACE_POP
}
/*
equation index: 4402
type: SIMPLE_ASSIGN
$DER.powerBlock.E_net = P_elec
*/
void PhysicalParticleCO21D_v11_eqFunction_4402(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4402};
  data->localData[0]->realVars[29] /* der(powerBlock.E_net) STATE_DER */ = data->localData[0]->realVars[56] /* P_elec variable */;
  TRACE_POP
}
/*
equation index: 4403
type: SIMPLE_ASSIGN
$DER.market.profit = 2.777777777777778e-10 * P_elec * market.price.price_annual
*/
void PhysicalParticleCO21D_v11_eqFunction_4403(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4403};
  data->localData[0]->realVars[28] /* der(market.profit) STATE_DER */ = (2.777777777777778e-10) * ((data->localData[0]->realVars[56] /* P_elec variable */) * (data->simulationInfo->realParameter[187] /* market.price.price_annual PARAM */));
  TRACE_POP
}
/*
equation index: 4404
type: SIMPLE_ASSIGN
$DER.E_pb_net = P_elec
*/
void PhysicalParticleCO21D_v11_eqFunction_4404(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4404};
  data->localData[0]->realVars[23] /* der(E_pb_net) STATE_DER */ = data->localData[0]->realVars[56] /* P_elec variable */;
  TRACE_POP
}
/*
equation index: 4405
type: SIMPLE_ASSIGN
$DER.E_elec = P_elec
*/
void PhysicalParticleCO21D_v11_eqFunction_4405(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4405};
  data->localData[0]->realVars[17] /* der(E_elec) STATE_DER */ = data->localData[0]->realVars[56] /* P_elec variable */;
  TRACE_POP
}
/*
equation index: 4406
type: SIMPLE_ASSIGN
$DER.E_pb_gross = if powerBlock.m_sup == true then -powerBlock.turbine.W_turb else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4406(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4406};
  data->localData[0]->realVars[21] /* der(E_pb_gross) STATE_DER */ = (((!data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && !1) || (data->localData[0]->booleanVars[25] /* powerBlock.m_sup DISCRETE */ && 1))?(-data->localData[0]->realVars[1312] /* powerBlock.turbine.W_turb variable */):0.0);
  TRACE_POP
}
/*
equation index: 4407
type: SIMPLE_ASSIGN
powerBlock.exchanger.deltaTAve = 0.5 * (powerBlock.exchanger.deltaT[1] + powerBlock.exchanger.deltaT[2])
*/
void PhysicalParticleCO21D_v11_eqFunction_4407(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4407};
  data->localData[0]->realVars[1281] /* powerBlock.exchanger.deltaTAve variable */ = (0.5) * (data->localData[0]->realVars[1279] /* powerBlock.exchanger.deltaT[1] variable */ + data->localData[0]->realVars[1280] /* powerBlock.exchanger.deltaT[2] variable */);
  TRACE_POP
}
/*
equation index: 4408
type: SIMPLE_ASSIGN
$DER.tankCold.medium.h = (tankCold.Q_losses + tankCold.W_net + (-LiftCold.fluid_b.m_flow) * powerBlock.fluid_b.h_outflow - particleReceiver1D_v11.mdot * tankCold.medium.h - der(tankCold.m) * tankCold.medium.h) / tankCold.m
*/
void PhysicalParticleCO21D_v11_eqFunction_4408(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4408};
  data->localData[0]->realVars[31] /* der(tankCold.medium.h) STATE_DER */ = DIVISION_SIM(data->localData[0]->realVars[1331] /* tankCold.Q_losses variable */ + data->localData[0]->realVars[1334] /* tankCold.W_net variable */ + ((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */)) * (data->localData[0]->realVars[1289] /* powerBlock.fluid_b.h_outflow variable */) - ((data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */) * (data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */)) - ((data->localData[0]->realVars[30] /* der(tankCold.m) STATE_DER */) * (data->localData[0]->realVars[14] /* tankCold.medium.h STATE(1) */)),data->localData[0]->realVars[13] /* tankCold.m STATE(1) */,"tankCold.m",equationIndexes);
  TRACE_POP
}
/*
equation index: 4409
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_solar = heliostatsField.Q_incident / particleReceiver1D_v11.A_ap
*/
void PhysicalParticleCO21D_v11_eqFunction_4409(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4409};
  data->localData[0]->realVars[1077] /* particleReceiver1D_v11.q_solar variable */ = DIVISION_SIM(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */,data->localData[0]->realVars[678] /* particleReceiver1D_v11.A_ap variable */,"particleReceiver1D_v11.A_ap",equationIndexes);
  TRACE_POP
}
/*
equation index: 4410
type: SIMPLE_ASSIGN
particleReceiver1D_v11.gc_f[20] = if heliostatsField.on_internal then particleReceiver1D_v11.q_solar else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4410(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4410};
  data->localData[0]->realVars[893] /* particleReceiver1D_v11.gc_f[20] variable */ = (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */?data->localData[0]->realVars[1077] /* particleReceiver1D_v11.q_solar variable */:0.0);
  TRACE_POP
}
void PhysicalParticleCO21D_v11_eqFunction_4411(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4412(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4413(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4414(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4415(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4416(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4417(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4418(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4419(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4420(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4421(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4422(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4423(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4424(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4425(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4426(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4427(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4428(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4429(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4430(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4431(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4432(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4433(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4434(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4435(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4436(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4437(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4438(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4439(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4440(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4441(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4442(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4443(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4444(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4445(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4446(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4447(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4448(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4449(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4450(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4451(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4452(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4453(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4454(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4455(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4456(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4457(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4458(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4459(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4460(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4461(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4462(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4463(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4464(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4465(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4466(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4467(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4468(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4469(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4470(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4471(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4472(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4473(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4474(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4475(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4476(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4477(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4478(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4479(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4480(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4481(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4482(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4483(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4484(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4485(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4486(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4487(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4488(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4489(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4490(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4491(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4492(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4493(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4494(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4495(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4496(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4497(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4498(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4499(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4500(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4501(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4502(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4503(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4504(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4505(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4506(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4507(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4508(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4509(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4510(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4511(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4512(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4513(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4514(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4515(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4516(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4517(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4518(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4519(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4520(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4521(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4522(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4523(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4524(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4525(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4526(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4527(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4528(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4529(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4530(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4531(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4532(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4533(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4534(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4535(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4536(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4537(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4538(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4539(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4540(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4541(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4542(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4543(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4544(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4545(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4546(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4547(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4548(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4549(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4550(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4551(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4552(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4553(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4554(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4555(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4556(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4557(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4558(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4559(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4560(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4561(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4562(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4563(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4564(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4565(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4566(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4567(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4606(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4605(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4604(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4603(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4602(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4601(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4600(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4599(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4598(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4597(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4596(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4595(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4594(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4593(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4592(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4591(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4590(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4589(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4588(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4587(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4586(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4585(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4584(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4583(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4582(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4581(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4580(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4579(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4578(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4577(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4576(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4575(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4574(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4573(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4572(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4571(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4570(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4569(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4568(DATA*, threadData_t*);
/*
equation index: 4607
indexNonlinear: 46
type: NONLINEAR

vars: {particleReceiver1D_v11.T_s[20], particleReceiver1D_v11.T_s[2], particleReceiver1D_v11.T_w[1], particleReceiver1D_v11.T_s[19], particleReceiver1D_v11.T_w[22], particleReceiver1D_v11.T_s[3], particleReceiver1D_v11.T_s[4], particleReceiver1D_v11.T_s[5], particleReceiver1D_v11.T_s[6], particleReceiver1D_v11.T_s[7], particleReceiver1D_v11.T_s[10], particleReceiver1D_v11.T_s[9], particleReceiver1D_v11.T_s[8], particleReceiver1D_v11.T_s[12], particleReceiver1D_v11.T_s[11], particleReceiver1D_v11.T_s[14], particleReceiver1D_v11.T_s[13], particleReceiver1D_v11.T_s[17], particleReceiver1D_v11.T_s[16], particleReceiver1D_v11.T_s[15], particleReceiver1D_v11.T_s[18], particleReceiver1D_v11.T_w[3], particleReceiver1D_v11.T_w[4], particleReceiver1D_v11.T_w[5], particleReceiver1D_v11.T_w[6], particleReceiver1D_v11.T_w[7], particleReceiver1D_v11.T_w[8], particleReceiver1D_v11.T_w[9], particleReceiver1D_v11.T_w[10], particleReceiver1D_v11.T_w[11], particleReceiver1D_v11.T_w[12], particleReceiver1D_v11.T_w[13], particleReceiver1D_v11.T_w[14], particleReceiver1D_v11.T_w[15], particleReceiver1D_v11.T_w[16], particleReceiver1D_v11.T_w[17], particleReceiver1D_v11.T_w[18], particleReceiver1D_v11.T_w[19], particleReceiver1D_v11.T_w[20]}
eqns: {4411, 4412, 4413, 4414, 4415, 4416, 4417, 4418, 4419, 4420, 4421, 4422, 4423, 4424, 4425, 4426, 4427, 4428, 4429, 4430, 4431, 4432, 4433, 4434, 4435, 4436, 4437, 4438, 4439, 4440, 4441, 4442, 4443, 4444, 4445, 4446, 4447, 4448, 4449, 4450, 4451, 4452, 4453, 4454, 4455, 4456, 4457, 4458, 4459, 4460, 4461, 4462, 4463, 4464, 4465, 4466, 4467, 4468, 4469, 4470, 4471, 4472, 4473, 4474, 4475, 4476, 4477, 4478, 4479, 4480, 4481, 4482, 4483, 4484, 4485, 4486, 4487, 4488, 4489, 4490, 4491, 4492, 4493, 4494, 4495, 4496, 4497, 4498, 4499, 4500, 4501, 4502, 4503, 4504, 4505, 4506, 4507, 4508, 4509, 4510, 4511, 4512, 4513, 4514, 4515, 4516, 4517, 4518, 4519, 4520, 4521, 4522, 4523, 4524, 4525, 4526, 4527, 4528, 4529, 4530, 4531, 4532, 4533, 4534, 4535, 4536, 4537, 4538, 4539, 4540, 4541, 4542, 4543, 4544, 4545, 4546, 4547, 4548, 4549, 4550, 4551, 4552, 4553, 4554, 4555, 4556, 4557, 4558, 4559, 4560, 4561, 4562, 4563, 4564, 4565, 4566, 4567, 4606, 4605, 4604, 4603, 4602, 4601, 4600, 4599, 4598, 4597, 4596, 4595, 4594, 4593, 4592, 4591, 4590, 4589, 4588, 4587, 4586, 4585, 4584, 4583, 4582, 4581, 4580, 4579, 4578, 4577, 4576, 4575, 4574, 4573, 4572, 4571, 4570, 4569, 4568}
*/
void PhysicalParticleCO21D_v11_eqFunction_4607(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4607};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 4607 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[0] = data->localData[0]->realVars[786] /* particleReceiver1D_v11.T_s[20] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[1] = data->localData[0]->realVars[768] /* particleReceiver1D_v11.T_s[2] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[2] = data->localData[0]->realVars[788] /* particleReceiver1D_v11.T_w[1] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[3] = data->localData[0]->realVars[785] /* particleReceiver1D_v11.T_s[19] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[4] = data->localData[0]->realVars[807] /* particleReceiver1D_v11.T_w[22] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[5] = data->localData[0]->realVars[769] /* particleReceiver1D_v11.T_s[3] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[6] = data->localData[0]->realVars[770] /* particleReceiver1D_v11.T_s[4] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[7] = data->localData[0]->realVars[771] /* particleReceiver1D_v11.T_s[5] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[8] = data->localData[0]->realVars[772] /* particleReceiver1D_v11.T_s[6] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[9] = data->localData[0]->realVars[773] /* particleReceiver1D_v11.T_s[7] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[10] = data->localData[0]->realVars[776] /* particleReceiver1D_v11.T_s[10] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[11] = data->localData[0]->realVars[775] /* particleReceiver1D_v11.T_s[9] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[12] = data->localData[0]->realVars[774] /* particleReceiver1D_v11.T_s[8] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[13] = data->localData[0]->realVars[778] /* particleReceiver1D_v11.T_s[12] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[14] = data->localData[0]->realVars[777] /* particleReceiver1D_v11.T_s[11] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[15] = data->localData[0]->realVars[780] /* particleReceiver1D_v11.T_s[14] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[16] = data->localData[0]->realVars[779] /* particleReceiver1D_v11.T_s[13] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[17] = data->localData[0]->realVars[783] /* particleReceiver1D_v11.T_s[17] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[18] = data->localData[0]->realVars[782] /* particleReceiver1D_v11.T_s[16] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[19] = data->localData[0]->realVars[781] /* particleReceiver1D_v11.T_s[15] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[20] = data->localData[0]->realVars[784] /* particleReceiver1D_v11.T_s[18] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[21] = data->localData[0]->realVars[789] /* particleReceiver1D_v11.T_w[3] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[22] = data->localData[0]->realVars[790] /* particleReceiver1D_v11.T_w[4] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[23] = data->localData[0]->realVars[791] /* particleReceiver1D_v11.T_w[5] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[24] = data->localData[0]->realVars[792] /* particleReceiver1D_v11.T_w[6] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[25] = data->localData[0]->realVars[793] /* particleReceiver1D_v11.T_w[7] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[26] = data->localData[0]->realVars[794] /* particleReceiver1D_v11.T_w[8] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[27] = data->localData[0]->realVars[795] /* particleReceiver1D_v11.T_w[9] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[28] = data->localData[0]->realVars[796] /* particleReceiver1D_v11.T_w[10] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[29] = data->localData[0]->realVars[797] /* particleReceiver1D_v11.T_w[11] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[30] = data->localData[0]->realVars[798] /* particleReceiver1D_v11.T_w[12] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[31] = data->localData[0]->realVars[799] /* particleReceiver1D_v11.T_w[13] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[32] = data->localData[0]->realVars[800] /* particleReceiver1D_v11.T_w[14] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[33] = data->localData[0]->realVars[801] /* particleReceiver1D_v11.T_w[15] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[34] = data->localData[0]->realVars[802] /* particleReceiver1D_v11.T_w[16] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[35] = data->localData[0]->realVars[803] /* particleReceiver1D_v11.T_w[17] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[36] = data->localData[0]->realVars[804] /* particleReceiver1D_v11.T_w[18] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[37] = data->localData[0]->realVars[805] /* particleReceiver1D_v11.T_w[19] variable */;
  data->simulationInfo->nonlinearSystemData[46].nlsxOld[38] = data->localData[0]->realVars[806] /* particleReceiver1D_v11.T_w[20] variable */;
  retValue = solve_nonlinear_system(data, threadData, 46);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,4607};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 4607 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[786] /* particleReceiver1D_v11.T_s[20] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[0];
  data->localData[0]->realVars[768] /* particleReceiver1D_v11.T_s[2] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[1];
  data->localData[0]->realVars[788] /* particleReceiver1D_v11.T_w[1] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[2];
  data->localData[0]->realVars[785] /* particleReceiver1D_v11.T_s[19] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[3];
  data->localData[0]->realVars[807] /* particleReceiver1D_v11.T_w[22] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[4];
  data->localData[0]->realVars[769] /* particleReceiver1D_v11.T_s[3] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[5];
  data->localData[0]->realVars[770] /* particleReceiver1D_v11.T_s[4] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[6];
  data->localData[0]->realVars[771] /* particleReceiver1D_v11.T_s[5] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[7];
  data->localData[0]->realVars[772] /* particleReceiver1D_v11.T_s[6] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[8];
  data->localData[0]->realVars[773] /* particleReceiver1D_v11.T_s[7] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[9];
  data->localData[0]->realVars[776] /* particleReceiver1D_v11.T_s[10] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[10];
  data->localData[0]->realVars[775] /* particleReceiver1D_v11.T_s[9] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[11];
  data->localData[0]->realVars[774] /* particleReceiver1D_v11.T_s[8] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[12];
  data->localData[0]->realVars[778] /* particleReceiver1D_v11.T_s[12] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[13];
  data->localData[0]->realVars[777] /* particleReceiver1D_v11.T_s[11] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[14];
  data->localData[0]->realVars[780] /* particleReceiver1D_v11.T_s[14] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[15];
  data->localData[0]->realVars[779] /* particleReceiver1D_v11.T_s[13] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[16];
  data->localData[0]->realVars[783] /* particleReceiver1D_v11.T_s[17] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[17];
  data->localData[0]->realVars[782] /* particleReceiver1D_v11.T_s[16] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[18];
  data->localData[0]->realVars[781] /* particleReceiver1D_v11.T_s[15] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[19];
  data->localData[0]->realVars[784] /* particleReceiver1D_v11.T_s[18] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[20];
  data->localData[0]->realVars[789] /* particleReceiver1D_v11.T_w[3] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[21];
  data->localData[0]->realVars[790] /* particleReceiver1D_v11.T_w[4] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[22];
  data->localData[0]->realVars[791] /* particleReceiver1D_v11.T_w[5] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[23];
  data->localData[0]->realVars[792] /* particleReceiver1D_v11.T_w[6] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[24];
  data->localData[0]->realVars[793] /* particleReceiver1D_v11.T_w[7] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[25];
  data->localData[0]->realVars[794] /* particleReceiver1D_v11.T_w[8] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[26];
  data->localData[0]->realVars[795] /* particleReceiver1D_v11.T_w[9] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[27];
  data->localData[0]->realVars[796] /* particleReceiver1D_v11.T_w[10] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[28];
  data->localData[0]->realVars[797] /* particleReceiver1D_v11.T_w[11] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[29];
  data->localData[0]->realVars[798] /* particleReceiver1D_v11.T_w[12] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[30];
  data->localData[0]->realVars[799] /* particleReceiver1D_v11.T_w[13] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[31];
  data->localData[0]->realVars[800] /* particleReceiver1D_v11.T_w[14] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[32];
  data->localData[0]->realVars[801] /* particleReceiver1D_v11.T_w[15] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[33];
  data->localData[0]->realVars[802] /* particleReceiver1D_v11.T_w[16] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[34];
  data->localData[0]->realVars[803] /* particleReceiver1D_v11.T_w[17] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[35];
  data->localData[0]->realVars[804] /* particleReceiver1D_v11.T_w[18] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[36];
  data->localData[0]->realVars[805] /* particleReceiver1D_v11.T_w[19] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[37];
  data->localData[0]->realVars[806] /* particleReceiver1D_v11.T_w[20] variable */ = data->simulationInfo->nonlinearSystemData[46].nlsx[38];
  TRACE_POP
}
/*
equation index: 4608
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[1] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[2] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4608(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4608};
  data->localData[0]->realVars[1017] /* particleReceiver1D_v11.q_conv_curtain[1] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[768] /* particleReceiver1D_v11.T_s[2] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4609
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[2] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[3] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4609(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4609};
  data->localData[0]->realVars[1018] /* particleReceiver1D_v11.q_conv_curtain[2] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[769] /* particleReceiver1D_v11.T_s[3] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4610
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[3] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[4] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4610(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4610};
  data->localData[0]->realVars[1019] /* particleReceiver1D_v11.q_conv_curtain[3] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[770] /* particleReceiver1D_v11.T_s[4] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4611
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[4] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[5] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4611(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4611};
  data->localData[0]->realVars[1020] /* particleReceiver1D_v11.q_conv_curtain[4] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[771] /* particleReceiver1D_v11.T_s[5] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4612
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[5] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[6] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4612(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4612};
  data->localData[0]->realVars[1021] /* particleReceiver1D_v11.q_conv_curtain[5] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[772] /* particleReceiver1D_v11.T_s[6] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4613
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[6] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[7] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4613(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4613};
  data->localData[0]->realVars[1022] /* particleReceiver1D_v11.q_conv_curtain[6] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[773] /* particleReceiver1D_v11.T_s[7] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4614
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[9] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[10] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4614(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4614};
  data->localData[0]->realVars[1025] /* particleReceiver1D_v11.q_conv_curtain[9] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[776] /* particleReceiver1D_v11.T_s[10] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4615
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[8] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[9] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4615(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4615};
  data->localData[0]->realVars[1024] /* particleReceiver1D_v11.q_conv_curtain[8] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[775] /* particleReceiver1D_v11.T_s[9] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4616
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[7] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[8] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4616(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4616};
  data->localData[0]->realVars[1023] /* particleReceiver1D_v11.q_conv_curtain[7] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[774] /* particleReceiver1D_v11.T_s[8] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4617
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[11] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[12] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4617(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4617};
  data->localData[0]->realVars[1027] /* particleReceiver1D_v11.q_conv_curtain[11] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[778] /* particleReceiver1D_v11.T_s[12] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4618
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[10] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[11] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4618(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4618};
  data->localData[0]->realVars[1026] /* particleReceiver1D_v11.q_conv_curtain[10] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[777] /* particleReceiver1D_v11.T_s[11] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4619
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[13] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[14] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4619(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4619};
  data->localData[0]->realVars[1029] /* particleReceiver1D_v11.q_conv_curtain[13] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[780] /* particleReceiver1D_v11.T_s[14] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4620
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[12] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[13] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4620(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4620};
  data->localData[0]->realVars[1028] /* particleReceiver1D_v11.q_conv_curtain[12] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[779] /* particleReceiver1D_v11.T_s[13] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4621
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[16] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[17] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4621(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4621};
  data->localData[0]->realVars[1032] /* particleReceiver1D_v11.q_conv_curtain[16] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[783] /* particleReceiver1D_v11.T_s[17] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4622
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[15] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[16] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4622(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4622};
  data->localData[0]->realVars[1031] /* particleReceiver1D_v11.q_conv_curtain[15] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[782] /* particleReceiver1D_v11.T_s[16] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4623
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[14] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[15] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4623(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4623};
  data->localData[0]->realVars[1030] /* particleReceiver1D_v11.q_conv_curtain[14] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[781] /* particleReceiver1D_v11.T_s[15] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4624
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[17] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[18] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4624(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4624};
  data->localData[0]->realVars[1033] /* particleReceiver1D_v11.q_conv_curtain[17] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[784] /* particleReceiver1D_v11.T_s[18] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4625
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[18] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[19] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4625(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4625};
  data->localData[0]->realVars[1034] /* particleReceiver1D_v11.q_conv_curtain[18] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[785] /* particleReceiver1D_v11.T_s[19] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4626
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Qloss_jcb = (particleReceiver1D_v11.jc_b[1] + particleReceiver1D_v11.jc_b[2] + particleReceiver1D_v11.jc_b[3] + particleReceiver1D_v11.jc_b[4] + particleReceiver1D_v11.jc_b[5] + particleReceiver1D_v11.jc_b[6] + particleReceiver1D_v11.jc_b[7] + particleReceiver1D_v11.jc_b[8] + particleReceiver1D_v11.jc_b[9] + particleReceiver1D_v11.jc_b[10] + particleReceiver1D_v11.jc_b[11] + particleReceiver1D_v11.jc_b[12] + particleReceiver1D_v11.jc_b[13] + particleReceiver1D_v11.jc_b[14] + particleReceiver1D_v11.jc_b[15] + particleReceiver1D_v11.jc_b[16] + particleReceiver1D_v11.jc_b[17] + particleReceiver1D_v11.jc_b[18] + particleReceiver1D_v11.jc_b[19] + particleReceiver1D_v11.jc_b[20]) * particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.H_drop_design
*/
void PhysicalParticleCO21D_v11_eqFunction_4626(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4626};
  data->localData[0]->realVars[764] /* particleReceiver1D_v11.Qloss_jcb variable */ = (data->localData[0]->realVars[935] /* particleReceiver1D_v11.jc_b[1] variable */ + data->localData[0]->realVars[936] /* particleReceiver1D_v11.jc_b[2] variable */ + data->localData[0]->realVars[937] /* particleReceiver1D_v11.jc_b[3] variable */ + data->localData[0]->realVars[938] /* particleReceiver1D_v11.jc_b[4] variable */ + data->localData[0]->realVars[939] /* particleReceiver1D_v11.jc_b[5] variable */ + data->localData[0]->realVars[940] /* particleReceiver1D_v11.jc_b[6] variable */ + data->localData[0]->realVars[941] /* particleReceiver1D_v11.jc_b[7] variable */ + data->localData[0]->realVars[942] /* particleReceiver1D_v11.jc_b[8] variable */ + data->localData[0]->realVars[943] /* particleReceiver1D_v11.jc_b[9] variable */ + data->localData[0]->realVars[944] /* particleReceiver1D_v11.jc_b[10] variable */ + data->localData[0]->realVars[945] /* particleReceiver1D_v11.jc_b[11] variable */ + data->localData[0]->realVars[946] /* particleReceiver1D_v11.jc_b[12] variable */ + data->localData[0]->realVars[947] /* particleReceiver1D_v11.jc_b[13] variable */ + data->localData[0]->realVars[948] /* particleReceiver1D_v11.jc_b[14] variable */ + data->localData[0]->realVars[949] /* particleReceiver1D_v11.jc_b[15] variable */ + data->localData[0]->realVars[950] /* particleReceiver1D_v11.jc_b[16] variable */ + data->localData[0]->realVars[951] /* particleReceiver1D_v11.jc_b[17] variable */ + data->localData[0]->realVars[952] /* particleReceiver1D_v11.jc_b[18] variable */ + data->localData[0]->realVars[953] /* particleReceiver1D_v11.jc_b[19] variable */ + data->localData[0]->realVars[954] /* particleReceiver1D_v11.jc_b[20] variable */) * ((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->simulationInfo->realParameter[307] /* particleReceiver1D_v11.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4627
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Qloss_conv_wall = (particleReceiver1D_v11.q_conv_wall[1] + particleReceiver1D_v11.q_conv_wall[2] + particleReceiver1D_v11.q_conv_wall[3] + particleReceiver1D_v11.q_conv_wall[4] + particleReceiver1D_v11.q_conv_wall[5] + particleReceiver1D_v11.q_conv_wall[6] + particleReceiver1D_v11.q_conv_wall[7] + particleReceiver1D_v11.q_conv_wall[8] + particleReceiver1D_v11.q_conv_wall[9] + particleReceiver1D_v11.q_conv_wall[10] + particleReceiver1D_v11.q_conv_wall[11] + particleReceiver1D_v11.q_conv_wall[12] + particleReceiver1D_v11.q_conv_wall[13] + particleReceiver1D_v11.q_conv_wall[14] + particleReceiver1D_v11.q_conv_wall[15] + particleReceiver1D_v11.q_conv_wall[16] + particleReceiver1D_v11.q_conv_wall[17] + particleReceiver1D_v11.q_conv_wall[18] + particleReceiver1D_v11.q_conv_wall[19] + particleReceiver1D_v11.q_conv_wall[20]) * particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.H_drop_design
*/
void PhysicalParticleCO21D_v11_eqFunction_4627(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4627};
  data->localData[0]->realVars[763] /* particleReceiver1D_v11.Qloss_conv_wall variable */ = (data->localData[0]->realVars[1037] /* particleReceiver1D_v11.q_conv_wall[1] variable */ + data->localData[0]->realVars[1038] /* particleReceiver1D_v11.q_conv_wall[2] variable */ + data->localData[0]->realVars[1039] /* particleReceiver1D_v11.q_conv_wall[3] variable */ + data->localData[0]->realVars[1040] /* particleReceiver1D_v11.q_conv_wall[4] variable */ + data->localData[0]->realVars[1041] /* particleReceiver1D_v11.q_conv_wall[5] variable */ + data->localData[0]->realVars[1042] /* particleReceiver1D_v11.q_conv_wall[6] variable */ + data->localData[0]->realVars[1043] /* particleReceiver1D_v11.q_conv_wall[7] variable */ + data->localData[0]->realVars[1044] /* particleReceiver1D_v11.q_conv_wall[8] variable */ + data->localData[0]->realVars[1045] /* particleReceiver1D_v11.q_conv_wall[9] variable */ + data->localData[0]->realVars[1046] /* particleReceiver1D_v11.q_conv_wall[10] variable */ + data->localData[0]->realVars[1047] /* particleReceiver1D_v11.q_conv_wall[11] variable */ + data->localData[0]->realVars[1048] /* particleReceiver1D_v11.q_conv_wall[12] variable */ + data->localData[0]->realVars[1049] /* particleReceiver1D_v11.q_conv_wall[13] variable */ + data->localData[0]->realVars[1050] /* particleReceiver1D_v11.q_conv_wall[14] variable */ + data->localData[0]->realVars[1051] /* particleReceiver1D_v11.q_conv_wall[15] variable */ + data->localData[0]->realVars[1052] /* particleReceiver1D_v11.q_conv_wall[16] variable */ + data->localData[0]->realVars[1053] /* particleReceiver1D_v11.q_conv_wall[17] variable */ + data->localData[0]->realVars[1054] /* particleReceiver1D_v11.q_conv_wall[18] variable */ + data->localData[0]->realVars[1055] /* particleReceiver1D_v11.q_conv_wall[19] variable */ + data->localData[0]->realVars[1056] /* particleReceiver1D_v11.q_conv_wall[20] variable */) * ((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->simulationInfo->realParameter[307] /* particleReceiver1D_v11.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4628
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[19] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[20] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4628(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4628};
  data->localData[0]->realVars[1035] /* particleReceiver1D_v11.q_conv_curtain[19] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[786] /* particleReceiver1D_v11.T_s[20] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4629
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Qgain_gcb = (particleReceiver1D_v11.gc_b[1] + particleReceiver1D_v11.gc_b[2] + particleReceiver1D_v11.gc_b[3] + particleReceiver1D_v11.gc_b[4] + particleReceiver1D_v11.gc_b[5] + particleReceiver1D_v11.gc_b[6] + particleReceiver1D_v11.gc_b[7] + particleReceiver1D_v11.gc_b[8] + particleReceiver1D_v11.gc_b[9] + particleReceiver1D_v11.gc_b[10] + particleReceiver1D_v11.gc_b[11] + particleReceiver1D_v11.gc_b[12] + particleReceiver1D_v11.gc_b[13] + particleReceiver1D_v11.gc_b[14] + particleReceiver1D_v11.gc_b[15] + particleReceiver1D_v11.gc_b[16] + particleReceiver1D_v11.gc_b[17] + particleReceiver1D_v11.gc_b[18] + particleReceiver1D_v11.gc_b[19] + particleReceiver1D_v11.gc_b[20]) * particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.H_drop_design
*/
void PhysicalParticleCO21D_v11_eqFunction_4629(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4629};
  data->localData[0]->realVars[761] /* particleReceiver1D_v11.Qgain_gcb variable */ = (data->localData[0]->realVars[873] /* particleReceiver1D_v11.gc_b[1] variable */ + data->localData[0]->realVars[874] /* particleReceiver1D_v11.gc_b[2] variable */ + data->localData[0]->realVars[875] /* particleReceiver1D_v11.gc_b[3] variable */ + data->localData[0]->realVars[876] /* particleReceiver1D_v11.gc_b[4] variable */ + data->localData[0]->realVars[877] /* particleReceiver1D_v11.gc_b[5] variable */ + data->localData[0]->realVars[878] /* particleReceiver1D_v11.gc_b[6] variable */ + data->localData[0]->realVars[879] /* particleReceiver1D_v11.gc_b[7] variable */ + data->localData[0]->realVars[880] /* particleReceiver1D_v11.gc_b[8] variable */ + data->localData[0]->realVars[881] /* particleReceiver1D_v11.gc_b[9] variable */ + data->localData[0]->realVars[882] /* particleReceiver1D_v11.gc_b[10] variable */ + data->localData[0]->realVars[883] /* particleReceiver1D_v11.gc_b[11] variable */ + data->localData[0]->realVars[884] /* particleReceiver1D_v11.gc_b[12] variable */ + data->localData[0]->realVars[885] /* particleReceiver1D_v11.gc_b[13] variable */ + data->localData[0]->realVars[886] /* particleReceiver1D_v11.gc_b[14] variable */ + data->localData[0]->realVars[887] /* particleReceiver1D_v11.gc_b[15] variable */ + data->localData[0]->realVars[888] /* particleReceiver1D_v11.gc_b[16] variable */ + data->localData[0]->realVars[889] /* particleReceiver1D_v11.gc_b[17] variable */ + data->localData[0]->realVars[890] /* particleReceiver1D_v11.gc_b[18] variable */ + data->localData[0]->realVars[891] /* particleReceiver1D_v11.gc_b[19] variable */ + data->localData[0]->realVars[892] /* particleReceiver1D_v11.gc_b[20] variable */) * ((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->simulationInfo->realParameter[307] /* particleReceiver1D_v11.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4630
type: SIMPLE_ASSIGN
particleReceiver1D_v11.jc_f[20] = if heliostatsField.on_internal then particleReceiver1D_v11.tau_c[20] * particleReceiver1D_v11.gc_b[20] - ((-5.670367e-08) * particleReceiver1D_v11.eps_c[20] * particleReceiver1D_v11.T_s[20] ^ 4.0 - particleReceiver1D_v11.reflectivity_c[20] * particleReceiver1D_v11.gc_f[20]) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4630(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4630};
  modelica_real tmp0;
  modelica_boolean tmp1;
  modelica_real tmp2;
  tmp1 = (modelica_boolean)data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */;
  if(tmp1)
  {
    tmp0 = data->localData[0]->realVars[786] /* particleReceiver1D_v11.T_s[20] variable */;
    tmp0 *= tmp0;
    tmp2 = (data->localData[0]->realVars[1140] /* particleReceiver1D_v11.tau_c[20] variable */) * (data->localData[0]->realVars[892] /* particleReceiver1D_v11.gc_b[20] variable */) - ((-5.670367e-08) * ((data->localData[0]->realVars[850] /* particleReceiver1D_v11.eps_c[20] variable */) * ((tmp0 * tmp0))) - ((data->localData[0]->realVars[1097] /* particleReceiver1D_v11.reflectivity_c[20] variable */) * (data->localData[0]->realVars[893] /* particleReceiver1D_v11.gc_f[20] variable */)));
  }
  else
  {
    tmp2 = 0.0;
  }
  data->localData[0]->realVars[974] /* particleReceiver1D_v11.jc_f[20] variable */ = tmp2;
  TRACE_POP
}
/*
equation index: 4631
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Qloss_jcf = (particleReceiver1D_v11.jc_f[1] + particleReceiver1D_v11.jc_f[2] + particleReceiver1D_v11.jc_f[3] + particleReceiver1D_v11.jc_f[4] + particleReceiver1D_v11.jc_f[5] + particleReceiver1D_v11.jc_f[6] + particleReceiver1D_v11.jc_f[7] + particleReceiver1D_v11.jc_f[8] + particleReceiver1D_v11.jc_f[9] + particleReceiver1D_v11.jc_f[10] + particleReceiver1D_v11.jc_f[11] + particleReceiver1D_v11.jc_f[12] + particleReceiver1D_v11.jc_f[13] + particleReceiver1D_v11.jc_f[14] + particleReceiver1D_v11.jc_f[15] + particleReceiver1D_v11.jc_f[16] + particleReceiver1D_v11.jc_f[17] + particleReceiver1D_v11.jc_f[18] + particleReceiver1D_v11.jc_f[19] + particleReceiver1D_v11.jc_f[20]) * particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.H_drop_design
*/
void PhysicalParticleCO21D_v11_eqFunction_4631(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4631};
  data->localData[0]->realVars[765] /* particleReceiver1D_v11.Qloss_jcf variable */ = (data->localData[0]->realVars[955] /* particleReceiver1D_v11.jc_f[1] variable */ + data->localData[0]->realVars[956] /* particleReceiver1D_v11.jc_f[2] variable */ + data->localData[0]->realVars[957] /* particleReceiver1D_v11.jc_f[3] variable */ + data->localData[0]->realVars[958] /* particleReceiver1D_v11.jc_f[4] variable */ + data->localData[0]->realVars[959] /* particleReceiver1D_v11.jc_f[5] variable */ + data->localData[0]->realVars[960] /* particleReceiver1D_v11.jc_f[6] variable */ + data->localData[0]->realVars[961] /* particleReceiver1D_v11.jc_f[7] variable */ + data->localData[0]->realVars[962] /* particleReceiver1D_v11.jc_f[8] variable */ + data->localData[0]->realVars[963] /* particleReceiver1D_v11.jc_f[9] variable */ + data->localData[0]->realVars[964] /* particleReceiver1D_v11.jc_f[10] variable */ + data->localData[0]->realVars[965] /* particleReceiver1D_v11.jc_f[11] variable */ + data->localData[0]->realVars[966] /* particleReceiver1D_v11.jc_f[12] variable */ + data->localData[0]->realVars[967] /* particleReceiver1D_v11.jc_f[13] variable */ + data->localData[0]->realVars[968] /* particleReceiver1D_v11.jc_f[14] variable */ + data->localData[0]->realVars[969] /* particleReceiver1D_v11.jc_f[15] variable */ + data->localData[0]->realVars[970] /* particleReceiver1D_v11.jc_f[16] variable */ + data->localData[0]->realVars[971] /* particleReceiver1D_v11.jc_f[17] variable */ + data->localData[0]->realVars[972] /* particleReceiver1D_v11.jc_f[18] variable */ + data->localData[0]->realVars[973] /* particleReceiver1D_v11.jc_f[19] variable */ + data->localData[0]->realVars[974] /* particleReceiver1D_v11.jc_f[20] variable */) * ((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->simulationInfo->realParameter[307] /* particleReceiver1D_v11.H_drop_design PARAM */));
  TRACE_POP
}
void PhysicalParticleCO21D_v11_eqFunction_4632(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4633(DATA*, threadData_t*);
void PhysicalParticleCO21D_v11_eqFunction_4634(DATA*, threadData_t*);
/*
equation index: 4635
indexNonlinear: 47
type: NONLINEAR

vars: {particleReceiver1D_v11.T_s[21]}
eqns: {4632, 4633, 4634}
*/
void PhysicalParticleCO21D_v11_eqFunction_4635(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4635};
  int retValue;
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving nonlinear system 4635 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  /* get old value */
  data->simulationInfo->nonlinearSystemData[47].nlsxOld[0] = data->localData[0]->realVars[787] /* particleReceiver1D_v11.T_s[21] variable */;
  retValue = solve_nonlinear_system(data, threadData, 47);
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,4635};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving non-linear system 4635 failed at time=%.15g.\nFor more information please use -lv LOG_NLS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[787] /* particleReceiver1D_v11.T_s[21] variable */ = data->simulationInfo->nonlinearSystemData[47].nlsx[0];
  TRACE_POP
}
/*
equation index: 4636
type: SIMPLE_ASSIGN
$DER.tankHot.medium.h = (tankHot.Q_losses + tankHot.W_net + particleReceiver1D_v11.mdot * particleReceiver1D_v11.h_s[21] + LiftCold.fluid_b.m_flow * tankHot.medium.h - der(tankHot.m) * tankHot.medium.h) / tankHot.m
*/
void PhysicalParticleCO21D_v11_eqFunction_4636(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4636};
  data->localData[0]->realVars[33] /* der(tankHot.medium.h) STATE_DER */ = DIVISION_SIM(data->localData[0]->realVars[1349] /* tankHot.Q_losses variable */ + data->localData[0]->realVars[1353] /* tankHot.W_net variable */ + (data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */) * (data->localData[0]->realVars[914] /* particleReceiver1D_v11.h_s[21] variable */) + (data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */) * (data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */) - ((data->localData[0]->realVars[32] /* der(tankHot.m) STATE_DER */) * (data->localData[0]->realVars[16] /* tankHot.medium.h STATE(1) */)),data->localData[0]->realVars[15] /* tankHot.m STATE(1) */,"tankHot.m",equationIndexes);
  TRACE_POP
}
/*
equation index: 4637
type: SIMPLE_ASSIGN
simpleReceiverControl.T_out_receiver = SolarTherm.Media.SolidParticles.CarboHSP_utilities.T_h(particleReceiver1D_v11.h_s[21])
*/
void PhysicalParticleCO21D_v11_eqFunction_4637(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4637};
  data->localData[0]->realVars[1320] /* simpleReceiverControl.T_out_receiver variable */ = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData, data->localData[0]->realVars[914] /* particleReceiver1D_v11.h_s[21] variable */);
  TRACE_POP
}
/*
equation index: 4638
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Qdot_rec = if heliostatsField.on_internal == true then max(particleReceiver1D_v11.mdot * (particleReceiver1D_v11.h_s[21] - particleReceiver1D_v11.h_s[1]), 0.0) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4638(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4638};
  data->localData[0]->realVars[760] /* particleReceiver1D_v11.Qdot_rec variable */ = (((!data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && !1) || (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && 1))?fmax((data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */) * (data->localData[0]->realVars[914] /* particleReceiver1D_v11.h_s[21] variable */ - data->localData[0]->realVars[894] /* particleReceiver1D_v11.h_s[1] variable */),0.0):0.0);
  TRACE_POP
}
/*
equation index: 4639
type: SIMPLE_ASSIGN
$DER.E_recv_net = particleReceiver1D_v11.Qdot_rec
*/
void PhysicalParticleCO21D_v11_eqFunction_4639(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4639};
  data->localData[0]->realVars[25] /* der(E_recv_net) STATE_DER */ = data->localData[0]->realVars[760] /* particleReceiver1D_v11.Qdot_rec variable */;
  TRACE_POP
}
/*
equation index: 4640
type: SIMPLE_ASSIGN
particleReceiver1D_v11.q_conv_curtain[20] = particleReceiver1D_v11.h_conv * (particleReceiver1D_v11.T_s[21] - particleReceiver1D_v11.Tamb)
*/
void PhysicalParticleCO21D_v11_eqFunction_4640(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4640};
  data->localData[0]->realVars[1036] /* particleReceiver1D_v11.q_conv_curtain[20] variable */ = (data->simulationInfo->realParameter[338] /* particleReceiver1D_v11.h_conv PARAM */) * (data->localData[0]->realVars[787] /* particleReceiver1D_v11.T_s[21] variable */ - data->localData[0]->realVars[808] /* particleReceiver1D_v11.Tamb variable */);
  TRACE_POP
}
/*
equation index: 4641
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Qloss_conv_curtain = (particleReceiver1D_v11.q_conv_curtain[1] + particleReceiver1D_v11.q_conv_curtain[2] + particleReceiver1D_v11.q_conv_curtain[3] + particleReceiver1D_v11.q_conv_curtain[4] + particleReceiver1D_v11.q_conv_curtain[5] + particleReceiver1D_v11.q_conv_curtain[6] + particleReceiver1D_v11.q_conv_curtain[7] + particleReceiver1D_v11.q_conv_curtain[8] + particleReceiver1D_v11.q_conv_curtain[9] + particleReceiver1D_v11.q_conv_curtain[10] + particleReceiver1D_v11.q_conv_curtain[11] + particleReceiver1D_v11.q_conv_curtain[12] + particleReceiver1D_v11.q_conv_curtain[13] + particleReceiver1D_v11.q_conv_curtain[14] + particleReceiver1D_v11.q_conv_curtain[15] + particleReceiver1D_v11.q_conv_curtain[16] + particleReceiver1D_v11.q_conv_curtain[17] + particleReceiver1D_v11.q_conv_curtain[18] + particleReceiver1D_v11.q_conv_curtain[19] + particleReceiver1D_v11.q_conv_curtain[20]) * particleReceiver1D_v11.W_rcv * particleReceiver1D_v11.H_drop_design
*/
void PhysicalParticleCO21D_v11_eqFunction_4641(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4641};
  data->localData[0]->realVars[762] /* particleReceiver1D_v11.Qloss_conv_curtain variable */ = (data->localData[0]->realVars[1017] /* particleReceiver1D_v11.q_conv_curtain[1] variable */ + data->localData[0]->realVars[1018] /* particleReceiver1D_v11.q_conv_curtain[2] variable */ + data->localData[0]->realVars[1019] /* particleReceiver1D_v11.q_conv_curtain[3] variable */ + data->localData[0]->realVars[1020] /* particleReceiver1D_v11.q_conv_curtain[4] variable */ + data->localData[0]->realVars[1021] /* particleReceiver1D_v11.q_conv_curtain[5] variable */ + data->localData[0]->realVars[1022] /* particleReceiver1D_v11.q_conv_curtain[6] variable */ + data->localData[0]->realVars[1023] /* particleReceiver1D_v11.q_conv_curtain[7] variable */ + data->localData[0]->realVars[1024] /* particleReceiver1D_v11.q_conv_curtain[8] variable */ + data->localData[0]->realVars[1025] /* particleReceiver1D_v11.q_conv_curtain[9] variable */ + data->localData[0]->realVars[1026] /* particleReceiver1D_v11.q_conv_curtain[10] variable */ + data->localData[0]->realVars[1027] /* particleReceiver1D_v11.q_conv_curtain[11] variable */ + data->localData[0]->realVars[1028] /* particleReceiver1D_v11.q_conv_curtain[12] variable */ + data->localData[0]->realVars[1029] /* particleReceiver1D_v11.q_conv_curtain[13] variable */ + data->localData[0]->realVars[1030] /* particleReceiver1D_v11.q_conv_curtain[14] variable */ + data->localData[0]->realVars[1031] /* particleReceiver1D_v11.q_conv_curtain[15] variable */ + data->localData[0]->realVars[1032] /* particleReceiver1D_v11.q_conv_curtain[16] variable */ + data->localData[0]->realVars[1033] /* particleReceiver1D_v11.q_conv_curtain[17] variable */ + data->localData[0]->realVars[1034] /* particleReceiver1D_v11.q_conv_curtain[18] variable */ + data->localData[0]->realVars[1035] /* particleReceiver1D_v11.q_conv_curtain[19] variable */ + data->localData[0]->realVars[1036] /* particleReceiver1D_v11.q_conv_curtain[20] variable */) * ((data->localData[0]->realVars[809] /* particleReceiver1D_v11.W_rcv variable */) * (data->simulationInfo->realParameter[307] /* particleReceiver1D_v11.H_drop_design PARAM */));
  TRACE_POP
}
/*
equation index: 4642
type: SIMPLE_ASSIGN
$DER.E_helio_net = heliostatsField.Q_incident
*/
void PhysicalParticleCO21D_v11_eqFunction_4642(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4642};
  data->localData[0]->realVars[19] /* der(E_helio_net) STATE_DER */ = data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */;
  TRACE_POP
}
/*
equation index: 4643
type: SIMPLE_ASSIGN
$DER.E_recv_incident = heliostatsField.Q_incident
*/
void PhysicalParticleCO21D_v11_eqFunction_4643(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4643};
  data->localData[0]->realVars[24] /* der(E_recv_incident) STATE_DER */ = data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */;
  TRACE_POP
}
/*
equation index: 4644
type: SIMPLE_ASSIGN
particleReceiver1D_v11.Q_check_curtain = particleReceiver1D_v11.mdot * (particleReceiver1D_v11.h_s[1] - particleReceiver1D_v11.h_s[21]) + heliostatsField.Q_incident + particleReceiver1D_v11.Qloss_conv_curtain + (-particleReceiver1D_v11.Qloss_jcf) - particleReceiver1D_v11.Qloss_jcb
*/
void PhysicalParticleCO21D_v11_eqFunction_4644(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4644};
  data->localData[0]->realVars[759] /* particleReceiver1D_v11.Q_check_curtain variable */ = (data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */) * (data->localData[0]->realVars[894] /* particleReceiver1D_v11.h_s[1] variable */ - data->localData[0]->realVars[914] /* particleReceiver1D_v11.h_s[21] variable */) + data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */ + data->localData[0]->realVars[762] /* particleReceiver1D_v11.Qloss_conv_curtain variable */ + (-data->localData[0]->realVars[765] /* particleReceiver1D_v11.Qloss_jcf variable */) - data->localData[0]->realVars[764] /* particleReceiver1D_v11.Qloss_jcb variable */;
  TRACE_POP
}
/*
equation index: 4645
type: SIMPLE_ASSIGN
particleReceiver1D_v11.eta_rec = if heliostatsField.on_internal == true then max(particleReceiver1D_v11.Qdot_rec / heliostatsField.Q_incident, 0.0) else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4645(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4645};
  data->localData[0]->realVars[851] /* particleReceiver1D_v11.eta_rec variable */ = (((!data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && !1) || (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */ && 1))?fmax(DIVISION_SIM(data->localData[0]->realVars[760] /* particleReceiver1D_v11.Qdot_rec variable */,data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */,"heliostatsField.Q_incident",equationIndexes),0.0):0.0);
  TRACE_POP
}
/*
equation index: 4646
type: SIMPLE_ASSIGN
heliostatsField.Q_total_loses_optical = max(heliostatsField.n_h * heliostatsField.A_h * sun.dni - heliostatsField.Q_incident, 0.0)
*/
void PhysicalParticleCO21D_v11_eqFunction_4646(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4646};
  data->localData[0]->realVars[86] /* heliostatsField.Q_total_loses_optical variable */ = fmax((data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[143] /* heliostatsField.A_h PARAM */) * (data->localData[0]->realVars[1328] /* sun.dni variable */)) - data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */,0.0);
  TRACE_POP
}
/*
equation index: 4647
type: SIMPLE_ASSIGN
$DER.heliostatsField.E_total_loses_optical = -heliostatsField.Q_total_loses_optical
*/
void PhysicalParticleCO21D_v11_eqFunction_4647(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4647};
  data->localData[0]->realVars[27] /* der(heliostatsField.E_total_loses_optical) STATE_DER */ = (-data->localData[0]->realVars[86] /* heliostatsField.Q_total_loses_optical variable */);
  TRACE_POP
}
/*
equation index: 4648
type: SIMPLE_ASSIGN
heliostatsField.damping = if heliostatsField.on_internal then heliostatsField.Q_incident / (0.001 + heliostatsField.Q_raw) else 1.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4648(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4648};
  data->localData[0]->realVars[91] /* heliostatsField.damping variable */ = (data->localData[0]->booleanVars[23] /* heliostatsField.on_internal DISCRETE */?DIVISION_SIM(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */,0.001 + data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */,"0.001 + heliostatsField.Q_raw",equationIndexes):1.0);
  TRACE_POP
}
/*
equation index: 4649
type: SIMPLE_ASSIGN
heliostatsField.W_loss1 = if heliostatsField.ele > 0.01 then heliostatsField.n_h * heliostatsField.he_av * heliostatsField.damping * heliostatsField.W_track else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4649(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4649};
  modelica_boolean tmp2;
  RELATIONHYSTERESIS(tmp2, data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, 1, Greater);
  data->localData[0]->realVars[88] /* heliostatsField.W_loss1 variable */ = (tmp2?(data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[152] /* heliostatsField.he_av PARAM */) * ((data->localData[0]->realVars[91] /* heliostatsField.damping variable */) * (data->simulationInfo->realParameter[149] /* heliostatsField.W_track PARAM */))):0.0);
  TRACE_POP
}
/*
equation index: 4650
type: SIMPLE_ASSIGN
heliostatsField.W_loss2 = if time < heliostatsField.t_on + heliostatsField.t_start then heliostatsField.n_h * heliostatsField.he_av * heliostatsField.damping * heliostatsField.E_start / heliostatsField.t_start else 0.0
*/
void PhysicalParticleCO21D_v11_eqFunction_4650(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4650};
  modelica_boolean tmp3;
  RELATIONHYSTERESIS(tmp3, data->localData[0]->timeValue, data->localData[0]->realVars[1372] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */, 19, Less);
  data->localData[0]->realVars[89] /* heliostatsField.W_loss2 variable */ = (tmp3?(data->simulationInfo->realParameter[155] /* heliostatsField.n_h PARAM */) * ((data->simulationInfo->realParameter[152] /* heliostatsField.he_av PARAM */) * ((data->localData[0]->realVars[91] /* heliostatsField.damping variable */) * (DIVISION_SIM(data->simulationInfo->realParameter[144] /* heliostatsField.E_start PARAM */,data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */,"heliostatsField.t_start",equationIndexes)))):0.0);
  TRACE_POP
}
/*
equation index: 4651
type: SIMPLE_ASSIGN
heliostatsField.W_loss = heliostatsField.W_loss1 + heliostatsField.W_loss2
*/
void PhysicalParticleCO21D_v11_eqFunction_4651(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4651};
  data->localData[0]->realVars[87] /* heliostatsField.W_loss variable */ = data->localData[0]->realVars[88] /* heliostatsField.W_loss1 variable */ + data->localData[0]->realVars[89] /* heliostatsField.W_loss2 variable */;
  TRACE_POP
}
/*
equation index: 4652
type: SIMPLE_ASSIGN
parasities_input.y = heliostatsField.W_loss + liftHX.W_loss + liftRC.W_loss + tankHot.W_loss + tankCold.W_loss
*/
void PhysicalParticleCO21D_v11_eqFunction_4652(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4652};
  data->localData[0]->realVars[104] /* parasities_input.y variable */ = data->localData[0]->realVars[87] /* heliostatsField.W_loss variable */ + data->localData[0]->realVars[100] /* liftHX.W_loss variable */ + data->localData[0]->realVars[102] /* liftRC.W_loss variable */ + data->localData[0]->realVars[1352] /* tankHot.W_loss variable */ + data->localData[0]->realVars[1333] /* tankCold.W_loss variable */;
  TRACE_POP
}
/*
equation index: 4702
type: ALGORITHM

  assert(particleReceiver1DCalculator.sink.p >= 0.0, "Pressure (= " + String(particleReceiver1DCalculator.sink.p, 6, 0, true) + " Pa) of medium \"" + "CARBO HSP 40/70" + "\" is negative
(Temperature = " + String(particleReceiver1DCalculator.sink.medium.T, 6, 0, true) + " K)");
*/
void PhysicalParticleCO21D_v11_eqFunction_4702(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4702};
  modelica_boolean tmp4;
  static const MMC_DEFSTRINGLIT(tmp5,12,"Pressure (= ");
  modelica_string tmp6;
  static const MMC_DEFSTRINGLIT(tmp7,16," Pa) of medium \"");
  static const MMC_DEFSTRINGLIT(tmp8,15,"CARBO HSP 40/70");
  static const MMC_DEFSTRINGLIT(tmp9,29,"\" is negative\n(Temperature = ");
  modelica_string tmp10;
  static const MMC_DEFSTRINGLIT(tmp11,3," K)");
  static int tmp12 = 0;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  {
    tmp4 = GreaterEq(data->simulationInfo->realParameter[290] /* particleReceiver1DCalculator.sink.p PARAM */,0.0);
    if(!tmp4)
    {
      tmp6 = modelica_real_to_modelica_string(data->simulationInfo->realParameter[290] /* particleReceiver1DCalculator.sink.p PARAM */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp5),tmp6);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp7));
      tmpMeta[2] = stringAppend(tmpMeta[1],MMC_REFSTRINGLIT(tmp8));
      tmpMeta[3] = stringAppend(tmpMeta[2],MMC_REFSTRINGLIT(tmp9));
      tmp10 = modelica_real_to_modelica_string(data->localData[0]->realVars[613] /* particleReceiver1DCalculator.sink.medium.T variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[4] = stringAppend(tmpMeta[3],tmp10);
      tmpMeta[5] = stringAppend(tmpMeta[4],MMC_REFSTRINGLIT(tmp11));
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
equation index: 4701
type: ALGORITHM

  assert(data.table.tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4701(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4701};
  static const MMC_DEFSTRINGLIT(tmp15,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp16,42,"tableOnFile = true and no table name given");
  static int tmp17 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[2] /* data.table.tableName PARAM */, MMC_REFSTRINGLIT(tmp15))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Sources.mo",2401,7,2402,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\ndata.table.tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp16)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4700
type: ALGORITHM

  assert(heliostatsField.optical.nu_table.tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4700(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4700};
  static const MMC_DEFSTRINGLIT(tmp20,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp21,42,"tableOnFile = true and no table name given");
  static int tmp22 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[5] /* heliostatsField.optical.nu_table.tableName PARAM */, MMC_REFSTRINGLIT(tmp20))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",743,7,744,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nheliostatsField.optical.nu_table.tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp21)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4699
type: ALGORITHM

  assert(simpleReceiverControl.limiter.uMax >= simpleReceiverControl.limiter.uMin, "Limiter: Limits must be consistent. However, uMax (=" + String(simpleReceiverControl.limiter.uMax, 6, 0, true) + ") < uMin (=" + String(simpleReceiverControl.limiter.uMin, 6, 0, true) + ")");
*/
void PhysicalParticleCO21D_v11_eqFunction_4699(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4699};
  modelica_boolean tmp23;
  static const MMC_DEFSTRINGLIT(tmp24,52,"Limiter: Limits must be consistent. However, uMax (=");
  modelica_string tmp25;
  static const MMC_DEFSTRINGLIT(tmp26,11,") < uMin (=");
  modelica_string tmp27;
  static int tmp28 = 0;
  modelica_metatype tmpMeta[4] __attribute__((unused)) = {0};
  {
    tmp23 = GreaterEq(data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMax PARAM */,data->simulationInfo->realParameter[781] /* simpleReceiverControl.limiter.uMin PARAM */);
    if(!tmp23)
    {
      tmp25 = modelica_real_to_modelica_string(data->simulationInfo->realParameter[780] /* simpleReceiverControl.limiter.uMax PARAM */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp24),tmp25);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp26));
      tmp27 = modelica_real_to_modelica_string(data->simulationInfo->realParameter[781] /* simpleReceiverControl.limiter.uMin PARAM */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[2] = stringAppend(tmpMeta[1],tmp27);
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
equation index: 4698
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[1].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4698(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4698};
  static const MMC_DEFSTRINGLIT(tmp31,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp32,42,"tableOnFile = true and no table name given");
  static int tmp33 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[71] /* particleReceiver1D_v11.Tab[1].tableName PARAM */, MMC_REFSTRINGLIT(tmp31))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[1].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp32)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4697
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[2].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4697(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4697};
  static const MMC_DEFSTRINGLIT(tmp36,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp37,42,"tableOnFile = true and no table name given");
  static int tmp38 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[72] /* particleReceiver1D_v11.Tab[2].tableName PARAM */, MMC_REFSTRINGLIT(tmp36))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[2].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp37)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4696
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[3].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4696(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4696};
  static const MMC_DEFSTRINGLIT(tmp41,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp42,42,"tableOnFile = true and no table name given");
  static int tmp43 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[73] /* particleReceiver1D_v11.Tab[3].tableName PARAM */, MMC_REFSTRINGLIT(tmp41))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[3].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp42)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4695
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[4].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4695(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4695};
  static const MMC_DEFSTRINGLIT(tmp46,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp47,42,"tableOnFile = true and no table name given");
  static int tmp48 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[74] /* particleReceiver1D_v11.Tab[4].tableName PARAM */, MMC_REFSTRINGLIT(tmp46))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[4].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp47)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4694
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[5].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4694(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4694};
  static const MMC_DEFSTRINGLIT(tmp51,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp52,42,"tableOnFile = true and no table name given");
  static int tmp53 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[75] /* particleReceiver1D_v11.Tab[5].tableName PARAM */, MMC_REFSTRINGLIT(tmp51))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[5].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp52)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4693
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[6].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4693(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4693};
  static const MMC_DEFSTRINGLIT(tmp56,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp57,42,"tableOnFile = true and no table name given");
  static int tmp58 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[76] /* particleReceiver1D_v11.Tab[6].tableName PARAM */, MMC_REFSTRINGLIT(tmp56))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[6].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp57)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4692
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[7].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4692(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4692};
  static const MMC_DEFSTRINGLIT(tmp61,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp62,42,"tableOnFile = true and no table name given");
  static int tmp63 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[77] /* particleReceiver1D_v11.Tab[7].tableName PARAM */, MMC_REFSTRINGLIT(tmp61))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[7].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp62)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4691
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[8].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4691(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4691};
  static const MMC_DEFSTRINGLIT(tmp66,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp67,42,"tableOnFile = true and no table name given");
  static int tmp68 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[78] /* particleReceiver1D_v11.Tab[8].tableName PARAM */, MMC_REFSTRINGLIT(tmp66))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[8].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp67)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4690
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[9].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4690(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4690};
  static const MMC_DEFSTRINGLIT(tmp71,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp72,42,"tableOnFile = true and no table name given");
  static int tmp73 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[79] /* particleReceiver1D_v11.Tab[9].tableName PARAM */, MMC_REFSTRINGLIT(tmp71))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[9].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp72)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4689
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[10].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4689(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4689};
  static const MMC_DEFSTRINGLIT(tmp76,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp77,42,"tableOnFile = true and no table name given");
  static int tmp78 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[80] /* particleReceiver1D_v11.Tab[10].tableName PARAM */, MMC_REFSTRINGLIT(tmp76))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[10].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp77)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4688
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[11].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4688(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4688};
  static const MMC_DEFSTRINGLIT(tmp81,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp82,42,"tableOnFile = true and no table name given");
  static int tmp83 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[81] /* particleReceiver1D_v11.Tab[11].tableName PARAM */, MMC_REFSTRINGLIT(tmp81))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[11].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp82)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4687
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[12].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4687(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4687};
  static const MMC_DEFSTRINGLIT(tmp86,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp87,42,"tableOnFile = true and no table name given");
  static int tmp88 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[82] /* particleReceiver1D_v11.Tab[12].tableName PARAM */, MMC_REFSTRINGLIT(tmp86))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[12].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp87)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4686
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[13].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4686(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4686};
  static const MMC_DEFSTRINGLIT(tmp91,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp92,42,"tableOnFile = true and no table name given");
  static int tmp93 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[83] /* particleReceiver1D_v11.Tab[13].tableName PARAM */, MMC_REFSTRINGLIT(tmp91))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[13].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp92)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4685
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[14].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4685(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4685};
  static const MMC_DEFSTRINGLIT(tmp96,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp97,42,"tableOnFile = true and no table name given");
  static int tmp98 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[84] /* particleReceiver1D_v11.Tab[14].tableName PARAM */, MMC_REFSTRINGLIT(tmp96))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[14].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp97)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4684
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[15].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4684(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4684};
  static const MMC_DEFSTRINGLIT(tmp101,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp102,42,"tableOnFile = true and no table name given");
  static int tmp103 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[85] /* particleReceiver1D_v11.Tab[15].tableName PARAM */, MMC_REFSTRINGLIT(tmp101))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[15].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp102)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4683
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[16].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4683(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4683};
  static const MMC_DEFSTRINGLIT(tmp106,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp107,42,"tableOnFile = true and no table name given");
  static int tmp108 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[86] /* particleReceiver1D_v11.Tab[16].tableName PARAM */, MMC_REFSTRINGLIT(tmp106))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[16].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp107)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4682
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[17].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4682(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4682};
  static const MMC_DEFSTRINGLIT(tmp111,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp112,42,"tableOnFile = true and no table name given");
  static int tmp113 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[87] /* particleReceiver1D_v11.Tab[17].tableName PARAM */, MMC_REFSTRINGLIT(tmp111))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[17].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp112)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4681
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[18].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4681(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4681};
  static const MMC_DEFSTRINGLIT(tmp116,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp117,42,"tableOnFile = true and no table name given");
  static int tmp118 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[88] /* particleReceiver1D_v11.Tab[18].tableName PARAM */, MMC_REFSTRINGLIT(tmp116))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[18].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp117)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4680
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[19].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4680(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4680};
  static const MMC_DEFSTRINGLIT(tmp121,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp122,42,"tableOnFile = true and no table name given");
  static int tmp123 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[89] /* particleReceiver1D_v11.Tab[19].tableName PARAM */, MMC_REFSTRINGLIT(tmp121))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[19].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp122)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4679
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[20].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4679(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4679};
  static const MMC_DEFSTRINGLIT(tmp126,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp127,42,"tableOnFile = true and no table name given");
  static int tmp128 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[90] /* particleReceiver1D_v11.Tab[20].tableName PARAM */, MMC_REFSTRINGLIT(tmp126))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[20].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp127)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4678
type: ALGORITHM

  assert(particleReceiver1D_v11.Tab[21].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4678(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4678};
  static const MMC_DEFSTRINGLIT(tmp131,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp132,42,"tableOnFile = true and no table name given");
  static int tmp133 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[91] /* particleReceiver1D_v11.Tab[21].tableName PARAM */, MMC_REFSTRINGLIT(tmp131))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1D_v11.Tab[21].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp132)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4677
type: ALGORITHM

  Modelica.Fluid.Utilities.checkBoundary("CARBO HSP 40/70", {"Al2O3", "SiO2", "Fe2O3", "TiO2", "other"}, false, false, particleReceiver1DCalculator.source.X, "FixedBoundary");
*/
void PhysicalParticleCO21D_v11_eqFunction_4677(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4677};
  static const MMC_DEFSTRINGLIT(tmp134,15,"CARBO HSP 40/70");
  string_array tmp135;
  static const MMC_DEFSTRINGLIT(tmp136,5,"Al2O3");
  static const MMC_DEFSTRINGLIT(tmp137,4,"SiO2");
  static const MMC_DEFSTRINGLIT(tmp138,5,"Fe2O3");
  static const MMC_DEFSTRINGLIT(tmp139,4,"TiO2");
  static const MMC_DEFSTRINGLIT(tmp140,5,"other");
  real_array tmp141;
  static const MMC_DEFSTRINGLIT(tmp142,13,"FixedBoundary");
  array_alloc_scalar_string_array(&tmp135, 5, (modelica_string)MMC_REFSTRINGLIT(tmp136), (modelica_string)MMC_REFSTRINGLIT(tmp137), (modelica_string)MMC_REFSTRINGLIT(tmp138), (modelica_string)MMC_REFSTRINGLIT(tmp139), (modelica_string)MMC_REFSTRINGLIT(tmp140));
  real_array_create(&tmp141, ((modelica_real*)&((&data->simulationInfo->realParameter[295] /* particleReceiver1DCalculator.source.X[1] PARAM */)[calc_base_index_dims_subs(1, 5, ((modelica_integer) 1))])), 1, 5);
  omc_Modelica_Fluid_Utilities_checkBoundary(threadData, MMC_REFSTRINGLIT(tmp134), tmp135, 0, 0, tmp141, MMC_REFSTRINGLIT(tmp142));
  TRACE_POP
}
/*
equation index: 4676
type: ALGORITHM

  Modelica.Fluid.Utilities.checkBoundary("CARBO HSP 40/70", {"Al2O3", "SiO2", "Fe2O3", "TiO2", "other"}, false, true, particleReceiver1DCalculator.sink.X, "FixedBoundary");
*/
void PhysicalParticleCO21D_v11_eqFunction_4676(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4676};
  static const MMC_DEFSTRINGLIT(tmp143,15,"CARBO HSP 40/70");
  string_array tmp144;
  static const MMC_DEFSTRINGLIT(tmp145,5,"Al2O3");
  static const MMC_DEFSTRINGLIT(tmp146,4,"SiO2");
  static const MMC_DEFSTRINGLIT(tmp147,5,"Fe2O3");
  static const MMC_DEFSTRINGLIT(tmp148,4,"TiO2");
  static const MMC_DEFSTRINGLIT(tmp149,5,"other");
  real_array tmp150;
  static const MMC_DEFSTRINGLIT(tmp151,13,"FixedBoundary");
  array_alloc_scalar_string_array(&tmp144, 5, (modelica_string)MMC_REFSTRINGLIT(tmp145), (modelica_string)MMC_REFSTRINGLIT(tmp146), (modelica_string)MMC_REFSTRINGLIT(tmp147), (modelica_string)MMC_REFSTRINGLIT(tmp148), (modelica_string)MMC_REFSTRINGLIT(tmp149));
  real_array_create(&tmp150, ((modelica_real*)&((&data->simulationInfo->realParameter[281] /* particleReceiver1DCalculator.sink.X[1] PARAM */)[calc_base_index_dims_subs(1, 5, ((modelica_integer) 1))])), 1, 5);
  omc_Modelica_Fluid_Utilities_checkBoundary(threadData, MMC_REFSTRINGLIT(tmp143), tmp144, 0, 1, tmp150, MMC_REFSTRINGLIT(tmp151));
  TRACE_POP
}
/*
equation index: 4675
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4675(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4675};
  static const MMC_DEFSTRINGLIT(tmp154,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp155,42,"tableOnFile = true and no table name given");
  static int tmp156 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[28] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableName PARAM */, MMC_REFSTRINGLIT(tmp154))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[1].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp155)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4674
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[2].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4674(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4674};
  static const MMC_DEFSTRINGLIT(tmp159,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp160,42,"tableOnFile = true and no table name given");
  static int tmp161 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[29] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[2].tableName PARAM */, MMC_REFSTRINGLIT(tmp159))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[2].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp160)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4673
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[3].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4673(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4673};
  static const MMC_DEFSTRINGLIT(tmp164,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp165,42,"tableOnFile = true and no table name given");
  static int tmp166 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[30] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[3].tableName PARAM */, MMC_REFSTRINGLIT(tmp164))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[3].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp165)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4672
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[4].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4672(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4672};
  static const MMC_DEFSTRINGLIT(tmp169,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp170,42,"tableOnFile = true and no table name given");
  static int tmp171 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[31] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[4].tableName PARAM */, MMC_REFSTRINGLIT(tmp169))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[4].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp170)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4671
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[5].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4671(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4671};
  static const MMC_DEFSTRINGLIT(tmp174,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp175,42,"tableOnFile = true and no table name given");
  static int tmp176 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[32] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[5].tableName PARAM */, MMC_REFSTRINGLIT(tmp174))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[5].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp175)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4670
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[6].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4670(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4670};
  static const MMC_DEFSTRINGLIT(tmp179,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp180,42,"tableOnFile = true and no table name given");
  static int tmp181 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[33] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[6].tableName PARAM */, MMC_REFSTRINGLIT(tmp179))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[6].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp180)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4669
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[7].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4669(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4669};
  static const MMC_DEFSTRINGLIT(tmp184,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp185,42,"tableOnFile = true and no table name given");
  static int tmp186 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[34] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[7].tableName PARAM */, MMC_REFSTRINGLIT(tmp184))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[7].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp185)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4668
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[8].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4668(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4668};
  static const MMC_DEFSTRINGLIT(tmp189,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp190,42,"tableOnFile = true and no table name given");
  static int tmp191 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[35] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[8].tableName PARAM */, MMC_REFSTRINGLIT(tmp189))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[8].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp190)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4667
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[9].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4667(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4667};
  static const MMC_DEFSTRINGLIT(tmp194,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp195,42,"tableOnFile = true and no table name given");
  static int tmp196 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[36] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[9].tableName PARAM */, MMC_REFSTRINGLIT(tmp194))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[9].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp195)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4666
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[10].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4666(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4666};
  static const MMC_DEFSTRINGLIT(tmp199,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp200,42,"tableOnFile = true and no table name given");
  static int tmp201 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[37] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[10].tableName PARAM */, MMC_REFSTRINGLIT(tmp199))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[10].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp200)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4665
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[11].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4665(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4665};
  static const MMC_DEFSTRINGLIT(tmp204,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp205,42,"tableOnFile = true and no table name given");
  static int tmp206 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[38] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[11].tableName PARAM */, MMC_REFSTRINGLIT(tmp204))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[11].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp205)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4664
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[12].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4664(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4664};
  static const MMC_DEFSTRINGLIT(tmp209,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp210,42,"tableOnFile = true and no table name given");
  static int tmp211 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[39] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[12].tableName PARAM */, MMC_REFSTRINGLIT(tmp209))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[12].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp210)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4663
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[13].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4663(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4663};
  static const MMC_DEFSTRINGLIT(tmp214,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp215,42,"tableOnFile = true and no table name given");
  static int tmp216 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[40] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[13].tableName PARAM */, MMC_REFSTRINGLIT(tmp214))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[13].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp215)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4662
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[14].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4662(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4662};
  static const MMC_DEFSTRINGLIT(tmp219,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp220,42,"tableOnFile = true and no table name given");
  static int tmp221 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[41] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[14].tableName PARAM */, MMC_REFSTRINGLIT(tmp219))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[14].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp220)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4661
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[15].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4661(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4661};
  static const MMC_DEFSTRINGLIT(tmp224,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp225,42,"tableOnFile = true and no table name given");
  static int tmp226 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[42] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[15].tableName PARAM */, MMC_REFSTRINGLIT(tmp224))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[15].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp225)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4660
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[16].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4660(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4660};
  static const MMC_DEFSTRINGLIT(tmp229,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp230,42,"tableOnFile = true and no table name given");
  static int tmp231 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[43] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[16].tableName PARAM */, MMC_REFSTRINGLIT(tmp229))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[16].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp230)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4659
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[17].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4659(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4659};
  static const MMC_DEFSTRINGLIT(tmp234,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp235,42,"tableOnFile = true and no table name given");
  static int tmp236 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[44] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[17].tableName PARAM */, MMC_REFSTRINGLIT(tmp234))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[17].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp235)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4658
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[18].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4658(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4658};
  static const MMC_DEFSTRINGLIT(tmp239,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp240,42,"tableOnFile = true and no table name given");
  static int tmp241 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[45] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[18].tableName PARAM */, MMC_REFSTRINGLIT(tmp239))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[18].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp240)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4657
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[19].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4657(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4657};
  static const MMC_DEFSTRINGLIT(tmp244,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp245,42,"tableOnFile = true and no table name given");
  static int tmp246 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[46] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[19].tableName PARAM */, MMC_REFSTRINGLIT(tmp244))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[19].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp245)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4656
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[20].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4656(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4656};
  static const MMC_DEFSTRINGLIT(tmp249,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp250,42,"tableOnFile = true and no table name given");
  static int tmp251 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[47] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[20].tableName PARAM */, MMC_REFSTRINGLIT(tmp249))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[20].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp250)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4655
type: ALGORITHM

  assert(particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableName <> "NoName", "tableOnFile = true and no table name given");
*/
void PhysicalParticleCO21D_v11_eqFunction_4655(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4655};
  static const MMC_DEFSTRINGLIT(tmp254,6,"NoName");
  static const MMC_DEFSTRINGLIT(tmp255,42,"tableOnFile = true and no table name given");
  static int tmp256 = 0;
  {
    if(!(!stringEqual(data->simulationInfo->stringParameter[48] /* particleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableName PARAM */, MMC_REFSTRINGLIT(tmp254))))
    {
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Blocks/Tables.mo",427,7,428,54,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nparticleReceiver1DCalculator.particleReceiver1D_v11.Tab[21].tableName <> \"NoName\"", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_withEquationIndexes(threadData, info, equationIndexes, MMC_STRINGDATA(MMC_REFSTRINGLIT(tmp255)));
      }
    }
  }
  TRACE_POP
}
/*
equation index: 4654
type: ALGORITHM

  assert(tankHot.p_top >= 0.0, "Pressure (= " + String(tankHot.p_top, 6, 0, true) + " Pa) of medium \"" + "CARBO HSP 40/70" + "\" is negative
(Temperature = " + String(tankHot.T_mea, 6, 0, true) + " K)");
*/
void PhysicalParticleCO21D_v11_eqFunction_4654(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4654};
  modelica_boolean tmp257;
  static const MMC_DEFSTRINGLIT(tmp258,12,"Pressure (= ");
  modelica_string tmp259;
  static const MMC_DEFSTRINGLIT(tmp260,16," Pa) of medium \"");
  static const MMC_DEFSTRINGLIT(tmp261,15,"CARBO HSP 40/70");
  static const MMC_DEFSTRINGLIT(tmp262,29,"\" is negative\n(Temperature = ");
  modelica_string tmp263;
  static const MMC_DEFSTRINGLIT(tmp264,3," K)");
  static int tmp265 = 0;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  {
    tmp257 = GreaterEq(data->localData[0]->realVars[1366] /* tankHot.p_top variable */,0.0);
    if(!tmp257)
    {
      tmp259 = modelica_real_to_modelica_string(data->localData[0]->realVars[1366] /* tankHot.p_top variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp258),tmp259);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp260));
      tmpMeta[2] = stringAppend(tmpMeta[1],MMC_REFSTRINGLIT(tmp261));
      tmpMeta[3] = stringAppend(tmpMeta[2],MMC_REFSTRINGLIT(tmp262));
      tmp263 = modelica_real_to_modelica_string(data->localData[0]->realVars[1350] /* tankHot.T_mea variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[4] = stringAppend(tmpMeta[3],tmp263);
      tmpMeta[5] = stringAppend(tmpMeta[4],MMC_REFSTRINGLIT(tmp264));
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
equation index: 4653
type: ALGORITHM

  assert(tankHot.p_top >= 0.0, "Pressure (= " + String(tankHot.p_top, 6, 0, true) + " Pa) of medium \"" + "CARBO HSP 40/70" + "\" is negative
(Temperature = " + String(particleReceiver1D_v11.T_s[1], 6, 0, true) + " K)");
*/
void PhysicalParticleCO21D_v11_eqFunction_4653(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4653};
  modelica_boolean tmp266;
  static const MMC_DEFSTRINGLIT(tmp267,12,"Pressure (= ");
  modelica_string tmp268;
  static const MMC_DEFSTRINGLIT(tmp269,16," Pa) of medium \"");
  static const MMC_DEFSTRINGLIT(tmp270,15,"CARBO HSP 40/70");
  static const MMC_DEFSTRINGLIT(tmp271,29,"\" is negative\n(Temperature = ");
  modelica_string tmp272;
  static const MMC_DEFSTRINGLIT(tmp273,3," K)");
  static int tmp274 = 0;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  {
    tmp266 = GreaterEq(data->localData[0]->realVars[1366] /* tankHot.p_top variable */,0.0);
    if(!tmp266)
    {
      tmp268 = modelica_real_to_modelica_string(data->localData[0]->realVars[1366] /* tankHot.p_top variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp267),tmp268);
      tmpMeta[1] = stringAppend(tmpMeta[0],MMC_REFSTRINGLIT(tmp269));
      tmpMeta[2] = stringAppend(tmpMeta[1],MMC_REFSTRINGLIT(tmp270));
      tmpMeta[3] = stringAppend(tmpMeta[2],MMC_REFSTRINGLIT(tmp271));
      tmp272 = modelica_real_to_modelica_string(data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */, ((modelica_integer) 6), ((modelica_integer) 0), 1);
      tmpMeta[4] = stringAppend(tmpMeta[3],tmp272);
      tmpMeta[5] = stringAppend(tmpMeta[4],MMC_REFSTRINGLIT(tmp273));
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
int PhysicalParticleCO21D_v11_functionDAE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  int equationIndexes[1] = {0};
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  data->simulationInfo->needToIterate = 0;
  data->simulationInfo->discreteCall = 1;
  PhysicalParticleCO21D_v11_functionLocalKnownVars(data, threadData);
  PhysicalParticleCO21D_v11_eqFunction_3803(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_3804(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_3805(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_3806(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_3807(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4049(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4050(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4051(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4052(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4053(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4054(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4055(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4056(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4057(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4058(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4059(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4060(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4061(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4062(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4063(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4064(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4065(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4066(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4067(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4068(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4069(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4070(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4071(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4072(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4073(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4074(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4075(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4076(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4077(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4078(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4079(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4080(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4081(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4082(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4083(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4084(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4085(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4086(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4087(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4088(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4090(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4091(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4092(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4094(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4095(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4096(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4097(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4098(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4099(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4100(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4102(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4103(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4104(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4105(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4107(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4108(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4109(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4110(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4111(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4112(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4113(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4114(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4115(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4116(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4117(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4118(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4119(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4120(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4121(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4122(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4123(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4124(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4125(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4126(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4127(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4128(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4129(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4130(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4131(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4132(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4133(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4134(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4135(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4136(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4137(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4138(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4139(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4140(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4141(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4142(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4143(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4144(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4145(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4146(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4147(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4148(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4149(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4150(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4151(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4152(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4153(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4154(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4155(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4156(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4157(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4158(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4159(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4160(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4161(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4162(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4163(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4164(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4165(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4166(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4167(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4168(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4169(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4170(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4171(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4172(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4173(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4174(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4175(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4177(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4178(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4179(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4180(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4181(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4182(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4183(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4184(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4185(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4186(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4187(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4188(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4189(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4190(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4191(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4192(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4193(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4194(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4195(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4196(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4197(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4198(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4199(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4200(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4201(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4202(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4203(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4204(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4205(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4206(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4207(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4208(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4209(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4210(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4211(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4212(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4213(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4214(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4215(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4216(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4217(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4218(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4219(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4220(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4221(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4222(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4223(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4224(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4225(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4226(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4227(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4228(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4229(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4230(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4231(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4232(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4233(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4234(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4235(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4236(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4237(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4238(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4239(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4240(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4241(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4242(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4243(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4244(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4245(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4246(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4247(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4248(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4249(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4250(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4251(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4252(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4253(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4254(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4255(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4256(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4257(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4259(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4260(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4261(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4262(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4263(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4264(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4265(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4266(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4267(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4369(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4370(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4371(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4372(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4373(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4374(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4375(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4376(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4377(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4378(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4379(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4380(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4381(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4382(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4383(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4384(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4385(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4386(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4387(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4388(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4389(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4390(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4391(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4392(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4393(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4394(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4395(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4396(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4397(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4398(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4399(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4400(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4401(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4402(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4403(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4404(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4405(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4406(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4407(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4408(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4409(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4410(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4607(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4608(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4609(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4610(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4611(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4612(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4613(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4614(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4615(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4616(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4617(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4618(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4619(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4620(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4621(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4622(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4623(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4624(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4625(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4626(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4627(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4628(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4629(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4630(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4631(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4635(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4636(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4637(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4638(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4639(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4640(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4641(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4642(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4643(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4644(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4645(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4646(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4647(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4648(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4649(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4650(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4651(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4652(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4702(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4701(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4700(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4699(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4698(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4697(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4696(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4695(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4694(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4693(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4692(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4691(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4690(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4689(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4688(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4687(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4686(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4685(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4684(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4683(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4682(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4681(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4680(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4679(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4678(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4677(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4676(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4675(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4674(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4673(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4672(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4671(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4670(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4669(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4668(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4667(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4666(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4665(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4664(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4663(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4662(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4661(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4660(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4659(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4658(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4657(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4656(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4655(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4654(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4653(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif
  TRACE_POP
  return 0;
}


int PhysicalParticleCO21D_v11_functionLocalKnownVars(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


/* forwarded equations */
extern void PhysicalParticleCO21D_v11_eqFunction_4082(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4083(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4084(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4085(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4086(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4087(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4090(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4091(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4095(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4096(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4097(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4098(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4099(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4102(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4103(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4104(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4109(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4110(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4117(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4118(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4132(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4133(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4134(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4135(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4138(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4139(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4140(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4141(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4142(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4146(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4147(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4149(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4150(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4153(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4155(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4156(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4158(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4159(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4161(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4165(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4168(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4169(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4170(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4171(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4172(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4173(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4174(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4177(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4178(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4179(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4180(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4181(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4182(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4183(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4185(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4186(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4187(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4188(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4189(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4190(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4191(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4192(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4193(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4194(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4195(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4196(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4197(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4198(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4199(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4200(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4201(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4202(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4203(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4204(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4205(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4208(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4209(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4210(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4211(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4212(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4213(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4214(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4215(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4216(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4217(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4218(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4219(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4220(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4221(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4222(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4223(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4224(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4225(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4226(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4227(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4228(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4229(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4230(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4231(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4232(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4233(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4234(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4235(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4236(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4237(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4238(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4239(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4240(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4241(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4242(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4243(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4244(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4245(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4248(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4249(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4250(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4252(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4253(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4255(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4256(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4259(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4260(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4261(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4262(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4265(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4266(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4267(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4369(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4373(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4374(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4375(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4393(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4398(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4400(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4402(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4403(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4404(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4405(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4406(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4408(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4409(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4410(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4607(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4630(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4635(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4636(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4638(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4639(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4642(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4643(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4646(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4647(DATA* data, threadData_t *threadData);

static void functionODE_system0(DATA *data, threadData_t *threadData)
{
    PhysicalParticleCO21D_v11_eqFunction_4082(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4083(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4084(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4085(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4086(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4087(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4090(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4091(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4095(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4096(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4097(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4098(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4099(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4102(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4103(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4104(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4109(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4110(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4117(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4118(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4132(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4133(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4134(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4135(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4138(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4139(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4140(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4141(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4142(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4146(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4147(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4149(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4150(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4153(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4155(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4156(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4158(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4159(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4161(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4165(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4168(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4169(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4170(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4171(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4172(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4173(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4174(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4177(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4178(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4179(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4180(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4181(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4182(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4183(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4185(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4186(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4187(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4188(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4189(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4190(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4191(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4192(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4193(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4194(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4195(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4196(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4197(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4198(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4199(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4200(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4201(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4202(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4203(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4204(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4205(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4208(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4209(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4210(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4211(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4212(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4213(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4214(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4215(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4216(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4217(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4218(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4219(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4220(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4221(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4222(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4223(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4224(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4225(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4226(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4227(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4228(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4229(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4230(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4231(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4232(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4233(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4234(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4235(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4236(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4237(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4238(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4239(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4240(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4241(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4242(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4243(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4244(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4245(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4248(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4249(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4250(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4252(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4253(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4255(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4256(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4259(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4260(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4261(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4262(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4265(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4266(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4267(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4369(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4373(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4374(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4375(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4393(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4398(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4400(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4402(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4403(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4404(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4405(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4406(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4408(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4409(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4410(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4607(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4630(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4635(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4636(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4638(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4639(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4642(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4643(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4646(data, threadData);

    PhysicalParticleCO21D_v11_eqFunction_4647(data, threadData);
}

int PhysicalParticleCO21D_v11_functionODE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_FUNCTION_ODE);
#endif

  
  data->simulationInfo->callStatistics.functionODE++;
  
  PhysicalParticleCO21D_v11_functionLocalKnownVars(data, threadData);
  functionODE_system0(data, threadData);

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_FUNCTION_ODE);
#endif

  TRACE_POP
  return 0;
}

/* forward the main in the simulation runtime */
extern int _main_SimulationRuntime(int argc, char**argv, DATA *data, threadData_t *threadData);

#include "PhysicalParticleCO21D_v11_12jac.h"
#include "PhysicalParticleCO21D_v11_13opt.h"

struct OpenModelicaGeneratedFunctionCallbacks PhysicalParticleCO21D_v11_callback = {
   (int (*)(DATA *, threadData_t *, void *)) PhysicalParticleCO21D_v11_performSimulation,
   (int (*)(DATA *, threadData_t *, void *)) PhysicalParticleCO21D_v11_performQSSSimulation,
   PhysicalParticleCO21D_v11_updateContinuousSystem,
   PhysicalParticleCO21D_v11_callExternalObjectDestructors,
   PhysicalParticleCO21D_v11_initialNonLinearSystem,
   PhysicalParticleCO21D_v11_initialLinearSystem,
   NULL,
   #if !defined(OMC_NO_STATESELECTION)
   PhysicalParticleCO21D_v11_initializeStateSets,
   #else
   NULL,
   #endif
   PhysicalParticleCO21D_v11_initializeDAEmodeData,
   PhysicalParticleCO21D_v11_functionODE,
   PhysicalParticleCO21D_v11_functionAlgebraics,
   PhysicalParticleCO21D_v11_functionDAE,
   PhysicalParticleCO21D_v11_functionLocalKnownVars,
   PhysicalParticleCO21D_v11_input_function,
   PhysicalParticleCO21D_v11_input_function_init,
   PhysicalParticleCO21D_v11_input_function_updateStartValues,
   PhysicalParticleCO21D_v11_data_function,
   PhysicalParticleCO21D_v11_output_function,
   PhysicalParticleCO21D_v11_setc_function,
   PhysicalParticleCO21D_v11_function_storeDelayed,
   PhysicalParticleCO21D_v11_updateBoundVariableAttributes,
   PhysicalParticleCO21D_v11_functionInitialEquations,
   1, /* useHomotopy - 0: local homotopy (equidistant lambda), 1: global homotopy (equidistant lambda), 2: new global homotopy approach (adaptive lambda), 3: new local homotopy approach (adaptive lambda)*/
   PhysicalParticleCO21D_v11_functionInitialEquations_lambda0,
   PhysicalParticleCO21D_v11_functionRemovedInitialEquations,
   PhysicalParticleCO21D_v11_updateBoundParameters,
   PhysicalParticleCO21D_v11_checkForAsserts,
   PhysicalParticleCO21D_v11_function_ZeroCrossingsEquations,
   PhysicalParticleCO21D_v11_function_ZeroCrossings,
   PhysicalParticleCO21D_v11_function_updateRelations,
   PhysicalParticleCO21D_v11_zeroCrossingDescription,
   PhysicalParticleCO21D_v11_relationDescription,
   PhysicalParticleCO21D_v11_function_initSample,
   PhysicalParticleCO21D_v11_INDEX_JAC_A,
   PhysicalParticleCO21D_v11_INDEX_JAC_B,
   PhysicalParticleCO21D_v11_INDEX_JAC_C,
   PhysicalParticleCO21D_v11_INDEX_JAC_D,
   PhysicalParticleCO21D_v11_INDEX_JAC_F,
   PhysicalParticleCO21D_v11_initialAnalyticJacobianA,
   PhysicalParticleCO21D_v11_initialAnalyticJacobianB,
   PhysicalParticleCO21D_v11_initialAnalyticJacobianC,
   PhysicalParticleCO21D_v11_initialAnalyticJacobianD,
   PhysicalParticleCO21D_v11_initialAnalyticJacobianF,
   PhysicalParticleCO21D_v11_functionJacA_column,
   PhysicalParticleCO21D_v11_functionJacB_column,
   PhysicalParticleCO21D_v11_functionJacC_column,
   PhysicalParticleCO21D_v11_functionJacD_column,
   PhysicalParticleCO21D_v11_functionJacF_column,
   PhysicalParticleCO21D_v11_linear_model_frame,
   PhysicalParticleCO21D_v11_linear_model_datarecovery_frame,
   PhysicalParticleCO21D_v11_mayer,
   PhysicalParticleCO21D_v11_lagrange,
   PhysicalParticleCO21D_v11_pickUpBoundsForInputsInOptimization,
   PhysicalParticleCO21D_v11_setInputData,
   PhysicalParticleCO21D_v11_getTimeGrid,
   PhysicalParticleCO21D_v11_symbolicInlineSystem,
   PhysicalParticleCO21D_v11_function_initSynchronous,
   PhysicalParticleCO21D_v11_function_updateSynchronous,
   PhysicalParticleCO21D_v11_function_equationsSynchronous,
   PhysicalParticleCO21D_v11_inputNames,
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

#define _OMC_LIT_RESOURCE_3_name_data "PhysicalParticleCO21D_v11"
#define _OMC_LIT_RESOURCE_3_dir_data "/home/philgun/solartherm/examples"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_name,25,_OMC_LIT_RESOURCE_3_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir,33,_OMC_LIT_RESOURCE_3_dir_data);

#define _OMC_LIT_RESOURCE_4_name_data "SolarTherm"
#define _OMC_LIT_RESOURCE_4_dir_data "/home/philgun/.local/lib/omlibrary/SolarTherm"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_name,10,_OMC_LIT_RESOURCE_4_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir,45,_OMC_LIT_RESOURCE_4_dir_data);

static const MMC_DEFSTRUCTLIT(_OMC_LIT_RESOURCES,10,MMC_ARRAY_TAG) {MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir)}};
void PhysicalParticleCO21D_v11_setupDataStruc(DATA *data, threadData_t *threadData)
{
  assertStreamPrint(threadData,0!=data, "Error while initialize Data");
  threadData->localRoots[LOCAL_ROOT_SIMULATION_DATA] = data;
  data->callback = &PhysicalParticleCO21D_v11_callback;
  OpenModelica_updateUriMapping(threadData, MMC_REFSTRUCTLIT(_OMC_LIT_RESOURCES));
  data->modelData->modelName = "PhysicalParticleCO21D_v11";
  data->modelData->modelFilePrefix = "PhysicalParticleCO21D_v11";
  data->modelData->resultFileName = NULL;
  data->modelData->modelDir = "/home/philgun/solartherm/examples";
  data->modelData->modelGUID = "{22aafe59-0b3d-48ff-ac3a-2f3d4d870e2f}";
  #if defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME)
  data->modelData->initXMLData = NULL;
  data->modelData->modelDataXml.infoXMLData = NULL;
  #else
  #if defined(_MSC_VER) /* handle joke compilers */
  {
  /* for MSVC we encode a string like char x[] = {'a', 'b', 'c', '\0'} */
  /* because the string constant limit is 65535 bytes */
  static const char contents_init[] =
    #include "PhysicalParticleCO21D_v11_init.c"
    ;
  static const char contents_info[] =
    #include "PhysicalParticleCO21D_v11_info.c"
    ;
    data->modelData->initXMLData = contents_init;
    data->modelData->modelDataXml.infoXMLData = contents_info;
  }
  #else /* handle real compilers */
  data->modelData->initXMLData =
  #include "PhysicalParticleCO21D_v11_init.c"
    ;
  data->modelData->modelDataXml.infoXMLData =
  #include "PhysicalParticleCO21D_v11_info.c"
    ;
  #endif /* defined(_MSC_VER) */
  #endif /* defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME) */
  
  data->modelData->nStates = 17;
  data->modelData->nVariablesReal = 1373;
  data->modelData->nDiscreteReal = 5;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 29;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 831;
  data->modelData->nParametersInteger = 164;
  data->modelData->nParametersBoolean = 141;
  data->modelData->nParametersString = 95;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  
  data->modelData->nAliasReal = 470;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 17;
  data->modelData->nAliasString = 0;
  
  data->modelData->nZeroCrossings = 25;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 26;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 88;
  
  data->modelData->modelDataXml.fileName = "PhysicalParticleCO21D_v11_info.json";
  data->modelData->modelDataXml.modelInfoXmlLength = 0;
  data->modelData->modelDataXml.nFunctions = 129;
  data->modelData->modelDataXml.nProfileBlocks = 0;
  data->modelData->modelDataXml.nEquations = 6534;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 2;
  data->modelData->nNonLinearSystems = 48;
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
  
    PhysicalParticleCO21D_v11_setupDataStruc(&data, threadData);
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


