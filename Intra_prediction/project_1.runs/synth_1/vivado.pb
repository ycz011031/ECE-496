
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2$
create_project: 2default:default2
00:00:062default:default2
00:00:062default:default2
1002.8202default:default2
118.7032default:defaultZ17-268h px� 
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental {C:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/utils_1/imports/synth_1/intra16x16_dc_prediction.dcp}2default:defaultZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2�
�C:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/utils_1/imports/synth_1/intra16x16_dc_prediction.dcp2default:defaultZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
~
Command: %s
53*	vivadotcl2M
9synth_design -top intra16x16_top -part xc7a200tlfbg676-2L2default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
	xc7a200tl2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
	xc7a200tl2default:defaultZ17-349h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
22default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
a
#Helper process launched with PID %s4824*oasys2
1010522default:defaultZ8-7075h px� 
�
5undeclared symbol '%s', assumed default net type '%s'7502*oasys2
REGCCE2default:default2
wire2default:default2[
EC:/Xilinx/Vivado/2022.2/data/verilog/src/unimacro/BRAM_SINGLE_MACRO.v2default:default2
21702default:default8@Z8-11241h px� 
�
%s*synth2�
tStarting Synthesize : Time (s): cpu = 00:00:08 ; elapsed = 00:00:08 . Memory (MB): peak = 1442.402 ; gain = 407.160
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys2"
intra16x16_top2default:default2
 2default:default2�
kC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Top.v2default:default2
12default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2!
DC_prediction2default:default2
 2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
12default:default8@Z8-6157h px� 
�
default block is never used226*oasys2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
532default:default8@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2!
DC_prediction2default:default2
 2default:default2
02default:default2
12default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
12default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2)
Horizontal_prediction2default:default2
 2default:default2�
}C:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Horizontal_prediction.v2default:default2
12default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2)
Horizontal_prediction2default:default2
 2default:default2
