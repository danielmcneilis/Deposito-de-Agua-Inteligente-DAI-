----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2026 11:14:06
-- Design Name: 
-- Module Name: Bidon - Behavioral
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

entity Bidon is
    generic (
        ciclo : std_logic_vector (7 downto 0) := "01000000"; ------definimos el ciclo al 50%
        ALTURA : integer := 30 -------------------------ALTURA DEL BIDON EN CM
        
    );
    
    Port (
        clk : in std_logic;
        reset : in std_logic; 
        
        --------------------------Water
        trigger : out std_logic;
        echo : in std_logic;
        led : out std_logic_vector (2 downto 0);
        
        -------------------------PELTIER
        sw : in std_logic_vector (1 downto 0);
        IN1 : out std_logic;
        IN2 : out std_logic;
        ENA : out std_logic;
        
        ------------------------PUMP
        rele : out std_logic;
        boton : in std_logic; 
        
        ------------------------DISPLAY
        seg : out std_logic_vector (6 downto 0);
        an : out std_logic_vector (3 downto 0)
          
    );
end Bidon;


architecture Behavioral of Bidon is

    component EstadoAgua is
        generic(
            ALTURA_BIDON : integer  -----Altura en cm
        );
        Port ( 
            clk : in std_logic;
            reset : in std_logic;
            echo : in std_logic; ----- DEL SENSOR
            trigger : out std_logic; ----- DEL SENSOR
            altura : out std_logic_vector (4 downto 0)
            
        );
    end component;
        
    
    component Peltier is
        Port ( 
            clk : in std_logic;
            reset: in std_logic;
            modo : in std_logic_vector (1 downto 0);
            ciclo : in std_logic_vector (7 downto 0); 
            altura : in std_logic_vector (4 downto 0);
            IN1 : out std_logic;
            IN2 : out std_logic;
            ENA : out std_logic
        );
    end component;
    
    component Bomba is
        generic(
            ALTURA_BIDON : integer -----Altura en cm
        );
        Port ( 
            clk : in std_logic; 
            reset : in std_logic;
            boton : in std_logic;
            altura : in std_logic_vector (4 downto 0); -----Conectar a las leds del estado de agua
            salida : out std_logic  ----enceder el relé
        );
    end component;
    
    component Display is
        Port ( 
             modo : in std_logic_vector (1 downto 0);
             reset : in std_logic; 
             seg : out std_logic_vector (6 downto 0);
             an : out std_logic_vector (3 downto 0);
             altura : in std_logic_vector (4 downto 0);
             clk : in std_logic  
        );
    end component;
    
    component LedControler is
        generic(
            ALTURA_BIDON : integer -----Altura en cm
        );
        Port (
            clk : in std_logic;
            reset : in std_logic;
            altura : in std_logic_vector (4 downto 0); 
            led : out std_logic_vector (2 downto 0) ------Salida [2] = ALTA -- Salida[1] = MEDIA ---Salida[0] = BAJA
        );
    end component;
    
    signal nivel : std_logic_vector (2 downto 0) := "000"; ------- controla los leds
    signal level : std_logic_vector (4 downto 0) := "00000"; ----- altura del agua
     

begin

    Water: EstadoAgua 
    generic map (
        ALTURA_BIDON => ALTURA   
    )
    port map (
        clk => clk, 
        reset => reset,
        echo => echo,
        trigger => trigger,
        altura => level
               
    );
    
    Pelti: Peltier 
        port map (
            clk => clk,
            reset => reset,
            modo => sw,
            altura => level,
            ciclo => ciclo,
            IN1 => IN1,
            IN2 => IN2,
            ENA => ENA  
        );
    
    Pump: Bomba 
        generic map (
            ALTURA_BIDON => ALTURA
        )
        port map (
            clk    => clk, 
            reset  => reset,
            boton  => boton,   
            altura => level,
            salida => rele
        );
    
    Screen: Display 
        port map (
            modo => sw,
            reset => reset,
            seg => seg,
            an => an,
            altura => level,
            clk => clk
            
        );
    
    Leds: LedControler 
    generic map (
        ALTURA_BIDON => ALTURA   
    )
    port map (
        clk => clk,
        reset => reset,
        altura => level, 
        led => nivel       
    );
    
    
     
    led <= nivel; 
        
            
    


end Behavioral;
