sub execute()
    env = m.global.env
    config = getAPIConfig()

    base = config[env].base
    shows = config[env].paths.shows

    url = base + shows
    headers = { "Accept": "application/json" }

    rawResponse = makeGetRequest(url, headers)

    if not rawResponse.isEmpty() then
        jsonResponse = parseJson(rawResponse)
        if jsonResponse <> invalid then
            response = _sortByGenre(jsonResponse)
            m.top.response = response
        else
            m.top.response = {
                error: "invalid"
            }
        end if
    end if
end sub

function _sortByGenre(shows as object) as object
    map = {}

    for each show in shows
        genres = ["Others"]
        if show.doesExist("genres") and show.genres.count() > 0 then
            genres = show.genres
        end if

        image = {}
        if show.doesExist("image") then
            image = {
                original: show.image.original
                medium: show.image.medium
            }
        end if

        title = ""
        if show.doesExist("name") then
            title = show.name
        end if

        genres = []
        if show.doesExist("genres") then
            genres = show.genres
        end if

        averageRating = ""
        if show.doesExist("rating") and show.rating.doesExist("average") and show.rating.average <> invalid then
            averageRating = show.rating.average.toStr()
        end if

        summary = ""
        if show.doesExist("summary") then
            summary = show.summary
        end if

        for each genre in genres
            if not map.doesExist(genre) then
                map[genre] = []
            end if

            item = {
                type: "ContentNode"
                title: title
                summary: summary
                genres: genres
                image: image
                averageRating: averageRating
                video: _pickRandomVideo()
            }
            map[genre].push(item)
        end for
    end for

    content = {
        type: "ContentNode"
        children: []
    }

    for each key in map.keys()
        row = {
            type: "ContentNode"
            title: key
            children: map[key]
        }
        content.children.push(row)
    end for

    return content
end function

function _pickRandomVideo() as object
    random = (Rnd(0) < 0.5)

    if random then
        video = {
            streamFormat: "hls"
            url: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
        }
    else
        video = {
            streamFormat: "dash"
            url: "https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears.mpd"
            drmParams: {
                keySystem: "widevine",
                licenseServerURL: "https://proxy.uat.widevine.com/proxy?provider=widevine_test"
            }
        }
    end if

    return video
end function
