from distutils.core import setup

setup(name='solartherm',
		version='0.1',
		package_dir={'': '/home/parallels/na-salt-hx/SolarTherm/src/python'},
		packages=['solartherm'],
		scripts=[
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_wea_to_mo',
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_plotmat',
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_simulate',
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_optimise',
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_get_aemo_prices',
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_inspect',
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_conv_sam_hourly',
			'/home/parallels/na-salt-hx/SolarTherm/src/python/scripts/st_cost',
			]
		)
