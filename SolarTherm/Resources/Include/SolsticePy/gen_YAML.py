import numpy as N

#from data_spectral import SolarSpectrum, MirrorRhoSpectrum

def gen_YAML(DNI, sunshape, sunsize, hst_pos, hst_foc, hst_aims,hst_w, hst_h, rho_refl, slope_error, receiver, rec_param, rec_abs, casefolder, hemisphere='North', tower_h=0.01, tower_r=0.01,  spectral=False, medium=0, OneHeliostat=False ):
    '''
    Arguements:
    (1) the sun
    DNI: float, the direct normal irrandice of solar radiation (W/m2)
    sunshape: str, 'buie' or ' pillbox
    sunsize: float, pillbox half-angle (deg), or Buie CSR value 


    (2) the field
    hst_pos: (n, 3) array, heliostat positions (x, y, z)
    hst_foc: (n, 1) array, heliostat focal length
    hst_aims: (n, 3) array, heliostat aiming point(ax, ay, az)
    hst_w: float, heliostat mirror width (in x direction)
    hst_h: float, heliostat mirror height (in y direction)
    hst_z: float, heliostat center height (in z direction)
    rho_refl: float, reflector reflectivity
    slope_error: float, reflector surface slope error rms, (rad)
    tower_h: float, tower height
    tower_r: float, tower radius (a cylindrical shape tower)

    (3) the receiver
    receiver: str, 'flat', 'cylinder', or 'stl'
    rec_abs: float, receiver absorptivity
    rec_param: numpy array, each element contain the geometrical parameter of the correpsonding receiver
        (1) flat receiver: index 0 is width, 1 is height, 2 is slices, 3- 6 is x, y, z and tilt angle (deg)
        (2) cylinder receiver: index 0 is radius, 1 is height, 2 is slices
        (3) stl: the directory of the stl file

    (4) others
    spectral: bool, if investigate spectral dependent performance 
    medium: float, if the atmosphere is surrounded by non-participant medium, medium=0; otherwise it is the extinction coefficient in m-1

    Return:
    Generation of the YAML inputs for SOLSTICE simulation
    '''

    iyaml='' # the input yaml file

    #
    # Creation of the sun and atmosphere
    #
    if spectral:
        iyaml+='- sun: {dni: %15.8e, spectrum: *solar_spectrum, %s: {half_angle: %6.4f}}\n' % (DNI, sunshape,sunsize) 
    else:
        iyaml+='- sun: {dni: %15.8e, %s: {half_angle: %6.4f}}\n' % (DNI, sunshape,sunsize)  

    if medium>1e-99:
        #iyaml+='- atmosphere: {extinction: *airkext}\n' 
        iyaml+='- atmosphere: {extinction: %s}\n'%medium 
        iyaml+='\n'

           
    # 
    ### Section (3)
    # set the materials
    # (gathering media)
    # occultant material, mirror specular material, receiver material, virtual target
    #------------------------------
    #
    # CREATE an occultant material
    r_f = 0. # front
    r_b = 0. # and back reflectivity
    iyaml+='- material: &%s\n' % 'material_black'
    iyaml+='   front:\n'
    iyaml+='     matte: {reflectivity: %6.4f }\n' % r_f    
    iyaml+='   back:\n'
    iyaml+='     matte: {reflectivity: %6.4f }\n' % r_b
    iyaml+='\n'
    #
    # CREATE a specular material
    r_f= rho_refl # front
    r_b = 0.      # and back reflectivity
    iyaml+='- material: &%s\n' % 'material_mirror'
    iyaml+='   front:\n'
    if spectral:
        iyaml+='     mirror: {reflectivity: *%s, slope_error: %15.8e }\n' % ('ref_mirror', slope_error ) 
    else:
        iyaml+='     mirror: {reflectivity: %6.4f, slope_error: %15.8e }\n' % (r_f, slope_error) 

    iyaml+='   back:\n'
    iyaml+='     matte: {reflectivity: %6.4f }\n' % r_b 
    iyaml+='\n'
    #
    # CREATE a material for the target
    r_f = 1.-rec_abs # front
    r_b = 1.-rec_abs # and back reflectivity
    iyaml+='- material: &%s\n' % 'material_target'
    iyaml+='   front:\n'
    iyaml+='     matte: {reflectivity: %6.4f }\n' % r_f    
    iyaml+='   back:\n'
    iyaml+='     matte: {reflectivity: %6.4f }\n' % r_b
    iyaml+='\n'
    #
    # CREATE a virtual material for the calculation of spillage
    iyaml+='- material: &%s\n' % 'material_virtual'
    iyaml+='   virtual:\n'
    iyaml+='\n'


    # 
    ### Section (4)
    # set the geometries
    # (gathering shapes and materials)
    # the tower, the receiver, the heliostat
    #------------------------------
    #
    # Tower Geometry
    # (cylindrical shape)
    #
    slices = 10 # slices for the envelop circle
    iyaml+='- geometry: &%s\n' % 'tower_g' 
    iyaml+='  - material: *%s\n' % 'material_black' 
    #iyaml+='    transform: { translation: %s, rotation: %s }\n' % ([0, 0, h_tow*0.5], [0, 90, 0]) 
    iyaml+='    cylinder: {height: %7.3f, radius: %7.3f, slices: %d }\n' % (tower_h, tower_r, slices) 
    iyaml+='\n'
    #
    # Receiver Geometry
    #
    if receiver=='flat':
        geom, rec_entt, rcv = flat_receiver(rec_param, hemisphere)
        iyaml+=geom

    elif receiver=='cylinder':
        geom, rec_entt, rcv = cylindrical_receiver(rec_param, hemisphere)
        iyaml+=geom

    elif receiver=='stl':
        rec_entt, rcv=STL_receiver(rec_param, hemisphere)
    #
    # Heliostats Geometry
    #
    if OneHeliostat:
        hst_x=N.r_[hst_pos[0]]
        hst_y=N.r_[hst_pos[1]]
        hst_z=N.r_[hst_pos[2]]
        aim_x=N.r_[hst_aims[0]] 
        aim_y=N.r_[hst_aims[1]]
        aim_z=N.r_[hst_aims[2]]
        num_hst=1
        hst_foc=N.r_[hst_foc]
    else:
        hst_x=hst_pos[:,0]
        hst_y=hst_pos[:,1]
        hst_z=hst_pos[:,2]
        aim_x=hst_aims[:,0]
        aim_y=hst_aims[:,1]
        aim_z=hst_aims[:,2]
        num_hst=len(hst_x)
    slices = 4 # slices for the envelop circle
    pts_hst = [ [-hst_w*0.5, -hst_h*0.5], [-hst_w*0.5, hst_h*0.5], [hst_w*0.5, hst_h*0.5], [hst_w*0.5,-hst_h*0.5] ]
    # CREATE a reflective facet (mirror)
    for i in range(0,num_hst):
        name_hst_g = 'hst_g_'+str(i)
        iyaml+='- geometry: &%s\n' % name_hst_g 
        iyaml+='  - material: *%s\n' % 'material_mirror' 
        #iyaml+='    transform: { translation: %s, rotation: %s }\n' % ([hst_x[i], hst_y[i], hst_z[i]], [0, 0, 0]) )
        iyaml+='    parabol: \n'
        iyaml+='      focal: %s\n' % hst_foc[i]
        iyaml+='      clip: \n'  
        iyaml+='      - operation: AND \n'
        iyaml+='        vertices: %s\n' % pts_hst
        iyaml+='      slices: %d\n' % slices  

    # CREATE the pylon "pylon_g" geometry cylindrical shape
    h_pyl = 0.001 # pylon height
    r_pyl = 0.2 # pylon radius
    slices = 4 # slices for the envelop circle
    iyaml+='- geometry: &%s\n' % 'pylon_g' 
    iyaml+='  - material: *%s\n' % 'material_black' 
    iyaml+='    transform: { translation: %s, rotation: %s }\n' % ([0, 0, -h_pyl*3], [0, 90, 0]) 
    iyaml+='    cylinder: {height: %7.3f, radius: %7.3f, slices: %d }\n' % (h_pyl,r_pyl,slices) 
    #   

    # 
    ### Section (5)
    # set the templates
    # (programming objects gathering geometries or pivot and geometries)
    #------------------------------
    # CREATE the heliostat templates
    for i in range(0,num_hst):    
        name_hst_t = 'hst_t_'+str(i)
        iyaml+='- template: &%s\n' % name_hst_t 
        name_hst_n = 'hst_'+ str(i)
        iyaml+='    name: %s\n' % name_hst_n 
        iyaml+='    primary: 0\n'   
        iyaml+='    geometry: *pylon_g\n'
        iyaml+='    children: \n' 
        iyaml+='    - name: pivot\n'
        iyaml+='      zx_pivot: {target: {position: %s}} \n' % ([aim_x[i],aim_y[i],aim_z[i]]) 
        iyaml+='      children: \n'
        iyaml+='      - name: reflect_surface\n'
        iyaml+='        primary: 1\n'
        iyaml+='        transform: {rotation: [-90,0,0]} \n'   
        name_hst_g = 'hst_g_'+str(i)
        iyaml+='        geometry: *%s\n' % name_hst_g 

    # 
    ### Section (6)
    # set the entities
    # (gather templates to be created and active in the scene)
    #------------------------------
    #
    # receiver entities
    iyaml+=rec_entt
    #
    # tower entities
    iyaml+='\n- entity:\n'
    iyaml+='    name: tower_e\n'
    iyaml+='    primary: 0\n' 
    iyaml+='    transform: { translation: %s, rotation: %s }\n' % ([0, -tower_r, tower_h*0.5], [0, 0, 0]) 
    iyaml+='    geometry: *%s\n' % 'tower_g'    
    #
    # heliostat entities from the template
    for i in range(0,num_hst):
        name_e ='H_'+str(i)
        name_hst_t = 'hst_t_'+str(i)
        iyaml+='\n- entity:\n'
        iyaml+='    name: %s\n' % name_e
        iyaml+='    transform: { translation: %s, rotation: %s }\n' % ([hst_x[i], hst_y[i], hst_z[i]], [0, 0, 0]) 
        iyaml+='    children: [ *%s ]\n' % name_hst_t    

    N.savetxt('%s/input.yaml'%casefolder, [iyaml], fmt='%s')
    N.savetxt('%s/input-rcv.yaml'%casefolder, [rcv], fmt='%s')
  


