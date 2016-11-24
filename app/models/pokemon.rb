class Pokemon < ApplicationRecord
  belongs_to :user, dependent: :destroy
  validates :poke_id, presence: true
  validates :move_1, presence: true
  validates :move_2, presence: true
  validates :max_health, presence: true
  validates :attack, presence: true
  validates :defense, presence: true
  validates :stamina, presence: true
  validates :cp, presence: true
  validates :iv, presence: true
  validates :favorite, presence: true
  validates :num_upgrades, presence: true
  validates :battles_attacked, presence: true
  validates :battles_defended, presence: true
  validates :pokeball, presence: true
  validates :height_m, presence: true
  validates :weight_kg, presence: true
  validates :health, presence: true
  validates :poke_num, presence: true
  validates :creation_time_ms, presence: true

  def self.evaluate_type(type)
    puts type
    pokemon = Pokemon.where(poke_id: type).order(:cp)
    max_level = pokemon.length > 0 ? pokemon.first.user.level + 1.5 : 0
    pokemon.map {|p| [p.cp, p.levels(max_level)]}.each {|ll| puts ll[0]; puts ll[1]}
    nil
  end

  def self.cheapest_to_cp(reach_cp = 2500)
    to_reach = Pokemon.all.select {|p| p.cost_to_cp(reach_cp)}.sort_by {|p| p.cost_to_cp(reach_cp)[2]}
    to_reach.each do |p|
      puts "#{p.poke_id} (#{p.cp}): #{p.cost_to_cp(reach_cp)}"
    end
    nil
  end

  def as_json(*)
    super.as_json.merge(level: level, max_cp: max_cp, candy_to_max_cp: candy_to_max_cp, stardust_to_max_cp: stardust_to_max_cp)
  end

  def powered_up
    return @powered_up if @powered_up
    test_level = user.level+1.5
    candy_investment = Pokemon.power_up_cost[level][:cumulative_candy]
    stardust_investment = Pokemon.power_up_cost[level][:cumulative_stardust]

    cp = Pokemon.compute_cp(test_level, evolved[:stats][0], evolved[:stats][1], evolved[:stats][2])
    candy_cost = evolved[:cost] + Pokemon.power_up_cost[test_level][:cumulative_candy] - candy_investment
    stardust_cost = Pokemon.power_up_cost[test_level][:cumulative_stardust] - stardust_investment
    @powered_up = {level: test_level, cp: cp, candy: candy_cost, stardust: stardust_cost}
  end

  def max_cp
    powered_up[:cp]
  end

  def stardust_to_max_cp
    powered_up[:stardust]
  end

  def candy_to_max_cp
    powered_up[:candy]
  end

  # calculates cost (in candies and stardust) to reach 2500
  def cost_to_cp(reach_cp = 2500)
    level_above_cp = levels.find { |l| l[:cp] >= reach_cp }
    return nil unless level_above_cp
    return [level_above_cp[:level], level_above_cp[:candy], level_above_cp[:stardust]]
  end

  def evolved
    return @evolved if @evolved
    cost = 0
    evolved_poke_num = poke_num
    while evolve_cost = Pokemon.base_stats[evolved_poke_num][3] do
      cost += evolve_cost
      evolved_poke_num += 1
    end
    total_stats = Pokemon.base_stats[evolved_poke_num][0..2]
    total_stats[0] += attack
    total_stats[1] += defense
    total_stats[2] += stamina
    @evolved = {
      stats: total_stats,
      cost: cost
    }
  end

  def level
    return @level if @level
    rhs = (Pokemon.base_stats[poke_num][0] + attack) *
          (Pokemon.base_stats[poke_num][1] + defense) ** 0.5 *
          (Pokemon.base_stats[poke_num][2] + stamina) ** 0.5 * 0.1
    cpm = ((cp + 0.5) / rhs) ** 0.5
    # actual formula has floor(), doing the intermediate one
    closest_cpm = Pokemon.cp_multiplier.values.min_by { |x| (x - cpm).abs }
    @level = Pokemon.cp_multiplier.key(closest_cpm)
  end

  # calculates outcomes of evolving and leveling
  def levels(max_level = 40.0)
    candy_investment = Pokemon.power_up_cost[level][:cumulative_candy]
    stardust_investment = Pokemon.power_up_cost[level][:cumulative_stardust]
    max_num_power_ups = (max_level - level) * 2.0

    (0..max_num_power_ups).map do |power_ups|
      test_level = level + power_ups / 2.0
      cp = Pokemon.compute_cp(test_level, evolved[:stats][0], evolved[:stats][1], evolved[:stats][2])
      candy_cost = evolved[:cost] + Pokemon.power_up_cost[test_level][:cumulative_candy] - candy_investment
      stardust_cost = Pokemon.power_up_cost[test_level][:cumulative_stardust] - stardust_investment
      {level: test_level, cp: cp, candy: candy_cost, stardust: stardust_cost}
    end.compact
  end

  def self.compute_cp(level, attack, defense, stamina)
    ((attack * defense ** 0.5 * stamina ** 0.5 * cp_multiplier[level]**2)/10).floor
  end

  def self.power_up_cost
    @@memoized_power_up_cost ||= [
      [1.0, {:candy=>1, :stardust=>200, :cumulative_candy=>0, :cumulative_stardust=>0}],
      [1.5, {:candy=>1, :stardust=>200, :cumulative_candy=>1, :cumulative_stardust=>200}],
      [2.0, {:candy=>1, :stardust=>200, :cumulative_candy=>2, :cumulative_stardust=>400}],
      [2.5, {:candy=>1, :stardust=>200, :cumulative_candy=>3, :cumulative_stardust=>600}],
      [3.0, {:candy=>1, :stardust=>400, :cumulative_candy=>4, :cumulative_stardust=>800}],
      [3.5, {:candy=>1, :stardust=>400, :cumulative_candy=>5, :cumulative_stardust=>1200}],
      [4.0, {:candy=>1, :stardust=>400, :cumulative_candy=>6, :cumulative_stardust=>1600}],
      [4.5, {:candy=>1, :stardust=>400, :cumulative_candy=>7, :cumulative_stardust=>2000}],
      [5.0, {:candy=>1, :stardust=>600, :cumulative_candy=>8, :cumulative_stardust=>2400}],
      [5.5, {:candy=>1, :stardust=>600, :cumulative_candy=>9, :cumulative_stardust=>3000}],
      [6.0, {:candy=>1, :stardust=>600, :cumulative_candy=>10, :cumulative_stardust=>3600}],
      [6.5, {:candy=>1, :stardust=>600, :cumulative_candy=>11, :cumulative_stardust=>4200}],
      [7.0, {:candy=>1, :stardust=>800, :cumulative_candy=>12, :cumulative_stardust=>4800}],
      [7.5, {:candy=>1, :stardust=>800, :cumulative_candy=>13, :cumulative_stardust=>5600}],
      [8.0, {:candy=>1, :stardust=>800, :cumulative_candy=>14, :cumulative_stardust=>6400}],
      [8.5, {:candy=>1, :stardust=>800, :cumulative_candy=>15, :cumulative_stardust=>7200}],
      [9.0, {:candy=>1, :stardust=>1000, :cumulative_candy=>16, :cumulative_stardust=>8000}],
      [9.5, {:candy=>1, :stardust=>1000, :cumulative_candy=>17, :cumulative_stardust=>9000}],
      [10.0, {:candy=>1, :stardust=>1000, :cumulative_candy=>18, :cumulative_stardust=>10000}],
      [10.5, {:candy=>1, :stardust=>1000, :cumulative_candy=>19, :cumulative_stardust=>11000}],
      [11.0, {:candy=>2, :stardust=>1300, :cumulative_candy=>20, :cumulative_stardust=>12000}],
      [11.5, {:candy=>2, :stardust=>1300, :cumulative_candy=>22, :cumulative_stardust=>13300}],
      [12.0, {:candy=>2, :stardust=>1300, :cumulative_candy=>24, :cumulative_stardust=>14600}],
      [12.5, {:candy=>2, :stardust=>1300, :cumulative_candy=>26, :cumulative_stardust=>15900}],
      [13.0, {:candy=>2, :stardust=>1600, :cumulative_candy=>28, :cumulative_stardust=>17200}],
      [13.5, {:candy=>2, :stardust=>1600, :cumulative_candy=>30, :cumulative_stardust=>18800}],
      [14.0, {:candy=>2, :stardust=>1600, :cumulative_candy=>32, :cumulative_stardust=>20400}],
      [14.5, {:candy=>2, :stardust=>1600, :cumulative_candy=>34, :cumulative_stardust=>22000}],
      [15.0, {:candy=>2, :stardust=>1900, :cumulative_candy=>36, :cumulative_stardust=>23600}],
      [15.5, {:candy=>2, :stardust=>1900, :cumulative_candy=>38, :cumulative_stardust=>25500}],
      [16.0, {:candy=>2, :stardust=>1900, :cumulative_candy=>40, :cumulative_stardust=>27400}],
      [16.5, {:candy=>2, :stardust=>1900, :cumulative_candy=>42, :cumulative_stardust=>29300}],
      [17.0, {:candy=>2, :stardust=>2200, :cumulative_candy=>44, :cumulative_stardust=>31200}],
      [17.5, {:candy=>2, :stardust=>2200, :cumulative_candy=>46, :cumulative_stardust=>33400}],
      [18.0, {:candy=>2, :stardust=>2200, :cumulative_candy=>48, :cumulative_stardust=>35600}],
      [18.5, {:candy=>2, :stardust=>2200, :cumulative_candy=>50, :cumulative_stardust=>37800}],
      [19.0, {:candy=>2, :stardust=>2500, :cumulative_candy=>52, :cumulative_stardust=>40000}],
      [19.5, {:candy=>2, :stardust=>2500, :cumulative_candy=>54, :cumulative_stardust=>42500}],
      [20.0, {:candy=>2, :stardust=>2500, :cumulative_candy=>56, :cumulative_stardust=>45000}],
      [20.5, {:candy=>2, :stardust=>2500, :cumulative_candy=>58, :cumulative_stardust=>47500}],
      [21.0, {:candy=>3, :stardust=>3000, :cumulative_candy=>60, :cumulative_stardust=>50000}],
      [21.5, {:candy=>3, :stardust=>3000, :cumulative_candy=>63, :cumulative_stardust=>53000}],
      [22.0, {:candy=>3, :stardust=>3000, :cumulative_candy=>66, :cumulative_stardust=>56000}],
      [22.5, {:candy=>3, :stardust=>3000, :cumulative_candy=>69, :cumulative_stardust=>59000}],
      [23.0, {:candy=>3, :stardust=>3500, :cumulative_candy=>72, :cumulative_stardust=>62000}],
      [23.5, {:candy=>3, :stardust=>3500, :cumulative_candy=>75, :cumulative_stardust=>65500}],
      [24.0, {:candy=>3, :stardust=>3500, :cumulative_candy=>78, :cumulative_stardust=>69000}],
      [24.5, {:candy=>3, :stardust=>3500, :cumulative_candy=>81, :cumulative_stardust=>72500}],
      [25.0, {:candy=>3, :stardust=>4000, :cumulative_candy=>84, :cumulative_stardust=>76000}],
      [25.5, {:candy=>3, :stardust=>4000, :cumulative_candy=>87, :cumulative_stardust=>80000}],
      [26.0, {:candy=>4, :stardust=>4000, :cumulative_candy=>90, :cumulative_stardust=>84000}],
      [26.5, {:candy=>4, :stardust=>4000, :cumulative_candy=>94, :cumulative_stardust=>88000}],
      [27.0, {:candy=>4, :stardust=>4500, :cumulative_candy=>98, :cumulative_stardust=>92000}],
      [27.5, {:candy=>4, :stardust=>4500, :cumulative_candy=>102, :cumulative_stardust=>96500}],
      [28.0, {:candy=>4, :stardust=>4500, :cumulative_candy=>106, :cumulative_stardust=>101000}],
      [28.5, {:candy=>4, :stardust=>4500, :cumulative_candy=>110, :cumulative_stardust=>105500}],
      [29.0, {:candy=>4, :stardust=>5000, :cumulative_candy=>114, :cumulative_stardust=>110000}],
      [29.5, {:candy=>4, :stardust=>5000, :cumulative_candy=>118, :cumulative_stardust=>115000}],
      [30.0, {:candy=>4, :stardust=>5000, :cumulative_candy=>122, :cumulative_stardust=>120000}],
      [30.5, {:candy=>4, :stardust=>5000, :cumulative_candy=>126, :cumulative_stardust=>125000}],
      [31.0, {:candy=>6, :stardust=>6000, :cumulative_candy=>130, :cumulative_stardust=>130000}],
      [31.5, {:candy=>6, :stardust=>6000, :cumulative_candy=>136, :cumulative_stardust=>136000}],
      [32.0, {:candy=>6, :stardust=>6000, :cumulative_candy=>142, :cumulative_stardust=>142000}],
      [32.5, {:candy=>6, :stardust=>6000, :cumulative_candy=>148, :cumulative_stardust=>148000}],
      [33.0, {:candy=>8, :stardust=>7000, :cumulative_candy=>154, :cumulative_stardust=>154000}],
      [33.5, {:candy=>8, :stardust=>7000, :cumulative_candy=>162, :cumulative_stardust=>161000}],
      [34.0, {:candy=>8, :stardust=>7000, :cumulative_candy=>170, :cumulative_stardust=>168000}],
      [34.5, {:candy=>8, :stardust=>7000, :cumulative_candy=>178, :cumulative_stardust=>175000}],
      [35.0, {:candy=>10, :stardust=>8000, :cumulative_candy=>186, :cumulative_stardust=>182000}],
      [35.5, {:candy=>10, :stardust=>8000, :cumulative_candy=>196, :cumulative_stardust=>190000}],
      [36.0, {:candy=>10, :stardust=>8000, :cumulative_candy=>206, :cumulative_stardust=>198000}],
      [36.5, {:candy=>10, :stardust=>8000, :cumulative_candy=>216, :cumulative_stardust=>206000}],
      [37.0, {:candy=>12, :stardust=>9000, :cumulative_candy=>226, :cumulative_stardust=>214000}],
      [37.5, {:candy=>12, :stardust=>9000, :cumulative_candy=>238, :cumulative_stardust=>223000}],
      [38.0, {:candy=>12, :stardust=>9000, :cumulative_candy=>250, :cumulative_stardust=>232000}],
      [38.5, {:candy=>12, :stardust=>9000, :cumulative_candy=>262, :cumulative_stardust=>241000}],
      [39.0, {:candy=>15, :stardust=>10000, :cumulative_candy=>274, :cumulative_stardust=>250000}],
      [39.5, {:candy=>15, :stardust=>10000, :cumulative_candy=>289, :cumulative_stardust=>260000}],
      [40.0, {:candy=>15, :stardust=>10000, :cumulative_candy=>304, :cumulative_stardust=>270000}],
      [40.5, {:candy=>15, :stardust=>10000, :cumulative_candy=>319, :cumulative_stardust=>280000}]
    ].to_h
  end

  def self.base_stats
    @@memoized_base_stats ||= [
      [1,   [118, 118, 90, 25]],
      [2,   [151, 151, 120, 100]],
      [3,   [198, 198, 160, nil]],
      [4,   [116, 96,  78, 25]],
      [5,   [158, 129, 116, 100]],
      [6,   [223, 176, 156, nil]],
      [7,   [94,  122, 88, 25]],
      [8,   [126, 155, 118, 100]],
      [9,   [171, 210, 158, nil]],
      [10,  [55,  62,  90, 12]],
      [11,  [45,  94,  100, 50]],
      [12,  [167, 151, 120, nil]],
      [13,  [63,  55,  80, 12]],
      [14,  [46,  86,  90, 50]],
      [15,  [169, 150, 130, nil]],
      [16,  [85,  76,  80, 12]],
      [17,  [117, 108, 126, 50]],
      [18,  [166, 157, 166, nil]],
      [19,  [103, 70,  60, 25]],
      [20,  [161, 144, 110, nil]],
      [21,  [112, 61,  80, 50]],
      [22,  [182, 135, 130, nil]],
      [23,  [110, 102, 70, 50]],
      [24,  [167, 158, 120, nil]],
      [25,  [112, 101, 70, 50]],
      [26,  [193, 165, 120, nil]],
      [27,  [126, 145, 100, 50]],
      [28,  [182, 202, 150, nil]],
      [29,  [86,  94,  110, 25]],
      [30,  [117, 126, 140, 100]],
      [31,  [180, 174, 180, nil]],
      [32,  [105, 76,  92, 25]],
      [33,  [137, 112, 122, 100]],
      [34,  [204, 157, 162, nil]],
      [35,  [107, 116, 140, 50]],
      [36,  [178, 171, 190, nil]],
      [37,  [96,  122, 76, 50]],
      [38,  [169, 204, 146, nil]],
      [39,  [80,  44,  230, 50]],
      [40,  [156, 93,  280, nil]],
      [41,  [83,  76,  80, 50]],
      [42,  [161, 153, 150, nil]],
      [43,  [131, 116, 90, 25]],
      [44,  [153, 139, 120, 100]],
      [45,  [202, 170, 150, nil]],
      [46,  [121, 99,  70, 50]],
      [47,  [165, 146, 120, nil]],
      [48,  [100, 102, 120, 50]],
      [49,  [179, 150, 140, nil]],
      [50,  [109, 88,  20, 50]],
      [51,  [167, 147, 70, nil]],
      [52,  [92,  81,  80, 50]],
      [53,  [150, 139, 130, nil]],
      [54,  [122, 96,  100, 50]],
      [55,  [191, 163, 160, nil]],
      [56,  [148, 87,  80, 50]],
      [57,  [207, 144, 130, nil]],
      [58,  [136, 96,  110, 50]],
      [59,  [227, 166, 180, nil]],
      [60,  [101, 82,  80, 25]],
      [61,  [130, 130, 130, 100]],
      [62,  [182, 187, 180, nil]],
      [63,  [195, 103, 50, 25]],
      [64,  [232, 138, 80, 100]],
      [65,  [271, 194, 110, nil]],
      [66,  [137, 88,  140, 25]],
      [67,  [177, 130, 160, 100]],
      [68,  [234, 162, 180, nil]],
      [69,  [139, 64,  100, 25]],
      [70,  [172, 95,  130, 100]],
      [71,  [207, 138, 160, nil]],
      [72,  [97,  182, 80, 50]],
      [73,  [166, 237, 160, nil]],
      [74,  [132, 163, 80, 25]],
      [75,  [164, 196, 110, 100]],
      [76,  [211, 229, 160, nil]],
      [77,  [170, 132, 100, 50]],
      [78,  [207, 167, 130, nil]],
      [79,  [109, 109, 180, 50]],
      [80,  [177, 194, 190, nil]],
      [81,  [165, 128, 50, 50]],
      [82,  [223, 182, 100, nil]],
      [83,  [124, 118, 104, nil]],
      [84,  [158, 88,  70, 50]],
      [85,  [218, 145, 120, nil]],
      [86,  [85,  128, 130, 50]],
      [87,  [139, 184, 180, nil]],
      [88,  [135, 90,  160, 50]],
      [89,  [190, 184, 210, nil]],
      [90,  [116, 168, 60, 50]],
      [91,  [186, 323, 100, nil]],
      [92,  [186, 70,  60, 25]],
      [93,  [223, 112, 90, 100]],
      [94,  [261, 156, 120, nil]],
      [95,  [85,  288, 70, nil]],
      [96,  [89,  158, 120, 50]],
      [97,  [144, 215, 170, nil]],
      [98,  [181, 156, 60, 50]],
      [99,  [240, 214, 110, nil]],
      [100, [109, 114, 80, 50]],
      [101, [173, 179, 120, nil]],
      [102, [107, 140, 120, 50]],
      [103, [233, 158, 190, nil]],
      [104, [90,  165, 100, 50]],
      [105, [144, 200, 120, nil]],
      [106, [224, 211, 100, nil]],
      [107, [193, 212, 100, nil]],
      [108, [108, 137, 180, nil]],
      [109, [119, 164, 80, 50]],
      [110, [174, 221, 130, nil]],
      [111, [140, 157, 160, 50]],
      [112, [222, 206, 210, nil]],
      [113, [60,  176, 500, nil]],
      [114, [183, 205, 130, nil]],
      [115, [181, 165, 210, nil]],
      [116, [129, 125, 60, 50]],
      [117, [187, 182, 110, nil]],
      [118, [123, 115, 90, 50]],
      [119, [175, 154, 160, nil]],
      [120, [137, 112, 60, 50]],
      [121, [210, 184, 120, nil]],
      [122, [192, 233, 80, nil]],
      [123, [218, 170, 140, nil]],
      [124, [223, 182, 130, nil]],
      [125, [198, 173, 130, nil]],
      [126, [206, 169, 130, nil]],
      [127, [238, 197, 130, nil]],
      [128, [198, 197, 150, nil]],
      [129, [29,  102, 40, 400]],
      [130, [237, 197, 190, nil]],
      [131, [186, 190, 260, nil]],
      [132, [91,  91,  96, nil]],
      [133, [104, 121, 110, 25]],
      [134, [205, 177, 260, nil]],
      [135, [232, 201, 130, nil]],
      [136, [246, 204, 130, nil]],
      [137, [153, 139, 130, nil]],
      [138, [155, 174, 70, 50]],
      [139, [207, 227, 140, nil]],
      [140, [148, 162, 60, 50]],
      [141, [220, 203, 120, nil]],
      [142, [221, 164, 160, nil]],
      [143, [190, 190, 320, nil]],
      [144, [192, 249, 180, nil]],
      [145, [253, 188, 180, nil]],
      [146, [251, 184, 180, nil]],
      [147, [119, 94,  82, 25]],
      [148, [163, 138, 122, 100]],
      [149, [263, 201, 182, nil]],
      [150, [330, 200, 212, nil]],
      [151, [210, 210, 200, nil]],
    ].to_h
  end

  def self.cp_multiplier
    @@memoized_cp_multiplier ||= [
      [1.0, 0.094],
      [1.5, 0.135137432],
      [2.0, 0.16639787],
      [2.5, 0.192650919],
      [3.0, 0.21573247],
      [3.5, 0.236572661],
      [4.0, 0.25572005],
      [4.5, 0.273530381],
      [5.0, 0.29024988],
      [5.5, 0.306057377],
      [6.0, 0.3210876],
      [6.5, 0.335445036],
      [7.0, 0.34921268],
      [7.5, 0.362457751],
      [8.0, 0.37523559],
      [8.5, 0.387592406],
      [9.0, 0.39956728],
      [9.5, 0.411193551],
      [10.0, 0.42250001],
      [10.5, 0.432926419],
      [11.0, 0.44310755],
      [11.5, 0.4530599578],
      [12.0, 0.46279839],
      [12.5, 0.472336083],
      [13.0, 0.48168495],
      [13.5, 0.4908558],
      [14.0, 0.49985844],
      [14.5, 0.508701765],
      [15.0, 0.51739395],
      [15.5, 0.525942511],
      [16.0, 0.53435433],
      [16.5, 0.542635767],
      [17.0, 0.55079269],
      [17.5, 0.558830576],
      [18.0, 0.56675452],
      [18.5, 0.574569153],
      [19.0, 0.58227891],
      [19.5, 0.589887917],
      [20.0, 0.59740001],
      [20.5, 0.604818814],
      [21.0, 0.61215729],
      [21.5, 0.619399365],
      [22.0, 0.62656713],
      [22.5, 0.633644533],
      [23.0, 0.64065295],
      [23.5, 0.647576426],
      [24.0, 0.65443563],
      [24.5, 0.661214806],
      [25.0, 0.667934],
      [25.5, 0.674577537],
      [26.0, 0.68116492],
      [26.5, 0.687680648],
      [27.0, 0.69414365],
      [27.5, 0.700538673],
      [28.0, 0.70688421],
      [28.5, 0.713164996],
      [29.0, 0.71939909],
      [29.5, 0.725571552],
      [30.0, 0.7317],
      [30.5, 0.734741009],
      [31.0, 0.73776948],
      [31.5, 0.740785574],
      [32.0, 0.74378943],
      [32.5, 0.746781211],
      [33.0, 0.74976104],
      [33.5, 0.752729087],
      [34.0, 0.75568551],
      [34.5, 0.758630378],
      [35.0, 0.76156384],
      [35.5, 0.764486065],
      [36.0, 0.76739717],
      [36.5, 0.770297266],
      [37.0, 0.7731865],
      [37.5, 0.776064962],
      [38.0, 0.77893275],
      [38.5, 0.781790055],
      [39.0, 0.78463697],
      [39.5, 0.787473578],
      [40.0, 0.79030001],
    ].to_h
  end
end
