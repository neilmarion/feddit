# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('.subreddit').click ->
    $(this).attr 'class', 'btn btn-warning btn-xs subreddit'
    selected = $('.subreddits .selected') 
    selected.append '<input id="user_subreddits" multiple="multiple" name="user[subreddits][]" type="hidden" value="'+$(this).val()+'">'


