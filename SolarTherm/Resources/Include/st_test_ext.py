#! /bin/env python2.7

import sys
print "PATH =",sys.path

import CoolProp
from CoolProp.CoolProp import PropsSI

#def testExternalPy_multiply(a,b):
#	""" Returns a multiplied by b """
#	c = a * b
#	return c

def testExternalPy_multiply(a,b):
	""" Returns a multiplied by b """
	print "hello from python :-P"
	c = PropsSI("T","P",a,"H",b,"R744")
	return c
