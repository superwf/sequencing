'use strict'

angular.module('sequencingApp').controller 'CompanyTreeCtrl', ['$scope', 'CompanyTree', ($scope, CompanyTree) ->
  CompanyTree.records(0).then (data)->
    $scope.record =
      children: data.data
    return

  $scope.expand = (record)->
    if record.children_count > 0
      if !record.children || record.children.length == 0
        CompanyTree.records(record.id).then (data)->
          record.children = data.data
      else
        record.children = []
    null
]
