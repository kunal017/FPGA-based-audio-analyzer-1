----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:52:39 03/04/2016 
-- Design Name: 
-- Module Name:    audio_process - Structural 
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

entity audio_process is
port(
	clk : in std_logic;
	audio_reset_b : out std_logic;
	ac97_sdata_out : out std_logic;
	ac97_sdata_in : in std_logic;
	ac97_synch : out std_logic;
	ac97_bit_clock : in std_logic;
	xn_index : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); --
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
	 xk_index : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
	 max_freq_vector : out std_logic_vector(4 downto 0);
	 header1 : out std_logic;
	 header2 : out std_logic;
	 header3 : out std_logic;
	 header4 : out std_logic;
	 bulb_check : out std_logic_vector(4 downto 0)
);
end audio_process;

architecture Structural of audio_process is

component audio_loopback
	port(
		clk : in std_logic;
		audio_reset_b : out std_logic;
		ac97_sdata_out : out std_logic;
		ac97_sdata_in : in std_logic;
		ac97_synch : out std_logic;
		ac97_bit_clock : in std_logic;
		digital_input : out std_logic_vector(17 downto 0)
		);
end component;

component codecfft
port(A : in std_logic_vector(17 downto 0);
 C : out std_logic_vector(17 downto 0);
 D : out std_logic_vector (17 downto 0) := "000000000000000000";
 rfd : in std_logic);
end component;
 
 COMPONENT fft_core
  PORT (
    clk : IN STD_LOGIC;
    start : IN STD_LOGIC;
    unload : IN STD_LOGIC;
    xn_re : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    xn_im : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    fwd_inv : IN STD_LOGIC;
    fwd_inv_we : IN STD_LOGIC;
    scale_sch : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    scale_sch_we : IN STD_LOGIC;
    rfd : OUT STD_LOGIC;
    xn_index : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
    dv : OUT STD_LOGIC;
    xk_index : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    xk_re : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    xk_im : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
	 --blk_exp : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  );
END COMPONENT;

component max_freq
port ( xe_re : in std_logic_vector(17 downto 0);
       xe_im : in std_logic_vector(17 downto 0);
		 clk : in std_logic ;
		 start_fft : in std_logic ;
		 max_freq_vector : out std_logic_vector(4 downto 0);
		 bulb_check : out std_logic_vector(4 downto 0);
		 ready : out std_logic);
end component ;

signal digital_input : std_logic_vector(17 downto 0);
signal dig_sig : std_logic_vector(17 downto 0);
signal imag_input : std_logic_vector(17 downto 0);
--signal blk_exp :  std_logic_vector(4 downto 0);
constant start : std_logic := '1' ;
constant unload : std_logic := '1' ;
constant fwd_inv : std_logic := '1' ;
constant fwd_inv_we : std_logic := '0';
constant scale_sch_we : std_logic := '0';
constant scale_sch :std_logic_vector := "00000000000000000000";
signal rfd : std_logic ;
signal start_fft : std_logic ;
signal fft_re : std_logic_vector(17 downto 0);
signal fft_im : std_logic_vector(17 downto 0);
signal ready : std_logic ;

begin
header1 <='1';
header2 <='1';
header3 <='0';
header4 <='0';
LOOPBACK : audio_loopback
port map(clk, audio_reset_b, ac97_sdata_out, ac97_sdata_in, ac97_synch, ac97_bit_clock, digital_input);

PM1 : codecfft
port map(digital_input, dig_sig, imag_input, rfd);

FFT : fft_core
port map(clk, start, unload, dig_sig, imag_input, fwd_inv, fwd_inv_we, scale_sch, scale_sch_we, rfd, xn_index, busy, edone, done, start_fft, xk_index, fft_re, fft_im);

FREQ : max_freq
port map(fft_re, fft_im, clk, start_fft, max_freq_vector, bulb_check, ready);

end Structural;

