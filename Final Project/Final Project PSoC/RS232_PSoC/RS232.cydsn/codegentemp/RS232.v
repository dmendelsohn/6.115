// ======================================================================
// RS232.v generated from TopDesign.cysch
// 05/16/2013 at 13:40
// This file is auto generated. ANY EDITS YOU MAKE MAY BE LOST WHEN THIS FILE IS REGENERATED!!!
// ======================================================================

/* -- WARNING: The following section of defines are deprecated and will be removed in a future release -- */
`define CYDEV_CHIP_DIE_LEOPARD 1
`define CYDEV_CHIP_REV_LEOPARD_PRODUCTION 3
`define CYDEV_CHIP_REV_LEOPARD_ES3 3
`define CYDEV_CHIP_REV_LEOPARD_ES2 1
`define CYDEV_CHIP_REV_LEOPARD_ES1 0
`define CYDEV_CHIP_DIE_PANTHER 2
`define CYDEV_CHIP_REV_PANTHER_PRODUCTION 1
`define CYDEV_CHIP_REV_PANTHER_ES1 1
`define CYDEV_CHIP_REV_PANTHER_ES0 0
`define CYDEV_CHIP_DIE_PSOC5LP 3
`define CYDEV_CHIP_REV_PSOC5LP_PRODUCTION 0
`define CYDEV_CHIP_REV_PSOC5LP_ES 0
`define CYDEV_CHIP_DIE_EXPECT 3
`define CYDEV_CHIP_REV_EXPECT 0
`define CYDEV_CHIP_DIE_ACTUAL 3
/* -- WARNING: The previous section of defines are deprecated and will be removed in a future release -- */
`define CYDEV_CHIP_FAMILY_UNKNOWN 0
`define CYDEV_CHIP_MEMBER_UNKNOWN 0
`define CYDEV_CHIP_FAMILY_PSOC3 1
`define CYDEV_CHIP_MEMBER_3A 1
`define CYDEV_CHIP_REVISION_3A_PRODUCTION 3
`define CYDEV_CHIP_REVISION_3A_ES3 3
`define CYDEV_CHIP_REVISION_3A_ES2 1
`define CYDEV_CHIP_REVISION_3A_ES1 0
`define CYDEV_CHIP_FAMILY_PSOC5 2
`define CYDEV_CHIP_MEMBER_5A 2
`define CYDEV_CHIP_REVISION_5A_PRODUCTION 1
`define CYDEV_CHIP_REVISION_5A_ES1 1
`define CYDEV_CHIP_REVISION_5A_ES0 0
`define CYDEV_CHIP_MEMBER_5B 3
`define CYDEV_CHIP_REVISION_5B_PRODUCTION 0
`define CYDEV_CHIP_REVISION_5B_ES 0
`define CYDEV_CHIP_FAMILY_USED 2
`define CYDEV_CHIP_MEMBER_USED 3
`define CYDEV_CHIP_REVISION_USED 0
// CharLCD_v1_70(ConversionRoutines=true, CUSTOM0=0,E,8,8,8,E,0, CUSTOM1=0,A,A,4,4,4,0, CUSTOM2=0,E,A,E,8,8,0, CUSTOM3=0,E,A,C,A,A,0, CUSTOM4=0,E,8,C,8,E,0, CUSTOM5=0,E,8,E,2,E,0, CUSTOM6=0,E,8,E,2,E,0, CUSTOM7=0,4,4,4,0,4,0, CustomCharacterSet=0, CY_COMPONENT_NAME=CharLCD_v1_70, CY_CONTROL_FILE=<:default:>, CY_FITTER_NAME=LCD, CY_INSTANCE_SHORT_NAME=LCD, CY_MAJOR_VERSION=1, CY_MINOR_VERSION=70, CY_REMOVE=false, CY_SUPPRESS_API_GEN=false, CY_VERSION=cydsfit No Version Information Found, INSTANCE_NAME=LCD, )
module CharLCD_v1_70_0 ;



	wire [6:0] tmpOE__LCDPort_net;
	wire [6:0] tmpFB_6__LCDPort_net;
	wire [6:0] tmpIO_6__LCDPort_net;
	wire [0:0] tmpINTERRUPT_0__LCDPort_net;
	electrical [0:0] tmpSIOVREF__LCDPort_net;

	cy_psoc3_pins_v1_10
		#(.id("743d4abb-26af-45c7-b23c-52ae8bdc946b/ed092b9b-d398-4703-be89-cebf998501f6"),
		  .drive_mode(21'b110_110_110_110_110_110_110),
		  .ibuf_enabled(7'b1_1_1_1_1_1_1),
		  .init_dr_st(7'b0_0_0_0_0_0_0),
		  .input_sync(7'b1_1_1_1_1_1_1),
		  .intr_mode(14'b00_00_00_00_00_00_00),
		  .io_voltage(", , , , , , "),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(7'b0_0_0_0_0_0_0),
		  .output_conn(7'b0_0_0_0_0_0_0),
		  .output_sync(7'b0_0_0_0_0_0_0),
		  .pin_aliases(",,,,,,"),
		  .pin_mode("OOOOOOO"),
		  .por_state(4),
		  .use_annotation(7'b0_0_0_0_0_0_0),
		  .sio_group_cnt(0),
		  .sio_hyst(7'b0_0_0_0_0_0_0),
		  .sio_ibuf(""),
		  .sio_info(14'b00_00_00_00_00_00_00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(7'b0_0_0_0_0_0_0),
		  .spanning(0),
		  .vtrip(14'b10_10_10_10_10_10_10),
		  .width(7))
		LCDPort
		 (.oe(tmpOE__LCDPort_net),
		  .y({7'b0}),
		  .fb({tmpFB_6__LCDPort_net[6:0]}),
		  .io({tmpIO_6__LCDPort_net[6:0]}),
		  .siovref(tmpSIOVREF__LCDPort_net),
		  .interrupt({tmpINTERRUPT_0__LCDPort_net[0:0]}));

	assign tmpOE__LCDPort_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{7'b1111111} : {7'b1111111};



endmodule

// Component: cy_virtualmux_v1_0
`ifdef CY_BLK_DIR
`undef CY_BLK_DIR
`endif

`ifdef WARP
`define CY_BLK_DIR "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\cy_virtualmux_v1_0"
`include "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\cy_virtualmux_v1_0\cy_virtualmux_v1_0.v"
`else
`define CY_BLK_DIR "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\cy_virtualmux_v1_0"
`include "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\cy_virtualmux_v1_0\cy_virtualmux_v1_0.v"
`endif

// Component: B_UART_v2_20
`ifdef CY_BLK_DIR
`undef CY_BLK_DIR
`endif

`ifdef WARP
`define CY_BLK_DIR "$CYPRESS_DIR\..\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\B_UART_v2_20"
`include "$CYPRESS_DIR\..\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\B_UART_v2_20\B_UART_v2_20.v"
`else
`define CY_BLK_DIR "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\B_UART_v2_20"
`include "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\B_UART_v2_20\B_UART_v2_20.v"
`endif

// UART_v2_20(Address1=0, Address2=0, BaudRate=9600, BreakBitsRX=13, BreakBitsTX=13, BreakDetect=false, CRCoutputsEn=false, CtrlModeReplacementString=SyncCtl, Enable_RX=1, Enable_RXIntInterrupt=0, Enable_TX=1, Enable_TXIntInterrupt=0, EnableHWAddress=0, EnIntRXInterrupt=false, EnIntTXInterrupt=false, FlowControl=0, HalfDuplexEn=false, HwTXEnSignal=false, InternalClock=true, InternalClockUsed=1, InterruptOnAddDetect=0, InterruptOnAddressMatch=0, InterruptOnBreak=0, InterruptOnByteRcvd=1, InterruptOnOverrunError=0, InterruptOnParityError=0, InterruptOnStopError=0, InterruptOnTXComplete=false, InterruptOnTXFifoEmpty=false, InterruptOnTXFifoFull=false, InterruptOnTXFifoNotFull=false, IntOnAddressDetect=false, IntOnAddressMatch=false, IntOnBreak=false, IntOnByteRcvd=true, IntOnOverrunError=false, IntOnParityError=false, IntOnStopError=false, NumDataBits=8, NumStopBits=1, OverSamplingRate=8, ParityType=0, ParityTypeSw=false, RequiredClock=76800, RXAddressMode=0, RXBufferSize=4, RxBuffRegSizeReplacementString=uint8, RXEnable=true, TXBitClkGenDP=true, TXBufferSize=4, TxBuffRegSizeReplacementString=uint8, TXEnable=true, Use23Polling=true, CY_COMPONENT_NAME=UART_v2_20, CY_CONTROL_FILE=<:default:>, CY_FITTER_NAME=UART, CY_INSTANCE_SHORT_NAME=UART, CY_MAJOR_VERSION=2, CY_MINOR_VERSION=20, CY_REMOVE=false, CY_SUPPRESS_API_GEN=false, CY_VERSION=cydsfit No Version Information Found, INSTANCE_NAME=UART, )
module UART_v2_20_1 (
    rx_clk,
    rx_data,
    tx_clk,
    tx_data,
    rx_interrupt,
    tx_interrupt,
    tx,
    tx_en,
    rts_n,
    reset,
    cts_n,
    clock,
    rx);
    output      rx_clk;
    output      rx_data;
    output      tx_clk;
    output      tx_data;
    output      rx_interrupt;
    output      tx_interrupt;
    output      tx;
    output      tx_en;
    output      rts_n;
    input       reset;
    input       cts_n;
    input       clock;
    input       rx;

    parameter Address1 = 0;
    parameter Address2 = 0;
    parameter EnIntRXInterrupt = 0;
    parameter EnIntTXInterrupt = 0;
    parameter FlowControl = 0;
    parameter HalfDuplexEn = 0;
    parameter HwTXEnSignal = 0;
    parameter NumDataBits = 8;
    parameter NumStopBits = 1;
    parameter ParityType = 0;
    parameter RXEnable = 1;
    parameter TXEnable = 1;

          wire  Net_289;
          wire  Net_61;
          wire  Net_9;


	cy_clock_v1_0
		#(.id("b0162966-0060-4af5-82d1-fcb491ad7619/be0a0e37-ad17-42ca-b5a1-1a654d736358"),
		  .source_clock_id(""),
		  .divisor(0),
		  .period("13020833333.3333"),
		  .is_direct(0),
		  .is_digital(1))
		IntClock
		 (.clock_out(Net_9));


	// VirtualMux_1 (cy_virtualmux_v1_0)
	assign Net_61 = Net_9;

    B_UART_v2_20 BUART (
        .cts_n(cts_n),
        .tx(tx),
        .rts_n(rts_n),
        .tx_en(tx_en),
        .clock(Net_61),
        .reset(reset),
        .rx(rx),
        .tx_interrupt(tx_interrupt),
        .rx_interrupt(rx_interrupt),
        .tx_data(tx_data),
        .tx_clk(tx_clk),
        .rx_data(rx_data),
        .rx_clk(rx_clk));
    defparam BUART.Address1 = 0;
    defparam BUART.Address2 = 0;
    defparam BUART.BreakBitsRX = 13;
    defparam BUART.BreakBitsTX = 13;
    defparam BUART.BreakDetect = 0;
    defparam BUART.CRCoutputsEn = 0;
    defparam BUART.FlowControl = 0;
    defparam BUART.HalfDuplexEn = 0;
    defparam BUART.HwTXEnSignal = 0;
    defparam BUART.NumDataBits = 8;
    defparam BUART.NumStopBits = 1;
    defparam BUART.OverSampleCount = 8;
    defparam BUART.ParityType = 0;
    defparam BUART.ParityTypeSw = 0;
    defparam BUART.RXAddressMode = 0;
    defparam BUART.RXEnable = 1;
    defparam BUART.RXStatusIntEnable = 1;
    defparam BUART.TXBitClkGenDP = 1;
    defparam BUART.TXEnable = 1;
    defparam BUART.Use23Polling = 1;



endmodule

// Component: ZeroTerminal
`ifdef CY_BLK_DIR
`undef CY_BLK_DIR
`endif

`ifdef WARP
`define CY_BLK_DIR "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\ZeroTerminal"
`include "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\ZeroTerminal\ZeroTerminal.v"
`else
`define CY_BLK_DIR "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\ZeroTerminal"
`include "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\ZeroTerminal\ZeroTerminal.v"
`endif

// Component: AMux_v1_60
`ifdef CY_BLK_DIR
`undef CY_BLK_DIR
`endif

`ifdef WARP
`define CY_BLK_DIR "$CYPRESS_DIR\..\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\AMux_v1_60"
`include "$CYPRESS_DIR\..\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\AMux_v1_60\AMux_v1_60.v"
`else
`define CY_BLK_DIR "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\AMux_v1_60"
`include "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cycomponentlibrary\CyComponentLibrary.cylib\AMux_v1_60\AMux_v1_60.v"
`endif

// Component: cy_analog_virtualmux_v1_0
`ifdef CY_BLK_DIR
`undef CY_BLK_DIR
`endif

`ifdef WARP
`define CY_BLK_DIR "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\cy_analog_virtualmux_v1_0"
`include "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\cy_analog_virtualmux_v1_0\cy_analog_virtualmux_v1_0.v"
`else
`define CY_BLK_DIR "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\cy_analog_virtualmux_v1_0"
`include "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\cy_analog_virtualmux_v1_0\cy_analog_virtualmux_v1_0.v"
`endif

// Component: cy_vref_v1_60
`ifdef CY_BLK_DIR
`undef CY_BLK_DIR
`endif

`ifdef WARP
`define CY_BLK_DIR "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\cy_vref_v1_60"
`include "$CYPRESS_DIR\..\psoc\content\cyprimitives\CyPrimitives.cylib\cy_vref_v1_60\cy_vref_v1_60.v"
`else
`define CY_BLK_DIR "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\cy_vref_v1_60"
`include "C:\Program Files\Cypress\PSoC Creator\2.1\PSoC Creator\psoc\content\cyprimitives\CyPrimitives.cylib\cy_vref_v1_60\cy_vref_v1_60.v"
`endif

// ADC_Vssa_v1_20(CY_COMPONENT_NAME=ADC_Vssa_v1_20, CY_CONTROL_FILE=<:default:>, CY_FITTER_NAME=ADC_Vssa_2, CY_INSTANCE_SHORT_NAME=ADC_Vssa_2, CY_MAJOR_VERSION=1, CY_MINOR_VERSION=20, CY_REMOVE=false, CY_SUPPRESS_API_GEN=false, CY_VERSION=cydsfit No Version Information Found, INSTANCE_NAME=ADC_ADC_Vssa_2, )
module ADC_Vssa_v1_20_2 (
    vout);
    inout       vout;
    electrical  vout;




	cy_vref_v1_0
		#(.autoenable(1),
		  .guid("15B3DB15-B7B3-4d62-A2DF-25EA392A7161"),
		  .name("Vssa (GND)"))
		vRef_1
		 (.vout(vout));




endmodule

// ADC_Vssa_v1_20(CY_COMPONENT_NAME=ADC_Vssa_v1_20, CY_CONTROL_FILE=<:default:>, CY_FITTER_NAME=ADC_Vssa_1, CY_INSTANCE_SHORT_NAME=ADC_Vssa_1, CY_MAJOR_VERSION=1, CY_MINOR_VERSION=20, CY_REMOVE=false, CY_SUPPRESS_API_GEN=false, CY_VERSION=cydsfit No Version Information Found, INSTANCE_NAME=ADC_ADC_Vssa_1, )
module ADC_Vssa_v1_20_3 (
    vout);
    inout       vout;
    electrical  vout;




	cy_vref_v1_0
		#(.autoenable(1),
		  .guid("15B3DB15-B7B3-4d62-A2DF-25EA392A7161"),
		  .name("Vssa (GND)"))
		vRef_1
		 (.vout(vout));




endmodule

// ADC_DelSig_v2_30(ADC_Charge_Pump_Clock=true, ADC_Clock=1, ADC_CLOCK_FREQUENCY=160000, ADC_Input_Mode=1, ADC_Input_Range=3, ADC_Input_Range_Config2=0, ADC_Input_Range_Config3=0, ADC_Input_Range_Config4=0, ADC_Power=1, ADC_Reference=0, ADC_Reference_Config2=0, ADC_Reference_Config3=0, ADC_Reference_Config4=0, ADC_Resolution=8, ADC_Resolution_Config2=16, ADC_Resolution_Config3=16, ADC_Resolution_Config4=16, Clock_Frequency=64000, Comment_Config1=Default Config, Comment_Config2=Second Config, Comment_Config3=Third Config, Comment_Config4=Fourth Config, Config1_Name=CFG1, Config2_Name=CFG2, Config3_Name=CFG3, Config4_Name=CFG4, Configs=4, Conversion_Mode=2, Conversion_Mode_Config2=2, Conversion_Mode_Config3=2, Conversion_Mode_Config4=2, Debug=false, DsmName=DSM4, Enable_Vref_Vss=false, Input_Buffer_Gain=1, Input_Buffer_Gain_Config2=1, Input_Buffer_Gain_Config3=1, Input_Buffer_Gain_Config4=1, Input_Buffer_Mode=1, Input_Buffer_Mode_Config2=1, Input_Buffer_Mode_Config3=1, Input_Buffer_Mode_Config4=1, PSOC5A=false, Ref_Voltage=1.024, Ref_Voltage_Config2=1.024, Ref_Voltage_Config3=1.024, Ref_Voltage_Config4=1.024, Sample_Rate=10000, Sample_Rate_Config2=10000, Sample_Rate_Config3=10000, Sample_Rate_Config4=10000, sRate_Err=false, Start_of_Conversion=0, Vdda_Value=5, CY_COMPONENT_NAME=ADC_DelSig_v2_30, CY_CONTROL_FILE=<:default:>, CY_FITTER_NAME=ADC, CY_INSTANCE_SHORT_NAME=ADC, CY_MAJOR_VERSION=2, CY_MINOR_VERSION=30, CY_REMOVE=false, CY_SUPPRESS_API_GEN=false, CY_VERSION=cydsfit No Version Information Found, INSTANCE_NAME=ADC, )
module ADC_DelSig_v2_30_4 (
    vplus,
    vminus,
    soc,
    eoc,
    aclk,
    nVref);
    inout       vplus;
    electrical  vplus;
    inout       vminus;
    electrical  vminus;
    input       soc;
    output      eoc;
    input       aclk;
    inout       nVref;
    electrical  nVref;


          wire  aclock;
          wire [3:0] mod_dat;
          wire  mod_reset;
          wire  Net_1;
    electrical  Net_2;
    electrical  Net_3;
          wire  Net_14;
          wire [7:0] Net_5;
          wire  Net_6;
          wire  Net_7;
          wire  Net_8;
          wire [7:0] Net_9;
          wire  Net_10;
    electrical  Net_11;
    electrical  Net_12;
    electrical  Net_13;
    electrical  Net_686;
    electrical  Net_690;
    electrical  Net_681;
    electrical  Net_677;
    electrical  Net_570;
          wire  Net_488;
          wire  Net_482;
          wire  Net_481;
          wire  Net_478;
          wire  Net_438;
          wire [3:0] Net_471;
          wire [3:0] Net_470;
    electrical  Net_352;
    electrical  Net_580;
    electrical  Net_349;
    electrical  Net_573;
    electrical  Net_257;
          wire  Net_487;
          wire  Net_40;
    electrical  Net_520;

    cy_psoc3_decimator_v1_0 DEC (
        .aclock(aclock),
        .mod_dat(mod_dat[3:0]),
        .ext_start(soc),
        .mod_reset(mod_reset),
        .interrupt(eoc));

    ZeroTerminal ZeroTerminal_1 (
        .z(Net_481));

    ZeroTerminal ZeroTerminal_2 (
        .z(Net_482));


	cy_clock_v1_0
		#(.id("f0ee2774-be65-4189-b918-994d48d98c4a/edd15f43-b66b-457b-be3a-5342345270c8"),
		  .source_clock_id("61737EF6-3B74-48f9-8B91-F7473A442AE7"),
		  .divisor(0),
		  .period("6250000000"),
		  .is_direct(0),
		  .is_digital(0))
		theACLK
		 (.clock_out(Net_40));


	// Clock_VirtualMux (cy_virtualmux_v1_0)
	assign Net_488 = Net_40;


	cy_isr_v1_0
		#(.int_type(2'b10))
		IRQ
		 (.int_signal(eoc));


	// cy_analog_virtualmux_1 (cy_analog_virtualmux_v1_0)
	cy_connect_v1_0 cy_analog_virtualmux_1_connect(Net_520, Net_681);
	defparam cy_analog_virtualmux_1_connect.sig_width = 1;

	// cy_analog_virtualmux_2 (cy_analog_virtualmux_v1_0)
	cy_connect_v1_0 cy_analog_virtualmux_2_connect(Net_580, Net_349);
	defparam cy_analog_virtualmux_2_connect.sig_width = 1;

	// cy_analog_virtualmux_3 (cy_analog_virtualmux_v1_0)
	cy_connect_v1_0 cy_analog_virtualmux_3_connect(Net_573, Net_257);
	defparam cy_analog_virtualmux_3_connect.sig_width = 1;

    cy_analog_noconnect_v1_0 cy_analog_noconnect_2 (
        .noconnect(Net_349));

    cy_analog_noconnect_v1_0 cy_analog_noconnect_3 (
        .noconnect(Net_257));


	cy_clock_v1_0
		#(.id("f0ee2774-be65-4189-b918-994d48d98c4a/b7604721-db56-4477-98c2-8fae77869066"),
		  .source_clock_id("61737EF6-3B74-48f9-8B91-F7473A442AE7"),
		  .divisor(0),
		  .period("1000000000"),
		  .is_direct(0),
		  .is_digital(1))
		Ext_CP_Clk
		 (.clock_out(Net_487));


	// cy_analog_virtualmux_5 (cy_analog_virtualmux_v1_0)
	cy_connect_v1_0 cy_analog_virtualmux_5_connect(Net_570, Net_352);
	defparam cy_analog_virtualmux_5_connect.sig_width = 1;

    cy_analog_noconnect_v1_0 cy_analog_noconnect_5 (
        .noconnect(Net_352));

    cy_psoc3_ds_mod_v4_0 DSM4 (
        .vplus(vplus),
        .vminus(Net_520),
        .modbit(Net_7),
        .reset_udb(Net_8),
        .aclock(Net_488),
        .mod_dat(Net_471[3:0]),
        .dout_udb(Net_9[7:0]),
        .reset_dec(mod_reset),
        .dec_clock(Net_478),
        .extclk_cp_udb(Net_487),
        .clk_udb(1'b0),
        .ext_pin_1(Net_580),
        .ext_pin_2(Net_573),
        .ext_vssa(Net_570),
        .qtz_ref(Net_677));
    defparam DSM4.resolution = 8;

    ZeroTerminal ZeroTerminal_3 (
        .z(Net_7));

    ZeroTerminal ZeroTerminal_5 (
        .z(Net_8));

	// Clock_VirtualMux_2 (cy_virtualmux_v1_0)
	assign mod_dat[3:0] = Net_471[3:0];

	// Clock_VirtualMux_3 (cy_virtualmux_v1_0)
	assign aclock = Net_478;

    // -- AMux AMux start -- ***
    // -- Mux A --
    
    cy_psoc3_amux_v1_0 AMux(
        .muxin({
            Net_690,
            Net_11
            }),
        .vout(Net_681)
        );
    
    defparam AMux.muxin_width = 2;
    defparam AMux.init_mux_sel = 2'h0;
    defparam AMux.one_active = 0;
    defparam AMux.connect_mode = 1;
    
    // -- AMux AMux end --

	// cy_analog_virtualmux_4 (cy_analog_virtualmux_v1_0)
	cy_connect_v1_0 cy_analog_virtualmux_4_connect(Net_677, Net_12);
	defparam cy_analog_virtualmux_4_connect.sig_width = 1;

    cy_analog_noconnect_v1_0 cy_analog_noconnect_1 (
        .noconnect(Net_12));

	// cy_analog_virtualmux_6 (cy_analog_virtualmux_v1_0)
	cy_connect_v1_0 cy_analog_virtualmux_6_connect(Net_690, Net_13);
	defparam cy_analog_virtualmux_6_connect.sig_width = 1;

    ADC_Vssa_v1_20_2 ADC_Vssa_2 (
        .vout(Net_13));

    ADC_Vssa_v1_20_3 ADC_Vssa_1 (
        .vout(Net_11));



endmodule

// top
module top ;

    electrical  Net_493;
          wire  Net_492;
          wire  Net_491;
          wire  Net_490;
    electrical  Net_489;
          wire  Net_505;
    electrical  Net_472;
          wire  Net_527;
          wire  Net_526;
          wire  Net_525;
          wire  Net_524;
          wire  Net_80;
          wire  Net_79;
          wire  Net_521;
          wire  Net_520;
          wire  Net_519;
          wire  Net_194;
          wire  Net_518;
          wire  Net_523;
          wire  Net_262;
          wire  Net_502;
    electrical  Net_496;
    electrical  Net_464;
    electrical  Net_463;
    electrical  Net_462;
    electrical  Net_461;
    electrical  Net_460;

    CharLCD_v1_70_0 LCD ();

    UART_v2_20_1 UART (
        .cts_n(1'b0),
        .tx(Net_194),
        .rts_n(Net_519),
        .tx_en(Net_520),
        .clock(1'b0),
        .reset(Net_79),
        .rx(Net_80),
        .tx_interrupt(Net_262),
        .rx_interrupt(Net_523),
        .tx_data(Net_524),
        .tx_clk(Net_525),
        .rx_data(Net_526),
        .rx_clk(Net_527));
    defparam UART.Address1 = 0;
    defparam UART.Address2 = 0;
    defparam UART.EnIntRXInterrupt = 0;
    defparam UART.EnIntTXInterrupt = 0;
    defparam UART.FlowControl = 0;
    defparam UART.HalfDuplexEn = 0;
    defparam UART.HwTXEnSignal = 0;
    defparam UART.NumDataBits = 8;
    defparam UART.NumStopBits = 1;
    defparam UART.ParityType = 0;
    defparam UART.RXEnable = 1;
    defparam UART.TXEnable = 1;

	wire [0:0] tmpOE__RX_net;
	wire [0:0] tmpIO_0__RX_net;
	wire [0:0] tmpINTERRUPT_0__RX_net;
	electrical [0:0] tmpSIOVREF__RX_net;

	cy_psoc3_pins_v1_10
		#(.id("1425177d-0d0e-4468-8bcc-e638e5509a9b"),
		  .drive_mode(3'b001),
		  .ibuf_enabled(1'b1),
		  .init_dr_st(1'b1),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b0),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("I"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b00),
		  .width(1))
		RX
		 (.oe(tmpOE__RX_net),
		  .y({1'b0}),
		  .fb({Net_80}),
		  .io({tmpIO_0__RX_net[0:0]}),
		  .siovref(tmpSIOVREF__RX_net),
		  .interrupt({tmpINTERRUPT_0__RX_net[0:0]}));

	assign tmpOE__RX_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};


	cy_isr_v1_0
		#(.int_type(2'b01))
		rx_int
		 (.int_signal(Net_523));


    ZeroTerminal ZeroTerminal_1 (
        .z(Net_79));


	cy_isr_v1_0
		#(.int_type(2'b01))
		tx_int
		 (.int_signal(Net_262));


	wire [0:0] tmpOE__TX_net;
	wire [0:0] tmpFB_0__TX_net;
	wire [0:0] tmpIO_0__TX_net;
	wire [0:0] tmpINTERRUPT_0__TX_net;
	electrical [0:0] tmpSIOVREF__TX_net;

	cy_psoc3_pins_v1_10
		#(.id("52f31aa9-2f0a-497d-9a1f-1424095e13e6"),
		  .drive_mode(3'b110),
		  .ibuf_enabled(1'b1),
		  .init_dr_st(1'b0),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b1),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("O"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b10),
		  .width(1))
		TX
		 (.oe(tmpOE__TX_net),
		  .y({Net_194}),
		  .fb({tmpFB_0__TX_net[0:0]}),
		  .io({tmpIO_0__TX_net[0:0]}),
		  .siovref(tmpSIOVREF__TX_net),
		  .interrupt({tmpINTERRUPT_0__TX_net[0:0]}));

	assign tmpOE__TX_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};

	wire [0:0] tmpOE__RIGHT_PIN_net;
	wire [0:0] tmpFB_0__RIGHT_PIN_net;
	wire [0:0] tmpIO_0__RIGHT_PIN_net;
	wire [0:0] tmpINTERRUPT_0__RIGHT_PIN_net;
	electrical [0:0] tmpSIOVREF__RIGHT_PIN_net;

	cy_psoc3_pins_v1_10
		#(.id("e28a89da-d56f-4754-b11f-0ea7410ae681"),
		  .drive_mode(3'b000),
		  .ibuf_enabled(1'b0),
		  .init_dr_st(1'b0),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b0),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("A"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b10),
		  .width(1))
		RIGHT_PIN
		 (.oe(tmpOE__RIGHT_PIN_net),
		  .y({1'b0}),
		  .fb({tmpFB_0__RIGHT_PIN_net[0:0]}),
		  .analog({Net_461}),
		  .io({tmpIO_0__RIGHT_PIN_net[0:0]}),
		  .siovref(tmpSIOVREF__RIGHT_PIN_net),
		  .interrupt({tmpINTERRUPT_0__RIGHT_PIN_net[0:0]}));

	assign tmpOE__RIGHT_PIN_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};

	wire [0:0] tmpOE__LEFT_PIN_net;
	wire [0:0] tmpFB_0__LEFT_PIN_net;
	wire [0:0] tmpIO_0__LEFT_PIN_net;
	wire [0:0] tmpINTERRUPT_0__LEFT_PIN_net;
	electrical [0:0] tmpSIOVREF__LEFT_PIN_net;

	cy_psoc3_pins_v1_10
		#(.id("05a9c8de-3ba2-4909-8250-95fdc61c0bf4"),
		  .drive_mode(3'b000),
		  .ibuf_enabled(1'b0),
		  .init_dr_st(1'b0),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b0),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("A"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b10),
		  .width(1))
		LEFT_PIN
		 (.oe(tmpOE__LEFT_PIN_net),
		  .y({1'b0}),
		  .fb({tmpFB_0__LEFT_PIN_net[0:0]}),
		  .analog({Net_460}),
		  .io({tmpIO_0__LEFT_PIN_net[0:0]}),
		  .siovref(tmpSIOVREF__LEFT_PIN_net),
		  .interrupt({tmpINTERRUPT_0__LEFT_PIN_net[0:0]}));

	assign tmpOE__LEFT_PIN_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};

	wire [0:0] tmpOE__TEST_PIN_net;
	wire [0:0] tmpFB_0__TEST_PIN_net;
	wire [0:0] tmpIO_0__TEST_PIN_net;
	wire [0:0] tmpINTERRUPT_0__TEST_PIN_net;
	electrical [0:0] tmpSIOVREF__TEST_PIN_net;

	cy_psoc3_pins_v1_10
		#(.id("751a4e27-d0ee-4ab3-ad86-5d0745ab0f99"),
		  .drive_mode(3'b000),
		  .ibuf_enabled(1'b0),
		  .init_dr_st(1'b0),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b0),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("A"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b10),
		  .width(1))
		TEST_PIN
		 (.oe(tmpOE__TEST_PIN_net),
		  .y({1'b0}),
		  .fb({tmpFB_0__TEST_PIN_net[0:0]}),
		  .analog({Net_472}),
		  .io({tmpIO_0__TEST_PIN_net[0:0]}),
		  .siovref(tmpSIOVREF__TEST_PIN_net),
		  .interrupt({tmpINTERRUPT_0__TEST_PIN_net[0:0]}));

	assign tmpOE__TEST_PIN_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};

	wire [0:0] tmpOE__MID_PIN_net;
	wire [0:0] tmpFB_0__MID_PIN_net;
	wire [0:0] tmpIO_0__MID_PIN_net;
	wire [0:0] tmpINTERRUPT_0__MID_PIN_net;
	electrical [0:0] tmpSIOVREF__MID_PIN_net;

	cy_psoc3_pins_v1_10
		#(.id("476a40da-6ee8-41ea-b2cb-3a794660c121"),
		  .drive_mode(3'b000),
		  .ibuf_enabled(1'b0),
		  .init_dr_st(1'b0),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b0),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("A"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b10),
		  .width(1))
		MID_PIN
		 (.oe(tmpOE__MID_PIN_net),
		  .y({1'b0}),
		  .fb({tmpFB_0__MID_PIN_net[0:0]}),
		  .analog({Net_464}),
		  .io({tmpIO_0__MID_PIN_net[0:0]}),
		  .siovref(tmpSIOVREF__MID_PIN_net),
		  .interrupt({tmpINTERRUPT_0__MID_PIN_net[0:0]}));

	assign tmpOE__MID_PIN_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};

	wire [0:0] tmpOE__DOWN_PIN_net;
	wire [0:0] tmpFB_0__DOWN_PIN_net;
	wire [0:0] tmpIO_0__DOWN_PIN_net;
	wire [0:0] tmpINTERRUPT_0__DOWN_PIN_net;
	electrical [0:0] tmpSIOVREF__DOWN_PIN_net;

	cy_psoc3_pins_v1_10
		#(.id("2e1d436a-d5a6-414a-87aa-eedccc00dc17"),
		  .drive_mode(3'b000),
		  .ibuf_enabled(1'b0),
		  .init_dr_st(1'b0),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b0),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("A"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b10),
		  .width(1))
		DOWN_PIN
		 (.oe(tmpOE__DOWN_PIN_net),
		  .y({1'b0}),
		  .fb({tmpFB_0__DOWN_PIN_net[0:0]}),
		  .analog({Net_463}),
		  .io({tmpIO_0__DOWN_PIN_net[0:0]}),
		  .siovref(tmpSIOVREF__DOWN_PIN_net),
		  .interrupt({tmpINTERRUPT_0__DOWN_PIN_net[0:0]}));

	assign tmpOE__DOWN_PIN_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};

	wire [0:0] tmpOE__UP_PIN_net;
	wire [0:0] tmpFB_0__UP_PIN_net;
	wire [0:0] tmpIO_0__UP_PIN_net;
	wire [0:0] tmpINTERRUPT_0__UP_PIN_net;
	electrical [0:0] tmpSIOVREF__UP_PIN_net;

	cy_psoc3_pins_v1_10
		#(.id("268d6560-90e0-4998-b5fa-709812abc6d0"),
		  .drive_mode(3'b000),
		  .ibuf_enabled(1'b0),
		  .init_dr_st(1'b0),
		  .input_sync(1'b1),
		  .intr_mode(2'b00),
		  .io_voltage(""),
		  .layout_mode("CONTIGUOUS"),
		  .oe_conn(1'b0),
		  .output_conn(1'b0),
		  .output_sync(1'b0),
		  .pin_aliases(""),
		  .pin_mode("A"),
		  .por_state(4),
		  .use_annotation(1'b0),
		  .sio_group_cnt(0),
		  .sio_hyst(1'b0),
		  .sio_ibuf(""),
		  .sio_info(2'b00),
		  .sio_obuf(""),
		  .sio_refsel(""),
		  .sio_vtrip(""),
		  .slew_rate(1'b0),
		  .spanning(0),
		  .vtrip(2'b10),
		  .width(1))
		UP_PIN
		 (.oe(tmpOE__UP_PIN_net),
		  .y({1'b0}),
		  .fb({tmpFB_0__UP_PIN_net[0:0]}),
		  .analog({Net_462}),
		  .io({tmpIO_0__UP_PIN_net[0:0]}),
		  .siovref(tmpSIOVREF__UP_PIN_net),
		  .interrupt({tmpINTERRUPT_0__UP_PIN_net[0:0]}));

	assign tmpOE__UP_PIN_net = (`CYDEV_CHIP_MEMBER_USED == `CYDEV_CHIP_MEMBER_3A && `CYDEV_CHIP_REVISION_USED < `CYDEV_CHIP_REVISION_3A_ES3) ? ~{1'b1} : {1'b1};


	cy_clock_v1_0
		#(.id("c23933dd-8fef-4472-ade7-d662cd57a064"),
		  .source_clock_id(""),
		  .divisor(0),
		  .period("333000333000333"),
		  .is_direct(0),
		  .is_digital(1))
		Clock_1
		 (.clock_out(Net_502));


    // -- AMux AMux start -- ***
    // -- Mux A --
    
    cy_psoc3_amux_v1_0 AMux(
        .muxin({
            Net_464,
            Net_463,
            Net_462,
            Net_461,
            Net_460
            }),
        .vout(Net_496)
        );
    
    defparam AMux.muxin_width = 5;
    defparam AMux.init_mux_sel = 5'h0;
    defparam AMux.one_active = 1;
    defparam AMux.connect_mode = 2;
    
    // -- AMux AMux end --

    ADC_DelSig_v2_30_4 ADC (
        .vplus(Net_496),
        .vminus(Net_489),
        .soc(1'b1),
        .eoc(Net_491),
        .aclk(1'b0),
        .nVref(Net_493));


	cy_isr_v1_0
		#(.int_type(2'b10))
		ISR
		 (.int_signal(Net_502));




endmodule

