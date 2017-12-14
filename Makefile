NAME = cloudbees
VERSION = 0.0.1

.PHONY: all build build-nocache test tag_latest release

all: build

build:
	docker build -t $(NAME):$(VERSION) .

build-nocache:
	docker build -t $(NAME):$(VERSION) --no-cache --rm .

run:
	docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: build tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to run 'twgit release/hotfix finish' :)"
