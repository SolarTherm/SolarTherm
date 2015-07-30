cmake_minimum_required(VERSION 2.6)
project(steep)

enable_testing()

set(MODELICA_LIBRARY_INSTALL_DIR "lib/omlibrary")
set(CTEST_ENVIRONMENT "OPENMODELICALIBRARY=${CMAKE_BINARY_DIR}:$ENV{OPENMODELICAHOME}/lib/omlibrary:$ENV{HOME}/.openmodelica/libraries;LD_LIBRARY_PATH=${LIBRARY_OUTPUT_DIR};../src;LIBRARY_PATH=${LIBRARY_OUTPUT_DIR}")

set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
#set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

add_subdirectory(src)
add_subdirectory(test)

file(COPY SolarTherm DESTINATION .)

install(DIRECTORY SolarTherm DESTINATION ${MODELICA_LIBRARY_INSTALL_DIR})
