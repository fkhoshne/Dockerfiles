add_custom_target(build_${image} ALL "${CMAKE_CURRENT_SOURCE_DIR}/build.sh" ${BUILD_MP3LAME} ${BUILD_FDKAAC})
if(dep_image)
    add_dependencies(build_${image} build_${dep_image})
endif()
add_custom_target(shell_${image} "${CMAKE_CURRENT_SOURCE_DIR}/shell.sh")

