# -------------------------------------------------
# QGroundControl - Micro Air Vehicle Groundstation
# Please see our website at <http://qgroundcontrol.org>
# Maintainer:
# Lorenz Meier <lm@inf.ethz.ch>
# (c) 2009-2019 QGroundControl Developers
# License terms set in COPYING.md
# -------------------------------------------------

QMAKE_PROJECT_DEPTH = 0 # undocumented qmake flag to force absolute paths in make files

# These are disabled until proven correct


DEFINES += QGC_GST_TAISYNC_DISABLED
DEFINES += QGC_GST_MICROHARD_DISABLED

exists($${OUT_PWD}/qgroundcontrol.pro) {
    error("You must use shadow build (e.g. mkdir build; cd build; qmake ../qgroundcontrol.pro).")
}

message(Qt version $$[QT_VERSION])

!equals(QT_MAJOR_VERSION, 5) | !greaterThan(QT_MINOR_VERSION, 10) {
    error("Unsupported Qt version, 5.11+ is required")
}

include(QGCCommon.pri)

TARGET   = QGroundControl
TEMPLATE = app
QGCROOT  = $$PWD

DebugBuild {
    DESTDIR  = $${OUT_PWD}/debug
} else {
    DESTDIR  = $${OUT_PWD}/release
}

QML_IMPORT_PATH += $$PWD/src/QmlControls

#
# OS Specific settings
#

MacBuild {
    QMAKE_INFO_PLIST    = Custom-Info.plist
    ICON                = $${BASEDIR}/resources/icons/macx.icns
    OTHER_FILES        += Custom-Info.plist
    LIBS               += -framework ApplicationServices
}

LinuxBuild {
    CONFIG  += qesp_linux_udev
}

WindowsBuild {
    RC_ICONS = resources/icons/YDHY.ico
    CONFIG += resources_big
}

#
# Branding
#

QGC_APP_NAME        = "QGroundControl"
QGC_ORG_NAME        = "QGroundControl.org"
QGC_ORG_DOMAIN      = "org.qgroundcontrol"
QGC_APP_DESCRIPTION = "Open source ground control app provided by QGroundControl dev team"
QGC_APP_COPYRIGHT   = "Copyright (C) 2019 QGroundControl Development Team. All rights reserved."

WindowsBuild {
    QGC_INSTALLER_ICON          = "WindowsQGC.ico"
    QGC_INSTALLER_HEADER_BITMAP = "installheader.bmp"
}

# Load additional config flags from user_config.pri
exists(user_config.pri):infile(user_config.pri, CONFIG) {
    CONFIG += $$fromfile(user_config.pri, CONFIG)
    message($$sprintf("Using user-supplied additional config: '%1' specified in user_config.pri", $$fromfile(user_config.pri, CONFIG)))
}

#
# Custom Build
#
# QGC will create a "CUSTOMCLASS" object (exposed by your custom build
# and derived from QGCCorePlugin).
# This is the start of allowing custom Plugins, which will eventually use a
# more defined runtime plugin architecture and not require a QGC project
# file you would have to keep in sync with the upstream repo.
#

# This allows you to ignore the custom build even if the custom build
# is present. It's useful to run "regular" builds to make sure you didn't
# break anything.

contains (CONFIG, QGC_DISABLE_CUSTOM_BUILD) {
    message("Disable custom build override")
} else {
    exists($$PWD/custom/custom.pri) {
        message("Found custom build")
        CONFIG  += CustomBuild
        DEFINES += QGC_CUSTOM_BUILD
        # custom.pri must define:
        # CUSTOMCLASS  = YourIQGCCorePluginDerivation
        # CUSTOMHEADER = \"\\\"YourIQGCCorePluginDerivation.h\\\"\"
        include($$PWD/custom/custom.pri)
    }
}

WindowsBuild {
    # Sets up application properties
    QMAKE_TARGET_COMPANY        = "$${QGC_ORG_NAME}"
    QMAKE_TARGET_DESCRIPTION    = "$${QGC_APP_DESCRIPTION}"
    QMAKE_TARGET_COPYRIGHT      = "$${QGC_APP_COPYRIGHT}"
    QMAKE_TARGET_PRODUCT        = "$${QGC_APP_NAME}"

}

#-------------------------------------------------------------------------------------
# iOS

iOSBuild {
    contains (CONFIG, DISABLE_BUILTIN_IOS) {
        message("Skipping builtin support for iOS")
    } else {
        LIBS                 += -framework AVFoundation
        #-- Info.plist (need an "official" one for the App Store)
        ForAppStore {
            message(App Store Build)
            #-- Create official, versioned Info.plist
            APP_STORE = $$system(cd $${BASEDIR} && $${BASEDIR}/tools/update_ios_version.sh $${BASEDIR}/ios/iOSForAppStore-Info-Source.plist $${BASEDIR}/ios/iOSForAppStore-Info.plist)
            APP_ERROR = $$find(APP_STORE, "Error")
            count(APP_ERROR, 1) {
                error("Error building .plist file. 'ForAppStore' builds are only possible through the official build system.")
            }
            QT               += qml-private
            QMAKE_INFO_PLIST  = $${BASEDIR}/ios/iOSForAppStore-Info.plist
            OTHER_FILES      += $${BASEDIR}/ios/iOSForAppStore-Info.plist
        } else {
            QMAKE_INFO_PLIST  = $${BASEDIR}/ios/iOS-Info.plist
            OTHER_FILES      += $${BASEDIR}/ios/iOS-Info.plist
        }
        QMAKE_ASSET_CATALOGS += ios/Images.xcassets
        BUNDLE.files          = ios/QGCLaunchScreen.xib $$QMAKE_INFO_PLIST
        QMAKE_BUNDLE_DATA    += BUNDLE
    }
}

#
# Plugin configuration
#
# This allows you to build custom versions of QGC which only includes your
# specific vehicle plugin. To remove support for a firmware type completely,
# disable both the Plugin and PluginFactory entries. To include custom support
# for an existing plugin type disable PluginFactory only. Then provide you own
# implementation of FirmwarePluginFactory and use the FirmwarePlugin and
# AutoPilotPlugin classes as the base clase for your derived plugin
# implementation.

contains (CONFIG, QGC_DISABLE_APM_PLUGIN) {
    message("Disable APM Plugin")
} else {
    CONFIG += APMFirmwarePlugin
}

contains (CONFIG, QGC_DISABLE_APM_PLUGIN_FACTORY) {
    message("Disable APM Plugin Factory")
} else {
    CONFIG += APMFirmwarePluginFactory
}

contains (CONFIG, QGC_DISABLE_PX4_PLUGIN) {
    message("Disable PX4 Plugin")
} else {
    CONFIG += PX4FirmwarePlugin
}

contains (CONFIG, QGC_DISABLE_PX4_PLUGIN_FACTORY) {
    message("Disable PX4 Plugin Factory")
} else {
    CONFIG += PX4FirmwarePluginFactory
}

# Bluetooth
contains (DEFINES, QGC_DISABLE_BLUETOOTH) {
    message("Skipping support for Bluetooth (manual override from command line)")
    DEFINES -= QGC_ENABLE_BLUETOOTH
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, QGC_DISABLE_BLUETOOTH) {
    message("Skipping support for Bluetooth (manual override from user_config.pri)")
    DEFINES -= QGC_ENABLE_BLUETOOTH
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, QGC_ENABLE_BLUETOOTH) {
    message("Including support for Bluetooth (manual override from user_config.pri)")
    DEFINES += QGC_ENABLE_BLUETOOTH
}

# QTNFC
contains (DEFINES, QGC_DISABLE_QTNFC) {
    message("Skipping support for QTNFC (manual override from command line)")
    DEFINES -= QGC_ENABLE_QTNFC
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, QGC_DISABLE_QTNFC) {
    message("Skipping support for QTNFC (manual override from user_config.pri)")
    DEFINES -= QGC_ENABLE_QTNFC
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, QGC_ENABLE_QTNFC) {
    message("Including support for QTNFC (manual override from user_config.pri)")
    DEFINES += QGC_ENABLE_QTNFC
}

# USB Camera and UVC Video Sources
contains (DEFINES, QGC_DISABLE_UVC) {
    message("Skipping support for UVC devices (manual override from command line)")
    DEFINES += QGC_DISABLE_UVC
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, QGC_DISABLE_UVC) {
    message("Skipping support for UVC devices (manual override from user_config.pri)")
    DEFINES += QGC_DISABLE_UVC
} else:LinuxBuild {
    contains(QT_VERSION, 5.5.1) {
        message("Skipping support for UVC devices (conflict with Qt 5.5.1 on Ubuntu)")
        DEFINES += QGC_DISABLE_UVC
    }
}

LinuxBuild {
    CONFIG += link_pkgconfig
}

# Qt configuration

CONFIG += qt \
    thread \
    c++11

DebugBuild {
    CONFIG -= qtquickcompiler
} else {
    CONFIG += qtquickcompiler
}

contains(DEFINES, ENABLE_VERBOSE_OUTPUT) {
    message("Enable verbose compiler output (manual override from command line)")
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, ENABLE_VERBOSE_OUTPUT) {
    message("Enable verbose compiler output (manual override from user_config.pri)")
} else {
    CONFIG += silent
}

QT += \
    concurrent \
    gui \
    location \
    network \
    opengl \
    positioning \
    qml \
    quick \
    quickwidgets \
    sql \
    svg \
    widgets \
    xml \
    texttospeech \

# Multimedia only used if QVC is enabled
!contains (DEFINES, QGC_DISABLE_UVC) {
    QT += \
        multimedia
}

AndroidBuild || iOSBuild {
    # Android and iOS don't unclude these
} else {
    QT += \
        printsupport \
        serialport \
}

contains(DEFINES, QGC_ENABLE_BLUETOOTH) {
QT += \
    bluetooth \
}

contains(DEFINES, QGC_ENABLE_QTNFC) {
QT += \
    nfc \
}

#  testlib is needed even in release flavor for QSignalSpy support
QT += testlib
ReleaseBuild {
    # We don't need the testlib console in release mode
    QT.testlib.CONFIG -= console
}

#
# Build-specific settings
#

DebugBuild {
!iOSBuild {
    CONFIG += console
}
}

#
# Our QtLocation "plugin"
#

include(src/QtLocationPlugin/QGCLocationPlugin.pri)

# Until pairing can be made to work cleanly on all OS it is turned off
DEFINES+=QGC_DISABLE_PAIRING

# Pairing
contains (DEFINES, QGC_DISABLE_PAIRING) {
    message("Skipping support for Pairing")
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, QGC_DISABLE_PAIRING) {
    message("Skipping support for Pairing (manual override from user_config.pri)")
} else:AndroidBuild:contains(QT_ARCH, arm64) {
    # Haven't figured out how to get 64 bit arm OpenSLL yet which pairing requires
    message("Skipping support for Pairing (Missing Android OpenSSL 64 bit support)")
} else {
    message("Enabling support for Pairing")
    DEFINES += QGC_ENABLE_PAIRING
}

#
# External library configuration
#

include(QGCExternalLibs.pri)

#
# Resources (custom code can replace them)
#

CustomBuild {
    exists($$PWD/custom/qgroundcontrol.qrc) {
        message("Using custom qgroundcontrol.qrc")
        RESOURCES += $$PWD/custom/qgroundcontrol.qrc
    } else {
        RESOURCES += $$PWD/qgroundcontrol.qrc
    }
    exists($$PWD/custom/qgcresources.qrc) {
        message("Using custom qgcresources.qrc")
        RESOURCES += $$PWD/custom/qgcresources.qrc
    } else {
        RESOURCES += $$PWD/qgcresources.qrc
    }
    exists($$PWD/custom/qgcimages.qrc) {
        message("Using custom qgcimages.qrc")
        RESOURCES += $$PWD/custom/qgcimages.qrc
    } else {
        RESOURCES += $$PWD/qgcimages.qrc
    }
} else {
    DEFINES += QGC_APPLICATION_NAME=\"\\\"QGroundControl\\\"\"
    DEFINES += QGC_ORG_NAME=\"\\\"QGroundControl.org\\\"\"
    DEFINES += QGC_ORG_DOMAIN=\"\\\"org.qgroundcontrol\\\"\"
    RESOURCES += \
        $$PWD/qgroundcontrol.qrc \
        $$PWD/qgcresources.qrc \
        $$PWD/qgcimages.qrc
}

# On Qt 5.9 android versions there is the following bug: https://bugreports.qt.io/browse/QTBUG-61424
# This prevents FileDialog from being used. So we have a temp hack workaround for it which just no-ops
# the FileDialog fallback mechanism on android 5.9 builds.
equals(QT_MAJOR_VERSION, 5):equals(QT_MINOR_VERSION, 9):AndroidBuild {
    RESOURCES += $$PWD/HackAndroidFileDialog.qrc
} else {
    RESOURCES += $$PWD/HackFileDialog.qrc
}

#
# Main QGroundControl portion of project file
#

DebugBuild {
    # Unit Test resources
    RESOURCES += UnitTest.qrc
}

DEPENDPATH += \
    . \
    plugins

INCLUDEPATH += .

INCLUDEPATH += \
    include/ui \
    src \
    src/ADSB \
    src/api \
    src/AnalyzeView \
    src/Camera \
    src/AutoPilotPlugins \
    src/FlightDisplay \
    src/FlightMap \
    src/FlightMap/Widgets \
    src/FollowMe \
    src/Geo \
    src/GPS \
    src/Joystick \
    src/PlanView \
    src/MissionManager \
    src/PositionManager \
    src/QmlControls \
    src/QtLocationPlugin \
    src/QtLocationPlugin/QMLControl \
    src/Settings \
    src/Terrain \
    src/Vehicle \
    src/ViewWidgets \
    src/Audio \
    src/comm \
    src/input \
    src/lib/qmapcontrol \
    src/uas \
    src/ui \
    src/ui/linechart \
    src/ui/map \
    src/ui/mapdisplay \
    src/ui/mission \
    src/ui/px4_configuration \
    src/ui/toolbar \
    src/ui/uas \

