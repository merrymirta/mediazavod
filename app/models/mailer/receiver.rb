module Mailer
  class Receiver < ActionMailer::Base
    cattr_accessor :section

    def receive(mail)
      mail.attachments.each do |file|
        store_path = File.join(Rails.configuration.idfix.parser_folder, "new", file.original_filename)
        
        File.open(store_path, "w+") do |f|
          f.write(file.read)
        end
      end
    end
  end
end