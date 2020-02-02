/* Events: Sample, Zero Crossings, Relations, Discrete Changes */
#include "PhysicalParticleCO21D_v11_model.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* Initializes the raw time events of the simulation using the now
   calcualted parameters. */
void PhysicalParticleCO21D_v11_function_initSample(DATA *data, threadData_t *threadData)
{
  long i=0;
}

const char *PhysicalParticleCO21D_v11_zeroCrossingDescription(int i, int **out_EquationIndexes)
{
  static const char *res[] = {"time >= pre(data.table.nextTimeEvent)",
  "heliostatsField.ele > 0.01",
  "time > 31449600.0",
  "simpleReceiverControl.hotTank.level_ref > simpleReceiverControl.defocusLogic.level_max",
  "simpleReceiverControl.hotTank.level_ref < simpleReceiverControl.defocusLogic.level_min",
  "simpleReceiverControl.hotTank.level_ref > simpleReceiverControl.hotTank.level_max",
  "simpleReceiverControl.hotTank.level_ref < simpleReceiverControl.hotTank.level_min",
  "controlHot.logic.level > controlHot.defocus_logic.level_max",
  "controlHot.logic.level < controlHot.defocus_logic.level_min",
  "controlHot.logic.level > controlHot.logic.level_on",
  "controlHot.logic.level < controlHot.logic.level_off",
  "heliostatsField.ele > heliostatsField.ele_min and Wspd_input.y < heliostatsField.Wspd_max",
  "tankHot.T_mea < tankHot.T_set",
  "particleReceiver1D_v11.T_s[1] < tankCold.T_set",
  "heliostatsField.Q_raw > heliostatsField.Q_start",
  "heliostatsField.Q_raw < heliostatsField.Q_min",
  "heliostatsField.Q_incident > 1e-06",
  "heliostatsField.Q_incident <= 1e-06",
  "time < heliostatsField.t_on + heliostatsField.t_start",
  "particleReceiver1D_v11.mdot > 1e-06",
  "particleReceiver1D_v11.mdot < 1e-06",
  "controlHot.m_flow_in > 0.0",
  "time - controlHot.logic.t_off < controlHot.logic.t_standby",
  "time - controlHot.logic.t_on > controlHot.logic.t_start",
  "(-LiftCold.fluid_b.m_flow) >= powerBlock.exchanger.m_HTF_des * powerBlock.nu_min"};
  static const int occurEqs0[] = {1,4110};
  static const int occurEqs1[] = {1,4162};
  static const int occurEqs2[] = {1,4108};
  static const int occurEqs3[] = {1,4098};
  static const int occurEqs4[] = {1,4099};
  static const int occurEqs5[] = {1,4103};
  static const int occurEqs6[] = {1,4104};
  static const int occurEqs7[] = {1,4086};
  static const int occurEqs8[] = {1,4087};
  static const int occurEqs9[] = {1,4090};
  static const int occurEqs10[] = {1,4091};
  static const int occurEqs11[] = {1,4165};
  static const int occurEqs12[] = {1,4156};
  static const int occurEqs13[] = {1,4150};
  static const int occurEqs14[] = {1,4173};
  static const int occurEqs15[] = {1,4174};
  static const int occurEqs16[] = {1,4180};
  static const int occurEqs17[] = {1,4180};
  static const int occurEqs18[] = {1,4650};
  static const int occurEqs19[] = {1,4186};
  static const int occurEqs20[] = {1,4248};
  static const int occurEqs21[] = {1,4249};
  static const int occurEqs22[] = {1,4252};
  static const int occurEqs23[] = {1,4256};
  static const int occurEqs24[] = {1,4265};
  static const int *occurEqs[] = {occurEqs0,occurEqs1,occurEqs2,occurEqs3,occurEqs4,occurEqs5,occurEqs6,occurEqs7,occurEqs8,occurEqs9,occurEqs10,occurEqs11,occurEqs12,occurEqs13,occurEqs14,occurEqs15,occurEqs16,occurEqs17,occurEqs18,occurEqs19,occurEqs20,occurEqs21,occurEqs22,occurEqs23,occurEqs24};
  *out_EquationIndexes = (int*) occurEqs[i];
  return res[i];
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
extern void PhysicalParticleCO21D_v11_eqFunction_4162(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4165(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4168(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4169(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4170(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4171(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4173(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4174(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4177(DATA* data, threadData_t *threadData);
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
extern void PhysicalParticleCO21D_v11_eqFunction_4374(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4408(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4409(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4410(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4607(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4630(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4635(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_v11_eqFunction_4636(DATA* data, threadData_t *threadData);

int PhysicalParticleCO21D_v11_function_ZeroCrossingsEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->callStatistics.functionZeroCrossingsEquations++;

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

  PhysicalParticleCO21D_v11_eqFunction_4162(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4165(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4168(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4169(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4170(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4171(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4173(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4174(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4177(data, threadData);

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

  PhysicalParticleCO21D_v11_eqFunction_4374(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4408(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4409(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4410(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4607(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4630(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4635(data, threadData);

  PhysicalParticleCO21D_v11_eqFunction_4636(data, threadData);
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_v11_function_ZeroCrossings(DATA *data, threadData_t *threadData, double *gout)
{
  TRACE_PUSH
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  modelica_boolean tmp2;
  modelica_boolean tmp3;
  modelica_boolean tmp4;
  modelica_boolean tmp5;
  modelica_boolean tmp6;
  modelica_boolean tmp7;
  modelica_boolean tmp8;
  modelica_boolean tmp9;
  modelica_boolean tmp10;
  modelica_boolean tmp11;
  modelica_boolean tmp12;
  modelica_boolean tmp13;
  modelica_boolean tmp14;
  modelica_boolean tmp15;
  modelica_boolean tmp16;
  modelica_boolean tmp17;
  modelica_boolean tmp18;
  modelica_boolean tmp19;
  modelica_boolean tmp20;
  modelica_boolean tmp21;
  modelica_boolean tmp22;
  modelica_boolean tmp23;
  modelica_boolean tmp24;
  modelica_boolean tmp25;

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_ZC);
#endif
  data->simulationInfo->callStatistics.functionZeroCrossings++;

  tmp0 = GreaterEqZC(data->localData[0]->timeValue, data->simulationInfo->realVarsPre[1370] /* data.table.nextTimeEvent DISCRETE */, data->simulationInfo->storedRelations[0]);
  gout[0] = (tmp0) ? 1 : -1;
  tmp1 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, data->simulationInfo->storedRelations[1]);
  gout[1] = (tmp1) ? 1 : -1;
  tmp2 = GreaterZC(data->localData[0]->timeValue, 31449600.0, data->simulationInfo->storedRelations[2]);
  gout[2] = (tmp2) ? 1 : -1;
  tmp3 = GreaterZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_max PARAM */, data->simulationInfo->storedRelations[3]);
  gout[3] = (tmp3) ? 1 : -1;
  tmp4 = LessZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[773] /* simpleReceiverControl.defocusLogic.level_min PARAM */, data->simulationInfo->storedRelations[4]);
  gout[4] = (tmp4) ? 1 : -1;
  tmp5 = GreaterZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_max PARAM */, data->simulationInfo->storedRelations[5]);
  gout[5] = (tmp5) ? 1 : -1;
  tmp6 = LessZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[776] /* simpleReceiverControl.hotTank.level_min PARAM */, data->simulationInfo->storedRelations[6]);
  gout[6] = (tmp6) ? 1 : -1;
  tmp7 = GreaterZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */, data->simulationInfo->storedRelations[7]);
  gout[7] = (tmp7) ? 1 : -1;
  tmp8 = LessZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */, data->simulationInfo->storedRelations[8]);
  gout[8] = (tmp8) ? 1 : -1;
  tmp9 = GreaterZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */, data->simulationInfo->storedRelations[9]);
  gout[9] = (tmp9) ? 1 : -1;
  tmp10 = LessZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */, data->simulationInfo->storedRelations[10]);
  gout[10] = (tmp10) ? 1 : -1;
  tmp11 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */, data->simulationInfo->storedRelations[11]);
  tmp12 = LessZC(data->localData[0]->realVars[57] /* Wspd_input.y variable */, data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */, data->simulationInfo->storedRelations[12]);
  gout[11] = ((tmp11 && tmp12)) ? 1 : -1;
  tmp13 = LessZC(data->localData[0]->realVars[1350] /* tankHot.T_mea variable */, data->simulationInfo->realParameter[812] /* tankHot.T_set PARAM */, data->simulationInfo->storedRelations[13]);
  gout[12] = (tmp13) ? 1 : -1;
  tmp14 = LessZC(data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */, data->simulationInfo->realParameter[802] /* tankCold.T_set PARAM */, data->simulationInfo->storedRelations[14]);
  gout[13] = (tmp14) ? 1 : -1;
  tmp15 = GreaterZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */, data->simulationInfo->storedRelations[15]);
  gout[14] = (tmp15) ? 1 : -1;
  tmp16 = LessZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */, data->simulationInfo->storedRelations[16]);
  gout[15] = (tmp16) ? 1 : -1;
  tmp17 = GreaterZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[17]);
  gout[16] = (tmp17) ? 1 : -1;
  tmp18 = LessEqZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[18]);
  gout[17] = (tmp18) ? 1 : -1;
  tmp19 = LessZC(data->localData[0]->timeValue, data->localData[0]->realVars[1372] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */, data->simulationInfo->storedRelations[19]);
  gout[18] = (tmp19) ? 1 : -1;
  tmp20 = GreaterZC(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, data->simulationInfo->storedRelations[20]);
  gout[19] = (tmp20) ? 1 : -1;
  tmp21 = LessZC(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, data->simulationInfo->storedRelations[21]);
  gout[20] = (tmp21) ? 1 : -1;
  tmp22 = GreaterZC(data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */, 0.0, data->simulationInfo->storedRelations[22]);
  gout[21] = (tmp22) ? 1 : -1;
  tmp23 = LessZC(data->localData[0]->timeValue - data->localData[0]->realVars[1368] /* controlHot.logic.t_off DISCRETE */, data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */, data->simulationInfo->storedRelations[23]);
  gout[22] = (tmp23) ? 1 : -1;
  tmp24 = GreaterZC(data->localData[0]->timeValue - data->localData[0]->realVars[1369] /* controlHot.logic.t_on DISCRETE */, data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */, data->simulationInfo->storedRelations[24]);
  gout[23] = (tmp24) ? 1 : -1;
  tmp25 = GreaterEqZC((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */), (data->simulationInfo->realParameter[658] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[694] /* powerBlock.nu_min PARAM */), data->simulationInfo->storedRelations[25]);
  gout[24] = (tmp25) ? 1 : -1;

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_ZC);
#endif

  TRACE_POP
  return 0;
}

const char *PhysicalParticleCO21D_v11_relationDescription(int i)
{
  const char *res[] = {"time >= pre(data.table.nextTimeEvent)",
  "heliostatsField.ele > 0.01",
  "time > 31449600.0",
  "simpleReceiverControl.hotTank.level_ref > simpleReceiverControl.defocusLogic.level_max",
  "simpleReceiverControl.hotTank.level_ref < simpleReceiverControl.defocusLogic.level_min",
  "simpleReceiverControl.hotTank.level_ref > simpleReceiverControl.hotTank.level_max",
  "simpleReceiverControl.hotTank.level_ref < simpleReceiverControl.hotTank.level_min",
  "controlHot.logic.level > controlHot.defocus_logic.level_max",
  "controlHot.logic.level < controlHot.defocus_logic.level_min",
  "controlHot.logic.level > controlHot.logic.level_on",
  "controlHot.logic.level < controlHot.logic.level_off",
  "heliostatsField.ele > heliostatsField.ele_min",
  "Wspd_input.y < heliostatsField.Wspd_max",
  "tankHot.T_mea < tankHot.T_set",
  "particleReceiver1D_v11.T_s[1] < tankCold.T_set",
  "heliostatsField.Q_raw > heliostatsField.Q_start",
  "heliostatsField.Q_raw < heliostatsField.Q_min",
  "heliostatsField.Q_incident > 1e-06",
  "heliostatsField.Q_incident <= 1e-06",
  "time < heliostatsField.t_on + heliostatsField.t_start",
  "particleReceiver1D_v11.mdot > 1e-06",
  "particleReceiver1D_v11.mdot < 1e-06",
  "controlHot.m_flow_in > 0.0",
  "time - controlHot.logic.t_off < controlHot.logic.t_standby",
  "time - controlHot.logic.t_on > controlHot.logic.t_start",
  "(-LiftCold.fluid_b.m_flow) >= powerBlock.exchanger.m_HTF_des * powerBlock.nu_min"};
  return res[i];
}

int PhysicalParticleCO21D_v11_function_updateRelations(DATA *data, threadData_t *threadData, int evalforZeroCross)
{
  TRACE_PUSH
  modelica_boolean tmp26;
  modelica_boolean tmp27;
  modelica_boolean tmp28;
  modelica_boolean tmp29;
  modelica_boolean tmp30;
  modelica_boolean tmp31;
  modelica_boolean tmp32;
  modelica_boolean tmp33;
  modelica_boolean tmp34;
  modelica_boolean tmp35;
  modelica_boolean tmp36;
  modelica_boolean tmp37;
  modelica_boolean tmp38;
  modelica_boolean tmp39;
  modelica_boolean tmp40;
  modelica_boolean tmp41;
  modelica_boolean tmp42;
  modelica_boolean tmp43;
  modelica_boolean tmp44;
  modelica_boolean tmp45;
  modelica_boolean tmp46;
  modelica_boolean tmp47;
  modelica_boolean tmp48;
  modelica_boolean tmp49;
  modelica_boolean tmp50;
  modelica_boolean tmp51;
  
  if(evalforZeroCross) {
    tmp26 = GreaterEqZC(data->localData[0]->timeValue, data->simulationInfo->realVarsPre[1370] /* data.table.nextTimeEvent DISCRETE */, data->simulationInfo->storedRelations[0]);
    data->simulationInfo->relations[0] = tmp26;
    tmp27 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, data->simulationInfo->storedRelations[1]);
    data->simulationInfo->relations[1] = tmp27;
    tmp28 = GreaterZC(data->localData[0]->timeValue, 31449600.0, data->simulationInfo->storedRelations[2]);
    data->simulationInfo->relations[2] = tmp28;
    tmp29 = GreaterZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_max PARAM */, data->simulationInfo->storedRelations[3]);
    data->simulationInfo->relations[3] = tmp29;
    tmp30 = LessZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[773] /* simpleReceiverControl.defocusLogic.level_min PARAM */, data->simulationInfo->storedRelations[4]);
    data->simulationInfo->relations[4] = tmp30;
    tmp31 = GreaterZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_max PARAM */, data->simulationInfo->storedRelations[5]);
    data->simulationInfo->relations[5] = tmp31;
    tmp32 = LessZC(data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */, data->simulationInfo->realParameter[776] /* simpleReceiverControl.hotTank.level_min PARAM */, data->simulationInfo->storedRelations[6]);
    data->simulationInfo->relations[6] = tmp32;
    tmp33 = GreaterZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */, data->simulationInfo->storedRelations[7]);
    data->simulationInfo->relations[7] = tmp33;
    tmp34 = LessZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */, data->simulationInfo->storedRelations[8]);
    data->simulationInfo->relations[8] = tmp34;
    tmp35 = GreaterZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */, data->simulationInfo->storedRelations[9]);
    data->simulationInfo->relations[9] = tmp35;
    tmp36 = LessZC(data->localData[0]->realVars[59] /* controlHot.logic.level variable */, data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */, data->simulationInfo->storedRelations[10]);
    data->simulationInfo->relations[10] = tmp36;
    tmp37 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */, data->simulationInfo->storedRelations[11]);
    data->simulationInfo->relations[11] = tmp37;
    tmp38 = LessZC(data->localData[0]->realVars[57] /* Wspd_input.y variable */, data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */, data->simulationInfo->storedRelations[12]);
    data->simulationInfo->relations[12] = tmp38;
    tmp39 = LessZC(data->localData[0]->realVars[1350] /* tankHot.T_mea variable */, data->simulationInfo->realParameter[812] /* tankHot.T_set PARAM */, data->simulationInfo->storedRelations[13]);
    data->simulationInfo->relations[13] = tmp39;
    tmp40 = LessZC(data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */, data->simulationInfo->realParameter[802] /* tankCold.T_set PARAM */, data->simulationInfo->storedRelations[14]);
    data->simulationInfo->relations[14] = tmp40;
    tmp41 = GreaterZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */, data->simulationInfo->storedRelations[15]);
    data->simulationInfo->relations[15] = tmp41;
    tmp42 = LessZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */, data->simulationInfo->storedRelations[16]);
    data->simulationInfo->relations[16] = tmp42;
    tmp43 = GreaterZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[17]);
    data->simulationInfo->relations[17] = tmp43;
    tmp44 = LessEqZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[18]);
    data->simulationInfo->relations[18] = tmp44;
    tmp45 = LessZC(data->localData[0]->timeValue, data->localData[0]->realVars[1372] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */, data->simulationInfo->storedRelations[19]);
    data->simulationInfo->relations[19] = tmp45;
    tmp46 = GreaterZC(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, data->simulationInfo->storedRelations[20]);
    data->simulationInfo->relations[20] = tmp46;
    tmp47 = LessZC(data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */, 1e-06, data->simulationInfo->storedRelations[21]);
    data->simulationInfo->relations[21] = tmp47;
    tmp48 = GreaterZC(data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */, 0.0, data->simulationInfo->storedRelations[22]);
    data->simulationInfo->relations[22] = tmp48;
    tmp49 = LessZC(data->localData[0]->timeValue - data->localData[0]->realVars[1368] /* controlHot.logic.t_off DISCRETE */, data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */, data->simulationInfo->storedRelations[23]);
    data->simulationInfo->relations[23] = tmp49;
    tmp50 = GreaterZC(data->localData[0]->timeValue - data->localData[0]->realVars[1369] /* controlHot.logic.t_on DISCRETE */, data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */, data->simulationInfo->storedRelations[24]);
    data->simulationInfo->relations[24] = tmp50;
    tmp51 = GreaterEqZC((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */), (data->simulationInfo->realParameter[658] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[694] /* powerBlock.nu_min PARAM */), data->simulationInfo->storedRelations[25]);
    data->simulationInfo->relations[25] = tmp51;
  } else {
    data->simulationInfo->relations[0] = (data->localData[0]->timeValue >= data->simulationInfo->realVarsPre[1370] /* data.table.nextTimeEvent DISCRETE */);
    data->simulationInfo->relations[1] = (data->localData[0]->realVars[92] /* heliostatsField.ele variable */ > 0.01);
    data->simulationInfo->relations[2] = (data->localData[0]->timeValue > 31449600.0);
    data->simulationInfo->relations[3] = (data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */ > data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_max PARAM */);
    data->simulationInfo->relations[4] = (data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */ < data->simulationInfo->realParameter[773] /* simpleReceiverControl.defocusLogic.level_min PARAM */);
    data->simulationInfo->relations[5] = (data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */ > data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_max PARAM */);
    data->simulationInfo->relations[6] = (data->localData[0]->realVars[1322] /* simpleReceiverControl.hotTank.level_ref variable */ < data->simulationInfo->realParameter[776] /* simpleReceiverControl.hotTank.level_min PARAM */);
    data->simulationInfo->relations[7] = (data->localData[0]->realVars[59] /* controlHot.logic.level variable */ > data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */);
    data->simulationInfo->relations[8] = (data->localData[0]->realVars[59] /* controlHot.logic.level variable */ < data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */);
    data->simulationInfo->relations[9] = (data->localData[0]->realVars[59] /* controlHot.logic.level variable */ > data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */);
    data->simulationInfo->relations[10] = (data->localData[0]->realVars[59] /* controlHot.logic.level variable */ < data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */);
    data->simulationInfo->relations[11] = (data->localData[0]->realVars[92] /* heliostatsField.ele variable */ > data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */);
    data->simulationInfo->relations[12] = (data->localData[0]->realVars[57] /* Wspd_input.y variable */ < data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */);
    data->simulationInfo->relations[13] = (data->localData[0]->realVars[1350] /* tankHot.T_mea variable */ < data->simulationInfo->realParameter[812] /* tankHot.T_set PARAM */);
    data->simulationInfo->relations[14] = (data->localData[0]->realVars[767] /* particleReceiver1D_v11.T_s[1] variable */ < data->simulationInfo->realParameter[802] /* tankCold.T_set PARAM */);
    data->simulationInfo->relations[15] = (data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */ > data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */);
    data->simulationInfo->relations[16] = (data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */ < data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */);
    data->simulationInfo->relations[17] = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */ > 1e-06);
    data->simulationInfo->relations[18] = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */ <= 1e-06);
    data->simulationInfo->relations[19] = (data->localData[0]->timeValue < data->localData[0]->realVars[1372] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */);
    data->simulationInfo->relations[20] = (data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */ > 1e-06);
    data->simulationInfo->relations[21] = (data->localData[0]->realVars[975] /* particleReceiver1D_v11.mdot variable */ < 1e-06);
    data->simulationInfo->relations[22] = (data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */ > 0.0);
    data->simulationInfo->relations[23] = (data->localData[0]->timeValue - data->localData[0]->realVars[1368] /* controlHot.logic.t_off DISCRETE */ < data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */);
    data->simulationInfo->relations[24] = (data->localData[0]->timeValue - data->localData[0]->realVars[1369] /* controlHot.logic.t_on DISCRETE */ > data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */);
    data->simulationInfo->relations[25] = ((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */) >= (data->simulationInfo->realParameter[658] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[694] /* powerBlock.nu_min PARAM */));
  }
  
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

