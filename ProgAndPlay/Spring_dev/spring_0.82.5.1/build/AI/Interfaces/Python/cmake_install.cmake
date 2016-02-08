# Install script for directory: C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/AI/Interfaces/Python

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

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1" TYPE DIRECTORY FILES "C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/AI/Interfaces/Python/data/" FILES_MATCHING REGEX "interfaceinfo\\.lua$" REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1" TYPE DIRECTORY FILES "C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/AI/Interfaces/Python/data/" FILES_MATCHING REGEX "interfaceinfo\\.lua$" EXCLUDE REGEX "/[^/]*$" REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1" TYPE DIRECTORY FILES "C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/AI/Interfaces/Python/src/" FILES_MATCHING REGEX ".*\\.py$" REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1" TYPE DIRECTORY FILES "C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Interfaces/Python/src-generated/PyAI" FILES_MATCHING REGEX ".*\\.py$" REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")
  IF("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1" TYPE MODULE FILES "C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/build/AI/Interfaces/Python/AIInterface.dll")
    IF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1/AIInterface.dll")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "C:/MinGW-gcc4.4/bin/strip.exe" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1/AIInterface.dll")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/./AI/Interfaces/Python/0.1/AIInterface.dll")
  ENDIF("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./AI/Skirmish/NullPythonAI/0.1" TYPE DIRECTORY FILES "C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/AI/Interfaces/Python/NullPythonAI/src/" FILES_MATCHING REGEX ".*\\.py$" REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./AI/Skirmish/NullPythonAI/0.1" TYPE DIRECTORY FILES "C:/Users/StephaneMeresse/Desktop/mocahteam/ProgAndPlay/Spring_dev/spring_0.82.5.1/AI/Interfaces/Python/NullPythonAI/data/" FILES_MATCHING REGEX ".*\\.lua$" REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" MATCHES "^(Unspecified)$")

