build:
	docker build --force-rm -t emby-new:$(cmd) .

shell:
	sudo docker exec -i -t emby /bin/ash

run:
ifndef
	sudo docker run -d -v /srv/dockstorage/emby/conf:/config -v /srv/storage/media:/media -p 8096:8096 --restart=always emby:$(cmd)
else
	sudo docker run -d -v /srv/dockstorage/emby/conf:/config -v /srv/storage/media:/media -p 8096:8096 --restart=always --name $(name) emby:$(cmd)
endif

rebuild:
	docker rm -f $(docker ps -a | grep emby | awk '{print $1}'); docker rmi -f $(docker images | grep emby | awk '{print $3}')
