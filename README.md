# cntfapp

- TODO: TerraForm APPlication for cloud Native
- TODO: コンテナとCI/CDに関するAWSリソース作成用のInfrastructure as Codeを提供
- TODO: TerraformとTerragruntについての詳細説明については割愛する旨(リンクを記載)

## cntfappで実現できること

- TODO: アプリケーションの内容(TerraformによるAWS環境構築)
- TODO: 書籍に連動している旨

## OSSと利用前提事項

### Terraform

- TODO: 利用バージョン
- TODO: remote stateはS3にて管理
- TODO: LockIDはDynamoDB似て管理

### Terragrunt

- TODO: 利用目的
- TODO: 利用バージョン

## 利用に際した前提事項

- TODO: 実行はAmazon Cloud9を利用する旨
  - AdministratorsRole相当の権限を有するIAMユーザーで作成

### 環境利用のためのセットアップ

### Terraform利用の準備

- TODO: Amazon S3の作成
- TODO: Amazon DynamoDBの作成
- TODO: Amazon Cloud9の作成
- TODO: aws-vaultのインストール
- TODO: AWSアクセスキーの作成

### tfenvのインストール

- TODO: tfenvバージョンの最新化

```bash
# インストール対象のディレクトリを作成
$ mkdir .tfenv

# Githubリポジトリからtfenvをダウンロードし、所定の場所にインストール
$ wget https://github.com/tfutils/tfenv/archive/v2.0.0.tar.gz
$ tar zxvf ../v2.0.0.tar.gz
$ mv tfenv-2.0.0/* .tfenv/

# tfenv実行に必要なパスを通す
$ echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
$ source ~/.bash_profile

# バージョンの確認 (下記出力内容は2020年7月5時点の内容)
$ tfenv
tfenv 2.0.0
Usage: tfenv <command> [<options>]

Commands:
   install       Install a specific version of Terraform
   use           Switch a version to use
   uninstall     Uninstall a specific version of Terraform
   list          List all installed versions
   list-remote   List all installable versions

# 不要なファイルを削除
$ rm -rf tfenv-2.0.0*
$ rm v2.0.0.tar.gz
```

### Terraformのインストール

- TODO: Terraformバージョンの最新化

```bash
# v0.12.25のインストール
$ tfenv install 0.12.25
Installing Terraform v0.12.25
Downloading release tarball from https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
######################################################################################################################################################################################################################################################### 100.0%
Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_SHA256SUMS
No keybase install found, skipping OpenPGP signature verification
Archive:  tfenv_download.BGgMie/terraform_0.12.25_linux_amd64.zip
  inflating: /home/ec2-user/.tfenv/versions/0.12.25/terraform  
Installation of terraform v0.12.25 successful. To make this your default version, run 'tfenv use 0.12.25'

# インストールしたバージョンの有効化
$ tfenv use 0.12.25
Switching default version to v0.12.25
Switching completed
$ tfenv list
* 0.12.25 (set by /home/ec2-user/.tfenv/version)

# terraformコマンドの実行確認
$ terraform -v
Terraform v0.12.25

Your version of Terraform is out of date! The latest version
is 0.12.28. You can update by downloading from https://www.terraform.io/downloads.html
```

### Terragruntのインストール

```bash
# Terragruntのダウンロード
$ wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.31/terragrunt_linux_amd64

# ダウンロードしたバイナリファイルの配置
$ mv terragrunt_linux_amd64 terragrunt
$ chmod 755 terragrunt
$ sudo mv terragrunt /usr/local/bin/

# terragruntコマンドの実行確認
$ terragrunt -v
terragrunt version v0.23.31
```

### 実行とAWSリソースの作成

## リソースの削除

- TODO: Terraformリソースと手動で作成したリソースで手順が異なる旨

### Terraformリソースの削除

- TODO: Terraformリソースの削除手順

### 手動で作成したAWSリソースの削除

- TODO: 手動で作成したAWSリソースの削除手順

## 料金に関する補足

- TODO: 1枚もので料金がわかる図を作成