----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2018 10:36:18
-- Design Name: 
-- Module Name: maquinacontrolador - Behavioral
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

entity dsed_audio is
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
end dsed_audio;

architecture Behavioral of dsed_audio is

component clk_12Megas is
    port (clk_in1: in std_logic;
       reset : in std_logic;
       clk_out1 :out std_logic);
end component;       

component MemoriaRAM is
  port (clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
         wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component audio_interface is
 Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           record_enable : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           play_enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwd : out STD_LOGIC);
end component;
           
component fir_filter is
    port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in signed (sample_size-1 downto 0); --<1,7>
       sample_in_enable : in STD_LOGIC;
       filter_select : in STD_LOGIC; --0 paso bajo y 1 paso alto
       sample_out : out signed (sample_size-1 downto 0); --<1,7>
       sample_out_ready : out STD_LOGIC);      
end component;


component maquinacontrolador is
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
       contadormemoria: out std_logic_vector(18 downto 0);
       play_enable: out std_logic);
end component;

signal sample_in_enable: std_logic;

--señales memoria

signal contadormemoria_addra: std_logic_vector(18 downto 0); --creo que esta 

signal wea: std_logic_vector(0 downto 0);
signal out_memoria: std_logic_vector(7 downto 0);

--señales audio_interface
signal clk_12M, play_enable,sample_out_ready_audio, sample_request, jack_pwm1 ,jack_sd1, micro_clk3, micro_LR1: std_logic;
signal sample_out_audio: STD_LOGIC_VECTOR (7 downto 0);

--señales filtro
signal sample_out_filter: signed(sample_size-1 downto 0);
signal sample_out_ready_filter,sample_in_enable_filter: std_logic;

--señal registro
signal signal_register: std_logic_vector(sample_size-1 downto 0);

begin


U0: clk_12Megas 
    port map (clk_in1 => clk_100Mhz,
           reset =>'0',
           clk_out1 => clk_12M);
           
U1: MemoriaRAM 
    port map (clka => clk_12M,
              ena => '1',
              wea => wea,
              addra => contadormemoria_addra,
              dina =>sample_out_audio,
              douta =>out_memoria);

            
U2 : audio_interface 
                  port map (clk_12megas => clk_12M,
                            reset => reset,
                            record_enable => BTNL,
                            sample_out => sample_out_audio,
                            sample_out_ready => sample_out_ready_audio,
                            micro_clk =>micro_clk3,
                            micro_data =>micro_data,
                            micro_LR => micro_LR1,
                            play_enable =>play_enable,
                            sample_in => signal_register,
                            sample_request => sample_request,
                            jack_sd => jack_sd1,
                            jack_pwd =>jack_pwm1);
                                            
U3 : fir_filter 
                port map (clk=> clk_12M,
                          reset => reset,
                          sample_in => signed(out_memoria),
                          sample_in_enable => sample_in_enable_filter,
                          filter_select => SW0,
                          sample_out =>sample_out_filter,
                          sample_out_ready =>sample_out_ready_filter);
                          
 U4: maquinacontrolador
                port map (clk_12M=>clk_12M,
                          reset=>reset,
                          BTNL => BTNL,
                          BTNC => BTNC,
                          BTNR => BTNR,
                          SW0 =>SW0,
                          SW1 =>SW1,
                          sample_out_ready_filter=> sample_out_ready_filter,
                          sample_out_ready_audio=>sample_out_ready_audio,
                          sample_request=>sample_request,
                          out_memoria=> signed(out_memoria),
                          sample_out_filter=>sample_out_filter,                          
                          sample_fir_enable => sample_in_enable_filter,
                          wea => wea,
                          signal_register => signal_register,
                          contadormemoria=>contadormemoria_addra,
                          play_enable => play_enable);
                                                  
 
 
micro_clk<=micro_clk3;
micro_LR<=micro_LR1;
jack_sd<=jack_sd1;
jack_pwm<=jack_pwm1;
               
end Behavioral;