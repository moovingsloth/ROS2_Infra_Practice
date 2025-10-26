cmake_minimum_required(VERSION 3.10)
project(ROS2_Infra_Practice)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


find_package(OpenCV REQUIRED)
find_package(Eigen3 REQUIRED)

include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(src)

file(GLOB_RECURSE SOURCES 
    "src/database/*.cpp"
    "src/module/*.cpp"
)

# Euroc test
add_executable(test_euroc test.cpp ${SOURCES})
target_link_libraries(test_euroc ${OpenCV_LIBS})

# Link Eigen3
if(TARGET Eigen3::Eigen)
    target_link_libraries(test_euroc Eigen3::Eigen)
elseif(EIGEN3_FOUND)
    include_directories(${EIGEN3_INCLUDE_DIR})
endif()

# Print OpenCV information for debugging
message(STATUS "OpenCV library status:")
message(STATUS "    version: ${OpenCV_VERSION}")
message(STATUS "    libraries: ${OpenCV_LIBS}")
message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")