'use strict'
angular.module('sequencingApp').factory 'CompanyTree', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/companies/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/companies/:id'}
    records: {isArray: true, method: 'GET', url: Sequencing.api + '/companyTree/:id'}
  }
]
