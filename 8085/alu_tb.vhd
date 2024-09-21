library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end entity alu_tb;

architecture behavioral of alu_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component alu
        port(
            i_a : in std_logic_vector(7 downto 0);
            i_b : in std_logic_vector(7 downto 0);
            o_cy : out std_logic;
            o_zr : out std_logic;
            sel : in std_logic_vector(2 downto 0);
            res : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals to connect to UUT
    signal i_a : std_logic_vector(7 downto 0) := (others => '0');
    signal i_b : std_logic_vector(7 downto 0) := (others => '0');
    signal sel : std_logic_vector(2 downto 0) := (others => '0');
    signal res : std_logic_vector(7 downto 0);
    signal o_cy : std_logic;
    signal o_zr : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: alu port map(
        i_a => i_a,
        i_b => i_b,
        sel => sel,
        o_cy => o_cy,
        o_zr => o_zr,
        res => res
    );

    -- Test process
    process
    begin
        -- Test case 1: Addition
        i_a <= "00000101"; -- 5
        i_b <= "00000011"; -- 3
        sel <= "000";      -- Add
        wait for 10 ns;
        
        -- Check results
        assert (res = "00001000" and o_cy = '0') 
        report "Addition failed!" severity error;

        -- Test case 2: Addition with carry
        i_a <= "11111111"; -- 255
        i_b <= "00000001"; -- 1
        sel <= "000";      -- Add
        wait for 10 ns;

        -- Check results (carry overflow expected)
        assert (res = "00000000" and o_cy = '1')
        report "Addition with carry failed!" severity error;

        -- Test case 3: OR
        i_a <= "00001111";
        i_b <= "11110000";
        sel <= "001";      -- OR
        wait for 10 ns;

        -- Check results
        assert (res = "11111111" and o_cy = '0')
        report "OR operation failed!" severity error;

        -- Test case 4: AND
        i_a <= "11110000";
        i_b <= "10101010";
        sel <= "010";      -- AND
        wait for 10 ns;

        -- Check results
        assert (res = "10100000" and o_cy = '0')
        report "AND operation failed!" severity error;

        -- Test case 5: XOR
        i_a <= "11001100";
        i_b <= "10101010";
        sel <= "011";      -- XOR
        wait for 10 ns;

        -- Check results
        assert (res = "01100110" and o_cy = '0')
        report "XOR operation failed!" severity error;

        -- Test case 6: Shift Right
        i_a <= "10101010"; -- Shift right on A
        sel <= "100";      -- Shift right
        wait for 10 ns;

        -- Check results
        assert (res = "01010101" and o_cy = '0')
        report "Shift Right failed!" severity error;

        -- Test case 7: Zero flag check
        i_a <= "00000000";
        i_b <= "00000000";
        sel <= "000";      -- Add
        wait for 10 ns;

        -- Check results (zero flag should be set)
        assert (o_zr = '1') 
        report "Zero flag failed!" severity error;

        wait;
    end process;
end architecture behavioral;
