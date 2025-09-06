function getDetailsConfig(settings as object)
    font = settings.font
    safetyMargins = settings.safetyMargins

    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    horizMargin = safetyMargins.horizontal[screenSize]
    vertMargin = safetyMargins.vertical[screenSize]

    sizes = {
        container: {
            FHD: {
                itemSpacings: [100]
            }
            HD: {
                itemSpacings: [50]
            }
        }
        image: {
            FHD: {
                width: 630
                height: 885
            }
            HD: {
                width: 420
                height: 590
            }
        }
        textGroup: {
            FHD: {
                itemSpacings: [25]
            }
            HD: {
                itemSpacings: [15]
            }
        }
        buttonGroup: {
            FHD: {
                itemSpacings: [20]
            }
            HD: {
                itemSpacings: [10]
            }
        }
    }

    textWidth = uiResolution.width - horizMargin - sizes.image[screenSize].width - sizes.container[screenSize].itemSpacings[0]

    style = {
        container: {
            layoutDirection: "horiz"
            itemSpacings: sizes.container[screenSize].itemSpacings
            translation: [0, uiResolution.height / 2 - vertMargin]
            vertAlignment: "center"
        }
        image: {
            loadHeight: sizes.image[screenSize].height
            loadWidth: sizes.image[screenSize].width
            loadDisplayMode: "scaleToFit"
            width: sizes.image[screenSize].width
            height: sizes.image[screenSize].height
        }
        textGroup: {
            itemSpacings: sizes.textGroup[screenSize].itemSpacings
        }
        title: {
            width: textWidth
            font: font.largeBold
        }
        averageRating: {
            width: textWidth
            font: font.medium
        }
        summary: {
            width: textWidth
            wrap: true
            font: font.smallest
        }
        genres: {
            width: textWidth
            font: font.smallestBold
        }
        buttonGroup: {
            layoutDirection: "horiz"
            itemSpacings: sizes.buttonGroup[screenSize].itemSpacings
            maxWidth: textWidth
            minWidth: textWidth
        }
        playButton: {
            text: "Play"
        }
        backButton: {
            text: "Back"
        }
    }

    config = {
        style: style
    }

    return config
end function
