# Littlest Tokyo 资源署名

- 作品：Littlest Tokyo。
- 作者：Glen Fox / glenatron。
- 作者主页：[ArtStation](https://artstation.com/glenatron)、[Sketchfab](https://sketchfab.com/glenatron)。
- 作品页面：[ArtStation](https://artstation.com/artwork/1AGwX)、[Sketchfab](https://sketchfab.com/models/94b24a60dc1b48248de50bf087c0f042)。
- 原模型许可：[Creative Commons Attribution 4.0 International（CC BY 4.0）](https://creativecommons.org/licenses/by/4.0/)。作者、标题、许可与作品链接同时记录在原 GLB 的 `asset.extras` 中。
- 上游示例：[three.js r170 / webgl_animation_keyframes.html](https://github.com/mrdoob/three.js/blob/r170/examples/webgl_animation_keyframes.html)。
- 上游资源：[three.js r170 / LittlestTokyo.glb](https://github.com/mrdoob/three.js/blob/r170/examples/models/gltf/LittlestTokyo.glb)。
- 原始 GLB 大小：4,133,072 字节。
- 原始 GLB SHA-256：`8375c2aa6808e28ad1cb9c0d43e1513f57ffd7865244bf66bbbd5bb0e907e06d`。

## 修改与转换

本示例将上游 GLB 解压并转换为 Qt Quick 3D 的 `.mesh`、QML 材质 / 蒙皮节点和 `.qad` 二进制关键帧，保留模型和原始动画内容。转换后移除生成的自动播放动画，公开 `timeline` 属性，供 `TokyoScene.qml` 按实际帧时间控制播放；同时按仓库规则调整生成 QML 的排版。

资产转换所用命令：

```sh
npx --yes @gltf-transform/cli@4.2.1 copy LittlestTokyo.glb LittlestTokyo-decoded.glb
balsam LittlestTokyo-decoded.glb --useBinaryKeyframes --manualAnimations --generateMipMaps -o assets
```

转换使用 Qt 6.8.3 Balsam。以上工具仅用于准备资产，不是运行时依赖。生成后将组件重命名为 `LittlestTokyo.qml`，并添加指向 `take_001_timeline` 的 `timeline` alias。

`maps/studio.hdr` 为本示例生成的简单柔光环境，遵循仓库 MIT 许可。该贴图与相机、光照及控制栏均是本示例新增内容。

如复制、修改或再分发模型及其派生资源，请保留作者、作品来源、CC BY 4.0 链接及修改说明。本仓库的 MIT 许可不替代模型原有许可。
