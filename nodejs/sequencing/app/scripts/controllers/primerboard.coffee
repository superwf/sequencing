'use strict'

angular.module('sequencingApp').controller 'PrimerBoardCtrl', ['$scope', '$modal', 'Modal', 'PrimerBoard', 'BoardHead', '$routeParams', '$rootScope','$http', 'SequencingConst', ($scope, $modal, Modal, PrimerBoard, BoardHead, $routeParams, $rootScope, $http, SequencingConst) ->
  if $routeParams.id == 'new'
    $scope.record = {number: 1}
  else
    if Modal.record
      $scope.record = Modal.record
      $scope.record.create_date = SequencingConst.date2string(Modal.record.create_date)
    else
      PrimerBoard.get id: $routeParams.id, (data)->
        $scope.record = data
        $scope.record.create_date = SequencingConst.date2string(date.create_date)

  $scope.save = ->
    if $scope.record.id > 0
      record = SequencingConst.copyWithDate($scope.record, 'create_date')
      PrimerBoard.update record, (data)->
        $scope.record.sn = data.sn
    else
      record = SequencingConst.copyWithDate($scope.record, 'create_date')
      PrimerBoard.create record, (data)->
        $scope.record.id = data.id

  $scope.showModal = ()->
    Modal.resource = BoardHead
    modal = $modal.open {
      templateUrl: '/views/boardHeadTable.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {available: 1, board_type: 'primer'}
    }
    modal.result.then (data)->
      $scope.record.board_head = data.name
      $scope.record.board_head_id = data.id
      null

  null
]
