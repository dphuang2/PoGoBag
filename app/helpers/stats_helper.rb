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

  def format_move(move)
    move.slice! '_FAST'
    move = move.split '_'
    move = move.map do |word|
      word.capitalize
    end
    move = move.join(" ")
    return move
  end
    
end
