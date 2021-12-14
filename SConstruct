import re, os, sys, platform, shutil, colorama; from pathlib import Path, PurePath
import subprocess as sp
colorama.init()

# build script for SolarTherm -- use 'scons' to run it.
# philopsophy here is:
#    - Needed tools like 'solstice' etc should be in the PATH at build-time
#    - We will provide a script called 'st' that makes all required environment var settings
#      at run-time, to try to avoid any challenges for configuration for the end user.
#    - We assume that Solstice is installed on Windows using our Windows installer.
#    - Ultimately we are aiming for a setup process that can be completely automated using
#      standard package managers like apt-get and pacman, but we're not there yet.

default_prefix=Path.home()/'.local'
default_pyversion = "%d.%d" % (sys.version_info[0],sys.version_info[1])

#print('system',platform.system())
if platform.system()=="Windows" or "MINGW" in platform.system():
	if os.environ.get('MSYSTEM') == "MINGW64":
		default_prefix=Path(os.environ['HOME'])/'.local'
		default_tf_prefix = default_prefix
		default_ssc_prefix = default_prefix
		default_om_libpath = '$OM_PREFIX/lib/omc'
		default_om_libs = ['SimulationRuntimeC','omcgc']
		default_install_omlibrary = '$PREFIX/lib/omlibrary'
		default_mpirun = 'mpiexec'
	else:
		raise RuntimeError("On Windows, you must use MSYS2 in 64-bit mode.")
else:
	default_tf_prefix = default_prefix
	default_ssc_prefix = Path(os.environ['HOME'])/'SAM'/'2020.11.12'
	default_om_libpath = None
	default_om_libs = []
	default_install_omlibrary = Path(os.environ['HOME'])/'.openmodelica'/'libraries'#'$PREFIX/lib/omlibrary'
	default_mpirun = 'mpirun'

if shutil.which('dakota'):
	default_dakota_prefix = Path(shutil.which('dakota')).parent.parent
else:
	default_dakota_prefix = default_prefix

if shutil.which('glpsol'):
	default_glpk_prefix = Path(shutil.which('glpsol')).parent.parent
else:
	default_glpk_prefix = default_prefix

if shutil.which('gsl-config'):
	default_gsl_config = Path(shutil.which('gsl-config'))
else:
	default_gsl_config = 'gsl-config'

if shutil.which('omc'):
	default_om_prefix = Path(shutil.which('omc')).parent.parent
else:
	default_om_prefix = default_prefix
default_om_modelicapath = '$OM_PREFIX/lib/omlibrary' # location of MSL, eg Modelica 3.2.3 etc.

default_colors='auto'
if sys.stdout.isatty():
	default_colors = 'yes'
def ORANGEWARN(msg):
	return(colorama.Fore.YELLOW+colorama.Style.BRIGHT + msg + colorama.Style.RESET_ALL)
