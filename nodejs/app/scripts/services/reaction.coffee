'use strict'
angular.module('sequencingApp').factory 'Reaction', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/reactions/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/reactions/:id'}
    updates: {method: 'PUT', url: Sequencing.api + '/reactions'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/reactions/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
    dilute: {isArray: true, method: 'GET', url: Sequencing.api + '/dilutePrimers'}
    reworking: {isArray: true, method: 'GET', url: Sequencing.api + '/reworkingReactions'}
  }
]
