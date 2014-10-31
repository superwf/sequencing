'use strict'

angular.module('sequencingApp').factory 'InterpreteCode', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/interpreteCodes/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/interpreteCodes/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/interpreteCodes/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET', url: Sequencing.api + '/interpreteCodes?all=true&available=1'}
  }
]
