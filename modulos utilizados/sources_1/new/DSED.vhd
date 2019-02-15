----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2018 12:10:41
-- Design Name: 
-- Module Name: DSED - Behavioral
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

package DSED is
    constant sample_size: integer:=8;
    constant delay_memoriaRAM: time:=2*83 ns;
    type std_logic_2d is
        array(integer range<>, integer range <>) of std_logic;
    function log2c(n: integer) return integer;
end DSED;


package body DSED is 
    
    FUNCTION log2c (n:integer) return integer is 
        variable m,p:integer;
    begin 
        m := 0;
        p := 1;
        while p < n loop
            m := m+1;
            p := p*2;
    end loop;
    return m;
 end log2c;
end DSED; 

