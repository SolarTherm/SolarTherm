#if defined(__cplusplus)
  extern "C" {
#endif
  int PhysicalParticleCO21D_mayer(DATA* data, modelica_real** res, short*);
  int PhysicalParticleCO21D_lagrange(DATA* data, modelica_real** res, short *, short *);
  int PhysicalParticleCO21D_pickUpBoundsForInputsInOptimization(DATA* data, modelica_real* min, modelica_real* max, modelica_real*nominal, modelica_boolean *useNominal, char ** name, modelica_real * start, modelica_real * startTimeOpt);
  int PhysicalParticleCO21D_setInputData(DATA *data, const modelica_boolean file);
  int PhysicalParticleCO21D_getTimeGrid(DATA *data, modelica_integer * nsi, modelica_real**t);
#if defined(__cplusplus)
}
#endif