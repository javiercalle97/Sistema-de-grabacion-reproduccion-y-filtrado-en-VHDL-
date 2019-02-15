----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2018 11:52:33
-- Design Name: 
-- Module Name: mux1 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity mux3 is
         Port ( c0 : in signed (7 downto 0); 
         selmux3 : in STD_LOGIC_VECTOR (2 downto 0);
         outmux3: out signed (7 downto 0));
end mux3;
architecture Behavioral of mux3 is

begin
process(c0, selmux3)
begin
    case selmux3 is
        when "000"=> outmux3 <= (others=>'0');
        when "001"=> outmux3 <= (others=>'0');
        when "010"=> outmux3 <= (others=>'0');
        when others => outmux3 <=c0;

    end case;
end process;        
end Behavioral;


