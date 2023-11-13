library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TX_tb is
end entity;


architecture Sim of TX_tb is

   -----------------------------------------------------------------------------
   -- Constant declaration
   -----------------------------------------------------------------------------

   -----------------------------------------------------------------------------
   -- Component declarasion
   -----------------------------------------------------------------------------
	component TX is
		port(
			clk  : in std_logic;
			rstn : in std_logic;
			buss : inout std_logic_vector(7 downto 0);
			adr  : in std_logic_vector(4 downto 0);
			WR   : in std_logic;
			RD   : in std_logic;
			TxD  : out std_logic);

	end component TX;

   -----------------------------------------------------------------------------
   -- Signal declaration
   -----------------------------------------------------------------------------
   -- DUT signals
	signal clk_tb  : std_logic;
	signal rstn_tb : std_logic;
	signal buss_tb : std_logic_vector(7 downto 0);
	signal adr_tb  : std_logic_vector(4 downto 0);
	signal WR_tb   : std_logic;
	signal RD_tb   : std_logic;
	signal TxD_tb  : std_logic;

   -- Testbench signals
  
begin

   -----------------------------------------------------------------------------
   -- Component instantiations
   -----------------------------------------------------------------------------
	i_TX: component TX
		port map (
			clk  => clk_tb,
			rstn => rstn_tb,
			buss => buss_tb,
			adr  => adr_tb,
			WR   => WR_tb,
			RD   => RD_tb,
      			TxD  => TxD_tb
		);

   -----------------------------------------------------------------------------
   -- purpose: State machine
   -- type   : concurrent
   -- inputs : 
   -----------------------------------------------------------------------------
   state_machine: process
   begin
      -- Initialize signals
	rstn_tb <= '1';
	buss_tb <= "ZZZZZZZZ";
	adr_tb  <= "00000";
	WR_tb   <= '0';
	RD_tb   <= '0';

	wait for 10 ns;

	WR_tb   <= '1';

	wait for 10 ns;

	RD_tb   <= '1';
	
	wait for 10 ns;

	adr_tb  <= "00001";
	buss_tb <= "01000010";

   end process state_machine;

end architecture SIM;
