


python
import openmc to test

python make_openmc_model.py

mpiexec -np 4 ~/cardinal/cardinal-opt -i openmc.i --n-threads=20



# to run
~/caridnal/cardinal-opt -i openmc.i --mesh-only