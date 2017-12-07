library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_arith.all; 


entity ECEFINAL is
  
  port (
   clk, reset : in  std_logic;
	vga_hs_control		:	out std_logic; 
	vga_vs_control		:	out std_logic; 
	vga_read_dispaly 	:	out std_logic; 
	vga_green_dispaly	:	out std_logic; 
	vga_blue_dispaly	:	out std_logic;
	Button_A   : in  std_logic;
	Button_B   : in  std_logic;
	Button_C   : in  std_logic;
	Button_D   : in  std_logic;
	Hex_13     : out std_logic;
	Hex_12     : out std_logic;
	Hex_11     : out std_logic;
	Hex_10     : out std_logic;
	Hex_09     : out std_logic;
	Hex_08     : out std_logic;
	Hex_07     : out std_logic;
	Hex_06     : out std_logic;
	Hex_05     : out std_logic;
	Hex_04     : out std_logic;
	Hex_03     : out std_logic;
	Hex_02     : out std_logic;
	Hex_01     : out std_logic;
	Hex_00     : out std_logic;
	Light_A    : out std_logic;
	Light_B    : out std_logic;
	Light_C    : out std_logic;
	Light_D    : out std_logic;
	Light_R    : out std_logic);
end ECEFINAL;
architecture beh of ECEFINAL is
  type   state_type is (STATE_A, STATE_B, STATE_C, STATE_D, STATE_End, STATE_Wrong);
  signal state : state_type := STATE_End;
  signal Signal_Time : STD_LOGIC:='0';
  signal plus : STD_LOGIC:='0';
  signal counter : std_logic_vector(26 downto 0);
  signal score : std_logic_vector(7 downto 0):="00000000";
  signal segment : std_logic_vector(13 downto 0):="00001000000100";
  SIGNAL hs: STD_LOGIC; 
  SIGNAL vs: STD_LOGIC:='1'; 
  SIGNAL GRB: STD_LOGIC_VECTOR(2 DOWNTO 0); 

begin
------------------------------------------
vgaclk:PROCESS (clk)  ---hs = 30 Khz vs = 57hz 
	VARIABLE i	:	integer range 0 to 799:=0; 
	VARIABLE j	:	integer range 0 to 79:=0; 
BEGIN 
 if reset = '1' then 
   GRB <= "000"; i:=96; j:=0;  hs <= '1'; 
	elsif clk'event and clk = '1'  then 
	  if i < 96 then 
	     hs <= '0'; 
	  elsif i = 799 then 
	     i:=0; 
	  else 
	     hs <= '1'; 
	  end if; 
	  if j = 79 then 
	     GRB(1) <= not GRB(1); 
	     j:=0; 
	  end if; 
	  i:=i+1; 
	  j:=j+1;		  	
	end if; 
	vga_hs_control <= hs;  
END PROCESS vgaclk; 
------------------------------------------------
vgahs:PROCESS (hs) 
VARIABLE k	:	integer range 0 to 524:=0; 
BEGIN 
if reset = '1' then 
   k:=2; vs <= '1'; 
	elsif hs'event and hs = '1' then 
	    if k < 2 then 
	       vs <= '0'; 
	    elsif k = 524 then 
	       k:=0; 
	    else 
	       vs <= '1'; 
	    end if; 
	    k:=k+1; 
	  end if; 
  vga_vs_control <= vs;  
END PROCESS vgahs; 
--------------------------------------------------
vgaout:PROCESS (clk) 
BEGIN 
	if clk'event and clk = '1' and vs = '1' and hs ='1' then 
		vga_green_dispaly <= GRB(2); 
	    vga_read_dispaly  <= GRB(1); 
		vga_blue_dispaly  <= GRB(0);				
