sub init()
  router = m.top.findNode("Router")

  m.global.update({
    env: "tvMaze"
    router: router
    deviceInfo: getDeviceInfo()
    theme: getTheme()
  }, true)

  setAppBackgroundColor()
  setOverlay()

  routerConstants = router.callFunc("getRouterConstants")
  router.callFunc("navigateToPage", routerConstants.routes.home)
end sub

sub setAppBackgroundColor()
  scene = m.top.getScene()
  scene.backgroundColor = m.global.theme.colors.background
  scene.backgroundUri = ""
end sub

sub setOverlay()
  overlay = CreateObject("roSGNode", "Overlay")
  overlay.visible = false
  m.global.update({
    overlay: overlay
  }, true)
  m.top.appendChild(overlay)
end sub
