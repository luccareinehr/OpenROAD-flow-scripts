export DESIGN_NICKNAME = openfasoc_tempsense
export DESIGN_NAME = tempsenseInst_error

export PLATFORM    = sky130hd

export VERILOG_FILES 		= $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v)) \
			  	  ./designs/src/$(DESIGN_NICKNAME)/tempsenseInst.blackbox.v
export SDC_FILE    		= ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DIE_AREA   	 	= 0 0 155.48 146.88
export CORE_AREA   		= 18.4 16.32 137.08 130.56

# area of the smaller voltage domain
export VD1_AREA                 = 33.58 32.64 64.86 62.56

# power delivery network config file
export PDN_CFG 			= ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.cfg

export ADDITIONAL_LEFS  	= ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/lef/HEADER.lef \
                        	  ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/lef/SLC.lef

export ADDITIONAL_GDS_FILES 	= ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/gds/HEADER.gds \
			      	  ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/gds/SLC.gds

# informs what cells should be placed in the smaller voltage domain
export DOMAIN_INSTS_LIST 	= ./designs/src/$(DESIGN_NICKNAME)/tempsenseInst_domain_insts.txt

# export CUSTOM_CONNECTION 	= ../blocks/$(PLATFORM)/tempsenseInst_custom_net.txt

export ADD_NDR_RULE		= 1
export NDR_RULE_NETS 		= r_VIN
export NDR_RULE 		= NDR_2W_2S

export GALLERY_REPORT = 1
