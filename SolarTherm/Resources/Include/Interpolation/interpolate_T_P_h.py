import numpy as np
from scipy.interpolate import RectBivariateSpline
#x = pressure , y=enthalpy (expected x and y and value shape to be [168,350]
def interpolate(enthalpy,pressure):
	rawdata = np.genfromtxt('/home/philgun/Desktop/sCO2Prop/Props_from_P_H.txt',delimiter=',')
	X=rawdata[1,1:]
	Y=rawdata[2:170,0]
	x,y = np.meshgrid(X,Y)
	value = rawdata[2:170,1:]
	f=RectBivariateSpline(Y,X,value)
	predictedvalue = f(enthalpy,pressure)
	print("Temperature = %s degC"%(predictedvalue[0,0]))
	print("Property is sucessfully interpolated")
	return predictedvalue[0,0]

