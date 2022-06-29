[Mesh]
  [cube]
    type = CartesianMeshGenerator
    dim = 3
    dx = 1.0
    dy = 1.0
    dz = 1.0
    ix = 12
    iy = 12
    iz = 12
  []
[]

[Variables]
  [sub_temp]
    # family = LAGRANGE
    # order = FIRST
  []
[]

[Kernels]
  [diffusion]
    type = HeatConduction
    variable = sub_temp
    # diffusion_coefficient = thermal_conductivity
  []
  [source_from_openmc]
    type = CoupledForce
    variable = sub_temp
    v = openmc_heat_source
  []
[]

[Materials]
  [steel]
     type = GenericConstantMaterial
     prop_names = 'thermal_conductivity'
     prop_values = '10.0'
  []
[]

[BCs]
  [right]
    type = DirichletBC
    variable = sub_temp
    boundary = 'right'
    value = 500.0
  []
[]

[AuxVariables]
  [openmc_heat_source]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Postprocessors]
  [total_received_source]
    type = ElementIntegralVariablePostprocessor
    variable = openmc_heat_source
    execute_on = 'transfer initial'
  []
[]


[Executioner]
  type = Transient
  dt = 0.3

  nl_abs_tol = 1e-8
[]

[Outputs]
  exodus = true
[]
