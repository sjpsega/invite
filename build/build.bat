set flashlib="D:\Program Files\FlashDevelop\Tools\fdbuild\fdbuild.exe "
set compiler="D:\Program Files\Adobe\Adobe Flash Builder 4 Plug-in\sdks\4.1.0"
set lib="D:\Program Files\FlashDevelop\Library"

%flashlib% "firstView.as3proj" -compiler %compiler% -notrace -library %lib% 
%flashlib% "invite.as3proj" -compiler %compiler% -notrace -library %lib% 

pause