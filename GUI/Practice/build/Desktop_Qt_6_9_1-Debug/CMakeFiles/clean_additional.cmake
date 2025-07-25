# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appPractice_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appPractice_autogen.dir/ParseCache.txt"
  "appPractice_autogen"
  )
endif()
