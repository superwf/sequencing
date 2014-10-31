'use strict'

angular.module('sequencingApp').factory 'PrecheckCode', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/precheckCodes/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/precheckCodes/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/precheckCodes/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
