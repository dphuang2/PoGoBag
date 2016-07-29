module SessionsHelper

  def current_user
    if (name = session[:pogo_alias])
      @current_user ||= User.find_by(name: name)
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # check if user exists by name (Pokemon Go name are unique_)
  def user_exist?(name)
    if user = User.find_by(name: name)
      user
    else 
      false
    end
  end

  def log_out
    session.delete(:pogo_alias)
    @current_user = nil
  end

  # Parse through all data and store into database
  def store_inventory(client)
    client.get_inventory
    call = client.call
    response = call.response
    user = User.find_by(name: session[:pogo_alias])


    # Reset database
    user.pokemon.delete_all
    user.items.delete_all

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
            poke_id = i[:pokemon_id]
            move_1 = i[:move_1]
            move_2 = i[:move_2]
            health = i[:stamina_max]
            attack = i[:individual_attack]
            defense = i[:individual_defense]
            stamina = i[:individual_stamina]
            iv = ((attack + defense + stamina) / 45.0).round(2)
            user.pokemon.create(:poke_id => poke_id, :move_1 => move_1, :move_2 => move_2, :health => health, :attack => attack, :defense => defense, :stamina => stamina, :iv => iv)
          end
        end
      end
    end
    Pokemon.delete_all("poke_id = 'MISSINGNO'")
  end


  # get name from logged in client
  def get_name(client)
    client.get_player
    call = client.call
    name = call.response[:GET_PLAYER][:player_data][:username]
  end

end
