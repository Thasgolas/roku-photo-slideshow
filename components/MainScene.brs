' ============================================================
'  MainScene.brs — logic for the root scene.
'
'  Milestone 3: load two photos into two side-by-side Posters.
'
'  New idea: the list of photos lives in a simple array (m.photoUrls),
'  separate from the layout. Right now we just show the first two,
'  but keeping the photos as data is what will let us cycle through
'  a whole album on a timer in the next step.
' ============================================================


sub init()
    ' m is this scene's state bag. We track how many photos have
    ' finished loading so we know when to hide the "Loading" caption.
    m.loadedCount = 0

    SetUpPhotoList()
    ShowFirstTwoPhotos()
end sub


' The photos to display, in order.
'
' >>> THIS IS WHERE YOUR DROPBOX LINKS GO <<<
' Share a photo in Dropbox, copy its link, change the trailing
' "dl=0" to "raw=1", and paste it in place of a test URL below.
' Example:
'   "https://www.dropbox.com/scl/fi/ABC123/grandma.jpg?rlkey=xyz&raw=1"
sub SetUpPhotoList()
    m.photoUrls = [
        "https://www.dropbox.com/scl/fi/v5aa846dpm8jdikm3pbbz/Family1a.jpg?rlkey=c4t5jw6fgpybxoszpg7sm5mqa&st=u7j9mtft&raw=1"
        "https://www.dropbox.com/scl/fi/nao625gq2eqs6querzqs3/adam-a.jpg?rlkey=s0z4per0qyou0znrnm1874ann&st=vqpxywtz&raw=1"
'        "https://picsum.photos/seed/left/960/1080",
'        "https://picsum.photos/seed/right/960/1080"
    ]
end sub


' Sends the first photo to the left box and the second to the right.
sub ShowFirstTwoPhotos()
    LoadPhotoInto("photoLeft", m.photoUrls[0])
    LoadPhotoInto("photoRight", m.photoUrls[1])
end sub


' Points one Poster at one URL and subscribes to its load result.
sub LoadPhotoInto(nodeId as string, url as string)
    poster = m.top.findNode(nodeId)

    ' Watch this Poster's loadStatus, then start the download by
    ' setting uri. Observe BEFORE setting uri so we don't miss the
    ' result on fast loads.
    poster.observeField("loadStatus", "OnPhotoLoadStatusChanged")
    poster.uri = url
end sub


' Runs whenever either Poster's loadStatus changes. Both Posters
' share this one handler, which is fine because we only care about
' the running total, not which photo finished.
sub OnPhotoLoadStatusChanged(event as object)
    newStatus = event.getData()
    statusLabel = m.top.findNode("statusLabel")

    if newStatus = "ready"
        m.loadedCount = m.loadedCount + 1

        ' Hide the caption only once BOTH photos are on screen.
        if m.loadedCount >= 2
            statusLabel.visible = false
        end if

    else if newStatus = "failed"
        ' A bad URL, no network, or a Dropbox preview page instead
        ' of raw bytes will land here. Leave the caption up to show it.
        statusLabel.text = "A photo failed to load."
    end if
end sub
