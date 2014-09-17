mod = angular.module('player')

mod.controller('PlayerCtrl', ($scope, $http, mpdService) ->
  'use strict'
  ctrl = this
  $scope.playing = {}

  $scope.$on MPD_STATUS, (event, data) ->
    $scope.playing =
      now: ctrl.nowPlaying(data)
      # play, pause or stop
      state: data.state
      error: data.error
      progress: Math.floor((parseFloat(data.elapsed)/parseFloat(data.Time))*100)
      playlistLength: data.playlistlength
      playlistPosition: parseInt(data.song||-1) + 1
      random: data.random == "1"
      quality: ctrl.friendlyQuality(data.audio, data.bitrate)
    $scope.$apply()

  $scope.$on CONN_STATUS, (event, connected) ->
    $scope.playing.error = if connected then "" else "Connection lost"

  ctrl.nowPlaying = (data) ->
    if data.Artist && data.Title
      "#{data.Artist} - #{data.Title}"

  ctrl.friendlyQuality = (mpdAudioString, bitrate) ->
    return unless mpdAudioString
    chan = if mpdAudioString.split(':')[2] == '2' then 'Stereo' else 'Mono'
    freq = parseInt(mpdAudioString.split(':')[0]) / 1000 + ' kHz'
    rate = mpdAudioString.split(':')[1] + ' bit'
    bitr = bitrate + ' kbps'
    [chan, rate, freq, bitr].join(', ')

  $scope.play = ->
    $http.get('/play')

  $scope.pause = ->
    $http.get('/pause')

  $scope.previous = ->
    $http.get('/previous')

  $scope.next = ->
    $http.get('/next')

  $scope.random = ->
    if $scope.playing.random then $http.get('/randomOff') else $http.get('/randomOn')
)
