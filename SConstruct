import sys; from pathlib import Path
default_prefix=Path.home()/'.local'
default_pyversion = "%d.%d" % (sys.version_info[0],sys.version_info[1])

vars = Variables()
vars.AddVariables(
	PathVariable('PREFIX','File installation prefix',default_prefix)
	,PathVariable(
		'INSTALL_OMLIBRARY'
		,'Installation path for Modelica code'
		,'$PREFIX/lib/omlibrary',PathVariable.PathIsDirCreate)
	,PathVariable(
		'INSTALL_OM_ST'
		,'Installation path for Modelica SolarTherm library'
		,'$INSTALL_OMLIBRARY/SolarTherm', PathVariable.PathIsDirCreate)
	,PathVariable(
		'INSTALL_OM_EXT'
		,'Installation path for Modelica external functions'
		,'$INSTALL_OM_ST/Resources/Library', PathVariable.PathIsDirCreate)
	,PathVariable(
		'INSTALL_BIN'
		,"Installation path for the 'st' script"
		,'$PREFIX/bin')
	,('PYVERSION','Version of Python to use',default_pyversion)
	,('PYTHON','Python executable','python%s'%(sys.version_info[0]))
	,('PYTHON_SHEBANG','Python as named in the `st` shebang',"/usr/bin/env $PYTHON")
)

env = Environment(variables=vars)

env['VERSION'] = '0.2'
env['SUBST_DICT'] = {
	'@VERSION@' : '$VERSION'
	,'@PYTHON@' : '$PYTHON'
	,'@PREFIX@' : '$PREFIX'
	,'@PYTHON_SHEBANG@' : '$PYTHON_SHEBANG'
}

# TODO use 'SConscript(...variant_dir...)
env.SConscript(
	['src/SConscript','tests/SConscript','resources/SConscript']
	, exports='env'
)

#-------------------------------------------------------------------------------
# Install (nearly) all files in 'SolarTherm' folder
import re, os, sys

stfiles = []
fre = re.compile(r'^(.*)\.(mo|motab|csv|CSV|txt|order)$')
#print("test.mo:",fre.match('test.mo'))
#sys.exit(1)
def fmatch(root,fns):
	for f in fns:
		if fre.match(f):
			yield str(Path(root)/f)
for root, dirs, fns in os.walk('SolarTherm'):
	r1 = Path(root).relative_to('SolarTherm')
	env.Install('$INSTALL_OM_ST/%s'%(r1,),list(fmatch(root,fns)))

env.Alias('install',['#','$PREFIX'])

#env.SConscript('examples')
#env.SConscript('resources')

# TODO install SolarTherm directory

# vim: ts=4:noet:sw=4:tw=80

