require 'roda'
require 'services/input_file_service'

class Web < Roda
  plugin :render

  route do |r|
    r.root do
      render('index.html')
    end

    r.is '' do
      r.post do
        file = r.params['file'][:tempfile]
        Services::InputFileService.new.call(file)
      end
    end
  end
end