def flat_receiver(rec_param, hemisphere='North'):
    '''
    hemishpere : 'North' or 'South' hemisphere of the earth where the field located
                if North: the field is in the positive y direction
                if South: the field is in the negtive y direction
                this will influence:
                 (1) the setting of the receiver tilt angle, 
                     if the front surface always facing to the field is desirable
                 (2) the position of the virtual target
    '''
    rec_w=rec_param[0]
    rec_h=rec_param[1]
    slices=rec_param[2]
    x=rec_param[3]
    y=rec_param[4]
    z=rec_param[5]
    tilt=rec_param[6]
    # receiver tilt angle:
    # 0 is vertical
    # the standby posiion of a plane in solstice is normal points to the +z axis
    # rotation anagle, positive is anti-clockwise

    geom=''
    pts=[ [-rec_w*0.5, -rec_h*0.5], [-rec_w*0.5, rec_h*0.5], [rec_w*0.5, rec_h*0.5], [rec_w*0.5,-rec_h*0.5] ]

    geom+='- geometry: &%s\n' % 'target_g'
    geom+='  - material: *%s\n' % 'material_target'
    geom+='    plane: \n'
    geom+='      clip: \n' 
    geom+='      - operation: AND \n'
    geom+='        vertices: %s\n' % pts
    geom+='      slices: %d\n' % slices 
    geom+='\n'

    # CREATE a receiver entity from "target_g" geometry (primary = 0)
    entt=''
    entt+='\n- entity:\n'
    entt+='    name: target_e\n'
    entt+='    primary: 0\n'
    if hemisphere=='North':
        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y, z], [-90.-tilt, 0, 0]) 
    else:
        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y, z], [90.+tilt, 0, 0]) 
    entt+='    geometry: *%s\n' % 'target_g'

    # CREATE a virtual target entity from "target_g" geometry (primary = 0)
    pts = [ [-rec_w*10., -rec_h*10.], [-rec_w*10., rec_h*10.], [rec_w*10., rec_h*10.], [rec_w*10.,-rec_h*10.] ]
    slices = 4
    entt+='\n- entity:\n'
    entt+='    name: virtual_target_e\n'
    entt+='    primary: 0\n'
    if hemisphere=='North':
        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y-5., z], [-90.-tilt, 0, 0])
    else:
        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y+5., z], [90.+tilt, 0, 0])
    entt+='    geometry: \n' 
    entt+='      - material: *%s\n' % 'material_virtual' 
    entt+='        plane: \n'
    entt+='          clip: \n'    
    entt+='          - operation: AND \n'
    entt+='            vertices: %s\n' % pts
    entt+='          slices: %d\n' % slices  

    rcv=''
    rcv+='- name: target_e \n' 
    rcv+='  side: %s \n' % 'FRONT_AND_BACK'
    rcv+='  per_primitive: %s \n' % 'INCOMING_AND_ABSORBED'
    rcv+='- name: virtual_target_e \n'
    rcv+='  side: %s \n' % 'FRONT'
    rcv+='  per_primitive: %s \n' % 'INCOMING'
    
    return geom, entt, rcv
    