def REDWARN(msg):
	return(colorama.Fore.RED+colorama.Style.BRIGHT + msg + colorama.Style.RESET_ALL)

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
	,PathVariable('OM_PREFIX',"Installation prefix for location where OpenModelica is installed"
		,default_om_prefix,PathVariable.PathAccept)
	,PathVariable( 'OM_CPPPATH' ,"Location where OM C runtime headers are located"
		,"$OM_PREFIX/include/omc/c",PathVariable.PathAccept)
	,('OM_LIBS',"Libraries to link when building external functions",default_om_libs)
	,PathVariable('OM_BIN',"Location of OM executables"
		,'$OM_PREFIX/bin',PathVariable.PathAccept)
	,PathVariable('OM_LIBPATH',"Location of OpenModelicaRuntimeC in particular"
		,default_om_libpath, PathVariable.PathAccept)
	,PathVariable('OM_MODELICAPATH','Location of Modelica standard libraries'
		,default_om_modelicapath,PathVariable.PathAccept)
	,PathVariable('GLPK_PREFIX',"Installation prefix for GLPK"
		,default_glpk_prefix,PathVariable.PathAccept)
	,PathVariable('GLPK_CPPPATH' ,"Location where GLPK headers are located" ,"$GLPK_PREFIX/include")
	,PathVariable('GLPK_LIBPATH' ,"Location where GLPK libraries are located" ,"$GLPK_PREFIX/lib")
	,PathVariable('TF_PREFIX'
		,"Installation prefix for TensorFlow",default_tf_prefix,PathVariable.PathAccept)
	,PathVariable('TF_CPPPATH' ,"Location where TensorFlow C headers are located" ,"$TF_PREFIX/include",PathVariable.PathAccept)
	,PathVariable('TF_LIBPATH' ,"Location where TensorFlow C libraries are located" ,"$TF_PREFIX/lib",PathVariable.PathAccept)
	,PathVariable('SSC_PREFIX'
		,"Installation prefix for SAM Simulation Core",default_ssc_prefix,PathVariable.PathAccept)
	,PathVariable('SSC_CPPPATH' ,"Location where SAM SSC headers are located" ,"$SSC_PREFIX/linux_64",PathVariable.PathAccept)
	,PathVariable('SSC_LIBPATH' ,"Location where SAM SSC libraries are located" ,"$SSC_PREFIX/linux_64",PathVariable.PathAccept)
	,PathVariable('GSL_CONFIG',"Location of 'gsl-config' tool for GSL installation info.",default_gsl_config,PathVariable.PathAccept)
	,PathVariable(
		'DAKOTA_PREFIX'
		,"Installation prefix for GLPK"
		,default_dakota_prefix,PathVariable.PathAccept)	
	,PathVariable('DAKOTA_BIN' ,"Location where DAKOTA executable is located" ,"$DAKOTA_PREFIX/bin",PathVariable.PathAccept)
	,PathVariable('DAKOTA_PYTHON'
		,"Location where DAKOTA python module is located"
		,"$DAKOTA_PREFIX/share/dakota/Python",PathVariable.PathAccept)
	,('MPIRUN',"Program to run MPI parallel tasks",default_mpirun)
	,EnumVariable('COLORS',"Whether to use colour in output",default_colors,['yes','no','auto'])
	,BoolVariable('DEBUG',"Add data for GDB during compilation",False)
)

if platform.system()=="Windows":
	env = Environment(variables=vars,tools=['default','mingw'])
	for v in ['PKG_CONFIG_PATH','PATH','TEMP']:
		if v in os.environ:
			env['ENV'][v] = os.environ[v]
elif platform.system()=="Linux":
	import distro
	env = Environment(variables=vars)
	if distro.id()=="centos" or distro.id()=="rocky":
		# for centos specifically (eg the NCI supercomputer, Gadi) we need this
		# for pkg-config to work correctly.
		for v in ['PKG_CONFIG_PATH','PATH','LD_LIBRARY_PATH']:
			if v in os.environ:
				env['ENV'][v] = os.environ[v]
Help(vars.GenerateHelpText(env))

#---------------------------------------------------------------------------------------------------
# CHECK FOR DAKOTA, SOLSTICE, OPENMODELICA, OPENMPI/MSMPI, correct PATH.

def check_solsticepy(ct):
	ct.Message('Checking for solsticepy... ')
	try:
		import solsticepy
	except Exception as e:
		ct.Result(str(e))
		return False

	try:
		from solsticepy.output_motab import output_metadata_motab
	except ImportError as e:
		ct.Result(str(e))
		return False
	ct.Result("yes")
	return True
def check_solstice(ct):
	ct.Message('Checking for solstice... ')
	try:
		import solsticepy
		solstice = solsticepy.find_prog('solstice')
		if not solstice:
			raise RuntimeError("Solstice not found by solsticepy")
		sp.run([solstice,'--version'],check=True,stdout=sp.PIPE,stderr=sp.PIPE)
		if platform.system()=='Linux' and solstice == 'solstice':
			solstice = shutil.which('solstice')
	except Exception as e:
		ct.Result(str(e))
		return False
	ct.Result(solstice)
	if platform.system()=="Linux":
		ct.env.AppendUnique(
			ST_PATH=[os.path.dirname(solstice)]
		)
	return True
def check_dakota(ct):
	ct.Message('Checking for DAKOTA... ')
	try:
		# we already searched the path for DAKOTA, don't need to do it again
		dakota = 'dakota'+('.exe' if platform.system()=="Windows" else '')
		dpath = Path(env.subst('$DAKOTA_BIN'))/dakota
		call = [dpath,'--version']
		sp.run(call,check=True,stdout=sp.PIPE,stderr=sp.PIPE)
	except Exception as e:
		ct.Result("Not found")
		ct.env['HAVE_DAKOTA'] = False
		return False
	ct.Result(str(dpath))
	ct.env['DAKOTA'] = dpath
	ct.env['HAVE_DAKOTA'] = True
	ct.env.AppendUnique(
		ST_PATH = [env.subst('$DAKOTA_BIN')]
	)
	return True
