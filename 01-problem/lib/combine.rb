require 'json'
require 'csv'

class Combine
  def initialize(format = 'json', *input_files)
    @format      = format
    @input_files = input_files
  end

  def combine
    return 'Error, at least one input file needed' if @input_files.empty?
    open_files
    raise @files[:articles].inspect
  end

  private

  def open_files
    @files ||= {}
    @input_files.each do |f|
      file_name, file_type = f.split('.')

      result = if file_type == 'json'
        parse_json(f)
      elsif file_type == 'csv'
        parse_csv(f)
      end

      @files[file_name.to_sym] = result
    end
    @files
  end

  def parse_json(file_name)
    file = File.open("resources/#{file_name}", 'rb').read
    JSON.parse(file)
  end

  def parse_csv(file_name)
    # ugh this is horrible
    file    = CSV.read("resources/#{file_name}")
    headers = file[0]
    body    = file[1,file.length]

    body.each do |row|
      row.map.with_index do |r,i|
        i
      end
    end
  end
end