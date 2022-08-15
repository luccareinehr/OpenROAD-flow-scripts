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

# configuration for placement
#-------------------------------------------------------------------------------
# don't run global place w/o IOs
export HAS_IO_CONSTRAINTS = 1
# don't run non-random IO placement (step 3_2)
export PLACE_PINS_ARGS = -random

export GPL_ROUTABILITY_DRIVEN = 1

# DPO currently fails on the tempsense
export ENABLE_DPO = 0

#export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
#export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

# configuration for routing
#-------------------------------------------------------------------------------
export PRE_GLOBAL_ROUTE = $(SCRIPTS_DIR)/openfasoc/pre_global_route.tcl

# informs any short circuits that should be forced during routing
export CUSTOM_CONNECTION 	= ./designs/src/$(DESIGN_NICKNAME)/tempsenseInst_custom_net.txt