def check_dakota_python(ct):
	ct.Message("Checking for 'dakota.interfacing' Python module... ")
	dpy = Path(ct.env.subst('$DAKOTA_PYTHON'))
	try:
		assert dpy.exists()
		call = [sys.executable,'-c','"import dakota.interfacing;print dakota.interfacing.__file__"']
		env1 = os.environ.copy()
		p1 = env1.get('PYTHONPATH')
		if p1 is None:
			env1['PYTHONPATH'] = str(dpy)
		else:
			env1['PYTHONPATH'] = os.pathsep.join([p1,str(dpy)])
		#print("PYTHONPATH =",env1['PYTHONPATH'])
		sp.run(call,env=env1,check=True)
	except Exception as e:
		ct.Result("Not found (%s)"%(str(e),))
		ct.env['HAVE_DAKOTA']=False
		return False
	ct.Result('OK')
	ct.env.AppendUnique(
		ST_PYTHONPATH=[str(dpy)]
	)
	return True
def check_omc(ct):
	ct.Message("Checking for 'omc'... ")
	# if our OM_PREFIX is correct, then OMC must be here:
	omcp = 'omc'+('.exe' if platform.system()=="Windows" else '')
	omc = Path(ct.env.subst('$OM_BIN'))/omcp
	if not omc.exists():
		ct.Result('Not found')
		return False
	try:
		call = [omc,'--version']
		sp.run(call,check=True,stdout=sp.PIPE,stderr=sp.PIPE) # TODO check the version is OK
	except Exception as e:
		ct.Result("Not found (%s)"%(str(e),))
		return False
	ct.Result(str(omc))
	if str(omc.parent) != '/usr/bin':
		ct.env.AppendUnique(
			ST_PATH = [str(omc.parent)]
#			,ST_LIBPATH = [str(omc.parent.parent/'lib')]
		)
	return True
def check_omlibrary(ct):
	ct.Message("Checking for Modelica Standard Library... ")
	try:
		p = Path(ct.env.subst('$OM_MODELICAPATH'))
		assert p.exists()
		if (p/'Modelica 3.2.3').exists():
			assert (p/'Modelica 3.2.3'/'SIunits.mo').exists()
			ct.Result('3.2.3')
		else:
			# allow 3.2.2 as fallback, for now
			assert (p/'Modelica 3.2.2'/'SIunits.mo').exists()
			ct.Result('3.2.2')
	except Exception as e:
		ct.Result("Failed (%s)"%(str(e),))
		return False
	return True

def check_mpi(ct):
	ct.Message("Checking for mpirun/mpiexec... ")
	mpirun = shutil.which(ct.env['MPIRUN'])
	args = ['--version']
	if platform.system()=="Linux":
		if not mpirun:
			ct.Result('Not found in PATH'); return False
		mpirun=Path(mpirun).resolve()
	elif platform.system()=="Windows":
		args = []
		if not mpirun:
			import winreg as wr
			mpiregpath = None
			for inst_type in wr.HKEY_CURRENT_USER, wr.HKEY_LOCAL_MACHINE:
				try:
					#print("Trying",inst_type)
					rk = wr.OpenKey(inst_type,r'SOFTWARE\Microsoft\MPI')
					mpiregpath,valtype = wr.QueryValueEx(rk,'InstallRoot')
					#print("GOT mpiregpath=",mpiregpath)
					rk.Close()
					if Path(mpiregpath).exists():
						break
				except WindowsError:
					pass
			if mpiregpath is None:
				ct.Result('Not found in Windows registry'); return False
			mpirun = PurePath(mpiregpath)/'Bin'/'mpiexec.exe'
	else:
		ct.Result('Unsupported platform'); return False
	try:
		call = [str(mpirun)]+args
		sp.run(call,stdout=sp.PIPE,stderr=sp.PIPE,check=True)
	except Exception as e:
		ct.Result('Unable to run. %s'%(str(e),))
		return False
	ct.env['MPIRUN']=str(mpirun)
	#print('MPIRUN =',ct.env['MPIRUN'])
	ct.Result(str(mpirun))
	return True


def check_ssc(ct):
	ct.Message('Checking SSC... ')
	cv = {}
	for v in ['CPPPATH','LIBPATH','LIBS','ENV']:
		cv[v] = ct.env.get(v)
	def restore_env(env):
		for v in cv:
			if cv[v] is None:
				del env[v]
			else:
				env[v] = cv[v]
	ct.env.Append(CPPPATH=['$SSC_CPPPATH'],LIBPATH=['$SSC_LIBPATH'],LIBS=['ssc'])
	src = '''
#include <sscapi.h>
#include <stdio.h>
int main() {
	fprintf(stdout,"%s\\n",ssc_build_info());
	return 0;
}
	'''
	res = ct.TryCompile(src,'.c')
	ct.env['HAVE_SSC'] = bool(res)
	ct.Result(res)
	restore_env(ct.env)
	return res


