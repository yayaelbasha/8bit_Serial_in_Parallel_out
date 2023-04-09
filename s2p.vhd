Library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity s2p is   

port (
  clk, rst, valid, S: in std_logic; 
  generated: out std_logic;
  P: out std_logic_vector (7 downto 0)

);
end entity;

architecture myImp of s2p is
 
signal Shift: std_logic_vector (7 downto 0);
signal Count: std_logic_vector (3 downto 0);
signal inrst,srst: std_logic;

begin
srst <= inrst or rst;
PROCESS(clk,srst)
 	BEGIN
	IF srst= '1' THEN 
		Shift<="00000000";
		Count <= "0000";
	ELSIF rising_edge(clk) THEN 
		IF valid = '1' THEN
			Shift <= S&Shift(7 downto 1);
			Count <= std_logic_vector(unsigned(Count) + 1);
		END IF;
	END IF;
END PROCESS;

PROCESS(clk)
 	BEGIN
	IF falling_edge(clk) THEN 
		IF valid = '0' 	then
			IF Count = "0001" THEN
			P <= "0000000"&Shift(7);
			ELSIF Count = "0010" THEN
			P <= "000000"&Shift(7 DOWNTO 6);
			ELSIF Count = "0011" THEN
			P <= "00000"&Shift(7 DOWNTO 5);
			ELSIF Count = "0100" THEN
			P <= "0000"&Shift(7 DOWNTO 4);
			ELSIF Count = "0101" THEN
			P <= "000"&Shift(7 DOWNTO 3);
			ELSIF Count = "0110" THEN
			P <= "00"&Shift(7 DOWNTO 2);
			ELSIF Count = "0111" THEN
			P <= '0'&Shift(7 DOWNTO 1);
			ELSIF Count = "1000" THEN
			P <= Shift;
			END IF;
			generated <= '1';
			inrst <= '1';
		ELSIF Count = "1000" THEN 
			P <= Shift;
			generated <= '1';
			inrst <= '1';
		ELSE
			P <= "00000000";
			generated <= '0';
			inrst <= '0';
		END IF;	
	END IF;
END PROCESS;

PROCESS(valid,Count)
 	BEGIN
		IF valid = '0' or Count = "1000" THEN 
			inrst <= '1';
		
		ELSE
			inrst <= '0';
		END IF;	
END PROCESS;


end myImp;
