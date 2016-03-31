# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('div.card div.content').click (e) ->
      $(@).closest('.card').toggleClass('flipped')

$ ->
  $("li.fav").click ->
     card_span = $(this).children("span")
     card_id = $(this).parents("div.card").attr("data-card")
     if $(this).children("span").hasClass("favorited")
       method = 'DELETE'
     else
       method = 'PUT'

     $.ajax
       url: "/cards/" + card_id + "/favorite",
       type: method,
       contentType: "application/json",
       dataType: "json",
       success: (msg) ->
         if method == "PUT"
           $(card_span).addClass("favorited")
         else
           $(card_span).removeClass("favorited")
