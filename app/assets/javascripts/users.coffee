$(document).on 'turbolinks:load', ->
  $('.loading').hide()
  return
$(document).ajaxStart(->
  $('.loading').show()
  return
)
$(document).ajaxStop(->
  $('.loading').hide()
  return
)
