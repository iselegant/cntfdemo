# 2019年11月のアップデートにより、従来のAWS WAFがAWS WAF Classicへの名称が変更。
# 2020年6月初時点において、AWS WAFはTerraform未対応の状態であり、
# 現在Featureが作成されて対応している状況である。
#
# Ref. https://github.com/terraform-providers/terraform-provider-aws/labels/service%2Fwafv2
#
# 書籍上はAWS WAFにて手順を記載しているが、Terraformでは対応できないため、
# 本ソースコードではAWS WAF Classicによる対応とする。
# なお、AWS WAFがTerraformで対応され次第、本ソースはアップデート予定である。
#
# FIXME: Terraform対応後にAWS WAF Classic -> AWS WAFへの修正

locals {
  wafregional_acl_pfx  = "${var.resource_id}-waf"
  wafregional_rule_pfx = "${local.wafregional_acl_pfx}-rule"

  # format: priority = rule_id
  waf_rules_block = {
    1 = aws_wafregional_rule.sqli.id
    2 = aws_wafregional_rule.xss.id
  }

  waf_rules_allow = {
    3 = aws_wafregional_rule.header.id
  }
}

resource "aws_wafregional_web_acl" "ingress" {
  name = "${local.wafregional_acl_pfx}-webacl"
  # メトリック名にハイフンが利用できないため、以下名前でCloudWatchメトリクス名を定義する
  metric_name = "CnappWAFAcl"

  default_action {
    type = "BLOCK"
  }

  rule {
    priority = 1
    rule_id  = aws_wafregional_rule_group.common.id
    type     = "GROUP"

    override_action {
      type = "NONE"
    }
  }
}

resource "aws_wafregional_web_acl_association" "ingress" {
  resource_arn = aws_lb.public.arn
  web_acl_id   = aws_wafregional_web_acl.ingress.id
}

resource "aws_wafregional_rule_group" "common" {
  name        = "${local.wafregional_rule_pfx}-group"
  metric_name = "CnappWAFRuleGroup"

  dynamic "activated_rule" {
    for_each = local.waf_rules_block

    content {
      action {
        type = "BLOCK"
      }

      priority = activated_rule.key
      rule_id  = activated_rule.value
    }
  }

  dynamic "activated_rule" {
    for_each = local.waf_rules_allow

    content {
      action {
        type = "ALLOW"
      }

      priority = activated_rule.key
      rule_id  = activated_rule.value
    }
  }
}

# SQLインジェクション
resource "aws_wafregional_rule" "sqli" {
  name        = "${local.wafregional_rule_pfx}-sqli"
  metric_name = "SQLInjection"

  predicate {
    data_id = aws_wafregional_sql_injection_match_set.common.id
    negated = false
    type    = "SqlInjectionMatch"
  }

  depends_on = [aws_wafregional_sql_injection_match_set.common]
}

resource "aws_wafregional_sql_injection_match_set" "common" {
  name = "sqli"

  sql_injection_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "URI"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "BODY"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# クロスサイトスクリプティング
resource "aws_wafregional_rule" "xss" {
  name        = "${local.wafregional_rule_pfx}-xss"
  metric_name = "XSS"

  predicate {
    data_id = aws_wafregional_xss_match_set.common.id
    negated = false
    type    = "XssMatch"
  }

  depends_on = [aws_wafregional_xss_match_set.common]
}

resource "aws_wafregional_xss_match_set" "common" {
  name = "xss"

  xss_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "URI"
    }
  }

  xss_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  xss_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "BODY"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# HTTPヘッダー
resource "aws_wafregional_rule" "header" {
  name        = "${local.wafregional_rule_pfx}-header"
  metric_name = "HttpHeaderClientId"

  predicate {
    data_id = aws_wafregional_byte_match_set.header.id
    negated = true
    type    = "ByteMatch"
  }

  depends_on = [aws_wafregional_byte_match_set.header]
}

resource "aws_wafregional_byte_match_set" "header" {
  name = "header"

  # ヘッダ名はAWSに登録される際に自動で小文字変換される。
  # 大文字で実装するすると毎回差分検出されるので、必ず小文字実装とする。
  byte_match_tuples {
    field_to_match {
      type = "HEADER"
      data = "x-${var.resource_id}-id"
    }

    target_string         = var.waf_header_string
    text_transformation   = "NONE"
    positional_constraint = "EXACTLY"
  }

  lifecycle {
    create_before_destroy = true
  }
}
