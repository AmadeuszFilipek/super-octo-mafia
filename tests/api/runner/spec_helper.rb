
shared_examples_for 'parsing body and headers' do
  it 'returns body and headers' do
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq 'some body'
  end
end

shared_examples_for 'parsing body' do
  it 'returns body and empty headers' do
    expect(parser.headers).to eq({})
    expect(parser.body).to eq 'some body'
  end
end

shared_examples_for 'parsing headers' do
  it 'returns headers and empty body' do
    expect(parser.headers).to eq(
      'Header-One' => 'Value One',
      'Header-Two' => 'Value Two',
    )
    expect(parser.body).to eq ''
  end
end

shared_examples_for 'parsing empty headers and empty body' do
  it 'returns empty body and empty headers' do
    expect(parser.headers).to eq({})
    expect(parser.body).to eq ''
  end
end

