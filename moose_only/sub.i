[Mesh]
    [cube]
        type=CartesianMeshGenerator
        dim=3
        dx = 1.0 
        dx = 1.0
        dy = 1.0
        dz = 1.0
        ix = 2
        iy = 3
        iz = 1
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
        prop_value = ‘50.0’
    []
[]

[BCs]
    [right]
        type = DirichletBC
        variable = temp
        boundary = ‘right’
        value = 100.0
    []
    [crazy]
        type = CoypledVarNeumannBC
        variable = temp
        boundary = ‘left’
        v = received_flux
    [insulated]
        Type = NeumanBC
        Variable = temp
        Boundary = ‘top bottom front back’
        value = 0.0’
    []
[]

[AuxVarirables]
    [received_flux]
    # family = LAGRANGE
    # order = FIRST
    initial_condition = 5000.0
    []
[]

[Executioner]
    type = Transient
    dt = 0.3
    nl_abs_tol = 1e-8
[]

[Output]
    []
    family = LAGRANGE
    order = FIRST
    []
[]
