<<<<<<< HEAD
# SitLog
SitLog is a declarative situation-oriented logical language for programming situated service robots’ tasks. The formalism is task and domain independent and can be used in a wide variety of settings. SitLog can also be seen as a behavior engineering specification and interpretation formalism to support action selection by autonomous agents during the execution of complex tasks. For more details see the paper [SitLog: A Programming Language for Service Robot Tasks](https://doi.org/10.5772/56906).

SitLog is used by the robot [Golem III](http://golem.iimas.unam.mx/home.php?lang=en&sec=home) to perfomed several behaviors and various complex tasks. Therefore, two possible modes of execution of SitLog are available, *test* and *actual*. Since the actual mode is meant to be run on a real agent or robot, in this README we discuss how to set up the test mode. The configuration of SitLog in a real robot varies slightly.

SitLog interpreter is written in Prolog and SitLog’s programs follow closely the Prolog notation, permitting the declarative specification and direct interpretation of complex applications in a modular and compact form. SitLog runs on SWI Prolog (swipl) version 6.6.6. To install such a version in a computer with Ubuntu Operating System perform the following steps.

   1. Download the compressed file found [here](https://www.swi-prolog.org/download/stable/src/pl-6.6.6.tar.gz). 
   2. Open a terminal and run the next command to install the needed libraries:

    sudo apt-get install \
      build-essential cmake ninja-build pkg-config \
      ncurses-dev libreadline-dev libedit-dev \
      libunwind-dev \
      libgmp-dev \
      libssl-dev \
      unixodbc-dev \
      zlib1g-dev libarchive-dev \
      libossp-uuid-dev \
      libxext-dev libice-dev libjpeg-dev libxinerama-dev libxft-dev \
      libxpm-dev libxt-dev \
      libdb-dev \
      libpcre3-dev \
      libyaml-dev \
      default-jdk junit


   3. Open another terminal and change the directory to where the downloaded file in step 1 is located. After that run the commands:

    $ tar zxvf pl-6.6.6.tar.gz
    $ cd pl-6.6.6/src
    $ ./configure
    $ make
    $ sudo make install
        

At this point, a basic version of swipl has been installed, however, some extra packages are missing so we run the next commands to install them.

    $ cd ../packages
    Note: In the next step, a Java compilation error may ocurr.
          Simply ignore it since we can proceed with a successful
	  compilation and installation of swipl executing the rest
	  of the instructions.
    $ ./configure
    $ make
    $ sudo make install


The final setting that must be perfomed to have SitLog running is to add an environment variable indicating the path of this repository on your computer. Append the following to the file ~/.bashrc

    export SITLOG_HOME=/path_in_your_computer/source_code/


You are ready to run SitLog programs in test mode. Now, we are going to describe the execution of the sample code 
=======
# source_code
>>>>>>> 27349e4aadfcdc1d50ed6993f6d9d8f3872342e1
