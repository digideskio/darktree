# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Flip card & Increment check_count
$ ->
  $('div.card div.content').click ->
      card = $(@).closest('div.card')
      card.toggleClass('flipped')

      # Increment check_count
      return unless card.hasClass('flipped')
      card_id = card.attr('data-card')
      check_count_span = card.find('li.check-count').children('span')
      check_count = parseInt(check_count_span.text())
      $.ajax
        url: "/cards/#{card_id}",
        type: 'PATCH',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ "check_count": check_count + 1 }),
        success: ->
          check_count_span.text(check_count + 1)

# Change fav
$ ->
  $('li.fav').click ->
     card_i = $(@).children('i')
     card_id = $(@).parents('div.card').attr('data-card')
     if $(@).children('i').hasClass('favorited')
       is_fav = false
     else
       is_fav = true

     $.ajax
       url: "/cards/#{card_id}",
       type: 'PATCH',
       contentType: 'application/json',
       dataType: 'json',
       data: JSON.stringify({ "favorite": is_fav }),
       success: ->
         if is_fav
           $(card_i).addClass('favorited')
         else
           $(card_i).removeClass('favorited')

# Change status
$ ->
  $('div.status').children('span').click ->
    status = $(@)
    card_id = $(@).parents('div.card').attr('data-card')

    switch status.attr('class')
      when 'good'
        next_status = false
        next_status_str = 'bad'
      when 'bad'
        next_status = true
        next_status_str = 'good'

    $.ajax
      url: "/cards/#{card_id}",
      type: 'PATCH',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ "status": next_status }),
      success: ->
        status.attr('class', next_status_str)
        status.text(next_status_str)
