all: ss cos

ss:
		ifort -o ss src/signal_sum.f90 -Ldirectory -lfftw3

cos:
		ifort -o cos src/cosinus.f90 -Ldirectory -lfftw3
