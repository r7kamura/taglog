# Taglog
Taglog provides taggable logger extension to any class which has `#logger` method.

## Installation
```
$ gem install taglog
```

## Usage

### Basic
```ruby
# a class which has `#logger` method
class A
  def hello
    logger.debug("hello")
  end

  def log
    io.string
  end

  private

  def logger
    @logger ||= Logger.new(io)
  end

  def io
    @io ||= StringIO.new
  end
end

# extend class A with Taglog
A.extend Taglog.new("class A")

# use logger
a = A.new
a.hello
a.hello
a.hello
puts a.log
```

```
D, [2012-12-11T00:16:03.032614 #679] DEBUG -- : [class A] hello
D, [2012-12-11T00:16:03.252622 #679] DEBUG -- : [class A] hello
D, [2012-12-11T00:16:03.680119 #679] DEBUG -- : [class A] hello
```

### Rails
```ruby
# Gemfile
group :development do
  gem "taglog"
end
```

```ruby
# config/environments/development.rb
require "active_record/log_subscriber"
require "action_view/log_subscriber"
require "action_controller/log_subscriber"
    ActiveRecord::LogSubscriber.extend Taglog.new("M")
      ActionView::LogSubscriber.extend Taglog.new("V")
ActionController::LogSubscriber.extend Taglog.new("C")
```

```
$ rails s
...
[C] Processing by EntriesController#show as HTML
[C]   Parameters: {"id"=>"1234567"}
[V]   Rendered entries/show.html.erb (7.5ms)
[M]   Entry Exists (6.4ms)  SELECT 1 AS one FROM ...
[C] Completed 200 OK in 88ms ...
```
