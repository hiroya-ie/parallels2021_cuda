# parallels2021_cuda
For Parallel Processing Class's Report

制作 : Hiroya Chinen

画像のモノクロ化を模したCUDAによる並列プログラムである。

実行にあたり必要な環境
- C言語のコンパイルができる（gccで動作確認済み）
- CUDAのコンパイルができる（nvccで動作確認済み）

<br>

## 実行手順
Windows環境を想定。適宜読み替えて下さい。

<br>
実行準備

```
$git clone https://github.com/hiroya-ie/parallels2021_cuda.git
$cd paeallels2021_cuda
$gcc .\process_cpu2.c -o cpu
$nvcc .\process_gpu2.cu -o gpu
````

実行

```
$.\cpu.exe
$.\gpu.exe
```

画像の幅、高さ、何回ループして処理させるかを聞かれるため、キーボードで入力してください。
CUDAのブロック数やスレッド数を変更する場合は、process_gpu2.cu の67行目を変更してください。

<br>

## 各ファイル説明

<br>
メインプログラム。

```
process_cpu2.c
process_gpu.cu
```

以下の3ファイルは、生成したRGBの値をテキストファイルに保存し、読み込んでから処理を行う、という方法で作成したプログラム。テキストファイルの読み書きに時間がかかりすぎるため手法を変更した。

```
ddiscontinued/pre_make.c
discontinued/process_cpu.c
discontinued/process_gpu
```