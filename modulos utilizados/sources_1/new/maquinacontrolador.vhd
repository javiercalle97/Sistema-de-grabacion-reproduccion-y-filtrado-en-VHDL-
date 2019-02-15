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

entity maquinacontrolador is
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
end maquinacontrolador;

architecture Behavioral of maquinacontrolador is


type state_type is (idle, borra, graba, reproduce);
signal state_reg, state_next:state_type;


--señales memoria
signal contadormemoria_escribir_reg, contadormemoria_escribir_next, contador_aux : std_logic_vector(18 downto 0); --creo que esta bien
signal contadormemoria_leer_reg, contadormemoria_leer_next : std_logic_vector(18 downto 0); --creo que esta bien

signal clka, ena, primer_ciclo_reg, primer_ciclo_next : std_logic;
signal wea_reg, wea_next: std_logic_vector(0 downto 0);
--signal out_memoria: std_logic_vector(7 downto 0);

--señales audio_interface
signal  jack_pwm1 ,jack_sd1, micro_clk3, micro_LR1: std_logic;
signal sample_out_audio, sample_audio : STD_LOGIC_VECTOR (7 downto 0);

--señales filtro
signal sample_in_filter: signed(sample_size-1 downto 0);
signal  sample_in_enable_filter: std_logic;

--señal registro
signal registro_reg, registro_next: std_logic_vector(sample_size-1 downto 0);

--señal doble FF
signal FF1_next, FF1_reg, FF2_next, FF2_reg: std_logic;

begin

leer_escribir: process (BTNL, BTNR)
begin
    
    if(BTNL='1') then-- grabando        
       wea_next<="1";--ESCRIBIR
     else
     wea_next<="0";
     end if;
     
end process;

process(SW1, sample_in_enable_filter, sample_out_filter, out_memoria, sample_out_ready_filter, registro_reg, FF2_reg)
begin
if(SW1='1') then-- reproducir con filtro
    if(sample_out_ready_filter='1') then --enable de salida del filtro
        registro_next<=std_logic_vector(sample_out_filter);               
    else
        registro_next<=registro_reg;  
    end if;
                                                        
elsif(SW1='0') then   --sin filtro
    if(FF2_reg='1') then 
        registro_next<=std_logic_vector(out_memoria);               
   else
        registro_next<=registro_reg;  
   end if;
end if;    
end process;

--Retardo sample_request
process(FF1_reg, sample_request)
begin 

        FF1_next <= sample_request;
        FF2_next <=FF1_reg;

end process;   

                                             
--state register
process(clk_12M, reset)
begin
if(clk_12M'event and clk_12M='1') then
  
    if(reset='1') then
        contadormemoria_escribir_reg<=(others => '0');
        contadormemoria_leer_reg<=(others => '0');
        wea_reg<="0";
        registro_reg<=(others => '0');
        primer_ciclo_reg<='0';
        state_reg <= idle;
        FF1_reg <= '0';
        FF2_reg <= '0';     
     else
        state_reg <= state_next;  
        contadormemoria_escribir_reg<=contadormemoria_escribir_next;
        contadormemoria_leer_reg<=contadormemoria_leer_next;
        wea_reg<=wea_next;
        registro_reg<=registro_next;
        primer_ciclo_reg<=primer_ciclo_next;
        FF1_reg <= FF1_next;
        FF2_reg <= FF2_next;
    end if;
    end if;
end process;



--next state
process(state_reg, BTNL, BTNR, BTNC, SW0, SW1, contadormemoria_escribir_reg, contadormemoria_leer_reg,sample_out_ready_audio, sample_request, registro_reg,primer_ciclo_reg, FF2_reg)
begin
 play_enable <='0';
 contadormemoria_escribir_next<=contadormemoria_escribir_reg;
 contadormemoria_leer_next<=contadormemoria_leer_reg;
 sample_audio<=(others => '0'); 
primer_ciclo_next<=primer_ciclo_reg;
 
   case state_reg is
       
    when idle=>
        if(BTNL='1') then
             state_next<=graba;
             
        elsif( BTNR='1') then
            if (SW0='1' and SW1='0') then          
              contadormemoria_leer_next<=contadormemoria_escribir_reg;         
             else
              contadormemoria_leer_next<=(others => '0'); 
             end if;
             state_next<=reproduce;
              
        elsif(BTNC='1') then    
             state_next<=borra; 
        else      
            state_next<=idle;          
        end if;
        
     when borra=>
        contadormemoria_escribir_next<=(others => '0');
        state_next<=idle;
            
     when graba=>
     
        if(sample_out_ready_audio='1') then --cuando sale DATO1 o DATO2 lo mete en memoria
            contadormemoria_escribir_next<=std_logic_vector(unsigned(contadormemoria_escribir_reg) + 1);
        else
            contadormemoria_escribir_next<=contadormemoria_escribir_reg;
        end if;
        
        if(BTNL='1') then --si sigue presionando sigue grabando 
            state_next<=graba;
        else --deja de grabar
            state_next<=idle; --si suelta vuelve a idle
        end if;
    
        
     when reproduce=>
     play_enable <= '1';
     if (SW0='1' and SW1='0') then  --reproduce al revés  
     
            if (FF2_reg='1') then
                        
               if(contadormemoria_leer_reg>"0000000000000000000") then
                   contadormemoria_leer_next<=std_logic_vector(unsigned(contadormemoria_leer_reg) - 1);                                   
                   state_next<=reproduce;
                else
                   contadormemoria_leer_next<=(others => '0');            
                   state_next<=idle;
                end if;
            else
                contadormemoria_leer_next<=contadormemoria_leer_reg;
                state_next<=reproduce;
           end if;
                 
     else   --reproduce normal o filtros
          if (FF2_reg='1') then
                 if(contadormemoria_leer_reg<contadormemoria_escribir_reg) then
                     contadormemoria_leer_next<=std_logic_vector(unsigned(contadormemoria_leer_reg) + 1);
              
                     state_next<=reproduce;
                 else                 
                    contadormemoria_leer_next<=(others => '0');    
                     state_next<=idle;
                 end if;    
           else
                                contadormemoria_leer_next<=contadormemoria_leer_reg;
                                state_next<=reproduce;
           end if;  
end if;
end case;  
end process;


process(state_reg, contadormemoria_escribir_reg, contadormemoria_leer_reg,clk_12M) 
begin 
    if(state_reg = graba) then
        contador_aux <= contadormemoria_escribir_reg;
    elsif(state_reg = reproduce) then
        contador_aux <= contadormemoria_leer_reg;
    else
        contador_aux <= (others => '0');
    end if;
 
end process;


--output logic
wea<=wea_reg;
signal_register<=registro_reg; 
contadormemoria<=contador_aux;
                
sample_fir_enable<=FF2_reg when (SW1='1') else
                   '0';              
                 
end Behavioral;