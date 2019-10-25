require 'csv'
require 'odca'
require 'tmpdir'
require 'securerandom'

require 'zip_file_generator'

module Services
  class InputFileService
    def call(file)
      records = CSV.read(file, col_sep: ';')
      uuid = SecureRandom.hex(16)
      odca_dir = File.join(Dir.tmpdir, uuid)
      Odca::Parser.new(records, odca_dir).call

      output_filename = uuid + '.zip'
      output_file = File.join('public', output_filename)
      ZipFileGenerator.new(odca_dir, output_file).write

      output_filename
    end
  end
end
