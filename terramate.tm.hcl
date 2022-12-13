terramate {
  required_version = "~> 0.2.0"

  config {
    git {
      check_untracked   = false
      check_uncommitted = false
      check_remote      = false
    }

    run {
      env {
        TF_PLUGIN_CACHE_DIR = "${terramate.root.path.fs.absolute}/.terraform-cache-dir"
      }
    }
  }
}
