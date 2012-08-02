require 'flickr_badge_maker/flickr_badge_maker.rb'
require 'flickr_badge_maker/client.rb'

module FlickerBadgeMaker
  def self.do_something
    maker.do_something
  end

  def self.do_something_else
    maker.do_something
  end

  private

  def self.maker
    config = parse_config
    Maker.new(config)
  end
end
