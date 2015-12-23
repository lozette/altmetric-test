require 'combine'

RSpec.describe(Combine) do
  it 'produces a nice error if nothing is passed to it' do
    combine_result = Combine.new
    expect(combine_result.combine).to eq('Error, at least one input file needed')
  end

  it 'produces json' do
    combine_result = Combine.new('json', 'journals.csv', 'articles.csv', 'authors.json')
    expect(combine_result.combine).to eq('')
  end

  it 'produces csv' do
    #combine_result = Combine.new()
  end
end