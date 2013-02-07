require "../classes/config_parser"
require "test/unit"

# This a class to test our config parser with a variety
# of cases.  Tests are a great practice to ensure code
# works in a varitey of edge cases.  Tests also are
# quite convenient when refactoring, as it allows us
# to do a sanity check to make sure we didn't break 
# functionality

class TestConfigParser < Test::Unit::TestCase

  # Below I define tests that only test the publicly
  # facing function (parse) on a variety of cases
  # I'm not testing internal functions that parse relies on,
  # so if those internal methods are refactored, we
  # don't have to rewrite tests

  # Here is the correct results we want each valid
  # config file to return.  This could be made into
  # a class variable, but for ease of use and inheritance
  # I defined it as a function for now.
  def correct_results
    {'host' => 'test.com',
     'user' => 'user',
     'log_file_path' => '/tmp/logfile.log',
     'verbose' => true,
     'test_mode' => 'on'}
  end

  # Test parsing of a normally-configured config file
  def test_valid
    assert_equal(correct_results,
                 ConfigParser.parse("data/valid.config"))
  end

  # Test parsing of a config file which is valid, but 
  # contains empty line breaks and whitespace in the definitions
  def test_valid_with_spaces
    assert_equal(correct_results,
                 ConfigParser.parse("data/valid_with_spaces.config"))
  end

  # Test parsing of a config file that defines
  # a variable twice.  It should take the last value
  def test_valid_with_double_definition
    assert_equal(correct_results,
                 ConfigParser.parse("data/valid_with_double_definition.config"))
  end

  # Test raising error for config file which has an invalid line
  def test_invalid
    cp = ConfigParser.new("data/invalid.config")
    assert_raise ConfigParser::ParseException do
      cp.results
    end
  end

  # Test raising error for config file which has a line
  # defining nothing
  def test_invalid_defining_nothing
    cp = ConfigParser.new("data/invalid_defining_nothing.config")
    assert_raise ConfigParser::ParseException do
      cp.results
    end
  end

end