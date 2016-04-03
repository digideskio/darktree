# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('div.card div.content').click ->
      $(@).closest('.card').toggleClass('flipped')

$ ->
  $("li.fav").click ->
     card_i = $(this).children("i")
     card_id = $(this).parents("div.card").attr("data-card")
     if $(this).children("i").hasClass("favorited")
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
           $(card_i).addClass("favorited")
         else
           $(card_i).removeClass("favorited")
