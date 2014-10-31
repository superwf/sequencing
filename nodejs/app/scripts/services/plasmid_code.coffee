'use strict'

angular.module('sequencingApp').factory 'PlasmidCode', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/plasmidCodes/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/plasmidCodes/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/plasmidCodes/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
