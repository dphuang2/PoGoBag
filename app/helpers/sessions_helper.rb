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
  def store_inventory(client, user)
    client.get_inventory
    call = client.call
    response = call.response

    response[:GET_INVENTORY][:inventory_delta][:inventory_items].each do |item|
      item[:inventory_item_data].each do |type, i|
        case type
        when :item 
          if i != nil 
            item_id = i[:item_id]
            count = i[:count]
            if item = Item.find_by(user_id: user.id, item_id: item_id)
              item.update_attribute(:count, count)
            else
              user.items.create(item_id: item_id, count: count)
            end
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
            if pokemon = Item.find_by(user_id: user.id, item_id: item_id)
              pokemon.update_attribute(:poke_id => poke_id, :move_1 => move_1, :move_2 => move_2, :health => health, :attack => attack, :defense => defense, :stamina => stamina)
            else
              user.pokemon.create(:poke_id => poke_id, :move_1 => move_1, :move_2 => move_2, :health => health, :attack => attack, :defense => defense, :stamina => stamina)
            end
          end
        end
      end
    end
  end


  # get name from logged in client
  def get_name(client)
    client.get_player
    call = client.call
    name = call.response[:GET_PLAYER][:player_data][:username]
  end

end
