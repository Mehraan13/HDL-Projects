library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port(
            i_a : in std_logic_vector (7 downto 0);
            i_b : in std_logic_vector (7 downto 0);
            o_cy : out std_logic; -- carry
            o_zr : out std_logic; -- zero
            sel : in std_logic_vector (2 downto 0);
            res : out std_logic_vector (7 downto 0)
    );
end entity alu;

architecture rtl of alu is

    signal temp_a : std_logic_vector (8 downto 0) := (others => '0');
    signal temp_b : std_logic_vector (8 downto 0) := (others => '0');
    signal temp_res : std_logic_vector (8 downto 0) := (others => '0');
    
    -- 5 operations to be implemented
    begin
            
    temp_a(7 downto 0) <= i_a;
    temp_b(7 downto 0) <= i_b;

    
    temp_res <= std_logic_vector(unsigned(temp_a) + unsigned(temp_b)) when (sel = "000") else
                temp_a or temp_b when (sel = "001") else -- OR
                temp_a and temp_b when (sel = "010") else -- AND
                temp_a xor temp_b when (sel = "011") else -- XOR
                std_logic_vector(shift_right(unsigned((temp_a)), 1)) when (sel = "100") else -- SHIFT RIGHT
                "000000000";

    o_cy <= temp_res(8); -- MSB of temp_res gives overflow
    o_zr <= '1' when (temp_res(7 downto 0) = "00000000") else 
            '0';
            

    res <= temp_res(7 downto 0);

end architecture rtl;

