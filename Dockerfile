FROM  dbaroliaices/mgisfenics:base
USER root
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
    git clone https://github.com/yunkb/tfel.git  && \
    git checkout -b cmakecompatibility && \
    mkdir -p build && \
    cd  build && \
    cmake ../tfel -DCMAKE_BUILD_TYPE=Release -Dlocal-castem-header=ON -Denable-aster=ON -Denable-abaqus=ON -Denable-calculix=ON -Denable-ansys=ON -Denable-europlexus=ON -Denable-python=ON -Denable-python-bindings=ON -DPython_ADDITIONAL_VERSIONS=$PYTHON_VERSION -DCMAKE_INSTALL_PREFIX=/home/fenics/local/tfel-install &&\
    make &&\ 
    make install 
ENV  PATH ${TFELHOME}/bin:$PATH
ENV  LD_LIBRARY_PATH ${TFELHOME}/lib:$LD_LIBRARY_PATH
ENV  PYTHONPATH=${TFELHOME}/lib/python3.6/site-packages:$PYTHONPATH

RUN cd $MGISSRC && \
    git clone https://github.com/thelfer/MFrontGenericInterfaceSupport.git && \
    mkdir -p build && \
    cd  build && \
    cmake ../MFrontGenericInterfaceSupport -DCMAKE_BUILD_TYPE=Release -Denable-python-bindings=ON -Denable-fortran-bindings=ON -Denable-c-bindings=ON -Denable-fenics-bindings=ON -DCMAKE_INSTALL_PREFIX=/home/fenics/local/mgis-install &&\
    make &&\ 
    make install 
    
ENV  PATH ${MGISHOME}/bin:$PATH
ENV  LD_LIBRARY_PATH ${MGISHOME}/lib:$LD_LIBRARY_PATH
ENV  PYTHONPATH=${MGISHOME}/lib/python3.6/site-packages:$PYTHONPATH    

