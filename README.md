# Celluloid::Pmap

[![Build Status](https://travis-ci.org/jwo/celluloid-pmap.png?branch=master)](https://travis-ci.org/jwo/celluloid-pmap)
[![Code Climate](https://codeclimate.com/github/jwo/celluloid-pmap.png)](https://codeclimate.com/github/jwo/celluloid-pmap)

Parallel Mapping using Celluloid

Celluloid Futures are wicked sweet, and when combined with a `pmap`
implementation AND a supervisor to keep the max threads down, you can be wicked
sweet too!

### How does this happen?
![celluloid](https://f.cloud.github.com/assets/123075/109654/7584c1fa-6a8c-11e2-9ad6-114818b7fbe4.png)

We use Celluloid Futures and Celluloid pool to execute blocks in parallel. 

The pmap will return an array of values when all of the Futures have completed and return values (or return nil).

The pool can help to make sure you don't exceed your connection resources. A common use case for this is in Rails, you can easily exceed the default ActiveRecord connection size.

### Use with ActiveRecord

Some users have reported connection leaking with using ActiveRecord objects in a
pmap. You can reuse a connection with this code below. You can read the backstory
on the [decision to not include an AR dependency](https://github.com/jwo/celluloid-pmap/pull/2).

```ruby
users.pmap(4) do |user|
  ActiveRecord::Base.connection_pool.with_connection { user.do_hefty_stuff! }
end
```


### Inspiration for this code

Tony Arcieri created [celluloid](http://celluloid.io/), and the [simple_pmap example](https://github.com/celluloid/celluloid/blob/master/examples/simple_pmap.rb) from which this codebase started

### Is this production ready?

I've used this implementation in several production systems over the last year. All complexity is with Celluloid (not 1.0 yet, but in my experience has been highly stable.)

### Why is this a gem?

Because I've been implementing the same initializer code in every project I've worked on for the last 6 months. It was time to take a stand, man.

### What rubies will this run on?

* 2.0.0
* 2.1.3
* 2.2.0
* jruby-19mode
* jruby-head


## Installation

Add this line to your application's Gemfile:

    gem 'celluloid-pmap'

## Usage

Default usage will execute in parallel. Simply pass a block to an Enumerable
(like an Array)

```
puts "You'll see the puts happen instantly, and the sleep in parallel"

[55,65,75,85].pmap{|limit| puts "I can't drive #{limit}!"; sleep(rand)}
```

Or something more real-world?

```
User.active.all.pmap do |user| 
  stripe_user = Stripe::Customer.retrieve user.stripe_customer_token
  user.invoices = BuildsInvoicesFromStripeUser.build(stripe_user)
  user.save
end
```

Problem: When using with ActiveRecord, you can quickly run out of connections.  
Answer: Specify the max number of threads (actors) to create at once!

```
puts "You should see two distinct groups of timestamps, 3 seconds apart"
puts [1,2,3].pmap(2){|speed_limit| puts Time.now.tap { sleep(3) }}

=> You should see two distinct groups of timestamps, 3 seconds apart
2013-01-29 21:15:01 -0600
2013-01-29 21:15:01 -0600
2013-01-29 21:15:04 -0600
```

We default pmap's threads to the number of Celluloid cores in the system.

### When should you use pmap over Sidekiq or Actors?

When you need the response right away. (well, right away in the workflow sense). This is crazy good in IRB too. Destroying multiple records in parallel is nice.

### When will this help performance?

* When the blocks are IO bound (like database or web queries)
* When you're running JRuby or Rubinius
* When you're running C Extensions

### So what will this not speed things up?

* Pure math or ruby computations*

\*except if you're on JRuby or Rubinius, where this will still speed those along quite nicely.

## Image Credit

Ben Scheirman (@subdigital) originally used the awesome Celluloid He-Man image
in a presentation on background workers. "He-Man and the Masters of the
Universe," AND "She-Ra: Princess of Power" are copyright Mattel.

More information on He-Man can be found at the unspeakably wow site: http://castlegrayskull.org

## Contributors

* [Jason Voegele](https://github.com/jvoegele)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
