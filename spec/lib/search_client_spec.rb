require 'rails_helper'

describe SearchClient do

  let(:test_client) { instance_double('SwiftypeAppSearch::Client') }

  let(:rake_gem)   { RubyGem.create(name: 'rake') }
  let(:shovel_gem) {RubyGem.create(name: 'shovel') }
  let(:hoe_gem)    { RubyGem.create(name: 'hoe') }

  let(:all_gems) { [rake_gem, shovel_gem, hoe_gem] }

  subject { described_class.new(test_client) }

  describe "Indexing documents" do
    context "when the App Search client throws an exception" do
      before do
        allow(test_client).to receive(:index_documents).and_raise(SwiftypeAppSearch::InvalidCredentials.new({}))
      end

      it "it doesn't swallow the exception" do
        expect { subject.index([rake_gem, shovel_gem, hoe_gem]) }.to raise_error(SwiftypeAppSearch::InvalidCredentials)
      end

      it "doesn't mark the documents as being indexed" do
        all_gems.each do |gem_to_index|
          expect(gem_to_index.indexed_at).to be_nil
        end
      end
    end

    context "when only some of the documents successfully index" do
      let(:shovel_error) { "I dig that name too much to index it." }

      before do
        test_response = [
          {"id" => rake_gem.id.to_s, "errors" => []},
          {"id" => hoe_gem.id.to_s, "errors" => []},
          {"id" => shovel_gem.id.to_s, "errors" => [shovel_error]},
        ]

        allow(test_client).to receive(:index_documents).and_return(test_response)
      end

      it "only marks those that succeeded as indexed" do
        subject.index(all_gems)

        [rake_gem, hoe_gem].each {|g| expect(g.reload.indexed_at).not_to be_nil }
        expect(shovel_gem.reload.indexed_at).to be_nil
      end

      it "appropriately reports successful and failed documents" do
        result = subject.index(all_gems)

        expect(result.successful_ids).to contain_exactly(rake_gem.id, hoe_gem.id)
        expect(result.errored_documents.size).to eq(1)
        expect(result.errored_documents.first.id).to eq(shovel_gem.id)
        expect(result.errored_documents.first.errors).to contain_exactly(shovel_error)
      end
    end
  end

  describe "Searching documents" do
  end

end
