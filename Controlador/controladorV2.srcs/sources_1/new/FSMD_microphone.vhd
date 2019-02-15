----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2018 12:59:13
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
    
    Port ( clk_12megas : in STD_LOGIC;
           en_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is
    type state_type is (idle,S1, S2, S3);
    signal state_reg, state_next:state_type;
 
--declaracion de señales
signal dato1reg, dato1next, dato2reg, dato2next, dato1fijo, dato2fijo, sample_out_next, sample_out_reg: std_logic_vector (sample_size-1 downto 0):=(others=>'0');
signal primer_ciclo_reg, primer_ciclo_next: std_logic:='0';
signal cuenta_reg, cuenta_next : std_logic_vector(log2c(299)-1 downto 0);


begin

--state register
process(clk_12megas, en_4_cycles, reset)
begin
 
    if(reset='1') then
        dato1reg<=(others=>'0');
        dato2reg<=(others=>'0');
        cuenta_reg<=(others=>'0');     
    elsif(clk_12megas'event and clk_12megas='1') then   
        if(en_4_cycles='1') then
             state_reg<=state_next;
            cuenta_reg<=cuenta_next;
            dato1reg<=dato1next;   
            dato2reg<=dato2next; 
            primer_ciclo_reg<=primer_ciclo_next;
            sample_out_reg<=sample_out_next;
            end if; 
        end if;      
end process;


--next state
process(micro_data, state_reg, cuenta_reg, primer_ciclo_reg, dato1reg, dato2reg, en_4_cycles)
begin
    primer_ciclo_next<=primer_ciclo_reg;
    cuenta_next<=cuenta_reg;
    case state_reg is 
when idle => 
    state_next <=S1;
    
when S1 => --entre 0 y 105 o entre 150 y 255
    
        cuenta_next<=std_logic_vector(unsigned(cuenta_reg) + 1);
                  
        if(micro_data='1') then
           dato1next<=std_logic_vector(unsigned(dato1reg)+ 1);   
           dato2next<=std_logic_vector(unsigned(dato2reg)+ 1);      
        else
           dato1next<=dato1reg;
           dato2next<=dato2reg;
        end if; 
 
        if (cuenta_reg="001101001") then--cuando llega a 105 cambia de estado, si no se queda aquí
        dato2fijo<=dato2reg; 
            state_next<=S2;
        elsif (cuenta_reg="011111111") then--cuando llega a 255 cambia de estado, si no se queda aquí
        dato1fijo<=dato1reg;  
            state_next<=S3;
        else
            state_next<=S1;   
        end if;             
      
               
 when S2 =>--entre 106 y 149
       cuenta_next<=std_logic_vector(unsigned(cuenta_reg) + 1);  
       if(micro_data='1') then
          dato1next<=std_logic_vector(unsigned(dato1reg)+1);
          dato2next<=dato2reg;
       else
          dato1next<=dato1reg;
          dato2next<=dato2reg;
       end if;  
         
      if(cuenta_reg="001101010") then --106
       -- dato2fijo<=dato2reg;
        dato2next<=(others=>'0');  
      end if;
        
      if(cuenta_reg="010010101") then--cambia si llega al limite 149
         state_next<=S1;
      else
         state_next<=S2;
      end if;             
        
when S3 => --entre 256 y 299
      
     if(micro_data='1') then
        dato2next<=std_logic_vector(unsigned(dato2reg)+1);
     else
        dato2next<=dato2reg;    
     end if;
          
     if(cuenta_reg="100000000") then--256
        --dato1fijo<=dato1reg;
       -- sample_out<=dato1fijo;
       dato1next<=(others=>'0');
     end if;
     
     if(cuenta_reg="100101011") then--cambia cuando llega a 299, si no se mantiene aquí
        cuenta_next<=(others=>'0');
        primer_ciclo_next<='1';
        state_next<=S1;
     else
        cuenta_next<=std_logic_vector(unsigned(cuenta_reg) + 1);
        state_next<=S3;
        
     end if;     
       
end case;
end process;
 
--output 
process(en_4_cycles, cuenta_reg, primer_ciclo_reg, dato1fijo, dato2fijo, sample_out_reg)
begin
  
  if(cuenta_reg="100000000" or(primer_ciclo_reg='1' and cuenta_reg="001101010")) then --si 256 o pc=1 y 106
   sample_out_ready<='1' and en_4_cycles; 
  else
    sample_out_ready<='0';  
end if;

   if(cuenta_reg<="001101001" or cuenta_reg>="100000000") then --si 105 o 256
    sample_out_next<=dato1fijo;
   elsif("001101010" <=cuenta_reg and cuenta_reg<="011111110")then -- si 106 y 254
    sample_out_next<=dato2fijo;
   else 
   sample_out_next <= sample_out_reg; 
    end if;

end process;


sample_out<=sample_out_reg;
end Behavioral;

