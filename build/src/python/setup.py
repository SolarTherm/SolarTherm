from distutils.core import setup

setup(name='solartherm',
		version='0.1',
		package_dir={'': '/home/admin-u5277975/SolarTherm/src/python'},
		packages=['solartherm'],
		scripts=[
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_wea_to_mo',
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_plotmat',
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_simulate',
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_optimise',
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_get_aemo_prices',
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_inspect',
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_conv_sam_hourly',
			'/home/admin-u5277975/SolarTherm/src/python/scripts/st_cost',
			]
		)
