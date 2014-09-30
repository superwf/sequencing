'use strict'

angular.module('sequencingApp').controller 'ReactionFilesCtrl', ['$scope', 'ReactionFile', 'Modal', '$modal', 'SequencingConst', ($scope, ReactionFile, Modal, $modal, SequencingConst) ->
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
      window.location = SequencingConst.api + '/downloadReactionFiles?ids=' + ids
    null

]
