# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 2.6

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canoncical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files (x86)\CMake 2.6\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files (x86)\CMake 2.6\bin\cmake.exe" -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = C:\PROGRA~2\CMAKE2~1.6\bin\CMAKE-~1.EXE

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build

# Utility rule file for install-spring.

rts/builds/default/CMakeFiles/install-spring: rts/builds/default/CMakeFiles/install-spring.dir/build.make
	$(CMAKE_COMMAND) -E cmake_progress_report C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "  spring: Installing ..."
	"C:\Program Files (x86)\CMake 2.6\bin\cmake.exe" -P C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/rts/builds/default/cmake_install.cmake
	"C:\Program Files (x86)\CMake 2.6\bin\cmake.exe" -P C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/tools/unitsync/cmake_install.cmake
	"C:\Program Files (x86)\CMake 2.6\bin\cmake.exe" -P C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/cont/cmake_install.cmake
	"C:\Program Files (x86)\CMake 2.6\bin\cmake.exe" -P C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/cmake_install.cmake

install-spring: rts/builds/default/CMakeFiles/install-spring
install-spring: rts/builds/default/CMakeFiles/install-spring.dir/build.make
.PHONY : install-spring

# Rule to build all files generated by this target.
rts/builds/default/CMakeFiles/install-spring.dir/build: install-spring
.PHONY : rts/builds/default/CMakeFiles/install-spring.dir/build

rts/builds/default/CMakeFiles/install-spring.dir/clean:
	cd C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\rts\builds\default && $(CMAKE_COMMAND) -P CMakeFiles\install-spring.dir\cmake_clean.cmake
.PHONY : rts/builds/default/CMakeFiles/install-spring.dir/clean

rts/builds/default/CMakeFiles/install-spring.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1 C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\rts\builds\default C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\rts\builds\default C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\rts\builds\default\CMakeFiles\install-spring.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : rts/builds/default/CMakeFiles/install-spring.dir/depend
