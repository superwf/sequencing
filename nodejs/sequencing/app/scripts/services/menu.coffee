'use strict'
angular.module('sequencingApp').factory 'Menu', ['map', '$resource', (map, $resource)->
  $resource map.api + '/menus/:id', id: '@id', {
    query: {isArray: true, method: 'GET'}
  }
]
