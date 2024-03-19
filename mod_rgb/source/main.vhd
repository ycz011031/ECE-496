----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/03/19 15:18:25
-- Design Name: 
-- Module Name: main - 
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
use IEEE.STD_LOGIC_1164.ALL;

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