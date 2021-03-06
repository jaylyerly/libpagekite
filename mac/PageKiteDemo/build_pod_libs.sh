#!/bin/sh

set -x

mkdir -p ios/Frameworks
mkdir -p osx/Frameworks

CONFIGURATION=Release
WORKSPACE=PageKiteDemo.xcworkspace

pod install

echo CLEANING
xcodebuild -workspace $WORKSPACE -scheme libev -configuration $CONFIGURATION clean
xcodebuild -workspace $WORKSPACE -scheme PageKiteKit -configuration $CONFIGURATION clean
xcodebuild -workspace $WORKSPACE -scheme PageKiteKitIOS -configuration $CONFIGURATION clean

echo BUILDING LIBEV
env
pushd ../ThirdParty/libev-4.15
make -f Makefile.pagekite dist_clean
make -f Makefile.pagekite 
popd

echo LIBEV STATUS
ls -la ../ThirdParty/libev-4.15/lib*

echo BUILDING MAC PAGEKITEKIT

MAC_PRODUCTS_DIR=`xcodebuild -workspace $WORKSPACE -scheme PageKiteKit -configuration $CONFIGURATION -showBuildSettings|grep ' BUILT_PRODUCTS_DIR ='|head -1|awk -F= '{print $2}'|tr -d ' '`
xcodebuild -workspace $WORKSPACE -scheme PageKiteKit -configuration $CONFIGURATION 
cp -a $MAC_PRODUCTS_DIR/PageKiteKit.framework osx/Frameworks

echo LIBEV STATUS 2
ls -la ../ThirdParty/libev-4.15/lib*

# stub out the framework for iOS
cp -a $MAC_PRODUCTS_DIR/PageKiteKit.framework ios/Frameworks
rm ios/Frameworks/PageKiteKit.framework/Versions/Current/PageKiteKit

echo BUILDING IOS PAGEKITEKIT

IOS_PRODUCTS_DIR=`xcodebuild -workspace $WORKSPACE -scheme PageKiteKitIOS -configuration $CONFIGURATION -showBuildSettings|grep ' BUILT_PRODUCTS_DIR ='|head -1|awk -F= '{print $2}'|tr -d ' '`
xcodebuild -workspace $WORKSPACE -scheme PageKiteKitIOS -configuration $CONFIGURATION 
cp $IOS_PRODUCTS_DIR/libPageKiteKitIOS.a ios/Frameworks/PageKiteKit.framework/Versions/Current/PageKiteKit

echo LIBEV STATUS 3
ls -la ../ThirdParty/libev-4.15/lib*