contains (DEFINES, QGC_ENABLE_PAIRING) {
    INCLUDEPATH += \
        src/PairingManager \
}

#
# Plugin API
#

HEADERS += \
    src/AnalyzeView/LogDownloadTest.h \
    src/DefineHelper.h \
    src/GPS/Drivers/src/mtk.h \
    src/Geo/Utility.h \
    src/MobileScreenMgr.h \
    src/NetWork.h \
    src/NetWork/NetManage.h \
    src/NetWork/TcpSocket.h \
    src/QGCDockWidget.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qcache3q_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeocameracapabilities_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeocameradata_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeocameratiles_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeocodereply_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeocodingmanager_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeocodingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomaneuver_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomap_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomap_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomapcontroller_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomappingmanager_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomappingmanager_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomappingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomappingmanagerengine_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomapscene_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomaptype_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeomaptype_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeoroute_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeoroutereply_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeorouterequest_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeoroutesegment_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeoroutingmanager_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeoroutingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeoserviceprovider_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotilecache_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotiledmap_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotiledmap_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotiledmappingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotiledmappingmanagerengine_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotiledmapreply_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotiledmapreply_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotilefetcher_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotilefetcher_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotilerequestmanager_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotilespec_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qgeotilespec_p_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplace_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceattribute_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacecategory_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacecontactdetail_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacecontent_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacecontentrequest_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceeditorial_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceicon_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceimage_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacemanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceproposedsearchresult_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceratings_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacereply_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceresult_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacereview_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacesearchresult_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplacesupplier_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/qplaceuser_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/5.5.1/QtLocation/private/unsupportedreplies_p.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoCodeReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoCodingManager \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoCodingManagerEngine \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoManeuver \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoRoute \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoRouteReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoRouteRequest \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoRouteSegment \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoRoutingManager \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoRoutingManagerEngine \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoServiceProvider \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QGeoServiceProviderFactory \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QLocation \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlace \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceAttribute \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceCategory \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceContactDetail \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceContent \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceContentReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceContentRequest \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceDetailsReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceEditorial \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceIcon \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceIdReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceImage \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceManager \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceManagerEngine \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceMatchReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceMatchRequest \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceProposedSearchResult \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceRatings \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceResult \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceReview \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceSearchReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceSearchRequest \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceSearchResult \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceSearchSuggestionReply \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceSupplier \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QPlaceUser \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QtLocation \
    src/QtLocationPlugin/qtlocation/include/QtLocation/QtLocationVersion \
    src/QtLocationPlugin/qtlocation/include/QtLocation/placemacro.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeocodereply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeocodingmanager.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeocodingmanagerengine.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeomaneuver.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeoroute.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeoroutereply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeorouterequest.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeoroutesegment.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeoroutingmanager.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeoroutingmanagerengine.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeoserviceprovider.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qgeoserviceproviderfactory.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qlocation.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qlocationglobal.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplace.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceattribute.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacecategory.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacecontactdetail.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacecontent.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacecontentreply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacecontentrequest.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacedetailsreply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceeditorial.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceicon.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceidreply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceimage.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacemanager.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacemanagerengine.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacematchreply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacematchrequest.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceproposedsearchresult.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceratings.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacereply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceresult.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacereview.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacesearchreply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacesearchrequest.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacesearchresult.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacesearchsuggestionreply.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplacesupplier.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qplaceuser.h \
    src/QtLocationPlugin/qtlocation/include/QtLocation/qtlocationversion.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qdeclarativegeoaddress_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qdeclarativegeolocation_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qdoublevector2d_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qdoublevector3d_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeoaddress_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeocircle_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeocoordinate_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeolocation_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeopositioninfosource_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeoprojection_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeorectangle_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qgeoshape_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qlocationutils_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/5.5.1/QtPositioning/private/qnmeapositioninfosource_p.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoAddress \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoAreaMonitorInfo \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoAreaMonitorSource \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoCircle \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoCoordinate \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoLocation \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoPositionInfo \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoPositionInfoSource \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoPositionInfoSourceFactory \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoRectangle \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoSatelliteInfo \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoSatelliteInfoSource \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QGeoShape \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QNmeaPositionInfoSource \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QtPositioning \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/QtPositioningVersion \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeoaddress.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeoareamonitorinfo.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeoareamonitorsource.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeocircle.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeocoordinate.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeolocation.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeopositioninfo.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeopositioninfosource.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeopositioninfosourcefactory.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeorectangle.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeosatelliteinfo.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeosatelliteinfosource.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qgeoshape.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qnmeapositioninfosource.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qpositioningglobal.h \
    src/QtLocationPlugin/qtlocation/include/QtPositioning/qtpositioningversion.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qcache3q_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocameracapabilities_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocameradata_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocameratiles_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocodereply.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocodereply_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocodingmanager.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocodingmanager_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocodingmanagerengine.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeocodingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomaneuver.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomaneuver_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomap_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomap_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomapcontroller_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomappingmanager_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomappingmanager_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomappingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomappingmanagerengine_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomapscene_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomaptype_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeomaptype_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroute.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroute_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutereply.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutereply_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeorouterequest.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeorouterequest_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutesegment.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutesegment_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutingmanager.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutingmanager_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutingmanagerengine.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoroutingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoserviceprovider.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoserviceprovider_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeoserviceproviderfactory.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotilecache_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotiledmap_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotiledmap_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotiledmappingmanagerengine_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotiledmappingmanagerengine_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotiledmapreply_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotiledmapreply_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotilefetcher_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotilefetcher_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotilerequestmanager_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotilespec_p.h \
    src/QtLocationPlugin/qtlocation/src/location/maps/qgeotilespec_p_p.h \
    src/QtLocationPlugin/qtlocation/src/location/qlocation.h \
    src/QtLocationPlugin/qtlocation/src/location/qlocationglobal.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qdeclarativegeoaddress_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qdeclarativegeolocation_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qdoublevector2d_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qdoublevector3d_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeoaddress.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeoaddress_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeoareamonitorinfo.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeoareamonitorsource.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeocircle.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeocircle_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeocoordinate.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeocoordinate_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeolocation.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeolocation_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeopositioninfo.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeopositioninfosource.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeopositioninfosource_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeopositioninfosourcefactory.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeoprojection_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeorectangle.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeorectangle_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeosatelliteinfo.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeosatelliteinfosource.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeoshape.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qgeoshape_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qlocationutils_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qnmeapositioninfosource.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qnmeapositioninfosource_p.h \
    src/QtLocationPlugin/qtlocation/src/positioning/qpositioningglobal.h \
    src/Vehicle/Vehicle.h~RF6c07d4d2.TMP \
    src/Vehicle/data.h \
    src/Vehicle/linkdatapack.h \
    src/Vehicle/mysqlhelper.h \
    src/Vehicle/mytimer.h \
    src/Vehicle/senddata.h \
    src/Vehicle/sqlitehelper.h \
    src/Vehicle/worker.h \
    src/VideoStreaming/iOS/gst_ios_init.h \
    src/ViewWidgets/CustomCommandWidgetController.h \
    src/ViewWidgets/ViewWidgetController.h \
    src/api/QGCCorePlugin.h \
    src/api/QGCOptions.h \
    src/api/QGCSettings.h \
    src/api/QmlComponentInfo.h \
    src/comm/MavlinkMessagesTimer.h \
    src/GPS/Drivers/src/base_station.h \
    src/qgcunittest/FileDialogTest.h \
    src/qgcunittest/FileManagerTest.h \
    src/qgcunittest/FlightGearTest.h \
    src/qgcunittest/MainWindowTest.h \
    src/qgcunittest/MessageBoxTest.h \
    src/qgcunittest/RadioConfigTest.h \
    src/quserlogin.h \
    src/setting.h \
    src/ui/MAVLinkDecoder.h \
    src/ui/QGCMapRCToParamDialog.h \
    src/ui/QGCPluginHost.h

#//202203Add ȡ���Ե�¼������
#    src/quserlogin.h

contains (DEFINES, QGC_ENABLE_PAIRING) {
    HEADERS += \
        src/PairingManager/aes.h
}

SOURCES += \
    src/AnalyzeView/LogDownloadTest.cc \
    src/GPS/Drivers/src/mtk.cpp \
    src/MobileScreenMgr.mm \
    src/NetWork.cpp \
    src/NetWork/NetManage.cpp \
    src/NetWork/TcpSocket.cpp \
    src/QGCDockWidget.cc \
    src/Vehicle/data - 副本.cpp \
    src/Vehicle/data.cpp \
    src/Vehicle/databaseagain.cpp \
    src/Vehicle/linkdatapack.cpp \
    src/Vehicle/mysqlhelper.cpp \
    src/Vehicle/mytimer.cpp \
    src/Vehicle/senddata.cpp \
    src/Vehicle/worker.cpp \
    src/ViewWidgets/ViewWidgetController.cc \
    src/api/QGCCorePlugin.cc \
    src/api/QGCOptions.cc \
    src/api/QGCSettings.cc \
    src/api/QmlComponentInfo.cc \
    src/comm/MavlinkMessagesTimer.cc \
    src/qgcunittest/FileDialogTest.cc \
    src/qgcunittest/FileManagerTest.cc \
    src/qgcunittest/FlightGearTest.cc \
    src/qgcunittest/MainWindowTest.cc \
    src/qgcunittest/MessageBoxTest.cc \
    src/qgcunittest/RadioConfigTest.cc \
    src/quserlogin.cpp \
    src/setting.cpp \
    src/ui/MAVLinkDecoder.cc \
    src/ui/QGCMapRCToParamDialog.cpp \
    src/ui/QGCPluginHost.cc
#//202203Add ȡ���Ե�¼������
#    src/quserlogin.cpp

contains (DEFINES, QGC_ENABLE_PAIRING) {
    SOURCES += \
        src/PairingManager/aes.cpp
}

#
# Unit Test specific configuration goes here (requires full debug build with all plugins)
#

DebugBuild { PX4FirmwarePlugin { PX4FirmwarePluginFactory { APMFirmwarePlugin { APMFirmwarePluginFactory { !MobileBuild {
    DEFINES += UNITTEST_BUILD

    INCLUDEPATH += \
        src/qgcunittest

    HEADERS += \
        src/Audio/AudioOutputTest.h \
        src/FactSystem/FactSystemTestBase.h \
        src/FactSystem/FactSystemTestGeneric.h \
        src/FactSystem/FactSystemTestPX4.h \
        src/FactSystem/ParameterManagerTest.h \
        src/MissionManager/CameraCalcTest.h \
        src/MissionManager/CameraSectionTest.h \
        src/MissionManager/CorridorScanComplexItemTest.h \
        src/MissionManager/FWLandingPatternTest.h \
        src/MissionManager/MissionCommandTreeTest.h \
        src/MissionManager/MissionControllerManagerTest.h \
        src/MissionManager/MissionControllerTest.h \
        src/MissionManager/MissionItemTest.h \
        src/MissionManager/MissionManagerTest.h \
        src/MissionManager/MissionSettingsTest.h \
        src/MissionManager/PlanMasterControllerTest.h \
        src/MissionManager/QGCMapPolygonTest.h \
        src/MissionManager/QGCMapPolylineTest.h \
        src/MissionManager/SectionTest.h \
        src/MissionManager/SimpleMissionItemTest.h \
        src/MissionManager/SpeedSectionTest.h \
        src/MissionManager/StructureScanComplexItemTest.h \
        src/MissionManager/SurveyComplexItemTest.h \
        src/MissionManager/TransectStyleComplexItemTest.h \
        src/MissionManager/VisualMissionItemTest.h \
        src/qgcunittest/GeoTest.h \
        src/qgcunittest/LinkManagerTest.h \
        src/qgcunittest/MavlinkLogTest.h \
        src/qgcunittest/MultiSignalSpy.h \
        src/qgcunittest/TCPLinkTest.h \
        src/qgcunittest/TCPLoopBackServer.h \
        src/qgcunittest/UnitTest.h \
        src/Vehicle/SendMavCommandTest.h \
        #src/qgcunittest/RadioConfigTest.h \
        #src/AnalyzeView/LogDownloadTest.h \
        #src/qgcunittest/FileDialogTest.h \
        #src/qgcunittest/FileManagerTest.h \
        #src/qgcunittest/FlightGearTest.h \
        #src/qgcunittest/MainWindowTest.h \
        #src/qgcunittest/MessageBoxTest.h \

    SOURCES += \
        src/Audio/AudioOutputTest.cc \
        src/FactSystem/FactSystemTestBase.cc \
        src/FactSystem/FactSystemTestGeneric.cc \
        src/FactSystem/FactSystemTestPX4.cc \
        src/FactSystem/ParameterManagerTest.cc \
        src/MissionManager/CameraCalcTest.cc \
        src/MissionManager/CameraSectionTest.cc \
        src/MissionManager/CorridorScanComplexItemTest.cc \
        src/MissionManager/FWLandingPatternTest.cc \
        src/MissionManager/MissionCommandTreeTest.cc \
        src/MissionManager/MissionControllerManagerTest.cc \
        src/MissionManager/MissionControllerTest.cc \
        src/MissionManager/MissionItemTest.cc \
        src/MissionManager/MissionManagerTest.cc \
        src/MissionManager/MissionSettingsTest.cc \
        src/MissionManager/PlanMasterControllerTest.cc \
        src/MissionManager/QGCMapPolygonTest.cc \
        src/MissionManager/QGCMapPolylineTest.cc \
        src/MissionManager/SectionTest.cc \
        src/MissionManager/SimpleMissionItemTest.cc \
        src/MissionManager/SpeedSectionTest.cc \
        src/MissionManager/StructureScanComplexItemTest.cc \
        src/MissionManager/SurveyComplexItemTest.cc \
        src/MissionManager/TransectStyleComplexItemTest.cc \
        src/MissionManager/VisualMissionItemTest.cc \
        src/qgcunittest/GeoTest.cc \
        src/qgcunittest/LinkManagerTest.cc \
        src/qgcunittest/MavlinkLogTest.cc \
        src/qgcunittest/MultiSignalSpy.cc \
        src/qgcunittest/TCPLinkTest.cc \
        src/qgcunittest/TCPLoopBackServer.cc \
        src/qgcunittest/UnitTest.cc \
        src/qgcunittest/UnitTestList.cc \
        src/Vehicle/SendMavCommandTest.cc \
        #src/qgcunittest/RadioConfigTest.cc \
        #src/AnalyzeView/LogDownloadTest.cc \
        #src/qgcunittest/FileDialogTest.cc \
        #src/qgcunittest/FileManagerTest.cc \
        #src/qgcunittest/FlightGearTest.cc \
        #src/qgcunittest/MainWindowTest.cc \
        #src/qgcunittest/MessageBoxTest.cc \

} } } } } }

