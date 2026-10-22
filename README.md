# EUI-PySide6

EUI-PySide6 是 EUI 的独立 Python 版本，使用 `PySide6 + Qt Quick/QML`。它包含一份独立的 QML 控件模块和 Gallery；运行时只注册 Python 类型，不依赖原 `EUI` 仓库中的 C++ 插件。

## 安装与启动

建议使用 Python 3.10 或更高版本：

```powershell
git clone https://github.com/lihechuan/EUI-PySide6.git
cd EUI-PySide6
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -e .
.\.venv\Scripts\python.exe -m eui
```

完成上述安装后，可使用以下入口：

```powershell
.\.venv\Scripts\python.exe main.py --language zh
.\.venv\Scripts\python.exe -m eui --language en --dark
.\.venv\Scripts\python.exe -m eui --component ETable
```

以上命令显式使用项目虚拟环境，不依赖终端激活状态。Qt Creator 的运行程序应选择 项目目录中的 `.venv\Scripts\python.exe`，脚本选择根目录的 `main.py`，工作目录选择项目根目录。新建虚拟环境后必须使用该环境的 Python 执行 `-m pip install -e .`；只打开项目目录或保留 `.egg-info` 不会安装项目和依赖。

无窗口环境可使用 `.\.venv\Scripts\python.exe -m eui --smoke-test`；该命令会注册资源、加载 Gallery 根窗口并在短暂事件循环后退出。

## 当前结构

目录按原 EUI 项目的职责组织，Python 包 `eui` 对应 `source`，Gallery 包 `eui_gallery` 对应 `example`：

```text
EUI-PySide6/
├── source/                 # eui 控件库
│   ├── component/          # EAdvancedRectangle.py、EFileUploader.py 等
│   ├── config/             # EDefaultConfig、ELocale、EValueUtils
│   ├── enum/               # EIcons、EStyle 等枚举
│   ├── layout/             # 消息、通知位置管理
│   ├── state/              # 控件状态对象
│   ├── style/palettes/     # 主题与调色板
│   ├── utils/              # 动画、数据、文件和文本工具
│   ├── qml/EUI/            # 156 个公开控件及私有 QML、字体、国际化资源
│   └── runtime.py          # QML 类型与服务注册
├── example/
│   ├── src/                # ExampleData、ExampleCatalog、更新与运行时支持
│   ├── qml/                # Gallery 和全部示例页面
│   ├── data/               # 示例数据、API 文档
│   └── quick3d/            # 独立复制的 3D 示例资源
├── assets/                 # 图标及公共图片
├── build/resources.py      # 开发时生成资源
├── tests/                  # Python 与 QML 回归测试
├── main.py
└── pyproject.toml
```

每个支持类按原 C++ 类名放在对应的 `.py` 文件中。QML 使用 Qt 6，不保留原工程的 `qt5` 路径、C++ 插件构建及 qmake 文件。批量数据操作在当前 QML JavaScript 引擎内执行，以保留对象引用并避免大模型逐条跨语言转换。

修改 QML、图片或资源映射后，在启动 Gallery 或测试进程之前运行：

```powershell
.\.venv\Scripts\python.exe build/resources.py
```

运行时只读取已生成的资源；安装包已包含资源，不需要编译器或对安装目录的写权限。

运行全部迁移测试：

```powershell
.\.venv\Scripts\python.exe tests/run_all.py
.\.venv\Scripts\python.exe -m unittest discover -s tests -p "test_*.py"
```

测试默认串行使用 `QT_QPA_PLATFORM=offscreen` 和 Basic Controls 风格，不会弹出窗口抢占焦点。原生文件对话框需要桌面驱动；真实 ECharts 图表需要可创建 OpenGL 上下文的平台。这些前提不满足时，相应测试明确记录为跳过，软件图表降级提示仍会验证。性能测试应串行运行；并行执行会影响耗时结果。

Quick 3D 来自 `PySide6-Addons`，不下载原 C++ Gallery 运行时；软件渲染下展示相应提示。更新器使用 `lihechuan/EUI-PySide6` 的 GitHub Releases，要求版本标签 `vX.Y.Z`、`eui_pyside6-X.Y.Z-py3-none-any.whl` 及 `SHA256SUMS`。它验证文件大小和 SHA-256 后，通过当前 Python 环境的 pip 安装并重新启动。源码开发安装只支持检查更新，安装入口会提示使用正式发行包。目前未对真实线上发行包执行更新安装验证。

## 许可

代码许可见 [LICENSE](LICENSE)，第三方资源和许可见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
