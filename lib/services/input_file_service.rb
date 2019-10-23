require 'csv'

module Services
  class InputFileService
    def call(file)
      CSV.parse(file, col_sep: ';')
    end
  end
end
