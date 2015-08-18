
file(COPY ./ DESTINATION . FILES_MATCHING PATTERN "Test*.py")
file(COPY run_tests DESTINATION .)

add_test(TestSolarTherm ./run_tests)
set_tests_properties(TestSolarTherm PROPERTIES
	ENVIRONMENT "${CTEST_ENVIRONMENT}")

add_subdirectory(resources)
