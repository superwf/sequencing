'use strict'

angular.module('sequencingApp').controller 'ReactionFilesCtrl', ['$scope', 'ReactionFile', 'Modal', '$modal', 'SequencingConst', '$window', ($scope, ReactionFile, Modal, $modal, SequencingConst, $window) ->
  ReactionFile.download (data) ->
    $scope.records = data
    null
  null

  $scope.download = ->
    selected = angular.element('.ui-selected')
    if selected.length
      ids = []
      selected.each ->
        i = parseInt(this.getAttribute('i'))
        ids.push $scope.records[i].id
      $window.open SequencingConst.api + '/downloadReactionFiles?ids=' + ids
    $scope.records
    null

]
