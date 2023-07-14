import QtQuick
import QtQuick.Window
import QtMultimedia
import QtQuick.Dialogs


//The program is a mediaplayer that will let you play any video.
//Tap on the folder icon in the bottom right corner to open the video file.
//Clicking on the play/pause button or on the video or pressing space key can pause or play the video
//Pressing the arrow keys can seek forwards or backwards
//Additionally, clicking anywhere on the seekline will help fast forward the video to that position
//Or, you can click on the seeker and drag them anywhere on the line to play the video from the dragged position.
//Double click to go in and out of fullscreen.
//Press play again after video ends to play the same video again

Window { //Main Window
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Media Player Test Code")
    color:"black"
    property int durationms: mediaPlayer.duration
    property int positionms: mediaPlayer.position
    property int seekpos: positionms/durationms

    FileDialog{ //File opener
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
                            mediaPlayer.stop()
                            mediaPlayer.source = fileDialog.currentFile
                            mediaPlayer.play()
                    }
    }

    MediaPlayer{ //Media Player which plays videoOutput
        id : mediaPlayer
        videoOutput: video
        audioOutput: AudioOutput { //To play audio from video
            id: audio

        }


    }

    VideoOutput{
        id: video
        anchors.top: parent.top
        anchors.bottom: controls.top
        anchors.left: parent.left
        anchors.right: parent.right
        MouseArea{
            id: videoMouseArea
            anchors.fill: parent //Clicking on the video can pause or play it
            onClicked: mediaPlayer.playing ? mediaPlayer.pause() : mediaPlayer.play()
            onDoubleClicked: {
                if (mainWindow.visibility===2){ //to initiate fullscreen or windowed
                    mainWindow.showFullScreen()
                    mediaPlayer.play()
                }
                else{
                    mainWindow.visibility=2
                    mediaPlayer.play()
                }
            }
        }
        Keys.onPressed: (event) =>{
                            if(event.key === Qt.Key_Space){ // Press space bar to pause
                                if (mediaPlayer.playing){
                                    mediaPlayer.pause()
                                }
                                else{
                                    mediaPlayer.play()
                                }
                            }
                            if (event.key=== Qt.Key_Right){
                                mediaPlayer.setPosition(positionms+2000)
                            }   //Press left or right to seek forwards or backwards
                            if (event.key=== Qt.Key_Left){
                                mediaPlayer.setPosition(positionms-2000)
                            }
                        }
        focus: true
    }


    Rectangle{
        id: controls //Control centre
        width: parent.width
        height: parent.height/7
        color: "black"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Text { // to show position and duration
            id: seconds
            text:  Math.round((positionms/1000)/120)+":"+Math.round((positionms/1000)%60)+" / "+Math.round((durationms/1000)/120)+":"+Math.round((durationms/1000)%60)
            color:"white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: seekLine.top


        }
        Image{ //File icon to open file
            id: openFile
            source:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHsAAAB7CAMAAABjGQ9NAAAAY1BMVEX///8AAABHR0dAQEDt7e2IiIg5OTnPz8+1tbX4+Pjm5uYYGBiPj49LS0tnZ2fX19elpaWfn59gYGAQEBDExMR3d3erq6sqKiowMDBTU1Pe3t4hISFwcHC9vb1ZWVmCgoKXl5d5WMTeAAADUElEQVRoge2aC5OqIBSAI81CLfNRPtoe//9XLlgmKwdEHu3OvXwzO7k5+InJOQd0tfJ4PB6P518D5+1ak3YTGqnjNTLg0pm4CxM1Qnusr+5KhMq95jUnbVGm796S5rtfaWzYPPNu7/7rbtxTfd4dp/ugp/m4uyrZuPhRd/UzJr+a4zxV4zFkLw03jkib8utEKcbmgXICCbC2m3a75U9dPXldQm13zqQfZowd6zJRobzk/ImrsiFNhp+MHd9hrMa7WLHoXox3/3/uR9YT/4b7RXmrTNzd6aDIlncTcsil6K6V41rDxDWGq767hDQgNeO+7yhnmhcahXmCwF21670K63b4adn7/ES2FX5y0b2GVRkOxLrp9lnfvRjWHZLto3d7t3d7twV3xySQ0CSu4d0hiJZBJ3P18A+7/aTN+eU30J1FymlMnWar4s7mDqNHNE2rgBvf+tMMrEIPOa0nADf9iIzWJwHorZjOu+/kw7a6P/a0iOPdmFyf2rZ69UB8KcO76Z22se6OxqpS4j4CZ2gMjTaH6Ze8m97lBovRMGcEhEzOHV4QutlWrw5ktsJNlabuK10EUcgDy8Al1CHOTb8wWIOHoR16zLtJTmhsq1dwh6bulPzdbavxGpwkTd2BixHWwR2austxdmcPQciYuqEYYIwgZABuhWpnGTEJGQXwPeC2nsOugg7xbpOnezBf5KjQ+g/vtj/CaoQSaAfv5ko6U7aipMy5E+uXPBV1iHPbH2GkbLiAHeLc9keYsEOcW3VBUpkdVDaAbvtVIikbErhDXB6z7kbjAxmJOwfmDsZAhTngbl1UiZI6iHGHiYMqkc40AkGHGPfVRZUoKBum7pOLKlE202DcyEWVWEjuodGduchhcSKJ0qM7d1ElisqGifvmoko8yaL0240RXFQZQZ9wR8K9b7eTEZZJo/Tb7WSl4yGtgwY3blxUifR9OPHewd25WOmIS2kdNLidrHSIy4Yf7oLJZ9YAVxs4dyiYtphBZxqS3S+3k5UOSdnAuqXxR5d0JjE+3TTDX2yr6cNkUdnAuJ2sJVZzifGZvRQf3C4ibuYmd/18oH/SrvtiqoBAYYJl+C6uFNngpoTu5M1s9Yd3hd2r/aI4Wk9NHo/H4/H8Ab4BZg40mIYM8uMAAAAASUVORK5CYII="
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height:40
            MouseArea{
                anchors.fill: parent
                onPressed: fileDialog.open()
                    }
                }

        Rectangle{
            id: seekLine
            width: controls-controls/2
            height: 5
            color:"white"
            anchors.left: stop.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.right: openFile.left
            anchors.verticalCenter: parent.verticalCenter
            onWidthChanged: {
                seeker.x = (positionms/durationms)*seekLine.width       //To retain the position of our seeker when going in and out of full screen.
            }

            MouseArea{ // pressing anywhere on the seek line will play the video from that position

                anchors.fill: parent
                onPressed: mediaPlayer.setPosition((mouseX/parent.width)*mediaPlayer.duration)

                    }

            Rectangle{
                id: seeker
                height: 20
                width: 5
                color: "red"
                anchors.verticalCenter: parent.verticalCenter

                x: (positionms/durationms)*seekLine.width


                MouseArea   {   // implement dragging to seek through the video
                                    id: seekerDragArea
                                    anchors.fill: parent
                                    drag.target: parent
                                    drag.axis: Drag.XAxis
                                    drag.maximumX: seekLine.width
                                    drag.minimumX: 0 // so that seeker cannot be dragged out of seekline
                                    onReleased: {
                                        var newPosition = seeker.x / seekLine.width
                                        console.log(newPosition)
                                        mediaPlayer.setPosition(newPosition * mediaPlayer.duration)
                                    } //The video will start from new position depending on the x position of seeker
                                    onPressed: {
                                        var newPositionn = seeker.x / seekLine.width
                                        mediaPlayer.setPosition(newPositionn * mediaPlayer.duration)

                                    }

                            }

                                Connections
                                {
                                    target: mediaPlayer
                                    onPositionChanged: {

                                        if (!seekerDragArea.drag.active) {
                                            seeker.x = (positionms / durationms) * seekLine.width
                                            //update the position of seeker after dragging
                                        }
                                        else{
                                            var newPosition = seeker.x / seekLine.width
                                            mediaPlayer.setPosition(newPosition*mediaPlayer.duration)
                                            // This enables the user to see the video play as they seek forwards or backwards

                                            }

                                        }
                                }
                         }

            }



        Image {
            id: playpause
            source: mediaPlayer.playing ? "data:image/png;base64,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"
                                        : "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHoAAAB6CAMAAABHh7fWAAAAaVBMVEX///8AAAD8/PyPj4/Q0NDT09NSUlIREREXFxf09PT39/fIyMjx8fELCwtFRUU4ODiGhobAwMB9fX1tbW2rq6t2dnYoKCi2trbi4uJmZmaYmJjq6upKSkqenp6kpKTb29tbW1sfHx8vLy/BPq7NAAACH0lEQVRoge3b2ZaCMAwAUBBcWbTKCMri8v8fOc44BaTQZDgtRUmeeKC5FhBKSS27HtdzFMeMMY/HY5vFcVzkzslGxnZXRFFcy+H9poiKfHc41ne0atuH1JJEesDAoSfLYbFbKx1JGz3iDMunNZAjqTpe0QUkW9YX2OcNmMMV6WwG02uIlh/tZ+wEGjzcL83aY4XJkQr0HNOMyWkHk2MTNOkE08ztMP8iR9H8QlNKI67UB71t0tL/NI+5nEZdLzOB9jHNLirorElD9wJ19MJcrwUa1etEBX3t1WuAjvvRqF6nHeZ/aKsnHXSgz2Bjp/mgQ+kB10n75nqthOYDrWnTgQoaMz4S6RU8oFNF88GlUhp3wPvRax29vpmjj8PRe6LN0lsUvVkqoPnbE9FEt8dMTrvvRoeI+QxFtEM00ZOiFypo1Nwb0e9BA08urb1eEU000UQTTTTRRBM9FtrksJDoD6Cn+X5NNNGfTY9+Uhp4chmkP/QDxKfR90l+0yR6YNpgmcToaS0lMUtz9DQrr6ZBv11tocliztHWkeos3NVTrqyiUlpnaboeehIF+cIyhOEWX4RN2uCSk+Hoe5O+YJp5cvqMovkbTEmjboKFnM4wOXy+d0mfMM3kc9K4s5YLNOYumLd6tUD8/qT8+RUdgHMCwJn+CfBs+1m5b32xJHC6I1i27b18ZJuE1a512r4WzO0IrwibSnvcHDbvyhG9LHn8BhC4NxkjXBI+AAAAAElFTkSuQmCC"
           // play or pause icon depending on the state of video (played or paused)
            width:30
            height:30
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: controls.verticalCenter

            MouseArea{
                anchors.fill: parent
                onPressed: mediaPlayer.playing ? mediaPlayer.pause(): mediaPlayer.play()
            }
        }

        Image {
            id: stop
            source: "https://www.kindpng.com/picc/m/7-73188_stop-frame-video-music-stop-button-icon-png.png"
            width: 30
            height: 30
            anchors.left: playpause.right
            anchors.leftMargin: 5
            anchors.verticalCenter: controls.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {mediaPlayer.stop()
                }

            }
        }

    }
}



