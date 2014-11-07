'use strict'
angular.module('sequencingApp').factory 'Attachment', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/attachments/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/attachments/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/attachments/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
