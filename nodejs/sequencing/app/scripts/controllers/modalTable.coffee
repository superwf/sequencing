'use strict'
angular.module('sequencingApp').controller 'ModalTableCtrl', ['$scope', 'Modal', '$rootScope', 'searcher', ($scope, Modal, $rootScope, searcher) ->
  $scope.inModal = true
  $scope.searcher = searcher || {}
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
    $scope.$close {id: id, name: name}
]
