FROM quay.io/fenicsproject/stable:2019.1.0.r3

USER root

RUN pip3 install progressbar2 xmltodict pandas seaborn

WORKDIR /tmp
RUN apt-get -y update && \ 
    apt-get install -y libgl1-mesa-glx libxcursor1 libxft2 libxinerama1 libglu1-mesa imagemagick python3-h5py python3-lxml gmsh graphviz graphviz-dev && \
    apt-get install -y libqt5svg5-dev qtwebengine5-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt purge -y python2.7-minimal   
RUN pip3 install pygraphviz &&\
	pip3 install pygmsh==6.0.4 meshio==4.0.1


RUN wget --no-verbose https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz && \
    tar xzf boost_1_65_1.tar.gz && \
    cd boost_1_65_1 && \
    ln -s /usr/local/include/python3.6m /usr/local/include/python3.6 && \
    ./bootstrap.sh --with-python=$(which python3) && \
    ./b2 install 

WORKDIR /home/fenics/local

RUN mkdir -p /home/fenics/local/codes/tfel/master/src && \
    mkdir -p /home/fenics/local/codes/mgis/master/src && \
    mkdir  /home/fenics/local/tfel-install && \
    mkdir  /home/fenics/local/mgis-install 
    
ENV TFELSRC /home/fenics/local/codes/tfel/master/src
ENV MGISSRC /home/fenics/local/codes/mgis/master/src
ENV TFELBASEHOME /home/fenics/local/codes/tfel/master
ENV MGISBASEHOME /home/fenics/local/codes/mgis/master
ENV TFELHOME /home/fenics/local/tfel-install 
ENV MGISHOME /home/fenics/local/mgis-install 



RUN cd $TFELSRC && \
    git clone https://github.com/thelfer/tfel.git  && \
    mkdir -p build && \
    cd  build && \
    cmake ../tfel -DCMAKE_BUILD_TYPE=Release -Dlocal-castem-header=ON -Denable-aster=ON -Denable-abaqus=ON -Denable-calculix=ON -Denable-ansys=ON -Denable-europlexus=ON -Denable-python=ON -Denable-python-bindings=ON -DPython_ADDITIONAL_VERSIONS=$PYTHON_VERSION -DCMAKE_INSTALL_PREFIX=/home/fenics/local/tfel-install &&\
    make &&\ 
  make install 
ENV  PATH ${TFELHOME}/bin:$PATH
ENV  LD_LIBRARY_PATH ${TFELHOME}/lib:$LD_LIBRARY_PATH
ENV  PYTHONPATH=${TFELHOME}/lib/python3.6/site-packages:$PYTHONPATH

RUN cd $MGISSRC && \ 
    git clone https://github.com/thelfer/MFrontGenericInterfaceSupport.git
    mkdir -p build && \
    cd  build && \
    cmake ../MFrontGenericInterfaceSupport -DCMAKE_BUILD_TYPE=Release -Denable-python-bindings=ON -Denable-fortran-bindings=ON -Denable-c-bindings=ON -Denable-fenics-bindings=ON -DCMAKE_INSTALL_PREFIX=/home/fenics/local/mgis-install &&\
    make &&\ 
    make install 
    
ENV  PATH ${MGISHOME}/bin:$PATH
ENV  LD_LIBRARY_PATH ${MGISHOME}/lib:$LD_LIBRARY_PATH
ENV  PYTHONPATH=${MGISHOME}/lib/python3.6/site-packages:$PYTHONPATH    
WORKDIR /home/fenics
