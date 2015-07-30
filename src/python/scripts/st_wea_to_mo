#! /bin/env python

import argparse
import os

def load_file(fn):
	print(fn)
	return 0

def save_file(dat, fn):
	print(fn)

if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('file')
	args = parser.parse_args()

	fn = args.file
	dat = load_file(fn)
	save_file(dat, os.path.splitext(fn)[0] + '.mo')
