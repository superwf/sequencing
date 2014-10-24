'use strict'

angular.module('sequencingApp').controller 'ClientCtrl', ['$scope', 'Client', '$modal', 'Modal', '$rootScope', 'Company', ($scope, Client, $modal, Modal, $rootScope, Company) ->
  $scope.record = Modal.record

  $scope.save = ->
    if $scope.record.id
      Client.update $scope.record, ->
        $scope.$close 'ok'
    else
      Client.create $scope.record, (data)->
        $scope.$close data

  $scope.showCompany = ()->
    Modal.resource = Company
    $modal.open {
      templateUrl: '/views/companiesTable.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    .result.then (data)->
      $scope.record.company = data.name
      $scope.record.company_id = data.id
      null

  null
]
