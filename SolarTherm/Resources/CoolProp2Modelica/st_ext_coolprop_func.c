#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

double propsSI(const char *pOutput,const char *pInput1, double vInput1,const char *pInput2, double vInput2,const char *substance);

double propsSI(const char *pOutput,const char *pInput1, double vInput1,const char *pInput2, double vInput2,const char *substance){
	// Variable declaration
	double output;

	// load shared library; change this path as needed
	void *CoolPropDll;
	CoolPropDll = dlopen("libCoolProp.so", RTLD_LAZY);

	if (CoolPropDll != NULL) //If the library is loaded, get the function and run it
	{
		// Define library functions
		double (*PropsSIAddress)(const char* PropertyToReturn,const char* InputProperty1, double InputValue1,const char* InputProperty2, double InputValue2,const char* Refrigerant);
		PropsSIAddress = dlsym(CoolPropDll, "PropsSI");

		// call function
		output = PropsSIAddress(pOutput,pInput1,vInput1,pInput2,vInput2,substance);

		// unload library
		dlclose(CoolPropDll);
	}
	else{//If is not loaded, print an error
		printf("Could not load CoolProp.so.\n");
	}
	return output;
}
