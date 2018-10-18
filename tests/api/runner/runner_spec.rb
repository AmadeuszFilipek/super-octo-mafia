require './run.rb'

describe RequestParser do
  it 'parses verb, uri, headers and body' do
    parser = RequestParser.new(<<~CONTENT)
      DELETE /api/path/to/delete
      Header-One: Value One
      Header-Two: Value Two

      request body
    CONTENT

    expect(parser.verb).to eq 'DELETE'
    expect(parser.uri).to eq '/api/path/to/delete'
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq 'request body'
  end

  it 'parses content without headers' do
    parser = RequestParser.new(<<~CONTENT)
      DELETE /api/path/to/delete

      request body
    CONTENT

    expect(parser.verb).to eq 'DELETE'
    expect(parser.uri).to eq '/api/path/to/delete'
    expect(parser.headers).to eq({})
    expect(parser.body).to eq 'request body'
  end

  it 'parses content without body' do
    parser = RequestParser.new(<<~CONTENT)
      DELETE /api/path/to/delete
      Header-One: Value One
      Header-Two: Value Two
    CONTENT

    expect(parser.verb).to eq 'DELETE'
    expect(parser.uri).to eq '/api/path/to/delete'
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq ''
  end

  it 'parses content without body and headers' do
    parser = RequestParser.new(<<~CONTENT)
      DELETE /api/path/to/delete
    CONTENT

    expect(parser.verb).to eq 'DELETE'
    expect(parser.uri).to eq '/api/path/to/delete'
    expect(parser.headers).to eq({})
    expect(parser.body).to eq ''
  end
end
