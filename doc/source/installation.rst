Installation
============

OpenModelica
------------
This section will guide you through the steps needed to install OpenModelica on your system.  Skip to the next section if you already have it running.

Windows
^^^^^^^
https://www.openmodelica.org/download/download-windows

Mac
^^^
https://www.openmodelica.org/download/download-mac

Ubuntu/Debian
^^^^^^^^^^^^^
https://www.openmodelica.org/download/download-linux

From Source
^^^^^^^^^^^
https://github.com/OpenModelica/OpenModelica

Archlinux Source
^^^^^^^^^^^^^^^^
There is at least one AUR package for OpenModelica, but it was troublesome.  Here we have a manual installation so that we can get just what we need and easily keep it up to date.

Install dependencies from pacman::

    pacman -S lapack blas lpsolve expat

Install dependencies for python interface from AUR (here using packer)::

    packer -S omniorb omniorbpy

Check you have the right build depedencies installed listed `here <https://github.com/OpenModelica/OpenModelica>`_ (e.g., clang, clang++, cmake, etc).

Clone the git repository::

    git clone https://openmodelica.org/git-readonly/OpenModelica.git --recursive

Configure, build and install selecting a prefix for the installation target (here ``/usr/local``)::

    autoconf
    ./configure CC=clang CXX=clang++ --prefix=/usr/local/ --with-omniORB
    make
    sudo make install

Add enviroment variable with installation prefix so that python library can find OpenModelica::

    export OPENMODELICAHOME="/usr/local/"

Install OMPython via pip::

    pip2 install git+git://github.com/OpenModelica/OMPython.git

Notes & Troubleshooting
"""""""""""""""""""""""
* omniORB is a CORBA implementation required for python interface.
* The OpenModelica compiler omc builds its own version of Ipopt.  If a version of Ipopt is already installed, then at times it might be linked to by mistake during simulation compilation.

SolarTherm Library
------------------
Change to the source directory and make a build folder::
    
    cd steep
    mkdir build
    cd build

Call ``cmake`` to build the library using the same prefix where the modelica
library is installed (typically either ``/usr/local`` or ``/usr``)::

    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
    make

Install the library::

    sudo make install

Run tests::

    ctest -V

Currently the tests can only be run after installing the libraries.  A solution where the tests default to using the locally built copy is desired.

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
