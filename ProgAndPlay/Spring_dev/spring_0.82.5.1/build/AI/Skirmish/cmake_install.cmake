# Install script for directory: C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/AI/Skirmish

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/Spring")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "RELWITHDEBINFO")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/AAI/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/CppTestAI/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/E323AI/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/HughAI/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/KAIK/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/NullAI/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/NullJavaAI/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/NullOOJavaAI/cmake_install.cmake")
  INCLUDE("C:/Users/Stephane/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Skirmish/RAI/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

