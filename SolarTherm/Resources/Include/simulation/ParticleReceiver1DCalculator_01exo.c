/* External objects file */
#include "ParticleReceiver1DCalculator_model.h"
#if defined(__cplusplus)
extern "C" {
#endif

void ParticleReceiver1DCalculator_callExternalObjectDestructors(DATA *data, threadData_t *threadData)
{
  if(data->simulationInfo->extObjs)
  {
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[0]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[1]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[2]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[3]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[4]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[5]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[6]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[7]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[8]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[9]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[10]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[11]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[12]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[13]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[14]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[15]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[16]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[17]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[18]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[19]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[20]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[21]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[22]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[23]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[24]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[25]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[26]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[27]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[28]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[29]);
    omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData,data->simulationInfo->extObjs[30]);
    free(data->simulationInfo->extObjs);
    data->simulationInfo->extObjs = 0;
  }
}
#if defined(__cplusplus)
}
#endif

