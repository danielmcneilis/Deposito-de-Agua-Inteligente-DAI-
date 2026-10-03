----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2026 12:21:33
-- Design Name: 
-- Module Name: Display - Behavioral
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

entity Display is
    Port ( 
         modo : in std_logic_vector (1 downto 0);
         reset : in std_logic; 
         seg : out std_logic_vector (6 downto 0);
         an : out std_logic_vector (3 downto 0);
         altura : in std_logic_vector (4 downto 0);
         clk : in std_logic
         
         
    );
end Display;

architecture Behavioral of Display is

    signal cnt      : unsigned(15 downto 0) := (others => '0');
    signal sel      : unsigned(1 downto 0);
    signal altura_int : integer range 0 to 511;
    signal centenas : integer range 0 to 9;
    signal decenas  : integer range 0 to 9;
    signal unidades : integer range 0 to 9;

begin

    -- Contador para multiplexacion
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    sel <= cnt(15 downto 14);

    
    altura_int <= to_integer(unsigned(altura));
    centenas   <= altura_int / 100;
    decenas    <= (altura_int mod 100) / 10;
    unidades   <= altura_int mod 10;

    -- Seleccion de anodo
    process(sel, modo)
    begin
        case sel is
            when "00" =>
                if modo = "00" then
                    an <= "1111";  -- peltier apagada, display off
                else
                    an <= "1110";  -- AN0: peltier
                end if;
            when "01" => an <= "1101";  -- AN1: unidades
            when "10" => an <= "1011";  -- AN2: decenas
            when others => an <= "0111";  -- AN3: centenas
        end case;
    end process;

    -- Seleccion de segmentos
    process(sel, modo, unidades, decenas, centenas)
        variable digito : integer range 0 to 10;
    begin
        case sel is
            -- peltier
            when "00" =>
                if altura = "00000" then
                    seg <= "0000110";
                else
                    case modo is
                        when "01" => seg <= "0001001";  -- caliente
                        when "10" => seg <= "1000110";  --  frio
                        when others => seg <= "1111111";
                    end case;
                end if;
            when "01" => 
                digito := unidades;
                case digito is
                    when 0 => seg <= "1000000";
                    when 1 => seg <= "1111001";
                    when 2 => seg <= "0100100";
                    when 3 => seg <= "0110000";
                    when 4 => seg <= "0011001";
                    when 5 => seg <= "0010010";
                    when 6 => seg <= "0000010";
                    when 7 => seg <= "1111000";
                    when 8 => seg <= "0000000";
                    when 9 => seg <= "0010000";
                    when others => seg <= "1111111";
                end case;
            when "10" => 
                digito := decenas;
                case digito is
                    when 0 => seg <= "1000000";
                    when 1 => seg <= "1111001";
                    when 2 => seg <= "0100100";
                    when 3 => seg <= "0110000";
                    when 4 => seg <= "0011001";
                    when 5 => seg <= "0010010";
                    when 6 => seg <= "0000010";
                    when 7 => seg <= "1111000";
                    when 8 => seg <= "0000000";
                    when 9 => seg <= "0010000";
                    when others => seg <= "1111111";
                end case;
            when others => 
            digito := centenas;
                case digito is
                    when 0 => seg <= "1000000";
                    when 1 => seg <= "1111001";
                    when 2 => seg <= "0100100";
                    when 3 => seg <= "0110000";
                    when 4 => seg <= "0011001";
                    when 5 => seg <= "0010010";
                    when 6 => seg <= "0000010";
                    when 7 => seg <= "1111000";
                    when 8 => seg <= "0000000";
                    when 9 => seg <= "0010000";
                    when others => seg <= "1111111";
                end case;

        end case;
    end process;
 
        

end Behavioral;
