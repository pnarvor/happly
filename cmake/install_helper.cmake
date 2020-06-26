function(install_target TARGET_NAME)

	set(oneValueArgs HEADER_PREFIX)
	set(multiValueArgs ADDITIONNAL_CONFIG_FILES)
	cmake_parse_arguments(INSTALL "${options}" "${oneValueArgs}"
	                      "${multiValueArgs}" ${ARGN} )

	
	if("${INSTALL_HEADER_PREFIX}" STREQUAL "")
        set(INSTALL_HEADER_PREFIX ${TARGET_NAME})
    endif()
	
	include(GNUInstallDirs)
	# Configuration
	set(VERSION_CONFIG "${CMAKE_CURRENT_BINARY_DIR}/generated/${TARGET_NAME}ConfigVersion.cmake")
	set(PROJECT_CONFIG "${CMAKE_CURRENT_BINARY_DIR}/generated/${TARGET_NAME}Config.cmake")
	set(TARGET_EXPORT_NAME "${TARGET_NAME}Targets")
	set(CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${TARGET_NAME}")
	
	include(CMakePackageConfigHelpers)
	write_basic_package_version_file(
	    "${VERSION_CONFIG}" COMPATIBILITY SameMajorVersion
	)
	configure_package_config_file(
	    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Config.cmake.in"
	    "${PROJECT_CONFIG}"
	    INSTALL_DESTINATION "${CONFIG_INSTALL_DIR}"
	    PATH_VARS CMAKE_INSTALL_INCLUDEDIR
	)
	
	# Installation
	install(
	    TARGETS "${TARGET_NAME}"
	    EXPORT "${TARGET_EXPORT_NAME}"
	    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
	    INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
	    PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${INSTALL_HEADER_PREFIX}"
	)
    list(APPEND CONFIG_FILES_TO_INSTALL
        ${PROJECT_CONFIG}
        ${VERSION_CONFIG}
        ${INSTALL_ADDITIONNAL_CONFIG_FILES}
    )
	install(
	    FILES ${CONFIG_FILES_TO_INSTALL}
	    DESTINATION "${CONFIG_INSTALL_DIR}"
	)
    # Header files do not get automatically installed int the case of an INTERFACE librairy (all-header)
    get_target_property(TARGET_TYPE_VALUE ${TARGET_NAME} TYPE)
    if(${TARGET_TYPE_VALUE} STREQUAL "INTERFACE_LIBRARY")
        get_target_property(ADDITIONNAL_HEADER_FILES ${TARGET_NAME} INTERFACE_PUBLIC_HEADER)
        if(NOT "ADDITIONNAL_HEADER_FILES-NOTFOUND" IN_LIST ADDITIONNAL_HEADER_FILES)
            install(
                FILES ${ADDITIONNAL_HEADER_FILES}
                DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${INSTALL_HEADER_PREFIX}"
            )
        endif()
    endif()
	install(
	    EXPORT "${TARGET_EXPORT_NAME}"
	    # NAMESPACE "${PROJECT_NAME}::"
	    DESTINATION "${CONFIG_INSTALL_DIR}"
	)

endfunction()

