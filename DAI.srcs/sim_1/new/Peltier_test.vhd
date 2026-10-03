----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 08:47:06
-- Design Name: 
-- Module Name: Peltier_test - Behavioral
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

entity Peltier_test is
--  Port ( );
end Peltier_test;

architecture Behavioral of Peltier_test is

    component Peltier is
        Port ( 
            clk    : in std_logic;
            reset  : in std_logic;
            modo   : in std_logic_vector (1 downto 0);
            ciclo  : in std_logic_vector (7 downto 0);
            altura : in std_logic_vector (4 downto 0);
            IN1    : out std_logic;
            IN2    : out std_logic;
            ENA    : out std_logic
        );
    end component;

    -- Entradas
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal modo   : std_logic_vector (1 downto 0) := "00";
    signal ciclo  : std_logic_vector (7 downto 0) := (others => '0');
    signal altura : std_logic_vector (4 downto 0) := (others => '0');

    -- Salidas
    signal IN1 : std_logic;
    signal IN2 : std_logic;
    signal ENA : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    UUT: Peltier port map (
        clk    => clk,
        reset  => reset,
        modo   => modo,
        ciclo  => ciclo,
        altura => altura,
        IN1    => IN1,
        IN2    => IN2,
        ENA    => ENA
    );

    -- Clock
    clk <= not clk after CLK_PERIOD / 2;

    process
    begin

        -- ============================================
        -- TEST 1: Reset
        -- ============================================
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;
        -- Esperamos: IN1=0, IN2=0, ENA=0

        -- ============================================
        -- TEST 2: Sin agua, modo calentar
        -- La peltier NO debe arrancar
        -- ============================================
        altura <= "00000";
        modo   <= "01";
        ciclo  <= "10000000"; -- 50%
        wait for 1 ms;
        -- Esperamos: IN1=0, IN2=0, ENA=0

        -- ============================================
        -- TEST 3: Sin agua, modo enfriar
        -- La peltier NO debe arrancar
        -- ============================================
        altura <= "00000";
        modo   <= "10";
        ciclo  <= "10000000"; -- 50%
        wait for 1 ms;
        -- Esperamos: IN1=0, IN2=0, ENA=0

        -- ============================================
        -- TEST 4: Con agua, modo calentar
        -- ============================================
        altura <= "01111"; -- 15 cm
        modo   <= "01";
        ciclo  <= "10000000"; -- 50%
        wait for 5 ms;
        -- Esperamos: IN1=1, IN2=0, ENA=PWM

        -- ============================================
        -- TEST 5: Con agua, modo enfriar
        -- ============================================
        altura <= "01111"; -- 15 cm
        modo   <= "10";
        ciclo  <= "10000000"; -- 50%
        wait for 5 ms;
        -- Esperamos: IN1=0, IN2=1, ENA=PWM

        -- ============================================
        -- TEST 6: Con agua, modo apagado
        -- ============================================
        altura <= "01111"; -- 15 cm
        modo   <= "00";
        ciclo  <= "10000000";
        wait for 1 ms;
        -- Esperamos: IN1=0, IN2=0, ENA=0

        -- ============================================
        -- TEST 7: Ciclo de trabajo al 25%
        -- ============================================
        altura <= "01111"; -- 15 cm
        modo   <= "01";
        ciclo  <= "01000000"; -- 25%
        wait for 5 ms;
        -- Esperamos: IN1=1, IN2=0, ENA=PWM al 25%

        -- ============================================
        -- TEST 8: Ciclo de trabajo al 100%
        -- ============================================
        altura <= "01111"; -- 15 cm
        modo   <= "01";
        ciclo  <= "11111111"; -- 100%
        wait for 5 ms;
        -- Esperamos: IN1=1, IN2=0, ENA siempre a 1

        -- ============================================
        -- TEST 9: Se queda sin agua mientras calienta
        -- ============================================
        altura <= "01111";
        modo   <= "01";
        ciclo  <= "10000000";
        wait for 2 ms;
        altura <= "00000"; -- se vacía el bidón
        wait for 2 ms;
        -- Esperamos: IN1 y ENA caen a 0 al quedarse sin agua

        wait;
    end process;

end Behavioral;

