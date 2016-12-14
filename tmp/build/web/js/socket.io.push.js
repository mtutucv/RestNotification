       var app = angular.module("DasApp", [])
        
        app.controller("DashBoardController", function($scope){
            
            $scope.model = {
                report_type:"GET_USER_COUNT",
                filter:false,
                num_users:0,
                total_male:0,
                total_female:0,
                total_nao_definido:0
            }
            var socket = io.connect("http://instant.0auth.tk:8080");
            
            socket.on('stats userscount', function(data){
               
                $scope.model.report_type = data._data.report_type
                $scope.model.filter = data._data.filter
                $scope.model.num_users = data._data.total
                $scope.model.total_male = data._data.total_male
                $scope.model.total_female = data._data.total_female
                $scope.model.total_nao_definido = data._data.total_nao_definido
                
                console.log($scope.model)
                $scope.$apply()
            })
            
            console.log("Dash App")
        })