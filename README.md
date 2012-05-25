================
FlickrBadgeMaker
================

Flickr Badge Maker helps you make photo gallery "badges" of your [Flickr](http://www.flickr.com) photos, suitable for a blog or other website.

##  Install the GEM

    $ gem install flickr_badge_maker

This will give you access to the API in your own applications and also installs a client program that offers some handy commands.

## Use the client
	
This runs the client program.

### Configuration

   flickr_badge_maker configure

This will walk you through the oauth authentication process interactively.  When it's finished,
you will have a flickr_config.yaml file with all the authentication tokens needed to access your Flickr
account via the application.

### Photo Info

  flickr_badge_maker info set=12345

This outputs the photo information for a given flickr photoset, so you can see what info
you have at your disposal.  For example:

	:squarethumb_image_url => "http://farm4.staticflickr.com/3489/3934003549_2f1908d319_s.jpg",
	      :thumb_image_url => "http://farm4.staticflickr.com/3489/3934003549_2f1908d319_t.jpg",
	      :small_image_url => "http://farm4.staticflickr.com/3489/3934003549_2f1908d319_m.jpg",
	        :med_image_url => "http://farm4.staticflickr.com/3489/3934003549_2f1908d319.jpg",
	      :large_image_url => "http://farm4.staticflickr.com/3489/3934003549_2f1908d319_b.jpg",
	       :orig_image_url => "http://farm4.staticflickr.com/3489/3934003549_fd31b69a05_o.jpg",
	              :caption => "I'm Ready for my Close Up",
	                 :host => "Flickr",
	             :view_url => "http://www.flickr.com/photos/99054757@N00/3934003549"

Note:  Not all sizes are available on all images, depending on how they were uploaded.  If a requested
size is not available, flickr will return the URL of the next bigger size.

### Simple Badge

  flickr_badge_maker badge set=12345

This outputs the HTML for a very simple photo badge, just to show how the script can be used.

## Use the API

Here is an example of how to use the gem's API in your application.

    require 'flickr_badge_maker'
    require 'yaml'

    # Include the config.yaml file in your project and reference it like so.
    # (or you can just hard-code the values)
    config = YAML.load_file("flickr_config.yaml")
      {
          :api_key => config["flickr"]["api_key"],
          :shared_secret => config["flickr"]["shared_secret"],
          :access_token => config["flickr"]["access_token"],
          :css_file => config["flickr"]["access_secret"]
      }

     flickr_badge_maker = FlickrBadgeMaker.new(config)
     photos = flickr_badge_maker.get_photos(ENV['set'])
     photos.each { |p|  puts "<img src=\"#{p[:thumb_image_url]}\"/>" }

# Disclaimers and Such

This code is free for all.  Use it, modify it, whatever you like.

This code is provided AS IS, with no warranty.

This library requires you to get your own Flickr API key, which in turn subjects you to Flickr's rules for its use.  Read [their website](http://www.flickr.com/services/api/tos/) for details.

Thinly wraps the [Flickraw](https://github.com/hanklords/flickraw) API.  Thanks.