
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -std=c99")

add_library(solartherm_test SHARED
	TestExternalC.c
	)

install(TARGETS solartherm_test
	LIBRARY DESTINATION lib)

add_library(st_tables SHARED
	st_tables.c
	solinterp/tables.c
	solinterp/symmetries.c
	solinterp/interpolation.c
	)

install(TARGETS st_tables
	LIBRARY DESTINATION lib)
