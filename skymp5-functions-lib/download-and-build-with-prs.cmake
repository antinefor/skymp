include(${CMAKE_SOURCE_DIR}/cmake/yarn.cmake)

message(STATUS "Downloading gamemode sources")

file(REMOVE_RECURSE ${CMAKE_BINARY_DIR}/gamemode-sources)
execute_process(
    COMMAND git clone "${GAMEMODE_REPO_URL}" ${CMAKE_BINARY_DIR}/gamemode-sources
    RESULT_VARIABLE GIT_RESULT
    OUTPUT_VARIABLE GIT_OUTPUT
)

if(GIT_RESULT EQUAL 0)
    message(STATUS "Downloaded gamemode sources")
else()
    message(FATAL_ERROR "Failed to download gamemode sources: ${GIT_OUTPUT}")
endif()

message(STATUS "Installing yarn dependencies for gamemode")

yarn_execute_command(
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/gamemode-sources
    COMMAND install
)

message(STATUS "Installed yarn dependencies for gamemode")

message(STATUS "Building gamemode.js")

yarn_execute_command(
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/gamemode-sources
    COMMAND build
)

message(STATUS "Built gamemode.js")

message(STATUS "Installing gamemode.js")

file(COPY ${CMAKE_BINARY_DIR}/gamemode-sources/build/dist/server/gamemode.js DESTINATION "${GAMEMODE_JS_DEST_DIR}")

message(STATUS "Installed gamemode.js")