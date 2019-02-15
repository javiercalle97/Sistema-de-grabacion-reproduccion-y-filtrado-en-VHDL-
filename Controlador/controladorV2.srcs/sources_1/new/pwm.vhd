----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2018 19:52:04
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use work.DSED.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is

    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is
 
 --declaracion de señales
 signal r_reg, r_next : unsigned(sample_size downto 0):="000000000";--9 bits para poder contar hasta 299
 signal buf_reg, buf_next, ready_next, ready_reg, requ_next, requ_reg: std_logic:='0';
 
begin

--register and output buffer
process(clk_12megas, en_2_cycles, reset)
begin
    if(reset='1') then
        r_reg<= (others=>'0');
        buf_reg<='0';
    elsif(clk_12megas'event and clk_12megas='1') then
        if(en_2_cycles='1') then
        r_reg<=r_next;
        buf_reg<=buf_next;
        requ_reg<=requ_next;
        ready_reg<=ready_next;
        end if;
    end if;        
end process;

--next state logic 
process(r_reg)
begin
    if(r_reg=299) then
        ready_next<='1';
        r_next<=(others=>'0');
        
    else 
     ready_next<='0';              
     r_next<=r_reg+1;
    end if;
end process;

-- output logic
buf_next<=
   '1' when((r_reg<unsigned(sample_in)) or (sample_in="00000000")) else  
   '0';
   
pwm_pulse<=buf_reg;     

sample_request<= (ready_reg and (not en_2_cycles));


--sample_request<=requ_reg;
end Behavioral;
