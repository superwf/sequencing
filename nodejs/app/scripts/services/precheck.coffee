'use strict'
angular.module('sequencingApp').factory 'Precheck', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/prechecks/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/prechecks/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/prechecks/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
