require 'rubygems'
require 'flickr_badge_maker'
require 'yaml'
require 'ap'

module FlickrBadgeMaker
  class Client

    def initialize
      read_config
      @maker = Maker.new(@config)
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

        @config['api_key'] = api_key
        @config['shared_secret'] = shared_secret

        @maker.configure(@config)
        
        request_token = @maker.get_request_token
        auth_url = @maker.get_authorize_url(request_token)

        puts "Open this url in your web browser to complete the authentication process\n   #{auth_url}\n"
        puts "Copy and paste the number given when you complete the process."
        print "Code>> "
        verify_lambda = STDIN.gets.strip

        access = @maker.authenticate(request_token, verify_lambda)
        login = @maker.test_login
        puts "\nSuccessfully authenticated as #{login.username}"

        @config['access_token'] = access[:access_token]
        @config['access_secret'] = access[:access_secret]

        write_config
      rescue FlickRaw::FailedResponse => e
        puts "Authentication failed : #{e.msg}"
      end
    end

    def get_set_info(set)
      ap @maker.get_photos(set)
    end

    def get_badge_yaml(set)
      photos = @maker.get_photos(set)
      display_info = get_display_info(photos)
      print YAML.dump(display_info)
    end

    def make_badge(set)
      photos = @maker.get_photos(set)
      photos = get_display_info(photos)
      puts "<ul>"
      photos.each do |p|
        puts "<li><a href=\"#{p['enlarge_image_url']}\"><img src=\"#{p['preview_image_url']}\"/></a>"
        puts "<br/><a href=\"#{p['view_url']}\">#{p['caption']}</a>"
      end
      puts "</ul>"
    end 
    
    private 
    
    def read_config
      @config_path = File.join(Dir.home, ".flickr_config")
      if (File.exists?(@config_path))
        @config = YAML.load_file(@config_path)
      else
        @config = 
        {
          'api_key'         => '',
          'shared_secret'   => '',
          'access_token'    => '',
          'access_secret'   => '',
          'display'         =>
          {
            'enlarge_image_url' => 'med_image_url',
            'preview_image_url' => 'small_image_url',
            'view_url'          => 'view_url',
            'caption'           => 'caption'
          }
        }
        write_config
      end
    end   
    
    def write_config
      puts "Creating config file in #{@config_path}."
      puts @config.inspect
      File.open(@config_path, 'w') {|f| f.write(YAML.dump(@config)) }
    end
    
    def get_display_info(photos)
      display_mapping = @config['display']
      display_photos = []
      photos.each do |photo| 
        display_info = {}
        display_mapping.keys.each do |key|
          display_info[key] = photo[display_mapping[key]]
        end
        display_photos << display_info
      end
      display_photos
    end
    
  end
end
