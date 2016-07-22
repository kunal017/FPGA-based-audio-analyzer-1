----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:37 03/04/2016 
-- Design Name: 
-- Module Name:    max_freq - Behavioral 
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

entity max_freq is
port ( xe_re : in std_logic_vector(17 downto 0);
       xe_im : in std_logic_vector(17 downto 0);
		 clk : in std_logic ;
		 start_fft : in std_logic ;
		 max_freq_vector : out std_logic_vector(4 downto 0);
		 bulb_check : out std_logic_vector(4 downto 0);
		 ready : out std_logic
		 );
end max_freq;

architecture Behavioral of max_freq is

type state is (idle,processing);

signal state_reg,state_next:state;
signal max_reg : integer ;
signal max_next : integer ;
signal max_fr_reg : integer ;
signal max_fr_next : integer ;
signal count_reg : integer ;
signal count_next : integer ;
--signal count2_next : integer ;
--signal count2_reg : integer ;
signal max_val : integer ;
signal final_answer : integer ; 
signal max_frequency : integer ;
signal int_re, int_im : integer;

begin
int_re <= to_integer(signed(xe_re));
int_im <= to_integer(signed(xe_im));
max_val<= int_re*int_re + int_im*int_im;
max_frequency <= max_fr_reg*300/1024 ;
final_answer <= to_integer(unsigned(std_logic_vector(to_unsigned(max_frequency, 9))));
--bulb_check <= max_freq_vector;

--max_freq_vector <= std_logic_vector(to_unsigned(max_frequency, 8));

process(clk)
begin
if(rising_edge(clk))then
	max_reg<=max_next;
	max_fr_reg<=max_fr_next;
	count_reg<=count_next;
	state_reg<=state_next;
	--count2_reg<=count2_next;
end if;
end process;
 
process(max_reg,max_val,state_reg,max_fr_reg,count_reg,start_fft, final_answer)
begin	
		state_next<=state_reg;
		max_fr_next<=max_fr_reg;
		count_next<=count_reg+1;
		--count2_next<=count2_reg+1;
		--res_next<=res_reg;
	case state_reg is
	when idle=>
		count_next<=0;
		max_next<=0;
		if(start_fft='1')then
			state_next<=processing;
			ready <= '1';
		end if;
	when processing=>
			if(max_reg<=max_val)then
				max_next<=max_val;
				max_fr_next<=count_reg;
			else
				max_next<=max_reg;
			end if;
			if(count_reg=1023)then
				count_next<=0;
			end if;
	end case;
	if(final_answer>=0 and final_answer <= 21) then
		max_freq_vector <= "00000";
		bulb_check <= "00000";
	elsif(final_answer > 21 and final_answer <= 40) then
		max_freq_vector <= "00101";
		bulb_check <= "00101";
	elsif(final_answer > 40 and final_answer <= 60) then
		max_freq_vector <= "00001";
		bulb_check <= "00001";
	elsif(final_answer > 60 and final_answer <= 80) then
		max_freq_vector <= "01111";
		bulb_check <= "01111";
	elsif(final_answer > 80 and final_answer <= 100) then
		max_freq_vector <= "01001";
		bulb_check <= "01001";
	elsif(final_answer > 100 and final_answer <= 120) then
		max_freq_vector <= "10001";
		bulb_check <= "10001";
	elsif(final_answer > 120 and final_answer <= 140) then
		max_freq_vector <= "11110";
		bulb_check <= "11110";
	elsif(final_answer > 140 and final_answer <= 160) then
		max_freq_vector <= "01000";
		bulb_check <= "01000";
	elsif(final_answer > 160 and final_answer <= 180) then
		max_freq_vector <= "10011";
		bulb_check <= "10011";
	elsif(final_answer > 180 and final_answer <= 200) then
		max_freq_vector <= "11000";
		bulb_check <= "11000";
	elsif(final_answer > 200 and final_answer <= 220) then
		max_freq_vector <= "11010";
		bulb_check <= "11010";
	elsif(final_answer > 220 and final_answer <= 240) then
		max_freq_vector <= "01111";
		bulb_check <= "01111";
	elsif(final_answer > 240 and final_answer <= 260) then
		max_freq_vector <= "10000";
		bulb_check <= "10000";
	elsif(final_answer > 260 and final_answer <= 280) then
		max_freq_vector <= "00011";
		bulb_check <= "00011";
	else
		max_freq_vector <= "11111";
		bulb_check <= "11111";
	end if;
	
end process;

end Behavioral;

