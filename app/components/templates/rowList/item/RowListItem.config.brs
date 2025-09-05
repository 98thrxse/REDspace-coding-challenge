function getRowListItemConfig(settings as object)
    font = settings.font

    style = {
        image: {
            width: 210
            height: 295
        }
        textGroup: {
            translation: [0, 315]
        }
        title: {
            text: "N/A"
            width: 210
            font: font.smallestBold
        }
        averageRating: {
            text: "N/A"
            font: font.smallest
        }
    }

    config = {
        style: style
    }

    return config
end function
