==================
Flickr Badge Maker
==================

Flickr Badge Maker helps you make photo gallery "badges" of your [Flickr](http://www.flickr.com) photos, suitable for a blog or other website.

##  Install the GEM

gem install flickr_badge_maker

This will give you access to the API in your own applications and also installs a client program that offers some handy commands.

## Use the client
	
Run the client application using the **flickr_badge_maker** command.

### Configuration

   flickr_badge_maker configure

This will walk you through the oauth authentication process interactively.  When it's finished, it will update the configuration file and enable you to access your Flickr account via the application.

### Photo Info

  flickr_badge_maker info <set id>

This outputs the photo information for a given flickr photoset, so you can see what info
you have at your disposal.  For example:

    {
	"squarethumb_image_url" => "http://farm4.staticflickr.com/3385/4628377268_f32ebc9369_s.jpg",
	      "thumb_image_url" => "http://farm4.staticflickr.com/3385/4628377268_f32ebc9369_t.jpg",
	      "small_image_url" => "http://farm4.staticflickr.com/3385/4628377268_f32ebc9369_m.jpg",
	        "med_image_url" => "http://farm4.staticflickr.com/3385/4628377268_f32ebc9369.jpg",
	      "large_image_url" => "http://farm4.staticflickr.com/3385/4628377268_f32ebc9369_b.jpg",
	       "orig_image_url" => "http://farm4.staticflickr.com/3385/4628377268_21ac1bd80d_o.jpg",
	              "caption" => "Red Tail Hawk",
	                 "host" => "Flickr",
	             "view_url" => "http://www.flickr.com/photos/99054757@N00/4628377268"
	}

Note:  Not all sizes are available on all images, depending on how they were uploaded.  If a requested
size is not available, flickr will return the URL of the next bigger size.

### YAML Badge Info 

  flickr_badge_maker yaml <set id>

This outputs a YAML style data sample for your set.

	- enlarge_image_url: http://farm4.staticflickr.com/3329/4628377136_3182b160fd.jpg
	  preview_image_url: http://farm4.staticflickr.com/3329/4628377136_3182b160fd_m.jpg
	  view_url: http://www.flickr.com/photos/99054757@N00/4628377136
	  caption: Red Tail Hawk
	- enlarge_image_url: http://farm4.staticflickr.com/3385/4628377268_f32ebc9369.jpg
	  preview_image_url: http://farm4.staticflickr.com/3385/4628377268_f32ebc9369_m.jpg
	  view_url: http://www.flickr.com/photos/99054757@N00/4628377268
	  caption: Red Tail Hawk

### Simple Badge

  flickr_badge_maker badge <set id>

This outputs the HTML for a very simple photo badge, just to show how the script can be used.

	<ul>
	<li><a href="http://farm4.staticflickr.com/3329/4628377136_3182b160fd.jpg"><img src="http://farm4.staticflickr.com/3329/4628377136_3182b160fd_m.jpg"/></a>
	<br/><a href="http://www.flickr.com/photos/99054757@N00/4628377136">Red Tail Hawk</a>
	<li><a href="http://farm4.staticflickr.com/3385/4628377268_f32ebc9369.jpg"><img src="http://farm4.staticflickr.com/3385/4628377268_f32ebc9369_m.jpg"/></a>
	<br/><a href="http://www.flickr.com/photos/99054757@N00/4628377268">Red Tail Hawk</a>
	</ul>

## Use the API

Here is an example of how to use the gem's API in your application.

    require 'flickr_badge_maker'
    require 'yaml'

    # Include the config data in your project and reference it like so.
    # (or you can just hard-code the values)
    config = YAML.load_file("flickr_config.yaml")
      {
          'api_key' => config["flickr"]["api_key"],
          etc.
      }

     flickr_badge_maker = FlickrBadgeMaker::Maker.new(config)
     photos = flickr_badge_maker.get_photos('122')
     photos.each { |p|  puts "<img src=\"#{p[:thumb_image_url]}\"/>" }


## Configuration

The configuration values are stored in the **.flickr_config** file in your home directory.

	api_key: 123
	shared_secret: 456
	access_token: 789
	access_secret: 101
	display:
	    enlarge_image_url: med_image_url
	    preview_image_url: small_image_url
	    view_url: view_url
	    caption: caption

The first four values are set via the configuration command, described in the client section.

The display values allow you to configure which fields are included in the YAML and Badge output.
	
# Disclaimers and Such

This code is free for all.  Use it, modify it, whatever you like.

This code is provided AS IS, with no warranty.

This library requires you to get your own Flickr API key, which in turn subjects you to Flickr's rules for its use.  Read [their website](http://www.flickr.com/services/api/tos/) for details.

Thinly wraps the [Flickraw](https://github.com/hanklords/flickraw) API.  Thanks.
