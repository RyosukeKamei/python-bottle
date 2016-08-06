# Pythonは公式イメージ
FROM python:3.5.2

# オリジナルはJoshua Conner氏
# MAINTAINER Joshua Conner <joshua.conner@gmail.com>
MAINTAINER Ryosuke Kamei <sr2smail@gmail.com>

# 各ライブラリインストール
# Pythonがパッケージ依存するものもインストール
# Pythonプロフェッショナルプログラミング第2版P9より
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y 	vim \
						sudo \
						python3-dev \
						zlib1g-dev \
						libsqlite3-dev \
						libreadline6-dev \
						libgdbm-dev \
						libbz2-dev \
						tk-dev
	
# ユーザ作成
RUN groupadd web
RUN useradd -d /home/bottle -m bottle

# pipでインストール
# virtualenv Pythonの仮想環境構築コマンド
# bottle Pytrhonの軽量フレームワーク
# flake8 コーディングスタイル/シンタックスのチェック
# ipython Pythonのインタラクティブモード拡張
RUN pip install virtualenv \
				bottle \
				ipython \
				flake8

# MySQLドライバ"mysql-connector-python"をインストール
# pipのを使うとエラーなので、git clone
RUN git clone https://github.com/mysql/mysql-connector-python.git
WORKDIR mysql-connector-python
RUN python ./setup.py build
RUN python ./setup.py install

# bottleを使ったサーバ起動ファイルをコピー
ADD ./app/server.py /home/bottle/server.py

# ポートは8080(bottleは8080らしい)にし、サーバ起動ファイルを新しく作成した"bottle"ユーザで起動
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/python", "/home/bottle/server.py"]
USER bottle

# vim の設定ファイル
ADD ./vim/.vimrc /home/bottle/
WORKDIR /home/bottle
RUN mkdir /home/bottle/.vim
RUN mkdir /home/bottle/.vim/ftplugin
ADD ./vim/python.vim /home/bottle/.vim/ftplugin/
RUN mkdir /home/bottle/.vim/bundle
RUN git clone https://github.com/Shougo/neobundle.vim /home/bottle/.vim/bundle/neobundle.vim
