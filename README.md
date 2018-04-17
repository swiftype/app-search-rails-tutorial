# James' Gem Hunt

### The App

Gem Hunt is the tool to use when you're hunting for a gem! It is a simple search interface for RubyGems built using Swiftype's App Search product. Getting things up and running is fairly simple:

- You'll need Ruby, but you probably knew that.
- You'll need a database that supports the json data type (I used PostgreSQL).
- And you'll need the `credentials.yml.enc` for James' Gem Hunt, or your own App Search credentials and a json dump of gem metadata.
- Running `bin/setup` should get you most of the way, which should install all the required gems, make sure you have the proper Ruby installed, and setup your database.
- You can then populate the database with the `ruby_gems:populate[my_file.json]` task.
- Finally, if you're using a new App Search Account, you'll need to initially index your gems using the `ruby_gems:initial_index` task.

### The Process

- Go to https://swiftype.com/app-search, and click "join the free beta"
- create a swiftype account and verify your email address
- log in and click the "Access the Beta" button next to the text "Looking to try out App Search?"
- Create your first engine! [1]
- Now grab your [authentication credentials](https://app.swiftype.com/as/credentials), and store them with the rest of your secrets (I used [Rails encrypted credentials](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2)).
- My app currently lets you search for and show information about RubyGems, but it has [The worst search algorithm](https://github.com/swiftype/james-gem-hunt/blob/5e7f610b943175fc20b80d5d7f58dba074fecaf7/app/controllers/ruby_gems_controller.rb#L15:L18), lets see if we can improve it using App Search.
- Since App Search manages it's own schema, there's nothing else to setup...we can just start Indexing documents. Using the [swiftype-app-search-ruby gem](https://github.com/swiftype/swiftype-app-search-ruby) makes this fairly painless. Just put the relevant fields into a hash and submit them as a document. [2]

- The App Search [Search API]() has many options at your disposal to help you fulfill your searching needs, but to get started, we're just going to pass it our query directly and let it search across all the fields we have indexed. [3]

### The Rough Spots

1. When you first enter App Search, you are prompted to create your first engine. It'd be nice to have a little explanation for what it is you're creating, similar to the explanation provided [here under step 2: creating an engine](https://swiftype.com/documentation/app-search/getting-started). You actually aren't linked to this documentation until after you've created the engine.

2. both the [Getting Started Guide](https://swiftype.com/documentation/app-search/getting-started) and the [Indexing Documents Guide](https://swiftype.com/documentation/app-search/guides/indexing-documents) describe the basics of documents, but neither talks at all about the ID field. It's hinted at that it is important in other sections where it is used to reference specific documents.

3. The docs do a great job of describing the options for searching, filtering, and controlling the format of the API result, but it doesn't mention that the results are paginated. Unpacking the result format is also a little arduous, but it might be better for less general use cases than what I'm using now.

4. It seems like Value Facets are a kind of aggregation, but I'll admit that after reading the docs I was still confused about them. Maybe this could use a little more explanation.

5. I'd just reiterate that in the Searching section especially, it'd really be nice to see some example API responses. There are quite a few options for queries, and it'd be great to see what you can expect out of the other side as you tweak them.

### Possible Next Steps

- Catch exceptions thrown by the API Client in my client code.
- Handle errors surfaced in the indexing API response (right now the code just assumes it worked).
- Handle pagination of Search Results...right now we only ever display the first ten.
  - This will require understanding how to request the next page of search results.
- Weight the query so that matches to `name` are more important than matches to `info`, it's a little weird that things that mention Rake rank above the actual Rake gem.
- Support more interesting queries, either through a more complicated search form, or parsing special query invocations.
- Pretty up "The Process" portion of my readme, so it more resembles a tutorial.
