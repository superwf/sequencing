'use strict'

angular.module('sequencingApp').factory 'Flow', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/flows/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/flows/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/flows/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
