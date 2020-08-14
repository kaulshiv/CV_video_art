docker_build:
	docker build -t kaulshiv/cv_art .

launch_notebook:
	docker run -it -p 8888:8888  -v `pwd`:/src kaulshiv/cv_art