end if; 
END PROCESS vgaout;
------------------------------------------
Scoplay: process (clk,score)
BEGIN
if (clk'event and clk='1') then
	if segment(13) = '1' then
		Hex_13 <= '1';
	else
		Hex_13 <= '0';
	end if;
	if segment(12) = '1' then
		Hex_12 <= '1';
	else
		Hex_12 <= '0';
	end if;
	if segment(11) = '1' then
		Hex_11 <= '1';
	else
		Hex_11 <= '0';
	end if;
	if segment(10) = '1' then
		Hex_10 <= '1';
	else
		Hex_10 <= '0';
	end if;
	if segment(9) = '1' then
		Hex_09 <= '1';
	else
		Hex_09 <= '0';
	end if;
	if segment(8) = '1' then
		Hex_08 <= '1';
	else
		Hex_08 <= '0';
	end if;
	if segment(7) = '1' then
		Hex_07 <= '1';
	else
		Hex_07 <= '0';
	end if;
	if segment(6) = '1' then
		Hex_06 <= '1';
	else
		Hex_06 <= '0';
	end if;
	if segment(5) = '1' then
		Hex_05 <= '1';
	else
		Hex_05 <= '0';
	end if;
	if segment(4) = '1' then
		Hex_04 <= '1';
	else
		Hex_04 <= '0';
	end if;
	if segment(3) = '1' then
		Hex_03 <= '1';
	else
		Hex_03 <= '0';
	end if;
	if segment(2) = '1' then
		Hex_02 <= '1';
	else
		Hex_02 <= '0';
	end if;
	if segment(1) = '1' then
		Hex_01 <= '1';
	else
		Hex_01 <= '0';
	end if;
	if segment(0) = '1' then
		Hex_00 <= '1';
	else
		Hex_00 <= '0';
	end if;
end if;
end process Scoplay;
-----------------------------------------------------
Sco: process (clk, score)
begin
if (clk'event) and (clk='1') then
case  score is
when "00000000"=> segment <="00000000000001";  -- '0'
when "00000001"=> segment <="00000001001111";  -- '1'
when "00000010"=> segment <="00000000010010";  -- '2'
when "00000011"=> segment <="00000000000110";  -- '3'
when "00000100"=> segment <="00000001001100";  -- '4' 
when "00000101"=> segment <="00000000100100";  -- '5'
when "00000110"=> segment <="00000000100000";  -- '6'
when "00000111"=> segment <="00000000001111";  -- '7'
when "00001000"=> segment <="00000000000000";  -- '8'
when "00001001"=> segment <="00000000000100";  -- '9'
when "00001010"=> segment <="10011110000001";  -- '10'
when "00001011"=> segment <="10011111001111";  -- '11'
when "00001100"=> segment <="10011110010010";  -- '12'
when "00001101"=> segment <="10011110000110";  -- '13'
when "00001110"=> segment <="10011111001100";  -- '14'
when "00001111"=> segment <="10011110100100";  -- '15'
when "00010000"=> segment <="10011110100000";  -- '16'
when "00010001"=> segment <="10011110001111";  -- '17'
when "00010010"=> segment <="10011110000000";  -- '18'
when "00010011"=> segment <="10011110000100";  -- '19'
when "00010100"=> segment <="10011110000001";  -- '20'
when others=> segment <="00000000000000"; --GG
end case;
end if;
end process Sco;
-----------------------------------------
Prescaler:process (clk)
  begin
  
    if clk'event and clk = '1' then
      if counter < "111111111111111111111111111" then
        counter <= counter + 1;
		  Signal_Time <= '0';
      else
        counter <= (others => '0');
		  Signal_Time <= '1';
      end if;
    end if;
end process Prescaler;
---------------------------------------------
Button:process (clk, reset)
  begin
    if reset = '1' then
      state <= STATE_End;
		Light_R <= '1';
    elsif clk'event and clk = '1' then
	   Light_R <= '0';
      case state is
		
        when STATE_A =>
          Light_A <= '1';
			 Light_B <= '0';
			 Light_C <= '0';
			 Light_D <= '0';
          if (Button_A = '1') then
		     Light_A <= '1';
			  Light_B <= '1';
			  Light_C <= '1';
			  Light_D <= '1';
				if (Signal_Time = '1') then
					state <= STATE_Wrong;
				end if;
          elsif (Signal_Time = '1') then
            state <= STATE_D;
			 elsif (Button_B = '1') or (Button_C = '1') or (Button_D = '1') then
				state <= STATE_Wrong;
          end if;
			 
        when STATE_B =>
          Light_A <= '0';
			 Light_B <= '1';
			 Light_C <= '0';
			 Light_D <= '0';
          if (Button_B = '1') then
			  Light_A <= '1';
			  Light_B <= '1';
			  Light_C <= '1';
			  Light_D <= '1';
				if (Signal_Time = '1') then
					state <= STATE_Wrong;
				end if;
          elsif (Signal_Time = '1') then
            state <= STATE_A;
			 elsif (Button_A = '1') or (Button_C = '1') or (Button_D = '1') then
				state <= STATE_Wrong;
          end if;
			 
        when STATE_C =>
          Light_A <= '0';
			 Light_B <= '0';
			 Light_C <= '1';
			 Light_D <= '0';
          if (Button_C = '1') then
			  Light_A <= '1';
			  Light_B <= '1';
			  Light_C <= '1';
			  Light_D <= '1';
				if (Signal_Time = '1') then
					state <= STATE_Wrong;
				end if;
          elsif (Signal_Time = '1') then
            state <= STATE_B;
			 elsif (Button_A = '1') or (Button_B = '1') or (Button_D = '1') then
				state <= STATE_Wrong;
          end if;
			 
        when STATE_D =>
          Light_A <= '0';
			 Light_B <= '0';
			 Light_C <= '0';
			 Light_D <= '1';
          if (Button_D = '1') then
			  Light_A <= '1';
			  Light_B <= '1';
			  Light_C <= '1';
			  Light_D <= '1';
				if (Signal_Time = '1') then
					state <= STATE_Wrong;
				end if;
          elsif (Signal_Time = '1') then
            state <= STATE_C;
			 elsif (Button_A = '1') or (Button_B = '1') or (Button_C = '1') then
				state <= STATE_Wrong;
          end if;
		
			when STATE_wrong =>
			 Light_A <= '0';
			 Light_B <= '0';
			 Light_C <= '0';
			 Light_D <= '0';
			 Light_R <= '1';
			 if reset = '1' then
				state <= STATE_End;
			 end if;
			 
			when STATE_End =>
			 Light_A <= '0';
			 Light_B <= '0';
			 Light_C <= '0';
			 Light_D <= '0';
			 state <= STATE_C;
        when others => null;
      end case;
    end if;
  end process Button;
------------------------------------------------
end beh;