# Main QGC Headers and Source files

HEADERS += \
    src/ADSB/ADSBVehicle.h \
    src/ADSB/ADSBVehicleManager.h \
    src/AnalyzeView/LogDownloadController.h \
    src/AnalyzeView/PX4LogParser.h \
    src/AnalyzeView/ULogParser.h \
    src/AnalyzeView/MavlinkConsoleController.h \
    src/Audio/AudioOutput.h \
    src/Camera/QGCCameraControl.h \
    src/Camera/QGCCameraIO.h \
    src/Camera/QGCCameraManager.h \
    src/CmdLineOptParser.h \
    src/FirmwarePlugin/PX4/px4_custom_mode.h \
    src/FlightMap/Widgets/ValuesWidgetController.h \
    src/FollowMe/FollowMe.h \
    src/Joystick/Joystick.h \
    src/Joystick/JoystickManager.h \
    src/JsonHelper.h \
    src/KMLFileHelper.h \
    src/LogCompressor.h \
    src/MissionManager/CameraCalc.h \
    src/MissionManager/CameraSection.h \
    src/MissionManager/CameraSpec.h \
    src/MissionManager/ComplexMissionItem.h \
    src/MissionManager/CorridorScanComplexItem.h \
    src/MissionManager/CorridorScanPlanCreator.h \
    src/MissionManager/BlankPlanCreator.h \
    src/MissionManager/FixedWingLandingComplexItem.h \
    src/MissionManager/GeoFenceController.h \
    src/MissionManager/GeoFenceManager.h \
    src/MissionManager/KML.h \
    src/MissionManager/MissionCommandList.h \
    src/MissionManager/MissionCommandTree.h \
    src/MissionManager/MissionCommandUIInfo.h \
    src/MissionManager/MissionController.h \
    src/MissionManager/MissionItem.h \
    src/MissionManager/MissionManager.h \
    src/MissionManager/MissionSettingsItem.h \
    src/MissionManager/PlanElementController.h \
    src/MissionManager/PlanCreator.h \
    src/MissionManager/PlanManager.h \
    src/MissionManager/PlanMasterController.h \
    src/MissionManager/QGCFenceCircle.h \
    src/MissionManager/QGCFencePolygon.h \
    src/MissionManager/QGCMapCircle.h \
    src/MissionManager/QGCMapPolygon.h \
    src/MissionManager/QGCMapPolyline.h \
    src/MissionManager/RallyPoint.h \
    src/MissionManager/RallyPointController.h \
    src/MissionManager/RallyPointManager.h \
    src/MissionManager/SimpleMissionItem.h \
    src/MissionManager/Section.h \
    src/MissionManager/SpeedSection.h \
    src/MissionManager/StructureScanComplexItem.h \
    src/MissionManager/StructureScanPlanCreator.h \
    src/MissionManager/SurveyComplexItem.h \
    src/MissionManager/SurveyPlanCreator.h \
    src/MissionManager/TakeoffMissionItem.h \
    src/MissionManager/TransectStyleComplexItem.h \
    src/MissionManager/VisualMissionItem.h \
    src/PositionManager/PositionManager.h \
    src/PositionManager/SimulatedPosition.h \
    src/Geo/QGCGeo.h \
    src/Geo/Constants.hpp \
    src/Geo/Math.hpp \
    src/Geo/Utility.hpp \
    src/Geo/UTMUPS.hpp \
    src/Geo/MGRS.hpp \
    src/Geo/TransverseMercator.hpp \
    src/Geo/PolarStereographic.hpp \
    src/QGC.h \
    src/QGCApplication.h \
    src/QGCComboBox.h \
    src/QGCConfig.h \
    src/QGCFileDownload.h \
    src/QGCLoggingCategory.h \
    src/QGCMapPalette.h \
    src/QGCPalette.h \
    src/QGCQGeoCoordinate.h \
    src/QGCTemporaryFile.h \
    src/QGCToolbox.h \
    src/QmlControls/AppMessages.h \
    src/QmlControls/CoordinateVector.h \
    src/QmlControls/EditPositionDialogController.h \
    src/QmlControls/ParameterEditorController.h \
    src/QmlControls/QGCFileDialogController.h \
    src/QmlControls/QGCImageProvider.h \
    src/QmlControls/QGroundControlQmlGlobal.h \
    src/QmlControls/QmlObjectListModel.h \
    src/QmlControls/QGCGeoBoundingCube.h \
    src/QmlControls/RCChannelMonitorController.h \
    src/QmlControls/ScreenToolsController.h \
    src/QtLocationPlugin/QMLControl/QGCMapEngineManager.h \
    src/Settings/ADSBVehicleManagerSettings.h \
    src/Settings/AppSettings.h \
    src/Settings/AutoConnectSettings.h \
    src/Settings/BrandImageSettings.h \
    src/Settings/FirmwareUpgradeSettings.h \
    src/Settings/FlightMapSettings.h \
    src/Settings/FlyViewSettings.h \
    src/Settings/OfflineMapsSettings.h \
    src/Settings/PlanViewSettings.h \
    src/Settings/RTKSettings.h \
    src/Settings/SettingsGroup.h \
    src/Settings/SettingsManager.h \
    src/Settings/UnitsSettings.h \
    src/Settings/VideoSettings.h \
    src/ShapeFileHelper.h \
    src/SHPFileHelper.h \
    src/Terrain/TerrainQuery.h \
    src/TerrainTile.h \
    src/Vehicle/GPSRTKFactGroup.h \
    src/Vehicle/MAVLinkLogManager.h \
    src/Vehicle/MultiVehicleManager.h \
    src/Vehicle/TrajectoryPoints.h \
    src/Vehicle/Vehicle.h \
    src/Vehicle/VehicleObjectAvoidance.h \
    src/VehicleSetup/JoystickConfigController.h \
    src/comm/LinkConfiguration.h \
    src/comm/LinkInterface.h \
    src/comm/LinkManager.h \
    src/comm/LogReplayLink.h \
    src/comm/MAVLinkProtocol.h \
    src/comm/QGCMAVLink.h \
    src/comm/TCPLink.h \
    src/comm/UDPLink.h \
    src/comm/UdpIODevice.h \
    src/uas/UAS.h \
    src/uas/UASInterface.h \
    src/uas/UASMessageHandler.h \
    src/AnalyzeView/GeoTagController.h \
    src/AnalyzeView/ExifParser.h \
    src/uas/FileManager.h \

contains (DEFINES, QGC_ENABLE_PAIRING) {
    HEADERS += \
        src/PairingManager/PairingManager.h \
}

AndroidBuild {
HEADERS += \
    src/Joystick/JoystickAndroid.h \
}

DebugBuild {
HEADERS += \
    src/comm/MockLink.h \
    src/comm/MockLinkFileServer.h \
    src/comm/MockLinkMissionItemHandler.h \
}

WindowsBuild {
    PRECOMPILED_HEADER += src/stable_headers.h
    HEADERS += src/stable_headers.h
    CONFIG -= silent
    OTHER_FILES += .appveyor.yml
}

contains(DEFINES, QGC_ENABLE_BLUETOOTH) {
    HEADERS += \
    src/comm/BluetoothLink.h \
}

contains (DEFINES, QGC_ENABLE_PAIRING) {
    contains(DEFINES, QGC_ENABLE_QTNFC) {
        HEADERS += \
            src/PairingManager/QtNFC.h
    }
}

!NoSerialBuild {
HEADERS += \
    src/comm/QGCSerialPortInfo.h \
    src/comm/SerialLink.h \
}

!MobileBuild {
HEADERS += \
    src/GPS/Drivers/src/gps_helper.h \
    src/GPS/Drivers/src/rtcm.h \
    src/GPS/Drivers/src/ashtech.h \
    src/GPS/Drivers/src/ubx.h \
    src/GPS/Drivers/src/sbf.h \
    src/GPS/GPSManager.h \
    src/GPS/GPSPositionMessage.h \
    src/GPS/GPSProvider.h \
    src/GPS/RTCM/RTCMMavlink.h \
    src/GPS/definitions.h \
    src/GPS/satellite_info.h \
    src/GPS/vehicle_gps_position.h \
    src/Joystick/JoystickSDL.h \
    src/RunGuard.h \
    src/comm/QGCHilLink.h \
    src/comm/QGCJSBSimLink.h \
    src/comm/QGCXPlaneLink.h \
}

iOSBuild {
    OBJECTIVE_SOURCES += \
        src/MobileScreenMgr.mm \
}

AndroidBuild {
    SOURCES += src/MobileScreenMgr.cc \
    src/Joystick/JoystickAndroid.cc \
}

SOURCES += \
    src/ADSB/ADSBVehicle.cc \
    src/ADSB/ADSBVehicleManager.cc \
    src/AnalyzeView/LogDownloadController.cc \
    src/AnalyzeView/PX4LogParser.cc \
    src/AnalyzeView/ULogParser.cc \
    src/AnalyzeView/MavlinkConsoleController.cc \
    src/Audio/AudioOutput.cc \
    src/Camera/QGCCameraControl.cc \
    src/Camera/QGCCameraIO.cc \
    src/Camera/QGCCameraManager.cc \
    src/CmdLineOptParser.cc \
    src/FlightMap/Widgets/ValuesWidgetController.cc \
    src/FollowMe/FollowMe.cc \
    src/Joystick/Joystick.cc \
    src/Joystick/JoystickManager.cc \
    src/JsonHelper.cc \
    src/KMLFileHelper.cc \
    src/LogCompressor.cc \
    src/MissionManager/CameraCalc.cc \
    src/MissionManager/CameraSection.cc \
    src/MissionManager/CameraSpec.cc \
    src/MissionManager/ComplexMissionItem.cc \
    src/MissionManager/CorridorScanComplexItem.cc \
    src/MissionManager/CorridorScanPlanCreator.cc \
    src/MissionManager/BlankPlanCreator.cc \
    src/MissionManager/FixedWingLandingComplexItem.cc \
    src/MissionManager/GeoFenceController.cc \
    src/MissionManager/GeoFenceManager.cc \
    src/MissionManager/KML.cc \
    src/MissionManager/MissionCommandList.cc \
    src/MissionManager/MissionCommandTree.cc \
    src/MissionManager/MissionCommandUIInfo.cc \
    src/MissionManager/MissionController.cc \
    src/MissionManager/MissionItem.cc \
    src/MissionManager/MissionManager.cc \
    src/MissionManager/MissionSettingsItem.cc \
    src/MissionManager/PlanElementController.cc \
    src/MissionManager/PlanCreator.cc \
    src/MissionManager/PlanManager.cc \
    src/MissionManager/PlanMasterController.cc \
    src/MissionManager/QGCFenceCircle.cc \
    src/MissionManager/QGCFencePolygon.cc \
    src/MissionManager/QGCMapCircle.cc \
    src/MissionManager/QGCMapPolygon.cc \
    src/MissionManager/QGCMapPolyline.cc \
    src/MissionManager/RallyPoint.cc \
    src/MissionManager/RallyPointController.cc \
    src/MissionManager/RallyPointManager.cc \
    src/MissionManager/SimpleMissionItem.cc \
    src/MissionManager/SpeedSection.cc \
    src/MissionManager/StructureScanComplexItem.cc \
    src/MissionManager/StructureScanPlanCreator.cc \
    src/MissionManager/SurveyComplexItem.cc \
    src/MissionManager/SurveyPlanCreator.cc \
    src/MissionManager/TakeoffMissionItem.cc \
    src/MissionManager/TransectStyleComplexItem.cc \
    src/MissionManager/VisualMissionItem.cc \
    src/PositionManager/PositionManager.cpp \
    src/PositionManager/SimulatedPosition.cc \
    src/Geo/QGCGeo.cc \
    src/Geo/Math.cpp \
    src/Geo/Utility.cpp \
    src/Geo/UTMUPS.cpp \
    src/Geo/MGRS.cpp \
    src/Geo/TransverseMercator.cpp \
    src/Geo/PolarStereographic.cpp \
    src/QGC.cc \
    src/QGCApplication.cc \
    src/QGCComboBox.cc \
    src/QGCFileDownload.cc \
    src/QGCLoggingCategory.cc \
    src/QGCMapPalette.cc \
    src/QGCPalette.cc \
    src/QGCQGeoCoordinate.cc \
    src/QGCTemporaryFile.cc \
    src/QGCToolbox.cc \
    src/QmlControls/AppMessages.cc \
    src/QmlControls/CoordinateVector.cc \
    src/QmlControls/EditPositionDialogController.cc \
    src/QmlControls/ParameterEditorController.cc \
    src/QmlControls/QGCFileDialogController.cc \
    src/QmlControls/QGCImageProvider.cc \
    src/QmlControls/QGroundControlQmlGlobal.cc \
    src/QmlControls/QmlObjectListModel.cc \
    src/QmlControls/QGCGeoBoundingCube.cc \
    src/QmlControls/RCChannelMonitorController.cc \
    src/QmlControls/ScreenToolsController.cc \
    src/QtLocationPlugin/QMLControl/QGCMapEngineManager.cc \
    src/Settings/ADSBVehicleManagerSettings.cc \
    src/Settings/AppSettings.cc \
    src/Settings/AutoConnectSettings.cc \
    src/Settings/BrandImageSettings.cc \
    src/Settings/FirmwareUpgradeSettings.cc \
    src/Settings/FlightMapSettings.cc \
    src/Settings/FlyViewSettings.cc \
    src/Settings/OfflineMapsSettings.cc \
    src/Settings/PlanViewSettings.cc \
    src/Settings/RTKSettings.cc \
    src/Settings/SettingsGroup.cc \
    src/Settings/SettingsManager.cc \
    src/Settings/UnitsSettings.cc \
    src/Settings/VideoSettings.cc \
    src/ShapeFileHelper.cc \
    src/SHPFileHelper.cc \
    src/Terrain/TerrainQuery.cc \
    src/TerrainTile.cc\
    src/Vehicle/GPSRTKFactGroup.cc \
    src/Vehicle/MAVLinkLogManager.cc \
    src/Vehicle/MultiVehicleManager.cc \
    src/Vehicle/TrajectoryPoints.cc \
    src/Vehicle/Vehicle.cc \
    src/Vehicle/VehicleObjectAvoidance.cc \
    src/VehicleSetup/JoystickConfigController.cc \
    src/comm/LinkConfiguration.cc \
    src/comm/LinkInterface.cc \
    src/comm/LinkManager.cc \
    src/comm/LogReplayLink.cc \
    src/comm/MAVLinkProtocol.cc \
    src/comm/QGCMAVLink.cc \
    src/comm/TCPLink.cc \
    src/comm/UDPLink.cc \
    src/comm/UdpIODevice.cc \
    src/main.cc \
    src/uas/UAS.cc \
    src/uas/UASMessageHandler.cc \
    src/AnalyzeView/GeoTagController.cc \
    src/AnalyzeView/ExifParser.cc \
    src/uas/FileManager.cc \

