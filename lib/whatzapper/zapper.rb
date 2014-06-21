require 'sqlite3'

module Whatzapper
  class Zapper
    
    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def zap
      db = open_db
      open_chats(db) do |message|
        pk, text = message['Z_PK'], message['ZTEXT']
        next unless text =~ /(fi|if)/
        puts "culprit: #{text}"
        clean_message(db, pk, text)
      end
    end

    private
    def open_db
      SQLite3::Database.new(@path)
    end

    def open_chats(db)
      db.prepare("select * from ZWAMESSAGE").execute.each_hash do |row|
        yield row
      end
    end

    def clean_message(db, pk, text)
      cleaned_text = text.sub(/(fi|if)/) do |match|
        "#{match[0]}*"
      end
      puts "cleaned: #{cleaned_text}"
      puts db.execute("UPDATE ZWAMESSAGE SET ZTEXT = '#{cleaned_text}' WHERE Z_PK = #{pk};")
    end
  end
end