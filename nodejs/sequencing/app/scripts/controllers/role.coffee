'use strict'
angular.module('sequencingApp').controller 'RoleCtrl', ['$scope', 'Role', '$routeParams', 'Menu', '$http', 'map', ($scope, Role, $routeParams, Menu, $http, map) ->
  $scope.record = Role.get id: $routeParams.id
  $scope.update = (menu_id, active)->
    $http.put map.api + '/roles/' + $scope.record.id, {menu_id: menu_id, active: active}

  Menu.query (data)->
    roots = []
    children = []
    angular.forEach data, (v, k)->
      if v.parent_id == 0
        roots.push {id: v.id, name: v.name, url: v.url, active: v.active > 0, children: []}
      else
        children.push v
    angular.forEach children, (v, k)->
      angular.forEach roots, (r, k1)->
        if v.parent_id == r.id
          r.children.push {id: v.id, name: v.name, url: v.url, active: v.active > 0}
    $scope.menus = roots
    #console.log roots
  null
]
