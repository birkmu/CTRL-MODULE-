library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl is
  port (
    clk : in std_logic; -- 50MHz
    rstn : in std_logic; -- Key0
    key : in std_logic; -- Key1
    baudsel : in std_logic_vector(2 downto 0); -- SW3, SW2 og SW1
	 parity : in std_logic_vector(1 downto 0); -- Sw5 og SW4 
	 
    LED : out std_logic; -- LEDR0
    ADR : out std_logic_vector(4 downto 0); -- 
    RD : out std_logic;
	 WR : out std_logic;
	 Data inout std_logic_vector(7 downto 0); -- Tristate (‘Z’) etter data har blitt sendt.

 );
end entity ctrl; 

architecture RTL of ctrl is
 -------------------------------------------------------------------------------
 -- Constants
 -------------------------------------------------------------------------------
 --Konstanter som trengs
    
 
 
 -------------------------------------------------------------------------------
 -- Types
 -------------------------------------------------------------------------------
 
 
 
 -------------------------------------------------------------------------------
 -- Signal
 -------------------------------------------------------------------------------
 
 
 -------------------------------------------------------------------------------
 -- Functions
 ------------------------------------------------------------------------------- 

 

begin 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 end architecture Ctrl;
