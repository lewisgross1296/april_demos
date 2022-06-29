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
#        family = MONONIAL
#        order = CONSTANT
#    []
#
#    [heat_source]
#        family = MONOMIAL
#        order = constant
#    []
#    # if you set fluid
#    [density]
#        family = MONOMIAL
#        order = CONSTANT
#    []
#    [fission_tally_std_dev]
#        family = MONOMIAL
#        order = CONSTANT
# []


# INCLUDE IF NO OTHER AUX VARIABLE EXIST TO PREVENT MOOSE BUG
# THAT COMPLAINS ABOUT MAPPING
[AuxVariables]
    [dummy]
    []
[]

[]
[AuxKernels]
    type = ConstantAux
    variable = dummy
    value = 0.0
[]

[ICs]
    [temp]
        type = ConstantIC
        variable = temp
        value = 600.0
    []
[]


[Problem]
    type = OpenMCCellAverageProblem # makes some aux variables for you
    output = 'fission_tally_std_dev'
    power = 500.0 # Watts, need to scale to power for tallies since criticality can occur at any power
    tally_type = mesh
    mesh_template = 'openmc_in.e'
    solid_cell_level = 0
    scaling = 100 # important bc MOOSE uses m and OpenMC uses cm
    solid_blocks = '0' # where to get temperature feedback
    # fluid_blocks = '' # where to get temperature and density feedback
    initial_properties = moose # take openmc material and density properties set in settings.xml
    verbose = true
    particles = 10000 # overrides openmc value, leaves (in)active batches alone
[]

[Executioner]
    type=Transient
    num_steps = 1
[]

[MultiApps]
    [app]
        type = TransientMultiApp
        app_type = CardinalApp
        input_files = 'sub.i'
        execute_on = timestep_end
        sub_cylcing = true
    []
[]


[Transfers]
    [get_temperature_from_sub]
        type = MultiAppNearestNodeTransfer
        source_variable = sub_temp 
        variable = temp
        from_multi_app = app
    []
    [send_heat_source_to_sub]
        type =MultiAppNearestNodeTransfer
        source_variable = heat_source
        variable = openmc_heat_source
        to_multi_app = app

        from_postprrocessor_to_be_preserved = total_openmc_source
        to_postprocessor_to_be_preserved = total_received_source
    []

[]

[Postprocessors]
    [total_openmc_source]
        type = ElementIntegralVariablePostprocessor
        variable = heat_source
    []
[]

[Outputs]
    exodus = true
[]