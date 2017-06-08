build:
	sudo docker build -t emby:1.9 .

shell:
	sudo docker exec -i -t emby /bin/ash

run:
	sudo docker run -d -v /srv/dockstorage/emby/conf:/config -v /srv/storage/media:/media -p 8096:8096 --restart=always --name emby emby:1.9
