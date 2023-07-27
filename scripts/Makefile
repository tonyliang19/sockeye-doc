IMAGE_NAME ?= new_mogo
build:
	docker build . -t ${IMAGE_NAME} -f Dockerfile
	@(docker rmi $$(docker images -q -f dangling=true) 2>/dev/null) || (echo "No image to delete" && exit 1)

run:
	#docker run -it --rm ${IMAGE_NAME}
	docker run -it --rm -v /$$(pwd):/app -p 8888:8888 ${IMAGE_NAME}
