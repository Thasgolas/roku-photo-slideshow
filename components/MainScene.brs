' ============================================================
'  MainScene.brs — logic for the root scene.
'
'  Milestone 4: cycle through the album automatically.
'
'  New idea: a Timer node fires on a fixed interval. We already
'  know how to react to events (observeField), so the slideshow is
'  just "on each tick, advance to the next pair of photos."
' ============================================================


sub init()
    ' Index of the NEXT photo to place on the left. The right photo
    ' is always the one after it. We move this forward by 2 each tick.
    m.nextPhotoIndex = 0

    SetUpPhotoList()
    WatchPhotoLoads()       ' subscribe to load results ONCE
    ShowNextPhotoPair()     ' display the first pair immediately
    StartSlideshowTimer()   ' then begin cycling
end sub


' The photos to display, in order.
'
' >>> YOUR DROPBOX LINKS GO HERE <<<  (each with dl=0 -> raw=1)
' Add as many as you like — the slideshow wraps back to the start
' automatically when it reaches the end.
sub SetUpPhotoList()
    m.photoUrls = [
        "https://www.dropbox.com/scl/fi/v5aa846dpm8jdikm3pbbz/Family1a.jpg?rlkey=c4t5jw6fgpybxoszpg7sm5mqa&st=u7j9mtft&raw=1",
        "https://www.dropbox.com/scl/fi/nao625gq2eqs6querzqs3/adam-a.jpg?rlkey=s0z4per0qyou0znrnm1874ann&st=vqpxywtz&raw=1",
        "https://www.dropbox.com/scl/fi/ut2f3gomvgytd0fc8u0ta/family4.jpg?rlkey=5g3fab1uz3ldy24evyh7jcs5u&st=2dau4yj1&raw=1",
        "https://www.dropbox.com/scl/fi/ls1tg926t48jvmd3nxkyi/Pb150010-2.jpg?rlkey=3xwlpzn6xwbpgjy7v342u0zfj&st=5lrfr4ub&raw=1"

    ]
end sub


' Subscribe to each Poster's load result exactly once. Doing this
' here, rather than every time we swap a photo, avoids stacking up
' duplicate observers that would fire the handler more than once.
sub WatchPhotoLoads()
    m.top.findNode("photoLeft").observeField("loadStatus", "OnPhotoLoadStatusChanged")
    m.top.findNode("photoRight").observeField("loadStatus", "OnPhotoLoadStatusChanged")
end sub


' Shows the next two photos, then moves the index forward by two.
' "mod" keeps every lookup inside the list and wraps to the start
' at the end, so the slideshow loops forever.
sub ShowNextPhotoPair()
    photoCount = m.photoUrls.count()

    leftIndex = m.nextPhotoIndex mod photoCount
    rightIndex = (m.nextPhotoIndex + 1) mod photoCount

    ' Prints to the VS Code Debug Console — handy proof the timer is
    ' firing even before you have enough photos to see it visually.
    print "Slideshow: showing photos "; leftIndex; " and "; rightIndex

    m.top.findNode("photoLeft").uri = m.photoUrls[leftIndex]
    m.top.findNode("photoRight").uri = m.photoUrls[rightIndex]

    m.nextPhotoIndex = (m.nextPhotoIndex + 2) mod photoCount
end sub


' Starts the repeating timer defined in MainScene.xml. Setting its
' control field to "start" begins the countdown; repeat="true" then
' makes it fire again every <duration> seconds.
sub StartSlideshowTimer()
    timer = m.top.findNode("slideshowTimer")
    timer.observeField("fire", "OnSlideshowTimerTick")
    timer.control = "start"
end sub


' Runs each time the timer fires. All it does is advance the show.
sub OnSlideshowTimerTick(event as object)
    ShowNextPhotoPair()
end sub


' Runs whenever either Poster finishes (or fails) loading an image.
sub OnPhotoLoadStatusChanged(event as object)
    newStatus = event.getData()
    statusLabel = m.top.findNode("statusLabel")

    if newStatus = "ready"
        statusLabel.visible = false                 ' hide startup caption
    else if newStatus = "failed"
        statusLabel.visible = true
        statusLabel.text = "A photo failed to load."
    end if
end sub