sub execute()
    env = m.global.env
    config = getAPIConfig()
    request = m.top.request

    base = config[env].base
    search = config[env].paths.search
    text = request.text

    url = base + search + text
    headers = { "Accept": "application/json" }

    rawResponse = makeGetRequest(url, headers)

    if not rawResponse.isEmpty() then
        jsonResponse = parseJson(rawResponse)
        if jsonResponse <> invalid then
            response = _sortInOneRow(jsonResponse)
            m.top.response = response
        else
            m.top.response = {
                error: "invalid"
            }
        end if
    end if
end sub

function _sortInOneRow(shows as object) as object
    data = {}
    items = []

    for each item in shows
        show = item.show

        image = {}
        if show.doesExist("image") and show.image <> invalid then
            image = {
                original: show.image.original
                medium: show.image.medium
            }
        end if

        title = ""
        if show.doesExist("name") and show.name <> invalid then
            title = show.name
        end if

        genres = []
        if show.doesExist("genres") and show.genres <> invalid then
            genres = show.genres
        end if

        averageRating = ""
        if show.doesExist("rating") and show.rating <> invalid then
            if show.rating.doesExist("average") and show.rating.average <> invalid then
                averageRating = show.rating.average.toStr()
            end if
        end if

        summary = ""
        if show.doesExist("summary") and show.summary <> invalid then
            summary = show.summary
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

        items.push(item)
    end for

    row = {
        type: "ContentNode"
        title: "Results"
        children: items
    }

    content = {
        type: "ContentNode"
        children: [row]
    }

    data.content = content

    return data
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
