$(document).on 'turbolinks:load', ->
  elem = $("#copy-clipboard-button")

  if elem
    new ZeroClipboard elem

$(document).on "turbolinks:before-render",  ->
  ZeroClipboard.destroy()
