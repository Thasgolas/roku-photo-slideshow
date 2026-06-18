' ============================================================
'  main.brs — Application entry point.
'
'  Roku calls Main() automatically when the channel launches.
'  Our whole job here is plumbing:
'    1. create the on-screen rendering surface,
'    2. load and show our root scene, then
'    3. wait quietly until the user exits the channel.
'
'  All the actual UI lives in components/MainScene.xml, not here.
' ============================================================


sub Main()
    ShowRootScene()
end sub


' Creates the application window, displays the root scene, and
' then hands control to the message loop that keeps us running.
sub ShowRootScene()

    ' The "screen" is the top-level rendering surface for a
    ' SceneGraph app. It talks to us through a message port: a
    ' mailbox that system events (like "app closed") get posted to.
    screen = CreateObject("roSGScreen")
    messagePort = CreateObject("roMessagePort")
    screen.SetMessagePort(messagePort)

    ' Build the scene defined in components/MainScene.xml and put
    ' it on screen. The string below must match that component's
    ' name="..." attribute exactly.
    screen.CreateScene("MainScene")
    screen.Show()

    WaitForExit(messagePort)
end sub


' Sleeps until the user closes the channel, then returns so that
' Main() can finish and the app exits cleanly.
'
' wait(0, port) blocks with zero CPU cost until a message arrives,
' so this loop is idle-friendly — it is not a busy-wait.
sub WaitForExit(messagePort as object)
    while true
        message = wait(0, messagePort)

        ' Screen-level events arrive as roSGScreenEvent. When
        ' isScreenClosed() reports true, the user has backed out
        ' of the channel and we are done.
        isScreenEvent = (type(message) = "roSGScreenEvent")
        if isScreenEvent and message.isScreenClosed()
            return
        end if
    end while
end sub
