----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2018 11:00:38
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in signed (sample_size-1 downto 0); --<1,7>
           sample_in_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC; --0 paso bajo y 1 paso alto
           sample_out : out signed (sample_size-1 downto 0); --<1,7>
           sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is

component mux1 is
    Port ( c0 : in signed (7 downto 0); --hay que ponerlos en funcion 
       c1 : in signed (7 downto 0);
       c2 : in signed (7 downto 0);
       c3 : in signed (7 downto 0);
       c4 : in signed (7 downto 0);
       selmux : in STD_LOGIC_VECTOR (2 downto 0); --3 bits para controlar las 5 entradas
       outmux: out signed(7 downto 0));
end component;

component mux3 is
         Port ( c0 : in signed (7 downto 0); --hay que ponerlos en funcion 
        selmux3 : in STD_LOGIC_VECTOR(2 downto 0); 
        outmux3: out signed(7 downto 0));
end component;

--declaracion de señales
type state_type is (idle,bucle);
signal state_reg, state_next:state_type;
signal X0_reg, X0_next, X1_reg, X1_next, X2_reg, X2_next, X3_reg, X3_next, X4_reg, X4_next, c0, c1, c2, c3, c4, outmux1, outmux2, sum1: signed(sample_size-1 downto 0);
signal r1_next, r1_reg, r2_reg,r2_next, r3_reg, r3_next, sample_out_reg, sample_out_next: signed(sample_size-1  downto 0); 
signal out_mult : signed (15 downto 0); -- para poder truncar luego
signal out_suma : signed(7 downto 0); 
signal selmux_next, selmux_reg: std_logic_vector( 2 downto 0);
signal sum2: signed (11 downto 0);
signal outmux3: signed (7 downto 0);

--ff's
signal FF1_next, FF1_reg, FF2_next, FF2_reg: std_logic;
signal FF3_next, FF3_reg, FF4_next, FF4_reg: std_logic;
signal FF5_next, FF5_reg, FF6_next, FF6_reg, FF7_next, FF7_reg: std_logic;

begin

M1: mux1
    port map ( c0 => c0,
       c1 => c1,
       c2 => c2,
       c3 => c3,
       c4 => c4,
       selmux => selmux_reg,
       outmux => outmux1);
       
M2: mux1
    port map ( c0 => X0_reg,
              c1 => X1_reg,
              c2 => X2_reg,
              c3 => X3_reg,
              c4 => X4_reg,
              selmux => selmux_reg,
              outmux => outmux2);            
M3: mux3
   port map ( c0 => out_suma,
              selmux3 =>selmux_reg,
              outmux3 =>outmux3);     
             
filter_type: process(filter_select)
begin      
           if( filter_select = '0') then         -- paso bajo
                C0 <= "00000100"; --    0.039
                C1 <= "00011111"; --    0.2422
                C2 <= "00111000"; --    0.4453
                C3 <= "00011111"; --    0.2422
                C4 <= "00000100"; --    0.039
            else                                 -- paso alto
                C0 <= "11111111"; --    -0.0078
                C1 <= "11100110"; --    -0.2031
                C2 <= "01001100"; --     0.6015
                C3 <= "11100110"; --    -0.2031
                C4 <= "11111111"; --    -0.0078               
            end if;      
end process;

desplazamiento_xn: process(sample_in,sample_in_enable, X0_reg, X1_reg, X2_reg, X3_reg, X4_reg, clk) --desplazamiento de Xn 
begin
    X4_next<=X4_reg;
    X3_next<=X3_reg;
    X2_next<=X2_reg;
    X1_next<=X1_reg;  
    X0_next<=X0_reg;
   if(sample_in_enable = '1') then
        X0_next<=sample_in;
        X4_next<=X3_reg;
        X3_next<=X2_reg;
        X2_next<=X1_reg;
        X1_next<=X0_reg;
        
    end if; 
end process;


clk_process: process(clk, reset) 
begin 
    if (clk'event and clk= '1') then 
        if (reset = '1') then 
            r1_reg <= (others => '0');
            r2_reg <= (others => '0');
            r3_reg <= (others => '0');
            X4_reg<= (others => '0');
            X3_reg<= (others => '0');
            X2_reg<= (others => '0');
            X1_reg<= (others => '0'); 
            X0_reg<= (others => '0');
            FF1_reg <= '0';
            FF2_reg <= '0';
            FF3_reg <= '0';
            FF4_reg <= '0';
            FF5_reg <= '0';
            FF6_reg <= '0';
            FF7_reg <= '0';          
        else 
             sample_out_reg<=sample_out_next;
             selmux_reg <= selmux_next;   
             state_reg <= state_next;    
             r1_reg <= r1_next; 
             r2_reg <= r2_next;            
             r3_reg <= r3_next;
             X4_reg<=X4_next;
             X3_reg<=X3_next;
             X2_reg<=X2_next;
             X1_reg<=X1_next;  
             X0_reg<=X0_next;   
             FF1_reg <= FF1_next;
             FF2_reg <= FF2_next;  
             FF3_reg <= FF3_next;
             FF4_reg <= FF4_next;  
             FF5_reg <= FF5_next;
             FF6_reg <= FF6_next;  
             FF7_reg <= FF7_next; 
     end if;   
    end if;
end process;

process_maquinadeestados: process(state_reg, selmux_reg, outmux1, outmux2, r1_reg, r2_reg, r3_reg, sample_in_enable, out_mult, out_suma)
begin

r1_next<=r1_reg; 
r2_next<=r2_reg; 
r3_next<=r3_reg; 
selmux_next<=selmux_reg;

case state_reg is 
    when idle => 
           r1_next <= (others => '0');
           r2_next <= (others => '0');
           r3_next <= (others => '0');
           selmux_next <= (others => '0');
  
           if sample_in_enable = '1' then          
                state_next <= bucle;
           else 
                state_next <=idle;
           end if;
                      
    when bucle => 
            r3_next <= out_suma(7 downto 0);
            r2_next <= r1_reg;
            r1_next <= out_mult(14 downto 7);
            selmux_next <= std_logic_vector(unsigned(selmux_reg) + "001");
            
            if(selmux_reg = "110") then 
                state_next <= idle;
            else 
                state_next <= bucle;
            end if;                                  
end case;
end process;

--definicion de las operaciones de suma y multiplicacion
out_mult<= outmux1 * outmux2;
out_suma <= r2_reg + r3_reg; 

--Retardo samle_in_enable
process(FF1_reg, FF2_reg, FF3_reg, FF4_reg, FF5_reg, FF6_reg, sample_in_enable)
begin 

        FF1_next <= sample_in_enable;
        FF2_next <=FF1_reg;
        FF3_next <=FF2_reg;
        FF4_next <=FF3_reg;
        FF5_next <=FF4_reg;
        FF6_next <=FF5_reg;
        FF7_next <=FF6_reg;
        

end process;
  
process(clk, r3_reg, selmux_reg, sample_out_reg)
begin
 sample_out_next<= sample_out_reg;
 if(selmux_reg) ="111" then
    sample_out_next<= r3_reg;
  
end if;   
end process;

sample_out_ready<=FF7_reg;  
sample_out<=sample_out_reg;
 
end Behavioral;
