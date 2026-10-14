project(skymp5-front)

set(FRONTEND_REPO_OWNER antinefor)
set(FRONTEND_REPO_NAME skymp5-front)
set(FRONTEND_REPO ${FRONTEND_REPO_OWNER}/${FRONTEND_REPO_NAME})
set(FRONTEND_BRANCH main)

if(BUILD_FRONT)
  if(NOT GITHUB_TOKEN)
    message(FATAL_ERROR "GITHUB_TOKEN is not set. Please set it to your GitHub personal access token.")
  endif()

  set(FRONTEND_JS_DEST_DIR "${CMAKE_BINARY_DIR}/dist/client/Data/Platform/UI")
  set(FRONTEND_REPO_URL "https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${FRONTEND_REPO_OWNER}/${FRONTEND_REPO_NAME}.git")
  set(YARN_CMAKE_PATH "${CMAKE_SOURCE_DIR}/cmake/yarn.cmake")

  # Pass variables to the download script.
  set(SCRIPT_PATH "${CMAKE_CURRENT_LIST_DIR}/download-and-build-with-prs.cmake")
  configure_file(${SCRIPT_PATH} ${CMAKE_BINARY_DIR}/download-and-build-front.cmake ESCAPE_QUOTES)

  set(source download-and-build-front.cmake)

  add_custom_target(skymp5-front ALL
    SOURCES ${CMAKE_BINARY_DIR}/${source}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/dist/client
    COMMAND ${CMAKE_COMMAND} -E env DOWNLOAD_NO_PROGRESS=1
            ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/${source}
    COMMENT "Downloading & building frontend repo..."
  )
else()
  add_custom_target(skymp5-front ALL
    COMMAND ${CMAKE_COMMAND} -E echo "Building skymp5-front is disabled. To enable it, set BUILD_FRONT to ON."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/dist/client/Data/Platform/UI
  )
endif()