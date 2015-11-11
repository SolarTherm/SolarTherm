Installation
============
This section goes through the installation process for SolarTherm.  More detailed instructions are provided for two Linux distributions at the end.  SolarTherm has currently only been tested on Linux, however there is no reason why it can't be run on Mac or Windows.

OpenModelica
------------
A working version of OpenModelica is required.  Instructions for installing OpenModelica on each platform:

* `Windows <https://www.openmodelica.org/download/download-windows>`_
* `Mac <https://www.openmodelica.org/download/download-mac>`_
* `Linux <https://www.openmodelica.org/download/download-linux>`_
* `Source <https://github.com/OpenModelica/OpenModelica>`_

SolarTherm
----------
Dependencies
^^^^^^^^^^^^
SolarTherm requires a number of python packages (some optional):

* `scipy <http://www.scipy.org/>`_ prerequisite
* `DyMat <https://bitbucket.org/jraedler/dymat>`_ read in result files
* `matplotlib <http://matplotlib.org/>`_ for plotting (optional)
* `pyswarm <http://pythonhosted.org/pyswarm/>`_ optimisation (optional)
* `cma <https://www.lri.fr/~hansen/cmaes_inmatlab.html>`_ optimisation (optimal)

.. _build-section:

Build and Install
^^^^^^^^^^^^^^^^^
Clone the SolarTherm source code, change to the SolarTherm source directory and make a build folder::
    
    git clone https://github.com/SolarTherm/SolarTherm.git SolarTherm
    cd SolarTherm
    mkdir build
    cd build

Call ``cmake`` to build the library using the same prefix where the modelica
library is installed (typically either ``/usr/local`` or ``/usr``)::

    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local

By default it puts the SolarTherm modelica library in ``lib/omlibrary`` beneath the current install prefix.  If OpenModelica is installed at a different prefix, then the full path to the library directory should be given to the ``-DMODELICA_LIBRARY_INSTALL_DIR`` variable.  This variable can also be set to ``$HOME/.openmodelica/libraries/`` to install it locally for the user.

Make and install the library (use ``sudo`` if installing it under root)::

    make
    make install

Run tests::

    ctest -V

Currently the tests can only be run after installing the libraries.  A solution where the tests default to using the locally built copy is desired.

Full Instructions
-----------------
Ubuntu 14.04 and 15.10
^^^^^^^^^^^^^^^^^^^^^^

OpenModelica::
    
    for deb in deb deb-src; do echo "$deb http://build.openmodelica.org/apt `lsb_release -cs` stable"; done | sudo tee /etc/apt/sources.list.d/openmodelica.list
    wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add -

    sudo apt-get update

    sudo apt-get install openmodelica

SolarTherm dependencies::

    sudo apt-get install git cmake

    sudo apt-get install python-pip
    sudo apt-get install python-scipy python-matplotlib

    sudo pip2 install dymat
    sudo pip2 install pyswarm cma

.. sudo pip2 install git+git://github.com/OpenModelica/OMPython.git

Continue onto :ref:`build-section`.

Ubuntu 14.04 and 15.10 Local Install
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you don't want to install SolarTherm under root, then it can be installed locally under a user account.  As prerequisites we still require:

* ``openmodelica``
* ``git``
* ``cmake``
* ``pip``
* ``scipy``
* ``matplotlib`` (optionally)

In addition we need ``virtualenv``::

    sudo apt-get install python-virtualenv

Additional dependencies can now be installed under a virtual python environment, for example in a new directory ``~/st_env``::

    virtualenv --system-site-packages ~/st_env
    source ~/st_env/bin/activate
    pip2 install dymat
    pip2 install pyswarm cma
    deactivate

Checkout the repository and change into a new build directory as outlined in :ref:`build-section`.  The build process proceeds::

    source ~/st_env/bin/activate
    cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/st_env -DMODELICA_LIBRARY_INSTALL_DIR=$HOME/.openmodelica/libraries/
    make
    make install
    deactivate

Now in order to run the tests or use SolarTherm a different environment is required.  This is turned on and off with (note the ``st_`` prefix)::

    source ~/st_env/bin/st_activate
    ctests -V
    st_deactivate

In addition to calling the ``virtualenv`` environment, it sets up paths to linked non-Modelica libraries.  Note that for this local installation ``omc`` will produce additional warnings when compiling code that links to external C libraries.  This is because it doesn't find the libraries in one of the default locations, but they still get linked in correctly later on in the process.

Archlinux Source
^^^^^^^^^^^^^^^^
There is at least one AUR package for OpenModelica, but it was troublesome.  Here we have a manual installation so that we can get just what we need and easily keep it up to date.

Install dependencies from pacman::

    sudo pacman -S lapack blas lpsolve expat boost

.. Install dependencies for python interface and sundials from AUR (here using packer)::

Install dependencies sundials from AUR (here using packer)::

    sudo packer -S sundials26

..    sudo packer -S omniorb omniorbpy

Check you have the right build depedencies installed listed `here <https://github.com/OpenModelica/OpenModelica>`__ (e.g., clang, clang++, cmake, etc).

Clone the git repository::

    git clone https://openmodelica.org/git-readonly/OpenModelica.git --recursive

Configure, build and install selecting a prefix for the installation target (here ``/usr/local``)::

    autoconf
    ./configure CC=clang CXX=clang++ --prefix=/usr/local/ --with-omniORB --with-cppruntime --with-lapack='-llapack -lblas'
    make
    sudo make install

.. Add enviroment variable with installation prefix so that python library can find OpenModelica::
.. 
..     export OPENMODELICAHOME="/usr/local/"

SolarTherm dependencies::

    sudo pacman -S git cmake

    sudo pacman -S python2-pip
    sudo pacman -S python2-scipy python2-matplotlib

    sudo pip2 install dymat
    sudo pip2 install pyswarm cma

.. sudo pip2 install git+git://github.com/OpenModelica/OMPython.git

Continue onto :ref:`build-section`.

Notes & Troubleshooting
"""""""""""""""""""""""
.. * omniORB is a CORBA implementation required for python interface.

* The OpenModelica compiler omc builds its own version of Ipopt.  If a version of Ipopt is already installed, then at times it might be linked to by mistake during simulation compilation.
* The 1.58-0-3 version of the boost library has a bug that causes a compilation error.  See `here <https://svn.boost.org/trac/boost/attachment/ticket/11207/patch_numeric-ublas-storage.hpp.diff>`__ for the simple diff to apply.

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