02default:default2
12default:default2�
}C:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Horizontal_prediction.v2default:default2
12default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2'
Vertical_prediction2default:default2
 2default:default2�
{C:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Vertical_prediction.v2default:default2
12default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2'
Vertical_prediction2default:default2
 2default:default2
02default:default2
12default:default2�
{C:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Vertical_prediction.v2default:default2
12default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2$
Plane_prediction2default:default2
 2default:default2�
yC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Planer_prediction.v2default:default2
12default:default8@Z8-6157h px� 
�
default block is never used226*oasys2�
yC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Planer_prediction.v2default:default2
552default:default8@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2$
Plane_prediction2default:default2
 2default:default2
02default:default2
12default:default2�
yC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Planer_prediction.v2default:default2
12default:default8@Z8-6155h px� 
�
default block is never used226*oasys2�
kC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Top.v2default:default2
662default:default8@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2"
intra16x16_top2default:default2
 2default:default2
02default:default2
12default:default2�
kC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/Top.v2default:default2
12default:default8@Z8-6155h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2
j_reg2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
482default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[15][15]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[15][14]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[15][13]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[15][12]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[15][11]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[15][10]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][9]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][8]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][7]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][6]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][5]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][4]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][3]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][2]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][1]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[15][0]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[14][15]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[14][14]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[14][13]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[14][12]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[14][11]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[14][10]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][9]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][8]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][7]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][6]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][5]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][4]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][3]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][2]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][1]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[14][0]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[13][15]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[13][14]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[13][13]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[13][12]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[13][11]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[13][10]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][9]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][8]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][7]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][6]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][5]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][4]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][3]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][2]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][1]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[13][0]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[12][15]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[12][14]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[12][13]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[12][12]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[12][11]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[12][10]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][9]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][8]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][7]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][6]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][5]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][4]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][3]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][2]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][1]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[12][0]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[11][15]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[11][14]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[11][13]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[11][12]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[11][11]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[11][10]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][9]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][8]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][7]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][6]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][5]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][4]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][3]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][2]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][1]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[11][0]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[10][15]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[10][14]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[10][13]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[10][12]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[10][11]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
prediction_reg[10][10]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][9]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][8]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][7]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][6]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][5]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][4]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][3]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][2]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][1]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[10][0]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[9][15]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[9][14]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2)
prediction_reg[9][13]2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
882default:default8@Z8-6014h px� 
�
�Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2 
Synth 8-60142default:default2
1002default:defaultZ17-14h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[15][15]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[15][14]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[15][13]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[15][12]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[15][11]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[15][10]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][9]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][8]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][7]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][6]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][5]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][4]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][3]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][2]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][1]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[15][0]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[14][15]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[14][14]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[14][13]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[14][12]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[14][11]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[14][10]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][9]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][8]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][7]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][6]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][5]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][4]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][3]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][2]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][1]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[14][0]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[13][15]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[13][14]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[13][13]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[13][12]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[13][11]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[13][10]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][9]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][8]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][7]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][6]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][5]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][4]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][3]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][2]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][1]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[13][0]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[12][15]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[12][14]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[12][13]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[12][12]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[12][11]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[12][10]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][9]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][8]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][7]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][6]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][5]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][4]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][3]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][2]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][1]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[12][0]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[11][15]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[11][14]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[11][13]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[11][12]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[11][11]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[11][10]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][9]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][8]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][7]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][6]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][5]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][4]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][3]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][2]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][1]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[11][0]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[10][15]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[10][14]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[10][13]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[10][12]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[10][11]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2(
residual_reg[10][10]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][9]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][8]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][7]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][6]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][5]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][4]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][3]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][2]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][1]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[10][0]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[9][15]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[9][14]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[9][13]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2'
residual_reg[9][12]2default:default2!
DC_prediction2default:default2�
uC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/sources_1/new/DC_prediction.v2default:default2
892default:default8@Z8-7137h px� 
�
�Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2 
Synth 8-71372default:default2
1002default:defaultZ17-14h px� 
�
%s*synth2�
tFinished Synthesize : Time (s): cpu = 00:00:19 ; elapsed = 00:00:20 . Memory (MB): peak = 1816.844 ; gain = 781.602
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
Finished Constraint Validation : Time (s): cpu = 00:00:21 ; elapsed = 00:00:22 . Memory (MB): peak = 1816.844 ; gain = 781.602
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Loading part: xc7a200tlfbg676-2L
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:21 ; elapsed = 00:00:22 . Memory (MB): peak = 1816.844 ; gain = 781.602
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Y
Loading part %s157*device2&
xc7a200tlfbg676-2L2default:defaultZ21-403h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
I
%s
*synth21
Start Preparing Guide Design
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
�The reference checkpoint %s is not suitable for use with incremental synthesis for this design. Please regenerate the checkpoint for this design with -incremental_synth switch in the same Vivado session that synth_design has been run. Synthesis will continue with the default flow4740*oasys2�
�C:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.srcs/utils_1/imports/synth_1/intra16x16_dc_prediction.dcp2default:defaultZ8-6895h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
|Finished Doing Graph Differ : Time (s): cpu = 00:00:24 ; elapsed = 00:00:24 . Memory (MB): peak = 1816.844 ; gain = 781.602
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Preparing Guide Design : Time (s): cpu = 00:00:24 ; elapsed = 00:00:24 . Memory (MB): peak = 1816.844 ; gain = 781.602
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2default:default2!
DC_prediction2default:defaultZ8-802h px� 
�
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2default:default2)
Horizontal_prediction2default:defaultZ8-802h px� 
�
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2default:default2'
Vertical_prediction2default:defaultZ8-802h px� 
�
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2default:default2$
Plane_prediction2default:defaultZ8-802h px� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2s
_                    IDLE |                             0001 |                               00
2default:defaulth p
x
� 
�
%s
*synth2s
_                CALC_SUM |                             0010 |                               01
2default:defaulth p
x
� 
�
%s
*synth2s
_               CALC_MEAN |                             0100 |                               10
2default:defaulth p
x
� 
�
%s
*synth2s
_           CALC_RESIDUAL |                             1000 |                               11
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2default:default2
one-hot2default:default2!
DC_prediction2default:defaultZ8-3354h px� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2s
_                    IDLE |                              001 |                               00
2default:defaulth p
x
� 
�
%s
*synth2s
_                 PREDICT |                              010 |                               01
2default:defaulth p
x
� 
�
%s
*synth2s
_           CALC_RESIDUAL |                              100 |                               10
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2default:default2
one-hot2default:default2)
Horizontal_prediction2default:defaultZ8-3354h px� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2s
_                    IDLE |                              001 |                               00
2default:defaulth p
x
� 
�
%s
*synth2s
_                 PREDICT |                              010 |                               01
2default:defaulth p
x
� 
�
%s
*synth2s
_           CALC_RESIDUAL |                              100 |                               10
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2default:default2
one-hot2default:default2'
Vertical_prediction2default:defaultZ8-3354h px� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2s
_                    IDLE |                               00 |                               00
2default:defaulth p
x
� 
�
%s
*synth2s
_                CALC_H_V |                               01 |                               01
2default:defaulth p
x
� 
�
%s
*synth2s
_               CALC_PRED |                               10 |                               10
2default:defaulth p
x
� 
�
%s
*synth2s
_           CALC_RESIDUAL |                               11 |                               11
2default:defaulth p
x
� 
�
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2default:default2

