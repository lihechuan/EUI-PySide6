# 更新日志 / Changelog

## 1.3.3 - 2026-11-11

1. 保留 `ESteps.active` 的有效绑定，使 Wizard 在导航、完成、重置和替换模型后同步步骤条。
2. 修复 Anchor 清空滚动目标后保留旧选中项及访问空对象的问题。
3. 修复 Card、Statistic 移除插槽后保留旧尺寸及重新启用时的绑定循环。
4. 同步原版 DynamicDialog 的完成结果与延迟回调生命周期修复。
5. 同步 CommandPalette 连续筛选与缩放后的列表高度修复。
6. 修复 Image 错误占位 Loader 的绑定循环和 Qt 6 预览事件参数警告，更新打包的组件资源。
7. 修复 Collapse 和 Timeline 移除内容插槽后残留旧高度及恢复时的 Loader 绑定循环。
8. 修复 InfiniteScroll 到达加载距离边界时未触发加载的问题。
9. 修复 Terminal 异步处理器重复回调时覆盖首次结果并重复发送完成通知，以及输出转换失败后一直处于忙碌状态的问题。
10. 修复 Calendar 范围比较包含时分秒时排除首日或末日的问题，统一按日判断范围边界。
11. 修复 Ripple 在零缩放首帧仍绘制孤立像素的问题。
12. 修复 BorderBeam 在小数尺寸或高 DPI 下反复绘制时边缘颜色残留、逐渐加深的问题。
13. 修复 Deferred 和 AnimateOnScroll 初始位于显式视口外时，随祖先移动进入视口后仍不更新，以及同级视口或其祖先移动后可见状态未更新的问题。
14. 修复 DynamicDialog 保留内容后切换组件时使用新参数重复创建旧组件的问题。
15. 为 Windows 源码启动的 Gallery 设置独立任务栏应用标识，并补充 Qt Creator 运行配置说明。

1. Preserve ESteps bindings so Wizard navigation, completion, reset, and model replacement keep the step indicator synchronized.
2. Clear Anchor selection safely when its scroll target is removed.
3. Fix stale Card and Statistic slot sizes and Loader binding loops when restoring custom content.
4. Keep DynamicDialog completion results correct during closing and reopening, and guard deferred callbacks.
5. Update CommandPalette height after batched filtering and resizing.
6. Fix Image placeholder Loader binding loops and Qt 6 preview event-parameter warnings, and refresh bundled resources.
7. Fix stale Collapse and Timeline content heights and Loader binding loops when restoring delegates.
8. Trigger InfiniteScroll loading at the distance boundary.
9. Keep Terminal completion single-shot and finish commands with an error when output cannot be converted to text.
10. Keep Calendar range boundaries inclusive for the entire first and last days.
11. Hide Ripple at zero scale to avoid a stray pixel on its initial frame.
12. Prevent BorderBeam edge colors from accumulating on fractional canvas sizes or high DPI.
13. Track ancestor, explicit viewport, and viewport ancestor movement in Deferred and AnimateOnScroll.
14. Avoid recreating retained DynamicDialog content with mismatched component parameters.
15. Give Windows source launches a dedicated Gallery taskbar identity and document the Qt Creator run configuration.

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
