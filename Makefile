FILES = ./mod/capump.mod ./mod/spike.mod ./mod/Xtra.mod

all:
	nrnivmodl $(FILES)

mpi:
	nrnivmodl-mpi $(FILES)

clean:
	rm -rf umac x86_64

