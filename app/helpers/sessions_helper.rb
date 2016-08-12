module SessionsHelper
  require 'poke-api'
  require 'pp'

  def current_user
    if (name = session[:pogo_alias])
      @current_user ||= User.find_by(name: name)
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:pogo_alias)
    session.delete(:user)
    @user = nil
  end

  # Reset database
  def destroy_user_data(user)
    user.pokemon.where(user_id: user.id).delete_all
    user.items.where(user_id: user.id).delete_all
  end

  # Parse through all data and store into database
  def store_data(client, user)
    destroy_user_data(user)
    call = get_call(client, :get_inventory)
    while call.response[:status_code] != 1
      call = get_call(client, :get_inventory)
    end
    response = call.response
    file = File.read('app/assets/pokemon.en.json')
    pokemon_hash = JSON.parse(file)

    #begin
    response[:GET_INVENTORY][:inventory_delta][:inventory_items].each do |item|
      item[:inventory_item_data].each do |type, i|
        if i != nil
          case type
          when :player_stats
            user.level = i[:level]
            user.experience = i[:experience]
            user.prev_level_xp = i[:prev_level_xp]
            user.next_level_xp = i[:next_level_xp]
            user.pokemons_encountered = i[:pokemons_encountered]
            user.km_walked = i[:km_walked]
            user.pokemons_captured = i[:pokemons_captured]
            user.poke_stop_visits = i[:poke_stop_visits]
            user.pokeballs_thrown = i[:pokeballs_thrown]
            user.battle_attack_won = i[:battle_attack_won]
            user.battle_attack_total = i[:battle_attack_total]
            user.battle_defended_won = i[:battle_defended_won]
            user.prestige_rasied_total = i[:prestige_rasied_total]
            user.prestige_dropped_total = i[:prestige_dropped_total]
            user.eggs_hatched = i[:eggs_hatched]
            user.unique_pokedex_entries = i[:unique_pokedex_entries]
            user.evolutions = i[:evolutions]
            user.save
          when :item
            item_id = i[:item_id]
            count = i[:count]
            user.items.create(item_id: item_id, count: count)
          when :pokemon_data
            # Set poke_id
            poke_id = i[:pokemon_id].capitalize.to_s
            # To deal with Nidoran and Mr. Mime naming
            poke_id = 'Nidoran♀' if poke_id.match('Nidoran_female')
            poke_id = 'Nidoran♂' if poke_id.match('Nidoran_male')
            poke_id = 'Mr. Mime' if poke_id.match('Mr_mime')
            poke_id = "Farfetch'd" if poke_id.match('Farfetchd')
            # To deal with MISSINGNO Pokemon
            if pokemon_hash.key(poke_id) != nil
              poke_num = pokemon_hash.key(poke_id)
            else
              poke_num = "0"
            end
            # Instantiate pokemon
            pokemon = user.pokemon.new
            # Set data
            pokemon.poke_id = poke_id
            pokemon.poke_num = poke_num
            pokemon.creation_time_ms = i[:creation_time_ms]
            pokemon.move_1 = i[:move_1]
            pokemon.move_2 = i[:move_2]
            pokemon.health = i[:stamina]
            pokemon.max_health = i[:stamina_max]
            pokemon.attack = i[:individual_attack]
            pokemon.defense = i[:individual_defense]
            pokemon.stamina = i[:individual_stamina]
            pokemon.cp = i[:cp]
            pokemon.iv = ((pokemon.attack + pokemon.defense + pokemon.stamina) / 45.0).round(3)
            pokemon.nickname = i[:nickname]
            pokemon.favorite = i[:favorite]
            pokemon.num_upgrades = i[:num_upgrades]
            pokemon.battles_attacked = i[:battles_attacked]
            pokemon.battles_defended = i[:battles_defended]
            pokemon.pokeball = i[:pokeball]
            pokemon.height_m = i[:height_m]
            pokemon.weight_kg = i[:weight_kg]
            # Save record
            pokemon.save
          #when :pokemon_family
            #poke_id = i[:family_id].to_s
            #poke_id.slice! 'FAMILY_'
            #poke_id = poke_id.capitalize.to_s
            #candy = i[:candy]

            ## Instantiate pokemon
            #pokemon = user.pokemon.where(:poke_id => poke_id).first_or_create!
            #pokemon.candy = candy
            #pokemon.save
          end
        end
      end
    end
    # Cleanup error pokemonn (Actually eggs)
    Pokemon.where(poke_id: "Missingno").delete_all
    return true
  end

  # get name from logged in client
  def get_player_info(client)
    call = get_call(client, :get_player)
    while call.response[:status_code] != 1
      call = get_call(client, :get_player)
    end
    info = Hash.new
    response = call.response
    info[:name] = response[:GET_PLAYER][:player_data][:username]
    info[:team] = response[:GET_PLAYER][:player_data][:team]
    info[:max_pokemon_storage] = response[:GET_PLAYER][:player_data][:max_pokemon_storage]
    info[:max_item_storage] = response[:GET_PLAYER][:player_data][:max_item_storage]
    info[:POKECOIN] = response[:GET_PLAYER][:player_data][:currencies][0][:amount]
    info[:STARDUST] = response[:GET_PLAYER][:player_data][:currencies][1][:amount]
    return info
  end

  # Handle login logic
  def setup_user
    if params.has_key? :ptc # PTC LOGIN------------
      client = Poke::API::Client.new
      # Grab all credentials from form
      username = params[:ptc][:username]
      pass = params[:ptc][:password]
      client.login(username, pass, 'ptc')
    end
    if params.has_key? :google # GOOGLE LOGIN---------
      response =  authorized_client params[:google][:code]
      client = response[:client]
      refresh_token = response[:refresh_token]
    end
    if defined? refresh_token
      @user = setup_client_user_pair(client, refresh_token)
    else
      @user = setup_client_user_pair(client)
    end
    return {:user => @user, :client => client}
  end

  def setup_client_user_pair(client, refresh_token = nil)
    info = get_player_info(client)
    screen_name = info[:name]
    name = screen_name.downcase
    @user = User.where(:name => name).first_or_create!
    @user.screen_name = screen_name
    @user.team = info[:team]
    @user.max_pokemon_storage = info[:max_pokemon_storage]
    @user.max_item_storage = info[:max_item_storage]
    @user.POKECOIN = info[:POKECOIN]
    @user.STARDUST = info[:STARDUST]
    @user.last_data_update = Time.now.to_s
    if !refresh_token.nil?
      time = Time.now + 3600
      time = time.to_i
      @user.access_token_expire_time = time
      @user.refresh_token = refresh_token
    end
    @user.save
    return @user
  end

  def refresh_data(user)
    auth_objects = authorized_client(user.refresh_token, 'refresh_token')
    client = auth_objects[:client]
    user = setup_client_user_pair(client, user.refresh_token)
    store_data(client, user)
  end

  def authorized_client(token, type = 'authorization_code')
      clnt = HTTPClient.new
      body = {
        grant_type: type,
        redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
        scope: 'openid email https://www.googleapis.com/auth/userinfo.email',
        client_secret: 'NCjF1TLi2CcY6t5mt0ZveuL7',
        client_id: '848232511240-73ri3t7plvk96pj4f85uj8otdat2alem.apps.googleusercontent.com',
      }
      if type == 'authorization_code'
        body[:code] = token
      end
      if type =='refresh_token'
        body[:refresh_token] = token
      end
      uri = 'https://accounts.google.com/o/oauth2/token'
      response = clnt.post(uri, body)
      body = response.body
      hash = JSON.parse body
      access_token = hash["id_token"]
      refresh_token = hash["refresh_token"]
      client = Poke::API::Client.new
      google = Poke::API::Auth::GOOGLE.new("username", "password")
      google.instance_variable_set(:@access_token, access_token)
      client.instance_variable_set(:@auth, google)
      return {:client => client, :refresh_token => refresh_token}
  end


  # get response from call by providing client and request
  def get_call(client, req)
    client.send req
    call = client.call
  end

end
