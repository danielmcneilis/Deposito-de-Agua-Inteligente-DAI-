----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 18:15:57
-- Design Name: 
-- Module Name: Bomba - Behavioral
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

entity Bomba is
    generic(
        ALTURA_BIDON : integer -----Altura en cm
    );
    Port ( 
        clk : in std_logic; 
        reset : in std_logic;
        boton : in std_logic;
        altura : in std_logic_vector (4 downto 0); -----Conectar a las leds del estado de agua
        salida : out std_logic  ----enceder el relé
    );
end Bomba;

architecture Behavioral of Bomba is
    
    signal altura_recipiente : std_logic_vector(4 downto 0) := "00000";
    signal salida_interna : std_logic := '0';

begin
    process (clk, reset)
    begin
        if reset = '1' then 
            salida_interna <= '0';
        elsif rising_edge (clk) then
            altura_recipiente <= std_logic_vector(to_unsigned(ALTURA_BIDON, 5));
            if altura = altura_recipiente then
                salida_interna <= '1';
            elsif boton = '1' then
                if altura = "00000" then
                    salida_interna <= '0';
                else
                    salida_interna <= '1';
                end if;
            else 
                salida_interna <= '0';
            end if;
        end if;
             
    end process;    
    
    salida <= salida_interna;


end Behavioral;