contains (DEFINES, QGC_ENABLE_PAIRING) {
    SOURCES += \
        src/PairingManager/PairingManager.cc \
}

DebugBuild {
SOURCES += \
    src/comm/MockLink.cc \
    src/comm/MockLinkFileServer.cc \
    src/comm/MockLinkMissionItemHandler.cc \
}

!NoSerialBuild {
SOURCES += \
    src/comm/QGCSerialPortInfo.cc \
    src/comm/SerialLink.cc \
}

contains(DEFINES, QGC_ENABLE_BLUETOOTH) {
    SOURCES += \
    src/comm/BluetoothLink.cc \
}

contains (DEFINES, QGC_ENABLE_PAIRING) {
    contains(DEFINES, QGC_ENABLE_QTNFC) {
        SOURCES += \
        src/PairingManager/QtNFC.cc
    }
}

!MobileBuild {
SOURCES += \
    src/GPS/Drivers/src/gps_helper.cpp \
    src/GPS/Drivers/src/rtcm.cpp \
    src/GPS/Drivers/src/ashtech.cpp \
    src/GPS/Drivers/src/ubx.cpp \
    src/GPS/Drivers/src/sbf.cpp \
    src/GPS/GPSManager.cc \
    src/GPS/GPSProvider.cc \
    src/GPS/RTCM/RTCMMavlink.cc \
    src/Joystick/JoystickSDL.cc \
    src/RunGuard.cc \
    src/comm/QGCJSBSimLink.cc \
    src/comm/QGCXPlaneLink.cc \
}

#
# Firmware Plugin Support
#

INCLUDEPATH += \
    src/AutoPilotPlugins/Common \
    src/FirmwarePlugin \
    src/VehicleSetup \

HEADERS+= \
    src/AutoPilotPlugins/AutoPilotPlugin.h \
    src/AutoPilotPlugins/Common/ESP8266Component.h \
    src/AutoPilotPlugins/Common/ESP8266ComponentController.h \
    src/AutoPilotPlugins/Common/MotorComponent.h \
    src/AutoPilotPlugins/Common/RadioComponentController.h \
    src/AutoPilotPlugins/Common/SyslinkComponent.h \
    src/AutoPilotPlugins/Common/SyslinkComponentController.h \
    src/AutoPilotPlugins/Generic/GenericAutoPilotPlugin.h \
    src/FirmwarePlugin/CameraMetaData.h \
    src/FirmwarePlugin/FirmwarePlugin.h \
    src/FirmwarePlugin/FirmwarePluginManager.h \
    src/VehicleSetup/VehicleComponent.h \

!MobileBuild { !NoSerialBuild {
    HEADERS += \
        src/VehicleSetup/Bootloader.h \
        src/VehicleSetup/FirmwareImage.h \
        src/VehicleSetup/FirmwareUpgradeController.h \
        src/VehicleSetup/PX4FirmwareUpgradeThread.h \
}}

SOURCES += \
    src/AutoPilotPlugins/AutoPilotPlugin.cc \
    src/AutoPilotPlugins/Common/ESP8266Component.cc \
    src/AutoPilotPlugins/Common/ESP8266ComponentController.cc \
    src/AutoPilotPlugins/Common/MotorComponent.cc \
    src/AutoPilotPlugins/Common/RadioComponentController.cc \
    src/AutoPilotPlugins/Common/SyslinkComponent.cc \
    src/AutoPilotPlugins/Common/SyslinkComponentController.cc \
    src/AutoPilotPlugins/Generic/GenericAutoPilotPlugin.cc \
    src/FirmwarePlugin/CameraMetaData.cc \
    src/FirmwarePlugin/FirmwarePlugin.cc \
    src/FirmwarePlugin/FirmwarePluginManager.cc \
    src/VehicleSetup/VehicleComponent.cc \

!MobileBuild { !NoSerialBuild {
    SOURCES += \
        src/VehicleSetup/Bootloader.cc \
        src/VehicleSetup/FirmwareImage.cc \
        src/VehicleSetup/FirmwareUpgradeController.cc \
        src/VehicleSetup/PX4FirmwareUpgradeThread.cc \
}}

# ArduPilot Specific

ArdupilotEnabled {
    HEADERS += \
        src/Settings/APMMavlinkStreamRateSettings.h \

    SOURCES += \
        src/Settings/APMMavlinkStreamRateSettings.cc \
}

# ArduPilot FirmwarePlugin

APMFirmwarePlugin {
    RESOURCES *= src/FirmwarePlugin/APM/APMResources.qrc

    INCLUDEPATH += \
        src/AutoPilotPlugins/APM \
        src/FirmwarePlugin/APM \

    HEADERS += \
        src/AutoPilotPlugins/APM/APMAirframeComponent.h \
        src/AutoPilotPlugins/APM/APMAirframeComponentController.h \
        src/AutoPilotPlugins/APM/APMAutoPilotPlugin.h \
        src/AutoPilotPlugins/APM/APMCameraComponent.h \
        src/AutoPilotPlugins/APM/APMCompassCal.h \
        src/AutoPilotPlugins/APM/APMFlightModesComponent.h \
        src/AutoPilotPlugins/APM/APMFlightModesComponentController.h \
        src/AutoPilotPlugins/APM/APMFollowComponent.h \
        src/AutoPilotPlugins/APM/APMFollowComponentController.h \
        src/AutoPilotPlugins/APM/APMHeliComponent.h \
        src/AutoPilotPlugins/APM/APMLightsComponent.h \
        src/AutoPilotPlugins/APM/APMSubFrameComponent.h \
        src/AutoPilotPlugins/APM/APMMotorComponent.h \
        src/AutoPilotPlugins/APM/APMPowerComponent.h \
        src/AutoPilotPlugins/APM/APMRadioComponent.h \
        src/AutoPilotPlugins/APM/APMSafetyComponent.h \
        src/AutoPilotPlugins/APM/APMSensorsComponent.h \
        src/AutoPilotPlugins/APM/APMSensorsComponentController.h \
        src/AutoPilotPlugins/APM/APMSubMotorComponentController.h \
        src/AutoPilotPlugins/APM/APMTuningComponent.h \
        src/FirmwarePlugin/APM/APMFirmwarePlugin.h \
        src/FirmwarePlugin/APM/APMParameterMetaData.h \
        src/FirmwarePlugin/APM/ArduCopterFirmwarePlugin.h \
        src/FirmwarePlugin/APM/ArduPlaneFirmwarePlugin.h \
        src/FirmwarePlugin/APM/ArduRoverFirmwarePlugin.h \
        src/FirmwarePlugin/APM/ArduSubFirmwarePlugin.h \

    SOURCES += \
        src/AutoPilotPlugins/APM/APMAirframeComponent.cc \
        src/AutoPilotPlugins/APM/APMAirframeComponentController.cc \
        src/AutoPilotPlugins/APM/APMAutoPilotPlugin.cc \
        src/AutoPilotPlugins/APM/APMCameraComponent.cc \
        src/AutoPilotPlugins/APM/APMCompassCal.cc \
        src/AutoPilotPlugins/APM/APMFlightModesComponent.cc \
        src/AutoPilotPlugins/APM/APMFlightModesComponentController.cc \
        src/AutoPilotPlugins/APM/APMFollowComponent.cc \
        src/AutoPilotPlugins/APM/APMFollowComponentController.cc \
        src/AutoPilotPlugins/APM/APMHeliComponent.cc \
        src/AutoPilotPlugins/APM/APMLightsComponent.cc \
        src/AutoPilotPlugins/APM/APMSubFrameComponent.cc \
        src/AutoPilotPlugins/APM/APMMotorComponent.cc \
        src/AutoPilotPlugins/APM/APMPowerComponent.cc \
        src/AutoPilotPlugins/APM/APMRadioComponent.cc \
        src/AutoPilotPlugins/APM/APMSafetyComponent.cc \
        src/AutoPilotPlugins/APM/APMSensorsComponent.cc \
        src/AutoPilotPlugins/APM/APMSensorsComponentController.cc \
        src/AutoPilotPlugins/APM/APMSubMotorComponentController.cc \
        src/AutoPilotPlugins/APM/APMTuningComponent.cc \
        src/FirmwarePlugin/APM/APMFirmwarePlugin.cc \
        src/FirmwarePlugin/APM/APMParameterMetaData.cc \
        src/FirmwarePlugin/APM/ArduCopterFirmwarePlugin.cc \
        src/FirmwarePlugin/APM/ArduPlaneFirmwarePlugin.cc \
        src/FirmwarePlugin/APM/ArduRoverFirmwarePlugin.cc \
        src/FirmwarePlugin/APM/ArduSubFirmwarePlugin.cc \
}

APMFirmwarePluginFactory {
    HEADERS   += src/FirmwarePlugin/APM/APMFirmwarePluginFactory.h
    SOURCES   += src/FirmwarePlugin/APM/APMFirmwarePluginFactory.cc
}

# PX4 FirmwarePlugin

PX4FirmwarePlugin {
    RESOURCES *= src/FirmwarePlugin/PX4/PX4Resources.qrc

    INCLUDEPATH += \
        src/AutoPilotPlugins/PX4 \
        src/FirmwarePlugin/PX4 \

    HEADERS+= \
        src/AutoPilotPlugins/PX4/AirframeComponent.h \
        src/AutoPilotPlugins/PX4/AirframeComponentAirframes.h \
        src/AutoPilotPlugins/PX4/AirframeComponentController.h \
        src/AutoPilotPlugins/PX4/CameraComponent.h \
        src/AutoPilotPlugins/PX4/FlightModesComponent.h \
        src/AutoPilotPlugins/PX4/PX4AdvancedFlightModesController.h \
        src/AutoPilotPlugins/PX4/PX4AirframeLoader.h \
        src/AutoPilotPlugins/PX4/PX4AutoPilotPlugin.h \
        src/AutoPilotPlugins/PX4/PX4RadioComponent.h \
        src/AutoPilotPlugins/PX4/PX4SimpleFlightModesController.h \
        src/AutoPilotPlugins/PX4/PX4TuningComponent.h \
        src/AutoPilotPlugins/PX4/PowerComponent.h \
        src/AutoPilotPlugins/PX4/PowerComponentController.h \
        src/AutoPilotPlugins/PX4/SafetyComponent.h \
        src/AutoPilotPlugins/PX4/SensorsComponent.h \
        src/AutoPilotPlugins/PX4/SensorsComponentController.h \
        src/FirmwarePlugin/PX4/PX4FirmwarePlugin.h \
        src/FirmwarePlugin/PX4/PX4ParameterMetaData.h \

    SOURCES += \
        src/AutoPilotPlugins/PX4/AirframeComponent.cc \
        src/AutoPilotPlugins/PX4/AirframeComponentAirframes.cc \
        src/AutoPilotPlugins/PX4/AirframeComponentController.cc \
        src/AutoPilotPlugins/PX4/CameraComponent.cc \
        src/AutoPilotPlugins/PX4/FlightModesComponent.cc \
        src/AutoPilotPlugins/PX4/PX4AdvancedFlightModesController.cc \
        src/AutoPilotPlugins/PX4/PX4AirframeLoader.cc \
        src/AutoPilotPlugins/PX4/PX4AutoPilotPlugin.cc \
        src/AutoPilotPlugins/PX4/PX4RadioComponent.cc \
        src/AutoPilotPlugins/PX4/PX4SimpleFlightModesController.cc \
        src/AutoPilotPlugins/PX4/PX4TuningComponent.cc \
        src/AutoPilotPlugins/PX4/PowerComponent.cc \
        src/AutoPilotPlugins/PX4/PowerComponentController.cc \
        src/AutoPilotPlugins/PX4/SafetyComponent.cc \
        src/AutoPilotPlugins/PX4/SensorsComponent.cc \
        src/AutoPilotPlugins/PX4/SensorsComponentController.cc \
        src/FirmwarePlugin/PX4/PX4FirmwarePlugin.cc \
        src/FirmwarePlugin/PX4/PX4ParameterMetaData.cc \
}

