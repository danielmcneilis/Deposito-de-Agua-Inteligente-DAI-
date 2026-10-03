----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 11:23:32
-- Design Name: 
-- Module Name: Peltier - Behavioral
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

entity Peltier is
    Port ( 
        clk : in std_logic;
        reset: in std_logic;
        modo : in std_logic_vector (1 downto 0);
        ciclo : in std_logic_vector (7 downto 0); ---256 bits
        altura : in std_logic_vector (4 downto 0);
        IN1 : out std_logic;
        IN2 : out std_logic;
        ENA : out std_logic
    );
end Peltier;

architecture Behavioral of Peltier is

    constant PWM_MAX : integer := 256000; ---ciclos para 100MHz / 390 Hz
    signal pwm_contador : integer range 0 to  PWM_MAX := 0;
    signal pwm_ancho : integer range 0 to PWM_MAX := 0;
    signal pwm_out : std_logic := '0';

begin

    pwm_ancho <= to_integer(unsigned(ciclo)) * 1000; ----escala a 256000
    
    process(clk, reset)
    begin
        if reset = '1' then
            pwm_contador <= 0;
            pwm_out <= '0';
            IN1 <= '0';
            IN2 <= '0';
            ENA <= '0';
        elsif rising_edge(clk) then
            -- PWM
            if pwm_contador >= PWM_MAX - 1 then
                pwm_contador <= 0;
            else
                pwm_contador <= pwm_contador + 1;
            end if;
            if pwm_contador < pwm_ancho then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
    
            -- Dirección
            if altura > "00000" then
                case modo is
                    when "01" => ---- Calienta
                        IN1 <= '1';
                        IN2 <= '0';
                        ENA <= pwm_out;
                    when "10" => ---- Enfria
                        IN1 <= '0';
                        IN2 <= '1';
                        ENA <= pwm_out;
                    when others => ---- Apagado
                        IN1 <= '0';
                        IN2 <= '0';
                        ENA <= '0';
                end case;
            else
                IN1 <= '0';
                IN2 <= '0';
                ENA <= '0';
            end if;
                
        end if;
    end process;
    
end Behavioral;
