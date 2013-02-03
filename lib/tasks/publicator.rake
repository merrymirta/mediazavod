require "rubygems"

def save_to_yml(file_name, object)
  File.open(file_name, "w+") do |f|
    f << YAML.dump(object)
  end
end

def sort_by_placement(file_list)
  file_list.sort{|a,b| 
    [
      File.basename(File.dirname(a)).to_i,
      File.basename(a).gsub(/[^\d]/, "").to_i
    ] <=> [
      File.basename(File.dirname(b)).to_i,
      File.basename(b).gsub(/[^\d]/, "").to_i
    ]
  }.reverse
end

namespace :publicator do
  desc "Подготовка к работе"
  task :prepare => :environment do
    OPTIONS = {
      :new_path         => File.join(Rails.configuration.idfix.parser_folder, "new"),
      :archive_path     => File.join(Rails.configuration.idfix.parser_folder, "archive"),
      :parsed_path      => File.join(Rails.configuration.idfix.parser_folder, "parsed"),
      :section          => "rabochy",
      :author           => Rails.production? ? 7 : 1,
      :archive_password => "thundersinsummer"
    }
  end

  desc "Парсит материалы из папки для публикации и складывает их в YML"
  task :parse => "publicator:prepare" do
    ActiveRecord::Base.transaction do
      @author   = User.find_or_create_by_remote_id(OPTIONS[:author])
      raise "Автор не найден" if @author.nil?

      @sections = Dir[File.join(OPTIONS[:new_path], "*")].collect{|s| File.basename(s)}

      @sections.each do |section|
        @section = Section.find_by_alias(section)
        raise "Раздел #{section} не найден" if @section.nil?

        Dir[File.join(OPTIONS[:new_path], section, "*.{rar,RAR}")].each do |archive|
          folder = archive.gsub(/\.rar$/i, "")

          # Создаем папку и копируем в нее архив
          FileUtils.remove_dir(folder) if File.directory?(folder)
          FileUtils.mkdir(folder)
          FileUtils.copy(archive, File.join(folder, File.basename(archive)))

          # Запускаем распаковку архива
          system("cd #{folder}; unrar x -u -p#{OPTIONS[:archive_password]} #{File.basename(archive)} ")

          publication_time  = DateTime.strptime(File.basename(folder), '%d-%m-%y')

          # Обрабатываем инфоблоки
          sort_by_placement(Dir[File.join(folder, "**", "{shorty,SHORTY}.{doc,DOC}")]).each_with_index do |document, place|
            puts "Parsing file #{document}..."

            text = Iconv.iconv("UTF-8", "CP866", File.read(document)).to_s.strip

            text.split(/\r\n\r\n\r\n/).each_with_index do |shorty, index|
              @shorty = @section.shorties.build(:author_id => @author.id)

              @shorty.name, @shorty.text = shorty.split(/\r\n(?:\s+)?\r\n/)
              @shorty.publicated_at = publication_time + place.minutes + index.seconds
              @shorty.publicate_at_homepage = false
              @shorty.publicate_in_general_digest = false
              @shorty.publicate_in_section_list = false

              @shorty.save!
              @shorty.publicate!

              puts "Publicated shorty #{index + 1} from #{ document } at #{ @shorty.publicated_at }"
            end

            FileUtils.remove_file(document)
          end

          # Обрабатываем статьи
          sort_by_placement(Dir[File.join(folder, "**", "{a,A,id,ID}*.{doc,DOC}")]).each_with_index do |document, index|
            puts "Parsing file #{document}..."

            text = Iconv.iconv("UTF-8", "CP866", File.read(document)).to_s.strip
            paragraphs = text.split(/\r\n\r\n/)

            @article = @section.articles.build(:author_id => @author.id)

            @article.name = paragraphs.shift
            @article.publicated_at = publication_time + index.minutes
            @article.publicate_in_general_digest = false
            @article.publicate_in_general_list = false

            @article.article_content.text = paragraphs.join("\n\n")
            @article.article_content.format_imported_text

            @article.excerpt = @article.article_content.text.split(/\./)[0, 5].join(".") + "."

            @article.save!
            @article.publicate!

            puts "Publicated article from #{ document } at #{ @article.publicated_at }"

            picture_file = document.gsub(/\.doc$/, ".jpg")

            if File.exist?(picture_file)
              puts "Importing picture #{picture_file}"

              @picture = @article.pictures.build

              @picture.image = File.open(picture_file)

              @picture.save!

              FileUtils.remove_file(picture_file)
            end

            FileUtils.remove_file(document)
          end

          puts "Successfully parsed!"

          FileUtils.mv(
            archive,
            File.join(OPTIONS[:archive_path], section, File.basename(archive))
          )

          FileUtils.remove_dir(folder)
        end
      end
    end
  end

  desc "Принимает файлы из почтового ящика и складывает их в папку для публикации"
  task :receive => :environment do
    RECEIVER_OPTIONS = {
      :address      => "pop.gmail.com",
      :port         => "995",
      :login        => "chr@buyreal.ru",
      :password     => "a13512",
      :tunnel_port  => 15199,
      :header       => /chelrab/,
    }

    puts "Создаем SSL туннель"

    config = File.join(RAILS_ROOT, "tmp", "stunnel_config")

    File.open(config, "w+") do |f|
      f.puts <<-CODE
        [gmail]
        client = yes
        accept = #{RECEIVER_OPTIONS[:tunnel_port]}
        connect = #{RECEIVER_OPTIONS[:address]}:#{RECEIVER_OPTIONS[:port]}
        delay = yes
      CODE
    end

    system("stunnel #{config}")

    puts "Подключаемся к почтовому ящику"

    require "net/pop"

    Net::POP3.start('localhost', RECEIVER_OPTIONS[:tunnel_port], RECEIVER_OPTIONS[:login], RECEIVER_OPTIONS[:password]) do |pop|
      if pop.mails.empty?
        puts 'No mail.'
      else
        pop.mails.each_with_index do |mail, index|
          puts "Получаем письмо #{index + 1} из #{pop.mails.size}"

          if mail.header =~ RECEIVER_OPTIONS[:header]
            Mailer::Receiver.receive(mail.pop)
          end
        end
      end
    end
  end
end