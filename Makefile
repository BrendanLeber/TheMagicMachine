video:
	ffmpeg -i frames/frame-%06d.png -c:v qtrle -pix_fmt rgb24 -r 30 ./output.mov

clean:
	rm frames/*.png
	rm output.mov
