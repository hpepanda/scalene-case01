#!/bin/bash

SRC_PATH=$1
TARGET_PATH=$2

###Compile src files
mvn -f $SRC_PATH/pom.xml package

###Move to target folder
mkdir -p $TARGET_PATH
mv -fu $SRC_PATH/target/expenses.war $TARGET_PATH