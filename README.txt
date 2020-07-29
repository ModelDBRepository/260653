    -- Last updated Mon 27 Feb 2012 00:36:15 EST

USAGE
    For standard GUI run mode
        make clean && make
        nrngui rgc-ctt3219m.hoc
    
    To run in MPI-compatible batch mode
        make clean && make mpi
        {time mpiexec -np 4 nrniv-mpi -mpi -nogui ./jobs/X.hoc} 2>&1 | tee -a out
            or
        {time mpirun -np 4 nrniv-mpi -mpi -nogui ./jobs/X.hoc} 2>&1 | tee -a out


FILE SUMMARY
    jobs/                    Script files for automated runs
    output/                  Computation output goes here
    regression/              Regression tests for RGCs
    scripts/                 Matlab scripts for data processing

    *.ses                    Session files for setting up the UI
    *.mod                    Model mechanism implementation files

    init-rgc-*.hoc           Initialization files for running RGCs 

    rgc-121203.hoc           Mice RGC with morphology by Kong05 (Masland)
    rgc-121821.hoc           Mice RGC with morphology by Kong05 (Masland)
    rgc-ctt3219m.asc         Salamander simple RGC morphology from Sheasby paper
    rgc-ctt3219m.hoc         Model spec for above
    rgc-lws9287r.asc         Salamander complex RGC morphology from sheasby paper
    rgc-lws9287r.hoc         Model spec for above

    autoThresholdMap.hoc     Computes threshold map automatically, supports MPI
    autoTileThresholdMap.hoc Computes threshold map automatically, supports MPI
    global.hoc               Cell-invariant global definitions
    gui.hoc                  Graphical user interface elements
    instr.hoc                Instrumentations for cells
    interpxyz.hoc            Extracellular stimulation supoort
    stim.hoc                 Extracellular stimulation definition
    util.hoc                 General utility functions

