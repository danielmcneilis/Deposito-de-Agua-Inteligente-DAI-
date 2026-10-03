----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 20:09:52
-- Design Name: 
-- Module Name: Bomba_test - Behavioral
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

entity Bomba_test is
--  Port ( );
end Bomba_test;

architecture Behavioral of Bomba_test is

    component Bomba is
        generic(
            ALTURA_BIDON : integer
        );
        Port ( 
            clk    : in std_logic; 
            reset  : in std_logic;
            boton  : in std_logic;
            altura : in std_logic_vector (4 downto 0);
            salida : out std_logic
        );
    end component;

    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal boton  : std_logic := '0';
    signal altura : std_logic_vector (4 downto 0) := (others => '0');
    signal salida : std_logic;

    constant CLK_PERIOD  : time    := 10 ns;
    constant ALTURA_TEST : integer := 30; -- cm

begin

    UUT: Bomba
        generic map (
            ALTURA_BIDON => ALTURA_TEST
        )
        port map (
            clk    => clk,
            reset  => reset,
            boton  => boton,
            altura => altura,
            salida => salida
        );

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
        -- Esperamos: salida=0

        -- ============================================
        -- TEST 2: Sin agua, sin boton
        -- Bomba NO debe arrancar
        -- ============================================
        altura <= "00000";
        boton  <= '0';
        wait for 500 ns;
        -- Esperamos: salida=0

        -- ============================================
        -- TEST 3: Sin agua, boton pulsado
        -- Bomba NO debe arrancar (proteccion)
        -- ============================================
        altura <= "00000";
        boton  <= '1';
        wait for 500 ns;
        boton  <= '0';
        -- Esperamos: salida=0

        -- ============================================
        -- TEST 4: Con agua a mitad, sin boton
        -- Bomba NO debe arrancar
        -- ============================================
        altura <= "01111"; -- 15 cm, mitad del bidon
        boton  <= '0';
        wait for 500 ns;
        -- Esperamos: salida=0

        -- ============================================
        -- TEST 5: Con agua a mitad, boton pulsado
        -- Bomba SI debe arrancar
        -- ============================================
        altura <= "01111"; -- 15 cm
        boton  <= '1';
        wait for 500 ns;
        boton  <= '0';
        wait for 500 ns;
        -- Esperamos: salida=1 mientras boton=1, luego salida=0

        -- ============================================
        -- TEST 6: Bidon lleno, sin boton
        -- Bomba SI debe arrancar automaticamente
        -- ============================================
        altura <= std_logic_vector(to_unsigned(ALTURA_TEST, 5)); -- 30 cm = lleno
        boton  <= '0';
        wait for 500 ns;
        -- Esperamos: salida=1

        -- ============================================
        -- TEST 7: Bidon lleno, boton pulsado
        -- Bomba SI debe arrancar (ambas condiciones)
        -- ============================================
        altura <= std_logic_vector(to_unsigned(ALTURA_TEST, 5));
        boton  <= '1';
        wait for 500 ns;
        boton  <= '0';
        wait for 500 ns;
        -- Esperamos: salida=1

        -- ============================================
        -- TEST 8: Bidon se vacia mientras bomba activa
        -- Al llegar a 0 con boton, debe parar
        -- ============================================
        altura <= "01010"; -- 10 cm
        boton  <= '1';
        wait for 500 ns;
        altura <= "00000"; -- se vacia
        wait for 500 ns;
        boton  <= '0';
        -- Esperamos: salida cae a 0 al quedarse sin agua

        -- ============================================
        -- TEST 9: Reset con bomba en marcha
        -- ============================================
        altura <= "01111";
        boton  <= '1';
        wait for 200 ns;
        reset  <= '1';
        wait for 100 ns;
        reset  <= '0';
        boton  <= '0';
        wait for 200 ns;
        -- Esperamos: salida=0 tras reset

        wait;
    end process;

end Behavioral;
