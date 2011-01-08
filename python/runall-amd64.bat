@ECHO OFF

call gettests.bat

call vcvarsall x64

for %%v in ("Python26" "Python27") do (
  for %%m in ("" "--with-machine=x64" "--with-machine=ansi64") do (
    for %%a in ("" "--without-threads") do (
      echo.
      echo # ========================================================================
      echo #               %%v %%m %%a
      echo # ========================================================================
      echo.
      cd ..
      del /s /q build
      "C:\Program Files\%%v\python.exe" setup.py build %%m %%a
      cd python
      echo.
      echo.
      echo ======================== Unit tests ==========================
      echo.
      "C:\Program Files\%%v\python.exe" test_cdecimal2.py
      echo.
      echo.
      echo ========================= deccheck ===========================
      echo.
      "C:\Program Files\%%v\python.exe" deccheck2.py
      echo.
      echo.
      echo ======================= ctx-deccheck =========================
      echo.
      "C:\Program Files\%%v\python.exe" ctx-deccheck2.py
    )
  )
)

for %%v in ("Python31") do (
  for %%m in ("" "--with-machine=x64" "--with-machine=ansi64") do (
    for %%a in ("" "--without-threads") do (
      echo.
      echo # ========================================================================
      echo #               %%v %%m %%a
      echo # ========================================================================
      echo.
      cd ..
      del /s /q build
      "C:\Program Files\%%v\python.exe" setup.py build %%m %%a
      cd python
      echo.
      echo.
      echo ======================== Unit tests ==========================
      echo.
      "C:\Program Files\%%v\python.exe" test_cdecimal3.py
      echo.
      echo.
      echo ========================= deccheck ===========================
      echo.
      "C:\Program Files\%%v\python.exe" deccheck3.py
      echo.
      echo.
      echo ======================= ctx-deccheck =========================
      echo.
      "C:\Program Files\%%v\python.exe" ctx-deccheck3.py
    )
  )
)

for %%m in ("" "--with-machine=x64" "--with-machine=ansi64") do (
  for %%a in ("" "--without-threads") do (
    echo.
    echo # ========================================================================
    echo #               py3k %%m %%a
    echo # ========================================================================
    echo.
    cd ..
    del /s /q build
    ..\..\svn\py3k_64\PCbuild\amd64\python.exe setup.py build %%m %%a
    cd python
    echo.
    echo.
    echo ======================== Unit tests ==========================
    echo.
    ..\..\..\svn\py3k_64\PCbuild\amd64\python.exe test_cdecimal3.py
    echo.
    echo.
    echo ========================= deccheck ===========================
    echo.
    ..\..\..\svn\py3k_64\PCbuild\amd64\python.exe deccheck3.py
    echo.
    echo.
    echo ======================= ctx-deccheck =========================
    echo.
    ..\..\..\svn\py3k_64\PCbuild\amd64\python.exe ctx-deccheck3.py
  )
)


