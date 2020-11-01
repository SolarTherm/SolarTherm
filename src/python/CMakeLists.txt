# see http://bloerg.net/2012/11/10/cmake-and-distutils.html

# This works but opt for pip instead
#find_program(PYTHON "python2")
#
#if (PYTHON)
#	set(SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in")
#	set(SETUP_PY "${CMAKE_CURRENT_BINARY_DIR}/setup.py")
#	set(DEPS "${CMAKE_CURRENT_SOURCE_DIR}/solartherm/__init__.py")
#	set(OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/build/timestamp")
#
#	configure_file(${SETUP_PY_IN} ${SETUP_PY})
#
#	add_custom_command(OUTPUT ${OUTPUT}
#						COMMAND ${PYTHON} ${SETUP_PY} build
#						COMMAND ${CMAKE_COMMAND} -E touch ${OUTPUT}
#						DEPENDS ${DEPS})
#
#	add_custom_target(target ALL DEPENDS ${OUTPUT})
#
#	install(CODE "execute_process(COMMAND ${PYTHON} ${SETUP_PY} install)")
#endif()


find_program(PYTHON "python")
#find_program(PIP "pip")

if (PYTHON)
	set(SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in")
	set(SETUP_PY "${CMAKE_CURRENT_BINARY_DIR}/setup.py")

	configure_file(${SETUP_PY_IN} ${SETUP_PY})

if (FORCE_PYTHON_PREFIX)
	install(CODE "execute_process(COMMAND ${PYTHON} -m pip install --prefix=${CMAKE_INSTALL_PREFIX} --upgrade ${CMAKE_CURRENT_BINARY_DIR})")
else()
	install(CODE "execute_process(COMMAND ${PYTHON} -m pip install --upgrade ${CMAKE_CURRENT_BINARY_DIR})")
endif()

endif()
