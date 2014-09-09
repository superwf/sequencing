'use strict'

angular.module('sequencingApp').factory 'PrimerHead', ['map', '$resource', (map, $resource)->
  $resource map.api + '/primerHeads/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/primerHeads/:id'}
    'delete': {method: 'DELETE', url: map.api + '/primerHeads/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
