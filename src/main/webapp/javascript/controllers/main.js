wildbook.app = angular.module('appWildbook', ["angularGrid"]);
wildbook.app.factory('$exceptionHandler', function() {
    return function(ex, cause) {
        //
        // TODO: Make this configurable so that if on production the errors
        // are sent to the console instead of a dialog?
        //
        alertplus.error(ex);
      };
});

wildbook.app.controller("MainController", function($scope, $http, $q, $exceptionHandler) {
    //
    // TODO: Make a single call to get all the "global" data that we might need throughout the app
    // rather than piecemeal?
    //
    $scope.maindata = {};

    $scope.getVessels = function(org) {
        //
        // Let's find our master organization so that we can add the vessels to
        // it and thus cache the results for future occerences of the user picking
        // this organization again in the list.
        //
        var orgfilter = $scope.maindata.organizations.filter(function(value) {
            return (value.orgId == org.orgId);
        });

        var orgmaster;
        if (orgfilter.length > 0) {
            orgmaster = orgfilter[0];
        } else {
            //
            // Just set it to org so we don't have to check for null below
            // but it should *never* not be an array of size 1
            //
            orgmaster = org;
        }

        if (orgmaster.vessels) {
            return $q.resolve(orgmaster.vessels);
        } else {
            return $http({url: "obj/survey/vessels/get", params: {orgid: org.orgId}})
            .then(function(results) {
                orgmaster.vessels = results.data;
                return results.data;
            });
        }
    };

    return $http({url:"obj/user/orgs/get"})
    .then(function(result) {
        $scope.maindata.organizations = result.data;
    }, $exceptionHandler);
});
