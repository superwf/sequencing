'use strict'

angular.module('sequencingApp').controller 'PrimerBoardCtrl', ['$scope', '$modal', 'Modal', 'PrimerBoard', 'PrimerHead', '$routeParams', '$rootScope','$http', 'Timeconvert', ($scope, $modal, Modal, PrimerBoard, PrimerHead, $routeParams, $rootScope, $http, Timeconvert) ->
  if $routeParams.id == 'new'
    $scope.record = {}
  else
    if Modal.record
      $scope.record = Modal.record
      d = new Date(Modal.record.created_date)
      m = (d.getMonth() + 1) + ''
      if m.length == 1
        m = '0' + m
      $scope.record.created_date = d.getFullYear() + '-' + m + '-' + d.getDate()
    else
      PrimerBoard.get id: $routeParams.id, (data)->
        $scope.record = data
        d = new Date(data.created_date)
        m = (d.getMonth() + 1) + ''
        if m.length == 1
          m = '0' + m
        $scope.record.created_date = d.getFullYear() + '-' + m + '-' + d.getDate()

  $scope.save = ->
    if $scope.record.id > 0
      date = $scope.record.created_date
      record = angular.copy($scope.record)
      record.created_date = new Date(record.created_date)
      PrimerBoard.update record, (data)->
        $scope.record.sn = data.sn
    else
      record = angular.copy($scope.record)
      record.created_date = new Date(record.created_date)
      PrimerBoard.create record, (data)->
        $scope.record.id = data.id

  $scope.showModal = ()->
    Modal.resource = PrimerHead
    Modal.modal = $modal.open {
      templateUrl: '/views/primerHeadTable.html'
      controller: 'ModalCtrl'
    }
  $rootScope.$on 'modal:clicked', ->
    $scope.record.primer_head = Modal.name
    $scope.record.primer_head_id = Modal.id

  null
]
