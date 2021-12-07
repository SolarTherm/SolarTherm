import os
import time
import numpy as np
import argparse

def convert_list(alist, delimiter=','):
	c=[]
	tmp=''
	for l in alist:
		if l==delimiter:
			c.append(tmp)
			tmp=''
		else:
			tmp+=l
	return c

if __name__=='__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--casedir', type=str)
	parser.add_argument('--num_args', type=int, default=0, 
			help="number of float arguments")
	parser.add_argument('--var_names', type=list)
	parser.add_argument('--var_vals', type=list)

	args = parser.parse_args()
	args.var_names=convert_list(args.var_names)
	args.var_vals=convert_list(args.var_vals)
	inputs=vars(args)

	for i in range(args.num_args):
		i=int(i)
		n=args.var_names[i]
		v=float(args.var_vals[i])
		inputs[n]=v

	print inputs
	del inputs['num_args']
	del inputs['var_names']
	del inputs['var_vals']

	filename = '/mnt/fb7cc2c9-e328-4f3f-a6f8-918195722408/MDBA-Aiming-Strategy/example/case_H230_Sodium_290_565/flux-table.csv'
	flux = np.loadtxt(filename, skiprows=7, delimiter=',', usecols=np.arange(1,17))[::-1]
	flux = np.flip(flux,axis=0)
	fp = np.concatenate((np.flip(flux[:,8],axis=0), flux[:,0]))

