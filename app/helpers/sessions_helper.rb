module SessionsHelper
  require 'poke-api'

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
  def store_inventory(client, user)
    call = get_call(client, :get_inventory)
    while call.response == nil
      logger.debug "GET_INVENTORY yielded nil response...Calling again"
      call = get_call(client, :get_inventory)
    end
    response = call.response
    file = File.read('app/assets/pokemon.en.json')
    pokemon_hash = JSON.parse(file)

    begin
      response[:GET_INVENTORY][:inventory_delta][:inventory_items].each do |item|
        item[:inventory_item_data].each do |type, i|
          case type
          when :item 
            if i != nil 
              item_id = i[:item_id]
              count = i[:count]
              user.items.create(item_id: item_id, count: count)
            end
          when :pokemon_data
            if i != nil
              poke_id = i[:pokemon_id].capitalize.to_s
              
              # To deal with Nidoran naming
              poke_id.match('Nidoran_female') ? poke_id = 'Nidoran♀' : nil
              poke_id.match('Nidoran_male') ? poke_id = 'Nidoran♂' : nil
              
              # To deal with MISSINGNO Pokemon
              if pokemon_hash.key(poke_id) != nil
                poke_num = format("%03d", pokemon_hash.key(poke_id))
              else
                poke_num = 000
              end

              move_1 = i[:move_1]
              move_2 = i[:move_2]
              health = i[:stamina_max]
              attack = i[:individual_attack]
              defense = i[:individual_defense]
              stamina = i[:individual_stamina]
              cp = i[:cp]
              iv = ((attack + defense + stamina) / 45.0).round(2)
              user.pokemon.create(:poke_id => poke_id, :poke_num => poke_num, :move_1 => move_1, :move_2 => move_2, :health => health, :attack => attack, :defense => defense, :stamina => stamina, :iv => iv, :cp => cp)
            end
          end
        end
      end
    rescue NoMethodError
      logger.debug "Rescued from store_inventory"
      return false
    end
    # Cleanup error pokemonn
    Pokemon.delete_all("poke_id = 'MISSINGNO'")
    return true
  end

  # get name from logged in client
  def get_name(client)
    call = get_call(client, :get_player)
    begin
    name = call.response[:GET_PLAYER][:player_data][:username].downcase
    rescue NoMethodError
      logger.debug "Rescued from get_name"
      get_name(client)
    end
  end
   
  # Handle login logic
  def setup_client(client)
    #if !params[:user].nil? # PTC LOGIN------------
      # Grab all credentials from form
      username = params[:user][:username]
      pass = params[:user][:password]
      auth = params[:user][:auth]
      client.login(username, pass, auth)
      # Create new user if user is new, otherwise retrieve it
      # Keep requesting until response
      name = get_name(client)
      @user = User.where(:name => name).first_or_create!
    #end
    #else             # GOOGLE LOGIN---------
      #@user = User.from_omniauth(env["omniauth.auth"])
      #google = Poke::API::Auth::GOOGLE.new(@user.name, "password")
      #google.instance_variable_set(:@access_token, @user.access_token)
      #client.instance_variable_set(:@auth, google)
      #client.instance_eval{ fetch_endpoint }
      #debugger
      #name = get_name(client)
      #@user.update_attribute(:name, name)
      #return @user
    #end
  end 

  # get response from call by providing client and request
  def get_call(client, req)
    begin
      client.send req
      call = client.call
    rescue
      logger.debug "Rescued from get_call"
      get_call(client, req)
    end
  end

end
