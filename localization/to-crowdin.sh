#!/bin/bash
# This is set to find lupdate in my particular installation. You will need to set the path
# where you have Qt installed.
QT_PATH=D:/QT5.12.6/5.12.6/msvc2017_64/bin
$QT_PATH/lupdate ../src -ts qgc.ts
