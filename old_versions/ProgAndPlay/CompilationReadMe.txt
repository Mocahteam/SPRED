Windows Compilation
	Prog&Play compilation and associated interfaces
		Important note: you have to install several dependencies:
			Install MinGW 4.4 and use its make to compile (i.e. mingw32-make). Take these packages:
				* MinGW Runtime - mingwrt (dev & dll)
				* MinGW API for MS-Windows - w32api (dev)
				* GNU Binutils - binutils (bin)
				* GCC 4 - gcc-core (bin & dll)
				* GCC 4 - gcc-c++ (bin & dll)
				* GCC 4 - pthreads (dll)
				* GCC 4 - mpfr (dll)
				* GCC 4 - gmp (dll)
				* GCC 4 - ada (bin & dll)
				* GNU Make - mingw32-make 
				* GNU Source-Level Debugger - gdb (version 6.8-3 or later) 
			Msys (Minimal system), instal it in your C:\ directory => C:\msys\1.0\bin do not have been included in your pass
			For Ocaml, install standard GCC3.4.5 (GCC4.4 is incompatible), instal in C:\MinGW-gcc3.4.5\ directory following packages:
				* MinGW Runtime - mingwrt (dev & dll)
				* MinGW API for MS-Windows - w32api (dev)
				* GNU Binutils - binutils (bin)
				* GCC 3 - gcc-core
				* GCC 3 - gcc-c++
	
		To compile, type: mingw32-make
	
	Spring compilation:
		Change your working directory to spring directory and follow these instructions: http://springrts.com/wiki/Building_Spring_on_Windows
		Note: use sources included in this package, use cmake to compile (do not use scons, that doesn't work to compile Prog&Play included in Spring directory).

Linux compilation
	Prog&Play compilation and associated interfaces
		to compile, just type: make
	Spring compilation:
		Change your working directory to spring directory and follow these instructions: http://springrts.com/wiki/Building_Spring_on_Linux
		Note: use sources included in this package, use cmake to compile (do not use scons, that doesn't work to compile Prog&Play included in Spring directory).