'use strict'

angular.module('sequencingApp').factory 'BoardHead', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/boardHeads/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/boardHeads/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/boardHeads/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
