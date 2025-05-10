# Command line Chinese to Hanyu Pinyin for Ubuntu Linux

```bash
$ pnyn pinyin 生日快乐
sheng1 ri4 kuai4 le4
```

# INSTALL

[Download][latest] the latest from the release page.

**-OR-**

Grab the package from here:
```bash
$ wget https://github.com/motetpaper/pnyn-sh/releases/download/v0.8.5/pnyn-v0.8.5.deb
```

Install the Debian package.
```bash
$ sudo apt install ./pnyn-v0.8.5.deb
```

# Quick Start

Convert tone numbers to tone marks.
```bash
$ pnyn tonemarks ni3 hao3
# nĭ hăo
```

Convert tone numbers to [ISO-compliant][iso] tone marks.
```bash
$ pnyn tonemarksiso ni3 hao3
# nǐ hǎo
```

# The Essentials

Convert Chinese to Hanyu Pinyin (Hanzi to Pinyin)
```bash
$ pnyn pinyin 生日快乐
# sheng1 ri4 kuai4 le4
```

```bash
$ pnyn p 生日快乐
# sheng1 ri4 kuai4 le4
```


Convert Chinese characters to Hanyu Pinyin tone marks.
```bash
$ pnyn tonemarks 生日快乐
# shēng rì kuài lè
```

```bash
$ pnyn tm 生日快乐
# shēng rì kuài lè
```

Convert Chinese characters to ISO-compliant Hanyu Pinyin tone marks.
```bash
$ pnyn tonemarksiso 生日快乐
# shēng rì kuài lè
```

```bash
$ pnyn tmiso 生日快乐
# shēng rì kuài lè
```

Convert Chinese to Hanyu Pinyin with no tones.
```bash
$ pnyn tonesremoved 生日快乐
# sheng ri kuai le
```

```bash
$ pnyn tr 生日快乐
# sheng ri kuai le
```

# For Coders and Creators

Here are some useful functions if you are making NoSQL document databases or WordPress blogs.

### FUNCTION: PMASH


PMASH, removing spaces
```bash
$ pnyn pmash sheng1 ri4 kuai4 le4
# sheng1ri4kuai4le4
```

```bash
$ pnyn pmash 生日快乐
# shēng rì kuài lè
```

### FUNCTION: PBASH

PBASH, removing spaces and digits
```bash
$ pnyn pbash 生日快乐
# shengrikuaile
```

```bash
$ pnyn pbash sheng1 ri4 kuai4 le4
# shengrikuaile
```


### FUNCTION: PSMASH

PSMASH, returning the pinyin initals
```bash
$ pnyn psmash 生日快乐
# srkl
```

```bash
$ pnyn psmash sheng1 ri4 kuai4 le4
# srkl
```

### FUNCTION: PSLUG

PSLUG, for [WordPress slugs][wp_slugs]
```bash
$ pnyn pslug 生日快乐
# sheng-ri-kuai-le
```

```bash
$ pnyn pslug sheng1ri4kuai4le4
# sheng-ri-kuai-le
```


# LICENSE
  + MIT

[wp_slugs]: https://developer.wordpress.org/reference/functions/wp_unique_post_slug/
[iso]: https://www.iso.org/standard/61420.html
[latest]: https://github.com/motetpaper/pnyn-sh/releases/latest
