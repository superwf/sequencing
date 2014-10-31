'use strict'

angular.module('sequencingApp').factory 'Vector', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/vectors/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/vectors/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/vectors/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
