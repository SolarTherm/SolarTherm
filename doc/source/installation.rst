Installation
============
This section goes through the installation process for SolarTherm. The required dependencies and software packages are reviewd at the beginning, followed by more detailed installation instructions for two Linux distributions and Windows.  The scripting and tools in SolarTherm have currently been tested on Ubuntu (20.04 and 18.04) and Windows-MSYS2. Although they should also run on Mac, we have not tested it yet.


Overview
---------
The SolarTherm package contains a series of CST related Modelica models to perform dynamic performance analysis. It is also integrated with several software packages to expand its simulation capability, for example, Solstice for Monte-Carlo ray tracing simulations, GLPK for linear programming optimisation, Tenserflow, SAM SSC (SAM simulation core) for surrogate modelling, etc. The Modelica models can be run by either OMEdit or a terminal command. `OMEdit <https://openmodelica.org/?id=78:omconnectioneditoromedit&catid=10:main-category>`_ is a graphical user interface that enables the users to easily create models, edit connections, run simulations and plot results.

The SolarTherm package also contains a series of additional functions that perform financial calculations (e.g. LCOE, LCOF), parametric sweep, system optimisation and sensitivity analysis. It also itegrates with excel spreasheets and Dakota software package for expanding data sampling and optimisation capabilities. These functions are handled externally from Modelica, and must be run from a terminal command. It is recommonded that using OMEdit for Modelica model development and inspection, and using terminal commands to perform techno-economic analysis, system optimisation and sensitivity analysis.  

The required dependencies and software packages are listed below:

OpenModelica
^^^^^^^^^^^^
A working version of OpenModelica is required.  Instructions for installing OpenModelica (including OMEdit) on each platform:

* `Windows <https://www.openmodelica.org/download/download-windows>`_
* `Mac <https://www.openmodelica.org/download/download-mac>`_
* `Linux <https://www.openmodelica.org/download/download-linux>`_
* `Source <https://github.com/OpenModelica/OpenModelica>`_

We found that the OpenModelica version v1.14.2 is stable and works better for all of our SolarTherm models, especially for the particle system model that invovles several surrogate models (e.g. ANN, Kriging, SAM SSC). 

An instruction of the OpenModelica intalltion is provided below in this documentation. 


Dependencies
^^^^^^^^^^^^
Prerequisite Python packages:

* `scons <https://scons.org/>`_ 
* `distro <https://pypi.org/project/distro/>`_
* `wheel <https://pypi.org/project/wheel/>`_ 
* `numpy <https://numpy.org/>`_
* `scipy <http://www.scipy.org/>`_
* `DyMat <https://bitbucket.org/jraedler/dymat>`_ 
* `solsticepy <https://pypi.org/project/solsticepy/>`_ (Python wrapper for Solstice ray-tracing simulations)
* `openpyxl <https://pypi.org/project/openpyxl/>`_ (for loading/exporting parameter from/to an excel spreadsheet)
* `colorama <https://pypi.org/project/colorama/>`_ (for highlighting keywords in output)s
* `pytest <https://docs.pytest.org>`_ (for running tests) 


Optional:

* `matplotlib <http://matplotlib.org/>`_ (for plotting figures)
* `pyswarm <http://pythonhosted.org/pyswarm/>`_ (for optimisation using pysawrm method)
* `cma <https://www.lri.fr/~hansen/cmaes_inmatlab.html>`_ (for optimisation using cma method)
* `tensorflow <https://www.tensorflow.org/learn>`_ (for training surrogate models)
* `pyDOE <https://pythonhosted.org/pyDOE/>`_ (for training surrogate models)
* `bayesian-optimization <https://github.com/fmfn/BayesianOptimization>`_ (for optimisation of ANN models) 
* `pandas <https://pandas.pydata.org/>`_ (handling data for surrogate model training)
* `CoolProp <http://www.coolprop.org/coolprop/wrappers/Python/index.html>`_ (for calculating fluid properties)


Optional external software packages/libraries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SolarTherm integrates with a number of software packages to expand its applications:

* `Solstice <https://www.meso-star.com/projects/solstice/solstice.html>`_ (for Monte-Carlo ray tracing simulations)
* `Dakota <https://dakota.sandia.gov/>`_ (for optimisation and uncertainty quantification)
* `glpk <https://www.gnu.org/software/glpk/>`_ (for linear programming)
* `gsl <https://www.gnu.org/software/gsl/>`_ GNU Scientific Library (for Kriging surrogate models)
* `SSC <https://github.com/NREL/ssc>`_ SAM simulation core (for surrogate models)
* `TensorFlow C API <https://www.tensorflow.org/install/lang_c>`_ (for deploying surrogate models inside SolarTherm)


.. _build-section:


Installation Instruction (Ubuntu 18.04 and 20.04)
-------------------------------------------------
The terminal commands for building the essential packages on Ubuntu (18.04 and 20.04) are listed below.

1. OpenModelica
^^^^^^^^^^^^^^^

Installation for the latest version (Note that the newest sometime is not the best, since it has not been carefully tested)

::

    $ for deb in deb deb-src; do echo "$deb http://build.openmodelica.org/apt `lsb_release -cs` release"; done | sudo tee /etc/apt/sources.list.d/openmodelica.list
    $ wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add - 
    $ sudo apt update
    $ sudo apt install build-essential openmodelica omlib-modelica-3.2.3 libglpk-dev

Installation for v 1.17.0 ::

	$ echo "deb https://build.openmodelica.org/omc/builds/linux/releases/1.17.0/ `lsb_release -cs` release" | sudo tee /etc/apt/sources.list.d/openmodelica.list
    $ wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add -  
    $ sudo apt-get update
    $ sudo apt-get install build-essential omc omlib-modelica-3.2.3 libglpk-dev
	$ sudo apt install openmodelica

Installation for v 1.14.2 (this version of omc works better with our models when we tested it, especially for the particle systems.) ::

	$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3A59B53664970947 
    $ echo "deb https://build.openmodelica.org/omc/builds/linux/releases/1.14.2/ bionic release"| sudo tee /etc/apt/sources.list.d/openmodelica.list
    $ wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add - 
    $ sudo apt-get update
    $ sudo apt-get install build-essential openmodelica omlib-modelica-3.2.2 libglpk-dev glpk-utils libgsl-dev



2. SolarTherm Python dependencies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  
::

    $ python3 -m pip install --upgrade pip 
    $ python3 -m pip install --upgrade setuptools wheel
    $ python3 -m pip install scons scipy matplotlib DyMat pyswarm cma pytest solsticepy openpyxl distro colorama


Note that if pip is not installed on your platform, then install it first by the following comment
::

    $ sudo apt install python3-pip 
    $ sudo apt install python3-testresources


3. Solstice
^^^^^^^^^^^
::

    $ sudo apt install libpolyclipping-dev libtbb-dev libyaml-dev  libgomp1
    $ export UBVER=`lsb_release -cs`
    $ export SOLSTICEURL="https://cloudstor.aarnet.edu.au/plus/s/TaoO6XnrGRiwoiC/download?path=%2F&files=solstice-0.9.1-x86_64-$UBVER.tar.gz"
    $ sudo tar zxv --strip-components=3 -C /usr/local < <(wget "$SOLSTICEURL" -q -O-)
    $ export PATH=$PATH:/usr/local/bin
    $ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
    $ solstice --version
	
4. Dakota
^^^^^^^^^
Prerequisite for Ubuntu 20.04::

    $ sudo apt install openmpi-bin libltdl7 liblapack3 libhwloc15 \
      libgslcblas0 libquadmath0 libboost-regex1.71.0 libgsl23 \
      libevent-2.1-7 libgfortran5 libboost-filesystem1.71.0 libopenmpi3 \
      libicu66 libblas3 libstdc++6 libevent-pthreads-2.1-7 \
      libboost-serialization1.71.0
    $ OS=ubuntu-20.04
    $ mpirun --version
	      
Prerequisite for Ubuntu 18.04::     
 
    $ sudo apt install libicu60 libboost-serialization1.65.1 libstdc++6 \
          libboost-filesystem1.65.1 libgcc1 libquadmath0 liblapack3 \
          libboost-regex1.65.1 libboost-system1.65.1 libblas3 libc6 \
          libgfortran4 openmpi-bin libopenmpi-dev
    $ OS=ubuntu-18.04
    $ mpirun --version

