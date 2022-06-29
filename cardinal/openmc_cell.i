[Mesh]
    [cube]
    type=CartesianMeshGenerator
    dim = 3
    dx = 1.0
    dy = 1.0
    dz = 1.0
    ix = 5
    iy = 5
    iz = 5
    []
[]

# [AuxVariables]
#    # always set
#    [temp]
#    family = MONONIAL
#    order = CONSTANT
#    []
#
#    [heat_source]
#    family = MONOMIAL
#    order = constant
#    []
#    # if you set fluid
#    [density]
#    family = MONOMIAL
#    order = CONSTANT
#    []
# []


[ICs]
    [temp]
    type = ConstantIC
    variable = temp
    value = 600.0
    []
[]


[Problem]
    type = OpenMCCellAverageProblem # makes some aux variables for ryou
    power = 500.0 # Watts, need to scale to power for tallies since criticality can occur at any power
    tally_type = cell
    tally_blocks = '0'
    scaling = 100 # important bc MOOSE uses m and OpenMC uses cm
    solid_blocks = '0' # where to get temperature feedback
    # fluid_blocks = '' # where to get temperature and density feedback
    initial_properties = xml # take openmc material and density properties set in settings.xml
    verbose = true
[]

[Executioner]
    type=Transient
    num_steps = 1
[]

[Outputs]
    exodus = true
[]