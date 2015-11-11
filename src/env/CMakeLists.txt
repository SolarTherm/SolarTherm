
if(EXISTS "${CMAKE_INSTALL_PREFIX}/bin/activate")
	configure_file("st_activate.in" "st_activate" @ONLY)

	install(FILES "${CMAKE_CURRENT_BINARY_DIR}/st_activate" DESTINATION "bin/")
endif()
