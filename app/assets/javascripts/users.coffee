$(document).on "turbolinks:load", ->
  $("#cp, #iv, #recent, #health, #atk, #def, #sta, #name, #num, #attack, #defend, #height, #weight").click ->
    list_id = '#poke_'+this.id 
    $("#poke_cp, #poke_iv, #poke_recent, #poke_health, #poke_atk, #poke_def, #poke_sta, #poke_name, #poke_num, #poke_attack, #poke_defend, #poke_height, #poke_weight").css "display", "none"
    $(list_id).css "display", "block"



