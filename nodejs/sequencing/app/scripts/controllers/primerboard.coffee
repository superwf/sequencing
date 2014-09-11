'use strict'

angular.module('sequencingApp').controller 'PrimerBoardCtrl', ['$scope', '$modal', 'Modal', 'PrimerBoard', 'PrimerHead', '$routeParams', '$rootScope','$http', 'SequencingConst', ($scope, $modal, Modal, PrimerBoard, PrimerHead, $routeParams, $rootScope, $http, SequencingConst) ->
  if $routeParams.id == 'new'
    $scope.record = {}
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
      #record = angular.copy($scope.record)
      #record.create_date = new Date(record.create_date)
      record = SequencingConst.copyWithDate($scope.record, 'create_date')
      PrimerBoard.update record, (data)->
        $scope.record.sn = data.sn
    else
      #record = angular.copy($scope.record)
      #record.create_date = new Date(record.create_date)
      record = SequencingConst.copyWithDate($scope.record, 'create_date')
      PrimerBoard.create record, (data)->
        $scope.record.id = data.id

  $scope.showModal = ()->
    Modal.resource = PrimerHead
    Modal.modal = $modal.open {
      templateUrl: '/views/primerHeadTable.html'
      controller: 'ModalCtrl'
    }
  $rootScope.$on 'modal:clicked', (v, data)->
    $scope.record.primer_head = data.name
    $scope.record.primer_head_id = data.id
    null

  null
]