def cylindrical_receiver(rec_param, hemisphere='North'):
    '''
    hemishpere : 'North' or 'South' hemisphere of the earth where the field located
                if North: the field is in the positive y direction
                if South: the field is in the negtive y direction
                this will influence:
                 (1) the setting of the receiver tilt angle, 
                     if the front surface always facing to the field is desirable
                 (2) the position of the virtual target
    '''
    rec_r=rec_param[0]
    rec_h=rec_param[1]
    slices=rec_param[2]
    x=rec_param[3]
    y=rec_param[4]
    z=rec_param[5]-rec_r

    geom=''
    geom+='- geometry: &%s\n' % 'target_g'
    geom+='  - material: *%s\n' % 'material_target'
    geom+='    cylinder: \n'
    geom+='      height: %s\n'%rec_h 
    geom+='      radius: %s\n'%rec_r 
    geom+='      slices: %d\n' % slices 
    geom+='\n'

    # CREATE a receiver entity from "target_g" geometry (primary = 0)
    entt=''
    entt+='\n- entity:\n'
    entt+='    name: target_e\n'
    entt+='    primary: 0\n'

    entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y, z], [0., 0., 0.]) 

    entt+='    geometry: *%s\n' % 'target_g'

    # CREATE a virtual target entity from "target_g" geometry (primary = 0)
    Vsize=100.
    pts = [ [-rec_h*Vsize, -rec_h*Vsize], [-rec_h*Vsize, rec_h*Vsize], [rec_h*Vsize, rec_h*Vsize], [rec_h*Vsize,-rec_h*Vsize] ]
    slices = 4
    entt+='\n- entity:\n'
    entt+='    name: virtual_target_e\n'
    entt+='    primary: 0\n'

    entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y, z+rec_h/2.+1], [-180., 0, 0])
 
    entt+='    geometry: \n' 
    entt+='      - material: *%s\n' % 'material_virtual' 
    entt+='        plane: \n'
    entt+='          clip: \n'    
    entt+='          - operation: AND \n'
    entt+='            vertices: %s\n' % pts
    entt+='          slices: %d\n' % slices  

    rcv=''
    rcv+='- name: target_e \n' 
    rcv+='  side: %s \n' % 'FRONT_AND_BACK'
    rcv+='  per_primitive: %s \n' % 'INCOMING_AND_ABSORBED'
    rcv+='- name: virtual_target_e \n'
    rcv+='  side: %s \n' % 'FRONT'
    rcv+='  per_primitive: %s \n' % 'INCOMING'
    
    return geom, entt, rcv



