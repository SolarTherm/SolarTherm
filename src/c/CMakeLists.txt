
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -std=c99")

add_library(st_test_ext SHARED
	TestExternalC.c
	)

install(TARGETS st_test_ext
	LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/tests/Resources/Library/
	)

add_library(st_tables SHARED
	st_tables.c
	solinterp/tables.c
	solinterp/symmetries.c
	solinterp/interpolation.c
	)

install(TARGETS st_tables
	LIBRARY DESTINATION ${SOLARTHERM_CLIB_INSTALL_DIR}
	)
