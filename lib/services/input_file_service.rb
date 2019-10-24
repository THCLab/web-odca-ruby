require 'csv'
require 'odca'

module Services
  class InputFileService
    def call(file)
      records = CSV.read(file, col_sep: ';')
      Odca::Parser.new(records, 'output').call
    end
  end
end
