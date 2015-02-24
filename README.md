# Cognition

This is a gem that parses a message, and compares it to various matchers.
When it finds the **first match**, it executes an associated block of code or
method, returning the output of whatever was run.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognition'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cognition

## Usage

Process your message:
```ruby
result = Cognition.process('command I need to process')
```

You can also include metadata with your message, like user info, or whatever:
```ruby
result = Cognition.process('another command', {user_id: 15, name: 'Bob'})
```

Internally, `Cognition` will turn your values into a `Cognition::Message` so
the metadata will be passed along with the message, and arbitrary metadata
is available in the #metadata Hash:
```ruby
msg = Cognition::Message('another command', {user_id: 15, name: 'Bob'})
msg.metadata   # Returns { user_id: 15, name: 'Bob' }
```

### Special metadata
If you include a `callback_url` key in your metadata, we'll give you a
convenience method to reply to it using the `reply` method.  This will
invoke a HTTParty POST back to the URL with your text sent as the
`content` variable.
```ruby
msg = Cognition::Message('another command', {
  callback_url: "http://foo.bar/baz",
  user_id: 15,
  name: 'Bob'
})

msg.reply("foo")   # Posts 'content=foo' to http://foo.bar/baz
```

## Creating a Plugin
Creating plugins is easy. Subclass `Cognition::Plugins::Base` and setup your
matches and logic that should be run:
```ruby
class Hello < Cognition::Plugins::Base
  # Simple string based matcher. Must match *EXACTLY*
  match 'hello', 'hello: Returns Hello World', :hello

  # Advanced Regexp based matcher. Capture groups are made available
  # via MatchData in the matches method
  match /hello\s*(?<name>.*)/, :hello_person, help: {
    'hello <name>' => 'Greets you by name!'
  }


  def hello(*)
    'Hello World'
  end

  def hello_person(msg, match_data = nil)
    name = match_data[:name]
    "Hello #{name}"
  end
end
```

After you've done that, you will be able to do:
```ruby
Cognition.register(Hello)
Cognition.process("help hello")  # "hello <name> - Greets you by name!"
Cognition.process("hello")       # "Hello World"
Cognition.process("hello foo")   # "Hello foo"
```

## Contributing

1. Fork it ( https://github.com/anoldguy/cognition/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
