# 更新日志 / Changelog

## 1.3.2

1. 提供 Python/PySide6 实现的 EUI 支持类，以及独立保存的 QML 组件和 Gallery。
2. 提供 Python wheel、源码包，以及 Windows x64、macOS Intel、macOS Apple Silicon 的 Gallery 安装包和免安装包构建流程。
3. 提供与 EUI 对应的中英文首页、使用指南、组件示例和贡献说明。
4. 修复小数像素宽度的输入框附加区域导致边框混色的问题。
5. 缓存默认字体配置，减少组件加载期间重复查询系统字体。

1. Provide EUI support classes implemented in Python/PySide6, with independent copies of the QML components and Gallery.
2. Add Python wheel/source distributions and Gallery installer/portable builds for Windows x64, macOS Intel, and macOS Apple Silicon.
3. Provide English and Chinese project pages, usage guides, component examples, and contribution guidelines corresponding to EUI.
4. Fix input addon border blending when content has a fractional pixel width.
5. Cache default font configuration to reduce repeated system font queries while loading components.
