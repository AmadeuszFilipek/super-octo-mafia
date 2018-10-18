require './run.rb'
require './request_parser.rb'
require './response_parser.rb'

describe ResponseParser do
  it 'parses all attributes', :focus do
    parser = ResponseParser.new(<<~CONTENT)
      HTTP/1.0 500 INTERNAL SERVER ERROR
      Header-One: Value One
      Header-Two: Value Two

      response body
    CONTENT

    expect(parser.http_version).to eq 'HTTP/1.0'
    expect(parser.status_code).to eq 500
    expect(parser.status_name).to eq 'INTERNAL SERVER ERROR'
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq 'response body'
  end

  it 'parses properly when headers are missing', :focus do
    parser = ResponseParser.new(<<~CONTENT)
      HTTP/1.0 500 INTERNAL SERVER ERROR

      response body
    CONTENT

    expect(parser.http_version).to eq 'HTTP/1.0'
    expect(parser.status_code).to eq 500
    expect(parser.status_name).to eq 'INTERNAL SERVER ERROR'
    expect(parser.headers).to eq({})
    expect(parser.body).to eq 'response body'
  end

  it 'parses when body is missing', :focus do
    parser = ResponseParser.new(<<~CONTENT)
      HTTP/1.0 500 INTERNAL SERVER ERROR
      Header-One: Value One
      Header-Two: Value Two
    CONTENT

    expect(parser.http_version).to eq 'HTTP/1.0'
    expect(parser.status_code).to eq 500
    expect(parser.status_name).to eq 'INTERNAL SERVER ERROR'
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq ''
  end
end

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
