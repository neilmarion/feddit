# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('.subreddit').click ->
    selected = $('.subreddits .selected') 
    if $(this).attr('class').indexOf('btn-warning') != -1
      $(this).attr 'class', 'btn btn-default btn-xs subreddit'
      $('#user_subreddits_' + $(this).val()).remove()
    else
      $(this).attr 'class', 'btn btn-warning btn-xs subreddit'
      selected.append '<input id="user_subreddits_' + $(this).val() + '" multiple="multiple" name="user[subreddits][]" type="hidden" value="' + $(this).val() + '">'


