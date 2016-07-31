module SessionsHelper

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
    response = call.response
    destroy_user_data(user)

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
              poke_id = i[:pokemon_id]
              move_1 = i[:move_1]
              move_2 = i[:move_2]
              health = i[:stamina_max]
              attack = i[:individual_attack]
              defense = i[:individual_defense]
              stamina = i[:individual_stamina]
              cp = i[:cp]
              iv = ((attack + defense + stamina) / 45.0).round(2)
              user.pokemon.create(:poke_id => poke_id, :move_1 => move_1, :move_2 => move_2, :health => health, :attack => attack, :defense => defense, :stamina => stamina, :iv => iv, :cp => cp)
            end
          end
        end
      end
    rescue 
      logger.debug "Rescued from storing"
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
    name = call.response[:GET_PLAYER][:player_data][:username]
    rescue NoMethodError
      logger.debug "Rescued from get name"
      flash[:danger] = 'Servers are busy. Please try again later.'
      render 'new'
    end

  end

  # get response from call by providing client and request
  def get_call(client, req)
    begin
      client.send req
      call = client.call
    rescue
      retry
    end
  end

end
