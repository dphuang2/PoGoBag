module StatsHelper
  def rank_image(rank)
    case rank
    when 1
      return "/assets/etc/badge_lv3.png"
    when 2
      return "/assets/etc/badge_lv2.png"
    when 3
      return "/assets/etc/badge_lv1.png"
    end
  end
end
