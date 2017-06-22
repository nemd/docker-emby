build:
	docker build --force-rm -t emby:$(cmd) .

shell:
	sudo docker exec -i -t emby /bin/ash

run:
	sudo docker run -d -v /srv/dockstorage/emby/conf:/config -v /srv/storage/media:/media -p 8096:8096 --restart=always --name emby emby:$(cmd)


build:
	docker build --force-rm -t tivix/zardoz_opsdeploy .
run:
ifndef name
	docker run -ti --env-file=.env_tmp tivix/zardoz_opsdeploy $(cmd)
else
	docker run -ti --env-file=.env_tmp --name $(name) tivix/zardoz_opsdeploy $(cmd)
endif
rebuild:
	docker rm -f $(docker ps -a | grep ops | awk '{print $1}'); docker rmi -f $(docker images | grep opsdeploy | awk '{print $3}')

