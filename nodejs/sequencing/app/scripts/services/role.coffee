'use strict'

angular.module('sequencingApp').factory 'Role', ['map', '$resource', (map, $resource)->
  $resource map.api + '/roles/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/roles/:id'}
    query: {isArray: false, method: 'GET'}
  }
]
