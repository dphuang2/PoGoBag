$(document).ready ->
  console.log "test"
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
