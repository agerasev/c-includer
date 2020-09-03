cmake_minimum_required(VERSION 3.0)
project(includer VERSION 0.2.1 DESCRIPTION "#include directives resolver for C-like sources")

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
include_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
)
set(SOURCE
    "${CMAKE_CURRENT_SOURCE_DIR}/src/includer.cpp"
)
add_library(${PROJECT_NAME} OBJECT ${SOURCE})

enable_testing()
add_executable("test_${PROJECT_NAME}"
    ${SOURCE}
    "${CMAKE_CURRENT_SOURCE_DIR}/src/test.cpp"
)
add_test("test_${PROJECT_NAME}" "test_${PROJECT_NAME}")
