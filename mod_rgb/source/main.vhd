----------------------------------------------------------------------------------
-- Company: UIUC
-- Engineer: Yicheng Zhou
-- 
-- Create Date: 2024/03/19 15:18:25
-- Design Name: mod_rgb
-- Module Name: main 
-- Project Name: ECE 496
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
--  Port ( );
    generic(
        Data_size_g: integer := 8
    );
    port (
        clk_i   : in std_logic;
        rst_in  : in std_logic;
        Rdata_i : in  std_logic_vector(256 * Data_size_g downto 0);
        Bdata_i : in  std_logic_vector(256 * Data_size_g downto 0);
        Gdata_i : in  std_logic_vector(256 * Data_size_g downto 0);
        Ydata_o : out std_logic_vector(256 * Data_size_g downto 0);
        Udata_o : out std_logic_vector(64  * Data_size_g downto 0);
        Vdata_o : out std_logic_vector(64  * Data_size_g downto 0)
    );   
end main;

architecture behavioral of main is
    type int_array is array(255 downto 0) of integer;
    type int_arr   is array(64 downto 0)  of integer;
    signal Rdata_rs : int_array;
    signal Bdata_rs : int_array;
    signal Gdata_rs : int_array;
    signal Ydata_rs : int_array;
    signal Udata_rs : int_arr;
    signal Vdata_rs : int_arr;

begin
    main : process (clk_i,rst_in)
    begin 
        if (rst_in = '0') then
            Ydata_o <= (others => '0');
            Udata_o <= (others => '0');
            Vdata_o <= (others => '0');
        else
            if (rising_edge(clk_i)) then
                for itr in 255 downto 0 loop
                end loop;
            end if;
        end if;
end process;
            
end architecture;