def check_path(ct):
	ct.Message('Checking PATH.... ')
	pp = os.environ.get('PATH','').split(os.pathsep)
	ib = os.path.normpath(ct.env.subst('$INSTALL_BIN'))
	for p in pp:
		if os.path.normpath(p) == ib:
			ct.Result('OK')
			return True
	ct.Result('Does not contain $INSTALL_BIN')
	return False

def check_tensorflow(ct):
	ct.Message('Checking Tensorflow... ')
	cv = {}
	for v in ['CPPPATH','LIBPATH','LIBS','ENV']:
		cv[v] = ct.env.get(v)
	def restore_env(env):
		for v in cv:
			if cv[v] is None:
				del env[v]
			else:
				env[v] = cv[v]
	ct.env.Append(CPPPATH=['$TF_CPPPATH'],LIBPATH=['$TF_LIBPATH'],LIBS=['tensorflow'])
	runpath = 'PATH' if platform.system()=="Windows" else 'LD_LIBRARY_PATH'
	ct.env['ENV'][runpath] = ct.env['ENV'].get(runpath,'') + os.pathsep + ct.env.subst('$TF_LIBPATH')
	src = '''
#include <tensorflow/c/c_api.h>
#include <stdio.h>
int main() {
	fprintf(stdout,"TensorFlow %s\\n",TF_Version());
	return 0; 
}
	'''
	if platform.system()=="Windows":
		# bug in SCons, can't yet check version using TryRun on MSYS2.
		res = ct.TryCompile(src,'.c')
		ct.env['HAVE_TF'] = bool(res)
		ct.Result(res)
		restore_env(ct.env)
		return res
	else:
		res, tfversion = ct.TryRun(src,'.c')
		restore_env(ct.env)
		msg = 'no'
		ct.env['HAVE_TF'] = False
		if res:
			versre = re.compile(r"^TensorFlow ([0-9]+)\.([0-9]+)\.(.*)$")
			tfversion = tfversion.strip()
			match = versre.match(tfversion)
			if match:
				tfmajor = int(match.group(1))
				tfminor = int(match.group(2))
				if tfmajor == 2 and tfminor >= 1:
					ct.Result('%d.%d'%(tfmajor,tfminor))
					ct.env['HAVE_TF'] = True
					return True
				msg = "bad version '%s'"%(tfversion)
			else:
				msg = "unrecognised version '%s'"%(tfversion)
		ct.Result(msg)
		return False

conf = env.Configure(custom_tests={
	'CSP':check_solsticepy
	,'CS':check_solstice
	, 'DAK':check_dakota
	,'DAKPY':check_dakota_python
	,'OMC':check_omc
	,'OMLib':check_omlibrary
	,'MPI':check_mpi
	,'PATH':check_path
	,'TF':check_tensorflow
	,'SSC':check_ssc
})

CONFFAIL=1
def confmsg(env,msg,fail=0):
	if fail:
		print(REDWARN(msg))
		Exit(1)
	else:
		print(ORANGEWARN(msg))

if not conf.CSP():
	confmsg(env,"Missing or wrong version of 'solsticepy'",CONFFAIL)
if not conf.CS():
	confmsg(env,"Unable to locate 'solstice'",CONFFAIL)
conf.DAK() # we tolerate not finding DAKOTA, use HAVE_DAKOTA later to check
conf.DAKPY()

if conf.TF():
	env.AppendUnique(ST_LIBPATH=['$TF_LIBPATH'])
else:
	confmsg(env,"Warning: TensorFlow was not found, some components will not be built.")
if conf.SSC():
	env.AppendUnique(ST_LIBPATH=['$SSC_LIBPATH'])
else:
	confmsg(env,"Warning: SSC was not found, some components will not be built.")

if not conf.OMC() or not conf.OMLib():
	confmsg(env,"Unable to locate OpenModelica. Unable to continue.",CONFFAIL)
if not conf.MPI():
	# FIXME can we make MPI optional?
	confmsg(env,"Warning: unable to run '%s', needed for parallel optimisation"%(env['MPIRUN']),CONFFAIL)
