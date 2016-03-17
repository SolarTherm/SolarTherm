
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -std=c99")

#add_library(st_test_ext SHARED
add_library(st_test_ext STATIC
	TestExternalC.c
	)

install(TARGETS st_test_ext
	LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/tests/Resources/Library/
	ARCHIVE DESTINATION ${CMAKE_BINARY_DIR}/tests/Resources/Library/
	)

# DLLs in windows must be fully linked (no undefined symbols) during compilation.
# This makes it more cumbersome to generate a shared library that refers to
# ModelicaError.

#add_library(st_tables SHARED
add_library(st_tables STATIC
	st_tables.c
	solinterp/tables.c
	solinterp/symmetries.c
	solinterp/interpolation.c
	)

install(TARGETS st_tables
	LIBRARY DESTINATION ${SOLARTHERM_CLIB_INSTALL_DIR}
	ARCHIVE DESTINATION ${SOLARTHERM_CLIB_INSTALL_DIR}
	)
