# MetaboanalystR を用いたメタボロームデータ解析

このレポジトリには Qiita に投稿した[MetaboanalystR を用いたメタボロームデータ解析](https://qiita.com/keisuke-ota/items/803c4299138b169eb9a2)という記事に公開している script を公開しています。詳しくはこちらの記事も参考にしてください。

## メタボロームデータとは

腸内代謝分子を対象にしたデータです。メタボロームデータ解析によって、食と健康の関連を調べることができます。

## MetaboanalystR とは

メタボロームデータ解析プラットホームの [R ライブラリ](https://www.metaboanalyst.ca/docs/RTutorial.xhtml)です。統計学的仮説検定、PCA や PLS といった代謝解析専門の多変量解析、機械学習といった数理解析を実施することが可能です。

## 各種 script の説明

* Metaboanalyst.R

標準化条件および欠損値処理方法を変えながら網羅的に解析するプログラムです。ここでは 2 群間の違いを調べる Fold change、 t 検定、 PLS-DA、ランダムフォレストを自動化しています。

* st_condition_search.py

解析結果の自動可視化アプリです。機能の詳細は Qiita に記載しておりますので、そちらを参考にしてください。