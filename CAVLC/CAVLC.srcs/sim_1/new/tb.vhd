----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/09/04 08:07:38
-- Design Name: 
-- Module Name: tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;
use std.textio.all;


entity test is
end test;

architecture cavlc_test of test is
	--
	constant STATE_IDLE   : std_logic_vector(2 downto 0) := b"000";
	constant STATE_READ   : std_logic_vector(2 downto 0) := b"001";
	constant STATE_CTOKEN : std_logic_vector(2 downto 0) := b"010";
	constant STATE_T1SIGN : std_logic_vector(2 downto 0) := b"011";
	constant STATE_COEFFS : std_logic_vector(2 downto 0) := b"100";
	constant STATE_TZEROS : std_logic_vector(2 downto 0) := b"101";
	constant STATE_RUNBF  : std_logic_vector(2 downto 0) := b"110";
	signal CLK : std_logic := '0';			--clock
	signal CLK2 : std_logic;				--2x clock
	signal ENABLE : std_logic := '0';				--values transfered only when this is 1
	signal READY : std_logic;				--values transfered only when this is 1
	signal VIN : std_logic_vector(11 downto 0) := x"000";		--12bits max (+/- 2048)
	signal NIN : std_logic_vector(4 downto 0);	--N coeffs nearby mb
	signal VE : std_logic_vector(24 downto 0) := (others=>'0');
	signal VL : std_logic_vector(4 downto 0) := (others=>'0');
	signal VALID : std_logic := '0';	-- enable delayed to same as VE/VL
	signal XSTATE : std_logic_vector(2 downto 0) := (others=>'0');
	signal STATE : std_logic_vector(2 downto 0) := (others=>'0');
	signal NOUT : std_logic_vector(4 downto 0);
	signal VIN1 : std_logic_vector(11 downto 0) := x"000";
	signal VIN2 : std_logic_vector(11 downto 0) := x"000";
	signal EN1: std_logic;
	signal EN2: std_logic;
	signal SIN : std_logic := '0';			--stream/strobe flag, copied to VS
	signal VS : std_logic;					--stream/strobe flag sync'd with VL/VE
	--
    component h264cavlc_vhd
    port(
        CLK : in std_logic;					--main clock / output clock
		CLK2 : in std_logic;				--input clock (typically twice CLK)
		ENABLE : in std_logic;				--values transfered only when this is 1
		READY : out std_logic;				--enable can fall when this 1
		VIN : in std_logic_vector(11 downto 0);	--12bits max (+/- 2048)
		NIN : in std_logic_vector(4 downto 0);	--N coeffs nearby mb
		SIN : in std_logic := '0';				--stream/strobe flag, copied to VS
		VS : out std_logic := '0';				--stream/strobe flag sync'd with VL/VE
		VE : out std_logic_vector(24 downto 0) := (others=>'0');
		VL : out std_logic_vector(4 downto 0) := (others=>'0');
		VALID : out std_logic := '0';			-- enable delayed to same as VE/VL
		XSTATE : out std_logic_vector(2 downto 0); 	--debug only
		NOUT : out std_logic_vector(4 downto 0) := b"00000"	--N coeffs for this mb
	);
	end component;
	
begin
	uut : h264cavlc_vhd
	port map (
		CLK => clk,
		CLK2 => clk2,
		ENABLE => enable,
		READY => ready,
		VIN => vin,
		NIN => nin,
		SIN => sin,
		VS => vs,
		VE => ve,
		VL => vl,
		VALID => valid,
		XSTATE => xstate,
		NOUT => nout
	);
	--
process		--generate CLK2, 100MHz will do for this sim, and CLK at 50MHz
begin
	CLK2 <= '0';
	wait for 5 ns;
	CLK2 <= '1';
	CLK <= not CLK;
	wait for 5 ns;
end process;
	--
process	--data input
	type Tdata is array(0 to 15) of integer;
	type TdataArray is array(0 to 6) of Tdata;
	variable index : integer;
	variable data : TdataArray := (
	(	0, 3,-1, 0,
		0,-1, 1, 0,
		1, 0, 0, 0,
		0, 0, 0, 0
	),
	(	-2,4, 0,-1,
		3, 0, 0, 0,
		-3,0, 0, 0,
		0, 0, 0, 0
	),
	(	-2,4, 2,-1,
		3, 1, 1, 1,
		-3,1, 1, 2,
		-1,-1, 1, 1
	),
	(	-2,4, 0,-1,
		3, 0, 0, 2,
		-3,0, 0, 0,
		0, 0, 0, 0
	),
	(	4, 3, 3, 3,
		3, 2, 3, 2,
		-3,1, 2, 2,
		1, 2, 3, 2
	),
	--(	14, 13,  23, 3,
	--	33, 22,-449, 2,
	--	-3, 8, 1022,54,
	--	 6, 5,  -12, 1
	--),
	(	1, 1, 1, 1,
		1, 1, 1, 1,
		1, 1, 1, 1,
		0, 0, 0, 0
	),
	(	0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0
	));
begin
	enable <= '0';
	for index in 0 to 6 loop
		wait until READY='1';
		wait until rising_edge(clk2); enable <= '1';
		if index=5 then SIN <= '1'; end if;	--DEBUG, test this feature
		nin <= b"00000";		      vin <= CONV_STD_LOGIC_VECTOR(data(index)(15),12);	--reverse zigzag order
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(14),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(11),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(7),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(10),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(13),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(12),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(9),12);
	 	wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(6),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(3),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(2),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(5),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(8),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(4),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(1),12);
		wait until rising_edge(clk2); vin <= CONV_STD_LOGIC_VECTOR(data(index)(0),12);
		wait until rising_edge(clk2); enable <= '0';
	end loop;
	wait for 1 ms;
end process;
	--
process(CLK2)
begin
	en2 <= enable;
	vin2 <= vin;
	en1 <= en2;
	vin1 <= vin2;
end process;
	--
process(CLK)		--DEBUG STUFF ONLY
	variable sout : line;
	variable n : integer;
begin
	if rising_edge(CLK) then
		state <= xstate;	--delay xstate by 1clk so it lines up with VE/VL 
    end if;		
		
end process;
	--
end cavlc_test;