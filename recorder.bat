@echo off

:: Arguments: 
:: %1 - Url of webinar (https://global.gotowebinar.com/join/XXX/YYY)
:: %2 - Time to record video in seconds
:: %3 - Video quality - hd720 or hd1080 or hd480
:: %4 - Path for compressed file
:: %5 - size of compressed parts in Mb

:start_runner

SET hr=%time:~0,2%
if "%hr:~0,1%" equ " " set hr=0%hr:~1,1%
SET filename=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%hr%%time:~3,2%%time:~6,2%

START /b "c:\\Program Files (x86)\\Mozilla Firefox\\firefox.exe" %1 

TIMEOUT 30

tasklist /FI "IMAGENAME eq g2mui.exe" 2>NUL | find /I /N "g2mui.exe">NUL

if "%ERRORLEVEL%"=="0" ( 

echo Webinar is running 

"ffmpeg/bin/ffmpeg"  -loglevel info -t %2  -f dshow  -video_device_number 0 -i video="screen-capture-recorder"  -f dshow -audio_device_number 0 -i audio="virtual-audio-capturer"  -vcodec libx264 -pix_fmt yuv420p -s %3  -preset ultrafast -vsync vfr -acodec libmp3lame record_%filename%.flv 

"c:\Program Files\7-Zip\7z" a -t7z -v%5m -y %4\\record_%filename%.7z record_%filename%.flv 

) ELSE (goto:start_runner)

