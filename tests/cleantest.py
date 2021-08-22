import os,glob,re


def clean(stem):
	r1 = re.compile(r"^%s_([0-9]{2}[a-z]{3}|functions|includes|model|records|literals)\.[och]$" % re.escape(stem))
	for i in os.listdir('.'):
		if r1.match(i):
			os.unlink(i)
	os.unlink(stem)
	os.unlink(stem+'.c')
	os.unlink(stem+'.o')
	os.unlink(stem+'.makefile')
	os.unlink(stem+'_init.xml')
	os.unlink(stem+'_info.json')
	os.unlink(stem+'_res.mat')

# vim: ts=4:sw=4:noet:tw=80
