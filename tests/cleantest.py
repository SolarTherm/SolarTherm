import os, glob, re, platform
from pathlib import Path

def rm_if(fn):
	Path(fn).unlink(missing_ok=True)

def clean(stem):
	r1 = re.compile(r"^%s_([0-9]{2}[a-z]{3}|functions|includes|model|records|literals)\.[och]$" % re.escape(stem))
	for i in os.listdir('.'):
		if r1.match(i):
			os.unlink(i)
	if platform.system()=="Windows":
		rm_if(stem + '.exe')
	else:
		rm_if(stem)
	rm_if(stem+'.c')
	rm_if(stem+'.o')
	rm_if(stem+'.makefile')
	rm_if(stem+'_init.xml')
	rm_if(stem+'_info.json')
	rm_if(stem+'_res.mat')

# vim: ts=4:sw=4:noet:tw=80
