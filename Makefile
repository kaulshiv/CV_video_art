docker_build:
	docker build -t kaulshiv/cv_art .

launch_notebook:
	docker run -p 8888:8888 kaulshiv/cv_art