Install Dakota::

    $ DAKOTA_VERSION=6.14.0
    $ export PKGN=dakota-${DAKOTA_VERSION}-${OS}-x86_64-jp
    $ export DAKURL="https://cloudstor.aarnet.edu.au/plus/s/TaoO6XnrGRiwoiC/download?path=%2F&files=$PKGN.tar.gz"
    $ sudo tar zxv --strip-components=3 -C /usr/local < <(wget "$DAKURL" -q -O-)
    $ export PATH=$PATH:/usr/local/bin    # needed for Ubuntu 18.04
    $ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib  # needed for 18.04
    $ dakota --version
    $ export PYTHONPATH=$PYTHONPATH:/usr/local/share/dakota/Python
    $ python3 -c "import dakota.interfacing;print(dakota.interfacing.__file__)"                    



5. Build and install SolarTherm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Clone the SolarTherm source code, change to the SolarTherm source directory and compile the package using ``scons``
::

    $ sudo apt install git
    $ git clone https://github.com/SolarTherm/SolarTherm.git SolarTherm
	$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
	$ export PYTHONPATH=$PYTHONPATH:/usr/local/share/dakota/Python
    $ cd SolarTherm
    $ scons
    $ scons install

The default installation prefix is ``~/.local``. A user defined prefix can be given to the 'PREFIX' variable to change the installation prefix, for example
::

    $ scons PREFIX=/the/user/defined/directory
    $ scons install PREFIX=/the/user/defined/directory

The default SolarTherm modelica library prefix is ``~/.openmodelica/libraries`` on Linux and ``~/.local/lib/omlibrary`` on Windows (MSYS2). If OpenModelica is installed at a different prefix, then the full path to the library directory should be given to the ``INSTALL_OMLIBRARY`` variable. For example
::

    $ scons PREFIX=/the/user/defined/directory INSTALL_OMLIBRARY=/the/directory/where/Openmodelica/installed
    $ scons install PREFIX=/the/user/defined/directory INSTALL_OMLIBRARY=/the/directory/where/Openmodelica/installed

The last step is to set up the correct environment variables for the command line to find SolarTherm.  A tool (``st``) has been created by the ``scons`` to automatically set the correct environment for the current terminal. By default, ``st`` is located in ``~/.local/bin/`` and can be called directly. The Solartherm environment can be activated by::
    
    $ st env

The command ``exit`` deactivates the environment. 

Once the environment is correctly set up,  tests can be run from the tests directory with the command::

    $ python -m pytest


Installation Instruction (Windows)
----------------------------------

On Windows platforms, the SolarTherm terminal commands are run from MSYS2. The installation includes MSYS2 system and OMEdit.

The full instruction is available on SolarTherm Wiki `here <https://github.com/SolarTherm/SolarTherm/wiki/Running-SolarTherm-on-Windows-%28MSYS2%29>`_.



Build omc from Source
---------------------
This section will be added to show how to build openmodelica (omc) from source, e.g. for supercomputer applications.



.. Notes & Troubleshooting
.. """""""""""""""""""""""
.. * omniORB is a CORBA implementation required for python interface.

.. * The OpenModelica compiler omc builds its own version of Ipopt.  If a version of Ipopt is already installed, then at times it might be linked to by mistake during simulation compilation.
.. * The 1.58-0-3 version of the boost library has a bug that causes a compilation error.  See `here <https://svn.boost.org/trac/boost/attachment/ticket/11207/patch_numeric-ublas-storage.hpp.diff>`__ for the simple diff to apply.

.. Add the SolarTherm libraries where OpenModelica can find them.  The first way to do this is to copy or symbolically link the SolarTherm folder in the ``~/.openmodelica/libraries/`` folder.  On linux creating the symbolic link::
.. 
..     mkdir -p ~/.openmodelica/libraries/
..     cd ~/.openmodelica/libraries
..     ln -s $STLIBPARENTPATH/SolarTherm SolarTherm
.. 
.. Where ``$STLIBPARENTPATH`` is the directory that contains the SolarTherm folder.
.. 
.. The second way to do this is by setting the ``OPENMODELICALIBRARY`` environment variable::
.. 
..     OPENMODELICA=$OPENMODELICAHOME/lib/omlibrary:~/.openmodelica/libraries/:$STLIBPARENTPATH
.. 
.. On windows replace the : with ;.
