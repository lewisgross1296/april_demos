import openmc
# uranium oxide materiral
uo2 = openmc.Material()
uo2.set_density('g/cc', 10.0)
uo2.add_element('U', 1.0, enrichment=5.0)
uo2.add_element('O', 2.0)

water = openmc.Material()
water.set_density('g/cc',1.0)
water.add_element('H',2.0)
water.add_element('O',1.0)

mats = openmc.Materials([uo2,water])
mats.export_to_xml()

# set up geometry
H = 100.0 # cm
xplane0 = openmc.XPlane(x0  = 0.0)
xplane1 = openmc.XPlane(x0 = H)
yplane0 = openmc.YPlane(y0 = 0.0)
yplane1 = openmc.YPlane(y0 = H)
zplane0 = openmc.ZPlane(z0 = 0.0)
zplane1 = openmc.Zplane(z0 = H)

R = 180.0
sphere = openmc.Sphere(r=R,boundary_type='vaccuum')


# make cell defining uo2 cube
cube_region =+xplane0 & -xplane1 & +yplane0 & -yplane1 & +zplane0 & -zplane, fill=uo2
fuel_cell = openmc.Cell(region=cube_region, fill=uo2 )
water_cell = openmc.Cell(region=~cube_region,fill=water)

geom = openmc.Geometry([fuel_celll,water_cell])
geom.export_to_xml()

# Finally, define some run settings
settings = openmc.Settings()
settings.batches = 50
settings.inactive = 10
settings.particles = 100


lower_left = (0.0, 0.0, 0.0)
upper_right = (H, H, H)
uniform_dist = openmc.stats.Box(lower_left, upper_right, only_fissionable=True)
settings.source = openmc.source.Source(space=uniform_dist)

settings.temperature = {'default': 600.0,
                        'method': 'interpolation',
                        'range': (294.0, 1600.0)} # good to load all temperatures you could encounter in multiphysics

solid_cell1 = openmc.Cell(fill=uo2, region=-sphere1)
geom = openmc.Geometry([solid_cell1])
geom.export_to_xml()

settings.export_to_xml()
