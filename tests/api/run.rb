require 'pp'
require 'pry'

class RequestReader
  def initialize(path)
    @path = path
  end

  def verb
    lines.first.split(/\s+/).first
  end

  def uri
    lines.first.split(/\s+/).last
  end

  def headers
    parts.first[1..-1].map do |line|
      line.strip.split(/:\s+/)
    end.to_h
  end

  def body
    parts.last[1..-1].join
  end

  private

  attr_reader :path

  def parts
    lines.slice_before(/\A\s+\z/).to_a
  end

  def lines
    @lines ||= File.readlines(path)
  end

  def first_line
    lines.first
  end
end

req = RequestReader.new('./steps/03_create_player')
