Change the Cmakefile of TFEL from 
find_package(Boost 1.36.0 COMPONENTS
               "python-py${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")

to

find_package(Boost 1.71.0 REQUIRED COMPONENTS
               "python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}" "numpy${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}" )
