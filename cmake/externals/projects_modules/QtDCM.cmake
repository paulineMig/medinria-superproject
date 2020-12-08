##############################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
################################################################################

function(QtDcm_project)
set(ep QtDCM)


## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep}_dependencies 
  Qt4 
  ITK 
  DCMTK
  )
  
  
## #############################################################################
## Prepare the project
## #############################################################################

EP_Initialisation(${ep}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIRED_FOR_PLUGINS ON
  )



if (NOT USE_SYSTEM_${ep})
## #############################################################################
## Set directories
## #############################################################################

EP_SetDirectories(${ep}
  EP_DIRECTORIES ep_dirs
  )

# Active QTNETWORK
if (QT4_FOUND)
  set(QT_USE_QTNETWORK TRUE)
  include(${QT_USE_FILE})
endif(QT4_FOUND)


## #############################################################################
## Set up versioning control.
## #############################################################################

set(tag "music")
if (NOT DEFINED ${ep}_SOURCE_DIR)
    set(location GIT_REPOSITORY "${GITHUB_PREFIX}medInria/qtdcm_archived.git" GIT_TAG ${tag})
endif()

## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

set(cmake_args
  ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${${ep}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep}_cxx_flags}
  -DCMAKE_SHARED_LINKER_FLAGS:STRING=${${ep}_shared_linker_flags}  
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep}}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
  )

## #############################################################################
## Check if patch has to be applied
## #############################################################################

ep_GeneratePatchCommand(QtDCM QtDCM_PATCH_COMMAND QtDCM.patch)

## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep}
  ${ep_dirs}
  ${location}
  UPDATE_COMMAND ""
  PATCH_COMMAND ${QtDCM_PATCH_COMMAND}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  DEPENDS ${${ep}_dependencies}
  INSTALL_COMMAND ""
  BUILD_ALWAYS 1
  )


## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep} binary_dir)
set(${ep}_DIR ${binary_dir} PARENT_SCOPE)


## #############################################################################
## Add custom targets
## #############################################################################

EP_AddCustomTargets(${ep})


endif() #NOT USE_SYSTEM_ep

endfunction()
