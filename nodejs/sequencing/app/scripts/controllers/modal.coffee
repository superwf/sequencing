'use strict'

angular.module('sequencingApp').controller 'ModalCtrl', ['$scope', 'Modal', '$rootScope', ($scope, Modal, $rootScope) ->
  $scope.inModal = true
  $scope.searcher = {}
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
    $rootScope.$broadcast 'modal:clicked', {name: name, id: id}
]
