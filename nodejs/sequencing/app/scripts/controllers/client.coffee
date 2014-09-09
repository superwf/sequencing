'use strict'

angular.module('sequencingApp').controller 'ClientCtrl', ['$scope', 'Client', '$routeParams', '$modal', 'Modal', '$rootScope', 'Company', ($scope, Client, $routeParams, $modal, Modal, $rootScope, Company) ->
  if $routeParams.id == 'new'
    $scope.record = {}
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = Client.get id: $routeParams.id

  $scope.save = ->
    if $scope.record.id
      Client.update $scope.record
    else
      Client.create $scope.record, (data)->
        $scope.record = data

  $scope.showCompany = ()->
    Modal.resource = Company
    Modal.modal = $modal.open {
      templateUrl: '/views/companiesTable.html'
      controller: 'ModalCtrl'
    }
  $rootScope.$on 'modal:clicked', ->
    $scope.record.company = Modal.name
    $scope.record.company_id = Modal.id
    console.log Modal.id

  null
]
