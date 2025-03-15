# uflare

A simple userspace generator that builds a simple web server. Useful for making simple edge servers or as a learning tool.

## Building

### Dependencies

You'll want to ensure you have a Go compiler, some core utilites, and Bash.

### Configuration

You may want to review `config` and change the path.

### Building

Just run `./build-userspace.sh`, and it will build an initramfs (`userspace.cpio.gz`), a tarball (`userspace.tar`), and a directory (`userspace`).

## Testing

You'll need a Linux kernel, but we test the generated userspace using QEMU:

```bash
wget https://github.com/charles25565/linux-prebuilds/releases/latest/download/bzImage
qemu-system-x86_64 -kernel bzImage -initrd userspace.cpio.gz -append "quiet ip=dhcp" -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::8080-:80 -accel kvm
```

On `localhost:8080`, you should see your site!

## Using

Using a simple GRUB configuration, `startup.nsh`, or any other method, you can make a complete device image. Note that this doesn't include any IP utility, so use kernel parameters to manage this.

Or alternatively, you can use a simple container image, like this:

```dockerfile
FROM scratch
ADD userspace.tar /
ENTRYPOINT ["/init"]
```
