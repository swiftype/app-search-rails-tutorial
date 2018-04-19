class IndexResult
  attr_reader :raw_response, :successful_ids, :errored_documents

  ErroredDocument = Struct.new(:id, :errors)

  def initialize(raw_response)
    @raw_response = raw_response
    @successful_ids = []
    @errored_documents = []

    raw_response.each do |doc|
      if doc['errors'].any?
        @errored_documents << ErroredDocument.new(doc['id'].to_i, doc['errors'])
      else
        @successful_ids << doc['id'].to_i
      end
    end
  end
end
