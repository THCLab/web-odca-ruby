require 'csv'
require 'roo'
require 'roo-xls'
require 'odca'
require 'tmpdir'
require 'securerandom'

require 'zip_file_generator'

module Services
  class InputFileService
    def call(filename, filetype, file, credential_layout_file, form_layout_file)
      `mv #{file.path} /tmp/#{filename}.#{filetype}`
      cmd = "./parser.bin parse oca -p /tmp/#{filename}.#{filetype} --zip"
      if !credential_layout_file.nil?
        cmd += " --credential-layout #{credential_layout_file.path}"
      end
      if !form_layout_file.nil?
        cmd += " --form-layout #{form_layout_file.path}"
      end
      `#{cmd}`
      uuid = SecureRandom.hex(16)
      `mv ./#{filename}.zip ./public/#{uuid}.zip`

      "#{uuid}.zip"
    end

    private def parse_file(file)
      file_ext = File.extname(file.path)
      if file_ext == '.csv'
        CSV.read(file, col_sep: ';', encoding: 'ISO8859-1:utf-8')
      elsif file_ext == '.xlsx'
        xlsx = Roo::Excelx.new(file)
        CSV.parse(xlsx.to_csv, col_sep: ',')
      elsif file_ext == '.xls'
        xls = Roo::Excel.new(file)
        CSV.parse(xls.to_csv, col_sep: ',')
      end
    end
  end
end
