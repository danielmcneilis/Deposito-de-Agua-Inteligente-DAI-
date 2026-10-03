----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2026 12:37:05
-- Design Name: 
-- Module Name: Bidon_test - Behavioral
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

entity Bidon_test is
--  Port ( );
end Bidon_test;

architecture Behavioral of Bidon_test is

component Bidon is
        generic (
            ciclo  : std_logic_vector (7 downto 0) := "01000000";
            ALTURA : integer := 30
        );
        Port (
            clk     : in std_logic;
            reset   : in std_logic; 
            trigger : out std_logic;
            echo    : in std_logic;
            led     : out std_logic_vector (2 downto 0);
            sw      : in std_logic_vector (1 downto 0);
            IN1     : out std_logic;
            IN2     : out std_logic;
            ENA     : out std_logic;
            boton   : in std_logic;
            rele    : out std_logic;
            seg     : out std_logic_vector (6 downto 0);
            an      : out std_logic_vector (3 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal echo    : std_logic := '0';
    signal sw      : std_logic_vector (1 downto 0) := "00";
    signal boton   : std_logic := '0';
    signal trigger : std_logic;
    signal led     : std_logic_vector (2 downto 0);
    signal IN1     : std_logic;
    signal IN2     : std_logic;
    signal ENA     : std_logic;
    signal rele    : std_logic;
    signal seg     : std_logic_vector (6 downto 0);
    signal an      : std_logic_vector (3 downto 0);

    constant CLK_PERIOD  : time    := 10 ns;
    constant ALTURA_TEST : integer := 30;

    -- Simula el echo del HC-SR04 para una distancia dada
    -- El echo dura: distancia_cm * 58 us
    procedure simular_echo(
        distancia_cm : in integer;
        signal echo  : out std_logic
    ) is
    begin
        wait until rising_edge(trigger);
        wait for 100 us; -- retardo de propagacion
        echo <= '1';
        wait for distancia_cm * 58 us; -- duracion del echo
        echo <= '0';
    end procedure;

begin

    UUT: Bidon
        generic map (
            ciclo  => "10000000", -- 50%
            ALTURA => ALTURA_TEST
        )
        port map (
            clk     => clk,
            reset   => reset,
            trigger => trigger,
            echo    => echo,
            led     => led,
            sw      => sw,
            IN1     => IN1,
            IN2     => IN2,
            ENA     => ENA,
            boton   => boton,
            rele    => rele,
            seg     => seg,
            an      => an
        );

    clk <= not clk after CLK_PERIOD / 2;

    -- ============================================
    -- Proceso que simula el sensor HC-SR04
    -- ============================================
    process
    begin

        -- TEST 1: Reset inicial
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- ============================================
        -- TEST 2: Bidon vacio (distancia = ALTURA = 30cm)
        -- altura=0, peltier OFF, bomba OFF, leds OFF
        -- ============================================
        sw    <= "00";
        boton <= '0';
        simular_echo(30, echo); -- sensor mide 30cm = vacio
        wait for 1 ms;
        -- Esperamos: led="000", rele=0, IN1=0, IN2=0

        -- ============================================
        -- TEST 3: Bidon a mitad (distancia = 15cm)
        -- altura=15cm, peltier segun sw, bomba segun boton
        -- ============================================
        sw    <= "01"; -- modo calentar
        boton <= '0';
        simular_echo(15, echo); -- sensor mide 15cm = mitad
        wait for 1 ms;
        -- Esperamos: led activo, IN1=1, IN2=0, ENA=PWM, rele=0

        -- ============================================
        -- TEST 4: Bidon a mitad, boton pulsado
        -- Bomba debe arrancar
        -- ============================================
        sw    <= "01";
        boton <= '1';
        simular_echo(15, echo);
        wait for 1 ms;
        boton <= '0';
        -- Esperamos: rele=1 mientras boton=1

        -- ============================================
        -- TEST 5: Bidon lleno (distancia = 0cm)
        -- Bomba debe arrancar automaticamente
        -- ============================================
        sw    <= "10"; -- modo enfriar
        boton <= '0';
        simular_echo(0, echo); -- sensor mide 0cm = lleno
        wait for 1 ms;
        -- Esperamos: rele=1, IN1=0, IN2=1, ENA=PWM

        -- ============================================
        -- TEST 6: Bidon a mitad, modo enfriar
        -- ============================================
        sw    <= "10";
        boton <= '0';
        simular_echo(15, echo);
        wait for 1 ms;
        -- Esperamos: IN1=0, IN2=1, ENA=PWM, rele=0

        -- ============================================
        -- TEST 7: Bidon vacio, boton pulsado
        -- Bomba NO debe arrancar
        -- ============================================
        sw    <= "01";
        boton <= '1';
        simular_echo(30, echo);
        wait for 1 ms;
        boton <= '0';
        -- Esperamos: rele=0 (proteccion sin agua)

        -- ============================================
        -- TEST 8: Reset con sistema en marcha
        -- ============================================
        sw    <= "01";
        boton <= '1';
        simular_echo(15, echo);
        wait for 500 us;
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        boton <= '0';
        wait for 1 ms;
        -- Esperamos: todo apagado tras reset

        wait;
    end process;

end Behavioral;
