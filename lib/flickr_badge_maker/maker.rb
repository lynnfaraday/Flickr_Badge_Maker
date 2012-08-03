require 'flickraw'

module FlickrBadgeMaker
  class Maker
    attr_reader :config
    
    def initialize(config)
      @config = config
      @api_key = config['api_key']
      @shared_secret = config['shared_secret']
      @access_token = config['access_token']
      @access_secret = config['access_secret']

      FlickRaw.api_key=@api_key
      FlickRaw.shared_secret=@shared_secret
      flickr.access_token = @access_token
      flickr.access_secret = @access_secret
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
