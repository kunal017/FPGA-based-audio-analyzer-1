----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:08 03/04/2016 
-- Design Name: 
-- Module Name:    codecfft - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity codecfft is
port(A : in std_logic_vector(17 downto 0);
 C : out std_logic_vector(17 downto 0);
 D : out std_logic_vector (17 downto 0) := "000000000000000000";
 rfd : in std_logic);
end codecfft;

architecture Behavioral of codecfft is

begin

process(rfd, A)
begin
C<="000000000000000000";
D<="000000000000000000";
if(rfd='1') then
C<=A;
end if;
end process;

end Behavioral;

