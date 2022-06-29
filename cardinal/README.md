# import openmc to test python API
`python`
`import openmc`
# run openmc simulation
python make_openmc_model.py
# to test the mesh
~/caridnal/cardinal-opt -i openmc.i --mesh-only
# run cardinl simulation using mpi paralellism and openmp parallelism
mpiexec -np 4 ~/cardinal/cardinal-opt -i openmc.i --n-threads=20