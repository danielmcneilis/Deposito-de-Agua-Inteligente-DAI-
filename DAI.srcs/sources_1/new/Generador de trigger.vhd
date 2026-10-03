----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2026 11:59:42
-- Design Name: 
-- Module Name: Generador de trigger - Behavioral
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

entity Generador_de_pulsos is
    port( 
        reset, clk : in std_logic ;
        pulso : out std_logic 
    );
    end Generador_de_pulsos;

architecture Behavioral of Generador_de_pulsos is
    constant ciclos_10us : integer := 1000; -- cuenta los ciclos de up
    constant ciclos_60ms : integer := 6000000;
    
    signal contador : integer range 0 to ciclos_60ms := 0;

begin
    process (clk, reset)
        begin
            if reset = '1' then
                    contador <= 0;
                    pulso <= '0';
                      
            elsif rising_edge (clk) then
                if contador >= ciclos_60ms then
                    contador <= 0;
                    pulso <= '1';
                else
                    contador <= contador +1;
                    if contador <  ciclos_10us then
                        pulso <= '1';
                    else
                        pulso <= '0';
                    end if;
                end if;
            end if;     
             
        end process;
                     
      
end Behavioral;
