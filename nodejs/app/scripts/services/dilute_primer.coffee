'use strict'

angular.module('sequencingApp').factory 'DilutePrimer', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/dilutePrimers/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/dilutePrimers/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/dilutePrimers:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
