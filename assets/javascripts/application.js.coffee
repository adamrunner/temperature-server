#= require 'jquery-2.1.4.min'
#= require hamlcoffee
#= require_tree ./templates
#= require ./websockets
$ ->
  string = "Hello from Haml Coffee!"
  $("#flash_message").html JST['flash_message'] string: string
