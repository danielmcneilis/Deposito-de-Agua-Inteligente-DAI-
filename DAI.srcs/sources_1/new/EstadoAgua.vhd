-----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2026 16:26:28
-- Design Name: 
-- Module Name: EstadoAgua - Behavioral
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

entity EstadoAgua is
    generic(
        ALTURA_BIDON : integer -----Altura en cm
    );
    Port ( 
        clk : in std_logic;
        reset : in std_logic;
        echo : in std_logic; ----- DEL SENSOR
        trigger : out std_logic; ----- DEL SENSOR
        altura : out std_logic_vector (4 downto 0)
        
        
    );
end EstadoAgua;

architecture Behavioral of EstadoAgua is

    component Generador_de_pulsos is
        port( 
            reset, clk : in std_logic ;
            pulso : out std_logic 
        );
    end component;

    component Contador_de_distancia is
        Port ( 
            clk : in std_logic;
            reset : in std_logic; 
            echo : in std_logic; 
            salida : out  std_logic_vector (8 downto 0) -----en cm 
        );
    end component;
    
    signal distancia : std_logic_vector (8 downto 0);
    signal altura_agua : integer := 0;


begin
    
    GENERADOR_TRIGGER: Generador_de_pulsos 
        port map (
            reset => reset,
            clk => clk,
            pulso => trigger
        );
        
    CONTADOR_DISTANCIA: Contador_de_distancia 
        port map (
            clk => clk,
            reset => reset,
            echo => echo,
            salida => distancia
        );
        
        
        
    process (distancia, reset)
        variable dist_int : integer;
    begin
        if reset = '1' then
            altura_agua <= 0;
        else
            dist_int := to_integer(unsigned(distancia));
            
            if dist_int >= ALTURA_BIDON then
                altura_agua <= 0;
            else 
                altura_agua <= ALTURA_BIDON - dist_int;
            end if;
        end if;
        
        altura <= std_logic_vector(to_unsigned(altura_agua, 5));
        
    end process;
            
            
    
          


end Behavioral;
