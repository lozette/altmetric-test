require 'combine'

RSpec.describe(Combine) do
  it 'produces a nice error if nothing is passed to it' do
    combine_result = Combine.new
    expect(combine_result.combine).to eq('Error, at least one input file needed')
  end

  it 'produces json' do
    combine_result = Combine.new('json', 'articles.csv', 'authors.json', 'journals.csv')
    expect(combine_result.combine).to include('{"doi":"10.1234/altmetric0","article_title":"Small Wooden Chair","author":["Amari Lubowitz"],"journal_title":"Bartell-Collins","issn":"1337-8688"}')
  end

  it 'produces csv' do
    combine_result = Combine.new('csv', 'articles.csv', 'authors.json', 'journals.csv')
    expect(combine_result.combine).to include('10.1234/altmetric0,Small Wooden Chair,Amari Lubowitz,Bartell-Collins,1337-8688')
  end
end