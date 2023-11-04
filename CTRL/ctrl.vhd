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
 -- Konstanter
 ------------------------------------------------------------------------------- 
  constant charA : std_logic_vector(7 downto 0) := "01000001"; --'A'
  constant startbit : std_logic := "1"; --Startbitet usikker om det skal være avhengig av parity
  
  
 -------------------------------------------------------------------------------
 -- Funkjson
 -------------------------------------------------------------------------------
--Funksjonen tar inn 2 'variabler' den ene som er dataen den skal sjekke enere på 
--og den andre blir "modus" altså parity som sier om den skal legge til parity partall/odde
function calculate_parity(data: std_logic_vector; modus: std_logic_vector) return std_logic is
		  variable count : natural := 0; --Tellevariabel som starter på '0'
    begin
        for i in data'range loop --varer så lenge som d fortsatt er bit i data
            if data(i) = '1' then
                count := count + 1;
            end if;
        end loop;

        case mode is
            when "00" => return '0'; -- no parity
            when "01" => -- even parity
                if count mod 2 = 0 then
                    return '1';
                else
                    return '0';
                end if;
            when "10" => -- odd parity
                if count mod 2 = 1 then --bruker mod for å gjøre d enklere
                    return '1';
                else
                    return '0'; 
                end if;
            when others => return '0'; -- ikke i bruk. (11)
        end case;
    end function calculate_parity;
  
begin 
  process(key)
  begin 
  
  
  --Må endres på senere, har bare skrevet ned logikken siden jeg allerede skrev ferdig funksjonen
  --Antar at det også skal legges til startbit som er '1'
	 if key = '1' then
      TxData(7 downto 0) <= charA;
		TxData(8) <= calculate_parity(charA, parity); -- Regner ut paritybit
		--Antar at man må ha med startbit? 
		TxData(8 downto 1) <= charA;
		TxData(8 downto 1) <= charA;
      TxData(9) <= calculate_parity(charA, parity); -- Regner ut paritybit
    end if;
  
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 end architecture Ctrl;
