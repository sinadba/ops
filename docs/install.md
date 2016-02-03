:snail: 下载使用
====================================

下载整个工程的脚本
-------------------

### 直接clone工程

使用简单、方便更新，不过要安装有`git`。

```bash
git clone git://github.com/gongice/ops.git

cd ops

# 使用Release分支的内容
git checkout release

# 更新脚本
git pull
```

包含2个分支：

- `master`：开发分支
- `release`：发布分支，功能稳定的脚本

当然如果你不想安装`git`,`github`是支持`svn`的：

```bash
svn co https://github.com/gongice/ops/branches/release

cd ops

# 更新脚本
svn up
```

下载和运行单个文件
-------------------

以[`show-busy-java-threads.sh`](https://raw.github.com/gongice/ops/release/show-busy-java-threads.sh)为例。

### `curl`文件直接用`bash`运行

```bash
curl -sLk 'https://raw.github.com/gongice/ops/release/show-busy-java-threads.sh' | bash
```

### 下载单个文件

```bash
wget --no-check-certificate https://raw.github.com/gongice/ops/release/show-busy-java-threads.sh
chmod +x show-busy-java-threads.sh

./show-busy-java-threads.sh
```
