'use strict'

angular.module('sequencingApp').controller 'PrimerBoardCtrl', ['$scope', '$modal', 'Modal', 'PrimerBoard', 'PrimerHead', '$routeParams', '$rootScope','$http', 'Timeconvert', ($scope, $modal, Modal, PrimerBoard, PrimerHead, $routeParams, $rootScope, $http, Timeconvert) ->
  if $routeParams.id == 'new'
    $scope.record = {}
  else
    if Modal.record
      $scope.record = Modal.record
      $scope.record.created_date = new Date(Modal.record.created_date)
      #console.log $scope.record.created_date
    else
      PrimerBoard.get id: $routeParams.id, (data)->
        $scope.record = data
        #$scope.record.created_date = new Date(data.created_date)
        d = new Date(data.created_date)
        $scope.record.created_date = d.getFullYear() + '-' d.getDate() + '-' + d.getDate()
  #$scope.$watch 'record.created_date', (n, o)->
    #console.log typeof(n)
    #console.log(n.getDate())
    #console.log(n.getUTCDate())
    #console.log(n.getUTCFullYear())
    #console.log(n.getUTCMonth())

  $scope.save = ->
    #scope.record.created_date = Timeconvert.gmt2utc(new Date($scope.record.created_date))
    if $scope.record.id > 0
      date = $scope.record.created_date
      #$scope.record.created_date = Timeconvert.gmt2utc($scope.record.created_date)
      console.log JSON.stringify(date)
      #PrimerBoard.update $scope.record, ->
      #  $scope.record.created_date = date
      #if Modal.modal
      #  Modal.modal.dismiss 'cancel'
    else
      #console.log $scope.record.created_date
      date = $scope.record.created_date
      $scope.record.created_date = Timeconvert.gmt2utc($scope.record.created_date)
      PrimerBoard.create $scope.record, (data)->
        $scope.record.id = data.id
        $scope.record.created_date = date

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
