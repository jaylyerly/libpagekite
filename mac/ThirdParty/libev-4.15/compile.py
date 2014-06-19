#!/usr/bin/env python

import os
import sys
import subprocess

all_libs = {
    'ios': [
        { "ARCH":"armv7", "SDK":"iphoneos", "MIN_IOS_VER":"-miphoneos-version-min=7.0", "HOST":"--host=armv7-apple-darwin7" },
        { "ARCH":"armv7s", "SDK":"iphoneos", "MIN_IOS_VER":"-miphoneos-version-min=7.0", "HOST":"--host=armv7-apple-darwin7" },
        { "ARCH":"arm64", "SDK":"iphoneos", "MIN_IOS_VER":"-miphoneos-version-min=7.0", "HOST":"--host=armv7-apple-darwin7" },
        { "ARCH":"i386", "SDK":"iphonesimulator", "MIN_IOS_VER":"-miphoneos-version-min=7.0", "HOST":"--host=armv7-apple-darwin7" },
        { "ARCH":"x86_64", "SDK":"iphonesimulator", "MIN_IOS_VER":"-miphoneos-version-min=7.0", "HOST":"--host=armv7-apple-darwin7" },
        
    ],
    'osx': [
        { "ARCH":"i386", "SDK":"macosx", "MIN_IOS_VER":"", "HOST":"" },
        { "ARCH":"x86_64", "SDK":"macosx", "MIN_IOS_VER":"", "HOST":"" },

    ]
}

def main(argv = sys.argv):
    # run with no arguments, build everything
    # other wise, just build the specified platform / arch to make the Makefile work

    if len(argv) == 2:
        argPlat = argv[1]
        libs = { argPlat : all_libs[argPlat] }
    else:
        libs = all_libs
        
    for plat in libs:
        archlist = libs[plat]
        files = {}
        for a in archlist:
            print "%s-%s" % (a['ARCH'], a['SDK'])
        
            env = os.environ.copy()
        
            env.update(a)
            env['PLAT'] = plat
            env ['SDKDIR'] = subprocess.check_output("xcrun --sdk $SDK --show-sdk-path", shell=True, env=env).strip()
            #print env
            #sys.exit()
            #SDKDIR=`xcrun --sdk $SDK --show-sdk-path`  
            #/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk

            env['CC']       = "xcrun --sdk %(SDK)s gcc" % env
            env['CFLAGS']   = "-arch %(ARCH)s -isysroot %(SDKDIR)s %(MIN_IOS_VER)s -w" % env
            env['CXX']      = "xcrun --sdk %(SDK)s llvm-g++-4.2" %env 
            env['CXXFLAGS'] = "-arch %(ARCH)s -isysroot %(SDKDIR)s %(MIN_IOS_VER)s -w" % env
            env['CPP']      = "xcrun --sdk %(SDK)s llvm-cpp-4.2" % env
            env['AR']       = "xcrun --sdk %(SDK)s ar" % env
            env['NM']       = "xcrun --sdk %(SDK)s nm" % env

            status = subprocess.call("./configure %(HOST)s" % env, shell=True, env=env)
            status = subprocess.call("make clean", shell=True, env=env)
            status = subprocess.call("make", shell=True, env=env)
            filename = "libev-%(PLAT)s.a.%(ARCH)s" % env
            files[a['ARCH']] = filename
            status = subprocess.call("cp .libs/libev.a %s" % filename , shell=True, env=env)
    
        #lipo -arch i386 foo-osx.a.i386 -arch x86_64 foo-osx.a.x86_64 -create -output foo-osx.a    
        cmd = "lipo"
        for arch in files:
            cmd +=" -arch %s %s " % ( arch, files[arch] )
        cmd += " -create "
        cmd += " -output libev-%s.a" % plat
        status = subprocess.call(cmd, shell=True, env=env)
        
        cmd = "rm"
        for arch in files:
            cmd +=" %s" % files[arch]
        status = subprocess.call(cmd, shell=True, env=env)


if __name__ == '__main__':
    main()