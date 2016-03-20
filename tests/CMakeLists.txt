
file(COPY ./ DESTINATION . FILES_MATCHING PATTERN "Test*.py")
file(COPY ./ DESTINATION . FILES_MATCHING PATTERN "Test*.mo")
file(COPY ./ DESTINATION . FILES_MATCHING PATTERN "st_test_*.c")
file(COPY run_tests DESTINATION .)

add_test(TestSolarTherm ./run_tests)
# Commenting out because could be trouble with different prefixes
#set_tests_properties(TestSolarTherm PROPERTIES
#	ENVIRONMENT "${CTEST_ENVIRONMENT}")
