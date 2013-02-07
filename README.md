ruby-config-parser
==================

An exercise in creating a config parser in ruby, with commented thought process.

Parses configuration files in the format:

```
# This is a comment, ignore it
host = test.com
user = user

# More comments
log_file_path = /tmp/logfile.log
verbose = true
test_mode = on
```

Returns a hash with configuration names and keys, i.e.:
```ruby
{'host' => 'test.com',
 'user' => 'user',
 'log_file_path' => '/tmp/logfile.log',
 'verbose' => true,
 'test_mode' => 'on'}
```

Features:
* Returns native boolean values for 'true' and 'false definitions'
* Is cool with new lines in config file
* Throws custom errors for invalid lines and lines with blank definitions
* Strips leading and trailing lines of config names and values on definition lines, so " some_config_name =   some_config_value  " is the same as "some_config_name = some_config_value"

To use:
```ruby
require "./classes/config_parser"
results = ConfigParser.parse("location_to_config_file.config")
```

To run tests:
```bash
cd tests
ruby tc_config_parser.rb
```