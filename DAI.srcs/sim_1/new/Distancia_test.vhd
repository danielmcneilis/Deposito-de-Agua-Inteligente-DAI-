----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2026 12:35:56
-- Design Name: 
-- Module Name: Distancia_test - Behavioral
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

entity Distancia_test is
--  Port ( );
end Distancia_test;

architecture Behavioral of Distancia_test is

    component Contador_de_distancia is
        Port ( 
            clk : in std_logic;
            reset : in std_logic; 
            echo : in std_logic; 
            salida : out  std_logic_vector (8 downto 0) -----en cm
           
        );
        end component;
        
    signal reset : std_logic :=  '0';
    signal clk : std_logic :=  '0';
    signal echo : std_logic := '0';
    signal salida : std_logic_vector (8 downto 0);
    
    constant clk_period : time := 10ns;
    
    
begin
    uut: Contador_de_distancia port map 
        (
            clk => clk,
            reset => reset,
            echo => echo,
            salida => salida         
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
            reset <= '0';-------- PAra revisar el reset de la distancia
            wait for 50 ns;
            -------------------
            
            echo <= '1';
            wait for 174000 ns; ---Distancia de 3 cm
            echo <= '0';
            wait for 500ns;
            
            echo <= '1';
            wait for 290000 ns;
            echo <= '0';
            
            wait;
                    
        end process;
        
        

end Behavioral;