cmake_minimum_required(VERSION 3.25)
project(graphai VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)

include(cmake/CPM.cmake)

CPMAddPackage(
        NAME glaze
        URL https://github.com/stephenberry/glaze/archive/refs/tags/v9.1.0.tar.gz
        VERSION 9.1.0
)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Qml)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(graphai
        src/main.cpp
        src/bible.cpp
        src/bible.hpp
        src/book_model.cpp
        src/book_model.hpp
        src/verse_model.cpp
        src/verse_model.hpp
        src/bible_view_model.cpp
        src/bible_view_model.hpp
        src/utils/bench.cpp
        src/utils/bench.hpp
)

if(ANDROID)
    set_target_properties(graphai PROPERTIES
            QT_ANDROID_PACKAGE_NAME "com.example.graphai"
            QT_ANDROID_VERSION_CODE 1
            QT_ANDROID_VERSION_NAME "1.0"
    )
endif()

qt_add_qml_module(graphai
        URI App
        VERSION 1.0
        QML_FILES
            ui/Main.qml
)

qt_add_resources(graphai bible_data
        PREFIX "/" BASE data
        FILES
            assets/nkjv.beve
        OPTIONS
            -no-compress
)

target_link_libraries(graphai PRIVATE
        Qt6::Quick
        glaze::glaze
)

target_include_directories(graphai PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

include(GNUInstallDirs)

install(TARGETS graphai
        BUNDLE  DESTINATION .
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_qml_app_script(
        TARGET graphai
        OUTPUT_SCRIPT graphai_deploy_script
)
install(SCRIPT ${graphai_deploy_script})

set(CPACK_PACKAGE_NAME "GraphAI")
set(CPACK_PACKAGE_VENDOR "GraphAI")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "GraphAI")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "GraphAI")

# Creates a Start Menu shortcut in the Windows NSIS installer.
set(CPACK_PACKAGE_EXECUTABLES "graphai" "GraphAI")

if(WIN32)
    set(CPACK_GENERATOR "NSIS;ZIP")
elseif(APPLE)
    set(CPACK_GENERATOR "DragNDrop;TGZ")
else()
    set(CPACK_GENERATOR "DEB;RPM;TGZ")

    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "GraphAI maintainers")
    set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
    set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)

    set(CPACK_RPM_PACKAGE_LICENSE "Proprietary")
endif()

include(CPack)
