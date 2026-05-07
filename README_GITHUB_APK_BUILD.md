# GoodMall Flutter App 自动打包说明

这个包已经加入 GitHub Actions 自动打包配置：

```text
.github/workflows/build-apk.yml
```

## 使用方法

1. 在 GitHub 新建仓库，例如 `goodmall_flutter_app`
2. 上传本目录里面的全部文件
3. 打开仓库的 `Actions`
4. 选择 `Build GoodMall Flutter APK`
5. 点击 `Run workflow`
6. 等待完成后，在页面底部下载 `Artifacts -> goodmall-apk`

下载后里面会有：

```text
app-debug.apk
app-release.apk
```

## 服务器接口地址

当前 App 使用：

```text
https://api-test.khmail.cn/native-api/index.php
```

## 已修复内容

- 修复了 `test/widget_test.dart` 里引用不存在的 `MyApp`
- App 名称改为 `GoodMall`
- Android 包名改为 `com.goodmall.app`
- 增加 GitHub Actions 自动打包
- 移除 `.dart_tool`、`.idea`、`android/local.properties` 等本地缓存文件
- 保持 Flutter 原生方向，不改 H5
