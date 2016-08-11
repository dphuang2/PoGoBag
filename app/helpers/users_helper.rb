module UsersHelper

  def user_link
    user_path(current_user.name)
  end

  def pokemon_image(number)
    number = format("%03d", number)
    image = image_list.detect { |i| i.match(%r{^#{number}}) }
    image_tag("pokemon/#{image}")
  end

  def image_list
    # a little caching when we're rendering a lot of these
    @image_list ||= Dir.entries('app/assets/images/pokemon').grep(%r{^\d})
  end
end
