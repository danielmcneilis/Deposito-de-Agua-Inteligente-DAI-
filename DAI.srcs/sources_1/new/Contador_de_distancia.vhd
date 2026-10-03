-----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2026 12:04:38
-- Design Name: 
-- Module Name: Contador_de_distancia - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Contador_de_distancia is
    Port ( 
        clk : in std_logic;
        reset : in std_logic; 
        echo : in std_logic; 
        salida : out  std_logic_vector (8 downto 0) -----en cm
       
    );
end Contador_de_distancia;

architecture Behavioral of Contador_de_distancia is

    constant TICKS_POR_CM : integer := 5800;
    constant MAX_TICKS : integer := 9 * 5800 * 30; --1566000
    
    signal cuenta : integer range 0 to 1800000 := 0; ---metemos el 1800000 para tener algo de margen
    signal echo_prev : std_logic := '0';
    signal midiendo : std_logic := '0';
    signal dist_latch : integer range 0 to 1800000 := 0;
    
    
begin

    process (clk,reset)
    begin  
        if reset = '1' then
            cuenta     <= 0;
            echo_prev  <= '0';
            midiendo   <= '0';
            dist_latch <= 0;
            salida     <= (others => '0');

        elsif rising_edge(clk) then
            echo_prev <= echo;  -- guardamos el valor anterior para detectar flancos
            
            if echo = '1' and echo_prev = '0' then
                cuenta <= 0;
                midiendo  <= '1';

            elsif echo = '0' and echo_prev = '1' then
                midiendo <= '0';
                salida   <= std_logic_vector(to_unsigned((cuenta + (TICKS_POR_CM/2)) / 5800, 9));

            elsif midiendo = '1' then
                if cuenta < 1800000 then
                    cuenta <= cuenta + 1;

                end if;
            end if; 
        end if;      
         
     end process;
     


end Behavioral;
