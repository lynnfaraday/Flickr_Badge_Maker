require 'rubygems'
require 'flickr_badge_maker'
require 'ap'
require 'yaml'

module FlickrBadgeMaker
  class Client
    def initialize
      @config_path = File.join(Dir.getwd, "flickr_config.yaml")
    end
    
    def read_config
      config = YAML.load_file(@config_path)
      {
        :api_key => config["flickr"]["api_key"],
        :shared_secret => config["flickr"]["shared_secret"],
        :access_token => config["flickr"]["access_token"],
        :css_file => config["flickr"]["access_secret"]
      }
    end

    def configure
      begin

        puts "Enter your flickr API key.  If you don't have one, you can request it at this url:"
        puts "   http://www.flickr.com/services/apps/create/apply"
        print "Key>>"
        api_key = STDIN.gets.strip

        puts "\nNow enter the 'secret' code associated with the API Key."
        print "Secret>> "
        shared_secret = STDIN.gets.strip

        config =
        {
          :api_key => api_key,
          :shared_secret =>  shared_secret,
          :access_token => '',
          :access_secret => ''
        }

        flickr_badge_maker = FlickrBadgeMaker.new(config)
        request_token = flickr_badge_maker.get_request_token()
        auth_url = flickr_badge_maker.get_authorize_url(request_token)

        puts "Open this url in your web browser to complete the authentication process\n   #{auth_url}\n"
        puts "Copy and paste the number given when you complete the process."
        print "Code>> "
        verify_lambda = STDIN.gets.strip

        access = flickr_badge_maker.authenticate(request_token, verify_lambda)
        login = flickr_badge_maker.test_login
        puts "\nSuccessfully authenticated as #{login.username}"

        File.open(@config_path, 'w') {|f|
          f.write( " flickr:\n")
          f.write( "   api_key: #{api_key}\n")
          f.write( "   shared_secret: #{shared_secret}\n")
          f.write( "   access_token: #{access[:access_token]}\n")
          f.write( "   access_secret: #{access[:access_secret]}\n")
        }
        puts "\nConfiguration written to flickr_config.yaml."

      rescue FlickRaw::FailedResponse => e
        puts "Authentication failed : #{e.msg}"
      end
    end

    def get_set_info(set)
      config = read_config
      flickr_badge_maker = FlickrBadgeMaker.new(config)
      ap flickr_badge_maker.get_photos(set)
    end

    def make_badge(set)
      config = read_config
      flickr_badge_maker = FlickrBadgeMaker.new(config)
      photos = flickr_badge_maker.get_photos(set)
      photos.each { |p|

        puts "<ul>"
        puts "<li><a href=\"#{p[:view_url]}\"><img src=\"#{p[:thumb_image_url]}\"/></a>"
        puts "<br/>#{p[:caption]}"
        puts "</ul>"

      }
    end
  end
end

