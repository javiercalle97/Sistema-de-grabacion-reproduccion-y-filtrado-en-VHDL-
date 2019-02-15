----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2018 11:54:04
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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
use IEEE.numeric_std.ALL;
use work.DSED.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity maquinacontrolador_tb is
--  Port ( );
end maquinacontrolador_tb;

architecture Behavioral of maquinacontrolador_tb is

constant clk_period: time := 83ns;  --12MHz

  component maquinacontrolador
    Port ( clk_12M : in STD_LOGIC;
         reset : in STD_LOGIC;
         BTNL : in STD_LOGIC;
         BTNC : in STD_LOGIC;
         BTNR : in STD_LOGIC;
         SW0 : in STD_LOGIC;
         SW1 : in STD_LOGIC;
         sample_out_ready_filter : in STD_LOGIC;
         sample_out_ready_audio: in STD_LOGIC;
         sample_request : in STD_LOGIC;
         out_memoria : in signed (sample_size-1 downto 0);
         sample_out_filter : in signed (sample_size-1 downto 0);
         sample_fir_enable: out std_logic;
         wea: out std_logic_vector (0 downto 0);
         signal_register: out std_logic_vector(sample_size-1 downto 0);
         contadormemoria: out std_logic_vector(18 downto 0));
  end component;
  
signal clk_12megas, reset, sample_fir_enable, BTNL, BTNC, BTNR, SW0, SW1, sample_out_ready_filter, sample_out_ready_audio, sample_request: STD_LOGIC;
signal out_memoria, sample_out_filter : signed (sample_size-1 downto 0);
signal wea: std_logic_vector(0 downto 0);
signal contadormemoria: std_logic_vector (18 downto 0);
signal signal_register: std_logic_vector(sample_size-1 downto 0);
begin

uut: maquinacontrolador          port map ( clk_12M  => clk_12megas,
                                    reset => reset,
                                    BTNL => BTNL,
                                    BTNC => BTNC,
                                    BTNR => BTNR,
                                    SW0 => SW0,
                                    SW1 => SW1,
                                    sample_out_ready_filter => sample_out_ready_filter,
                                    sample_out_ready_audio => sample_out_ready_audio,
                                    sample_request => sample_request,
                                    out_memoria => out_memoria,
                                    sample_fir_enable=> sample_fir_enable,
                                    sample_out_filter => sample_out_filter,
                                    wea=>wea,
                                    signal_register=> signal_register,
                                    contadormemoria=> contadormemoria
                                    );

clk_process: process
  begin
  clk_12megas<='1';
  wait for clk_period/2;
  clk_12megas<='0';
  wait for clk_period/2; 
  end process;



process
begin

reset<='1';
wait for clk_period;
reset<='0';
BTNL<='1';--grabo
BTNR<='0';
BTNC<='0'; 

SW0<='0';--PARA GRABAR DA IGUAL
SW1<='0';

out_memoria<="00000011";
sample_out_filter<="00000111";
sample_out_ready_filter<='0';

sample_request<='0';




sample_out_ready_audio<='0';
wait for 300ns;
sample_out_ready_audio<='1';
wait for clk_period;
sample_out_ready_audio<='0';

wait for 600 ns;

--REPRODUZCO
BTNL<='0';
BTNR<='1';
BTNC<='0'; 

SW0<='1';--REPRODUCCION NORMAL
SW1<='1';
wait for 200ns;
sample_out_ready_filter<='1';
wait for clk_period;
sample_out_ready_filter<='0';

sample_request<='1';
wait for clk_period;
sample_request<='0';
 
BTNC<='1'; --borro audio
BTNL<='0';
BTNR<='0'; 
wait for 500 ns;

BTNL<='1';--vuelvo a graboar
BTNR<='0';
BTNC<='0'; 
sample_out_ready_audio<='0';
wait for 300ns;
sample_out_ready_audio<='1';
wait for clk_period;
sample_out_ready_audio<='0';


wait;
end process;

end;
