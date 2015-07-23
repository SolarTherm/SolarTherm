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
Install dependencies from pacman::

    pacman -S lapack blas lpsolve expat

Install dependencies for python interface from AUR (here using packer)::

    packer -S omniorb omniorbpy

Check you have the right build depedencies installed listed `here <https://github.com/OpenModelica/OpenModelica>`_ (e.g., clang, clang++, cmake, etc).

Clone the git repository::

    git clone https://openmodelica.org/git-readonly/OpenModelica.git --recursive

Configure and build::

    ./configure CC=clang CXX=clang++ --prefix=/usr/local/ --with-omniORB
    make
    make install

Install OMPython via pip::

    pip2 install git+git://github.com/OpenModelica/OMPython.git

Add enviroment variable so python library can find OpenModelica::

    export OPENMODELICAHOME="/usr/local/"

SolarTherm Library
------------------
Add the SolarTherm libraries where OpenModelica can find them.  The first way to do this is to copy or symbolically link the SolarTherm folder in the ~/.openmodelica/libraries/ folder.  On linux creating the symbolic link::

    mkdir -p ~/.openmodelica/libraries/
    cd ~/.openmodelica/libraries
    ln -s $STLIBPARENTPATH/SolarTherm SolarTherm

Where $STLIBPARENTPATH is the directory that contains the SolarTherm folder.

The second way to do this is by setting the OPENMODELICALIBRARY environment variable::

    OPENMODELICA=$OPENMODELICAHOME/lib/omlibrary:~/.openmodelica/libraries/:$STLIBPARENTPATH

On windows replace the : with ;.
