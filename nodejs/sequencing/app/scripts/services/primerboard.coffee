'use strict'

angular.module('sequencingApp').factory 'PrimerBoard', ['map', '$resource', (map, $resource)->
  $resource map.api + '/primerBoards/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/primerBoards/:id'}
    'delete': {method: 'DELETE', url: map.api + '/primerBoards/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
