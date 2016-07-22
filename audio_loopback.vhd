----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:58:49 03/04/2016 
-- Design Name: 
-- Module Name:    audio_loopback - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity audio_loopback is
port(
      clk : in std_logic;
		audio_reset_b : out std_logic;
		ac97_sdata_out : out std_logic;
		ac97_sdata_in : in std_logic;
		ac97_synch : out std_logic;
		ac97_bit_clock : in std_logic;
		digital_input : out std_logic_vector(17 downto 0)
);
end audio_loopback;

architecture Behavioral of audio_loopback is

signal command_address : std_logic_vector(19 downto 0); 
signal command_data : std_logic_vector(19 downto 0);
signal bit_count : std_logic_vector(7 downto 0) := "00000000";
signal lower_bit_count : std_logic_vector(3 downto 0) ;
signal frame_count : std_logic_vector(3 downto 0) := "0000";
signal command : std_logic_vector(23 downto 0);
signal reset_count : std_logic_vector(7 downto 0) := "00000000";
signal dummy : std_logic_vector(17 downto 0);

begin

process(clk)
begin
	if(rising_edge(clk))then
		if(reset_count = "11111111")then
			audio_reset_b <= '1';
		else
			reset_count   <= std_logic_vector(unsigned(reset_count) + 1);
		end if;
	end if;
end process;

process(bit_count, ac97_bit_clock, command_data, command_address, frame_count)
begin
   lower_bit_count <= bit_count(3 downto 0);
	if(rising_edge(ac97_bit_clock))then
		if (bit_count = "11111111")then
			ac97_synch     <= '1';
			digital_input <= dummy;
		end if;
		if (bit_count = "00001111")then
			ac97_synch   <= '0';
		end if;
		if ((bit_count >= "00000000") and (bit_count <= "00001111"))then
			case lower_bit_count is
				when "0000" => ac97_sdata_out <= '1';
				when "0001" => ac97_sdata_out <= '1';
				when "0010" => ac97_sdata_out <= '1';
				when others => ac97_sdata_out <= '0';
			end case;
		elsif ((bit_count >= "00010000") and (bit_count <= "00100011"))then
			ac97_sdata_out <= command_address(to_integer(unsigned(std_logic_vector(35 - unsigned(bit_count)))));
	   elsif ((bit_count >= "00100100") and (bit_count <= "00110111"))then
			ac97_sdata_out <= command_data(to_integer(unsigned(std_logic_vector(55 - unsigned(bit_count)))));
		elsif ((bit_count >= "00111000") and (bit_count <= "01001001"))then
			ac97_sdata_out <= '0';
			dummy(to_integer(unsigned(std_logic_vector(unsigned(bit_count)-56)))) <= ac97_sdata_in;
		else
			ac97_sdata_out <= '0';
		end if;

		if (bit_count = "11111111")then
			frame_count   <= std_logic_vector(unsigned(frame_count) + 1);
		end if;
  
		bit_count   <= std_logic_vector(unsigned(bit_count) + 1);
	end if;
end process;

process(frame_count, command, command_address, command_data)
begin
	case frame_count is
		when "0000" => command <= "000000100000000000000000"; -- Unmute line outputs
		when "0001" => command <= "000001000000000000000000"; -- Unmute headphones
		when "0010" => command <= "000100000000100000001000"; -- Unmute line inputs
		when others => command <= "111111000000000000000000"; -- Read vendor ID
	end case;
	
	command_address(19 downto 12) <= command(23 downto 16);
	command_address(11 downto 0) <= "000000000000";
	command_data(19 downto 4) <= command(15 downto 0);
	command_data(3 downto 0) <= "0000";
end process;


   

end architecture;

