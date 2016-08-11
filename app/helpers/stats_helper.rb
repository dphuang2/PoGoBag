module StatsHelper
  def rank_image(rank)
    # TODO: Implement Rank Images
    case rank.to_i
    when 1
      return image_path "etc/badge_lv3.png"
    when 2
      return image_path "etc/badge_lv2.png"
    when 3
      return image_path "etc/badge_lv1.png"
    end
  end

  def format_move(move)
    move = move.to_s
    move.slice! '_FAST'
    move.split('_').map(&:capitalize).join(' ')
  end
end
