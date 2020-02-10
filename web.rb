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
      file = r.params['file'][:tempfile]
      zip_filename = Services::InputFileService.new.call(file)

      zip_filename
    end
  end
end
