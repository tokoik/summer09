# summer09 - 今風 OpenGL の使い方（第１２回 模様を付ける）サンプルプログラム

## 1. 概要

このプログラムは、OpenGL の **GLSL フラグメントシェーダ** を用いて、画像テクスチャを使わずにプロシージャル（計算幾何的）に縞模様や格子模様を生成し、球の表面に模様付けや型抜き（`discard`）を行う手順を学ぶための、学生向けのサンプルプログラムです。本プログラムは、以下のブログ記事の解説に沿って学習を進めるための雛形として提供されています。

- [第１２回 模様を付ける](https://tokoik.github.io/blog/glsl/2009/09/20/glsl.html)

バーテックスシェーダから渡された座標値（varying 変数）をもとに、`mix()`, `step()`, `fract()`, `floor()`, `mod()` などの GLSL 組み込み関数や `discard` を駆使して、ピクセル単位で動的に色や透過を制御する手法を学習します。

## 2. ビルド方法

このプログラムは [CMake](https://cmake.org/) を用いてビルド環境を整備します。各OSとも、ソースコードが置かれているディレクトリにターミナル（またはコマンドプロンプト）で移動してから、以下の手順を実行してください。なお、プログラムをビルドするためのバイナリディレクトリは、バージョン管理ファイル（.gitignore）の設定に合わせて **build** という名前にします。

### 2.1 Windows (Visual Studio 2022 の場合)

1. コマンドプロンプトまたは PowerShell を開き、このプロジェクトのディレクトリに移動します。
2. 以下のコマンドを実行してビルドディレクトリを作成し、CMake で構成を行います。

   ```bat
   mkdir build
   cd build
   cmake .. -G "Visual Studio 17 2022"
   ```

3. 生成された build フォルダ内の summer09.sln を Visual Studio で開きます。
4. ソリューションエクスプローラーで **summer09** プロジェクトを右クリックし、「スタートアップ プロジェクトに設定」を選択します。
5. 「ローカル Windows デバッガー」をクリックするか、F5 キーを押してビルドおよび実行します。

### 2.2 macOS (Xcode の場合)

1. ターミナルを開き、このプロジェクトのディレクトリに移動します。
2. 以下のコマンドを実行してビルドディレクトリを作成し、Xcode 用のプロジェクトを生成します。

   ```sh
   mkdir build
   cd build
   cmake .. -G Xcode
   ```

3. 生成された build/summer09.xcodeproj を Xcode で開きます。
4. 左上のスキーム選択（再生ボタンの横）が **summer09** になっていることを確認します。
5. 「Run」ボタン（再生ボタン）をクリックするか、Command + R を押してビルドおよび実行します。

### 2.3 Ubuntu Linux

1. ターミナルを開き、このプロジェクトのディレクトリに移動します。
2. 必要なパッケージ（freeglut3-dev など）がインストールされていることを確認し、以下のコマンドでビルドします。

   ```sh
   mkdir build
   cd build
   cmake ..
   make
   ```

## 3. 使い方

### 3.1 プログラムの起動方法

- **Windows**: `build\Debug\summer09.exe`
- **macOS**: `open build/Debug/summer09.app` または Xcode 上で Run
- **Ubuntu Linux**: `cd build && ./summer09`

### 3.2 操作方法

- プロシージャルな模様が適用された球が表示されます。

## 4. 解説

### 4.1 格子模様と discard による型抜き (simple.frag)

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
