--fil for TX

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	
entity TX is

	port(
		clk : in std_logic;
		rstn : in std_logic;
		buss : inout std_logic_vector(7 downto 0);
		adr : in std_logic_vector(4 downto 0); -- små bokstaver på signaler
		WR : in std_logic;
		RD : in std_logic;
		TxD : out std_logic);
		
end entity TX;

architecture RTL of TX is

	type state_machine_type is (config, waiting, start, transfer, parity, stop);
	
	signal state_machine : state_machine_type;
	signal busy : std_logic;
	signal count_out : std_logic;
	signal parity_set : std_logic_vector(1 downto 0);
	signal parity_calc : std_logic;
	signal baudrate : std_logic_vector(2 downto 0);

	signal TxConfig : std_logic_vector(7 downto 0);
	signal TxData : std_logic_vector(7 downto 0);
	signal TxStatus : std_logic_vector(7 downto 0); --- disse settes av CTRL

begin
	process_1 : process (all) is
		variable count_trnsf : integer;
	begin
		case state_machine is
			when config =>
				if (WR = '1' and ADR = "00000" and TxData = not "ZZZZZZZZ") then 
					state_machine <= waiting;
				end if; 
				
			when waiting =>
				if (WR = '1' and ADR = "00001" and Txdata = not "ZZZZZZZZ") then
					state_machine <= start;
				end if;
			when start =>
				if count_out = '1' then
					TxD <= '0';
					TxD <= 'Z';
					state_machine <= transfer;
				end if;

			when transfer =>
				count_trnsf := 0;
					if count_out = '1' then
						TxD <= TxData(0 + count_trnsf);
						TxD <= 'Z';
						count_trnsf := count_trnsf + 1;
					end if;
				if TxConfig(4 downto 3) = ("01" or "10")  then --- pass på rikitg komboer (ev. 3 to 4)
					state_machine <= parity;
				else 
					state_machine <= stop;
				end if;
				
			when parity =>
				if count_out = '1' then
					if TxConfig(4 downto 3) = "01" then
						parity_set <= "01";
						TxD <= parity_calc;
						TxD <= 'Z';
					elsif TxConfig(4 downto 3) = "10" then
						parity_set <= "10";
						TxD <= parity_calc;
						TxD <= 'Z';
					end if;
				end if;
				state_machine <= stop;
				
			when stop =>
				if count_out = '1' then
					TxD <= '1';
					TxD <= 'Z';
				end if;
				state_machine <= waiting;
		end case;
		
	end process process_1;	

end architecture RTL;
