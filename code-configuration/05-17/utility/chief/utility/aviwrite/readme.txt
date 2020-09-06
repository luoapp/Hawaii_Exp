Instructions for aviwrite.zip:

This file contains routines that can be used to create an .avi animation
on Windows computers from within MATLAB.

"getindexedframe.m" is used in a manner identical to that of MATLAB's 
"getframe" function.  It grabs an image from the current figure or from 
a user-specified figure or axis, and encodes the image using a color 
table.  This saves memory compared to getframe's truecolor RGB format, 
but limits the maximum number of colors to 256.

After recording a vector of indexed images using getindexedframe, the 
movie can be written to an .avi-format Windows animation file using 
"aviwrite.m".

After unzipping this archive in the directory of your choice, you may 
use "sinewavemovie.m" to test the functionality of getindexedframe, 
aviwrite, and the dynamic-link library (.dll) files they call.

This routine has been tested under MATLAB 5.3.

Please address comments and questions to Mike Vick at alsmjv@gte.net.





"Help" contents:

» help getindexedframe

 GETINDEXEDFRAME  Get indexed movie frame.
 
    GETINDEXEDFRAME returns the contents of the current figure
    as an indexed image movie frame.  This format requires about
    one third of the memory that a true color frame returned by 
    GETFRAME occupies.  However, indexed frames can only store
    a maximum of 256 colors.  
 
    This function is intended for use with AVIWRITE.
 
    Example:  for I=1:num_frames,
                 plot_command
                 M(I) = getindexedframe;
              end;
              aviwrite('my_video.avi',M)
 
    GETINDEXEDFRAME(H) gets a frame from object H, where H is a 
    handle to a figure or an axis.
 



» help aviwrite

 AVIWRITE  Write an AVI file.
 
    AVIWRITE(FILENAME,M) writes the movie M, which must be an array
    of movie frames produced by GETINDEXEDFRAME, to the file FILENAME.
    FILENAME should have an extension of ".avi" to be recognized by the
    built-in Windows .avi viewer.
 
    AVIWRITE(FILENAME,M,FPS) writes a movie that *attempts* to play at 
    a speed of FPS frames per second.  The default is 10.  FPS must be 
    an integer between 1 and 255, although high frame rates may not be 
    playable at full speed on your computer.  
 
    AVIWRITE(FILENAME,M,FPS,'menu') pops up a window that allows you to
    choose a compression/decompression algorithm ("codec") from a menu.
    The default is "Microsoft Video 1" with a Compression Quality of 
    100 and a maximum of 60 frames between each key frame.  (A "key 
    frame" is always recorded explicitly, pixel by pixel; other frames 
    may be encoded relative to the preceding or following frame in 
    order to reduce the file size.)
 
    Note: the codecs may not all work, depending on your computer's 
    configuration; also, some will perform much better than others in 
    terms of quality and compression ratio.  Trial and error is the
    only way to find out which codec is the most effective for your 
    particular application.


