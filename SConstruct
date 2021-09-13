import os, sys, platform, subprocess; from pathlib import Path
default_prefix=Path.home()/'.local'
default_pyversion = "%d.%d" % (sys.version_info[0],sys.version_info[1])

print('system',platform.system())
if platform.system()=="Windows" or "MINGW" in platform.system():
	if os.environ.get('MSYSTEM') == "MINGW64":
		#default_prefix = subprocess.check_output(['cygpath','-w',Path(os.environ['HOME'])/".local"],encoding='utf-8').strip()
		default_prefix=Path(os.environ['HOME'])/'.local'
		default_om_prefix = default_prefix
		print("OM_PREFIX =",default_om_prefix)
		default_om_libpath = '$OM_PREFIX/lib/omc'
		default_om_libs = ['SimulationRuntimeC','omcgc']
		default_install_omlibrary = '$PREFIX/lib/omlibrary'
	else:
		raise RuntimeError("On Windows, you must use MSYS2 in 64-bit mode.")
else:
	default_om_prefix = "/usr"
	default_om_libpath = None
	default_om_libs = []
	default_install_omlibrary = Path(os.environ['HOME'])/'.openmodelica'/'libraries'#'$PREFIX/lib/omlibrary'

vars = Variables()
vars.AddVariables(
	PathVariable('PREFIX'
		,'File installation prefix'
		,default_prefix
		,PathVariable.PathIsDirCreate)
	,PathVariable(
		'INSTALL_OMLIBRARY'
		,'Installation path for Modelica code'
		,default_install_omlibrary,PathVariable.PathIsDirCreate)
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
		,'$PREFIX/bin', PathVariable.PathIsDirCreate)
	,('PYVERSION','Version of Python to use',default_pyversion)
	,('PYTHON','Python executable','python%s'%(sys.version_info[0]))
	,('PYTHON_SHEBANG','Python as named in the `st` shebang',"/usr/bin/env $PYTHON")
	,PathVariable(
		'OM_PREFIX'
		,"Installation prefix for location where OpenModelica is installed"
		,default_om_prefix)
	,PathVariable(
		'OM_CPPPATH'
		,"Location where OM C runtime headers are located"
		,"$OM_PREFIX/include/omc/c")
	,('OM_LIBS',"Libraries to link when building external functions",default_om_libs)
	,('OM_LIBPATH',"Location of OpenModelicaRuntimeC in particular",default_om_libpath)
)

if platform.system()=="Windows":
	env = Environment(variables=vars,tools=['default','mingw'])
	for v in ['PKG_CONFIG_PATH','PATH','TEMP']:
		if v in os.environ:
			env['ENV'][v] = os.environ[v]
else:
	env = Environment(variables=vars)

# some tricks required for Ubuntu 18.04...
import platform
configcmd = 'pkg-config python-$PYVERSION-embed --libs --cflags'
if platform.system()=="Linux":
    import distro
    if distro.id() == 'ubuntu' and distro.version() == '18.04':
        configcmd = 'python$PYVERSION-config --libs --cflags'
env['PKGCONFIGPYTHON'] = configcmd


#print("os.environ['PATH']=",os.environ.get('PATH'))
#print("os.environ['PKG_CONFIG_PATH']=",os.environ.get('PKG_CONFIG_PATH'))
#print("env['ENV']['PKG_CONFIG_PATH']=",env['ENV'].get('PKG_CONFIG_PATH'))
#print("env['ENV']['PATH']=",env['ENV'].get('PATH'))

env['VERSION'] = '0.2'
env['SUBST_DICT'] = {
	'@VERSION@' : '$VERSION'
	,'@PYTHON@' : '$PYTHON'
	,'@PREFIX@' : '$PREFIX'
	,'@PYTHON_SHEBANG@' : '$PYTHON_SHEBANG'
}

# TODO use 'SConscript(...variant_dir...)
env.SConscript(
	['src/SConscript','tests/SConscript']
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

env.Alias('install',['#','$PREFIX','$INSTALL_OMLIBRARY'])

#env.SConscript('examples')
#env.SConscript('resources')

# TODO install SolarTherm directory

# vim: ts=4:noet:sw=4:tw=80:syntax=python
