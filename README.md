# arcade_os
Git repo hosting the containerfiles for describing the arcade_os's

# To build the containers
1. Change directory to the arcade_base

```bash
cd arcade_base
```

2. Create a pat token, with a long expiry, and create an auth.json file by logging into the container registry with the pat token

```bash
podman login --authfile ./auth.json ghcr.io
```

3. Create the arcade_base image by runing changing the image tag to your preference

```bash
podman build -t ghcr.io/redhat-uk-arcade/arcade-base:10.1 -f Containerfile
```

4. Do the next steps for the two different arcade machines

    1. For the Command Line Heros arcade machine:

        1. Build the container file

            ```bash
            podman build -t ghcr.io/redhat-uk-arcade/arcade-clh:10.1 -f Containerfile
            ```

        2. Push the image and pull the image to the sudo user.

        3. Create the disk image. The example is for a qcow2 VM disk image.

            ```bash
            sudo podman run \
            --rm \
            -it \
            --privileged \
            --pull=newer \
            --security-opt label=type:unconfined_t \
            -v $(pwd)/config.toml:/config.toml:ro \
            -v $(pwd):/output \
            -v /var/lib/containers/storage:/var/lib/containers/storage registry.redhat.io/rhel10/bootc-image-builder:latest \
            --type qcow2 \
            ghcr.io/redhat-uk-arcade/arcade-clh:10.1
            ```

     2. For the retro arcade machine

        1. Build the container file

            ```bash
            podman build -t ghcr.io/redhat-uk-arcade/arcade-rom:10.1 -f Containerfile
            ```

        2. Build an arcade rom image. Any of pacman, asteroids, super_mario_bros or spaceinvaders can be used.

        ```bash
        cd ../pacman
        podman build -t ghcr.io/redhat-uk-arcade/arcade-pacman:10.1 -f Containerfile
        ```

        2. Push the image and pull the image to the sudo user.

        3. Update the config.toml file with your ssh key

        4. Create the disk image. This example is for a qcow2 VM disk image.

        ```bash
        sudo podman run \
          --rm \
          -it \
          --privileged \
          --pull=newer \
          --security-opt label=type:unconfined_t \
          -v $(pwd)/config.toml:/config.toml:ro \
          -v $(pwd):/output \
          -v /var/lib/containers/storage:/var/lib/containers/storage registry.redhat.io/rhel10/bootc-image-builder:latest \
          --type qcow2 \
          ghcr.io/redhat-uk-arcade/arcade-rom:10.1
        ```

        5. Install the VM

        ```bash
        virt-install --name arcade \
          --vcpus 2 --memory 4096 \ 
          --disk /var/lib/libvirt/images/arcade.qcow2,device=disk,bus=virtio,format=qcow2 \
          --os-variant rhel10.1 --boot uefi --virt-type kvm \
          --graphics spice --video vga --channel spicevmc \
          --network default
        ```

        6. Run the VM

        ```bash
        sudo virsh start arcade && sudo virt-viewer arcade &
        ```

        7. Build and push the other roms

        8. ssh into the vm and use bootc switch to load another rom

        ```bash
        sudo bootc switch --soft-reboot=required --apply ghcr.io/redhat-uk-arcade/asteroids:latest
        ```

Uncomment any of the dnf installs if additional packages are required to run the images on the micro PCs or if you need to debug.
