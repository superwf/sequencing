'use strict'
angular.module('sequencingApp').factory 'Procedure', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/procedures/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/procedures/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/procedures/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
