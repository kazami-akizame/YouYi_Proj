@REM 终端命令行“.\start-json-server.bat”根目录下启动命令行
@echo off
echo ========================================
echo   JSON Server 启动脚本
echo ========================================
echo.

REM 检查是否安装了json-server
where json-server >nul 2>nul
if %errorlevel% neq 0 (
    echo 未检测到 json-server，正在安装...
    npm install -g json-server@0.17.4
    if %errorlevel% neq 0 (
        echo 安装失败，请手动运行: npm install -g json-server@0.17.4
        pause
        exit /b 1
    )
) else (
    REM 检查版本是否正确
    for /f "tokens=*" %%i in ('json-server --version') do set VERSION=%%i
    echo 当前版本: %VERSION%
    
    REM 如果不是 0.17.4，提示更新
    echo %VERSION% | find "0.17.4" >nul
    if %errorlevel% neq 0 (
        echo.
        echo 警告: 检测到版本不是 0.17.4
        echo 建议运行: npm install -g json-server@0.17.4
        echo.
        choice /C YN /M "是否现在更新到 0.17.4"
        if %errorlevel% equ 1 (
            npm install -g json-server@0.17.4
        )
    )
)

echo.
echo 正在启动 JSON Server...
echo 访问地址: http://localhost:8080
echo 模拟器访问地址: http://10.0.2.2:8080
echo.

REM 启动 JSON Server
json-server --watch data.json --port 8080 --host 0.0.0.0

pause