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
	 buss inout std_logic_vector(7 downto 0); -- Tristate (‘Z’) etter data har blitt sendt.

 );
end entity ctrl; 

architecture RTL of ctrl is
 -------------------------------------------------------------------------------
 -- Konstanter
 ------------------------------------------------------------------------------- 
  constant charA : std_logic_vector(7 downto 0) := "01000001"; --'A'
  constant startbit : std_logic := "1"; --Startbitet usikker om det skal være avhengig av parity
  constant TARGET_COUNT : integer := 2500000; -- teller så mange klokkefrekvenser som tilsvarer 50ms
 -------------------------------------------------------------------------------
 -- Signaler
 ------------------------------------------------------------------------------- 
  signal counter : integer range 0 to TARGET_COUNT; --Tellevariabel for varigheten til LED lyset. 
  --Lager en variabel for knappen som brukes til å sjekke når knapp-verdien går fra
  --1 til 0. Slik at datainnholdet endres kun når knappen blir trykket og ikke presset
  signal key_prev_state : std_logic := '1';
  signal paritybit : std_logic;
 -------------------------------------------------------------------------------
 -- Funkjson
 -------------------------------------------------------------------------------
--Skal kanskje være i Tx-modulen, men ser ikke grunn til å fjerne den nå.
 
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
  process(clk, rstn_n)
  begin 
    if rst_n = '0' then
      LED <= '0'; -- default 0
	   RD <= '0'; --default 0
      WR <= '0'; -- default 0
		buss <= (others => 'Z'); --Dette skal sette hele data til "tristate"?
		--data <= (others => 'Z'); --Dette skal sette hele data til "tristate"?
		counter <= TARGET_COUNT; 
		
  --Kjører koden hvis rst_n ikke er '0'
	 elsif rising_edge(clk) then
	 
      if key = '0' and key_prev_state = '1' then
		  --Da endres verdien på datainnholdet -> data skal sendes og led skal lyse
		  --Data <= charA;
		  buss <= charA;
		
		end if;
		key_prev_state <= key; 

		--Er lat, orker ikke å lage en funksjon som sjekker om alle bitene er "tristate"
		--Så sjekker kun det første. 
		if buss(0) /= 'Z' then 
        RD <= '1'; --Forteller at Ctrl modulen er nødt til å lese datainnholdet. Fordi da er det data i databussen.  		
		end if
		
		if RD = '1' and WR = '0' then --Sjekker om at Tx ikke er i "sender fasen"
		  --Skal lese data og gjøre det klar til sending for Tx-modulen
		  TxData <= buss; 
		  paritybit <= calculate_parity(TxData, parity); -- Regner ut paritybit
		  
		  --Starter tellinga til varigheten på LED
		  counter <= '0';
		  WR <= '1'; --Forteller til Tx at data kan sendes.  
		end if
		
		if WR = '1' then
		  buss <= (others => 'Z'); --Setter hele data til "tristate"?
		  --Data <= (others => 'Z'); --Setter hele data til "tristate"?
		  RD = '0'; 
		end if
	 end if;
	 
  
  --Teller varigheten til LED
    if counter < TARGET_COUNT then
      counter <= counter + 1; 
      led <= '1'; -- LED PÅ gjennom tellinga
    else
       led <= '0'; -- LED AV etter tellinga
    
	 end if;
 
 end architecture Ctrl;
