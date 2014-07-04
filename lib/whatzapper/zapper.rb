require 'sqlite3'
require 'tmpdir'

module Whatzapper
  class Zapper
    
    attr_accessor :path

    def initialize(path)
      @path = Pathname.new path
    end

    def clean_db
      work_in_writable_space do |working_db|
        zap(working_db)
      end
    end

    protected
    def zap(db)
      db = open_db(db)
      open_chats(db) do |message|
        pk, text = message['Z_PK'], message['ZTEXT']
        next unless text =~ /(fi|if)/
        puts "culprit: #{text}"
        clean_message(db, pk, text)
      end
    end

    private
    def open_db(db)
      SQLite3::Database.new(db)
    end

    def open_chats(db)
      db.prepare("select * from ZWAMESSAGE").execute.each_hash do |row|
        yield row
      end
    end

    def work_in_writable_space
      Dir.mktmpdir do |tmp_dir|
        FileUtils.cp self.path.realpath, tmp_dir
        working_db = (Pathname.new(tmp_dir) + self.path.basename).to_s
        yield working_db
        FileUtils.cp working_db, self.path
      end
    end

    def clean_message(db, pk, text)
      cleaned_text = text.sub(/(fi|if|ff)/) do |match|
        "#{match[0]}*"
      end
      puts "cleaned: #{cleaned_text}"
      db.execute("UPDATE ZWAMESSAGE SET ZTEXT = '#{cleaned_text}' WHERE Z_PK = #{pk};")
    end
  end
end