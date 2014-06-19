#!/bin/sh

# This runs the pagekitec binary with arguments
# to forward port 80 from your $PAGEKITE to 
# port 80 on the local machine
#
# $PAGEKITE and $PAGEKITESECRET are environment
# variables.  You might set these in your .bashrc
# like this:
#
# export PAGEKITESECRET=0123456789abcdef0123456789abcdef
# export PAGEKITE=kitename.pagekite.me 
#
# or you can specifiy them on the command line like:
#
# env PAGEKITESECRET=0123456789abcdef0123456789abcdef \
#     PAGEKITE=kitename.pagekite.me test_pagekitec_port_80.sh
#
# Both of these values can be found on your PageKite
# 'My Account' page at https://pagekite.net/home/
#

./pagekitec $* 5900 raw $PAGEKITE 5900 $PAGEKITESECRET 
