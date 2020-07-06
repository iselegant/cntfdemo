locals {
  codedeploy_prefix               = "AppECS-${var.resource_id}"
  codedeploy_deployment_group_pfx = "DgpECS-${var.resource_id}"
  source_artifact                 = "SourceArtifact"
  build_artifact                  = "BuildArtifact"
}

resource "aws_codepipeline" "app" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      run_order        = 1
      output_artifacts = [local.source_artifact]
      configuration = {
        RepositoryName = var.repo_name
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      run_order        = 2
      input_artifacts  = [local.source_artifact]
      output_artifacts = [local.build_artifact]
      configuration = {
        ProjectName = aws_codebuild_project.app.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name     = "Deploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeployToECS"
      input_artifacts = [
        local.source_artifact,
        local.build_artifact
      ]
      version   = 1
      run_order = 3
      configuration = {
        ApplicationName                = "${local.codedeploy_prefix}-${var.app_name}"
        DeploymentGroupName            = "${local.codedeploy_deployment_group_pfx}-${var.app_name}"
        TaskDefinitionTemplateArtifact = local.source_artifact
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = local.source_artifact
        AppSpecTemplatePath            = "appspec.yaml"
        Image1ArtifactName             = local.build_artifact
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }
}