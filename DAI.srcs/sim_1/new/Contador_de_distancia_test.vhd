-----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 12:00:50
-- Design Name: 
-- Module Name: Contador_de_distancia_test - Behavioral
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

entity Contador_de_distancia_test is
--  Port ( );
end Contador_de_distancia_test;

architecture Behavioral of Contador_de_distancia_test is
    
    component Generador_de_pulsos is
        port( 
            reset, clk : in std_logic ;
            pulso : out std_logic 
        );
    end component;
    
    signal reset : std_logic :=  '0';
    signal clk : std_logic :=  '0';
    signal salida : std_logic;
    
    constant clk_period : time := 10ns;
    
    
begin
    uut: Generador_de_pulsos port map 
        (
            clk => clk,
            reset => reset,
            pulso => salida        
        );
        
    clk_process : process
                    begin
                        clk <= '0'; 
                            wait for clk_period /2;
                        clk <= '1';
                            wait for clk_period /2;
                    end process;
                    
     Pruebas:
        process
        begin   
            reset <= '1';
            wait for 50 ns;
            -------------------
            reset <= '0';
            wait for 100 ns;
            
            wait;
                    
        end process;
        
        

end Behavioral;
