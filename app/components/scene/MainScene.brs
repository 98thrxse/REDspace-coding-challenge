sub init()
  router = m.top.findNode("Router")

  m.global.update({
    env: "tvMaze"
    deviceInfo: getDeviceInfo()
    theme: getTheme()
    router: router
  }, true)

  setAppBackgroundColor()

  router.callFunc("setup")
end sub

sub setAppBackgroundColor()
  scene = m.top.getScene()
  scene.backgroundColor = m.global.theme.colors.background
  scene.backgroundUri = ""
end sub
