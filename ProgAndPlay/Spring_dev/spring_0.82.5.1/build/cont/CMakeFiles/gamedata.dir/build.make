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

# Utility rule file for gamedata.

cont/CMakeFiles/gamedata: cont/CMakeFiles/gamedata.dir/build.make
	cd C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\cont\base && call make_gamedata_arch.bat C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\base C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/mingwlibs/bin/7za.exe

gamedata: cont/CMakeFiles/gamedata
gamedata: cont/CMakeFiles/gamedata.dir/build.make
.PHONY : gamedata

# Rule to build all files generated by this target.
cont/CMakeFiles/gamedata.dir/build: gamedata
.PHONY : cont/CMakeFiles/gamedata.dir/build

cont/CMakeFiles/gamedata.dir/clean:
	cd C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\cont && $(CMAKE_COMMAND) -P CMakeFiles\gamedata.dir\cmake_clean.cmake
.PHONY : cont/CMakeFiles/gamedata.dir/clean

cont/CMakeFiles/gamedata.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1 C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\cont C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\cont C:\Users\StephaneMeresse\Desktop\mocahteam\ProgAndPlay\Spring_dev\spring_0.82.5.1\build\cont\CMakeFiles\gamedata.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : cont/CMakeFiles/gamedata.dir/depend
