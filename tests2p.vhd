library ieee;
use ieee.std_logic_1164.all;
	
use std.env.stop;


entity tests2p is
end entity;

Architecture tbs2p of tests2p is
component s2p is
port (
clk,rst,valid,S: in std_logic;
generated: out std_logic;
P: out std_logic_vector(7 downto 0));
end component;

signal tclk,trst,tvalid,tdata,tgenerated : std_logic;
signal P : std_logic_vector(7 downto 0);
constant Tperiod : time := 10 ns;

function clearedBitCheck(tgenerated:std_logic; count: integer) return integer is
	variable c: integer;
begin
	c := count;
	if (tgenerated /= '0') then
		report "Failed clear generated" severity error;
		c := count +1;
	else 
		report "Passed clear generated";
	end if;
	return c;
end function;

function parallelDataCheck(tgenerated:std_logic; count: integer; inputData:std_logic_vector(7 downto 0);
        P:std_logic_vector(7 downto 0)) return integer is
	variable c: integer;
begin
	c := count;
	if (tgenerated /= '1') then
		report "Failed:  data" severity error;
		c := count +1;
	elsif (tgenerated = '1') and (inputData /= P) then
		report "Failed: data" severity error;
		c := count +1; 
	else
		report "Passed data" ;
	end if;
	return c;
end function;

procedure shiftdataIn(signal tdata: out std_logic;variable inputData:in std_logic_vector(15 downto 0);
constant minK:in integer; constant maxK : in integer; constant T: in time) is
begin
	test1 : for k in minK to maxK loop
      		tdata <= inputData(k);
      		wait for Tperiod;
		end loop test1;
end procedure;

begin

U0: s2p port map(tclk,trst,tvalid,tdata,tgenerated,P);

process 
begin
tclk <= '0'; wait for Tperiod/2;
tclk  <= '1'; wait for Tperiod/2;
end process;

process
variable count : integer := 0;
variable inputData : std_logic_vector(15 downto 0);
begin

trst <= '1';
tvalid <='1';
tdata <='1';
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);

trst <= '0';
tvalid <= '0';
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);

tvalid <= '1';
inputData:= "1111111110010011";
	shiftdataIn(tdata,inputData,0,7,Tperiod);
tvalid <= '0';
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,inputData(7 downto 0),P);

wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);


-- --------------------------------------------
tvalid <= '1';
inputData:= "1111101110001101";   
	shiftdataIn(tdata,inputData,0,7,Tperiod);
tdata <= inputData(8);
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,inputData(7 downto 0),P);

tvalid <= '0';
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,"0000000" & inputData(8),P);

wait for Tperiod;
count := clearedBitCheck(tgenerated,count);

-- ------------------------------------------------

tvalid <= '1';
inputData:= "1111101110001101";   
	shiftdataIn(tdata,inputData,0,5,Tperiod);

tvalid <= '0';
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,"00" & inputData(5 DOWNTO 0),P);

wait for Tperiod;
count := clearedBitCheck(tgenerated,count);

-- ------------------------------------------------


-- --------------------------------------------
tvalid <= '1';
inputData:= "1111101110001101";
    	shiftdataIn(tdata,inputData,0,7,Tperiod);
tdata <= inputData(8);
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,inputData(7 downto 0),P);
tdata <= inputData(9);
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);
tdata <= inputData(10);
tvalid <= '0';
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,"000000" & inputData(9 downto 8),P);
wait for Tperiod;
count := clearedBitCheck(tgenerated,count);

-- ------

tvalid <= '1';
inputData:= "1111101110001101";
    	shiftdataIn(tdata,inputData,0,7,Tperiod);
tdata <= inputData(8);
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,inputData(7 downto 0),P);
tdata <= inputData(9);
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);
tdata <= inputData(10);
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);
tdata <= inputData(11);
tvalid <= '0';
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,"00000" & inputData(10 downto 8),P);
wait for Tperiod;
count := clearedBitCheck(tgenerated,count);

-- ------

tvalid <= '1';
inputData:= "1111101110001101";
    	shiftdataIn(tdata,inputData,0,7,Tperiod);
tdata <= inputData(8);
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,inputData(7 downto 0),P);
tdata <= inputData(9);
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);
tdata <= inputData(10);
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);
tdata <= inputData(11);
wait for Tperiod;
	count := clearedBitCheck(tgenerated,count);
	tdata <= inputData(12);
	tvalid <= '0';
wait for Tperiod;
	count := parallelDataCheck(tgenerated,count,"0000" & inputData(11 downto 8),P);
wait for Tperiod;
count := clearedBitCheck(tgenerated,count);


report "Number of failed test cases:" & integer'image(count) & " / 24" ;

stop;
end process;

end architecture;
