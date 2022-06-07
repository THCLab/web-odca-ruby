require 'roda'
require 'services/input_file_service'
require 'plugins/cors'

class Web < Roda
  plugin :render
  plugin :public
  plugin :cors
  plugin :json

  route do |r|
    r.public

    r.root do
      render('index.html')
    end

    r.post '' do
      files = {}
      name, type = r.params['file'][:filename].split('.')
      files[:root] = { name: name, type: type, file: r.params['file'][:tempfile] }

      referencesFiles = r.params['referencesFiles'] || []
      references = []
      referencesFiles.each do |file|
        name, type = file[:filename].split('.')
        references.push({ name: name, type: type, file: file[:tempfile] })
      end
      files.merge!(references: references)

      credential_layout_file = r.params['credentialLayoutFile']&.fetch(:tempfile)
      form_layout_file = r.params['formLayoutFile']&.fetch(:tempfile)
      zip_filename = Services::InputFileService.new.call(files, credential_layout_file, form_layout_file)

      zip_filename
    end
  end
end
