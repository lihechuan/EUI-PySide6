# 参与贡献 / Contributing

欢迎通过 [GitHub Issues](https://github.com/lihechuan/EUI-PySide6/issues) 提交问题或功能建议，也可联系 `xiaojiaqaq@gmail.com`。请使用 Issue 模板，先搜索已有问题；附上 Python/PySide6 版本、操作系统、架构、组件名称、复现步骤、预期行为和错误日志。日志和示例不要包含密码、令牌或个人数据。

Use [GitHub Issues](https://github.com/lihechuan/EUI-PySide6/issues) or email `xiaojiaqaq@gmail.com`. Search existing issues and use the templates. Include your Python/PySide6 versions, OS, architecture, component, reproduction steps, expected behavior, and logs without credentials or personal data.

## 构建与验证 / Build and verification

按[中文指南](docs/guide.zh-CN.md#1-环境准备)或 [English guide](docs/guide.en.md#1-prerequisites) 创建环境并安装源码，使用该环境的 Python 执行以下命令。界面测试在后台运行。

Create the environment and install the checkout using the guides above. Run these commands with that environment's Python. UI tests run offscreen.

```powershell
python build/resources.py
python -m unittest discover -s tests -p "test_*.py"
python tests/run_all.py --jobs 1
python main.py --smoke-test
git diff --check
```

## 提交 PR / Pull requests

说明 PR 解决的问题，附上复现步骤和验证结果；界面修改可附截图。提交说明使用英文。公开控件或 Gallery 行为改变时，同步更新示例、API、测试和中英文文档。新增第三方代码或资源时注明来源并保留许可及版权声明。原创贡献按根目录 MIT 许可证提供。

Describe the problem your PR solves and include reproduction steps and verification results. Screenshots help explain UI changes. Write commit messages in English. Update the examples, API, tests, and both language versions of the documentation when public controls or Gallery behavior changes. Record third-party sources and retain their licenses and copyright notices. Original contributions use the root MIT license.
