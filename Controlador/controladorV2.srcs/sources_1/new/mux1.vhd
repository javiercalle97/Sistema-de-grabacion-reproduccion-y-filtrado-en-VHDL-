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

entity mux1 is
    Port ( c0 : in signed (7 downto 0); --hay que ponerlos en funcion 
           c1 : in signed (7 downto 0);
           c2 : in signed (7 downto 0);
           c3 : in signed (7 downto 0);
           c4 : in signed (7 downto 0);
           selmux : in STD_LOGIC_VECTOR (2 downto 0); --3 bits para controlar las 5 entradas
           outmux: out signed(7 downto 0));
end mux1;

architecture Behavioral of mux1 is
begin
process(c0, c1, c2, c3, c4, selmux)
begin
    case selmux is
        when "000" => outmux <=c0;
        when "001" => outmux <=c1;
        when "010" => outmux <=c2;
        when "011" => outmux <=c3;
        when "100" => outmux <=c4;
        when others => outmux <= (others =>'0');
    end case;
end process;        
end Behavioral;

