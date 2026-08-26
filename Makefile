COMMON_RTL = \
	rtl/common/Adder.v \
	rtl/common/ALU.v \
	rtl/common/ALUControl.v \
	rtl/common/Comparator.v \
	rtl/common/Mux2x15Bits.v \
	rtl/common/Mux2x110Bits.v \
	rtl/common/Mux2x132Bits.v \
	rtl/common/Mux3x132Bits.v \
	rtl/common/Mux4x132Bits.v \
	rtl/common/ShiftLeft.v \
	rtl/common/SignExtend.v \
	rtl/control/ControlUnit.v \
	rtl/control/Forwarding.v \
	rtl/control/Hazard.v \
	rtl/datapath/PC.v \
	rtl/datapath/RegisterFile.v \
	rtl/datapath/InstructionMemory.v \
	rtl/pipeline/IF_ID_Reg.v \
	rtl/pipeline/ID_EX_Reg.v \
	rtl/pipeline/EX_Mem_Reg.v \
	rtl/pipeline/Mem_Wb_Reg.v \
	rtl/pipeline/Mem1_Mem2_Reg.v

FIVE_STAGE_RTL = \
	$(COMMON_RTL) \
	rtl/five_stage/DataMemory.v \
	rtl/five_stage/MipsPipeline.v

SIX_STAGE_RTL = \
	$(COMMON_RTL) \
	rtl/six_stage/DataMemory.v \
	rtl/six_stage/MipsPipeline.v

IVERILOG ?= iverilog
VVP      ?= vvp
IVFLAGS  ?= -g2005 -Wall

.PHONY: all test sim5 sim6 hazards clean

all: test

sim:
	mkdir -p sim

sim/tb_five_stage.vvp: | sim
sim/tb_five_stage.vvp: $(FIVE_STAGE_RTL) tb/tb_five_stage.v
	$(IVERILOG) $(IVFLAGS) -o $@ $(FIVE_STAGE_RTL) tb/tb_five_stage.v

sim/tb_hazards.vvp: | sim
sim/tb_hazards.vvp: $(FIVE_STAGE_RTL) tb/tb_hazards.v
	$(IVERILOG) $(IVFLAGS) -o $@ $(FIVE_STAGE_RTL) tb/tb_hazards.v

sim/tb_six_stage.vvp: | sim
sim/tb_six_stage.vvp: $(SIX_STAGE_RTL) tb/tb_six_stage.v
	$(IVERILOG) $(IVFLAGS) -o $@ $(SIX_STAGE_RTL) tb/tb_six_stage.v

# Programs are read with $readmemh at elaboration time, so every simulation
# must run from the repository root.
sim5: sim/tb_five_stage.vvp
	$(VVP) $<

hazards: sim/tb_hazards.vvp
	$(VVP) $<

sim6: sim/tb_six_stage.vvp
	$(VVP) $<

test: sim5 hazards sim6

clean:
	rm -rf sim/*.vvp sim/*.vcd
