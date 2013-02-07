# I created the config parser as a small class.
# This helps me organize the code, and allows the class
# to be inherited from for other uses.

class ConfigParser

  # There will be times when a config file is invalid,
  # and we will raise a custom error for that case.
  # If we wanted the config parser to be more lenient,
  # we could expand this class to not throw this error,
  # but instead ignore invalid lines
  class ParseException < StandardError
  end

  # The use case for this function is creating a new instance,
  # and then returning the results, so let's make a class function
  # to make this quick
  def self.parse(file_location)
    return ConfigParser.new(file_location).results
  end

  # Constructor for taking in the file location
  def initialize(file_location)
    @file_location = file_location
  end

  # Returns the variable definitions of a config file
  def results
    # Start with an empty hash, in case we don't have any definitions
    final_results = {}

    # Parsing the file line by line is the easiest way to
    # parse this config file
    File.open(@file_location).each_with_index do |line, counter|
      # Let's find out information about this line
      # Because this is some complex logic, I've put it into a seperate
      # function
      line_parsed = parse_line(line, counter+1)

      # If this line includes a definition, let's put it into
      # our results.  The line could be of different types (i.e. :new_line
      # or :comment) which we don't care about for the actual results
      if line_parsed[:type] == :definition
        # We allow values to be defined twice in the config,
        # and we take the last defined value.  For that,
        # we just use merge! on our existing reults
        final_results.merge!(line_parsed[:data])
      end

    end

    # Implicit returns are nice, I miss them in other languages...
    final_results
  end

  # Takes in a line and a line number, and returns a 
  # hash with the type of the line in the :type key,
  # and any additional data in the :data key.
  # We currently only care about definitions, but if we wanted to
  # extend this to report information about comments or new lines,
  # we could easily do that.
  def parse_line(line, line_number)
    # Lets be lenient with whitespace
    line = line.strip

    # This line doesnt include any actual characters, let's let 
    # it pass as a new line
    if line == ""
      return {:type => :new_line}
    end

    # Anything that starts with a # we will treat as a comment
    if line[0] == "#"
      return {:type => :comment}
    end

    # Let's check for valid definition syntax
    split_by_equals = line.split("=", 2)
    # If there's no occurence of an = character at this point,
    # we have invalid syntax
    if split_by_equals.size == 1
      # Here we raise our custom Exception, making it easy for the
      # caller of this function to catch it.
      # We also call out the line number, so we can pinpoint the
      # error in a large file.
      raise ParseException,
            "Invalid definition on line #{line_number}"
    end

    # We discard whitespace at the beginning
    # and end of variable name and value definitions
    value_name = split_by_equals[0].strip
    value_definition = split_by_equals[1].strip
    if value_definition == ""
      raise ParseException,
        "No value definition found on line #{line_number}"
    end

    # This function is getting long, and parse_value_definition has
    # a clear purpose and input value, so it was put into a seperate function
    data = {value_name => parse_value_definition(value_definition)}
    return {:type => :definition,
            :data => data}
  end

  # Parses a value definition, translating into a boolean value
  # when appropritate.
  def parse_value_definition(value_definition)
    # Case statements are sometimes prettier than if/elses
    case(value_definition)
    when "true"
      return true
    when "false"
      return false
    else
      return value_definition
    end
  end

end