# Whatzapper

Quick gem to sort out the Whatsapp database for text causing crashes on iOS8 Beta 1/2. 
Whatsapp for some reason (would be quite interesting to know why) crashes when receiving certain character strings, if|fi|ff. (http://www.reddit.com/r/iOS8/comments/28e3ub/beta_2_whatsapp_fix/)

DISCLAIMER: Unless you specify a path to Chatstorage.sqlite that's not mounted on your phone you may kill your database. Which if you are trying this would probably already be unusable so much of a muchness. 

## Installation

    $ gem install whatzapper

## Usage

* Install iExplorer from http://www.macroplant.com/iexplorer/
* Mount your WhatsApp/Documents directory
* bundle exec whatzapper </full_path_to_/ChatStorage.sqlite> 

## Contributing

1. Fork it ( https://github.com/[my-github-username]/whatzapper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
