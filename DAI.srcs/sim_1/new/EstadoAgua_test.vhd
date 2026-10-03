----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2026 18:10:16
-- Design Name: 
-- Module Name: EstadoAgua_test - Behavioral
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

entity EstadoAgua_test is
--  Port ( );
end EstadoAgua_test;

architecture Behavioral of EstadoAgua_test is
    component EstadoAgua is
        generic (
            ALTURA_BIDON : integer
        );
        Port ( 
            clk : in std_logic;
            reset : in std_logic;
            echo : in std_logic;
            trigger : out std_logic;
            led : out std_logic_vector (2 downto 0) ------Salida [2] = ALTA -- Salida[1] = MEDIA ---Salida[0] = BAJA
            
        );
    end component;
    
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal echo  : std_logic := '0';
    signal trigger : std_logic;
    signal led  : std_logic_vector(2 downto 0);

    constant clk_period  : time := 10 ns;
    
    
    
----SIMULAICON DEL SENSOR-------------------------
    procedure simular_medicion (
            constant cm          : in integer;
            signal   echo_signal : out std_logic
        ) is
        begin
            echo_signal <= '1';
            wait for cm * 58000 ns;
            echo_signal <= '0';
            wait for 500 us;  -- pausa entre mediciones
        end procedure;

begin

    UUT : EstadoAgua
        generic map (ALTURA_BIDON => 30)
        port map (
            clk   => clk,
            reset => reset,
            echo  => echo,
            trigger => trigger,
            led  => led
        );

    -- Generador de reloj
    clk_process : process
    begin
        clk <= '0'; wait for clk_period / 2;
        clk <= '1'; wait for clk_period / 2;
    end process;

    -- Proceso de pruebas
    Pruebas : process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 200 ns;

        -- CASO 1: Bidon VACIO
        -- Sensor mide 30 cm → altura_agua = 30 - 30 = 0 cm → leds = "000"
        simular_medicion(30, echo);

        -- CASO 2: Nivel BAJO (1/3)
        -- Sensor mide 20 cm → altura_agua = 30 - 20 = 10 cm → leds = "001"
        simular_medicion(20, echo);

        -- CASO 3: Nivel MEDIO (2/3)
        -- Sensor mide 10 cm → altura_agua = 30 - 10 = 20 cm → leds = "011"
        simular_medicion(10, echo);

        -- CASO 4: Bidon LLENO
        -- Sensor mide 0 cm → altura_agua = 30 - 0 = 30 cm → leds = "111"
        -- Usamos 1 cm porque 0 es imposible en la practica
        simular_medicion(1, echo);

        -- CASO 5: Distancia invalida (sensor al aire, > altura bidon)
        -- Sensor mide 40 cm → altura_agua = 0 (proteccion) → leds = "000"
        simular_medicion(40, echo);

        -- CASO 6: Dos mediciones seguidas para verificar
        -- que distancia se resetea correctamente entre pulsos
        simular_medicion(15, echo);  -- altura_agua = 15 cm → leds = "001"
        simular_medicion(5, echo);   -- altura_agua = 25 cm → leds = "011"

        wait;
    end process;


end Behavioral;
