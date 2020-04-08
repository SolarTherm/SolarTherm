cd ~
# Check out the sources for CoolProp
git clone https://github.com/CoolProp/CoolProp --recursive
# Move into the folder you just created
cd CoolProp
# Make a build folder
mkdir build && cd build
# Generate builder (defaults to 64-bit on 64-bit machine)
cmake .. -DCOOLPROP_SHARED_LIBRARY=ON -DCMAKE_BUILD_TYPE=Release
# Build
cmake --build .
# Copy files
sudo cp libCoolProp.so /usr/lib
# Dynamic linking
pushd /usr/lib
sudo ln -sf libCoolProp.so libCoolProp.so.6
sudo ln -sf libCoolProp.so.6 libCoolProp.so.6.3.1dev
# Install the library
ldconfig -n -v /usr/lib
