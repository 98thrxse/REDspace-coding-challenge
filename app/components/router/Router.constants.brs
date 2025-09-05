
function getRouterConstants() as object
    return {
        routes: _getRoutes()
    }
end function

function _getRoutes() as object
    return {
        home: "HomePage"
        details: "DetailsPage"
        player: "PlayerPage"
    }
end function
