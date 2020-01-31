import CoolProp
from CoolProp.CoolProp import PropsSI

def testExternalPy_multiply(a,b):
	""" Returns a multiplied by b """
	c = PropsSI("T","P",a,"H",b,"R744")
	return c

print testExternalPy_multiply(101325,505000)
