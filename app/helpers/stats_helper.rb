module StatsHelper
  def rank_image(rank)
    case rank
    when 1
      return image_path "etc/badge_lv3.png"
    when 2
      return image_path "etc/badge_lv2.png"
    when 3
      return image_path "etc/badge_lv1.png"
    end
  end
end
