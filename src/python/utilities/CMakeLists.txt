file(COPY st_wea_to_mo.py DESTINATION .)
	#FILE_PERMISSIONS OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
# if going to set permissions need to set them all

install(PROGRAMS st_wea_to_mo.py RENAME st_wea_to_mo
	DESTINATION bin)
