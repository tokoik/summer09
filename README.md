# summer09 - 今風 OpenGL の使い方（第１２回 模様を付ける）サンプルプログラム

## 1. 概要

このプログラムは、OpenGL の **GLSL フラグメントシェーダ** を用いて、画像テクスチャを使わずにプロシージャル（計算幾何的）に格子模様を生成し、球の表面に模様付けと型抜き（`discard`）を行う手順を学ぶための、学生向けのサンプルプログラムです。本プログラムは、以下のブログ記事の解説に沿って学習を進めるための雛形として提供されています。

- [第１２回 模様を付ける](https://tokoik.github.io/blog/今風%20opengl%20の使い方/2009/09/20/glsl.html)

バーテックスシェーダから渡された座標値（varying 変数）をもとに、`floor()`, `mod()` などの GLSL 組み込み関数や `discard` を使って、ピクセル単位で動的に色や透明度を制御する手法を学習します。

## 2. 対応環境

- **Windows**: Windows 10 / 11, Visual Studio 2022 (MSVC C++17)
- **macOS**: macOS 12 Monterey 以降, Xcode 14 以降 / Command Line Tools
- **Linux**: Ubuntu 22.04 LTS 以降, GCC / Clang (C++17 対応コンパイラ)
- **ビルドツール**: CMake 3.22 以降

## 3. ビルド手順

このプログラムは [CMake](https://cmake.org/) を用いてビルド環境を整備します。各 OS とも、ソースコードが置かれているディレクトリにターミナル（またはコマンドプロンプト）で移動してから、以下の手順を実行してください。なお、プログラムをビルドするためのバイナリディレクトリは、バージョン管理ファイル（.gitignore）の設定に合わせて **build** という名前にします。

> cmake-gui で設定することも可能です。その際は、`Source code path` にはプロジェクトのフォルダを指定し、`Build path` にはプロジェクトのフォルダの中に作った build というフォルダを指定してください。その後、`Configure` → `Generate` の順にクリックした後、`Open Project` をクリックすれば、開発環境が起動します。

### 3.1 Windows (Visual Studio 2022 の場合)

1. コマンドプロンプトまたは PowerShell を開き、このプロジェクトのディレクトリに移動します。
2. 以下のコマンドを実行してビルドディレクトリを作成し、CMake で構成を行います。

   ```bat
   mkdir build
   cd build
   cmake .. -G "Visual Studio 17 2022"
   ```

3. 生成された build フォルダ内の `summer09.sln` を Visual Studio で開きます。
4. ソリューションエクスプローラーで **summer09** プロジェクトを右クリックし、「スタートアップ プロジェクトに設定」を選択します。
5. 「ローカル Windows デバッガー」をクリックするか、F5 キーを押してビルドおよび実行します。

### 3.2 macOS (Xcode の場合)

1. ターミナルを開き、このプロジェクトのディレクトリに移動します。
2. 以下のコマンドを実行してビルドディレクトリを作成し、Xcode 用のプロジェクトを生成します。

   ```sh
   mkdir build
   cd build
   cmake .. -G Xcode
   ```

3. 生成された `build/summer09.xcodeproj` を Xcode で開きます。
4. 左上のスキーム選択（再生ボタンの横）が **summer09** になっていることを確認します。
5. 「Run」ボタン（再生ボタン）をクリックするか、Command + R を押してビルドおよび実行します。

### 3.3 Ubuntu Linux

1. ターミナルを開き、このプロジェクトのディレクトリに移動します。
2. 必要なパッケージ（freeglut3-dev など）がインストールされていることを確認し、以下のコマンドでビルドします。

   ```sh
   mkdir build
   cd build
   cmake ..
   make
   ```

## 4. 起動方法

各 OS とも、ビルド後に生成されるバイナリディレクトリ (build) やそのサブフォルダから起動します。

- **Windows**

  Visual Studio 上で「ローカル Windows デバッガー」をクリックして実行するか、またはコマンドプロンプトから以下のコマンドで起動します。

  ```cmd
  cd build\Debug
  summer09.exe
  ```

- **macOS**

  Xcode 上で左上の「Run（再生ボタン）」をクリックして実行します。アプリケーションバンドルを直接起動する場合は、Finder から `build/Debug/summer09.app` を開くか、ターミナルから `open build/Debug/summer09.app` を実行します。

- **Ubuntu Linux**

  ターミナルから以下のコマンドで実行ファイル（バイナリ）を直接起動します。

  ```sh
  cd build
  ./summer09
  ```

## 5. 操作方法

- プロシージャルな格子模様が適用され、型抜きされた球が表示されます。

## 6. プログラムの解説

### 6.1 格子模様と discard による型抜き (simple.frag)

```glsl
#version 120

varying vec3 diffuseColor;
varying vec2 t;
const vec3 c1 = vec3(1.0, 0.0, 0.0);

void main(void)
{
  if (mod(floor(t.x) + floor(t.y), 2.0) == 0.0) discard;
  gl_FragColor = vec4(diffuseColor * c1, 1.0);
}
```
