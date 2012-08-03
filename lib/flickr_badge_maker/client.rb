require 'rubygems'
require 'flickr_badge_maker'
require 'ap'
require 'yaml'

module FlickrBadgeMaker
  class Client
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
          :api_key       => api_key,
          :shared_secret =>  shared_secret,
          :access_token  => '',
          :access_secret => ''
        }

        request_token = FlickrBadgeMaker.get_request_token
        auth_url = FlickrBadgeMaker.get_authorize_url(request_token)

        puts "Open this url in your web browser to complete the authentication process\n   #{auth_url}\n"
        puts "Copy and paste the number given when you complete the process."
        print "Code>> "
        verify_lambda = STDIN.gets.strip

        access = FlickrBadgeMaker.authenticate(request_token, verify_lambda)
        login = FlickrBadgeMaker.test_login
        puts "\nSuccessfully authenticated as #{login.username}"

        puts "Please add this to your config file:"
        puts "   api_key: #{api_key}"
        puts "   shared_secret: #{shared_secret}"
        puts "   access_token: #{access[:access_token]}"
        puts "   access_secret: #{access[:access_secret]}"

      rescue FlickRaw::FailedResponse => e
        puts "Authentication failed : #{e.msg}"
      end
    end

    def get_set_info(set)
      ap FlickrBadgeMaker.get_photos(set)
    end

    def get_badge_yaml(set)
      photos = FlickrBadgeMaker.get_photos(set)
      display_info = FlickrBadgeMaker.get_display_info(photos)
      print YAML.dump(display_info)
    end

    def make_badge(set)
      photos = FlickrBadgeMaker.get_photos(set)
      photos = FlickrBadgeMaker.get_display_info(photos)
      puts "<ul>"
      photos.each do |p|
        puts "<li><a href=\"#{p['enlarge_image_url']}\"><img src=\"#{p['preview_image_url']}\"/></a>"
        puts "<br/><a href=\"#{p['view_url']}\">#{p['caption']}</a>"
      end
      puts "</ul>"
    end    
  end
end
