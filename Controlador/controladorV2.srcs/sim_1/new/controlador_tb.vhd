----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2018 12:48:36
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
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

entity controlador_tb is
--  Port ( );
end controlador_tb;

architecture Behavioral of controlador_tb is

  component maquinacontrolador
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
  
  constant clk_period: time := 83ns;  --12MHz 
  signal clk_100Mhz, reset, BTNL, BTNC, BTNR, SW0, SW1, micro_clk, micro_data, micro_LR, jack_sd, jack_pwm: STD_LOGIC;
begin

uut: maquinacontrolador          port map ( clk_100Mhz  => clk_100Mhz,
                                    reset => reset,
                                    BTNL => BTNL,
                                    BTNC => BTNC,
                                    BTNR => BTNR,
                                    SW0 => SW0
                                    SW1 => SW1,
                                    micro_clk => micro_clk,
                                    micro_data => micro_data,
                                    micro_LR => micro_LR,
                                    jack_sd => jack_sd,
                                    jack_pwm => jack_pwm,                                   
                                    );

clk_process: process
  begin
  clk<='1';
  wait for clk_period/2;
  clk<='0';
  wait for clk_period/2; 
  end process;


process
begin
reset <= '1'; 
wait for clk_period; 

reset <= '0'; 
record_enable <= '1';
micro_data <= 
end process;
end Behavioral;




  







  
