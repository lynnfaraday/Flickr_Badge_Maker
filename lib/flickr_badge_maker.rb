require 'flickr_badge_maker/maker'
require 'flickr_badge_maker/client'

module FlickrBadgeMaker
  def self.get_photos(set_id)
    maker.get_photos(set_id)
  end

  def self.get_request_token()
    maker.get_request_token
  end
  
  def self.get_authorize_url(request_token)
    maker.get_authorize_url(request_token)
  end
  
  def self.authenticate(request_token, verify_lambda)
    maker.authenticate(request_token, verify_lambda)
  end
  
  def self.test_login
    maker.test_login
  end
  
  def self.preview_image_url(photo)
    photo[maker.config['preview_field']]
  end

  def self.enlarge_image_url(photo)
    photo[maker.config['enlarge_field']]
  end
  
  def self.get_display_info(photos)
    maker.get_display_info(photos)
  end
  
  private

  def self.maker
    config_path = File.join(Dir.getwd, "flickr_config.yaml")
    config = YAML.load_file(config_path)
    Maker.new(config)
  end
    
end
