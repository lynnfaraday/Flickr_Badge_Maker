require 'flickraw'

module FlickrBadgeMaker
  class Maker
    attr_reader :config
    
    def initialize(config)
      configure(config)
    end

    def configure(config)
      @config = config
      begin
        FlickRaw.api_key=config['api_key']
        FlickRaw.shared_secret=config['shared_secret']
        flickr.access_token = config['access_token']
        flickr.access_secret = config['access_secret']
      rescue FlickRaw::FailedResponse => e
          puts "Warning: Unable to initialize flickr library.  Check your configuration."
      end
    end
    
    def get_photos(set_id)
      flickr_photos = flickr.photosets.getPhotos( :photoset_id => set_id )
      build_full_photo_info(flickr_photos)
    end

    def get_request_token()
      flickr.get_request_token
    end

    def get_authorize_url(request_token)
      flickr.get_authorize_url(request_token['oauth_token'], :perms => 'read')
    end

    def authenticate(request_token, verify_lambda)
      flickr.get_access_token(request_token['oauth_token'], request_token['oauth_token_secret'], verify_lambda)
      { 
        :access_token  => flickr.access_token, 
        :access_secret => flickr.access_secret 
      }
    end

    def test_login()
      flickr.test.login
    end
        
    private
    
    
    def build_full_photo_info(flickr_photos)
      gallery_photos = []

      flickr_photos.photo.each do |p|
        info = flickr.photos.getInfo(:photo_id => p.id)

        gallery_photos <<
            {
                'squarethumb_image_url' => FlickRaw.url_s(info),
                'thumb_image_url'       => FlickRaw.url_t(info),
                'small_image_url'       => FlickRaw.url_m(info),
                'med_image_url'         => FlickRaw.url(info),
                'large_image_url'       => FlickRaw.url_b(info),
                'orig_image_url'        => FlickRaw.url_o(info),
                'caption'               => info.title,
                'host'                  => "Flickr",
                'view_url'              => FlickRaw.url_photopage(info)
            }
      end
      gallery_photos
    end
  end
end
