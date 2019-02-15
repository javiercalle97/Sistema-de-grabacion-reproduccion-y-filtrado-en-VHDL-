----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2018 12:07:10
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity relojes is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end relojes;

architecture Behavioral of relojes is


signal count3reg, count3next: std_logic;
signal clk_state3next, clk_state3reg: STD_LOGIC:= '0';
signal clk_state6next, clk_state6reg: STD_LOGIC:= '0';
signal en_4next, en_4reg: STD_LOGIC:= '0';
begin
    
 --state register
 process(clk_12megas,reset)
begin
    if (reset='1')then
                clk_state3reg<='0';
                clk_state6reg <='0';

    elsif (clk_12megas'event and clk_12megas='1') then 
 
                 clk_state3reg<=clk_state3next;
                 clk_state6reg <=clk_state6next;
                 count3reg<=count3next;
      
    end if;                 
      
 end process;
 
 --next state            
 process(clk_state3reg, clk_state6reg, count3reg )
 begin
      --control para 3 megas
      if (count3reg = '0') then 
           count3next <= '1';
          clk_state3next <= clk_state3reg;
      else
            clk_state3next <= not clk_state3reg;
            count3next <= '0';    
     end if;
                
     --control para en_2_cycles (6 megas)
    clk_state6next <= not clk_state6reg;

 end process;
 
 --output
clk_3megas <= clk_state3reg;
en_2_cycles <= clk_state6reg;  
en_4_cycles<= '1' when (clk_state3reg ='1' and clk_state6reg='0') else
              '0';

end Behavioral;
