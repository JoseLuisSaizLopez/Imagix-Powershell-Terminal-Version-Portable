class ImagixLooper {
    $songFileList = (Get-ChildItem -Path "bin\songs").FullName
    $videoFileList = (Get-ChildItem -Path "bin\videos").FullName
    $songNames = (Get-ChildItem -Path "bin\songs")
    $videoNames = (Get-ChildItem -Path "bin\videos")
    $vlc = ("VideoLAN\VLC\vlc.exe")

    #/
    #   Before all
    #/
    ##Check if its first time initialized
    checkFirstTime(){
        if (Test-Path "bin\config.iptv" -PathType Leaf) {
            $times = (Get-Content "bin\config.iptv")
            $times = [int]$times
            if ($times -eq 0) {
                $times++
                $times | Out-File "bin\config.iptv"
                Start-Process ((Resolve-Path "manual.pdf").Path)
            }
        } else {
            $times = 0
            $times | Out-File "bin\config.iptv"
        }
    }

    #Adding C# support to handle FileBrowser window
    addCpath(){
        Add-Type -AssemblyName system.Windows.Forms
    }
    ##vlc support for 32 and 64 bits
    checkVlc(){
        if (Test-Path $this.vlc -PathType Leaf) {
            Remove-Item "bin\vlc.path"
            $this.vlc | Out-File "bin\vlc.path"             
        } elseif (Test-Path 'C:\Program Files (x86)\VideoLAN\VLC\vlc.exe' -PathType Leaf) {
            $this.vlc = 'C:\Program Files (x86)\VideoLAN\VLC\vlc.exe'
            Remove-Item "bin\vlc.path"
            $this.vlc | Out-File "bin\vlc.path"   
        } elseif (Test-Path 'C:\Program Files\VideoLAN\VLC\vlc.exe' -PathType Leaf) {
            $this.vlc = 'C:\Program Files\VideoLAN\VLC\vlc.exe'
            Remove-Item "bin\vlc.path"
            $this.vlc | Out-File "bin\vlc.path" 
        } else {
            $this.showVlcWarning()
        }
    }

    showVlcWarning(){
        $exit = $false
        $option = ""
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  VLC PATH EXCEPTION                                                              "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  You can try to read our manual or insert your vlc path to solve this problem    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " We cannot find your vlc program path, plase enter the path here or maybe     "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " you can download our portable version with vlc included.                     "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "  [P] - Enter path                                                            "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "  [M] - Read manual                                                           "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "  [D] - Download portable version                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "  [Z] - EXIT                                                                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "        
        
            
            
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = [System.Console]::ReadKey().Key
            Write-Host ""
            switch ($option) {
                p { 
                    $newPath = $this.SelectVlcPath()
                    if ($newPath.ToLower() -like '*videolan\vlc\vlc.exe*' -and (Test-Path $newPath -PathType Leaf)) {
                        $this.vlc = "$newPath"
                        Write-Host -ForegroundColor White -BackgroundColor DarkGreen "  Path succesfully recognized                                                     "
                        Remove-Item "bin\vlc.path"
                        $this.vlc | Out-File "bin\vlc.path" 
                        $newPath = Read-Host 'Enter any key to launch the program'
                        $this.showMenu("main", "playMusic")
                    } else {
                        Write-Host -ForegroundColor White -BackgroundColor DarkRed "  This path does not contain a vlc.exe file, remember to put *\vlc.exe at the end "
                        $newPath = Read-Host 'Enter any key to retry'
                    }
                 }
                 m {
                    Start-Process ((Resolve-Path "manual.pdf").Path)
                    exit
                 }
                 d {
                    $IE=new-object -com internetexplorer.application
                    $IE.navigate2("https://github.com/AdsysDevelop/Imagix-Powershell-Terminal-Version-Portable")
                    $IE.visible=$true
                 }
                 z { 
                    exit
                 }
                Default {}
            }
        }
    }

    ##Creating two playlists with All Songs and Imagix selection
    createDefaultPlaylists(){
        $songFileListBugged = New-Object System.Collections.ArrayList
        $this.playSongDebug($songFileListBugged)
        if (Test-Path "bin/playlist/All Songs.m3u" -PathType Leaf) {
            Remove-Item "bin/playlist/All Songs.m3u"   
        }
        $songFileListBugged | Out-File "bin/playlist/All Songs.m3u"

        $imagixSelectionEmpty = @()
        $imagixSelection = New-Object System.Collections.ArrayList

        for ($i = 0; $i -lt 5; $i++) {
            $number = Get-Random -Minimum 0 -Maximum ($this.songFileList.length-1)
            try {
                $imagixSelectionEmpty = $imagixSelectionEmpty + ($this.songFileList.Get($number))
            }
            catch {
                
            }
        }
        $this.songFileList = $imagixSelectionEmpty
        $this.playSongDebug($imagixSelection)
        if (Test-Path "bin/playlist/Imagix Selection.m3u" -PathType Leaf) {
            Remove-Item "bin/playlist/Imagix Selection.m3u"
        }
        $imagixSelection | Out-File "bin/playlist/Imagix Selection.m3u"


        ##For videos
        $videoFileListBugged = New-Object System.Collections.ArrayList
        $this.playVideoDebug($videoFileListBugged)
        if (Test-Path "bin/vplaylist/All Songs.m3u" -PathType Leaf) {
            Remove-Item "bin/vplaylist/All Songs.m3u"   
        }
        $videoFileListBugged | Out-File "bin/vplaylist/All Videos.m3u"
    }


    #/
    #   Functionality
    #/
    ##Debug for playing the first song of every playlist, vlc skips it by default
    playSongDebug($playlistArray){
        for ($i = 0; $i -lt $this.songFileList.Count; $i++) {
            if ($i -eq 0) {
                $playlistArray.Add($this.songFileList.Get(0))
                $playlistArray.Add($this.songFileList.Get(0))
            }else {
                $playlistArray.Add($this.songFileList.Get($i))
            }
        }
    }

    ##Support for video options
    playVideoDebug($playlistArray){
        for ($i = 0; $i -lt $this.videoFileList.Count; $i++) {
            if ($i -eq 0) {
                $playlistArray.Add($this.videoFileList.Get(0))
                $playlistArray.Add($this.videoFileList.Get(0))
            } else {
                $playlistArray.Add($this.videoFileList.Get($i))
            }
        }
    }

    ##Setting the diferent playlists files
    playSongPlaylist($option, $playlistName){

        $randomFileListEmpty = New-Object System.Collections.ArrayList
        $randomFileList = New-Object System.Collections.ArrayList


        if ($option -eq "random") {
            $this.songFileList = (Get-Content "bin/playlist/$playlistName.m3u")
            for ($i = 0; $i -lt $this.songFileList.Count; $i++) {
                if ($i -ne 0) {
                    $randomFileListEmpty.Add($this.songFileList.Get($i))
                }
            }
            $this.songFileList = $randomFileListEmpty
            $this.songFileList =  $this.songFileList | Get-Random -Count $this.songFileList.Count
            $this.playSongDebug($randomFileList)
            $this.songFileList = $randomFileList
            $this.songFileList | Out-File "bin/tmp/random$playlistName.m3u"
            $this.songFileList = Get-Content "bin/tmp/random$playlistName.m3u"
            & $this.vlc --one-instance  -I dummy --dummy-quiet --global-key-next=Down --global-key-prev=Up --global-key-play-pause=Space --global-key-jump-short=Left --global-key-jump+short=Right --global-key-vol-up=Alt-Up --global-key-vol-down=Alt-Down "bin\tmp\random$playlistName.m3u"
        } elseif ($option -eq "next") {
            $this.songFileList = (Get-Content "bin/playlist/$playlistName.m3u")  
            & $this.vlc --one-instance  -I dummy --dummy-quiet --global-key-next=Down --global-key-prev=Up --global-key-play-pause=Space --global-key-jump-short=Left --global-key-jump+short=Right --global-key-vol-up=Alt-Up --global-key-vol-down=Alt-Down "bin\playlist\$playlistName.m3u"
        } elseif ($option -eq "loop") {
            & $this.vlc --one-instance  -I dummy --dummy-quiet --global-key-next=Down --global-key-prev=Up --global-key-play-pause=Space --global-key-jump-short=Left --global-key-jump+short=Right --global-key-vol-up=Alt-Up --global-key-vol-down=Alt-Down --loop "bin\songs\$playlistName.mp3"
        }
    }

    ##Support for video playlist files
    playVideoPlaylist($option, $playlistName){

        $randomFileListEmpty = New-Object System.Collections.ArrayList
        $randomFileList = New-Object System.Collections.ArrayList


        if ($option -eq "random") {
            $this.videoFileList = (Get-Content "bin/vplaylist/$playlistName.m3u")
            for ($i = 0; $i -lt $this.videoFileList.Count; $i++) {
                if ($i -ne 0) {
                    $randomFileListEmpty.Add($this.videoFileList.Get($i))
                }
            }
            $this.videoFileList = $randomFileListEmpty
            $this.videoFileList =  $this.videoFileList | Get-Random -Count $this.videoFileList.Count
            $this.playVideoDebug($randomFileList)
            $this.videoFileList = $randomFileList
            $this.videoFileList | Out-File "bin/tmp/random$playlistName.m3u"
            $this.videoFileList = Get-Content "bin/tmp/random$playlistName.m3u"
            & $this.vlc --one-instance -I dummy --dummy-quiet --meta-title="$playlistName" --global-key-next=Down --global-key-prev=Up --global-key-play-pause=Space --global-key-jump-short=Left --global-key-jump+short=Right --global-key-vol-up=Alt-Up --global-key-vol-down=Alt-Down --global-key-quit=z --global-key-toggle-fullscreen=Esc "bin\tmp\random$playlistName.m3u"
        } elseif ($option -eq "next") {
            $this.videoFileList = (Get-Content "bin/vplaylist/$playlistName.m3u")  
            & $this.vlc --one-instance -I dummy --dummy-quiet --meta-title="$playlistName" --global-key-next=Down --global-key-prev=Up --global-key-play-pause=Space --global-key-jump-short=Left --global-key-jump+short=Right --global-key-vol-up=Alt-Up --global-key-vol-down=Alt-Down --global-key-quit=z --global-key-toggle-fullscreen=Esc "bin\vplaylist\$playlistName.m3u"
        } elseif ($option -eq "loop") {
            & $this.vlc --one-instance -I dummy --dummy-quiet --meta-title="$playlistName" --global-key-next=Down --global-key-prev=Up --global-key-play-pause=Space --global-key-jump-short=Left --global-key-jump+short=Right --global-key-vol-up=Alt-Up --global-key-vol-down=Alt-Down --global-key-quit=z --global-key-toggle-fullscreen=Esc --loop "bin\videos\$playlistName.mp4"
        }
    }


    #/
    #   Menu functions
    #/
    showMain($selection){
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " Main menu                                                                    "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playMusic") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewLine; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Music                                                                       "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Music                                                                       "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playVideo") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Video                                                                       "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Video                                                                       "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "        
    }

    showPlayMusic($selection){
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " Main menu > Music                                                            "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playSong") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewLine; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Play song                                                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Play song                                                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "addSong") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Add Song                                                                    "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Add Song                                                                    "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playPlaylist") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  My Playlists                                                                "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  My Playlists                                                                "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "        
    }

    showMyPlaylists($selection){
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " Main menu > Music > My playlists                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playPlaylist") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewLine; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  View playlist                                                               "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  View playlist                                                               "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "createPlayList") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Create playlist                                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Create playlist                                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "        
    }

    showPlayPlaylist(){
        $exit = $false
        $option = ""
        $playlistsFiles = (Get-ChildItem -Path "bin\playlist")
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Back [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                                      "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  PLAYLISTS                                                                       "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Please select one option below                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " All playlists                                                                "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            for ($i = 0; $i -lt $playlistsFiles.Count; $i++) {
                $playlistPositionString = $this.alignItem(($i+1).ToString(),3);
                $playlistName =  $this.alignItem((Split-Path $playlistsFiles.Get($i) -leaf).Substring(0,(Split-Path $playlistsFiles.Get($i) -leaf).Length-4),69) 
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $playlistPositionString - $playlistName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "           
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = Read-Host "Enter the number of the playlist"
            if ($option -eq "z") {
                $exit = $true
            } else {
                try {
                    $option = [int]$option -1
                    $this.showPlaylistMode((Split-Path $playlistsFiles.Get($option) -leaf), $playlistsFiles.Get($option))
                }
                catch {
                    
                }
            }   
        }
    }        

    showPlayPlaylistOption($selection,$isUserPlaylist){
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playNext") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewLine; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Play next                                                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Play next                                                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playRandom") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Play random                                                                 "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Play random                                                                 "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($isUserPlaylist) {
            if ($selection -eq "deletePlaylist") {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Delete playlist                                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            } else {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Delete playlist                                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
            }
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        }

        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "        
    }

    showPlaylistMode($playlistName, $playlistPath){
        $playlistNameString = $this.alignItem($playlistName.Substring(0, $playlistName.Length-4), 77)
        if ($playlistName -eq "All songs.m3u" -or $playListName -eq "Imagix Selection.m3u") {
            $isUserPlaylist = $false
        } else {
            $isUserPlaylist = $true
        }
        $exit = $false
        $option = ""
        $selection = "playNext"
        $help = $false
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Back [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                          " -NonewLine;        
            if ($help) {
                Write-Host -ForegroundColor Black -BackgroundColor Yellow " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            } else {
                Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  PLAYLISTS                                                                       "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Please select one option below                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " $playlistNameString"-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            $this.showPlayPlaylistOption($selection, $isUserPlaylist)
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Controls                                                                        "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            if ($help) {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                                 Up- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[W]                                      " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                  Left- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[A]                       [D]"-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black " -Right                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                               Down- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[S]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "         Select- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[X]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "  
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                
            } else {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                     [W]                                      " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                        [A]                       [D]                         "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                     [S]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                 [X]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "             
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = [System.Console]::ReadKey().Key
            switch ($option) {
                h { 
                    if (!$help) {
                        $help = $true
                    } else {
                        $help = $false
                    }
                 }
                w {
                    if ($isUserPlaylist) {
                        if ($selection -eq "playNext") {
                            $selection = "deletePlaylist"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "playNext"
                        } elseif ($selection -eq "deletePlaylist") {
                            $selection = "playRandom"
                        }
                    } else {
                        if ($selection -eq "playNext") {
                            $selection = "playRandom"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "playNext"
                        }  
                    }

                }
                s { 
                    if ($isUserPlaylist) {
                        if ($selection -eq "playNext") {
                            $selection = "playRandom"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "deletePlaylist"
                        } elseif ($selection -eq "deletePlaylist") {
                            $selection = "playNext"
                        }
                    } else {
                        if ($selection -eq "playNext") {
                            $selection = "playRandom"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "playNext"
                        }
                    }

                }
                x { 
                    if ($selection -eq "playNext") {
                        $this.playSongPlaylist("next", $playlistName.Substring(0,$playlistName.Length-4))
                        $this.showCurrentSong($true, $playListName)
                    } elseif ($selection -eq "playRandom") {
                        $this.playSongPlaylist("random", $playlistName.Substring(0,$playlistName.Length-4))
                        $this.showCurrentSong($true, $playListName)
                    } elseif ($selection -eq "deletePlaylist") {
                        Remove-Item "bin/playlist/$playlistPath"
                        $this.showMenu("myPlaylists", "playPlaylist")
                    }
                }
                z { 
                    $exit = $true
                }
                Default {}
            }
        }
    }

    showVideoMenu($selection){
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " Main menu > Video                                                            "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "playVideo") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewLine; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Play video                                                                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Play video                                                                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        if ($selection -eq "addVideo") {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -ForegroundColor Green -BackgroundColor DarkBlue "  Add Video                                                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        } else {
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "  Add Video                                                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "   
        }
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "        
    
    }
    
    showPlayVideo(){
        $exit = $false
        $option = ""
        $videoFiles = (Get-ChildItem -Path "bin\videos")
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Back [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                                      "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  VIDEOS                                                                          "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Please select one option below                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " All videos                                                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  0   - All Videos                                                            "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "            
            for ($i = 0; $i -lt $videoFiles.Count; $i++) {
                $videoPositionString = $this.alignItem(($i+1).ToString(),3);
                $videoName =  $this.alignItem((Split-Path $videoFiles.Get($i) -leaf).Substring(0,(Split-Path $videoFiles.Get($i) -leaf).Length-4),69) 
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $videoPositionString - $videoName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "           
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = Read-Host "Enter the number of a video"
            if ($option -eq "z") {
                $exit = $true
            } else {
                try {
                    $option = [int]$option -1
                    if ($option -eq -1) {
                        $this.showPlaylistVideoMode("All Videos.m3u", "bin\vplaylist\All Videos.m3u")
                    } else {
                        $this.playVideoPlaylist("loop",(Split-Path $videoFiles.Get($option) -leaf).Substring(0, (Split-Path $videoFiles.Get($option) -leaf).Length-4))
                        $this.showCurrentSong($false, (Split-Path $videoFiles.Get($option) -leaf))
                    }
                }
                catch {
                    
                }
            }   
        }
    }

    showPlaylistVideoMode($playlistName, $playlistPath){
        $playlistNameString = $this.alignItem($playlistName.Substring(0, $playlistName.Length-4), 77)
        if ($playlistName -eq "All videos.m3u") {
            $isUserPlaylist = $false
        } else {
            $isUserPlaylist = $true
        }
        $exit = $false
        $option = ""
        $selection = "playNext"
        $help = $false
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Back [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                          " -NonewLine;        
            if ($help) {
                Write-Host -ForegroundColor Black -BackgroundColor Yellow " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            } else {
                Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  PLAYLISTS                                                                       "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Please select one option below                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " $playlistNameString"-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            $this.showPlayPlaylistOption($selection, $isUserPlaylist)
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Controls                                                                        "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            if ($help) {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                                 Up- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[W]                                      " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                  Left- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[A]                       [D]"-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black " -Right                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                               Down- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[S]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "         Select- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[X]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "  
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                
            } else {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                     [W]                                      " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                        [A]                       [D]                         "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                     [S]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                 [X]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "             
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = [System.Console]::ReadKey().Key
            switch ($option) {
                h { 
                    if (!$help) {
                        $help = $true
                    } else {
                        $help = $false
                    }
                 }
                w {
                    if ($isUserPlaylist) {
                        if ($selection -eq "playNext") {
                            $selection = "deletePlaylist"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "playNext"
                        } elseif ($selection -eq "deletePlaylist") {
                            $selection = "playRandom"
                        }
                    } else {
                        if ($selection -eq "playNext") {
                            $selection = "playRandom"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "playNext"
                        }  
                    }

                }
                s { 
                    if ($isUserPlaylist) {
                        if ($selection -eq "playNext") {
                            $selection = "playRandom"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "deletePlaylist"
                        } elseif ($selection -eq "deletePlaylist") {
                            $selection = "playNext"
                        }
                    } else {
                        if ($selection -eq "playNext") {
                            $selection = "playRandom"
                        } elseif ($selection -eq "playRandom") {
                            $selection = "playNext"
                        }
                    }

                }
                x { 
                    if ($selection -eq "playNext") {
                        $this.playVideoPlaylist("next", $playlistName.Substring(0,$playlistName.Length-4))
                        $this.showCurrentSong($true, $playListName)
                    } elseif ($selection -eq "playRandom") {
                        $this.playVideoPlaylist("random", $playlistName.Substring(0,$playlistName.Length-4))
                        $this.showCurrentSong($true, $playListName)
                    } elseif ($selection -eq "deletePlaylist") {
                        Remove-Item "bin/playlist/$playlistPath"
                        $this.showMenu("playVideo", "playVideo")
                    }
                }
                z { 
                    $exit = $true
                }
                Default {}
            }
        }
    }

    ##This is the Menu Root Father, from it, the program shows all diferent sections
    showMenu($menu, $selection){
        $exit = $false
        $option = ""
        $help = $false
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            if ($menu -eq "main") {
                Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Exit [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                          " -NonewLine; 
            } else {
                Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Back [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                          " -NonewLine;        
            }
            if ($help) {
                Write-Host -ForegroundColor Black -BackgroundColor Yellow " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            } else {
                Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  MAIN MENU                                                                       "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Please select one option below                                                  "
            if ($menu -eq "main") {
                $this.showMain($selection)
            } elseif ($menu -eq "playMusic") {
                $this.showPlayMusic($selection)
            } elseif ($menu -eq "myPlaylists") {
                $this.showMyPlaylists($selection)
            } elseif ($menu -eq "playVideo") {
                $this.showVideoMenu($selection)
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Controls                                                                        "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            if ($help) {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                                 Up- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[W]                                      " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                  Left- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[A]                       [D]"-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black " -Right                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                               Down- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[S]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "         Select- "-NoNewLine; Write-host -ForegroundColor DarkBlue -BackgroundColor Gray "[X]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "  
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                
            } else {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                     [W]                                      " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                        [A]                       [D]                         "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                     [S]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                 [X]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "             
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = [System.Console]::ReadKey().Key
            switch ($option) {
                h { 
                    if (!$help) {
                        $help = $true
                    } else {
                        $help = $false
                    }
                 }
                w { 
                    if ($menu -eq "main") {
                        if ($selection -eq "playMusic") {
                            $selection = "playVideo"
                        } elseif ($selection -eq "playVideo") {
                            $selection = "playMusic"
                        }
                    } elseif ($menu -eq "playMusic") {
                        if ($selection -eq "playSong") {
                            $selection = "playPlaylist"
                        } elseif ($selection -eq "addSong") {
                            $selection = "playSong"
                        } elseif ($selection -eq "playPlaylist") {
                            $selection = "addSong"
                        }
                    }  elseif ($menu -eq "myPlaylists") {
                        if ($selection -eq "playPlaylist") {
                            $selection = "createPlaylist"
                        } elseif ($selection -eq "createPlaylist") {
                            $selection = "playPlaylist"
                        }
                    } elseif ($menu -eq "playVideo") {
                        if ($selection -eq "playVideo") {
                            $selection = "addVideo"
                        } elseif ($selection -eq "addVideo") {
                            $selection = "playVideo"
                        }
                    }
                }
                s { 
                    if ($menu -eq "main") {
                        if ($selection -eq "playMusic") {
                            $selection = "playVideo"
                        } elseif ($selection -eq "playVideo") {
                            $selection = "playMusic"
                        }
                    } elseif ($menu -eq "playMusic") {
                        if ($selection -eq "playSong") {
                            $selection = "addSong"
                        } elseif ($selection -eq "addSong") {
                            $selection = "playPlaylist"
                        } elseif ($selection -eq "playPlaylist") {
                            $selection = "playSong"
                        }
                    } elseif ($menu -eq "myPlaylists") {
                        if ($selection -eq "playPlaylist") {
                            $selection = "createPlaylist"
                        } elseif ($selection -eq "createPlaylist") {
                            $selection = "playPlaylist"
                        }
                    } elseif ($menu -eq "playVideo") {
                        if ($selection -eq "playVideo") {
                            $selection = "addVideo"
                        } elseif ($selection -eq "addVideo") {
                            $selection = "playVideo"
                        }
                    }
                }
                x { 
                    if ($menu -eq "main") {
                        if ($selection -eq "playMusic") {
                            $menu = "playMusic"
                            $selection = "playSong"
                        } elseif ($selection -eq "playVideo") {
                            $menu = "playVideo"
                            $selection = "playVideo"
                        }
                    } elseif ($menu -eq "playMusic") {
                        if ($selection -eq "playSong") {
                            $this.showPlaySong()
                        } elseif ($selection -eq "addSong") {
                            $this.showAddSong()
                        } elseif ($selection -eq "playPlaylist") {
                            $menu = "myPlaylists"
                        }
                    } elseif ($menu -eq "myPlaylists") {
                        if ($selection -eq "playPlaylist") {
                            $this.showPlayPlaylist()
                        } elseif ($selection -eq "createPlaylist") {
                            $this.createPlaylist()
                        }
                    } elseif ($menu -eq "playVideo") {
                        if ($selection -eq "playVideo") {
                            $this.showPlayVideo()
                        } elseif ($selection -eq "addVideo") {
                            $this.showAddVideo()
                        }
                    }
                }
                z { 
                    if ($menu -eq "main") {
                        $exit = $true
                        exit
                    } elseif ($menu -eq "playMusic") {
                        $menu = "main"
                        $selection = "playMusic"
                    } elseif ($menu -eq "myPlaylists") {
                        $menu = "playMusic"
                        $selection = "playPlaylist"
                    } elseif ($menu -eq "playVideo") {
                        $menu = "main"
                        $selection = "playVideo"
                    }
                }
                Default {}
            }
        }
    }

    showCurrentSong($isPlaylist, $playlistName){
        $option = ""
        $playlistNameString = $this.alignItem($playlistName.Substring(0, $playlistName.Length-4), 61)
        $help = $false
        while ($option -ne "z"){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Exit [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                          " -NonewLine; 
            if ($help) {
                Write-Host -ForegroundColor Black -BackgroundColor Yellow " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            } else {
                Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            if ($isPlaylist) {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Current Playlist : "-NoNewline; Write-Host -BackgroundColor DarkGray -ForegroundColor Black "$playlistNameString"
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                if ($playListName -eq "All Videos.m3u") {
                    for ($i = 0; $i -lt $this.videoFileList.Count; $i++) {
                        if ($i -ne 0) {
                            $videoName =  $this.alignItem((Split-Path $this.videoFileList.Get($i) -leaf),75) 
                            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $videoName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                        }
                    }                     
                } else {
                    
                    for ($i = 0; $i -lt $this.songFileList.Count; $i++) {
                        if ($i -ne 0) {
                            $songName =  $this.alignItem((Split-Path $this.songFileList.Get($i) -leaf),75) 
                            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $songName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                        }
                    }                  }
              
            } else {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Playing song  (Loop mode)                                                       "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                $songName =  $this.alignItem($playlistName.Substring(0, $playlistName.Length-4), 75) 
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $songName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
            }
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Controls                                                                        "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            
            if ($playListName -eq "All Videos.m3u") {
                if ($help) {
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Esc]"-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor Black " -Fullscreen   Previous -"-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue " [Up]                                       " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "              -5s - "-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "[Left]        [Space]        [Right]"-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor Black " +5s                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                                     ^                                        "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                                 Play/Pause                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                           Next - "-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "[Down]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "      Volume - "-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "[Alt]"-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor Black " + [Up]/[Down]                                            "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                
                } else {
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Esc]                          [Up]                                       " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                    [Left]        [Space]        [Right]                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                  [Down]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "               [Alt]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "             
                }
            } else {
                if ($help) {
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                        Previous -"-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue " [Up]                                       " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "              -5s - "-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "[Left]        [Space]        [Right]"-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor Black " +5s                  "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                                     ^                                        "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                                 Play/Pause                                   "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "                           Next - "-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "[Down]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black "      Volume - "-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "[Alt]"-NoNewLine; Write-Host -BackgroundColor Gray -ForegroundColor Black " + [Up]/[Down]                                            "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                
                } else {
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                   [Up]                                       " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                    [Left]        [Space]        [Right]                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                  [Down]                                      "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "               [Alt]                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                    Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "             
                }
            }          

            Write-Host -BackgroundColor DarkGray "                                                                                  "
            $option = [System.Console]::ReadKey().Key
            switch ($option) {
                h { 
                    if (!$help) {
                        $help = $true
                    } else {
                        $help = $false
                    }
                 }
                z {
                    if ($playlistName -like "*.mp4" -or $playlistName -like "*All Videos*") {
                        $this.showMenu("playVideo","playVideo")
                    } else {
                        Stop-Process -Name "vlc" -Force
                        if ($isPlaylist) {
                            $this.showMenu("myPlaylists", "playPlaylist")
                        } else {
                            $this.showMenu("playMusic", "playSong")
                        } 
                    }
                   
                }
                Default {}
            }
        }
    }

    createPlaylist(){
        $option = ""
        $playlistName = ""
        $playlistNameString = $this.alignItem($playlistName,64)
        $playlistNameString2 = $this.alignItem($playlistName,66)
        $this.songFileList = (Get-ChildItem -Path "bin\songs").FullName
        $songFileListShow = $this.songFileList
        $newSongFileList = New-Object System.Collections.ArrayList

        $help = $false
        while ($option -ne "z"){
            while(($playlistName -eq "")){
                Clear-Host
                Write-Host ""
                Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
                Write-Host -BackgroundColor DarkGray "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Enter a name for the new playlist" -NoNewline
                $playlistName = Read-Host
                $playlistNameString = $this.alignItem($playlistName,64)
                $playlistNameString2 = $this.alignItem($playlistName,71)
            }
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            if ($playlistName -ne "") {
                Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Exit [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                          " -NonewLine; 
                if ($help) {
                    Write-Host -ForegroundColor Black -BackgroundColor Yellow " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
                } else {
                    Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Help [H] " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkGray "  "
                }   
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "  Playlist name : " -NoNewline; Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "$playlistNameString"
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  All songs                                                                       "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "

            for ($i = 0; $i -lt $songFileListShow.Count; $i++) {
                $songPositionString = $this.alignItem(($i+1).ToString(),3);
                $songName =  $this.alignItem((Split-Path $songFileListShow.Get($i) -leaf),69) 
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $songPositionString - $songName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Songs in " -NoNewLine; Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "$playlistNameString2"
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "

            for ($i = 0; $i -lt $newSongFileList.Count; $i++) {
                $songPositionString = $this.alignItem(($i+1).ToString(),3);
                $songName =  $this.alignItem((Split-Path $newSongFileList.Get($i) -leaf),69) 
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $songPositionString - $songName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "

            }
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            
            
            
            
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Controls                                                                        "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            if ($help) {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Add songs]"-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black " Enter a number to add a song into the playlist                " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Delete songs]"-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black " Just enter a number preceded by '-' to delete it           "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Exit without saving]"-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black " Enter key [Z]                                       "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Save and exit]"-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor Black " Enter key [O]                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "               
            } else {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Add songs]                                                               "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Delete songs]                                                            "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Exit without saving]                                                     "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "    [Save and exit]                                                           "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "             
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            
            $option = Read-Host "Enter a song number or any command key "
            try {
                if ($option.ToLower() -eq "h") {
                    if ($help) {
                        $help = $false
                    } else {
                        $help = $true
                    }
                } elseif($option.toLower() -eq "z"){
                    ##Show main menu


                } elseif($option.ToLower() -eq "o"){
                    $buggedFilelist = New-Object System.Collections.ArrayList
                    $this.songFileList = $newSongFileList
                    $this.playSongDebug($buggedFilelist)
                    $this.songFileList = $buggedFilelist
                    $this.songFileList | Out-File "bin/playlist/$playListName.m3u"
                    ##Show created playlist successfully
                    $this.showPlaylistSuccess($playListName, $newSongFileList.Count)
                    
                } elseif($option.StartsWith("-")){
                    $updatedNewSongFileList = New-Object System.Collections.ArrayList
                    $option = $option.substring(1)
                    $option = [int]$option -1
                    for ($i = 0; $i -lt $newSongFileList.Count; $i++) {
                        if ($option -ne $i) {
                            $updatedNewSongFileList += $newSongFileList.Get($i)
                        }
                    }
                    $newSongFileList = $updatedNewSongFileList
                } else {
                    $option = [int]$option -1
                    $newSongFileList += ($songFileListShow.Get($option))
                }
            }
            catch {
                
            }
   
        }
    }

    showPlaylistSuccess($playListName, $totalSongs){
        $option = ""
        $playlistNameString = $this.alignItem($playlistName,64)
        $totalSongsString = $this.alignItem($totalSongs,64)

        while ($option -ne "z"){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "                          Playlist successfully created                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Playlist name : "-NonewLine; Write-Host -BackgroundColor DarkGray -ForegroundColor DarkBlue "$playlistNameString"
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "    Total songs : "-NoNewline; Write-Host -BackgroundColor DarkGray -ForegroundColor DarkBlue "$totalSongsString"
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "     "-NoNewline; Write-Host -BackgroundColor DarkBlue -ForegroundColor White "Exit[Z]"-NoNewline; Write-Host -BackgroundColor DarkGray "                                                           "-NoNewline; Write-Host -BackgroundColor DarkBlue -ForegroundColor White "Play[X]"-NoNewline; Write-Host -BackgroundColor DarkGray "    "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            
            $option = [System.Console]::ReadKey().Key
            switch ($option) {
                x { 
                    $this.playSongPlaylist("next", $playlistName)
                    $this.showCurrentSong($true, "$playlistName.m3u")
                 }
                z { 
                    $this.showMenu("myPlaylists", "playPlaylist")
                 }
                Default {}
            }
   
        }
    }

    showPlaySong(){
        $exit = $false
        $option = ""
        $songFiles = (Get-ChildItem -Path "bin\songs")
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "  " -NonewLine; Write-Host -ForegroundColor White -BackgroundColor DarkBlue " Back [Z] " -NoNewline; Write-Host -BackgroundColor DarkGray "                                                                      "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  SONGS                                                                           "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Please select one option below                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow " All songs                                                                    "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  0   - All Songs                                                             "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "            
            for ($i = 0; $i -lt $songFiles.Count; $i++) {
                $songPositionString = $this.alignItem(($i+1).ToString(),3);
                $songName =  $this.alignItem((Split-Path $songFiles.Get($i) -leaf).Substring(0,(Split-Path $songFiles.Get($i) -leaf).Length-4),69) 
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Green "  $songPositionString - $songName " -NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            }
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "           
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = Read-Host "Enter the number of a song"
            if ($option -eq "z") {
                $exit = $true
            } else {
                try {
                    $option = [int]$option -1
                    if ($option -eq -1) {
                        $this.showPlaylistMode("All Songs.m3u", "bin\playlist\All songs.m3u")
                    } else {
                        $this.playSongPlaylist("loop", (Split-Path $songFiles.Get($option) -leaf).Substring(0, (Split-Path $songFiles.Get($option) -leaf).Length-4))
                        $this.showCurrentSong($false, (Split-Path $songFiles.Get($option) -leaf))
                    }
                }
                catch {
                    
                }
            }   
        }
    }

    showAddSong(){
        $FilePath = $this.SelectFile()
        $success = "yes"
        if ($FilePath -eq "no") {
            $success = "cancel"
        } elseif ((Split-Path $FilePath -leaf) -like "*.mp3") {
            $success = "yes"
            Copy-Item -Path $FilePath -Destination "bin\songs"
        } else {
            $success = "fileError"
        }
        $exit = $false
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  ADD SONG                                                                        "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Adding a new song into IPTV                                                     "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            if ($success -eq "cancel") {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Red " Operation cancelled                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "                            Enter any key to continue                             "

            } elseif ($success -eq "fileError") {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Red " This is not a valid mp3 file                                                 "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "  
                Write-Host -BackgroundColor DarkGray "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "                            Enter any key to continue                             "
                
            } elseif ($success -eq "yes") {
                $FileNameString = $this.alignItem((Split-Path $FilePath -leaf).Substring(0,(Split-Path $FilePath -leaf).Length-4),64)
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray "  "-NoNewLine; Write-Host -BackgroundColor Black -ForegroundColor Magenta " Added song : "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Blue "$FileNameString"-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "                            Enter any key to continue                             "
                                
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = [System.Console]::ReadKey().Key
            switch ($option) {
                default { 
                    $exit = $true
                 }
            }
        }
    }

    showAddVideo(){
        $FilePath = $this.SelectFileVideo()
        $success = "yes"
        if ($FilePath -eq "no") {
            $success = "cancel"
        } elseif ((Split-Path $FilePath -leaf) -like "*.mp4") {
            $success = "yes"
            Copy-Item -Path $FilePath -Destination "bin\videos"
        } else {
            $success = "fileError"
        }
        $exit = $false
        while ($exit -eq $false){
            Clear-Host
            Write-Host ""
            Write-Host -BackgroundColor Black "                            Imagix Looper Terminal v1.0                           "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                 IMAGIX LOOPER                                    "
            Write-Host -BackgroundColor DarkGray -ForegroundColor DarkMagenta "                           Powershell terminal version                            "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  ADD VIDEO                                                                       "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  Adding a new video into IPTV                                                    "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            if ($success -eq "cancel") {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Red " Operation cancelled                                                          "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "                            Enter any key to continue                             "

            } elseif ($success -eq "fileError") {
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Red " This is not a valid mp4 file                                                 "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "  
                Write-Host -BackgroundColor DarkGray "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "                            Enter any key to continue                             "
                
            } elseif ($success -eq "yes") {
                $FileNameString = $this.alignItem((Split-Path $FilePath -leaf).Substring(0,(Split-Path $FilePath -leaf).Length-4),63)
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray "  "-NoNewLine; Write-Host -BackgroundColor Black -ForegroundColor Magenta " Added video : "-NoNewline; Write-Host -BackgroundColor Black -ForegroundColor Blue "$FileNameString"-NoNewline; Write-Host -BackgroundColor DarkGray "  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Black "  "-NoNewline; Write-Host -BackgroundColor Black "                                                                              "-NoNewline; Write-Host -BackgroundColor DarkGray "  "                       
                Write-Host -BackgroundColor DarkGray "                                                                                  "
                Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "                            Enter any key to continue                             "
                                
            }
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            Write-Host -BackgroundColor DarkGray -ForegroundColor Black "                                                                                  "
            Write-Host -BackgroundColor DarkGray "                                                                                  "

            $option = [System.Console]::ReadKey().Key
            switch ($option) {
                default { 
                    $exit = $true
                 }
            }
        }
    }

    #/
    # C# Support
    #/
    [string]SelectFile(){
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
            InitialDirectory = [Environment]::GetFolderPath('Desktop') 
            Filter = 'Documents (*.mp3)|*.mp3'
            Title = 'Choose one song to add it into IPTV'
            FileName = 'Any File'
        }
        $option = $FileBrowser.ShowDialog()

        if ($option -eq "OK") {
            $FilePath = $FileBrowser.FileName
        } else {
            $FilePath = "no"
        }
        return $FilePath
    }

    [string]SelectFileVideo(){
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
            InitialDirectory = [Environment]::GetFolderPath('Desktop') 
            Filter = 'Documents (*.mp4)|*.mp4'
            Title = 'Choose one video to add it into IPTV'
            FileName = 'Any File'
        }
        $option = $FileBrowser.ShowDialog()

        if ($option -eq "OK") {
            $FilePath = $FileBrowser.FileName
        } else {
            $FilePath = "no"
        }
        return $FilePath
    }

    [string]SelectVlcPath(){
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
            InitialDirectory = [Environment]::GetFolderPath('Desktop') 
            Filter = 'Documents (*.exe)|*.exe'
            Title = 'Select your vlc.exe file location'
            FileName = 'vlc.exe'
        }
        $option = $FileBrowser.ShowDialog()

        if ($option -eq "OK") {
            $FilePath = $FileBrowser.FileName
        } else {
            $FilePath = "no"
        }
        return $FilePath
    }


    #/
    #   View functions
    #/
    [string]alignItem($item,$margin) {
        $itemLength = $item.length
        $totalSpaces = $margin - $itemLength
        $FinalString = $item
        for ($i = 0; $i -lt $totalSpaces; $i++){
            $FinalString = "$FinalString "
        }
        return $FinalString
    }

}



##Event for making Powershell close vlc when exit
Register-EngineEvent PowerShell.Exiting -Action {
    if (Get-Process vlc -ErrorAction SilentlyContinue) {
        Stop-Process -Name "vlc" -Force
    }
}


#@Test
##For creating a random playlist
#$il = New-Object ImagixLooper
#$il.playSongPlaylist("random")
#$il.showCurrentSong()


$Host.UI.RawUI.BackgroundColor = ('DarkBlue')
$Host.UI.RawUI.ForegroundColor = ('White')
$host.UI.RawUI.WindowTitle = "Imagix Looper - Powershell Terminal Version"

$il = New-Object ImagixLooper
$il.addCpath()
$il.checkFirstTime()
$il.checkVlc()
$il.createDefaultPlaylists()
##$il.SelectFile()
$il.showMenu("main", "playMusic")
