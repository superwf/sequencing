'use strict'
angular.module('sequencingApp').controller 'RolesCtrl', ['$scope', 'Role', ($scope, Role) ->
  $scope.$emit 'event:title', 'privilege'
  $scope.searcher = {}

  $scope.search = ->
    Role.query $scope.searcher, (data) ->
      $scope.records = data
      return
    return

  $scope.search()

  $scope.delete = (id, index)->
    Role.delete {id: id}
    $scope.records.splice index, 1
]