if not conf.PATH():
	confmsg(env,"Warning: folder %s is not in your PATH. You will need to add it so that you can run the 'st' script easily."%(env.subst('$INSTALL_BIN'),))
env = conf.Finish()

envg = env.Clone()
if shutil.which(env['GSL_CONFIG']):
	envg.ParseConfig('$GSL_CONFIG --libs --cflags')
def check_gsl(ct):
	ct.Message('Checking for GSL... ')
	src = """#include <gsl/gsl_sf_bessel.h>
int main(void){
	double y = gsl_sf_bessel_J0(5);
	return 0;
}
"""
	res = ct.TryLink(src,'.c')
	ct.Result(res)
	ct.env['HAVE_GSL'] = res
	return res
confg = envg.Configure(custom_tests={'GSL':check_gsl})
if not confg.GSL():
	confmsg(env,"Warning: unable to locate GSL. Some components will not be built.")
envg = confg.Finish()
env['HAVE_GSL'] = envg['HAVE_GSL']

#---------------------------------------------------------------------------------------------------

# some tricks required for Ubuntu 18.04...
configcmd = 'pkg-config python-$PYVERSION-embed --libs --cflags'
if platform.system()=="Linux":
	if env['PYVERSION'] in ('3.6','3.7'):
		configcmd = 'python$PYVERSION-config --ldflags --cflags'

env['PKGCONFIGPYTHON'] = configcmd

#print("os.environ['PATH']=",os.environ.get('PATH'))
#print("os.environ['PKG_CONFIG_PATH']=",os.environ.get('PKG_CONFIG_PATH'))
#print("env['ENV']['PKG_CONFIG_PATH']=",env['ENV'].get('PKG_CONFIG_PATH'))
#print("env['ENV']['PATH']=",env['ENV'].get('PATH'))

env.AppendUnique(
	ST_PATH=[env.subst('$INSTALL_BIN')]
	,ST_LIBPATH=[]
	,ST_PYTHONPATH=[env.subst('$PREFIX/lib/python$PYVERSION/site-packages')]	
	,ST_MODELICAPATH=[env.subst('$OM_MODELICAPATH'),env.subst('$INSTALL_OMLIBRARY')]
)

# Note: ST_PATH, ST_LIBPATH and ST_PYTHONPATH contain paths that will be added to PATH,
# LD_LIBRARY_PATH and PYTHONPATH (Linux) or just PATH and PYTHONPATH (Windows) when the 'st' script
# is run, to reduce the risks of runtime configuration errors. The components will only be added
# if not already in the relevant path.

env['VERSION'] = '0.2'
env['SUBST_DICT'] = {
	'@VERSION@' : '$VERSION'
	,'@PYTHON@' : '$PYTHON'
	,'@PREFIX@' : '$PREFIX'
	,'@PYTHON_SHEBANG@' : '$PYTHON_SHEBANG'
	,'@ST_PATH@' : os.pathsep.join(env['ST_PATH'])
	,'@ST_LIBPATH@' : os.pathsep.join(env['ST_LIBPATH'])
	,'@ST_PYTHONPATH@' : os.pathsep.join(env['ST_PYTHONPATH'])
	,'@ST_MODELICAPATH@' : os.pathsep.join(env['ST_MODELICAPATH'])
	,'@ST_MPIRUN@' : env.subst('$MPIRUN')
}

if env['COLORS'] == 'yes':
	env.Append(
		CPPFLAGS=['-fdiagnostics-color=always']
		,LINKFLAGS=['-fdiagnostics-color=always']
	)
elif env['COLORS'] == 'no':
	env.Append(
		CPPFLAGS=['-fdiagnostics-color=never']
		,LINKFLAGS=['-fdiagnostics-color=never']
	)

env.Append(CPPFLAGS=['-Wall'])

if env['DEBUG']:
	env.Append(
		CPPFLAGS =["-g"]
		,LDFLAGS =["-g"]
	)


# TODO use 'SConscript(...variant_dir...)
env.SConscript(
	['src/SConscript','tests/SConscript']
	, exports='env'
)

#print("Runtime PATHs:",env.get('ST_PATH'))

#---------------------------------------------------------------------------------------------------
# Install (nearly) all files in 'SolarTherm' folder

stfiles = []
fre = re.compile(r'^(.*)\.(mo|motab|csv|CSV|txt|order|pb|index|data.*|index)$') #Update this to include *pb *index etc.
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
#

# vim: ts=4:noet:sw=4:tw=100:syntax=python
