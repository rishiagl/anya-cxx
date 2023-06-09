cmake_minimum_required(VERSION 3.20)
project(anya CXX)

include(CheckIncludeFileCXX)

# check_include_file_cxx(any HAS_ANY)
# check_include_file_cxx(string_view HAS_STRING_VIEW)
# check_include_file_cxx(coroutine HAS_COROUTINE)
# if (NOT "${CMAKE_CXX_STANDARD}" STREQUAL "")
#     # Do nothing
# elseif (HAS_ANY AND HAS_STRING_VIEW AND HAS_COROUTINE)
set(CMAKE_CXX_STANDARD 20)
# elseif (HAS_ANY AND HAS_STRING_VIEW)
#     set(CMAKE_CXX_STANDARD 17)
# else ()
#     set(CMAKE_CXX_STANDARD 14)
# endif ()

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "-fcoroutines -std=c++20")

add_executable(${PROJECT_NAME} main.cc)

include(FetchContent)

FetchContent_Declare(
  glaze
  GIT_REPOSITORY https://github.com/stephenberry/glaze.git
  GIT_TAG main
  GIT_SHALLOW TRUE
)

FetchContent_MakeAvailable(glaze)
# ##############################################################################
# If you include the drogon source code locally in your project, use this method
# to add drogon 
# add_subdirectory(dblib)
# target_link_libraries(${PROJECT_NAME} PRIVATE RapidJSON drogon dblib)
#
# and comment out the following lines
find_package(Drogon CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE Drogon::Drogon glaze::glaze)

# ##############################################################################

message(STATUS "use c++20")

aux_source_directory(controllers CTL_SRC)
aux_source_directory(filters FILTER_SRC)
aux_source_directory(plugins PLUGIN_SRC)
aux_source_directory(database DATABASE_SRC)

drogon_create_views(${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/views
                    ${CMAKE_CURRENT_BINARY_DIR})
# use the following line to create views with namespaces.
# drogon_create_views(${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/views
#                     ${CMAKE_CURRENT_BINARY_DIR} TRUE)
# use the following line to create views with namespace CHANGE_ME prefixed
# and path namespaces.
# drogon_create_views(${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/views
#                     ${CMAKE_CURRENT_BINARY_DIR} TRUE CHANGE_ME)

#--comented by me--
# target_include_directories(${PROJECT_NAME}
#                            PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
#                                    ${CMAKE_CURRENT_SOURCE_DIR}/models)
target_sources(${PROJECT_NAME}
               PRIVATE
               ${SRC_DIR}
               ${CTL_SRC}
               ${FILTER_SRC}
               ${PLUGIN_SRC}
               ${DATABASE_SRC})
# ##############################################################################
# uncomment the following line for dynamically loading views 
# set_property(TARGET ${PROJECT_NAME} PROPERTY ENABLE_EXPORTS ON)

# ##############################################################################

# add_subdirectory(test)
