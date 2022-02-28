require 'roda'
require 'services/input_file_service'
require 'plugins/cors'

class Web < Roda
  plugin :render
  plugin :public
  plugin :cors

  route do |r|
    r.public

    r.root do
      render('index.html')
    end

    r.post '' do
      filename, filetype = r.params['file'][:filename].split('.')
      file = r.params['file'][:tempfile]
      credential_layout_file = r.params['credentialLayoutFile']&.fetch(:tempfile)
      form_layout_file = r.params['formLayoutFile']&.fetch(:tempfile)
      zip_filename = Services::InputFileService.new.call(filename, filetype, file, credential_layout_file, form_layout_file)

      zip_filename
    end
  end
end
