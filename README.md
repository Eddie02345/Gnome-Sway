# sway-gnome

A Sway configuration that mimics the looks of GNOME.  
**Work in progress.**

## Requirements

To install dependencies, run:


[autotiling](https://github.com/nwg-piotr/autotiling)
```bash
pip3 install --user autotiling
```

[izmenu](https://github.com/e-tho/iwmenu)
```bash
git clone https://github.com/e-tho/iwmenu
cd iwmenu
cargo build --release
sudo cp target/release/izmenu /usr/local/bin/
```

[bzmenu](https://github.com/e-tho/bzmenu)
```bash
git clone https://github.com/e-tho/bzmenu
cd bzmenu
cargo build --release
sudo cp target/release/bzmenu /usr/local/bin/
