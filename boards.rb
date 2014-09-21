require "csv"
require "dotenv"
require "trello"

class TrelloBoardCacher
  FILENAME = "./boards.csv"
  HEADERS = ["name", "url"]

  def initialize(username)
    user = Trello::Member.find(username)
    @boards = user.boards
  end

  def run
    CSV.open(FILENAME, "wb", headers: HEADERS, write_headers: true) do |csv|
      @boards.each do |board|
        csv << [board.name, board.url]
      end
    end

    puts "Cached #{@boards.count} boards"
  end
end

home_directory = File.expand_path('~/')
Dir.chdir(home_directory) { Dotenv.load }

Trello.configure do |config|
  config.developer_public_key = ENV.fetch("TRELLO_DEVELOPER_KEY")
  config.member_token = ENV.fetch("TRELLO_TOKEN")
end

username = ENV.fetch("TRELLO_USERNAME")
TrelloBoardCacher.new(username).run
