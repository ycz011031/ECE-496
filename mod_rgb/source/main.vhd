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
    type int_array is array(255 downto 0) of unsigned(7 downto 0);
    type int_arr   is array(63 downto 0)  of unsigned(7 downto 0);
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
                --loading input into register
                for itr in 0 to 255 loop
                    Rdata_rs(itr) <= unsigned(Rdata_i((itr + 1) * Data_size_g - 1 downto itr * Data_size_g));
                    Gdata_rs(itr) <= unsigned(Gdata_i((itr + 1) * Data_size_g - 1 downto itr * Data_size_g));
                    Bdata_rs(itr) <= unsigned(Bdata_i((itr + 1) * Data_size_g - 1 downto itr * Data_size_g));
                end loop;
                
                --calculate Y data
                for itr in 0 to 255 loop
                    --Ydata_rs(itr) <= unsigned((66)*Rdata_rs(itr)/255 + (129)*Gdata_rs(itr)/255 + (25)*Bdata_rs(itr)/255 +16);
                    Ydata_rs(itr) <= to_unsigned(
                    (66 * to_integer(Rdata_rs(itr)) / 255) +
                    (129 * to_integer(Gdata_rs(itr)) / 255) +
                    (25 * to_integer(Bdata_rs(itr)) / 255) + 16,
                    Ydata_rs(itr)'length);
                    Ydata_o((itr+1)*data_size_g-1 downto itr * data_size_g) <= std_logic_vector(Ydata_rs(itr));
                    --Ydata_o((itr+1)*data_size_g-1 downto itr * data_size_g) <= unsigned((66)*Rdata_rs(itr)/255 + (129)*Gdata_rs(itr)/255 + (25)*Bdata_rs(itr)/255 +16);
                end loop;
                
                --calculate U & V data
                for itr in 0 to 63 loop
                    Udata_rs(itr) <= to_unsigned(
                        ((112 * (to_integer(Bdata_rs(4*itr)) + to_integer(Bdata_rs(4*itr+1)) +
                                to_integer(Bdata_rs(4*itr+2)) + to_integer(Bdata_rs(4*itr+3))) / 4) / 255) -
                        ((38 * (to_integer(Rdata_rs(4*itr)) + to_integer(Rdata_rs(4*itr+1)) +
                                to_integer(Rdata_rs(4*itr+2)) + to_integer(Rdata_rs(4*itr+3))) / 4) / 255) -
                        ((74 * (to_integer(Gdata_rs(4*itr)) + to_integer(Gdata_rs(4*itr+1)) +
                                to_integer(Gdata_rs(4*itr+2)) + to_integer(Gdata_rs(4*itr+3))) / 4) / 255) + 128,
                        Udata_rs(itr)'length);                    
                    Vdata_rs(itr) <= to_unsigned(
                        ((112 * (to_integer(Rdata_rs(4*itr)) + to_integer(Rdata_rs(4*itr+1)) +
                                to_integer(Rdata_rs(4*itr+2)) + to_integer(Rdata_rs(4*itr+3))) / 4) / 255) -
                        ((18 * (to_integer(Bdata_rs(4*itr)) + to_integer(Bdata_rs(4*itr+1)) +
                                to_integer(Bdata_rs(4*itr+2)) + to_integer(Bdata_rs(4*itr+3))) / 4) / 255) -
                        ((94 * (to_integer(Gdata_rs(4*itr)) + to_integer(Gdata_rs(4*itr+1)) +
                                to_integer(Gdata_rs(4*itr+2)) + to_integer(Gdata_rs(4*itr+3))) / 4) / 255) + 128,
                        Vdata_rs(itr)'length);
                    
                    Udata_o((itr+1)*data_size_g-1 downto itr * data_size_g) <= std_logic_vector(Udata_rs(itr));
                    Vdata_o((itr+1)*data_size_g-1 downto itr * data_size_g) <= std_logic_vector(Vdata_rs(itr));
                end loop;
                
            end if;
        end if;
end process;
            
end architecture;