PX4FirmwarePluginFactory {
    HEADERS   += src/FirmwarePlugin/PX4/PX4FirmwarePluginFactory.h
    SOURCES   += src/FirmwarePlugin/PX4/PX4FirmwarePluginFactory.cc
}

# Fact System code

INCLUDEPATH += \
    src/FactSystem \
    src/FactSystem/FactControls \

HEADERS += \
    src/FactSystem/Fact.h \
    src/FactSystem/FactControls/FactPanelController.h \
    src/FactSystem/FactGroup.h \
    src/FactSystem/FactMetaData.h \
    src/FactSystem/FactSystem.h \
    src/FactSystem/FactValueSliderListModel.h \
    src/FactSystem/ParameterManager.h \
    src/FactSystem/SettingsFact.h \

SOURCES += \
    src/FactSystem/Fact.cc \
    src/FactSystem/FactControls/FactPanelController.cc \
    src/FactSystem/FactGroup.cc \
    src/FactSystem/FactMetaData.cc \
    src/FactSystem/FactSystem.cc \
    src/FactSystem/FactValueSliderListModel.cc \
    src/FactSystem/ParameterManager.cc \
    src/FactSystem/SettingsFact.cc \

#-------------------------------------------------------------------------------------
# MAVLink Inspector
contains (DEFINES, QGC_ENABLE_MAVLINK_INSPECTOR) {
    HEADERS += \
        src/AnalyzeView/MAVLinkInspectorController.h
    SOURCES += \
        src/AnalyzeView/MAVLinkInspectorController.cc
    QT += \
        charts
}

#-------------------------------------------------------------------------------------
# Taisync
contains (DEFINES, QGC_GST_TAISYNC_DISABLED) {
    DEFINES -= QGC_GST_TAISYNC_ENABLED
    message("Taisync disabled")
} else {
    contains (DEFINES, QGC_GST_TAISYNC_ENABLED) {
        INCLUDEPATH += \
            src/Taisync

        HEADERS += \
            src/Taisync/TaisyncManager.h \
            src/Taisync/TaisyncHandler.h \
            src/Taisync/TaisyncSettings.h \

        SOURCES += \
            src/Taisync/TaisyncManager.cc \
            src/Taisync/TaisyncHandler.cc \
            src/Taisync/TaisyncSettings.cc \

        iOSBuild | AndroidBuild {
            HEADERS += \
                src/Taisync/TaisyncTelemetry.h \
                src/Taisync/TaisyncVideoReceiver.h \

            SOURCES += \
                src/Taisync/TaisyncTelemetry.cc \
                src/Taisync/TaisyncVideoReceiver.cc \
        }
    }
}

#-------------------------------------------------------------------------------------
# Microhard
QGC_GST_MICROHARD_DISABLED
contains (DEFINES, QGC_GST_MICROHARD_DISABLED) {
    DEFINES -= QGC_GST_MICROHARD_ENABLED
    message("Microhard disabled")
} else {
    contains (DEFINES, QGC_GST_MICROHARD_ENABLED) {
        INCLUDEPATH += \
            src/Microhard

        HEADERS += \
            src/Microhard/MicrohardManager.h \
            src/Microhard/MicrohardHandler.h \
            src/Microhard/MicrohardSettings.h \

        SOURCES += \
            src/Microhard/MicrohardManager.cc \
            src/Microhard/MicrohardHandler.cc \
            src/Microhard/MicrohardSettings.cc \
    }
}
#-------------------------------------------------------------------------------------
# AirMap

contains (DEFINES, QGC_AIRMAP_ENABLED) {

    #-- These should be always enabled but not yet
    INCLUDEPATH += \
        src/AirspaceManagement

    HEADERS += \
        src/AirspaceManagement/AirspaceAdvisoryProvider.h \
        src/AirspaceManagement/AirspaceFlightPlanProvider.h \
        src/AirspaceManagement/AirspaceManager.h \
        src/AirspaceManagement/AirspaceRestriction.h \
        src/AirspaceManagement/AirspaceRestrictionProvider.h \
        src/AirspaceManagement/AirspaceRulesetsProvider.h \
        src/AirspaceManagement/AirspaceVehicleManager.h \
        src/AirspaceManagement/AirspaceWeatherInfoProvider.h \

    SOURCES += \
        src/AirspaceManagement/AirspaceAdvisoryProvider.cc \
        src/AirspaceManagement/AirspaceFlightPlanProvider.cc \
        src/AirspaceManagement/AirspaceManager.cc \
        src/AirspaceManagement/AirspaceRestriction.cc \
        src/AirspaceManagement/AirspaceRestrictionProvider.cc \
        src/AirspaceManagement/AirspaceRulesetsProvider.cc \
        src/AirspaceManagement/AirspaceVehicleManager.cc \
        src/AirspaceManagement/AirspaceWeatherInfoProvider.cc \

    #-- This is the AirMap implementation of the above
    RESOURCES += \
        src/Airmap/airmap.qrc

    INCLUDEPATH += \
        src/Airmap

    HEADERS += \
        src/Airmap/AirMapAdvisoryManager.h \
        src/Airmap/AirMapFlightManager.h \
        src/Airmap/AirMapFlightPlanManager.h \
        src/Airmap/AirMapManager.h \
        src/Airmap/AirMapRestrictionManager.h \
        src/Airmap/AirMapRulesetsManager.h \
        src/Airmap/AirMapSettings.h \
        src/Airmap/AirMapSharedState.h \
        src/Airmap/AirMapTelemetry.h \
        src/Airmap/AirMapTrafficMonitor.h \
        src/Airmap/AirMapVehicleManager.h \
        src/Airmap/AirMapWeatherInfoManager.h \
        src/Airmap/LifetimeChecker.h \

    SOURCES += \
        src/Airmap/AirMapAdvisoryManager.cc \
        src/Airmap/AirMapFlightManager.cc \
        src/Airmap/AirMapFlightPlanManager.cc \
        src/Airmap/AirMapManager.cc \
        src/Airmap/AirMapRestrictionManager.cc \
        src/Airmap/AirMapRulesetsManager.cc \
        src/Airmap/AirMapSettings.cc \
        src/Airmap/AirMapSharedState.cc \
        src/Airmap/AirMapTelemetry.cc \
        src/Airmap/AirMapTrafficMonitor.cc \
        src/Airmap/AirMapVehicleManager.cc \
        src/Airmap/AirMapWeatherInfoManager.cc \

    #-- Do we have an API key?
    exists(src/Airmap/Airmap_api_key.h) {
        message("Using compile time Airmap API key")
        HEADERS += \
            src/Airmap/Airmap_api_key.h
        DEFINES += QGC_AIRMAP_KEY_AVAILABLE
    }

    include(src/Airmap/QJsonWebToken/src/qjsonwebtoken.pri)

} else {
    #-- Dummies
    INCLUDEPATH += \
        src/Airmap/dummy
    RESOURCES += \
        src/Airmap/dummy/airmap_dummy.qrc
    HEADERS += \
        src/Airmap/dummy/AirspaceManager.h
    SOURCES += \
        src/Airmap/dummy/AirspaceManager.cc
}

#-------------------------------------------------------------------------------------
# Video Streaming

INCLUDEPATH += \
    src/VideoStreaming

HEADERS += \
    src/VideoStreaming/VideoReceiver.h \
    src/VideoStreaming/VideoStreaming.h \
    src/VideoStreaming/SubtitleWriter.h \
    src/VideoStreaming/VideoManager.h

SOURCES += \
    src/VideoStreaming/VideoReceiver.cc \
    src/VideoStreaming/VideoStreaming.cc \
    src/VideoStreaming/SubtitleWriter.cc \
    src/VideoStreaming/VideoManager.cc

contains (CONFIG, DISABLE_VIDEOSTREAMING) {
    message("Skipping support for video streaming (manual override from command line)")
# Otherwise the user can still disable this feature in the user_config.pri file.
} else:exists(user_config.pri):infile(user_config.pri, DEFINES, DISABLE_VIDEOSTREAMING) {
    message("Skipping support for video streaming (manual override from user_config.pri)")
} else {
    include(src/VideoStreaming/VideoStreaming.pri)
}

!VideoEnabled {
    HEADERS += \
       src/VideoStreaming/GLVideoItemStub.h
    SOURCES += \
        src/VideoStreaming/GLVideoItemStub.cc
}

#-------------------------------------------------------------------------------------
# Android

AndroidBuild {
    contains (CONFIG, DISABLE_BUILTIN_ANDROID) {
        message("Skipping builtin support for Android")
    } else {
        include(android.pri)
    }
}

#-------------------------------------------------------------------------------------
#
# Localization
#

TRANSLATIONS += $$files($$PWD/localization/qgc_*.ts)
CONFIG+=lrelease embed_translations

#-------------------------------------------------------------------------------------
#
# Post link configuration
#

contains (CONFIG, QGC_DISABLE_BUILD_SETUP) {
    message("Disable standard build setup")
} else {
    include(QGCSetup.pri)
}

#
# Installer targets
#

contains (CONFIG, QGC_DISABLE_INSTALLER_SETUP) {
    message("Disable standard installer setup")
} else {
    include(QGCInstaller.pri)
}

#202203�޸�
QT       += core gui sql
QT       +=  sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

#SOURCES += \
##    main.cpp \
#    src/Vehicle/linkdatapack.cpp

#HEADERS += \
#    src/Vehicle/linkdatapack.h

#FORMS += \
#    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#//202203ע��ȡ�������û���¼qml
#DISTFILES += \
#    src/UsersLogin.qml

#????qlite?��?��?��???#MOBILITY =

#android {
#    data.files += aaa/zc.db
#    data.path = /assets/bbb
#    INSTALLS += data
#}
#ANDROID_PACKAGE_SOURCE_DIR = $$PWD/aaa

#ANDROID_EXTRA_LIBS = D:/software/qt/5.12.6/android_armv7/plugins/sqldrivers/libqsqlite.so
#????qlite?��?��??��????建�?��?��???建�?��????#ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

#android
#{
#my_files.path = /assets
#my_files.files = $$PWD/android/*
#INSTALLS += my_files
#}
#

#202203ע�� ȡ���ֻ�֧��mysql���ݿ�
contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/libs/OpenSSL/android_openssl/arm/libcrypto.so \
        $$PWD/libs/OpenSSL/android_openssl/arm/libssl.so \
        $$PWD/libmariadb.so
}



#    #?�己添�??满足?��?��?��?��?��?
#    QT += androidextras
#2.0.0.4  �������й������ڲ���
VERSION = 2.0.0.4_Full_20220525
DEFINES += VERSION=\"\\\"$$VERSION\\\"\"

