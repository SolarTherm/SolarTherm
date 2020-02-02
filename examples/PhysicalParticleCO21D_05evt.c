/* Events: Sample, Zero Crossings, Relations, Discrete Changes */
#include "PhysicalParticleCO21D_model.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* Initializes the raw time events of the simulation using the now
   calcualted parameters. */
void PhysicalParticleCO21D_function_initSample(DATA *data, threadData_t *threadData)
{
  long i=0;
}

const char *PhysicalParticleCO21D_zeroCrossingDescription(int i, int **out_EquationIndexes)
{
  static const char *res[] = {"heliostatsField.ele > 0.01",
  "time >= pre(data.table.nextTimeEvent)",
  "controlHot.defocus_logic.level_ref > controlHot.defocus_logic.level_max",
  "controlHot.defocus_logic.level_ref < controlHot.defocus_logic.level_min",
  "controlHot.defocus_logic.level_ref > controlHot.logic.level_on",
  "controlHot.defocus_logic.level_ref < controlHot.logic.level_off",
  "simpleReceiverControl.defocusLogic.level_ref > simpleReceiverControl.defocusLogic.level_max",
  "simpleReceiverControl.defocusLogic.level_ref < simpleReceiverControl.defocusLogic.level_min",
  "simpleReceiverControl.defocusLogic.level_ref > simpleReceiverControl.hotTank.level_max",
  "simpleReceiverControl.defocusLogic.level_ref < simpleReceiverControl.hotTank.level_min",
  "time > 31449600.0",
  "particleReceiver1D.T_s[1] < tankCold.T_set",
  "tankHot.T_mea < tankHot.T_set",
  "heliostatsField.ele > heliostatsField.ele_min and Wspd_input.y < heliostatsField.Wspd_max",
  "heliostatsField.Q_raw > heliostatsField.Q_start",
  "heliostatsField.Q_raw < heliostatsField.Q_min",
  "heliostatsField.Q_incident > 1e-06",
  "heliostatsField.Q_incident <= 1e-06",
  "controlHot.m_flow_in > 0.0",
  "time - controlHot.logic.t_on > controlHot.logic.t_start",
  "time - controlHot.logic.t_off < controlHot.logic.t_standby",
  "(-LiftCold.fluid_b.m_flow) >= powerBlock.exchanger.m_HTF_des * powerBlock.nu_min",
  "particleReceiver1D.mdot == 0.0",
  "time < heliostatsField.t_on + heliostatsField.t_start"};
  static const int occurEqs0[] = {1,4198};
  static const int occurEqs1[] = {1,4158};
  static const int occurEqs2[] = {1,4146};
  static const int occurEqs3[] = {1,4147};
  static const int occurEqs4[] = {1,4151};
  static const int occurEqs5[] = {1,4152};
  static const int occurEqs6[] = {1,4134};
  static const int occurEqs7[] = {1,4135};
  static const int occurEqs8[] = {1,4138};
  static const int occurEqs9[] = {1,4139};
  static const int occurEqs10[] = {1,4131};
  static const int occurEqs11[] = {1,4235};
  static const int occurEqs12[] = {1,4229};
  static const int occurEqs13[] = {1,4201};
  static const int occurEqs14[] = {1,4209};
  static const int occurEqs15[] = {1,4210};
  static const int occurEqs16[] = {1,4237};
  static const int occurEqs17[] = {1,4237};
  static const int occurEqs18[] = {1,4240};
  static const int occurEqs19[] = {1,4243};
  static const int occurEqs20[] = {1,4246};
  static const int occurEqs21[] = {1,4252};
  static const int occurEqs22[] = {1,4099};
  static const int occurEqs23[] = {1,4223};
  static const int *occurEqs[] = {occurEqs0,occurEqs1,occurEqs2,occurEqs3,occurEqs4,occurEqs5,occurEqs6,occurEqs7,occurEqs8,occurEqs9,occurEqs10,occurEqs11,occurEqs12,occurEqs13,occurEqs14,occurEqs15,occurEqs16,occurEqs17,occurEqs18,occurEqs19,occurEqs20,occurEqs21,occurEqs22,occurEqs23};
  *out_EquationIndexes = (int*) occurEqs[i];
  return res[i];
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
extern void PhysicalParticleCO21D_eqFunction_4169(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4170(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4171(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4172(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4186(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4187(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4194(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4195(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4197(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4198(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4201(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4204(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4205(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4206(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4207(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4209(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4210(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4214(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4215(DATA* data, threadData_t *threadData);
extern void PhysicalParticleCO21D_eqFunction_4218(DATA* data, threadData_t *threadData);
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
extern void PhysicalParticleCO21D_eqFunction_4695(DATA* data, threadData_t *threadData);

int PhysicalParticleCO21D_function_ZeroCrossingsEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->callStatistics.functionZeroCrossingsEquations++;

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

  PhysicalParticleCO21D_eqFunction_4169(data, threadData);

  PhysicalParticleCO21D_eqFunction_4170(data, threadData);

  PhysicalParticleCO21D_eqFunction_4171(data, threadData);

  PhysicalParticleCO21D_eqFunction_4172(data, threadData);

  PhysicalParticleCO21D_eqFunction_4186(data, threadData);

  PhysicalParticleCO21D_eqFunction_4187(data, threadData);

  PhysicalParticleCO21D_eqFunction_4194(data, threadData);

  PhysicalParticleCO21D_eqFunction_4195(data, threadData);

  PhysicalParticleCO21D_eqFunction_4197(data, threadData);

  PhysicalParticleCO21D_eqFunction_4198(data, threadData);

  PhysicalParticleCO21D_eqFunction_4201(data, threadData);

  PhysicalParticleCO21D_eqFunction_4204(data, threadData);

  PhysicalParticleCO21D_eqFunction_4205(data, threadData);

  PhysicalParticleCO21D_eqFunction_4206(data, threadData);

  PhysicalParticleCO21D_eqFunction_4207(data, threadData);

  PhysicalParticleCO21D_eqFunction_4209(data, threadData);

  PhysicalParticleCO21D_eqFunction_4210(data, threadData);

  PhysicalParticleCO21D_eqFunction_4214(data, threadData);

  PhysicalParticleCO21D_eqFunction_4215(data, threadData);

  PhysicalParticleCO21D_eqFunction_4218(data, threadData);

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

  PhysicalParticleCO21D_eqFunction_4695(data, threadData);
  
  TRACE_POP
  return 0;
}

int PhysicalParticleCO21D_function_ZeroCrossings(DATA *data, threadData_t *threadData, double *gout)
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
  modelica_boolean tmp24;

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_ZC);
#endif
  data->simulationInfo->callStatistics.functionZeroCrossings++;

  tmp0 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, data->simulationInfo->storedRelations[0]);
  gout[0] = (tmp0) ? 1 : -1;
  tmp1 = GreaterEqZC(data->localData[0]->timeValue, data->simulationInfo->realVarsPre[1168] /* data.table.nextTimeEvent DISCRETE */, data->simulationInfo->storedRelations[1]);
  gout[1] = (tmp1) ? 1 : -1;
  tmp2 = GreaterZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */, data->simulationInfo->storedRelations[2]);
  gout[2] = (tmp2) ? 1 : -1;
  tmp3 = LessZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */, data->simulationInfo->storedRelations[3]);
  gout[3] = (tmp3) ? 1 : -1;
  tmp4 = GreaterZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */, data->simulationInfo->storedRelations[4]);
  gout[4] = (tmp4) ? 1 : -1;
  tmp5 = LessZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */, data->simulationInfo->storedRelations[5]);
  gout[5] = (tmp5) ? 1 : -1;
  tmp6 = GreaterZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[771] /* simpleReceiverControl.defocusLogic.level_max PARAM */, data->simulationInfo->storedRelations[6]);
  gout[6] = (tmp6) ? 1 : -1;
  tmp7 = LessZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_min PARAM */, data->simulationInfo->storedRelations[7]);
  gout[7] = (tmp7) ? 1 : -1;
  tmp8 = GreaterZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[774] /* simpleReceiverControl.hotTank.level_max PARAM */, data->simulationInfo->storedRelations[8]);
  gout[8] = (tmp8) ? 1 : -1;
  tmp9 = LessZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_min PARAM */, data->simulationInfo->storedRelations[9]);
  gout[9] = (tmp9) ? 1 : -1;
  tmp10 = GreaterZC(data->localData[0]->timeValue, 31449600.0, data->simulationInfo->storedRelations[10]);
  gout[10] = (tmp10) ? 1 : -1;
  tmp11 = LessZC(data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */, data->simulationInfo->realParameter[801] /* tankCold.T_set PARAM */, data->simulationInfo->storedRelations[11]);
  gout[11] = (tmp11) ? 1 : -1;
  tmp12 = LessZC(data->localData[0]->realVars[1148] /* tankHot.T_mea variable */, data->simulationInfo->realParameter[811] /* tankHot.T_set PARAM */, data->simulationInfo->storedRelations[12]);
  gout[12] = (tmp12) ? 1 : -1;
  tmp13 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */, data->simulationInfo->storedRelations[13]);
  tmp14 = LessZC(data->localData[0]->realVars[57] /* Wspd_input.y variable */, data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */, data->simulationInfo->storedRelations[14]);
  gout[13] = ((tmp13 && tmp14)) ? 1 : -1;
  tmp15 = GreaterZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */, data->simulationInfo->storedRelations[15]);
  gout[14] = (tmp15) ? 1 : -1;
  tmp16 = LessZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */, data->simulationInfo->storedRelations[16]);
  gout[15] = (tmp16) ? 1 : -1;
  tmp17 = GreaterZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[17]);
  gout[16] = (tmp17) ? 1 : -1;
  tmp18 = LessEqZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[18]);
  gout[17] = (tmp18) ? 1 : -1;
  tmp19 = GreaterZC(data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */, 0.0, data->simulationInfo->storedRelations[19]);
  gout[18] = (tmp19) ? 1 : -1;
  tmp20 = GreaterZC(data->localData[0]->timeValue - data->localData[0]->realVars[1167] /* controlHot.logic.t_on DISCRETE */, data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */, data->simulationInfo->storedRelations[20]);
  gout[19] = (tmp20) ? 1 : -1;
  tmp21 = LessZC(data->localData[0]->timeValue - data->localData[0]->realVars[1166] /* controlHot.logic.t_off DISCRETE */, data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */, data->simulationInfo->storedRelations[21]);
  gout[20] = (tmp21) ? 1 : -1;
  tmp22 = GreaterEqZC((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */), (data->simulationInfo->realParameter[657] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[693] /* powerBlock.nu_min PARAM */), data->simulationInfo->storedRelations[22]);
  gout[21] = (tmp22) ? 1 : -1;
  gout[22] = ((data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0)) ? 1 : -1;
  tmp24 = LessZC(data->localData[0]->timeValue, data->localData[0]->realVars[1170] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */, data->simulationInfo->storedRelations[24]);
  gout[23] = (tmp24) ? 1 : -1;

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_ZC);
#endif

  TRACE_POP
  return 0;
}

const char *PhysicalParticleCO21D_relationDescription(int i)
{
  const char *res[] = {"heliostatsField.ele > 0.01",
  "time >= pre(data.table.nextTimeEvent)",
  "controlHot.defocus_logic.level_ref > controlHot.defocus_logic.level_max",
  "controlHot.defocus_logic.level_ref < controlHot.defocus_logic.level_min",
  "controlHot.defocus_logic.level_ref > controlHot.logic.level_on",
  "controlHot.defocus_logic.level_ref < controlHot.logic.level_off",
  "simpleReceiverControl.defocusLogic.level_ref > simpleReceiverControl.defocusLogic.level_max",
  "simpleReceiverControl.defocusLogic.level_ref < simpleReceiverControl.defocusLogic.level_min",
  "simpleReceiverControl.defocusLogic.level_ref > simpleReceiverControl.hotTank.level_max",
  "simpleReceiverControl.defocusLogic.level_ref < simpleReceiverControl.hotTank.level_min",
  "time > 31449600.0",
  "particleReceiver1D.T_s[1] < tankCold.T_set",
  "tankHot.T_mea < tankHot.T_set",
  "heliostatsField.ele > heliostatsField.ele_min",
  "Wspd_input.y < heliostatsField.Wspd_max",
  "heliostatsField.Q_raw > heliostatsField.Q_start",
  "heliostatsField.Q_raw < heliostatsField.Q_min",
  "heliostatsField.Q_incident > 1e-06",
  "heliostatsField.Q_incident <= 1e-06",
  "controlHot.m_flow_in > 0.0",
  "time - controlHot.logic.t_on > controlHot.logic.t_start",
  "time - controlHot.logic.t_off < controlHot.logic.t_standby",
  "(-LiftCold.fluid_b.m_flow) >= powerBlock.exchanger.m_HTF_des * powerBlock.nu_min",
  "particleReceiver1D.mdot == 0.0",
  "time < heliostatsField.t_on + heliostatsField.t_start"};
  return res[i];
}

int PhysicalParticleCO21D_function_updateRelations(DATA *data, threadData_t *threadData, int evalforZeroCross)
{
  TRACE_PUSH
  modelica_boolean tmp25;
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
  modelica_boolean tmp49;
  
  if(evalforZeroCross) {
    tmp25 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, 0.01, data->simulationInfo->storedRelations[0]);
    data->simulationInfo->relations[0] = tmp25;
    tmp26 = GreaterEqZC(data->localData[0]->timeValue, data->simulationInfo->realVarsPre[1168] /* data.table.nextTimeEvent DISCRETE */, data->simulationInfo->storedRelations[1]);
    data->simulationInfo->relations[1] = tmp26;
    tmp27 = GreaterZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */, data->simulationInfo->storedRelations[2]);
    data->simulationInfo->relations[2] = tmp27;
    tmp28 = LessZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */, data->simulationInfo->storedRelations[3]);
    data->simulationInfo->relations[3] = tmp28;
    tmp29 = GreaterZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */, data->simulationInfo->storedRelations[4]);
    data->simulationInfo->relations[4] = tmp29;
    tmp30 = LessZC(data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */, data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */, data->simulationInfo->storedRelations[5]);
    data->simulationInfo->relations[5] = tmp30;
    tmp31 = GreaterZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[771] /* simpleReceiverControl.defocusLogic.level_max PARAM */, data->simulationInfo->storedRelations[6]);
    data->simulationInfo->relations[6] = tmp31;
    tmp32 = LessZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_min PARAM */, data->simulationInfo->storedRelations[7]);
    data->simulationInfo->relations[7] = tmp32;
    tmp33 = GreaterZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[774] /* simpleReceiverControl.hotTank.level_max PARAM */, data->simulationInfo->storedRelations[8]);
    data->simulationInfo->relations[8] = tmp33;
    tmp34 = LessZC(data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */, data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_min PARAM */, data->simulationInfo->storedRelations[9]);
    data->simulationInfo->relations[9] = tmp34;
    tmp35 = GreaterZC(data->localData[0]->timeValue, 31449600.0, data->simulationInfo->storedRelations[10]);
    data->simulationInfo->relations[10] = tmp35;
    tmp36 = LessZC(data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */, data->simulationInfo->realParameter[801] /* tankCold.T_set PARAM */, data->simulationInfo->storedRelations[11]);
    data->simulationInfo->relations[11] = tmp36;
    tmp37 = LessZC(data->localData[0]->realVars[1148] /* tankHot.T_mea variable */, data->simulationInfo->realParameter[811] /* tankHot.T_set PARAM */, data->simulationInfo->storedRelations[12]);
    data->simulationInfo->relations[12] = tmp37;
    tmp38 = GreaterZC(data->localData[0]->realVars[92] /* heliostatsField.ele variable */, data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */, data->simulationInfo->storedRelations[13]);
    data->simulationInfo->relations[13] = tmp38;
    tmp39 = LessZC(data->localData[0]->realVars[57] /* Wspd_input.y variable */, data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */, data->simulationInfo->storedRelations[14]);
    data->simulationInfo->relations[14] = tmp39;
    tmp40 = GreaterZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */, data->simulationInfo->storedRelations[15]);
    data->simulationInfo->relations[15] = tmp40;
    tmp41 = LessZC(data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */, data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */, data->simulationInfo->storedRelations[16]);
    data->simulationInfo->relations[16] = tmp41;
    tmp42 = GreaterZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[17]);
    data->simulationInfo->relations[17] = tmp42;
    tmp43 = LessEqZC(data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */, 1e-06, data->simulationInfo->storedRelations[18]);
    data->simulationInfo->relations[18] = tmp43;
    tmp44 = GreaterZC(data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */, 0.0, data->simulationInfo->storedRelations[19]);
    data->simulationInfo->relations[19] = tmp44;
    tmp45 = GreaterZC(data->localData[0]->timeValue - data->localData[0]->realVars[1167] /* controlHot.logic.t_on DISCRETE */, data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */, data->simulationInfo->storedRelations[20]);
    data->simulationInfo->relations[20] = tmp45;
    tmp46 = LessZC(data->localData[0]->timeValue - data->localData[0]->realVars[1166] /* controlHot.logic.t_off DISCRETE */, data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */, data->simulationInfo->storedRelations[21]);
    data->simulationInfo->relations[21] = tmp46;
    tmp47 = GreaterEqZC((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */), (data->simulationInfo->realParameter[657] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[693] /* powerBlock.nu_min PARAM */), data->simulationInfo->storedRelations[22]);
    data->simulationInfo->relations[22] = tmp47;
    data->simulationInfo->relations[23] = (data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
    tmp49 = LessZC(data->localData[0]->timeValue, data->localData[0]->realVars[1170] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */, data->simulationInfo->storedRelations[24]);
    data->simulationInfo->relations[24] = tmp49;
  } else {
    data->simulationInfo->relations[0] = (data->localData[0]->realVars[92] /* heliostatsField.ele variable */ > 0.01);
    data->simulationInfo->relations[1] = (data->localData[0]->timeValue >= data->simulationInfo->realVarsPre[1168] /* data.table.nextTimeEvent DISCRETE */);
    data->simulationInfo->relations[2] = (data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */ > data->simulationInfo->realParameter[86] /* controlHot.defocus_logic.level_max PARAM */);
    data->simulationInfo->relations[3] = (data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */ < data->simulationInfo->realParameter[87] /* controlHot.defocus_logic.level_min PARAM */);
    data->simulationInfo->relations[4] = (data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */ > data->simulationInfo->realParameter[89] /* controlHot.logic.level_on PARAM */);
    data->simulationInfo->relations[5] = (data->localData[0]->realVars[58] /* controlHot.defocus_logic.level_ref variable */ < data->simulationInfo->realParameter[88] /* controlHot.logic.level_off PARAM */);
    data->simulationInfo->relations[6] = (data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */ > data->simulationInfo->realParameter[771] /* simpleReceiverControl.defocusLogic.level_max PARAM */);
    data->simulationInfo->relations[7] = (data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */ < data->simulationInfo->realParameter[772] /* simpleReceiverControl.defocusLogic.level_min PARAM */);
    data->simulationInfo->relations[8] = (data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */ > data->simulationInfo->realParameter[774] /* simpleReceiverControl.hotTank.level_max PARAM */);
    data->simulationInfo->relations[9] = (data->localData[0]->realVars[1119] /* simpleReceiverControl.defocusLogic.level_ref variable */ < data->simulationInfo->realParameter[775] /* simpleReceiverControl.hotTank.level_min PARAM */);
    data->simulationInfo->relations[10] = (data->localData[0]->timeValue > 31449600.0);
    data->simulationInfo->relations[11] = (data->localData[0]->realVars[115] /* particleReceiver1D.T_s[1] variable */ < data->simulationInfo->realParameter[801] /* tankCold.T_set PARAM */);
    data->simulationInfo->relations[12] = (data->localData[0]->realVars[1148] /* tankHot.T_mea variable */ < data->simulationInfo->realParameter[811] /* tankHot.T_set PARAM */);
    data->simulationInfo->relations[13] = (data->localData[0]->realVars[92] /* heliostatsField.ele variable */ > data->simulationInfo->realParameter[151] /* heliostatsField.ele_min PARAM */);
    data->simulationInfo->relations[14] = (data->localData[0]->realVars[57] /* Wspd_input.y variable */ < data->simulationInfo->realParameter[150] /* heliostatsField.Wspd_max PARAM */);
    data->simulationInfo->relations[15] = (data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */ > data->simulationInfo->realParameter[148] /* heliostatsField.Q_start PARAM */);
    data->simulationInfo->relations[16] = (data->localData[0]->realVars[85] /* heliostatsField.Q_raw variable */ < data->simulationInfo->realParameter[147] /* heliostatsField.Q_min PARAM */);
    data->simulationInfo->relations[17] = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */ > 1e-06);
    data->simulationInfo->relations[18] = (data->localData[0]->realVars[84] /* heliostatsField.Q_incident variable */ <= 1e-06);
    data->simulationInfo->relations[19] = (data->localData[0]->realVars[61] /* controlHot.m_flow_in variable */ > 0.0);
    data->simulationInfo->relations[20] = (data->localData[0]->timeValue - data->localData[0]->realVars[1167] /* controlHot.logic.t_on DISCRETE */ > data->simulationInfo->realParameter[94] /* controlHot.logic.t_start PARAM */);
    data->simulationInfo->relations[21] = (data->localData[0]->timeValue - data->localData[0]->realVars[1166] /* controlHot.logic.t_off DISCRETE */ < data->simulationInfo->realParameter[93] /* controlHot.logic.t_standby PARAM */);
    data->simulationInfo->relations[22] = ((-data->localData[0]->realVars[55] /* LiftCold.fluid_b.m_flow variable */) >= (data->simulationInfo->realParameter[657] /* powerBlock.exchanger.m_HTF_des PARAM */) * (data->simulationInfo->realParameter[693] /* powerBlock.nu_min PARAM */));
    data->simulationInfo->relations[23] = (data->localData[0]->realVars[283] /* particleReceiver1D.mdot variable */ == 0.0);
    data->simulationInfo->relations[24] = (data->localData[0]->timeValue < data->localData[0]->realVars[1170] /* heliostatsField.t_on DISCRETE */ + data->simulationInfo->realParameter[161] /* heliostatsField.t_start PARAM */);
  }
  
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

