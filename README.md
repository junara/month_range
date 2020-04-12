# MonthRange
![](https://github.com/junara/month_range/workflows/RuboCop/badge.svg)
![](https://github.com/junara/month_range/workflows/RSpec/badge.svg)

Calculate month range union and difference including unterminated end.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'month_range'
```

And then execute:

    $ bundle install

## Usage
* Month object is `MonthRange::Month` object. It is special Date object which day is beginning of month. Like this.
```ruby
Date.parse('2020-01-01') is valid.
Date.parse('2020-01-02') is not valid.
```

* range start (called as start_month) is only Month.
* range end is month or nil is valid.

### Example

```ruby
require 'month_range'

# 和

from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-03-01'), Date.parse('2020-05-01')]
MonthRange::Service.add(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-05-01 ((2458971j,0s,0n),+0s,2299161j)>], [#<Date: 2020-07-01 ((2459032j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]


# 和（例：複数期間にまたがる）
from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-03-01'), Date.parse('2020-08-01')]
MonthRange::Service.add(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]


# 和（例：隣り合った期間を連結）
from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-05-01'), Date.parse('2020-06-01')]
MonthRange::Service.add(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]


# 和（例：終端なし）
from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-05-01'), nil]
MonthRange::Service.add(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, nil]]


# 差
from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-03-01'), Date.parse('2020-05-01')]
MonthRange::Service.subtraction(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-02-01 ((2458881j,0s,0n),+0s,2299161j)>], [#<Date: 2020-07-01 ((2459032j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]


# 差（例：複数期間にまたがる）
from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-03-01'), Date.parse('2020-08-01')]
MonthRange::Service.subtraction(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-02-01 ((2458881j,0s,0n),+0s,2299161j)>], [#<Date: 2020-09-01 ((2459094j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]



# 差（例：期間内）
from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-02-01'), Date.parse('2020-03-01')]
MonthRange::Service.subtraction(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>], [#<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>, #<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>], [#<Date: 2020-07-01 ((2459032j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]



# 差（例：終端なし）
from_range_arrays = [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],[Date.parse('2020-07-01'), Date.parse('2020-10-01')],[Date.parse('2020-12-01'), nil]]
range_array = [Date.parse('2020-05-01'), nil]
MonthRange::Service.subtraction(range_array, from_range_arrays)
# => [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>]]


```

## Document
https://rubydoc.info/gems/month_range


## Development

TODO

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/month_range. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/month_range/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MonthRange project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/month_range/blob/master/CODE_OF_CONDUCT.md).
