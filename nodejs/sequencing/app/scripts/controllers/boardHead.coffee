'use strict'
angular.module('sequencingApp').controller 'BoardHeadCtrl', ['$scope', '$routeParams', 'Modal', 'BoardHead', 'SequencingConst', ($scope, $routeParams, Modal, BoardHead, SequencingConst) ->
  $scope.boardType = SequencingConst.boardType
  if $routeParams.id == 'new'
    $scope.record = with_date: true, available: true
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = BoardHead.get id: $routeParams.id

  $scope.save = ->
    if $scope.record.id
      BoardHead.update $scope.record
    else
      BoardHead.create $scope.record, (data)->
        $scope.record = data
    if Modal.modal
      Modal.modal.dismiss 'cancel'

  null
]
