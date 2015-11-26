
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -std=c99")

add_library(solartherm_test SHARED
	TestExternalC.c
	)

install(TARGETS solartherm_test
	LIBRARY DESTINATION lib)

add_library(st_table SHARED
	table.c
	)

install(TARGETS st_table
	LIBRARY DESTINATION lib)
