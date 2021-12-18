cmake_minimum_required(VERSION 3.16)

# Create the project and set the version

project(hypothesis VERSION 1.0.0 LANGUAGES CXX)

# Add install target, configure and version files
# https://cliutils.gitlab.io/modern-cmake/chapters/install/installing.html

install(EXPORT ${PROJECT_NAME}Targets
	NAMESPACE ${PROJECT_NAME}::
	DESTINATION lib/cmake/${PROJECT_NAME})

include(CMakePackageConfigHelpers)

write_basic_package_version_file(${PROJECT_NAME}ConfigVersion.cmake
	COMPATIBILITY AnyNewerVersion)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	DESTINATION lib/cmake/${PROJECT_NAME})

configure_file(Config.cmake.in
	${PROJECT_NAME}Config.cmake @ONLY)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
	DESTINATION lib/cmake/${PROJECT_NAME})

# Create project target

add_library(${PROJECT_NAME} INTERFACE)

# Add include directories

include(GNUInstallDirs)

target_include_directories(${PROJECT_NAME} INTERFACE
	"$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
	"$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")

# Alias target for master projects

add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Setup target for install

install(TARGETS ${PROJECT_NAME}
	EXPORT ${PROJECT_NAME}Targets)

# Add subdirectories

add_subdirectory(include)

# Add uninstall target
# https://gitlab.kitware.com/cmake/community/-/wikis/FAQ#can-i-do-make-uninstall-with-cmake

if(NOT TARGET uninstall)
	configure_file(uninstall.cmake.in
		uninstall.cmake @ONLY)

	add_custom_target(uninstall COMMAND
		${CMAKE_COMMAND} -P uninstall.cmake)
endif()
