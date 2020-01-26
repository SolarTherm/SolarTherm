from distutils.core import setup

setup(name='solartherm',
		version='0.1',
		package_dir={'': '/home/parallels/SolarTherm/src/python'},
		packages=['solartherm'],
		scripts=[
			'/home/parallels/SolarTherm/src/python/scripts/st_wea_to_mo',
			'/home/parallels/SolarTherm/src/python/scripts/st_plotmat',
			'/home/parallels/SolarTherm/src/python/scripts/st_simulate',
			'/home/parallels/SolarTherm/src/python/scripts/st_optimise',
			'/home/parallels/SolarTherm/src/python/scripts/st_get_aemo_prices',
			'/home/parallels/SolarTherm/src/python/scripts/st_inspect',
			'/home/parallels/SolarTherm/src/python/scripts/st_conv_sam_hourly',
			'/home/parallels/SolarTherm/src/python/scripts/st_cost',
			]
		)
