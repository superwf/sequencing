'use strict'

angular.module('sequencingApp').controller 'ModalCtrl', ['$scope', 'Modal', '$rootScope', ($scope, Modal, $rootScope) ->
  $scope.inModal = true
  $scope.search = ->
    Modal.resource.query $scope.searcher, (data) ->
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
  $scope.setPage = ()->
    $scope.search()

  $scope.click = (id, name)->
    Modal.modal.dismiss 'cancel'
    Modal.id = id
    Modal.name = name
    $rootScope.$broadcast 'modal:clicked'
]