def STL_receiver(rec_param, hemisphere='North'):
    '''
    hemishpere : 'North' or 'South' hemisphere of the earth where the field located
                if North: the field is in the positive y direction
                if South: the field is in the negtive y direction
                this will influence:
                 (1) the setting of the receiver tilt angle, 
                     if the front surface always facing to the field is desirable
                 (2) the position of the virtual target
    '''

    rec_w=rec_param[0].astype(float) # for creating the virtual target
    rec_h=rec_param[1].astype(float)
    stlfile=rec_param[2] # directory of the stl file
    x=rec_param[3].astype(float)
    y=rec_param[4].astype(float)
    z=rec_param[5].astype(float)
    tilt=rec_param[6].astype(float) # need to figure out the initial mesh orientation

    # CREATE a receiver entity from a STL file 
    entt=''
    entt+='\n- entity:\n'
    entt+='    name: STL_receiver_e\n'
    entt+='    primary: 0\n'
    if hemisphere=='North':

        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y, z], [-90.-tilt, 0, 0]) 
    else:
        # if it is the mesh model of the bladed receiver at CSIRO
        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y, z], [180.+tilt, 0, 0]) 
    entt+='    geometry:\n'
    entt+='    - material: *material_target\n'
    entt+='      transform: {translation: [0, 0, 0], rotation: [0, 0, 0]}\n'
    entt+="      stl : {path: %s }  \n"%(stlfile)
 

    # CREATE a virtual target entity from "target_g" geometry (primary = 0)
    pts = [ [-rec_w*10., -rec_h*10.], [-rec_w*10., rec_h*10.], [rec_w*10., rec_h*10.], [rec_w*10.,-rec_h*10.] ]
    slices = 4
    entt+='\n- entity:\n'
    entt+='    name: virtual_target_e\n'
    entt+='    primary: 0\n'
    if hemisphere=='North':
        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y-5., z], [-90.-tilt, 0, 0])
    else:
        entt+='    transform: { translation: %s, rotation: %s }\n' % ([x, y+5., z], [90.+tilt, 0, 0])
    entt+='    geometry: \n' 
    entt+='      - material: *%s\n' % 'material_virtual' 
    entt+='        plane: \n'
    entt+='          clip: \n'    
    entt+='          - operation: AND \n'
    entt+='            vertices: %s\n' % pts
    entt+='          slices: %d\n' % slices  

    rcv=''
    rcv+='- name: STL_receiver_e \n' 
    rcv+='  side: %s \n' % 'FRONT_AND_BACK'
    rcv+='  per_primitive: %s \n' % 'INCOMING_AND_ABSORBED'
    rcv+='- name: virtual_target_e \n'
    rcv+='  side: %s \n' % 'FRONT'
    rcv+='  per_primitive: %s \n' % 'INCOMING'

    return entt, rcv










    #------------------------------
