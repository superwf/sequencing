'use strict'

angular.module('sequencingApp').factory 'User', ['$resource', 'map', ($resource, map)->
  $resource map.api + '/users/:id', id: '@id', {
    query: {isArray: false, method: 'GET'}
  }
]
