require 'sqlite3'
require 'tmpdir'
require 'pathname'

module Whatzapper
  class Zapper

    WTFS = /(fi|if|ff|fl|lf|🇩🇪|🇫🇷|🇺🇸)/i
    
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
    def zap(path)
      open_db(path) do |db|
        open_chats(db) do |message|
          pk, text = message['Z_PK'], message['ZTEXT']
          puts "reading #{text}"
          next unless text =~ WTFS
          puts "culprit: #{text}"
          clean_message(db, pk, text)
        end
      end
    end

    private
    def open_db(path)
      SQLite3::Database.new(path) do |db|
        puts "Database.readonly? #{db.readonly?}"
        yield db
        puts "Total Changed: #{db.total_changes}"
      end
    end

    def open_chats(db)
      stmnt = db.prepare("select * from ZWAMESSAGE")
        stmnt.execute.each_hash do |row|
          yield row
        end
      stmnt.close
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
      cleaned_text = text.sub(WTFS) do |match|
        "#{match[0]}*"
      end
      puts "cleaned: #{cleaned_text}"
      puts db.execute("UPDATE ZWAMESSAGE SET ZTEXT = ? WHERE Z_PK = ?;", cleaned_text, pk)
    end
  end
end