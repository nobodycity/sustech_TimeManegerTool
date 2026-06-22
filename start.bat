@echo off
cd /d "%%~dp0"
echo ========================================
echo   南方科技大学 - 时间管理系统
echo   服务器启动中...
echo ========================================
echo.
python -m http.server 5173 2>nul
if errorlevel 1 (
  node server.mjs 2>nul
  if errorlevel 1 (
    echo [错误] 未找到 Python 或 Node.js
    echo 请安装 Python 后重试，或手动运行：
    echo   python -m http.server 5173
    pause
  )
)
