require 'json'
require 'csv'

class Combine
  def initialize(format = 'json', articles = nil, authors = nil, journals = nil)
    @format     = format
    @articles_f = articles
    @authors_f  = authors
    @journals_f = journals
  end

  def combine
    return 'Error, at least one input file needed' unless @articles_f || @authors_f || @journals_f
    
    result = []

    CSV.foreach(File.path("resources/#{@articles_f}"), :headers => true) do |row|
      doi     = row['DOI']
      title   = row['Title']
      issn    = row['ISSN']
      journal = find_journal(issn)
      author  = find_author(doi)

      row = {
        doi:           doi,
        article_title: title,
        author:        author,
        journal_title: journal,
        issn:          issn
      }

      result << row
    end

    format(result)
  end

  private

  def format(data)
    if @format == 'json'
      data.to_json
    elsif @format == 'csv'
      headers = %w(doi, article_title, authors, journal_title, issn)
      CSV.generate do |csv|
        csv << headers

        data.each do |row|
          csv << [
            row[:doi],
            row[:article_title],
            row[:author].join(', '),
            row[:journal_title],
            row[:issn]
          ]
        end
    end
    else
      return 'Sorry, unknown format'
    end
  end

  def find_journal(issn)
    journals = parse_csv(@journals_f)

    journal = journals.find { |r| r['ISSN'] = issn }

    journal['Title'] if journal
  end

  def find_author(doi)
    authors = parse_json(@authors_f)
    result  = []

    authors.each do |a|
      result << a['name'] if a['articles'].include?(doi)
    end

    result
  end

  def parse_json(file_name)
    JSON.parse(File.open("resources/#{file_name}", 'rb').read)
  end

  def parse_csv(file_name)
    CSV.new(File.new("resources/#{file_name}"), :headers => true)
  end
end