# UXBOX Docker development environment #

## Quick Start ##

Build the image

```bash
sudo docker build --rm=true -t uxbox .
```

Start development environment inside docker:

```
sudo docker run -ti -v `pwd`:/home/uxbox/uxbox  -v $HOME/.m2:/home/uxbox/.m2 -p 3449:3449 uxbox tmux
```

This is that this commend does:

- This will start tmux session inside the docker container.
- Map the host `.m2` (maven local repo) to the container for avoid repeatedly download all dependencies.
- Map the current directory to the `~uxbox` inside container.
