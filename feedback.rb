require "csv"
require "rexml/document"

class Feedback
  FILENAME = "boards.csv"

  def initialize(query)
    @query = query
  end

  def response
    REXML::Document.new.tap do |doc|
      items = doc.add_element "items"

      boards.each do |board|
        item = items.add_element "item"
        item.add_attribute "arg", board["url"]
        item.add_element("title").add_text board["name"]
      end
    end
  end

  private

  def boards
    CSV.foreach(FILENAME, headers: true).select do |board|
      board["name"].downcase.include? @query.downcase
    end
  end
end

puts Feedback.new(ARGV[0]).response
