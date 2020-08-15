build:
	docker build -t kaulshiv/cv_art .

launch_notebook:
	docker run -it --rm -p 8888:8888  -v `pwd`:/src/dev kaulshiv/cv_art

prune:
	docker system prune -a --volumes
