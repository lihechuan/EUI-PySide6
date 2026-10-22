# 第三方软件与资源 / Third-party notices

根目录 [LICENSE](LICENSE) 的 MIT 许可适用于 EUI-PySide6 自身代码和文档。下列第三方软件、资源及其修改保留各自的版权和许可；项目的 MIT 许可不替代这些条款。

The root [LICENSE](LICENSE) applies to EUI-PySide6's own code and documentation. Third-party software, assets, and their modifications retain their respective copyright and license terms.

| 软件或资源 / Component | 位置 / Location | 许可与说明 / License and notices |
| --- | --- | --- |
| Apache ECharts 6.1.0 | `source/thirdparty/echarts/` | [LICENSE](source/thirdparty/echarts/LICENSE)、[NOTICE](source/thirdparty/echarts/NOTICE) 和[来源记录 / source](source/thirdparty/echarts/README.md) |
| Littlest Tokyo 3D model | `example/quick3d/littlest-tokyo/assets/` | Glen Fox / glenatron；CC BY 4.0；[署名、来源及转换说明 / attribution, source and conversion](example/quick3d/littlest-tokyo/assets/ATTRIBUTION.md) |
| Skill Icons 品牌 SVG | `source/qml/EUI/font/icons/` | [MIT](source/qml/EUI/font/icons/LICENSE)；[来源和修改说明 / source and modifications](source/qml/EUI/font/icons/README.md) |
| PySide6、PySide6-Essentials、PySide6-Addons 及 Qt | pip 安装的依赖 / separately installed dependencies | 许可、Qt 模块和内含第三方组件的声明随相应发行包提供 / license terms and bundled third-party notices are provided by the installed distributions |
| Pillow | pip 安装的依赖 / separately installed dependency | MIT-CMU；完整许可见已安装发行包的 `pillow-*.dist-info/licenses/LICENSE` / full license is included in the installed distribution |
| Python qrcode | pip 安装的依赖 / separately installed dependency | BSD；完整许可及原始 MIT 代码署名见已安装发行包的 `qrcode-*.dist-info/LICENSE` / full license and original MIT code attribution are included in the installed distribution |

本项目的 wheel 和源码包保留上述内置资源的许可、署名及来源说明。运行时依赖由 pip 安装，不包含在 EUI-PySide6 wheel 中。品牌名称和图形的商标权不因代码许可证而转移。

The project wheel and source distribution retain the licenses, attribution, and source notices for the bundled assets above. Runtime dependencies are installed by pip and are not included in the EUI-PySide6 wheel. Code licenses do not transfer trademark rights in brand names or artwork.

Gallery 安装包和免安装包另行内置 Python、PySide6/Qt、Pillow、qrcode 及其运行依赖，随包 `licenses/` 目录保留相关许可和声明；macOS 中该目录位于 app bundle 的 `Contents/Resources/`。PyInstaller 引导程序使用其 GPL 许可和引导程序分发例外，声明同样保留。Qt 内含组件继续遵循其各自许可。

Gallery installers and portable packages additionally bundle Python, PySide6/Qt, Pillow, qrcode, and their runtime dependencies. Their license texts and notices are retained under `licenses/`, located in `Contents/Resources/` inside macOS bundles. PyInstaller's bootloader uses its GPL license with the bootloader distribution exception, also retained. Components bundled with Qt retain their respective licenses.
