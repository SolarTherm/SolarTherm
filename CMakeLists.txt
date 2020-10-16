cmake_minimum_required(VERSION 2.6)
project(solartherm)
set(PACKAGE_VERSION 0.1)

enable_testing()

if (DEFINED MODELICA_LIBRARY_INSTALL_DIR)
else()
	set(MODELICA_LIBRARY_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/lib/omlibrary/)
	#set(MODELICA_LIBRARY_INSTALL_DIR ${HOME}/.openmodelica/libraries/)
endif()

if (DEFINED SOLARTHERM_CLIB_INSTALL_DIR)
else()
	set(SOLARTHERM_CLIB_INSTALL_DIR ${MODELICA_LIBRARY_INSTALL_DIR}/SolarTherm/Resources/Library/)
	#set(SOLARTHERM_CLIB_INSTALL_DIR lib)
endif()

if (DEFINED FORCE_PYTHON_PREFIX)
else()
	#set(FORCE_PYTHON_PREFIX 0)
	set(FORCE_PYTHON_PREFIX 1)
endif()

# Used to correctly set PYTHONPATH in local enviroment setup source file.
# Should work out how to do this more intelligently.

set(PYTHON_LIBRARY_VERSION ${Python_VERSION})

add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(examples)
add_subdirectory(resources)

#file(COPY SolarTherm DESTINATION .)
install(DIRECTORY SolarTherm DESTINATION ${MODELICA_LIBRARY_INSTALL_DIR})
