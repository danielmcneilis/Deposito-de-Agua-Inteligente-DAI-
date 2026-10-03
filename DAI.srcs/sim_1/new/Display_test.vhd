----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.05.2026 18:19:57
-- Design Name: 
-- Module Name: Display_test - Behavioral
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

entity Display_test is
--  Port ( );
end Display_test;

architecture Behavioral of Display_test is

    component Display is
        Port ( 
            modo   : in std_logic_vector (1 downto 0);
            reset  : in std_logic; 
            seg    : out std_logic_vector (6 downto 0);
            an     : out std_logic_vector (3 downto 0);
            altura : in std_logic_vector (4 downto 0);
            clk    : in std_logic
        );
    end component;

    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal modo   : std_logic_vector (1 downto 0) := "00";
    signal altura : std_logic_vector (4 downto 0) := (others => '0');
    signal seg    : std_logic_vector (6 downto 0);
    signal an     : std_logic_vector (3 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    UUT: Display port map (
        modo   => modo,
        reset  => reset,
        seg    => seg,
        an     => an,
        altura => altura,
        clk    => clk
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

        -- ============================================
        -- TEST 2: Sin agua, modo apagado
        -- AN0 debe estar apagado (an="1111")
        -- ============================================
        altura <= "00000";
        modo   <= "00";
        wait for 10 ms; -- varios ciclos de multiplexacion
        -- Esperamos: an(0)="1111" cuando sel="00"

        -- ============================================
        -- TEST 3: Sin agua, modo calentar
        -- AN0 debe mostrar 'E' (deposito vacio)
        -- altura = 000 -> digitos todos a 0
        -- ============================================
        altura <= "00000";
        modo   <= "01";
        wait for 10 ms;
        -- Esperamos: seg="0110000" cuando an="1110"

        -- ============================================
        -- TEST 4: Sin agua, modo enfriar
        -- Igual que T3, muestra 'E'
        -- ============================================
        altura <= "00000";
        modo   <= "10";
        wait for 10 ms;
        -- Esperamos: seg="0110000" cuando an="1110"

        -- ============================================
        -- TEST 5: Altura = 15 cm, modo calentar
        -- AN0: 'H', AN1: 5, AN2: 1, AN3: 0
        -- ============================================
        altura <= "01111"; -- 15 cm
        modo   <= "01";
        wait for 10 ms;
        -- Esperamos:
        -- an="1110" -> seg="0001001" (H = caliente)
        -- an="1101" -> seg="0010010" (5)
        -- an="1011" -> seg="1111001" (1)
        -- an="0111" -> seg="1000000" (0)

        -- ============================================
        -- TEST 6: Altura = 15 cm, modo enfriar
        -- AN0: 'C', AN1: 5, AN2: 1, AN3: 0
        -- ============================================
        altura <= "01111"; -- 15 cm
        modo   <= "10";
        wait for 10 ms;
        -- Esperamos:
        -- an="1110" -> seg="1000110" (C = frio)
        -- an="1101" -> seg="0010010" (5)
        -- an="1011" -> seg="1111001" (1)
        -- an="0111" -> seg="1000000" (0)

        -- ============================================
        -- TEST 7: Altura = 30 cm (bidon lleno)
        -- AN0: 'H', AN1: 0, AN2: 3, AN3: 0
        -- ============================================
        altura <= "11110"; -- 30 cm
        modo   <= "01";
        wait for 10 ms;
        -- Esperamos:
        -- an="1110" -> seg="0001001" (H)
        -- an="1101" -> seg="1000000" (0)
        -- an="1011" -> seg="0110000" (3)
        -- an="0111" -> seg="1000000" (0)

        -- ============================================
        -- TEST 8: Altura = 9 cm, modo apagado
        -- AN0 apagado, AN1: 9, AN2: 0, AN3: 0
        -- ============================================
        altura <= "01001"; -- 9 cm
        modo   <= "00";
        wait for 10 ms;
        -- Esperamos:
        -- an="1111" -> display AN0 apagado
        -- an="1101" -> seg="0010000" (9)
        -- an="1011" -> seg="1000000" (0)
        -- an="0111" -> seg="1000000" (0)

        -- ============================================
        -- TEST 9: Reset con display activo
        -- ============================================
        altura <= "01111";
        modo   <= "01";
        wait for 5 ms;
        reset  <= '1';
        wait for 100 ns;
        reset  <= '0';
        wait for 5 ms;

        wait;
    end process;

end Behavioral;