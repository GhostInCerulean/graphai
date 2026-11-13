cmake_minimum_required(VERSION 4.0)
project(graphai)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)

include(cmake/CPM.cmake)

CPMAddPackage(
        NAME glaze
        URL https://github.com/stephenberry/glaze/archive/refs/tags/v9.1.0.tar.gz
        VERSION 9.1.0
)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

if(ANDROID)
    set_target_properties(graphai PROPERTIES
            QT_ANDROID_PACKAGE_NAME "com.example.graphai"
            QT_ANDROID_VERSION_CODE 1
            QT_ANDROID_VERSION_NAME "1.0"
    )
endif()

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
