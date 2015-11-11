cmake_minimum_required(VERSION 2.6)
project(solartherm)
set(PACKAGE_VERSION 0.1)

enable_testing()

if (DEFINED MODELICA_LIBRARY_INSTALL_DIR)
else()
	set(MODELICA_LIBRARY_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/lib/omlibrary/")
endif()
#set(MODELICA_LIBRARY_INSTALL_DIR "${HOME}/.openmodelica/libraries/")
# Commenting out because could be trouble with different prefixes
#set(CTEST_ENVIRONMENT "OPENMODELICALIBRARY=${CMAKE_BINARY_DIR}:$ENV{OPENMODELICAHOME}/lib/omlibrary:$ENV{HOME}/.openmodelica/libraries;LD_LIBRARY_PATH=${LIBRARY_OUTPUT_DIR};../src;LIBRARY_PATH=${LIBRARY_OUTPUT_DIR}")

#set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
#set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

add_subdirectory(src)
add_subdirectory(test)
add_subdirectory(examples)

#file(COPY SolarTherm DESTINATION .)

install(DIRECTORY SolarTherm DESTINATION ${MODELICA_LIBRARY_INSTALL_DIR})
