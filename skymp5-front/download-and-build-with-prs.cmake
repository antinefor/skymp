include(${YARN_CMAKE_PATH})

message(STATUS "Downloading frontend sources")

file(REMOVE_RECURSE ${CMAKE_BINARY_DIR}/frontend-sources)
execute_process(
    COMMAND git clone "${FRONTEND_REPO_URL}" ${CMAKE_BINARY_DIR}/frontend-sources
    RESULT_VARIABLE GIT_RESULT
    OUTPUT_VARIABLE GIT_OUTPUT
)

if(GIT_RESULT EQUAL 0)
    message(STATUS "Downloaded frontend sources")
else()
    message(FATAL_ERROR "Failed to download frontend sources: ${GIT_OUTPUT}")
endif()

message(STATUS "Installing yarn dependencies for frontend")

yarn_execute_command(
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/frontend-sources
    COMMAND install
)

message(STATUS "Installed yarn dependencies for frontend")

message(STATUS "Writing config.js for frontend")

file(WRITE "${CMAKE_BINARY_DIR}/frontend-sources/config.js" "")
file(APPEND "${CMAKE_BINARY_DIR}/frontend-sources/config.js" "module.exports = {\n")
file(APPEND "${CMAKE_BINARY_DIR}/frontend-sources/config.js" "  outputPath:\n")
file(APPEND "${CMAKE_BINARY_DIR}/frontend-sources/config.js" "    '${FRONTEND_JS_DEST_DIR}',\n")
file(APPEND "${CMAKE_BINARY_DIR}/frontend-sources/config.js" "};\n")

message(STATUS "Building frontend")

yarn_execute_command(
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/frontend-sources
    COMMAND build
)

message(STATUS "Built frontend")