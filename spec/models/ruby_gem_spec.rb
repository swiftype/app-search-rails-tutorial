require 'rails_helper'

describe RubyGem, type: :model do
  let(:example_json) do
    %q[{"name":"rake","downloads":195960151,"version":"12.3.0","version_downloads":6815814,"platform":"ruby","authors":"Hiroshi SHIBATA, Eric Hodel, Jim Weirich","info":"Rake is a Make-like program implemented in Ruby. Tasks and dependencies are\nspecified in standard Ruby syntax.\nRake has the following features:\n  * Rakefiles (rake's version of Makefiles) are completely defined in standard Ruby syntax.\n    No XML files to edit. No quirky Makefile syntax to worry about (is that a tab or a space?)\n  * Users can specify tasks with prerequisites.\n  * Rake supports rule patterns to synthesize implicit tasks.\n  * Flexible FileLists that act like arrays but know about manipulating file names and paths.\n  * Supports parallel execution of tasks.\n","licenses":["MIT"],"metadata":{},"sha":"4ebebe2c58050b29a03c3f33a23f4a19bca16cd39c7723653dc0b68f343b17a4","project_uri":"https://rubygems.org/gems/rake","gem_uri":"https://rubygems.org/gems/rake-12.3.0.gem","homepage_uri":"https://github.com/ruby/rake","wiki_uri":"","documentation_uri":"http://docs.seattlerb.org/rake","mailing_list_uri":"","source_code_uri":"https://github.com/ruby/rake","bug_tracker_uri":"https://github.com/ruby/rake/issues","changelog_uri":null,"dependencies":{"development":[{"name":"bundler","requirements":">= 0"},{"name":"coveralls","requirements":">= 0"},{"name":"minitest","requirements":">= 0"},{"name":"rdoc","requirements":">= 0"},{"name":"rubocop","requirements":">= 0"}],"runtime":[]},"updated_at":"2017-11-15T17:04:08.211Z"}]
  end

  subject { described_class.from_json(example_json) }

  it 'can be initialized from a string of json' do
    expect(subject.name).to eq('rake')
    expect(subject.authors).to eq('Hiroshi SHIBATA, Eric Hodel, Jim Weirich')
    expect(subject.info).to eq(<<~INFO)
      Rake is a Make-like program implemented in Ruby. Tasks and dependencies are
      specified in standard Ruby syntax.
      Rake has the following features:
        * Rakefiles (rake's version of Makefiles) are completely defined in standard Ruby syntax.
          No XML files to edit. No quirky Makefile syntax to worry about (is that a tab or a space?)
        * Users can specify tasks with prerequisites.
        * Rake supports rule patterns to synthesize implicit tasks.
        * Flexible FileLists that act like arrays but know about manipulating file names and paths.
        * Supports parallel execution of tasks.
    INFO
    expect(subject.raw_json['name']).to eq(subject.name)

    expect(subject.valid?).to be true
  end
end
