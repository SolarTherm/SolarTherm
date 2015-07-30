
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")

add_library(solartherm_test SHARED
	TestExternalC.c
	)

install(TARGETS solartherm_test
	LIBRARY DESTINATION lib)
