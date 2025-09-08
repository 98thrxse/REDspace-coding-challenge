function getAPIConfig()
    return {
        tvMaze: {
            base: "https://api.tvmaze.com/"
            paths: {
                shows: "shows"
                search: "search/shows?q="
            }
        }
        requests: 3
    }
end function
