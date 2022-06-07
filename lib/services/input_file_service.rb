require 'csv'
require 'roo'
require 'roo-xls'
require 'odca'
require 'tmpdir'
require 'securerandom'

require 'zip_file_generator'

module Services
  class InputFileService
    def call(files, credential_layout_file, form_layout_file)
      `mv #{files[:root][:file].path} \"/tmp/#{files[:root][:name]}.#{files[:root][:type]}\"`
      cmd = "./parser.bin parse oca -p \"/tmp/#{files[:root][:name]}.#{files[:root][:type]}\" --zip"
      files[:references].each do |reference|
        `mv #{reference[:file].path} /tmp/#{reference[:name]}.#{reference[:type]}`
        cmd += " -p \"/tmp/#{reference[:name]}.#{reference[:type]}\""
      end
      if !credential_layout_file.nil?
        cmd += " --credential-layout \"#{credential_layout_file.path}\""
      end
      if !form_layout_file.nil?
        cmd += " --form-layout \"#{form_layout_file.path}\""
      end
      result_msg = `#{cmd}`
      return { success: false, error: result_msg } if result_msg.start_with?('Error')
      uuid = SecureRandom.hex(16)
      `mv \"./#{files[:root][:name]}.zip\" ./public/#{uuid}.zip`

      { success: true, filename: "#{uuid}.zip" }
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
