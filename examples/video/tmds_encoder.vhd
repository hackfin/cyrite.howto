--------------------------------------------------------------------------------
--
--   FileName:        tmds_encoder.vhd
--   Dependencies:    none
--   Design Software: Quartus II 64-bit Version 13.1.0 Build 162 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 8/7/2014 Scott Larson
--     Initial Public Release
--   Version 2.0 2/24/2014 Scott Larson
--     Corrected bug in the control signals
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tmds_encoder IS
  PORT(  
    clk      : IN  STD_LOGIC;                     --system clock
    disp_ena : IN  STD_LOGIC;                     --display enable
    control  : IN  unsigned(1 DOWNTO 0);  --C1, C0
    d_in     : IN  unsigned(7 DOWNTO 0);  --8-bit data input
    q_out    : OUT unsigned(9 DOWNTO 0)); --10-bit encoder output
END tmds_encoder;

ARCHITECTURE logic OF tmds_encoder IS
  SIGNAL q_m       : unsigned(8 DOWNTO 0); --internal data
  SIGNAL ones_d_in : INTEGER RANGE 0 TO 8;         --number of ones in the input data
  SIGNAL ones_q_m  : INTEGER RANGE 0 TO 8;         --number of ones in the internal data
  SIGNAL diff_q_m  : INTEGER RANGE -8 TO 8;        --number of ones minus the number of zeros in the internal data
  SIGNAL disparity : INTEGER RANGE -16 TO 15;      --disparity
BEGIN

  --count the ones in the input data byte
  PROCESS(d_in)
    VARIABLE ones: INTEGER RANGE 0 TO 8;
  BEGIN
    ones := 0;
    FOR i IN 0 TO 7 LOOP
      IF(d_in(i) = '1') THEN
        ones := ones + 1;
      END IF;
    END LOOP;
    ones_d_in <= ones;
  END PROCESS;

  --process interval data to minimize transitions
  PROCESS(d_in, q_m, ones_d_in)
  BEGIN
    IF(ones_d_in > 4 OR (ones_d_in = 4 AND d_in(0) = '0')) THEN
      q_m(0) <= d_in(0);
      q_m(1) <= q_m(0) XNOR d_in(1);
      q_m(2) <= q_m(1) XNOR d_in(2);
      q_m(3) <= q_m(2) XNOR d_in(3);
      q_m(4) <= q_m(3) XNOR d_in(4);
      q_m(5) <= q_m(4) XNOR d_in(5);
      q_m(6) <= q_m(5) XNOR d_in(6);
      q_m(7) <= q_m(6) XNOR d_in(7);
      q_m(8) <= '0';
    ELSE
      q_m(0) <= d_in(0);
      q_m(1) <= q_m(0) XOR d_in(1);
      q_m(2) <= q_m(1) XOR d_in(2);
      q_m(3) <= q_m(2) XOR d_in(3);
      q_m(4) <= q_m(3) XOR d_in(4);
      q_m(5) <= q_m(4) XOR d_in(5);
      q_m(6) <= q_m(5) XOR d_in(6);
      q_m(7) <= q_m(6) XOR d_in(7);
      q_m(8) <= '1';
    END IF;
  END PROCESS;
  
  --count the ones in the internal data
  PROCESS(q_m)
    VARIABLE ones: INTEGER RANGE 0 TO 8;
  BEGIN
    ones := 0;
    FOR i IN 0 TO 7 LOOP
      IF(q_m(i) = '1') THEN
        ones := ones + 1;
      END IF;
    END LOOP;
    ones_q_m <= ones;
    diff_q_m <= ones + ones - 8;  --determine the difference between the number of ones and zeros
  END PROCESS;
  
  --determine output and new disparity
  PROCESS(clk)
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
      IF(disp_ena = '1') THEN  
        IF(disparity = 0 OR ones_q_m = 4) THEN
          IF(q_m(8) = '0') THEN
            q_out <= NOT q_m(8) & q_m(8) & NOT q_m(7 DOWNTO 0);
            disparity <= disparity - diff_q_m;
          ELSE
            q_out <= NOT q_m(8)& q_m(8 DOWNTO 0);
            disparity <= disparity + diff_q_m;
          END IF;
        ELSE
          IF((disparity > 0 AND ones_q_m > 4) OR (disparity < 0 AND ones_q_m < 4)) THEN
            q_out <= '1' & q_m(8) & NOT q_m(7 DOWNTO 0);
            IF(q_m(8) = '0') THEN
              disparity <= disparity - diff_q_m;
            ELSE
              disparity <= disparity - diff_q_m + 2;
            END IF;
          ELSE
            q_out <= '0' & q_m(8 DOWNTO 0);
            IF(q_m(8) = '0') THEN
              disparity <= disparity + diff_q_m - 2;
            ELSE
              disparity <= disparity + diff_q_m;
            END IF;
          END IF;
        END IF;
      ELSE
        CASE control IS
          WHEN "00" => q_out <= "1101010100";
          WHEN "01" => q_out <= "0010101011";
          WHEN "10" => q_out <= "0101010100";
          WHEN "11" => q_out <= "1010101011";
          WHEN OTHERS => NULL;
        END CASE;
        disparity <= 0;
      END IF;
    END IF;
  END PROCESS;
  
END logic;
