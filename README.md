# Command line Chinese to Hanyu Pinyin for Ubuntu Linux

```bash
$ pnyn 生日快乐
sheng1 ri4 kuai4 le4
```

# INSTALL

[Download][latest] the latest from the release page.

**-OR-**

Grab the package from here:
```bash
$ wget https://github.com/motetpaper/pnyn-sh/releases/download/v0.8.1/pnyn-v0.8.1.deb
```

Install the Debian package.
```bash
$ sudo apt install ./pnyn-v0.8.1.deb
```

# Getting Started

Convert tone numbers to tone marks.
```bash
$ pnyn tonemarks ni3 hao3
nĭ hăo
```


Convert Chinese to Hanyu Pinyin
```bash
$ pnyn pinyin 生日快乐
sheng1 ri4 kuai4 le4
```

Convert Chinese characters to Hanyu Pinyin tone marks.
```bash
$ pnyn pinyin 生日快乐 | xargs pnyn tonemarks
shēng rì kuài lè
```

Convert Chinese characters to [ISO-compliant](https://www.iso.org/standard/61420.html) Hanyu Pinyin tone marks.
```bash
$ pnyn pinyin 生日快乐 | xargs pnyn tonemarksiso
shēng rì kuài lè
```


# LICENSE
  + MIT

[latest]: https://github.com/motetpaper/pnyn-sh/releases/latest
