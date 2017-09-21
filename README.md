# gyoutube-dl

This is a quick and dirty GUI built around
[youtube-dl's][youtube-dl-home] audio download function for the
Mac. Give it a list of YouTube links and gyoutube-dl will go and
download their audio to your Music folder as MP3s.

[youtube-dl-home]: https://github.com/rg3/youtube-dl

This is my first Swift program and was written over a few nights so
the code is of fairly poor quality. It does work however just with
almost no error checking. I might tidy it up at some point in the
future.

## Build

Build gyoutube-dl by opening the `.xcodeproj` file and building as normal in
Xcode. gyoutube-dl is written in Swift 4.0 so you'll need to use Xcode 9.

## Running

To run gyoutube-dl, you'll need at least Mac OS 10.10. You'll also
need to install youtube-dl and [ffmpeg][ffmpeg-home] to your
`/usr/local/bin` folder. This is most easily done with
[homebrew][brew-home]. I might bundle versions of these dependencies
in future releases.

[ffmpeg-home]: http://ffmpeg.org
[brew-home]: http://brew.sh

To use, simply paste a YouTube link into the text field and click
"Add". Do this for as many videos as you want. When you're ready to
download, click "Start". Your MP3s will end up in
`~/Music/$TITLE.mp3`.

## Credits

Credit obviously goes to the fantastic [youtube-dl][youtube-dl-home]
and [ffmpeg][ffmpeg-home] which are responsible for the heavy lifting
of gyoutube-dl.

## License

gyoutube-dl is licensed under the MIT license.
