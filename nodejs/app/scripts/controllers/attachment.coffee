'use strict'
angular.module('sequencingApp').controller 'AttachmentCtrl', ['$scope', 'attachment', 'Attachment', ($scope, attachment, Attachment)->
  $scope.attachment = attachment

  $scope.delete = (a)->
    Attachment.delete id: a.id, ->
      $scope.$close a
  return
]
