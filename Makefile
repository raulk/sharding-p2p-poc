gx:
	go get -u github.com/whyrusleeping/gx
	go get -u github.com/whyrusleeping/gx-go

deps: gx
	gx --verbose install --global
	gx-go rewrite
	./script/gx-unwrite-partially.sh

build-prod:
	docker build -f docker/prod.Dockerfile -t ethereum/sharding-p2p:latest .

build-dev:
	docker build -f docker/dev.Dockerfile -t ethereum/sharding-p2p:dev .

run-dev:
	docker run -it --rm -v $(PWD):/go/sharding-p2p/ ethereum/sharding-p2p:dev sh -c "go build -v -o main ."

test-dev: partial-gx-rw
	docker run -it --rm -v $(PWD):/go/sharding-p2p/ ethereum/sharding-p2p:dev sh -c "go test"
	gx-go uw

run-many-dev:
	docker-compose -f docker/dev.docker-compose.yml up --scale node=5

down-dev:
	docker-compose -f docker/dev.docker-compose.yml down

run-many-prod:
	docker-compose -f docker/prod.docker-compose.yml up --scale node=5

down-prod:
	docker-compose -f docker/prod.docker-compose.yml down

gx-partial-rw:
	gx-go rw
	./script/gx-unwrite-partially.sh

gx-rw:
	gx-go rw

gx-uw:
	gx-go uw
