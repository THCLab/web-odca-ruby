require 'roda'
require 'services/input_file_service'

class Web < Roda
  plugin :render
  plugin :public

  route do |r|
    r.public

    r.root do
      render('index.html')
    end

    r.post '' do
      file = r.params['file'][:tempfile]
      zip_filename = Services::InputFileService.new.call(file)

      r.redirect(zip_filename)
    end
  end
end
