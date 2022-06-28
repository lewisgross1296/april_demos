# script scope variables
element_size_in_x_direction = 0.2
ix_custom = ${fparse 6 * sqrt(5)}
# ix_custom = ${fparse 6 * sqrt(5)}
[Mesh]
    [cube]
        type=CartesianMeshGenerator
        dim=3
        dx = ${ fparse ix_custom * element_size_in_x_direction}
        dx = 1.0
        dy = 1.0
        dz = 1.0
        ix = ${ix_custom}
        iy = 3
        iz = 3
    [shift]
        type = TransformGenerator
        input = cube
        transform = TRANSLATE
        vector_value = ‘-1.0 0 0 ‘’
    []
[]

[Variables]
    [temp]
    # family = LAGRANGE
    # order = FIRST
    []
[]
[Kernels]
    [conduction]
        type = HeatConduction
        variable = temp
        # diffusion_coefficient = thermal_conductivity
    []
[]

[Materials]
    [steel]
        type = GenericConstantMateriral
        prop_names = ‘thermal_conductivity’
        prop_value = ‘5.0’
    []
[]

[BCs]
    [left]
        type = DirichletBC
        variable = temp
        boundary = left
        value = 400
    []
    [interface]
        type = MatchedValueBC
        variable = temp
        boundary = right
        v = received_temperrature
    [insulated]
        type = NeumanBC
        variable = temp
        boundary = ‘top bottom front back’
        value = 0.0’
    []
[]

[AuxVarirables]
    [received_temperature]
    # family = LAGRANGE
    # order = FIRST
    initial_condition = 300.0
    []
    [flux]
    family = MONOMIAL
    order = CONSTANT
    []
[]

[AuxKernel]
    [flux]
    type = DiffusionFluxAux
    variable = flux
    component = norrmal
    diffusivity = thermal_conductivity
    boundary = 'right'
    []
[]

[Executioner]
    type = Transient
    dt = 1
    num_steps = 5
    nl_abs_tol = 1e-8
    []
[]

[MultiApps]
    [app]
    type = TransientMultiApp
    input = ‘sub.i’
    app_type = CardinalApp
    subcycling = true
    Execute_on = timestep_end
[]

[Transfers]
    [from_sub_to_main]
        type = MultiAppNearestNodeTransfer
        source_variable = temp
        variable = received_temperature
        from_multi_app = app
        target_boundary = 'right'
        source_boundary = 'left'
    [from_main_to_sub_flux]
        type = MultiAppNearestNodeTransfer
        source_variable = flux
        variable = received_flux
        to_multi_app = app
    []    
[]
