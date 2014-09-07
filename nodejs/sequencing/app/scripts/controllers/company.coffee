'use strict'

angular.module('sequencingApp').controller 'CompanyCtrl', ['$scope', 'Company', '$routeParams', '$modal', 'Modal', '$rootScope', ($scope, Company, $routeParams, $modal, Modal, $rootScope) ->
  new_record = {
  }
  if $routeParams.id == 'new'
    $scope.record = new_record
  else
    Company.get id: $routeParams.id, (data)->
      $scope.record = data
      if data.parent_id > 0
        Company.get id: $scope.record.parent_id, (parent)->
          $scope.parent = parent.name

  $scope.save = ->
    $scope.record.price = $scope.record.price * 1
    if $scope.record.id
      $scope.record.$update id: $scope.record.id
    else
      Company.create $scope.record, (data)->
        $scope.record = data
  $scope.showParent = ()->
    Modal.resource = Company
    Modal.modal = $modal.open {
      templateUrl: '/views/companiesTable.html'
      controller: 'ModalCtrl'
    }

  $scope.parent = ''
  $rootScope.$on 'modal:clicked', ->
    $scope.parent = Modal.name
    $scope.record.parent_id = Modal.id
  null
]
