# Terraformを利用したｔ書籍「xxx」のハンズオン実施

- TODO: 書籍名が決まったらタイトル修正

本リポジトリのTerraformソースコードは書籍「xxxx」の内容と連動してAWSリソースを作成することができます。
具体的には、書籍内3章で作成するVPCやサブネットといったネットワークの設定、ECSなどのコンテナ定義といったリソースや4章で作成するCodeCommitやCodePipelineなどのリソースについて、各章内のStepと併せて作成することができます。

普段AWSマネジメントコンソールからの作業ではなく、IaCなどTerraformを利用している方はこちらのソースコードを利用したハンズオンとしてご活用ください。

## 利用に関する前提事項

本手順はREDOME.mdに記載の内容を基に作成しています。
事前にREDOME.mdを参照いただき、必要な環境をセットアップした上で実施してください。

## 注意事項

### Terraform対象外のAWSリソース

現時点においてTerraformでは、すべてのAWSリソースを作成できるわけでなく、Featureとして対応中の対象も含まれています。
また、Cloud9のように、一部のリソースに関してはTerraform内に完結して関連するAWSリソースを組み合わせることが難しいケースもあります。

そのため、**書籍内で扱うすべてのAWSリソースを本ソースコードから作成できるわけではありません**。
このようなAWSリソースについては、各Stepのリソース作成手順内にて適宜補足していきます。

### 一部Terraformリソースの引数について

Amazon AuroraやAmazon Systems Managerパラメーターストアなどで扱う認証情報等においては、Terraformソースコード上はダミー値として定義し、Terraformでの差分検知対象外としています(一般的にクレデンシャルとして扱われる情報はソースコード等のフラットに扱われるファイルに記述すべきではない、という思想です)。

以上の理由により、**認証情報はAWSリソース作成後に手動で変更する方針**としています。
こちらについても、適宜各Stepのリソース作成手順内にて触れていきます。

### 書籍ハンズオン内容との差分について

本Terraformから作成されるALBとAuroraについて、利用後の削除作業簡単にするため**削除保護を無効化**しています。
一方、書籍ハンズオンの手順ではこれらの削除保護を有効化しています。**本番環境での運用を考えると削除保護は有効化が望ましい**設定となります。
あくまで、Terraformリソース作成後の削除しやすさを考慮した設定となっているためご留意ください。

## 事前の設定事項

### ソースコードの取得

REDOME.mdで作成したCloud9上で必要なブランチを取得します。

``` bash
$ mkdir terraform; ls -l; cd terraform

$ git clone https://github.com/iselegant/cntfdemo

$ cd cntfdemo

$ git branch
  cnfs/chap-3_step-1
  cnfs/chap-3_step-2
  cnfs/chap-3_step-3
  cnfs/chap-3_step-4
  cnfs/chap-3_step-5
  cnfs/chap-4_step-1
  cnfs/chap-4_step-2
  cnfs/chap-4_step-3
  cnfs/chap-4_step-4
* master

$ git pull --all
Already up-to-date.

$ git checkout cnfs/chap-3_step-1
Switched to branch 'cnfs/chap-3_step-1'
Your branch is up-to-date with 'origin/cnfs/chap-3_step-1'.
```

- TODO: git cloneの出力結果を記載する

### Terraform内一部変数も設定

ソースコードを取得後、事前にそれぞれのAWS環境に合わせたTerraform変数の設定が必要となります。
以下ファイルを修正し、変数の値を書き換えてください。

``` bash
# dependiencies.tfのdummyを利用するAWS環境のAWSアカウントIDに書き換える
# 例) "dummy" -> "0123456789012"
$ cat main/dependencies.tfvars 
aws_account_id = "dummy"
```

## 3章に関する手順

以下のように各章の各Stepと本リポジトリのブランチについて、1対1で紐付いています。

<img src="./images/branches.jpg" width="512" alt="ブランチと書籍内で作成するAWSリソースの対応について">

そのため、各Step毎にブランチ切り替えながら`terragrunt apply`を実行していくのが基本的な流れです。
以下に各章各Step毎の手順を記載します。

### Step3-1の実行

``` base
$ cd ~/terraform/cntfdemo/main/base/

```

### Step3-2の実行

### Step3-3の実行

### Step3-4の実行

### Step3-5の実行

### 4章に関する手順

### Step4-1の実行

### Step4-2の実行

### Step4-3の実行

### Step4-4の実行
