# Note: OpenGL32 must precede Gdi32 as it overwrites some functions.
LIBS += -lole32 -luser32 -lwinspool -limm32 -lwinmm -loleaut32

qtConfig(opengl):!qtConfig(opengles2):!qtConfig(dynamicgl): LIBS *= -lopengl32

mingw: LIBS *= -luuid
# For the dialog helpers:
LIBS += -lshlwapi -lshell32 -ladvapi32

DEFINES *= QT_NO_CAST_FROM_ASCII

qtConfig(directwrite) {
    qtConfig(directwrite2): \
        DEFINES *= QT_USE_DIRECTWRITE2

    SOURCES += $$PWD/qwindowsfontenginedirectwrite.cpp
    HEADERS += $$PWD/qwindowsfontenginedirectwrite.h
} else {
    DEFINES *= QT_NO_DIRECTWRITE
}

SOURCES += \
    $$PWD/qwindowswindow.cpp \
    $$PWD/qwindowsintegration.cpp \
    $$PWD/qwindowscontext.cpp \
    $$PWD/qwindowsscreen.cpp \
    $$PWD/qwindowskeymapper.cpp \
    $$PWD/qwindowsfontengine.cpp \
    $$PWD/qwindowsfontdatabase.cpp \
    $$PWD/qwindowsmousehandler.cpp \
    $$PWD/qwindowsole.cpp \
    $$PWD/qwindowsmime.cpp \
    $$PWD/qwindowsinternalmimedata.cpp \
    $$PWD/qwindowscursor.cpp \
    $$PWD/qwindowsinputcontext.cpp \
    $$PWD/qwindowstheme.cpp \
    $$PWD/qwindowsdialoghelpers.cpp \
    $$PWD/qwindowsservices.cpp \
    $$PWD/qwindowsnativeimage.cpp \
    $$PWD/qwindowsnativeinterface.cpp \
    $$PWD/qwindowsopengltester.cpp

HEADERS += \
    $$PWD/qwindowswindow.h \
    $$PWD/qwindowsintegration.h \
    $$PWD/qwindowscontext.h \
    $$PWD/qwindowsscreen.h \
    $$PWD/qwindowskeymapper.h \
    $$PWD/qwindowsfontengine.h \
    $$PWD/qwindowsfontdatabase.h \
    $$PWD/qwindowsmousehandler.h \
    $$PWD/qtwindowsglobal.h \
    $$PWD/qwindowsole.h \
    $$PWD/qwindowsmime.h \
    $$PWD/qwindowsinternalmimedata.h \
    $$PWD/qwindowscursor.h \
    $$PWD/qwindowsinputcontext.h \
    $$PWD/qwindowstheme.h \
    $$PWD/qwindowsdialoghelpers.h \
    $$PWD/qwindowsservices.h \
    $$PWD/qwindowsnativeimage.h \
    $$PWD/qwindowsnativeinterface.h \
    $$PWD/qwindowsopengltester.h \
    $$PWD/qwindowsthreadpoolrunner.h

INCLUDEPATH += $$PWD

qtConfig(opengl): HEADERS += $$PWD/qwindowsopenglcontext.h

qtConfig(opengles2) {
    SOURCES += $$PWD/qwindowseglcontext.cpp
    HEADERS += $$PWD/qwindowseglcontext.h
} else: qtConfig(opengl) {
    SOURCES += $$PWD/qwindowsglcontext.cpp
    HEADERS += $$PWD/qwindowsglcontext.h
}

# Dynamic GL needs both WGL and EGL
qtConfig(dynamicgl) {
    SOURCES += $$PWD/qwindowseglcontext.cpp
    HEADERS += $$PWD/qwindowseglcontext.h
}

!contains( DEFINES, QT_NO_CLIPBOARD ) {
    SOURCES += $$PWD/qwindowsclipboard.cpp
    HEADERS += $$PWD/qwindowsclipboard.h
}

# drag and drop on windows only works if a clipboard is available
!contains( DEFINES, QT_NO_DRAGANDDROP ) {
    !win32:SOURCES += $$PWD/qwindowsdrag.cpp
    !win32:HEADERS += $$PWD/qwindowsdrag.h
    win32:!contains( DEFINES, QT_NO_CLIPBOARD ) {
        HEADERS += $$PWD/qwindowsdrag.h
        SOURCES += $$PWD/qwindowsdrag.cpp
    }
}

!contains( DEFINES, QT_NO_TABLETEVENT ) {
    INCLUDEPATH += $$QT_SOURCE_TREE/src/3rdparty/wintab
    HEADERS += $$PWD/qwindowstabletsupport.h
    SOURCES += $$PWD/qwindowstabletsupport.cpp
}

!contains( DEFINES, QT_NO_SESSIONMANAGER ) {
    SOURCES += $$PWD/qwindowssessionmanager.cpp
    HEADERS += $$PWD/qwindowssessionmanager.h
}

!contains( DEFINES, QT_NO_IMAGEFORMAT_PNG ):RESOURCES += $$PWD/cursors.qrc

RESOURCES += $$PWD/openglblacklists.qrc

qtConfig(freetype) {
    HEADERS += $$PWD/qwindowsfontdatabase_ft.h
    SOURCES += $$PWD/qwindowsfontdatabase_ft.cpp
    qtConfig(system-freetype) {
        include($$QT_SOURCE_TREE/src/platformsupport/fontdatabases/basic/basic.pri)
    } else {
        include($$QT_SOURCE_TREE/src/3rdparty/freetype_dependency.pri)
    }
}

qtConfig(accessibility): include($$PWD/accessible/accessible.pri)

DEFINES *= LIBEGL_NAME=$${LIBEGL_NAME}
DEFINES *= LIBGLESV2_NAME=$${LIBGLESV2_NAME}
