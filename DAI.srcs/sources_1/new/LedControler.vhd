----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2026 11:34:57
-- Design Name: 
-- Module Name: LedControler - Behavioral
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
-----------------------------------------------------------------------------------


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

entity LedControler is
    generic(
        ALTURA_BIDON : integer -----Altura en cm
    );
    Port (
        clk : in std_logic;
        reset : in std_logic;
        altura : in std_logic_vector (4 downto 0);
        led : out std_logic_vector (2 downto 0) ------Salida [2] = ALTA -- Salida[1] = MEDIA ---Salida[0] = BAJA
    );
end LedControler;

architecture Behavioral of LedControler is

begin
    
    process (altura, reset, clk)
            constant TERCIO : integer := ALTURA_BIDON/3;
            constant DOS_TERCIOS : integer := (ALTURA_BIDON *2)/3;
            constant LLENO : integer := (ALTURA_BIDON - 2);
            variable  level : integer := 0;
        begin
        
            if reset = '1' then
                led <= "000";
            elsif rising_edge (clk) then
                level := to_integer(unsigned(altura));
                if level = ALTURA_BIDON then 
                    led <= "000";
                elsif level >= DOS_TERCIOS then
                    led <= "111";
                elsif level >= TERCIO then
                    led <= "011";
                else
                    led <= "001";
                end if;
            end if;
        end process;

end Behavioral;
