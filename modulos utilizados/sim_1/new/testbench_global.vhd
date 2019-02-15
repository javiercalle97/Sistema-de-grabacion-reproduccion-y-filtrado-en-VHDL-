----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2018 16:18:11
-- Design Name: 
-- Module Name: testbench_global - Behavioral
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

entity testbench_global is
--  Port ( );
end testbench_global;

architecture Behavioral of testbench_global is

constant clk_period_100M: time := 10ns;  --100MHz
constant clk_period_12M: time := 83ns;

component dsed_audio 
    Port ( clk_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           SW0 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end component;

signal clk_100M, reset, BTNL, BTNC, BTNR, SW0, SW1, micro_clk, micro_data, micro_LR,jack_sd, jack_pwm: STD_LOGIC;
signal a, b, c: std_logic := '0';
begin

uut: dsed_audio 
    port map(clk_100Mhz => clk_100M,
           reset => reset,
           BTNL => BTNL,
           BTNC => BTNC,
           BTNR => BTNR,
           SW0 => SW0,
           SW1 => SW1,
           micro_clk => micro_clk,
           micro_data => micro_data,
           micro_LR => micro_LR,
           jack_sd => jack_sd,
           jack_pwm => jack_pwm);

clk_process: process
             begin
             clk_100M<='1';
             wait for clk_period_100M/2;
             clk_100M<='0';
             wait for clk_period_100M/2; 
             end process;
             
             
  --sample_in<=std_logic_vector(unsigned(sample_in) + 20) after 50us;
           a <= not a after 1300 ns;
           b <= not b after 2100 ns;
           c <= not c after 3700 ns;
           micro_data <= a xor b xor c;
process
begin

reset <= '1'; 
wait for clk_period_12M;

-- Grabamos

    reset <= '0';
    BTNL <= '1';--grabo
    BTNR <= '0';
    BTNC <= '0'; 

    SW0 <= '0';
    SW1 <= '0';
    
    wait for 500 us;
       BTNL <= '0';
       BTNR <= '0';
       BTNC <= '0'; 
    wait for 100us; 
       SW0 <= '0';
       SW1 <= '1'; -- filtro paso bajo 
      
       BTNL <= '0';
       BTNR <= '1';
       BTNC <= '0'; 
       wait for clk_period_12M;
       BTNL <= '0';
       BTNR <= '0';
       BTNC <= '0';          
     wait for 500us;   
    
    --------------------------PRUEBA RESET-----------------
--       wait for 500 us;
--           BTNL <= '0';
--           BTNR <= '0';
--           BTNC <= '0'; 
--       wait for 100us; 
--           BTNL <= '0';
--           BTNR <= '1';
--           BTNC <= '0'; 
--       wait for 500us; 
--           BTNL <= '0';
--           BTNR <= '0';
--           BTNC <= '0'; 
--       wait for 100us;    
--           BTNL <= '0';
--           BTNR <= '0';       
--           BTNC <= '0'; 
--           reset<='1';   
--        wait for 100 us; 
--            reset <='0';
--            BTNL <= '0';
--            BTNR <= '1';        --reproducimos (no se deberia haber borrado la memoria) 
--            BTNC <= '0';       
        
    
    
    
    
    
 --------------------------PRUEBA DEL CLEAR ----------------------------------
    
--   wait for 500 us;
--       BTNL <= '0';
--       BTNR <= '0';
--       BTNC <= '0'; 
--   wait for 100us; 
--       BTNL <= '0';
--       BTNR <= '1';
--       BTNC <= '0'; 
--   wait for 500us; 
--       BTNL <= '0';
--       BTNR <= '0';
--       BTNC <= '0'; 
--   wait for 100us;    
--       BTNL <= '0';
--       BTNR <= '0';
--       BTNC <= '1';     --borramos la memoria
--    wait for 100 us;
    
--       BTNL <= '0';
--       BTNR <= '0';
--       BTNC <= '0'; 
--     wait for 100us;
     
--       BTNL <= '0';
--       BTNR <= '1';     -- no deberia reproducir nada
--       BTNC <= '0';   


---------------------------------------PRUEBA REPRODUCIR NORMAL----------------------------------------

--wait for 1ms;
--    BTNL <= '0';
--    BTNR <= '0';
--    BTNC <= '0'; 
--wait for 100us;
---- Leemos sin filtro y normal    
--    SW0 <= '0';
--    SW1 <= '0';    
--    BTNL <= '0';
--    BTNR <= '1';
--    BTNC <= '0'; 
-- wait for clk_period_12M; 
--    BTNL <= '0';
--    BTNR <= '0'; 
--    BTNC <= '0'; 
     
--wait for 1ms;




    
wait; 
end process; 


end;