DISTFILES += \
    src/ADSB/CMakeLists.txt \
    src/Airmap/AirMap.SettingsGroup.json \
    src/Airmap/AirmapSettings.qml \
    src/Airmap/AirspaceControl.qml \
    src/Airmap/AirspaceRegulation.qml \
    src/Airmap/AirspaceWeather.qml \
    src/Airmap/CMakeLists.txt \
    src/Airmap/ComplianceRules.qml \
    src/Airmap/FlightBrief.qml \
    src/Airmap/FlightDetails.qml \
    src/Airmap/FlightFeature.qml \
    src/Airmap/QJsonWebToken/README.md \
    src/Airmap/README.md \
    src/Airmap/RuleSelector.qml \
    src/Airmap/dummy/AirspaceControl.qml \
    src/Airmap/dummy/AirspaceRegulation.qml \
    src/Airmap/dummy/AirspaceWeather.qml \
    src/Airmap/dummy/ComplianceRules.qml \
    src/Airmap/dummy/FlightBrief.qml \
    src/Airmap/dummy/FlightDetails.qml \
    src/Airmap/dummy/FlightFeature.qml \
    src/Airmap/dummy/QGroundControl.Airmap.qmldir \
    src/Airmap/dummy/RuleSelector.qml \
    src/Airmap/images/advisory-icon.svg \
    src/Airmap/images/colapse.svg \
    src/Airmap/images/expand.svg \
    src/Airmap/images/pencil.svg \
    src/Airmap/images/right-arrow.svg \
    src/Airmap/images/unavailable.svg \
    src/Airmap/images/weather-icons/clear.svg \
    src/Airmap/images/weather-icons/cloudy.svg \
    src/Airmap/images/weather-icons/cloudy_wind.svg \
    src/Airmap/images/weather-icons/drizzle.svg \
    src/Airmap/images/weather-icons/drizzle_day.svg \
    src/Airmap/images/weather-icons/drizzle_night.svg \
    src/Airmap/images/weather-icons/foggy.svg \
    src/Airmap/images/weather-icons/frigid.svg \
    src/Airmap/images/weather-icons/hail.svg \
    src/Airmap/images/weather-icons/heavy_rain.svg \
    src/Airmap/images/weather-icons/hurricane.svg \
    src/Airmap/images/weather-icons/isolated_thunderstorms.svg \
    src/Airmap/images/weather-icons/mostly_clear.svg \
    src/Airmap/images/weather-icons/mostly_cloudy_day.svg \
    src/Airmap/images/weather-icons/mostly_cloudy_night.svg \
    src/Airmap/images/weather-icons/mostly_sunny.svg \
    src/Airmap/images/weather-icons/partly_cloudy_day.svg \
    src/Airmap/images/weather-icons/partly_cloudy_night.svg \
    src/Airmap/images/weather-icons/rain.svg \
    src/Airmap/images/weather-icons/rain_snow.svg \
    src/Airmap/images/weather-icons/scattered_snow_showers_day.svg \
    src/Airmap/images/weather-icons/scattered_snow_showers_night.svg \
    src/Airmap/images/weather-icons/scattered_thunderstorms_day.svg \
    src/Airmap/images/weather-icons/scattered_thunderstorms_night.svg \
    src/Airmap/images/weather-icons/snow.svg \
    src/Airmap/images/weather-icons/snow_storm.svg \
    src/Airmap/images/weather-icons/sunny.svg \
    src/Airmap/images/weather-icons/thunderstorm.svg \
    src/Airmap/images/weather-icons/tornado.svg \
    src/Airmap/images/weather-icons/unknown.svg \
    src/Airmap/images/weather-icons/windy.svg \
    src/AirspaceManagement/CMakeLists.txt \
    src/AnalyzeView/AnalyzePage.qml \
    src/AnalyzeView/AnalyzeView.qml \
    src/AnalyzeView/CMakeLists.txt \
    src/AnalyzeView/FloatingWindow.svg \
    src/AnalyzeView/GeoTagIcon.svg \
    src/AnalyzeView/GeoTagPage.qml \
    src/AnalyzeView/LogDownloadIcon.svg \
    src/AnalyzeView/LogDownloadPage.qml \
    src/AnalyzeView/MAVLinkInspector.svg \
    src/AnalyzeView/MAVLinkInspectorPage.qml \
    src/AnalyzeView/MavlinkConsoleIcon.svg \
    src/AnalyzeView/MavlinkConsolePage.qml \
    src/Audio/CMakeLists.txt \
    src/AutoPilotPlugins/APM/APMAirframeComponent.qml \
    src/AutoPilotPlugins/APM/APMAirframeComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMCameraComponent.qml \
    src/AutoPilotPlugins/APM/APMCameraComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMCameraSubComponent.qml \
    src/AutoPilotPlugins/APM/APMFlightModesComponent.qml \
    src/AutoPilotPlugins/APM/APMFlightModesComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMFollowComponent.FactMetaData.json \
    src/AutoPilotPlugins/APM/APMFollowComponent.qml \
    src/AutoPilotPlugins/APM/APMFollowComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMHeliComponent.qml \
    src/AutoPilotPlugins/APM/APMLightsComponent.qml \
    src/AutoPilotPlugins/APM/APMLightsComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMMotorComponent.qml \
    src/AutoPilotPlugins/APM/APMNotSupported.qml \
    src/AutoPilotPlugins/APM/APMPowerComponent.qml \
    src/AutoPilotPlugins/APM/APMPowerComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMRadioComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponent.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentCopter.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentPlane.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentRover.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentSub.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentSummaryCopter.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentSummaryPlane.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentSummaryRover.qml \
    src/AutoPilotPlugins/APM/APMSafetyComponentSummarySub.qml \
    src/AutoPilotPlugins/APM/APMSensorsComponent.qml \
    src/AutoPilotPlugins/APM/APMSensorsComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMSubFrameComponent.qml \
    src/AutoPilotPlugins/APM/APMSubFrameComponentSummary.qml \
    src/AutoPilotPlugins/APM/APMSubMotorComponent.qml \
    src/AutoPilotPlugins/APM/APMTuningComponentCopter.qml \
    src/AutoPilotPlugins/APM/APMTuningComponentSub.qml \
    src/AutoPilotPlugins/APM/CMakeLists.txt \
    src/AutoPilotPlugins/APM/Images/LightsComponentIcon.png \
    src/AutoPilotPlugins/APM/Images/SubFrameComponentIcon.png \
    src/AutoPilotPlugins/APM/Images/bluerov-frame.png \
    src/AutoPilotPlugins/APM/Images/simple3-frame.png \
    src/AutoPilotPlugins/APM/Images/simple4-frame.png \
    src/AutoPilotPlugins/APM/Images/simple5-frame.png \
    src/AutoPilotPlugins/APM/Images/vectored-frame.png \
    src/AutoPilotPlugins/APM/Images/vectored6dof-frame.png \
    src/AutoPilotPlugins/CMakeLists.txt \
    src/AutoPilotPlugins/Common/CMakeLists.txt \
    src/AutoPilotPlugins/Common/ESP8266Component.qml \
    src/AutoPilotPlugins/Common/ESP8266ComponentSummary.qml \
    src/AutoPilotPlugins/Common/Images/APMode.svg \
    src/AutoPilotPlugins/Common/Images/AirframeComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/AirframeSimulation.svg \
    src/AutoPilotPlugins/Common/Images/AirframeUnknown.svg \
    src/AutoPilotPlugins/Common/Images/ArrowCCW.svg \
    src/AutoPilotPlugins/Common/Images/ArrowCW.svg \
    src/AutoPilotPlugins/Common/Images/ArrowDirection.svg \
    src/AutoPilotPlugins/Common/Images/Autogyro.svg \
    src/AutoPilotPlugins/Common/Images/Boat.svg \
    src/AutoPilotPlugins/Common/Images/CameraComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/FlightModesComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/FlyingWing.svg \
    src/AutoPilotPlugins/Common/Images/Helicopter.svg \
    src/AutoPilotPlugins/Common/Images/HelicopterCoaxial.svg \
    src/AutoPilotPlugins/Common/Images/HexaRotorPlus.svg \
    src/AutoPilotPlugins/Common/Images/HexaRotorX.svg \
    src/AutoPilotPlugins/Common/Images/MotorComponentIcon.svg \
    src/AutoPilotPlugins/Common/Images/OctoRotorPlus.svg \
    src/AutoPilotPlugins/Common/Images/OctoRotorPlusCoaxial.svg \
    src/AutoPilotPlugins/Common/Images/OctoRotorX.svg \
    src/AutoPilotPlugins/Common/Images/OctoRotorXCoaxial.svg \
    src/AutoPilotPlugins/Common/Images/Plane.svg \
    src/AutoPilotPlugins/Common/Images/PlaneATail.svg \
    src/AutoPilotPlugins/Common/Images/PlaneVTail.svg \
    src/AutoPilotPlugins/Common/Images/PowerComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/QuadRotorATail.svg \
    src/AutoPilotPlugins/Common/Images/QuadRotorH.svg \
    src/AutoPilotPlugins/Common/Images/QuadRotorPlus.svg \
    src/AutoPilotPlugins/Common/Images/QuadRotorVTail.svg \
    src/AutoPilotPlugins/Common/Images/QuadRotorWide.svg \
    src/AutoPilotPlugins/Common/Images/QuadRotorX.svg \
    src/AutoPilotPlugins/Common/Images/RadioComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/Rover.svg \
    src/AutoPilotPlugins/Common/Images/SafetyComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/SensorsComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/StationMode.svg \
    src/AutoPilotPlugins/Common/Images/TuningComponentIcon.png \
    src/AutoPilotPlugins/Common/Images/VTOLDuoRotorTailSitter.svg \
    src/AutoPilotPlugins/Common/Images/VTOLPlane.svg \
    src/AutoPilotPlugins/Common/Images/VTOLPlaneOcto.svg \
    src/AutoPilotPlugins/Common/Images/VTOLQuadRotorTailSitter.svg \
    src/AutoPilotPlugins/Common/Images/VTOLTiltRotor.svg \
    src/AutoPilotPlugins/Common/Images/Y6A.svg \
    src/AutoPilotPlugins/Common/Images/Y6B.svg \
    src/AutoPilotPlugins/Common/Images/YMinus.svg \
    src/AutoPilotPlugins/Common/Images/YPlus.svg \
    src/AutoPilotPlugins/Common/Images/wifi.svg \
    src/AutoPilotPlugins/Common/MotorComponent.qml \
    src/AutoPilotPlugins/Common/RadioComponent.qml \
    src/AutoPilotPlugins/Common/SetupPage.qml \
    src/AutoPilotPlugins/Common/SyslinkComponent.qml \
    src/AutoPilotPlugins/PX4/AirframeComponent.qml \
    src/AutoPilotPlugins/PX4/AirframeComponentSummary.qml \
    src/AutoPilotPlugins/PX4/AirframeFactMetaData.xml \
    src/AutoPilotPlugins/PX4/CMakeLists.txt \
    src/AutoPilotPlugins/PX4/CameraComponent.qml \
    src/AutoPilotPlugins/PX4/CameraComponentSummary.qml \
    src/AutoPilotPlugins/PX4/FlightModesComponentSummary.qml \
    src/AutoPilotPlugins/PX4/Images/CameraTrigger.svg \
    src/AutoPilotPlugins/PX4/Images/DatalinkLoss.svg \
    src/AutoPilotPlugins/PX4/Images/DatalinkLossLight.svg \
    src/AutoPilotPlugins/PX4/Images/GeoFence.svg \
    src/AutoPilotPlugins/PX4/Images/GeoFenceLight.svg \
    src/AutoPilotPlugins/PX4/Images/HITL.svg \
    src/AutoPilotPlugins/PX4/Images/LandMode.svg \
    src/AutoPilotPlugins/PX4/Images/LandModeCopter.svg \
    src/AutoPilotPlugins/PX4/Images/LowBattery.svg \
    src/AutoPilotPlugins/PX4/Images/LowBatteryLight.svg \
    src/AutoPilotPlugins/PX4/Images/ObjectAvoidance.svg \
    src/AutoPilotPlugins/PX4/Images/PowerComponentBattery_01cell.svg \
    src/AutoPilotPlugins/PX4/Images/PowerComponentBattery_02cell.svg \
    src/AutoPilotPlugins/PX4/Images/PowerComponentBattery_03cell.svg \
    src/AutoPilotPlugins/PX4/Images/PowerComponentBattery_04cell.svg \
    src/AutoPilotPlugins/PX4/Images/PowerComponentBattery_05cell.svg \
    src/AutoPilotPlugins/PX4/Images/PowerComponentBattery_06cell.svg \
    src/AutoPilotPlugins/PX4/Images/RCLoss.svg \
    src/AutoPilotPlugins/PX4/Images/RCLossLight.svg \
    src/AutoPilotPlugins/PX4/Images/ReturnToHomeAltitude.svg \
    src/AutoPilotPlugins/PX4/Images/ReturnToHomeAltitudeCopter.svg \
    src/AutoPilotPlugins/PX4/Images/Rotate.png \
    src/AutoPilotPlugins/PX4/Images/RotateBack.png \
    src/AutoPilotPlugins/PX4/Images/RotateFront.png \
    src/AutoPilotPlugins/PX4/Images/VehicleDown.png \
    src/AutoPilotPlugins/PX4/Images/VehicleDownRotate.png \
    src/AutoPilotPlugins/PX4/Images/VehicleLeft.png \
    src/AutoPilotPlugins/PX4/Images/VehicleLeftRotate.png \
    src/AutoPilotPlugins/PX4/Images/VehicleNoseDown.png \
    src/AutoPilotPlugins/PX4/Images/VehicleNoseDownRotate.png \
    src/AutoPilotPlugins/PX4/Images/VehicleRight.png \
    src/AutoPilotPlugins/PX4/Images/VehicleRightRotate.png \
    src/AutoPilotPlugins/PX4/Images/VehicleTailDown.png \
    src/AutoPilotPlugins/PX4/Images/VehicleTailDownRotate.png \
    src/AutoPilotPlugins/PX4/Images/VehicleUpsideDown.png \
    src/AutoPilotPlugins/PX4/Images/VehicleUpsideDownRotate.png \
    src/AutoPilotPlugins/PX4/Images/no-logging-light.svg \
    src/AutoPilotPlugins/PX4/Images/no-logging.svg \
    src/AutoPilotPlugins/PX4/PX4AdvancedFlightModes.qml \
    src/AutoPilotPlugins/PX4/PX4FlightModes.qml \
    src/AutoPilotPlugins/PX4/PX4RadioComponentSummary.qml \
    src/AutoPilotPlugins/PX4/PX4SimpleFlightModes.qml \
    src/AutoPilotPlugins/PX4/PX4TuningComponentCopter.qml \
    src/AutoPilotPlugins/PX4/PX4TuningComponentPlane.qml \
    src/AutoPilotPlugins/PX4/PX4TuningComponentVTOL.qml \
    src/AutoPilotPlugins/PX4/PowerComponent.qml \
    src/AutoPilotPlugins/PX4/PowerComponentSummary.qml \
    src/AutoPilotPlugins/PX4/SafetyComponent.qml \
    src/AutoPilotPlugins/PX4/SafetyComponentSummary.qml \
    src/AutoPilotPlugins/PX4/SensorsComponent.qml \
    src/AutoPilotPlugins/PX4/SensorsComponentSummary.qml \
    src/AutoPilotPlugins/PX4/SensorsComponentSummaryFixedWing.qml \
    src/AutoPilotPlugins/PX4/SensorsSetup.qml \
    src/CMakeLists.txt \
    src/Camera/CMakeLists.txt \
    src/Camera/camera_definition_example.xml \
    src/Camera/images/camera_photo.svg \
    src/Camera/images/camera_video.svg \
    src/FactSystem/CMakeLists.txt \
    src/FactSystem/FactControls/AltitudeFactTextField.qml \
    src/FactSystem/FactControls/CMakeLists.txt \
    src/FactSystem/FactControls/FactBitmask.qml \
    src/FactSystem/FactControls/FactCheckBox.qml \
    src/FactSystem/FactControls/FactComboBox.qml \
    src/FactSystem/FactControls/FactLabel.qml \
    src/FactSystem/FactControls/FactTextField.qml \
    src/FactSystem/FactControls/FactTextFieldGrid.qml \
    src/FactSystem/FactControls/FactTextFieldRow.qml \
    src/FactSystem/FactControls/FactTextFieldSlider.qml \
    src/FactSystem/FactControls/FactValueSlider.qml \
    src/FactSystem/FactSystemTest.qml \
    src/FirmwarePlugin/APM/APMBrandImage.png \
    src/FirmwarePlugin/APM/APMBrandImageSub.png \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.3.5.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.3.6.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.3.7.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.4.0.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.3.10.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.3.8.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.3.9.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.4.0.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.3.4.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.3.5.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.3.6.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.4.0.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Sub.3.4.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Sub.3.5.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Sub.3.6.xml \
    src/FirmwarePlugin/APM/APMParameterFactMetaData.Sub.4.0.xml \
    src/FirmwarePlugin/APM/APMSensorParams.qml \
    src/FirmwarePlugin/APM/BuildParamMetaData.sh \
    src/FirmwarePlugin/APM/CMakeLists.txt \
    src/FirmwarePlugin/APM/Copter3.6.OfflineEditing.params \
    src/FirmwarePlugin/APM/MavCmdInfoCommon.json \
    src/FirmwarePlugin/APM/MavCmdInfoFixedWing.json \
    src/FirmwarePlugin/APM/MavCmdInfoMultiRotor.json \
    src/FirmwarePlugin/APM/MavCmdInfoRover.json \
    src/FirmwarePlugin/APM/MavCmdInfoSub.json \
    src/FirmwarePlugin/APM/MavCmdInfoVTOL.json \
    src/FirmwarePlugin/APM/Plane3.9.OfflineEditing.params \
    src/FirmwarePlugin/APM/QGroundControl.ArduPilot.qmldir \
    src/FirmwarePlugin/APM/Rover3.5.OfflineEditing.params \
    src/FirmwarePlugin/CMakeLists.txt \
    src/FirmwarePlugin/PX4/MavCmdInfoCommon.json \
    src/FirmwarePlugin/PX4/MavCmdInfoFixedWing.json \
    src/FirmwarePlugin/PX4/MavCmdInfoMultiRotor.json \
    src/FirmwarePlugin/PX4/MavCmdInfoRover.json \
    src/FirmwarePlugin/PX4/MavCmdInfoSub.json \
    src/FirmwarePlugin/PX4/MavCmdInfoVTOL.json \
    src/FirmwarePlugin/PX4/PX4BrandImage.png \
    src/FirmwarePlugin/PX4/PX4ParameterFactMetaData.xml \
    src/FirmwarePlugin/PX4/V1.4.OfflineEditing.params \
    src/FlightDisplay/CMakeLists.txt \
    src/FlightDisplay/DefaultChecklist.qml \
    src/FlightDisplay/FixedWingChecklist.qml \
    src/FlightDisplay/FlightDisplayView.qml \
    src/FlightDisplay/FlightDisplayViewDummy.qml \
    src/FlightDisplay/FlightDisplayViewMap.qml \
    src/FlightDisplay/FlightDisplayViewUVC.qml \
    src/FlightDisplay/FlightDisplayViewVideo.qml \
    src/FlightDisplay/FlightDisplayViewWidgets.qml \
    src/FlightDisplay/GuidedActionConfirm.qml \
    src/FlightDisplay/GuidedActionList.qml \
    src/FlightDisplay/GuidedActionsController.qml \
    src/FlightDisplay/GuidedAltitudeSlider.qml \
    src/FlightDisplay/MultiRotorChecklist.qml \
    src/FlightDisplay/MultiVehicleList.qml \
    src/FlightDisplay/PreFlightBatteryCheck.qml \
    src/FlightDisplay/PreFlightCheckList.qml \
    src/FlightDisplay/PreFlightGPSCheck.qml \
    src/FlightDisplay/PreFlightRCCheck.qml \
    src/FlightDisplay/PreFlightSensorsHealthCheck.qml \
    src/FlightDisplay/PreFlightSoundCheck.qml \
    src/FlightDisplay/RoverChecklist.qml \
    src/FlightDisplay/SubChecklist.qml \
    src/FlightDisplay/VTOLChecklist.qml \
    src/FlightDisplay/VirtualJoystick.qml \
    src/FlightMap/CMakeLists.txt \
    src/FlightMap/FlightMap.qml \
    src/FlightMap/Images/AlertAircraft.svg \
    src/FlightMap/Images/AwarenessAircraft.svg \
    src/FlightMap/Images/Help.svg \
    src/FlightMap/Images/HelpBlack.svg \
    src/FlightMap/Images/Home.svg \
    src/FlightMap/Images/MapAddMission.svg \
    src/FlightMap/Images/MapAddMissionBlack.svg \
    src/FlightMap/Images/MapCenter.svg \
    src/FlightMap/Images/MapCenterBlack.svg \
    src/FlightMap/Images/MapDrawShape.svg \
    src/FlightMap/Images/MapHome.svg \
    src/FlightMap/Images/MapHomeBlack.svg \
    src/FlightMap/Images/MapSync.svg \
    src/FlightMap/Images/MapSyncBlack.svg \
    src/FlightMap/Images/MapSyncChanged.svg \
    src/FlightMap/Images/MapType.svg \
    src/FlightMap/Images/MapTypeBlack.svg \
    src/FlightMap/Images/PiP.svg \
    src/FlightMap/Images/ZoomMinus.svg \
    src/FlightMap/Images/ZoomPlus.svg \
    src/FlightMap/Images/adsbVehicle.svg \
    src/FlightMap/Images/attitudeDial.svg \
    src/FlightMap/Images/attitudeInstrument.svg \
    src/FlightMap/Images/attitudePointer.svg \
    src/FlightMap/Images/cOGPointer.svg \
    src/FlightMap/Images/compassDottedLine.svg \
    src/FlightMap/Images/compassInstrumentArrow.svg \
    src/FlightMap/Images/compassInstrumentDial.svg \
    src/FlightMap/Images/crossHair.svg \
    src/FlightMap/Images/pipHide.svg \
    src/FlightMap/Images/pipResize.svg \
    src/FlightMap/Images/rollDialWhite.svg \
    src/FlightMap/Images/rollPointerWhite.svg \
    src/FlightMap/Images/scale.png \
    src/FlightMap/Images/scaleLight.png \
    src/FlightMap/Images/scale_end.png \
    src/FlightMap/Images/scale_endLight.png \
    src/FlightMap/Images/sub.png \
    src/FlightMap/Images/vehicleArrowOpaque.svg \
    src/FlightMap/Images/vehicleArrowOutline.svg \
    src/FlightMap/MapItems/CMakeLists.txt \
    src/FlightMap/MapItems/CameraTriggerIndicator.qml \
    src/FlightMap/MapItems/CustomMapItems.qml \
    src/FlightMap/MapItems/MissionItemIndicator.qml \
    src/FlightMap/MapItems/MissionItemIndicatorDrag.qml \
    src/FlightMap/MapItems/MissionItemView.qml \
    src/FlightMap/MapItems/MissionLineView.qml \
    src/FlightMap/MapItems/PlanMapItems.qml \
    src/FlightMap/MapItems/PolygonEditor.qml \
    src/FlightMap/MapItems/SplitIndicator.qml \
    src/FlightMap/MapItems/VehicleMapItem.qml \
    src/FlightMap/MapScale.qml \
    src/FlightMap/QGCVideoBackground.qml \
    src/FlightMap/Widgets/CMakeLists.txt \
    src/FlightMap/Widgets/CameraPageWidget.qml \
    src/FlightMap/Widgets/CenterMapDropButton.qml \
    src/FlightMap/Widgets/CenterMapDropPanel.qml \
    src/FlightMap/Widgets/CompassRing.qml \
    src/FlightMap/Widgets/HealthPageWidget.qml \
    src/FlightMap/Widgets/InstrumentSwipeView.qml \
    src/FlightMap/Widgets/MapFitFunctions.qml \
    src/FlightMap/Widgets/QGCArtificialHorizon.qml \
    src/FlightMap/Widgets/QGCAttitudeHUD.qml \
    src/FlightMap/Widgets/QGCAttitudeWidget.qml \
    src/FlightMap/Widgets/QGCCompassWidget.qml \
    src/FlightMap/Widgets/QGCInstrumentWidget.qml \
    src/FlightMap/Widgets/QGCInstrumentWidgetAlternate.qml \
    src/FlightMap/Widgets/QGCMapToolButton.qml \
    src/FlightMap/Widgets/QGCPitchIndicator.qml \
    src/FlightMap/Widgets/QGCWaypointEditor.qml \
    src/FlightMap/Widgets/ValuePageWidget.qml \
    src/FlightMap/Widgets/VibrationPageWidget.qml \
    src/FlightMap/Widgets/VideoPageWidget.qml \
    src/FollowMe/CMakeLists.txt \
    src/GPS/CMakeLists.txt \
    src/GPS/Drivers/LICENSE.md \
    src/GPS/Drivers/README.md \
    src/Geo/CMakeLists.txt \
    src/Joystick/CMakeLists.txt \
    src/Microhard/MicrohardSettings.qml \
    src/MissionManager/BlankPlanCreator.png \
    src/MissionManager/BreachReturn.FactMetaData.json \
    src/MissionManager/CMakeLists.txt \
    src/MissionManager/CameraCalc.FactMetaData.json \
    src/MissionManager/CameraSection.FactMetaData.json \
    src/MissionManager/CameraSpec.FactMetaData.json \
    src/MissionManager/CogWheel.svg \
    src/MissionManager/CorridorScan.SettingsGroup.json \
    src/MissionManager/CorridorScanPlanCreator.png \
    src/MissionManager/FWLandingPattern.FactMetaData.json \
    src/MissionManager/MapLineArrow.qml \
    src/MissionManager/MavCmdInfoCommon.json \
    src/MissionManager/MavCmdInfoFixedWing.json \
    src/MissionManager/MavCmdInfoMultiRotor.json \
    src/MissionManager/MavCmdInfoRover.json \
    src/MissionManager/MavCmdInfoSub.json \
    src/MissionManager/MavCmdInfoVTOL.json \
    src/MissionManager/MissionSettings.FactMetaData.json \
    src/MissionManager/QGCMapCircle.Facts.json \
    src/MissionManager/QGCMapCircleVisuals.qml \
    src/MissionManager/QGCMapPolygonVisuals.qml \
    src/MissionManager/QGCMapPolylineVisuals.qml \
    src/MissionManager/RallyPoint.FactMetaData.json \
    src/MissionManager/SpeedSection.FactMetaData.json \
    src/MissionManager/StructureScan.SettingsGroup.json \
    src/MissionManager/StructureScanPlanCreator.png \
    src/MissionManager/Survey.SettingsGroup.json \
    src/MissionManager/SurveyPlanCreator.png \
    src/MissionManager/TransectStyle.SettingsGroup.json \
    src/MissionManager/UnitTest/MavCmdInfoCommon.json \
    src/MissionManager/UnitTest/MavCmdInfoFixedWing.json \
    src/MissionManager/UnitTest/MavCmdInfoMultiRotor.json \
    src/MissionManager/UnitTest/MavCmdInfoRover.json \
    src/MissionManager/UnitTest/MavCmdInfoSub.json \
    src/MissionManager/UnitTest/MavCmdInfoVTOL.json \
    src/MissionManager/UnitTest/MissionPlanner.waypoints \
    src/MissionManager/UnitTest/OldFileFormat.mission \
    src/MissionManager/UnitTest/PolygonAreaTest.kml \
    src/MissionManager/UnitTest/PolygonBadCoordinatesNode.kml \
    src/MissionManager/UnitTest/PolygonBadXml.kml \
    src/MissionManager/UnitTest/PolygonGood.kml \
    src/MissionManager/UnitTest/PolygonMissingNode.kml \
    src/MissionManager/UnitTest/SectionTest.plan \
    src/PlanView/CMakeLists.txt \
    src/PlanView/CameraCalcCamera.qml \
    src/PlanView/CameraCalcGrid.qml \
    src/PlanView/CameraSection.qml \
    src/PlanView/CorridorScanEditor.qml \
    src/PlanView/CorridorScanMapVisual.qml \
    src/PlanView/FWLandingPatternEditor.qml \
    src/PlanView/FWLandingPatternMapVisual.qml \
    src/PlanView/GeoFenceEditor.qml \
    src/PlanView/GeoFenceMapVisuals.qml \
    src/PlanView/MissionItemEditor.qml \
    src/PlanView/MissionItemMapVisual.qml \
    src/PlanView/MissionItemStatus.qml \
    src/PlanView/MissionSettingsEditor.qml \
    src/PlanView/PlanEditToolbar.qml \
    src/PlanView/PlanToolBar.qml \
    src/PlanView/PlanToolBarIndicators.qml \
    src/PlanView/PlanView.qml \
    src/PlanView/RallyPointEditorHeader.qml \
    src/PlanView/RallyPointItemEditor.qml \
    src/PlanView/RallyPointMapVisuals.qml \
    src/PlanView/SimpleItemEditor.qml \
    src/PlanView/SimpleItemMapVisual.qml \
    src/PlanView/StructureScanEditor.qml \
    src/PlanView/StructureScanMapVisual.qml \
    src/PlanView/SurveyItemEditor.qml \
    src/PlanView/SurveyMapVisual.qml \
    src/PlanView/TakeoffItemMapVisual.qml \
    src/PlanView/TransectStyleComplexItemStats.qml \
    src/PlanView/TransectStyleMapVisuals.qml \
    src/PositionManager/CMakeLists.txt \
    src/QmlControls/APMSubMotorDisplay.qml \
    src/QmlControls/AppMessages.qml \
    src/QmlControls/AxisMonitor.qml \
    src/QmlControls/CMakeLists.txt \
    src/QmlControls/ClickableColor.qml \
    src/QmlControls/DeadMouseArea.qml \
    src/QmlControls/DropButton.qml \
    src/QmlControls/DropPanel.qml \
    src/QmlControls/EditPositionDialog.FactMetaData.json \
    src/QmlControls/EditPositionDialog.qml \
    src/QmlControls/ExclusiveGroupItem.qml \
    src/QmlControls/FactSliderPanel.qml \
    src/QmlControls/FileButton.qml \
    src/QmlControls/FlightModeDropdown.qml \
    src/QmlControls/FlightModeMenu.qml \
    src/QmlControls/HackAndroidFileDialog.qml \
    src/QmlControls/HackFileDialog.qml \
    src/QmlControls/HeightIndicator.qml \
    src/QmlControls/IndicatorButton.qml \
    src/QmlControls/JoystickThumbPad.qml \
    src/QmlControls/KMLOrSHPFileDialog.qml \
    src/QmlControls/LogReplayStatusBar.qml \
    src/QmlControls/MAVLinkChart.qml \
    src/QmlControls/MAVLinkMessageButton.qml \
    src/QmlControls/MainWindowSavedState.qml \
    src/QmlControls/MissionCommandDialog.qml \
    src/QmlControls/MissionItemIndexLabel.qml \
    src/QmlControls/ModeSwitchDisplay.qml \
    src/QmlControls/MultiRotorMotorDisplay.qml \
    src/QmlControls/OfflineMapButton.qml \
    src/QmlControls/PIDTuning.qml \
    src/QmlControls/PageView.qml \
    src/QmlControls/ParameterEditor.qml \
    src/QmlControls/ParameterEditorDialog.qml \
    src/QmlControls/PreFlightCheckButton.qml \
    src/QmlControls/PreFlightCheckGroup.qml \
    src/QmlControls/PreFlightCheckList.qml \
    src/QmlControls/PreFlightCheckModel.qml \
    src/QmlControls/QGCButton.qml \
    src/QmlControls/QGCCheckBox.qml \
    src/QmlControls/QGCColoredImage.qml \
    src/QmlControls/QGCComboBox.qml \
    src/QmlControls/QGCDynamicObjectManager.qml \
    src/QmlControls/QGCFileDialog.qml \
    src/QmlControls/QGCFlickable.qml \
    src/QmlControls/QGCFlickableHorizontalIndicator.qml \
    src/QmlControls/QGCFlickableVerticalIndicator.qml \
    src/QmlControls/QGCGroupBox.qml \
    src/QmlControls/QGCHoverButton.qml \
    src/QmlControls/QGCLabel.qml \
    src/QmlControls/QGCListView.qml \
    src/QmlControls/QGCMapLabel.qml \
    src/QmlControls/QGCMenu.qml \
    src/QmlControls/QGCMenuItem.qml \
    src/QmlControls/QGCMenuSeparator.qml \
    src/QmlControls/QGCMouseArea.qml \
    src/QmlControls/QGCMovableItem.qml \
    src/QmlControls/QGCOptionsComboBox.qml \
    src/QmlControls/QGCPipable.qml \
    src/QmlControls/QGCRadioButton.qml \
    src/QmlControls/QGCSlider.qml \
    src/QmlControls/QGCSwitch.qml \
    src/QmlControls/QGCTabBar.qml \
    src/QmlControls/QGCTabButton.qml \
    src/QmlControls/QGCTextField.qml \
    src/QmlControls/QGCToolBarButton.qml \
    src/QmlControls/QGCViewDialog.qml \
    src/QmlControls/QGCViewDialogContainer.qml \
    src/QmlControls/QGCViewMessage.qml \
    src/QmlControls/QGroundControl/Airmap/qmldir \
    src/QmlControls/QGroundControl/Controls/qmldir \
    src/QmlControls/QGroundControl/FactControls/qmldir \
    src/QmlControls/QGroundControl/FactSystem/qmldir \
    src/QmlControls/QGroundControl/FlightDisplay/qmldir \
    src/QmlControls/QGroundControl/FlightMap/qmldir \
    src/QmlControls/QGroundControl/PX4/qmldir \
    src/QmlControls/QGroundControl/ScreenTools/qmldir \
    src/QmlControls/QGroundControl/Vehicle/qmldir \
    src/QmlControls/QmlTest.qml \
    src/QmlControls/RCChannelMonitor.qml \
    src/QmlControls/RoundButton.qml \
    src/QmlControls/ScreenTools.qml \
    src/QmlControls/SectionHeader.qml \
    src/QmlControls/SliderSwitch.qml \
    src/QmlControls/SubMenuButton.qml \
    src/QmlControls/ToolStrip.qml \
    src/QmlControls/VehicleRotationCal.qml \
    src/QmlControls/VehicleSummaryRow.qml \
    src/QmlControls/arrow-down.png \
    src/QmlControls/checkbox-check.svg \
    src/QtLocationPlugin/CMakeLists.txt \
    src/QtLocationPlugin/QMLControl/OfflineMap.qml \
    src/QtLocationPlugin/qtlocation/README.md \
    src/QtLocationPlugin/qtlocation/src/location/maps/maps.pri \
    src/Settings/ADSBVehicleManager.SettingsGroup.json \
    src/Settings/APMMavlinkStreamRate.SettingsGroup.json \
    src/Settings/App.SettingsGroup.json \
    src/Settings/AutoConnect.SettingsGroup.json \
    src/Settings/BrandImage.SettingsGroup.json \
    src/Settings/CMakeLists.txt \
    src/Settings/FirmwareUpgrade.SettingsGroup.json \
    src/Settings/FlightMap.SettingsGroup.json \
    src/Settings/FlyView.SettingsGroup.json \
    src/Settings/OfflineMaps.SettingsGroup.json \
    src/Settings/PlanView.SettingsGroup.json \
    src/Settings/RTK.SettingsGroup.json \
    src/Settings/Units.SettingsGroup.json \
    src/Settings/Video.SettingsGroup.json \
    src/Taisync/TaisyncSettings.qml \
    src/Terrain/CMakeLists.txt \
    src/Vehicle/BatteryFact.json \
    src/Vehicle/CMakeLists.txt \
    src/Vehicle/ClockFact.json \
    src/Vehicle/DistanceSensorFact.json \
    src/Vehicle/EstimatorStatusFactGroup.json \
    src/Vehicle/FlowRateFact.json \
    src/Vehicle/FlowRateMeterFact.json \
    src/Vehicle/GPSFact.json \
    src/Vehicle/GPSRTKFact.json \
    src/Vehicle/SetpointFact.json \
    src/Vehicle/SubmarineFact.json \
    src/Vehicle/TemperatureFact.json \
    src/Vehicle/VehicleFact.json \
    src/Vehicle/VibrationFact.json \
    src/Vehicle/WindFact.json \
    src/VehicleSetup/CMakeLists.txt \
    src/VehicleSetup/FirmwareUpgrade.qml \
    src/VehicleSetup/FirmwareUpgradeIcon.png \
    src/VehicleSetup/JoystickConfig.qml \
    src/VehicleSetup/JoystickConfigAdvanced.qml \
    src/VehicleSetup/JoystickConfigButtons.qml \
    src/VehicleSetup/JoystickConfigCalibration.qml \
    src/VehicleSetup/JoystickConfigGeneral.qml \
    src/VehicleSetup/PX4FlowSensor.qml \
    src/VehicleSetup/SetupParameterEditor.qml \
    src/VehicleSetup/SetupView.qml \
    src/VehicleSetup/VehicleSummary.qml \
    src/VehicleSetup/VehicleSummaryIcon.png \
    src/VideoStreaming/CMakeLists.txt \
    src/VideoStreaming/README.md \
    src/VideoStreaming/iOS/gst_ios_init.m \
    src/ViewWidgets/CMakeLists.txt \
    src/ViewWidgets/CustomCommandWidget.qml \
    src/ViewWidgets/ViewWidget.qml \
    src/api/CMakeLists.txt \
    src/comm/APMArduSubMockLink.params \
    src/comm/CMakeLists.txt \
    src/comm/PX4MockLink.params \
    src/comm/USBBoardInfo.json \
    src/documentation.dox \
    src/qgcunittest/CMakeLists.txt \
    src/test.qml \
    src/uas/CMakeLists.txt \
    src/ui/AppSettings.qml \
    src/ui/CMakeLists.txt \
    src/ui/ExitWithErrorWindow.qml \
    src/ui/MainRootWindow.qml \
    src/ui/preferences/BluetoothSettings.qml \
    src/ui/preferences/CMakeLists.txt \
    src/ui/preferences/DebugWindow.qml \
    src/ui/preferences/GeneralSettings.qml \
    src/ui/preferences/HelpSettings.qml \
    src/ui/preferences/LinkSettings.qml \
    src/ui/preferences/LogReplaySettings.qml \
    src/ui/preferences/MavlinkSettings.qml \
    src/ui/preferences/MockLink.qml \
    src/ui/preferences/MockLinkSettings.qml \
    src/ui/preferences/SerialSettings.qml \
    src/ui/preferences/TcpSettings.qml \
    src/ui/preferences/UdpSettings.qml \
    src/ui/toolbar/ArmedIndicator.qml \
    src/ui/toolbar/BatteryIndicator.qml \
    src/ui/toolbar/CMakeLists.txt \
    src/ui/toolbar/GPSIndicator.qml \
    src/ui/toolbar/GPSRTKIndicator.qml \
    src/ui/toolbar/Images/AirplaneIcon.svg \
    src/ui/toolbar/Images/Analyze.svg \
    src/ui/toolbar/Images/Armed.svg \
    src/ui/toolbar/Images/Battery.svg \
    src/ui/toolbar/Images/CameraIcon.svg \
    src/ui/toolbar/Images/Connect.svg \
    src/ui/toolbar/Images/Disarmed.svg \
    src/ui/toolbar/Images/Disconnect.svg \
    src/ui/toolbar/Images/Gears.svg \
    src/ui/toolbar/Images/Gps.svg \
    src/ui/toolbar/Images/Hamburger.svg \
    src/ui/toolbar/Images/Joystick.png \
    src/ui/toolbar/Images/Megaphone.svg \
    src/ui/toolbar/Images/PaperPlane.svg \
    src/ui/toolbar/Images/Plan.svg \
    src/ui/toolbar/Images/Quad.svg \
    src/ui/toolbar/Images/RC.svg \
    src/ui/toolbar/Images/RTK.svg \
    src/ui/toolbar/Images/Signal0.svg \
    src/ui/toolbar/Images/Signal100.svg \
    src/ui/toolbar/Images/Signal20.svg \
    src/ui/toolbar/Images/Signal40.svg \
    src/ui/toolbar/Images/Signal60.svg \
    src/ui/toolbar/Images/Signal80.svg \
    src/ui/toolbar/Images/TelemRSSI.svg \
    src/ui/toolbar/Images/Yield.svg \
    src/ui/toolbar/Images/roi.svg \
    src/ui/toolbar/JoystickIndicator.qml \
    src/ui/toolbar/LinkIndicator.qml \
    src/ui/toolbar/MainToolBar.qml \
    src/ui/toolbar/MainToolBarIndicators.qml \
    src/ui/toolbar/MessageIndicator.qml \
    src/ui/toolbar/ModeIndicator.qml \
    src/ui/toolbar/MultiVehicleSelector.qml \
    src/ui/toolbar/RCRSSIIndicator.qml \
    src/ui/toolbar/ROIIndicator.qml \
    src/ui/toolbar/SignalStrength.qml \
    src/ui/toolbar/TelemetryRSSIIndicator.qml \
    src/ui/toolbar/VTOLModeIndicator.qml

RESOURCES += \
    src/Airmap/airmap.qrc \
    src/Airmap/dummy/airmap_dummy.qrc \
    src/FirmwarePlugin/APM/APMResources.qrc \
    src/FirmwarePlugin/PX4/PX4Resources.qrc \
    src/qml.qrc

FORMS += \
    src/ui/QGCMapRCToParamDialog.ui \
    src/ui/QGCPluginHost.ui \
    src/ui/QMap3D.ui
