# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Flip card
$ ->
  $('div.card div.content').click ->
      $(@).closest('.card').toggleClass('flipped')

# Change fav
$ ->
  $('li.fav').click ->
     card_i = $(@).children('i')
     card_id = $(@).parents('div.card').attr('data-card')
     if $(@).children('i').hasClass('favorited')
       method = 'DELETE'
     else
       method = 'PUT'

     $.ajax
       url: '/cards/' + card_id + '/favorite',
       type: method,
       contentType: 'application/json',
       dataType: 'json',
       success: (msg) ->
         if method == 'PUT'
           $(card_i).addClass('favorited')
         else
           $(card_i).removeClass('favorited')

# Cahnge status
$ ->
  $('div.status').click ->
    status = $(@).children('span')
    card_id = $(@).parents('div.card').attr('data-card')

    switch status.attr('class')
      when 'bad'
        next_status = 'almost'
        next_stauts_id = 1
      when 'almost'
        next_status = 'good'
        next_stauts_id = 2
      when 'good'
        next_status = 'bad'
        next_stauts_id = 0

    $.ajax
      url: "/cards/#{card_id}/status",
      type: "PUT",
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ "status": next_stauts_id }),
      success: (msg) ->
        status.attr('class', next_status)
        status.text(next_status)
