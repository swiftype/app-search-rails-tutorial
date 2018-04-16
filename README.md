# James' Gem Hunt

### The App

Gem Hunt is the tool to use when you're hunting for a gem! It is a simple search interface for RubyGems built using Swiftype's App Search product. To get the app running, you'll need:

- Ruby! But you probably knew that.
- A database that supports the json data type (I used PostgreSQL).
- The `credentials.yml.enc` for James' Gem Hunt, or your own App Search credentials and a json dump of gem metadata.
- To run `bin/setup`, which should install all the required gems, make sure you have the proper Ruby installed, and setup your database.
- To populate the database with the `ruby_gems:populate[my_file.json]` task.
- And finally, if you're using a new App Search Account, you'll need to initially index your gems using the `ruby_gems:initial_index` task.

### The Process

### The Rough Spots
