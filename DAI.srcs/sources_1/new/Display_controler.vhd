----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2026 18:00:56
-- Design Name: 
-- Module Name: Display_controler - Behavioral
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

entity Display_controler is
    Port ( 
        modo : in std_logic_vector (1 downto 0);
        reset : in std_logic; 
        seg : out std_logic_vector (6 downto 0);
        an : out std_logic_vector (3 downto 0);
        altura : in std_logic_vector (4 downto 0);
        clk : in std_logic_vector (1 downto 0) 
    );
end Display_controler;

architecture Behavioral of Display_controler is

begin

    process (clk, altura, reset, modo)
        begin
            if reset = '1' then 
                seg <= "1111111";
                an <= "1111";
            end if;
        
        case sel is
            when "00" =>
                an <= "1110";
                case modo is
                    when "01" =>
                        seg <= "0001001"; ------caliente 
                    when "10" =>
                        seg <= "1000110"; ------frio
                    when others =>
                        seg <= "1111111"; ------apagado
                    end case;
                    
            when "01" =>
            
            
            
            
            
            
            
    ------------------------------------------------------
    -- miro primero el switch y enciendo el display 
    ------------------------------------------------------
            case modo is
                when "01" => 
                    an <= "1110";
                    seg <= "0001001"; ------caliente 
                when "10" => 
                    an <= "1110";
                    seg <= "1000110"; ------frio
                when others =>
                    an <= "1110";
                    seg <= "1111111"; ------apagado
            end case;
    --------------------------------------------------------
    -- puedo ver la altura
    --------------------------------------------------------
            case altura is
                when "00000" => ----------------0
                    an <= "1101";
                    seg <= "0000001";
                when "00001" => ---------------1
                    an <= "1101";
                    seg <= "1001111";
                when "00010" =>-----------------2
                    an <= "1101";
                    seg <= "0010010";
                when "00011" => ----------------3
                    an <= "1101";
                    seg <= "0000110";
                when "00100" =>-----------------4
                    an <= "1101";
                    seg <= "1001100";
                when "00101" =>------------------5
                    an <= "1101";
                    seg <= "0100100";
                when "00110" => -----------------6
                    an <= "1101";
                    seg <= "0100000";
                when "00111" => ------------------7
                    an <= "1101";
                    seg <= "0001111";
                when "01000" =>---------------------8
                    an <= "1101";
                    seg <= "0000000";
                when "01001" =>---------------------9
                    an <= "1101";
                    seg <= "0000100";
            
           



end Behavioral;