sequential2default:default2$
Plane_prediction2default:defaultZ8-3354h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:33 ; elapsed = 00:00:31 . Memory (MB): peak = 1816.844 ; gain = 781.602
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
U
%s
*synth2=
)

Incremental Synthesis Report Summary:

2default:defaulth p
x
� 
N
%s
*synth26
"1. Incremental synthesis run: no

2default:defaulth p
x
� 
a
%s
*synth2I
5   Reason for not running incremental synthesis : 


2default:defaulth p
x
� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}4868*oasysZ8-7130h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   32 Bit       Adders := 13    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input   32 Bit       Adders := 10    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    8 Bit       Adders := 64    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    6 Bit       Adders := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    5 Bit       Adders := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	             2048 Bit    Registers := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               32 Bit    Registers := 6     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               16 Bit    Registers := 3     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                8 Bit    Registers := 1553  
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                5 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 4     
2default:defaulth p
x
� 
?
%s
*synth2'
+---Multipliers : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	               6x32  Multipliers := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	               4x32  Multipliers := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	              16x32  Multipliers := 8     
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input 2048 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   32 Bit        Muxes := 7     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input   32 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input   32 Bit        Muxes := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    7 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    5 Bit        Muxes := 4     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    5 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    2 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    1 Bit        Muxes := 37    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    1 Bit        Muxes := 74    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    1 Bit        Muxes := 60    
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2m
YPart Resources:
DSPs: 740 (col length:100)
BRAMs: 730 (col length: RAMB18 100 RAMB36 50)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
c
%s
*synth2K
7DSP Report: Generating DSP V1, operation Mode is: A*B.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator V1 is absorbed into DSP V1.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator V1 is absorbed into DSP V1.
2default:defaulth p
x
� 
n
%s
*synth2V
BDSP Report: Generating DSP V1, operation Mode is: (PCIN>>17)+A*B.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator V1 is absorbed into DSP V1.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator V1 is absorbed into DSP V1.
2default:defaulth p
x
� 
h
%s
*synth2P
<DSP Report: Generating DSP p_1_out, operation Mode is: A*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_1_out is absorbed into DSP p_1_out.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_1_out is absorbed into DSP p_1_out.
2default:defaulth p
x
� 
s
%s
*synth2[
GDSP Report: Generating DSP p_1_out, operation Mode is: (PCIN>>17)+A*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_1_out is absorbed into DSP p_1_out.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_1_out is absorbed into DSP p_1_out.
2default:defaulth p
x
� 
c
%s
*synth2K
7DSP Report: Generating DSP H1, operation Mode is: A*B.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator H1 is absorbed into DSP H1.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator H1 is absorbed into DSP H1.
2default:defaulth p
x
� 
n
%s
*synth2V
BDSP Report: Generating DSP H1, operation Mode is: (PCIN>>17)+A*B.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator H1 is absorbed into DSP H1.
2default:defaulth p
x
� 
]
%s
*synth2E
1DSP Report: operator H1 is absorbed into DSP H1.
2default:defaulth p
x
� 
q
%s
*synth2Y
EDSP Report: Generating DSP p_0_out, operation Mode is: (A:0x1ff9)*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_0_out is absorbed into DSP p_0_out.
2default:defaulth p
x
� 
|
%s
*synth2d
PDSP Report: Generating DSP p_2_out, operation Mode is: PCIN+(A:0x0):B+(C:0x10).
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_2_out is absorbed into DSP p_2_out.
2default:defaulth p
x
� 
q
%s
*synth2Y
EDSP Report: Generating DSP p_0_out, operation Mode is: (A:0x1ffa)*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_0_out is absorbed into DSP p_0_out.
2default:defaulth p
x
� 
|
%s
*synth2d
PDSP Report: Generating DSP p_2_out, operation Mode is: PCIN+(A:0x0):B+(C:0x10).
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_2_out is absorbed into DSP p_2_out.
2default:defaulth p
x
� 
q
%s
*synth2Y
EDSP Report: Generating DSP p_0_out, operation Mode is: (A:0x1ffb)*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_0_out is absorbed into DSP p_0_out.
2default:defaulth p
x
� 
|
%s
*synth2d
PDSP Report: Generating DSP p_2_out, operation Mode is: PCIN+(A:0x0):B+(C:0x10).
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_2_out is absorbed into DSP p_2_out.
2default:defaulth p
x
� 
q
%s
*synth2Y
EDSP Report: Generating DSP p_0_out, operation Mode is: (A:0x1ffc)*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_0_out is absorbed into DSP p_0_out.
2default:defaulth p
x
� 
|
%s
*synth2d
PDSP Report: Generating DSP p_2_out, operation Mode is: PCIN+(A:0x0):B+(C:0x10).
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_2_out is absorbed into DSP p_2_out.
2default:defaulth p
x
� 
q
%s
*synth2Y
EDSP Report: Generating DSP p_0_out, operation Mode is: (A:0x1ffd)*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_0_out is absorbed into DSP p_0_out.
2default:defaulth p
x
� 
|
%s
*synth2d
PDSP Report: Generating DSP p_2_out, operation Mode is: PCIN+(A:0x0):B+(C:0x10).
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_2_out is absorbed into DSP p_2_out.
2default:defaulth p
x
� 
q
%s
*synth2Y
EDSP Report: Generating DSP p_0_out, operation Mode is: (A:0x1ffe)*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_0_out is absorbed into DSP p_0_out.
2default:defaulth p
x
� 
|
%s
*synth2d
PDSP Report: Generating DSP p_2_out, operation Mode is: PCIN+(A:0x0):B+(C:0x10).
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_2_out is absorbed into DSP p_2_out.
2default:defaulth p
x
� 
q
%s
*synth2Y
EDSP Report: Generating DSP p_0_out, operation Mode is: (A:0x1fff)*B.
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_0_out is absorbed into DSP p_0_out.
2default:defaulth p
x
� 
|
%s
*synth2d
PDSP Report: Generating DSP p_2_out, operation Mode is: PCIN+(A:0x0):B+(C:0x10).
2default:defaulth p
x
� 
g
%s
*synth2O
;DSP Report: operator p_2_out is absorbed into DSP p_2_out.
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:01:28 ; elapsed = 00:01:33 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
�
%s*synth2p
\
DSP: Preliminary Mapping Report (see note below. The ' indicates corresponding REG is set)
2default:defaulth px� 
�
%s*synth2�
�+-----------------+-------------------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth px� 
�
%s*synth2�
�|Module Name      | DSP Mapping             | A Size | B Size | C Size | D Size | P Size | AREG | BREG | CREG | DREG | ADREG | MREG | PREG | 
2default:defaulth px� 
�
%s*synth2�
�+-----------------+-------------------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | A*B                     | 18     | 7      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (PCIN>>17)+A*B          | 16     | 7      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | A*B                     | 18     | 17     | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (PCIN>>17)+A*B          | 17     | 16     | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | A*B                     | 18     | 7      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (PCIN>>17)+A*B          | 16     | 7      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (A:0x1ff9)*B            | 13     | 13     | -      | -      | 26     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | PCIN+(A:0x0):B+(C:0x10) | 30     | 13     | 5      | -      | -1     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (A:0x1ffa)*B            | 13     | 13     | -      | -      | 26     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | PCIN+(A:0x0):B+(C:0x10) | 30     | 13     | 5      | -      | -1     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (A:0x1ffb)*B            | 13     | 13     | -      | -      | 26     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | PCIN+(A:0x0):B+(C:0x10) | 30     | 13     | 5      | -      | -1     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (A:0x1ffc)*B            | 13     | 13     | -      | -      | 26     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | PCIN+(A:0x0):B+(C:0x10) | 30     | 13     | 5      | -      | -1     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (A:0x1ffd)*B            | 13     | 13     | -      | -      | 26     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | PCIN+(A:0x0):B+(C:0x10) | 30     | 13     | 5      | -      | -1     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (A:0x1ffe)*B            | 13     | 13     | -      | -      | 26     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | PCIN+(A:0x0):B+(C:0x10) | 30     | 13     | 5      | -      | -1     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | (A:0x1fff)*B            | 13     | 13     | -      | -      | 26     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�|Plane_prediction | PCIN+(A:0x0):B+(C:0x10) | 30     | 13     | 5      | -      | -1     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
2default:defaulth px� 
�
%s*synth2�
�+-----------------+-------------------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+

2default:defaulth px� 
�
%s*synth2�
�Note: The table above is a preliminary report that shows the DSPs inferred at the current stage of the synthesis flow. Some DSP may be reimplemented as non DSP primitives later in the synthesis flow. Multiple instantiated DSPs are reported only once.
2default:defaulth px� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
~Finished Timing Optimization : Time (s): cpu = 00:01:28 ; elapsed = 00:01:34 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
}Finished Technology Mapping : Time (s): cpu = 00:01:34 ; elapsed = 00:01:40 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
wFinished IO Insertion : Time (s): cpu = 00:01:43 ; elapsed = 00:01:49 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:01:43 ; elapsed = 00:01:49 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:01:44 ; elapsed = 00:01:50 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:01:44 ; elapsed = 00:01:50 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:01:45 ; elapsed = 00:01:51 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:01:45 ; elapsed = 00:01:51 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
i
%s
*synth2Q
=
DSP Final Report (the ' indicates corresponding REG is set)
2default:defaulth p
x
� 
�
%s
*synth2�
�+-----------------+--------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|Module Name      | DSP Mapping  | A Size | B Size | C Size | D Size | P Size | AREG | BREG | CREG | DREG | ADREG | MREG | PREG | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+-----------------+--------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 17     | 6      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN>>17+A*B | 15     | 6      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 17     | 16     | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 17     | 6      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN>>17+A*B | 15     | 6      | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 13     | 13     | -      | -      | 0      | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN+A:B+C   | 0      | 13     | -      | -      | 13     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 13     | 13     | -      | -      | 0      | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN+A:B+C   | 0      | 13     | -      | -      | 13     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 13     | 13     | -      | -      | 0      | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN+A:B+C   | 0      | 13     | -      | -      | 13     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 13     | 13     | -      | -      | 0      | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN+A:B+C   | 0      | 13     | -      | -      | 13     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 13     | 13     | -      | -      | 0      | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN+A:B+C   | 0      | 13     | -      | -      | 13     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 13     | 13     | -      | -      | 0      | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN+A:B+C   | 0      | 13     | -      | -      | 13     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | A*B          | 13     | 13     | -      | -      | 0      | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|Plane_prediction | PCIN+A:B+C   | 0      | 13     | -      | -      | 13     | 0    | 0    | -    | -    | -     | 0    | 0    | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+-----------------+--------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+

2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
| |BlackBox name |Instances |
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
E
%s*synth2-
+------+--------+------+
2default:defaulth px� 
E
%s*synth2-
|      |Cell    |Count |
2default:defaulth px� 
E
%s*synth2-
+------+--------+------+
2default:defaulth px� 
E
%s*synth2-
|1     |BUFG    |     1|
2default:defaulth px� 
E
%s*synth2-
|2     |CARRY4  |   267|
2default:defaulth px� 
E
%s*synth2-
|3     |DSP48E1 |    19|
2default:defaulth px� 
E
%s*synth2-
|4     |LUT1    |    17|
2default:defaulth px� 
E
%s*synth2-
|5     |LUT2    |   602|
2default:defaulth px� 
E
%s*synth2-
|6     |LUT3    |    20|
2default:defaulth px� 
E
%s*synth2-
|7     |LUT4    |   242|
2default:defaulth px� 
E
%s*synth2-
|8     |LUT5    |    98|
2default:defaulth px� 
E
%s*synth2-
|9     |LUT6    |  6295|
2default:defaulth px� 
E
%s*synth2-
|10    |MUXF7   |   397|
2default:defaulth px� 
E
%s*synth2-
|11    |MUXF8   |    16|
2default:defaulth px� 
E
%s*synth2-
|12    |FDCE    |  8484|
2default:defaulth px� 
E
%s*synth2-
|13    |FDPE    |     3|
2default:defaulth px� 
E
%s*synth2-
|14    |FDRE    | 12416|
2default:defaulth px� 
E
%s*synth2-
|15    |IBUF    |  2310|
2default:defaulth px� 
E
%s*synth2-
|16    |OBUF    |  2048|
2default:defaulth px� 
E
%s*synth2-
+------+--------+------+
2default:defaulth px� 
E
%s
*synth2-

Report Instance Areas: 
2default:defaulth p
x
� 
l
%s
*synth2T
@+------+------------------------+----------------------+------+
2default:defaulth p
x
� 
l
%s
*synth2T
@|      |Instance                |Module                |Cells |
2default:defaulth p
x
� 
l
%s
*synth2T
@+------+------------------------+----------------------+------+
2default:defaulth p
x
� 
l
%s
*synth2T
@|1     |top                     |                      | 33235|
2default:defaulth p
x
� 
l
%s
*synth2T
@|2     |  dc_prediction         |DC_prediction         |  5290|
2default:defaulth p
x
� 
l
%s
*synth2T
@|3     |  horizontal_prediction |Horizontal_prediction |  5309|
2default:defaulth p
x
� 
l
%s
*synth2T
@|4     |  plane_prediction      |Plane_prediction      | 10488|
2default:defaulth p
x
� 
l
%s
*synth2T
@|5     |  vertical_prediction   |Vertical_prediction   |  7789|
2default:defaulth p
x
� 
l
%s
*synth2T
@+------+------------------------+----------------------+------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:01:45 ; elapsed = 00:01:51 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
u
%s
*synth2]
ISynthesis finished with 0 errors, 1 critical warnings and 2053 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:01:45 ; elapsed = 00:01:51 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:01:45 ; elapsed = 00:01:51 . Memory (MB): peak = 2124.945 ; gain = 1089.703
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.5902default:default2
2124.9452default:default2
0.0002default:defaultZ17-268h px� 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
6992default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
12default:defaultZ29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0102default:default2
2124.9452default:default2
0.0002default:defaultZ17-268h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
g
$Synth Design complete, checksum: %s
562*	vivadotcl2
b3be71542default:defaultZ4-1430h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
392default:default2
2012default:default2
12default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
synth_design: 2default:default2
00:01:552default:default2
00:02:022default:default2
2124.9452default:default2
1097.2662default:defaultZ17-268h px� 
u
%s6*runtcl2Y
ESynthesis results are not added to the cache due to CRITICAL_WARNING
2default:defaulth px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
rC:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE 496/FPGA_build/project_1/project_1.runs/synth_1/intra16x16_top.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
rExecuting : report_utilization -file intra16x16_top_utilization_synth.rpt -pb intra16x16_top_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Mon Aug  5 22:54:02 20242default:defaultZ17-206h px� 


End Record